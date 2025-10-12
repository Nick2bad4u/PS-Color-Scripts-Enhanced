# Unique Concept: Crystal lattice with refractive light patterns and geometric symmetries.
# Hexagonal crystal structures with light bending through prismatic facets.

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

        # Hexagonal lattice
        $hexX = $nx * 10
        $hexY = $ny * 6
        $hexDist = [math]::Sqrt(($hexX % 1 - 0.5) * ($hexX % 1 - 0.5) + ($hexY % 1 - 0.5) * ($hexY % 1 - 0.5))

        # Light refraction simulation
        $angle = [math]::Atan2($ny - 0.5, $nx - 0.5)
        $refraction = [math]::Sin($angle * 6 + $hexDist * [math]::PI * 2) * 0.5 + 0.5

        $facet = [math]::Floor($angle / ([math]::PI / 3)) % 6
        $prismHue = $facet / 6.0

        $intensity = Clamp -Value (1.0 - $hexDist * 2) * $refraction -Min 0 -Max 1

        $hue = ($prismHue + 0.2 * [math]::Sin($hexDist * [math]::PI * 4)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.9 - $hexDist * 0.3) -Min 0.6 -Max 1
        $value = Clamp -Value (0.3 + 0.7 * [math]::Pow($intensity, 0.6)) -Min 0.2 -Max 1

        $symbol =
        if ($intensity -gt 0.9) { '◆' }
        elseif ($intensity -gt 0.7) { '◇' }
        elseif ($intensity -gt 0.5) { '⋄' }
        elseif ($intensity -gt 0.3) { '·' }
        else { ' ' }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
