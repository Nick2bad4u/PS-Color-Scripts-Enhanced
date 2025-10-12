# Unique Concept: Quantum entanglement visualization with interconnected particle states.
# Superposition patterns with probabilistic wave functions and entanglement links.

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

function Clamp {
    param(
        [double]$Value,
        [double]$Min,
        [double]$Max
    )

    if ($Value -lt $Min) { return $Min }
    if ($Value -gt $Max) { return $Max }
    return $Value
}

$width = 100
$height = 30
$particles = @(
    @{ X = 20; Y = 10; Hue = 0.0 },
    @{ X = 50; Y = 15; Hue = 0.2 },
    @{ X = 80; Y = 20; Hue = 0.4 },
    @{ X = 30; Y = 25; Hue = 0.6 },
    @{ X = 70; Y = 5; Hue = 0.8 }
)

$grid = @{}

# Calculate entanglement probabilities
foreach ($p1 in $particles) {
    foreach ($p2 in $particles) {
        if ($p1 -ne $p2) {
            $dx = $p2.X - $p1.X
            $dy = $p2.Y - $p1.Y
            $dist = [math]::Sqrt($dx * $dx + $dy * $dy)
            $entanglement = [math]::Exp(-$dist / 20.0)

            $steps = [int]$dist
            for ($i = 0; $i -le $steps; $i++) {
                $t = $i / [double]$steps
                $x = [int]($p1.X + $dx * $t)
                $y = [int]($p1.Y + $dy * $t)

                if ($x -ge 0 -and $x -lt $width -and $y -ge 0 -and $y -lt $height) {
                    $key = "$x,$y"
                    $prob = $entanglement * (1 - $t * 0.5)

                    if ($grid.ContainsKey($key)) {
                        $grid[$key].Prob += $prob
                        $grid[$key].Hues += ($p1.Hue + $p2.Hue) / 2
                        $grid[$key].Count++
                    }
                    else {
                        $grid[$key] = @{
                            Prob  = $prob
                            Hues  = ($p1.Hue + $p2.Hue) / 2
                            Count = 1
                        }
                    }
                }
            }
        }
    }
}

# Add particle cores
foreach ($p in $particles) {
    $key = "$($p.X),$($p.Y)"
    if ($grid.ContainsKey($key)) {
        $grid[$key].Prob += 2.0
        $grid[$key].Hues += $p.Hue
        $grid[$key].Count++
    }
    else {
        $grid[$key] = @{
            Prob  = 2.0
            Hues  = $p.Hue
            Count = 1
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
            $intensity = Clamp -Value ($cell.Prob / 3.0) -Min 0 -Max 1

            $hue = ($avgHue + 0.1 * [math]::Sin($col * 0.1 + $row * 0.1)) % 1
            $saturation = Clamp -Value (0.8 + 0.2 * $intensity) -Min 0.5 -Max 1
            $value = Clamp -Value (0.2 + 0.8 * [math]::Pow($intensity, 0.5)) -Min 0.1 -Max 1

            $symbol =
            if ($intensity -gt 0.8) { '◎' }
            elseif ($intensity -gt 0.6) { '◉' }
            elseif ($intensity -gt 0.4) { '●' }
            elseif ($intensity -gt 0.2) { '◦' }
            else { '·' }

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;5;5;15m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
