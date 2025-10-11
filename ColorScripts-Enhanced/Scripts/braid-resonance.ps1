# Unique Concept: Triple-phase resonance braids intertwining sinusoidal bands with dominance-driven glyph swaps.


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

$width = 104
$height = 36

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $u = $col / [double]($width - 1)
        $v = $row / [double]($height - 1)

        $phaseA = 2.0 * [math]::PI * (2.1 * $u + 0.3 * [math]::Sin(2.0 * [math]::PI * $v))
        $phaseB = 2.0 * [math]::PI * (2.1 * $v + 0.28 * [math]::Cos(2.0 * [math]::PI * $u))
        $phaseC = 2.0 * [math]::PI * (1.5 * ($u + $v) + 0.22 * [math]::Sin(2.0 * [math]::PI * ($u - $v)))

        $braidA = [math]::Sin($phaseA)
        $braidB = [math]::Sin($phaseB)
        $braidC = [math]::Sin($phaseC)

        $dominant = 'A'
        $maxVal = [math]::Abs($braidA)
        if ([math]::Abs($braidB) -gt $maxVal) {
            $dominant = 'B'
            $maxVal = [math]::Abs($braidB)
        }
        if ([math]::Abs($braidC) -gt $maxVal) {
            $dominant = 'C'
            $maxVal = [math]::Abs($braidC)
        }

        $cross = $braidA * $braidB * $braidC
        $blend = ($braidA + $braidB + $braidC) / 3.0

        $symbol = switch ($dominant) {
            'A' {
                if ($braidA -ge 0) { if ($cross -gt 0) { '╳' } else { '╱' } }
                else { if ($cross -gt 0) { '╳' } else { '╲' } }
            }
            'B' {
                if ($braidB -ge 0) { '━' } else { '┅' }
            }
            default {
                if ($braidC -ge 0) { '┃' } else { '┇' }
            }
        }

        if ($maxVal -lt 0.25) { $symbol = '·' }

        $hue = (0.62 + 0.2 * $braidA + 0.15 * $braidB + 0.12 * [math]::Sin($phaseC * 0.5)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.46 + 0.4 * $maxVal + 0.1 * $blend) -Min 0 -Max 1
        $value = Clamp -Value (0.24 + 0.62 * [math]::Pow($maxVal, 0.7) + 0.12 * [math]::Sin($cross * 6)) -Min 0.2 -Max 1

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
