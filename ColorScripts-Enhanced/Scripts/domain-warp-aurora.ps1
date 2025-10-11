# Unique Concept: Dual-domain warped aurora using recursive sine displacement and ridge detection.


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
$height = 34

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $u = $col / [double]($width - 1)
        $v = $row / [double]($height - 1)

        $warpA = 0.22 * [math]::Sin(6.0 * $v + 0.8 * [math]::Sin(4.0 * $u))
        $warpB = 0.22 * [math]::Sin(6.0 * $u - 0.8 * [math]::Cos(4.0 * $v))

        $wx = $u + $warpA
        $wy = $v + $warpB

        $warpC = 0.18 * [math]::Sin(7.0 * $wy + 1.2 * [math]::Cos(5.0 * $wx))
        $warpD = 0.18 * [math]::Cos(7.0 * $wx - 1.2 * [math]::Sin(5.0 * $wy))

        $fx = $wx + $warpC
        $fy = $wy + $warpD

        $ridge = [math]::Sin(12.0 * $fx + 4.0 * [math]::Sin(3.5 * $fy))
        $sheet = [math]::Sin(8.0 * $fy + 2.5 * [math]::Sin(4.5 * $fx))
        $mix = ($ridge * 0.6) + ($sheet * 0.4)
        $intensity = 0.5 + 0.5 * [math]::Sin($mix * 3.1 + $u * 2 - $v * 2.5)

        $ridgeSharp = [math]::Exp( - [math]::Pow([math]::Abs($ridge), 1.6) * 3.5)
        $sheetSharp = [math]::Exp( - [math]::Pow([math]::Abs($sheet), 1.4) * 3.0)

        $hue = (0.67 + 0.18 * $ridge + 0.12 * $sheet + 0.08 * [math]::Sin($fy * 5.2)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.55 + 0.35 * $intensity + 0.18 * $sheetSharp) -Min 0 -Max 1
        $value = Clamp -Value (0.28 + 0.62 * $intensity + 0.25 * $ridgeSharp) -Min 0.2 -Max 1

        $symbol = if ($ridgeSharp -gt 0.72) {
            '╱'
        }
        elseif ($sheetSharp -gt 0.68) {
            '╲'
        }
        elseif ($intensity -gt 0.72) {
            '╳'
        }
        elseif ($intensity -gt 0.45) {
            '∙'
        }
        else {
            '·'
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
