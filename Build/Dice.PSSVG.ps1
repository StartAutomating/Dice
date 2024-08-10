#requires -Module PSSVG
Push-Location ($psScriptRoot | Split-Path)
$powerShellChevron = Invoke-RestMethod https://pssvg.start-automating.com/Examples/PowerShellChevron.svg   
$assetsPath = Join-Path $pwd Assets
$scaleMax = 1.02


$FontSplat = [Ordered]@{
    FontFamily = "sans-serif" 
}

$φ = (1.0 + [Math]::Sqrt(5))/2
$scaleMin = 1
$AnimateSplat = [Ordered]@{
    Dur = 60/128*4
    AttributeName = 'font-size'
    Values = "${scaleMin}em;${scaleMax}em;${scaleMin}em"
    RepeatCount = 'indefinite'
}

if (-not (Test-path $assetsPath)) {
    $null = New-Item -ItemType Directory -Path $assetsPath -Force
}


foreach ($variant in '') {
svg @(
    SVG.GoogleFont -FontName $FontName    
    svg.symbol -ViewBox $powerShellChevron.svg.viewBox -Content $powerShellChevron.svg.symbol.InnerXml -Id psChevron 
    
    svg.use -href '#psChevron'  -X '48%' -Y '-2.75%' -Width '10%' -Stroke '#4488ff' -Fill '#4488ff'
    svg.text @(
        svg.tspan "DICE" -FontSize "${scaleMin}em"        
    ) -FontSize 3em -Fill '#4488ff' -X 50% -DominantBaseline 'middle' -TextAnchor 'middle' -Y 50% @FontSplat
    svg.text  @(
        svg.tspan "⚀" -Children -FontSize "${scaleMin}em" -Dx '-0.1em'
        svg.tspan "⚁" -Children -FontSize "${scaleMin}em" -Dx '-0.1em'
        svg.tspan "⚂" -Children -FontSize "${scaleMin}em" -Dx '-0.1em'
        svg.tspan "⚃" -Children -FontSize "${scaleMin}em" -Dx '-0.1em'
        svg.tspan "⚄" -Children -FontSize "${scaleMin}em" -Dx '-0.1em'
        svg.tspan "⚅" -Children -FontSize "${scaleMin}em" -Dx '-0.1em'
    ) -FontSize 2em -Fill '#4488ff' -X 50% -DominantBaseline 'middle' -TextAnchor 'middle' -Y 66% @FontSplat    
) -ViewBox 300, ([Math]::Floor(300 / $φ)) -OutputPath (Join-Path $assetsPath "Dice$(if ($variant){"-$($variant)"}).svg")
}

Pop-Location
