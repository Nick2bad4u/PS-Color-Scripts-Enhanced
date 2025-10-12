# Unique Concept: Galactic spiral arms with stellar nurseries and cosmic dust lanes.
# Logarithmic spiral galaxy with multiple arms, star clusters, and nebular regions.

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

        # Spiral arms
        $spiral1 = [math]::Log($distance + 1) * 0.5 + $angle * 2.5
        $spiral2 = [math]::Log($distance + 1) * 0.5 + ($angle + [math]::PI) * 2.5
        $spiral3 = [math]::Log($distance + 1) * 0.5 + ($angle + [math]::PI * 2 / 3) * 2.5
        $spiral4 = [math]::Log($distance + 1) * 0.5 + ($angle + [math]::PI * 4 / 3) * 2.5

        $armDensity1 = [math]::Abs([math]::Sin($spiral1))
        $armDensity2 = [math]::Abs([math]::Sin($spiral2))
        $armDensity3 = [math]::Abs([math]::Sin($spiral3))
        $armDensity4 = [math]::Abs([math]::Sin($spiral4))

        $maxArmDensity = [math]::Max([math]::Max($armDensity1, $armDensity2), [math]::Max($armDensity3, $armDensity4))

        # Star clusters
        $clusterNoise = [math]::Sin($angle * 12 + $distance * 3) * [math]::Cos($angle * 8 + $distance * 2)
        $clusterDensity = Clamp -Value ([math]::Abs($clusterNoise) - 0.7) * 3.33 -Min 0 -Max 1

        # Central bulge
        $bulge = Clamp -Value (1.0 - $normalizedDist * 3) -Min 0 -Max 1

        $intensity = Clamp -Value (($maxArmDensity * 0.6 + $clusterDensity * 0.8 + $bulge * 0.4) * (1.0 - $normalizedDist * 0.3)) -Min 0 -Max 1

        $hue = (0.6 + 0.4 * [math]::Sin($angle * 2 + $distance * 0.5) + 0.1 * $clusterNoise) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.8 + 0.2 * $intensity) -Min 0.6 -Max 1
        $value = Clamp -Value (0.1 + 0.9 * [math]::Pow($intensity, 0.7)) -Min 0.05 -Max 1

        $symbol =
        if ($intensity -gt 0.9) { '✦' }
        elseif ($intensity -gt 0.7) { '⋆' }
        elseif ($intensity -gt 0.5) { '·' }
        elseif ($intensity -gt 0.3) { '◦' }
        elseif ($bulge -gt 0.5) { '⊙' }
        else { ' ' }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
