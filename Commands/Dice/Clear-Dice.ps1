function Clear-Dice {
    <#
    .SYNOPSIS
        Clears the dice.
    .DESCRIPTION
        Clears the dice, removing all the rolls.
    .LINK
        Get-Dice
    .LINK
        New-Dice
    .LINK
        Read-Dice
    #>
    param(
    # The number of sides on the dice.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Side','Number')]
    [int]$Sides
    )

    process {
        if ($sides) {            
            $diceFound = $dice.DB.Tables['Dice'].Select("Sides = $sides")
            foreach ($foundDice in $diceFound) {
                Write-Warning "Clearing dice with $sides sides."
                $foundDice.RollTable.Clear()
            }
        } else {
            Write-Warning "Clearing all dice."
            foreach ($foundDice in Get-Dice) {
                $foundDice.RollTable.Clear()
            }
        }
    }
}