# Unique Concept: Fractal nebula with recursive star formations and cosmic dust clouds.
# Mandelbrot-inspired patterns creating infinite depth with stellar nurseries.

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

function Mandelbrot {
    param(
        [double]$x,
        [double]$y,
        [int]$maxIter = 50
    )

    $zx = 0
    $zy = 0
    $iteration = 0

    while (($zx * $zx + $zy * $zy) -lt 4 -and $iteration -lt $maxIter) {
        $temp = $zx * $zx - $zy * $zy + $x
        $zy = 2 * $zx * $zy + $y
        $zx = $temp
        $iteration++
    }

    return $iteration
}

$width = 100
$height = 30

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = ($col / [double]($width - 1)) * 3.5 - 2.5
        $ny = ($row / [double]($height - 1)) * 2.0 - 1.0

        $iter = Mandelbrot -x $nx -y $ny -maxIter 30
        $normalized = $iter / 30.0

        $noise = [math]::Sin($nx * 10 + $ny * 15) * 0.1
        $depth = [math]::Exp(-$normalized * 2) + $noise

        $hue = (0.7 + 0.3 * [math]::Sin($normalized * [math]::PI * 4) + 0.1 * $noise) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.6 + 0.4 * $depth) -Min 0.3 -Max 1
        $value = Clamp -Value (0.1 + 0.9 * [math]::Pow($depth, 0.8)) -Min 0.05 -Max 1

        $symbol =
        if ($normalized -gt 0.8) { '✦' }
        elseif ($normalized -gt 0.6) { '⋆' }
        elseif ($normalized -gt 0.4) { '·' }
        elseif ($normalized -gt 0.2) { '◦' }
        else { ' ' }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
