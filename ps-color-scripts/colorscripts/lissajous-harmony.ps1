# Unique Concept: Lissajous curves with varying frequency ratios creating intricate harmonic patterns.
# Parametric equations x = A*sin(at + δ), y = B*sin(bt) with different phase relationships.

# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$ErrorActionPreference = 'Stop'
$esc = [char]27
$reset = "$esc[0m"

function Convert-HsvToRgb {
    param([double]$Hue, [double]$Saturation, [double]$Value)
    $h = ($Hue % 1) * 6
    $sector = [math]::Floor($h)
    $fraction = $h - $sector
    $p = $Value * (1 - $Saturation)
    $q = $Value * (1 - $fraction * $Saturation)
    $t = $Value * (1 - (1 - $fraction) * $Saturation)
    switch ($sector) {
        0 { $r = $Value; $g = $t; $b = $p }
        1 { $r = $q; $g = $Value; $b = $p }
        2 { $r = $p; $g = $Value; $b = $t }
        3 { $r = $p; $g = $q; $b = $Value }
        4 { $r = $t; $g = $p; $b = $Value }
        default { $r = $Value; $g = $p; $b = $q }
    }
    return @([int][math]::Round($r * 255), [int][math]::Round($g * 255), [int][math]::Round($b * 255))
}

$width = 100
$height = 26

# Multiple Lissajous curves with different frequency ratios
$curves = @(
    @{ A = 45; B = 11; FreqA = 3; FreqB = 4; Phase = 0.0; Hue = 0.0 },
    @{ A = 45; B = 11; FreqA = 5; FreqB = 6; Phase = 1.57; Hue = 0.33 },
    @{ A = 45; B = 11; FreqA = 7; FreqB = 8; Phase = 0.78; Hue = 0.66 }
)

$grid = @{}
$time = ([DateTime]::Now.Ticks / 10000000.0) % 60

foreach ($curve in $curves) {
    $steps = 1200
    for ($i = 0; $i -lt $steps; $i++) {
        $t = ($i / [double]$steps) * 2 * [math]::PI

        $x = $curve.A * [math]::Sin($curve.FreqA * $t + $curve.Phase + $time * 0.1)
        $y = $curve.B * [math]::Sin($curve.FreqB * $t)

        $px = [int]($x + 50)
        $py = [int]($y + 13)

        if ($px -ge 0 -and $px -lt $width -and $py -ge 0 -and $py -lt $height) {
            $key = "$px,$py"
            $progress = $i / [double]$steps

            if ($grid.ContainsKey($key)) {
                $grid[$key].Count++
                $grid[$key].Hues += $curve.Hue
            }
            else {
                $grid[$key] = @{
                    Count    = 1
                    Hues     = $curve.Hue
                    Progress = $progress
                }
            }
        }
    }
}

# Render
for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]

            $avgHue = $cell.Hues / $cell.Count
            $hue = ($avgHue + $cell.Progress * 0.2) % 1
            $saturation = 0.7 + 0.25 * ($cell.Count / 3.0)
            if ($saturation -gt 1.0) { $saturation = 1.0 }
            $value = 0.5 + 0.45 * ($cell.Count / 3.0)
            if ($value -gt 1.0) { $value = 1.0 }

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            $symbol = if ($cell.Count -gt 2) { '◉' }
            elseif ($cell.Count -gt 1) { '●' }
            else { '∙' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
