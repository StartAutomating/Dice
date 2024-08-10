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
        # If the name is provided, we will search for the dice by name.
        if ($name) {
            $foundDice = $dice.DB.Tables['Dice'].Select("Name = '$name'")
            if ($foundDice) {
                $foundDice
            } else {
                # If the dice is not found, write an error
                # (since we can't presume a number of sides)
                Write-Error "Dice '$name' not found."
                return
            }
        }
        # If the sides are provided, we will search for the dice by sides.
        elseif ($side)
        {
            $foundDice = $dice.DB.Tables['Dice'].Select("Sides = $side")
            if ($foundDice) {
                $foundDice
            } else {
                # If the dice is not found, create a new dice with the given sides.
                New-Dice -Sides $side
            }
        }
        # If neither the name nor the sides are provided, we will return all dice.
        else
        {
            $dice.DB.Tables['Dice']
        }
    }    
}