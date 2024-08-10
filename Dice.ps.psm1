$commandsPath = Join-Path $PSScriptRoot .\Commands
[include('*-*')]$commandsPath

$myModule = $MyInvocation.MyCommand.ScriptBlock.Module
$ExecutionContext.SessionState.PSVariable.Set($myModule.Name, $myModule)
$myModule.pstypenames.insert(0, $myModule.Name)

New-PSDrive -Name $MyModule.Name -PSProvider FileSystem -Scope Global -Root $PSScriptRoot -ErrorAction Ignore

# Set a script variable of this, set to the module
# (so all scripts in this scope default to `$this` module)
$script:this = $myModule

Export-ModuleMember -Alias * -Function * -Variable $myModule.Name