<#
.SYNOPSIS
    Rolls the dice.
.DESCRIPTION
    Rolls a dice any number of sides any number of times.
#>
param(
# The number of sides on the dice.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Side','Number')]
[int]$Sides,

# The number of rolls of the dice.
[Alias('Rolls','Roll')]
[int]$RollCount = 1
)



if ($sides) {
    $thisDiceExists = @($dice.DB.Tables["Dice"].Select("Sides = $sides"))
    if (-not $thisDiceExists) {
        $thisDiceExists = (New-Dice -Sides $sides)
    }
    foreach ($n in 1..$rollCount) {
        $thisDiceExists.Roll()
    }                
    continue
}

if (-not $this.Sides) {
    foreach ($die in $dice.DB.Tables['Dice']) {
        foreach ($n in 1..$rollCount) {
            $die.Roll() 
        }            
    }
} else {        
    $rollTable = $dice.DB.Tables[$this.Name]
    foreach ($n in 1..$rollCount) {
        $diceRoll = $rollTable.NewRow()
        $diceRoll.Sides = $this.Sides
        $diceRoll.Roll = (Get-Random -Minimum 1 -Maximum ($this.Sides + 1)) -as [double]
        $rollTable.Rows.Add($diceRoll)
        $diceRoll.pstypenames.insert(0,'Dice.Roll')
        $diceRoll
    }        
}