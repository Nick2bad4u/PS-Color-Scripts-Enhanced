# Unique Concept: Psychedelic vortex with swirling patterns and hippie color transitions.
# Hypnotic spiral vortex with color-shifting waves and fractal-like depth.

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

        # Spiral vortex
        $spiral = [math]::Log($distance + 1) * 0.8 + $angle * 3

        # Psychedelic waves
        $wave1 = [math]::Sin($spiral) * [math]::Cos($angle * 4)
        $wave2 = [math]::Sin($spiral * 1.5 + 1) * [math]::Sin($angle * 6)
        $wave3 = [math]::Sin($spiral * 0.7 + 2) * [math]::Cos($angle * 2)

        $vortexIntensity = Clamp -Value ([math]::Abs($wave1 + $wave2 + $wave3) / 3.0) -Min 0 -Max 1

        $hue = (0.5 + 0.5 * [math]::Sin($spiral * 0.5 + $angle * 2) + 0.2 * [math]::Cos($normalizedDist * 8)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.8 + 0.2 * $vortexIntensity) -Min 0.6 -Max 1
        $value = Clamp -Value (0.2 + 0.8 * [math]::Pow($vortexIntensity, 0.7)) -Min 0.1 -Max 1

        $symbol =
        if ($vortexIntensity -gt 0.8) { '◎' }
        elseif ($vortexIntensity -gt 0.6) { '◉' }
        elseif ($vortexIntensity -gt 0.4) { '●' }
        elseif ($vortexIntensity -gt 0.2) { '◦' }
        else { '·' }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
