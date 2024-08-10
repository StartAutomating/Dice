@{
    ModuleVersion = '0.1'
    RootModule = 'Dice.psm1'
    TypesToProcess = 'Dice.types.ps1xml'
    FormatsToProcess = 'Dice.format.ps1xml'
    Guid = 'db4a1b20-1e58-408b-837c-6b4d8eecffd0'
    CompanyName = 'Start-Automating'
    Author = 'James Brundage'
    Copyright = '2024 Start-Automating'
    Description = 'Roll the Dice and Play with Probability in PowerShell - ⚀ ⚅'

    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/Dice'
            LicenseURI = 'https://github.com/StartAutomating/Dice/blob/main/LICENSE'
            Tags = 'Dice', 'PowerShell', 'Probability', 'Random'
            ReleaseNotes = @'
## 0.1

* Initial release
  * Core Commands
    * Get-Dice gets dice
    * New-Dice creates dice
    * Read-Dice rolls dice
    * Clear-Dice clears dice  
* Core Types
  * Dice
  * Dice.Roll
  * Dice.Rolls
* Dockerfile and Microservice
'@
        }
    }
}