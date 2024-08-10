describe Dice {
    it 'Is a little module to play with probability.' {
        $dice -is [Management.Automation.PSModuleInfo] | Should -Be $true
    }

    it 'Is takes no time for a computer to flip a coin 10kb times.' {
        Measure-Command { 
             Read-Dice -Sides 2 -RollCount 10kb
        } | 
        Select-Object -ExpandProperty TotalSeconds | 
        Should -BeLessThan 5 # It should be a lot less than 5 seconds,
        # but we'll give it a little wiggle room.
    }

    it 'Can measure the variance correctly' {
        $coin = Get-Dice -Side 2
        [Math]::Sqrt($coin.Variance) | Should -Be $coin.StandardDeviation
    }

    it 'Can prove rolling 20 is lucky' {
        Read-Dice -Sides 20 -RollCount 10kb |
            Select-Object -ExpandProperty Rolls |
            Where-Object Roll -EQ 20 |
            Select-Object -ExpandProperty StandardUnit |
            Should -BeGreaterThan 1.5
    }

    it 'Can clear the dice' {
        Clear-Dice
        foreach ($foundDice in Get-Dice) {
            $foundDice.RollTable.Rows.Count | Should -Be 0
        }
    }
}
