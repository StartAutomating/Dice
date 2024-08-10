function New-Dice
{
    <#
    .SYNOPSIS
        Creates a new dice.
    .DESCRIPTION
        Creates a new dice, or returns an existing dice.
    .NOTES
        A dice is a simple table that represents a die.
        
        The table has a column for the roll number, the roll result, and the number of sides on the die.

        By describing a dice in a table, we can easily roll the dice, and keep track of the results.
    #>
    param(
    # The number of sides on the die.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateRange(2, [int]::MaxValue/2)]
    [Alias('Side','SideCount')]
    [int]
    $Sides = 2,
    
    # The name of the die.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('DiceName','DieName')]
    [string]
    $Name,

    # The faces of the die.  Each face is a string that will can be displayed when the die is rolled.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Faces')]
    [string[]]
    $Face
    )
        
    process {
        # If the name is not provided, we will usually default to the number of sides.
        if (-not $name) {
            $name = switch ($sides) {
                # Special cases for coins and six-sided dice.
                2 { 'coin' }
                6 { 'Six-Sided-Dice' }
                default { "d$Sides" }
            }            
        }
    
        # Check if the dice already exists by querying the dice table.
        $diceExists = $dice.DB.Tables['Dice'].Select("Sides = $sides")
        
        # If the dice does not exist, create a new dice.
        if (-not $diceExists) {
            $diceRoll = $dice.DB.Tables.Add($Name)
            $diceRoll.Columns.AddRange(@(
                # The roll number is an auto-incrementing number.
                $rollNumber = [Data.DataColumn]::new('N', [double], '', 'Attribute')
                $rollNumber.AutoIncrementSeed = 1
                $rollNumber.AutoIncrement = $true
                $rollNumber.ReadOnly = $true
                $rollNumber
                # The roll result is a double.
                [Data.DataColumn]::new('Roll', [double], '', 'Attribute')
                # The number of sides is an int, and it is hidden from serialization.
                [Data.DataColumn]::new('Sides', [int], '', 'Hidden')
            ))
            # The roll number is the primary key.
            $diceRoll.PrimaryKey = @($diceRoll.Columns['N'])
            # Create a relationship between the dice and the dice roll.
            $diceRelationship = $dice.DB.Relations.Add(
                    "DiceRoll$Name", 
                    $dice.DB.Tables['Dice'].Columns['Sides'], 
                    $diceRoll.Columns['Sides']
            )
            # nest the relationship, so that any generated content nests as well.
            $diceRelationship.Nested = $true
            # Set the default value for the sides column to the number of sides
            $diceRoll.Columns['Sides'].DefaultValue = $diceRow.Sides
            $diceRoll.Columns['Sides'].ReadOnly = $true
            # 'decorate' the dice with type typename 'Dice'
            $diceRoll.pstypenames.insert(0,'Dice')
            # If faces are provided, add them to the dice table.
            if ($Face) {
                # as the extended properties.
                $diceRoll.ExtendedProperties.Add('Faces', $Face)
            }
            # Add the new dice to the dice table.
            $newDice = $dice.DB.Tables['Dice'].Rows.Add($Name, $Sides)
            # 'decorate' the dice with type typename 'Dice'
            $newDice.pstypenames.insert(0,'Dice')
            # Return the new dice.
            $newDice
        } else {
            # If the dice already exists, return the existing dice.
            # Since it has already been decorated, it will have the 'Dice' type typename.            
            $diceExists
        }
    }
}
