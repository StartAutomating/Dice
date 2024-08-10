function Get-Dice {
    <#
    .SYNOPSIS
        Gets the dice.
    .DESCRIPTION
        Get-Dice retrieves dice objects from the dice database.
    .EXAMPLE
        Get-Dice        
    .EXAMPLE
        dice
    #>
    param(
    # The name of the dice.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('DiceName','DieName')]
    [string]$Name,

    # The number of sides on the dice.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Sides')]
    [int]$Side
    )
        
    process {
        if ($name) {
            $foundDice = $dice.DB.Tables['Dice'].Select("Name = '$name'")
            if ($foundDice) {
                $foundDice
            } else {
                Write-Error "Dice '$name' not found."
                return
            }
        } elseif ($side) {
            $foundDice = $dice.DB.Tables['Dice'].Select("Sides = $side")
            if ($foundDice) {
                $foundDice
            } else {
                New-Dice -Sides $side
            }
        } else {
            $dice.DB.Tables['Dice']
        }
    }    
}