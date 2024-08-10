function Read-Dice {
    <#
    .SYNOPSIS
        Reads the dice
    .DESCRIPTION
        Rolls the dice N times and reads the results.
    .LINK
        Get-Dice
    .LINK
        New-Dice    
    #>
    [Alias('Roll-Dice','Roll')]
    param(
    # The number of sides on the dice.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Side','Number')]
    [int]$Sides,

    # The name of the dice.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('DiceName','DieName')]
    [string]$Name,
    
    # The number of rolls of the dice.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Rolls','Roll')]
    [int]$RollCount = 1
    )
    
    process {
        $diceToRoll = if ($name) {
            $dice.DB.Tables['Dice'].Select("Name = '$name'")
        } elseif ($sides) {
            (New-Dice -Sides $sides)
        } else {
            $dice.DB.Tables['Dice'].Rows
        }

        if (-not $diceToRoll) {
            Write-Error "No dice found with Name '$Name'"
            return
        }
                        
        foreach ($rollTheDice in $diceToRoll) {
            [PSCustomObject]@{
                PSTypeName = 'Dice.Rolls'
                Rolls = $(
                    foreach ($n in 1..$rollCount) {
                        $rollTheDice.Roll()
                    }
                )
            }            
        }        
    }    
}

