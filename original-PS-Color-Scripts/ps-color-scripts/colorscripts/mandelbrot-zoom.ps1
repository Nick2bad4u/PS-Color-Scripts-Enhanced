# Unique Concept: Deep Mandelbrot set visualization with iteration-based color cycling and escape velocity gradients.
# Uses cardioid and bulb optimization for faster rendering and smooth HSV color mapping.

# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

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
    param([double]$Value, [double]$Min, [double]$Max)
    if ($Value -lt $Min) { return $Min }
    if ($Value -gt $Max) { return $Max }
    return $Value
}

function Get-MandelbrotIteration {
    param(
        [double]$Cx,
        [double]$Cy,
        [int]$MaxIter
    )

    # Cardioid and bulb check for main body optimization
    $q = ($Cx - 0.25) * ($Cx - 0.25) + $Cy * $Cy
    if ($q * ($q + ($Cx - 0.25)) -lt 0.25 * $Cy * $Cy) { return -1 }
    if (($Cx + 1) * ($Cx + 1) + $Cy * $Cy -lt 0.0625) { return -1 }

    $zx = 0.0
    $zy = 0.0
    $iter = 0

    while ($iter -lt $MaxIter) {
        $zx2 = $zx * $zx
        $zy2 = $zy * $zy

        if ($zx2 + $zy2 -gt 4.0) {
            # Smooth coloring using escape velocity
            $smoothIter = $iter + 1 - [math]::Log([math]::Log([math]::Sqrt($zx2 + $zy2))) / [math]::Log(2)
            return $smoothIter
        }

        $zyTemp = 2.0 * $zx * $zy + $Cy
        $zx = $zx2 - $zy2 + $Cx
        $zy = $zyTemp
        $iter++
    }

    return -1
}

$width = 120
$height = 40
$maxIter = 256

# Zoom into an interesting location near the Mandelbrot boundary
$centerX = -0.7463
$centerY = 0.1102
$zoom = 0.005

for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $x = $centerX + ($col - $width / 2.0) * $zoom / $width * 3.5
        $y = $centerY + ($row - $height / 2.0) * $zoom / $height * 2.0

        $iter = Get-MandelbrotIteration -Cx $x -Cy $y -MaxIter $maxIter

        if ($iter -lt 0) {
            # Inside the set - deep black with slight color variation
            $hue = (($col + $row) * 0.003) % 1
            $rgb = Convert-HsvToRgb -Hue $hue -Saturation 0.3 -Value 0.15
            $symbol = '█'
        }
        else {
            # Outside the set - color by iteration count
            $normalized = $iter / $maxIter
            $hue = (0.65 + $normalized * 2.5 + [math]::Sin($normalized * 6.28) * 0.1) % 1
            $saturation = Clamp -Value (0.7 + 0.25 * [math]::Cos($normalized * 3.14)) -Min 0 -Max 1
            $value = Clamp -Value (0.3 + 0.7 * [math]::Pow($normalized, 0.7)) -Min 0.2 -Max 1.0

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            # Symbol varies by escape speed
            if ($normalized -lt 0.05) { $symbol = '▓' }
            elseif ($normalized -lt 0.15) { $symbol = '▒' }
            elseif ($normalized -lt 0.3) { $symbol = '░' }
            elseif ($normalized -lt 0.5) { $symbol = '·' }
            else { $symbol = '∙' }
        }

        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
