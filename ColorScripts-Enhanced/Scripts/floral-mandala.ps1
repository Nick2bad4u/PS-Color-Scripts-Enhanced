# Unique Concept: Floral mandala with layered petals and geometric symmetry.
# Multi-layered flower patterns with petal gradients and central corolla.

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

        # Petal layers
        $petalAngle = $angle * 8  # 8 petals
        $petalShape = [math]::Abs([math]::Sin($petalAngle / 2)) * [math]::Cos($petalAngle / 2)

        $innerPetals = [math]::Abs([math]::Sin($angle * 12)) * (1.0 - $normalizedDist * 2)
        $outerPetals = $petalShape * [math]::Exp(-$normalizedDist * 1.5)

        # Central corolla
        $corolla = Clamp -Value (1.0 - $normalizedDist * 4) -Min 0 -Max 1

        # Flower center
        $centerGlow = Clamp -Value (1.0 - $normalizedDist * 8) -Min 0 -Max 1

        $intensity = Clamp -Value (($innerPetals * 0.5 + $outerPetals * 0.7 + $corolla * 0.6 + $centerGlow * 0.8) * (1.0 - $normalizedDist * 0.2)) -Min 0 -Max 1

        $hue = (0.1 + 0.9 * [math]::Sin($angle * 4 + $normalizedDist * 6) + 0.1 * [math]::Cos($petalAngle)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.9 + 0.1 * $intensity) -Min 0.7 -Max 1
        $value = Clamp -Value (0.2 + 0.8 * [math]::Pow($intensity, 0.6)) -Min 0.1 -Max 1

        $symbol =
        if ($centerGlow -gt 0.8) { '✦' }
        elseif ($intensity -gt 0.8) { '❀' }
        elseif ($intensity -gt 0.6) { '✿' }
        elseif ($intensity -gt 0.4) { '✾' }
        elseif ($intensity -gt 0.2) { '·' }
        else { ' ' }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
