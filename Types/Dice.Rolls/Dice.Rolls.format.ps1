Write-FormatView -TypeName Dice.Rolls -Action {
    $thisRoll = $_
    
    if ($request -is [Net.HttpListenerRequest]) {
        @"
<!DOCTYPE html>
<html>
    <title>$([Web.HttpUtility]::htmlEncode($Request.Url))</title>
    <style>html, body { font-size: 2em; height:100% }</style>
    <body>
        <svg width="100%" height="100%" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg">
            <text x='50%' y='50%' fill='currentColor' text-anchor='middle' alignment-baseline='middle'>$(                
                foreach ($roll in $thisRoll.Rolls) {
                    if ($roll.Face) { [Web.HttpUtility]::htmlEncode("$($roll.Face)") } else { "$($roll.Roll)" }
                }                
            )</text>
        </svg>
    </body>
</html>        
"@
        
    } else {
        @(foreach ($roll in $thisRoll.Rolls) {
            if ($roll.Face) { "$($roll.Face)" } else { "$($roll.Roll) / $($roll.Sides)" }
        }) -join ' '           
    }
}

Write-FormatView -TypeName Dice.Rolls -Action {
    @(foreach ($roll in $thisRoll.Rolls) {
        $roll.Roll
    }) -join [Environment]::NewLine
} -Name Number