param()


# If $dice is a PSModuleInfo object and it does not have a '.DB' property,
if ($dice -is [Management.Automation.PSModuleInfo] -and (-not $dice.'.DB')) {
    # then create a new DataSet object named 'Dice'.    
    $diceDB = [Data.DataSet]::new('Dice')
    $dice.psobject.properties.add([psnoteproperty]::new('.DB', $diceDB), $true)
    # Create a new DataTable object named 'Dice' and add it to the DataSet object.
    $diceTable = $diceDB.Tables.Add('Dice')
    # A dice will have a name and a number of sides.
    $diceTable.Columns.AddRange(@(
        [Data.DataColumn]::new('Name', [string], '', 'Attribute')
        [Data.DataColumn]::new('Sides', [int], '', 'Attribute')
    ))
    
    # The sides of a dice will be the primary key.
    $diceTable.PrimaryKey = @($diceTable.Columns['Sides'])
    # The chance of rolling a side will be 1 divided by the number of sides,
    # and will be calculated using an expression property.
    $chanceColumn = $diceTable.Columns.Add('Chance', [double], '1/Sides')    
    $chanceColumn.ColumnMapping = 'Attribute'    
    
    # Create a few dice objects.
    $null = @(
        New-Dice -Name 'coin' -Sides 2 # -Face '🦸','🦹'       
        New-Dice -Name 'Six-Sided-Dice' -Sides 6 # -Faces '⚀','⚁','⚂','⚃','⚄','⚅'        
        New-Dice -Name 'D20' -Sides 20
    )
    # Accept the changes to the Dice Table.
    $diceTable.AcceptChanges()
}
# Return the Dice Database (all of the code above should only run once per module load).
return $dice.'.DB'


