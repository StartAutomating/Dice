$commandsPath = Join-Path $PSScriptRoot .\Commands
:ToIncludeFiles foreach ($file in (Get-ChildItem -Path "$commandsPath" -Filter "*-*" -Recurse)) {
    if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    foreach ($exclusion in '\.[^\.]+\.ps1$') {
        if (-not $exclusion) { continue }
        if ($file.Name -match $exclusion) {
            continue ToIncludeFiles  # Skip excluded files
        }
    }     
    . $file.FullName
}

$myModule = $MyInvocation.MyCommand.ScriptBlock.Module
$ExecutionContext.SessionState.PSVariable.Set($myModule.Name, $myModule)
$myModule.pstypenames.insert(0, $myModule.Name)

New-PSDrive -Name $MyModule.Name -PSProvider FileSystem -Scope Global -Root $PSScriptRoot -ErrorAction Ignore

if ($home) {
    $MyModuleUserDirectory = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) $MyModule.Name    
    if (-not (Test-Path $MyModuleUserDirectory)) {
        $null = New-Item -ItemType Directory -Path $MyModuleUserDirectory -Force
    }
    New-PSDrive -Name "My$($MyModule.Name)" -PSProvider FileSystem -Scope Global -Root $MyModuleUserDirectory -ErrorAction Ignore
}


$KnownVerbs = Get-Verb | 
    Sort-Object @{
        Expression={$_.Verb.Length}
    }, @{
        Expression={ $_.Verb};Descending=$false
    } -Descending | 
    Select-Object -ExpandProperty Verb

$DoNotExportTypes = @('^System\.', 'Collection$')
$DoNotExportMembers = @('\.format','^Import\.', '^To\.','^From\.')

# Set a script variable of this, set to the module
# (so all scripts in this scope default to the correct `$this`)
$script:this = $myModule


$myScriptTypes = Get-ChildItem -Path ($myModule | Split-Path) -Filter *.types.ps1xml | Select-Xml -Path { $_ } -XPath //Type
$myTypesTable = [Data.DataTable]::new('TypeData')
$myTypesTable.Columns.AddRange(@(
    [Data.DataColumn]::new('TypeName', [string], '', 'Attribute'),
    [Data.DataColumn]::new('MemberName', [string], '', 'Attribute')
    $exportColumn = [Data.DataColumn]::new('Export', [bool], '', 'Attribute')
    $exportColumn.DefaultValue = $true
    $exportColumn
    [Data.DataColumn]::new('Member', [object])
))

$myScriptTypeData = Get-TypeData -TypeName @($myScriptTypes.Node.Name)
foreach ($myTypeData in $myScriptTypeData) {    
    if (-not $myTypeData.Members) { continue }
    foreach ($myMember in $myTypeData.Members.GetEnumerator()) {
        $newTypeRow = $myTypesTable.NewRow()
        $newTypeRow.TypeName = $myTypeData.TypeName
        $newTypeRow.MemberName = $myMember.Key
        $newTypeRow.Member = $myMember.Value
        
        :NotExported do {
            if ($newTypeRow.Member -is [Management.Automation.Runspaces.ScriptPropertyData]) {
                $newTypeRow.Export = $false
                break NotExported
            }
            if ($newTypeRow.Member -is [Management.Automation.Runspaces.AliasPropertyData] -and 
                ($myTypeData.Members[$newTypeRow.Member.ReferencedMemberName] -isnot [Management.Automation.Runspaces.ScriptMethodData])
            ) {
                $newTypeRow.Export = $false
                break NotExported
            }
            foreach ($notMatch in $DoNotExportTypes) {
                if ($newTypeRow.TypeName -match $notMatch) { 
                    $newTypeRow.Export = $false
                    break NotExported
                }
            }
            foreach ($notMatch in $DoNotExportMembers) {
                if ($myMember.Key -match $notMatch) { 
                    $newTypeRow.Export = $false
                    break NotExported
                }
            }
        } while ($false)
        
        $null = $myTypesTable.Rows.Add($newTypeRow)
    }    
}
$myTypesTable.AcceptChanges()
$startsWithKnownVerb = [regex]::new("^(?>$(@($KnownVerbs -join '|')))", 'IgnoreCase', '00:00:00.01')

$myScriptTypeCommands = foreach ($myScriptMember in $myTypesTable.Select("Export = 'True'")) {
    $myScriptType = $myScriptMember.TypeName
    $myMemberName = $myScriptMember.MemberName
    $myMember = $myScriptMember.Member
    if ($myMember -is [Management.Automation.Runspaces.ScriptMethodData]) {
        $myFunctionName = 
            if ($myMemberName -match $startsWithKnownVerb) {
                "$($matches.0)-$($myScriptType)$($myMemberName -replace $startsWithKnownVerb)" -replace '[\._]',''
            }            
            else {
                "$($myScriptType).$($myMemberName)"
            }
        # Declare My Function
        "function $myFunctionName {"
        "$($myMember.Script)"
        "}"
        if ($myMemberName -in $KnownVerbs -or $myMemberName -in 'To','From') {
            # Alias it if it's a known verb, so both verb and noun form are available.
            "Set-Alias -Name '$($myScriptType).$($myMemberName)' -Value '$myFunctionName'"            
        }
        
        "Set-Alias -Name '$($myMemberName).$($myScriptType)' -Value '$myFunctionName'"
    }            
}

. ([ScriptBlock]::Create($myScriptTypeCommands -join [Environment]::NewLine))

Export-ModuleMember -Alias * -Function * -Variable $myModule.Name
