#require -Module HelpOut
Push-Location ($PSScriptRoot | Split-Path)

$DiceLoaded = Get-Module Dice
if (-not $DiceLoaded) {
    $DiceLoaded = Get-ChildItem -Recurse -Filter "*.psd1" | Where-Object Name -like 'Dice*' | Import-Module -Name { $_.FullName } -Force -PassThru
}
if ($DiceLoaded) {
    "::notice title=ModuleLoaded::Dice Loaded" | Out-Host
} else {
    "::error:: Dice not loaded" |Out-Host
}

Save-MarkdownHelp -Module Dice -SkipCommandType Alias -PassThru 

Pop-Location