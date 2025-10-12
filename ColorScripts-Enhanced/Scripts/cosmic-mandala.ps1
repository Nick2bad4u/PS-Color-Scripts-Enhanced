# Unique Concept: Cosmic mandala with planetary orbits and stellar constellations.
# Radial symmetry with orbiting celestial bodies and star formations.

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

$width = 80
$height = 30

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $centerX = $width / 2.0
        $centerY = $height / 2.0
        $dx = $col - $centerX
        $dy = $row - $centerY
        $distance = [math]::Sqrt($dx * $dx + $dy * $dy)
        $angle = [math]::Atan2($dy, $dx)
        if ($angle -lt 0) { $angle += 2 * [math]::PI }

        $normalizedDist = $distance / [math]::Max($centerX, $centerY)
        $sector = [math]::Floor($angle / ([math]::PI / 6)) % 12

        # Orbital rings
        $ring = [math]::Floor($normalizedDist * 5)
        $ringOffset = $normalizedDist * 5 - $ring

        # Planetary positions
        $planetDist = [math]::Abs($normalizedDist - 0.3) + [math]::Abs($normalizedDist - 0.6) + [math]::Abs($normalizedDist - 0.9)
        $planetDist = 1.0 - (Clamp -Value $planetDist -Min 0 -Max 1)

        # Star formations
        $starPattern = [math]::Sin($angle * 8 + $distance * 0.5) * [math]::Cos($angle * 6 + $distance * 0.3)

        $intensity = Clamp -Value ($planetDist * 0.7 + [math]::Abs($starPattern) * 0.3 + (1 - $ringOffset) * 0.2) -Min 0 -Max 1

        $hue = ($sector / 12.0 + 0.1 * [math]::Sin($distance * 2) + 0.05 * $starPattern) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.7 + 0.3 * $intensity) -Min 0.4 -Max 1
        $value = Clamp -Value (0.15 + 0.85 * [math]::Pow($intensity, 0.6)) -Min 0.1 -Max 1

        $symbol =
        if ($intensity -gt 0.9) { '☾' }
        elseif ($intensity -gt 0.7) { '✦' }
        elseif ($intensity -gt 0.5) { '⋆' }
        elseif ($intensity -gt 0.3) { '·' }
        elseif ($normalizedDist -lt 0.1) { '⊙' }
        else { ' ' }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
