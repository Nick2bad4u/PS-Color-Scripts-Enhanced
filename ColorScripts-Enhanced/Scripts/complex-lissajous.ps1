# Unique Concept: Complex Lissajous figures with multiple frequency ratios, phase relationships, and harmonic overtones.

$ErrorActionPreference = 'Stop'
$esc = [char]27
$reset = "$esc[0m"

function Convert-HsvToRgb {
    param(
        [double]$Hue,
        [double]$Saturation,
        [double]$Value
    )

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

$width = 120
$height = 30
$time = ([DateTime]::Now.Ticks / 10000000.0) % 60

# Complex Lissajous curves with multiple harmonics
$harmonics = @(
    @{ FreqX = 3; FreqY = 4; PhaseX = 0.0; PhaseY = 0.0; Amplitude = 12; Hue = 0.0; OffsetX = 0; OffsetY = 0 },
    @{ FreqX = 5; FreqY = 6; PhaseX = 1.57; PhaseY = 0.78; Amplitude = 10; Hue = 0.2; OffsetX = 0; OffsetY = 0 },
    @{ FreqX = 7; FreqY = 8; PhaseX = 0.5; PhaseY = 1.2; Amplitude = 8; Hue = 0.4; OffsetX = 0; OffsetY = 0 },
    @{ FreqX = 9; FreqY = 11; PhaseX = 2.1; PhaseY = 0.3; Amplitude = 6; Hue = 0.6; OffsetX = 0; OffsetY = 0 },
    @{ FreqX = 13; FreqY = 15; PhaseX = 1.8; PhaseY = 2.4; Amplitude = 4; Hue = 0.8; OffsetX = 0; OffsetY = 0 }
)

$grid = @{}
$maxSteps = 2000

foreach ($harmonic in $harmonics) {
    $steps = $maxSteps
    for ($i = 0; $i -lt $steps; $i++) {
        $t = ($i / [double]$steps) * 4 * [math]::PI + $time * 0.1

        $x = $harmonic.Amplitude * [math]::Sin($harmonic.FreqX * $t + $harmonic.PhaseX)
        $y = $harmonic.Amplitude * [math]::Sin($harmonic.FreqY * $t + $harmonic.PhaseY)

        $px = [int]($x + $width / 2 + $harmonic.OffsetX)
        $py = [int]($y + $height / 2 + $harmonic.OffsetY)

        if ($px -ge 0 -and $px -lt $width -and $py -ge 0 -and $py -lt $height) {
            $key = "$px,$py"
            $progress = $i / [double]$steps

            if (-not $grid.ContainsKey($key)) {
                $grid[$key] = @{
                    Count     = 0
                    Hues      = @()
                    Harmonics = @()
                    Progress  = $progress
                }
            }

            $grid[$key].Count++
            $grid[$key].Hues += $harmonic.Hue
            $grid[$key].Harmonics += $harmonic
        }
    }
}

# Render with harmonic complexity
for ($y = 0; $y -lt $height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        $key = "$x,$y"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]

            # Complex harmonic mixing
            $avgHue = 0
            $totalWeight = 0
            foreach ($hue in $cell.Hues) {
                $weight = 1.0 / (1.0 + [math]::Abs($hue - 0.5))  # Prefer middle hues
                $avgHue += $hue * $weight
                $totalWeight += $weight
            }
            $avgHue /= $totalWeight

            $hue = ($avgHue + $cell.Progress * 0.1) % 1
            $saturation = 0.6 + 0.4 * ([math]::Min($cell.Count / 5.0, 1.0))
            $value = 0.4 + 0.6 * ([math]::Min($cell.Count / 3.0, 1.0))

            # Add harmonic complexity visualization
            $complexity = $cell.Harmonics.Count
            if ($complexity -gt 1) {
                $hue = ($hue + 0.1 * $complexity) % 1
                $saturation = [math]::Min(1.0, $saturation + 0.1 * $complexity)
            }

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            # Symbol based on harmonic density
            $symbols = @('·', '◦', '●', '◉', '◎', '◆', '◇', '◈')
            $symbolIndex = [math]::Min([int]($cell.Count / 2), 7)
            $symbol = $symbols[$symbolIndex]

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;3;3;10m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
