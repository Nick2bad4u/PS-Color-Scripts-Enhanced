# Unique Concept: Aurora Borealis waves with flowing energy streams and polar light gradients.
# Dynamic wave interference creating aurora-like curtains with magnetic field influences.

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

$width = 120
$height = 30

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = $col / [double]($width - 1)
        $ny = $row / [double]($height - 1)

        # Multiple wave layers for aurora effect
        $wave1 = [math]::Sin(2.0 * [math]::PI * ($nx * 3.0 + $ny * 0.5))
        $wave2 = [math]::Sin(2.0 * [math]::PI * ($nx * 2.5 + $ny * 0.7 + 0.3))
        $wave3 = [math]::Sin(2.0 * [math]::PI * ($nx * 4.0 + $ny * 0.3 + 0.6))

        $interference = ($wave1 + $wave2 + $wave3) / 3.0
        $curvature = [math]::Sin([math]::PI * $ny) * 0.8

        $energy = [math]::Abs($interference) * (1.0 - $ny * 0.6) + $curvature * 0.2
        $energy = Clamp -Value $energy -Min 0 -Max 1

        $hue = (0.55 + 0.3 * $wave1 + 0.2 * $wave2 + 0.1 * [math]::Sin($nx * [math]::PI * 2)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.8 + 0.2 * $energy) -Min 0.5 -Max 1
        $value = Clamp -Value (0.2 + 0.8 * [math]::Pow($energy, 0.7)) -Min 0.1 -Max 1

        $symbol =
        if ($energy -gt 0.8) { '✦' }
        elseif ($energy -gt 0.6) { '✧' }
        elseif ($energy -gt 0.4) { '⋆' }
        elseif ($energy -gt 0.2) { '·' }
        else { ' ' }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
