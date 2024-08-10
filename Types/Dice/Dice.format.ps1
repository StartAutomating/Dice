Write-FormatView -TypeName Dice -Property Name, Sides, Chance -FormatProperty @{
    Name = 'Name'
    Sides = 'Sides'
    Chance = '{0:p}'
} -VirtualProperty @{
    Sides = {
        if ($_.Sides) {
            $_.Sides
        } else {
            [double]::PositiveInfinity           
        }
    }    
}