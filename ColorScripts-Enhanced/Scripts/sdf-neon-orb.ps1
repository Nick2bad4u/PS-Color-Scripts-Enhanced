# Unique Concept: Signed-distance fusion of a neon orb, warped ring, and ribbon petals with normal-oriented highlights.


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

function GetSdfSample {
    param(
        [double]$X,
        [double]$Y
    )

    $r = [math]::Sqrt(($X * $X) + ($Y * $Y))
    $theta = [math]::Atan2($Y, $X)
    if ($theta -lt 0) { $theta += 2 * [math]::PI }

    $core = $r - 0.36
    $ringBase = $r - (0.78 + 0.06 * [math]::Sin(6.0 * $theta))
    $ring = [math]::Abs($ringBase) - 0.05
    $petal = $core + 0.16 * [math]::Cos(3.0 * $theta) - 0.04
    $ribbon = $r - (0.52 + 0.08 * [math]::Sin(5.0 * $theta + $r * 2.3))

    $fusion = [math]::Min([math]::Max($core, - $ring), [math]::Max($petal, - $ribbon))

    return [pscustomobject]@{
        Distance = $fusion
        Core     = $core
        Ring     = $ring
        Ribbon   = $ribbon
        Radius   = $r
        Angle    = $theta
    }
}

$width = 100
$height = 36
$delta = 0.004

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = ($col / [double]($width - 1)) - 0.5
        $ny = ($row / [double]($height - 1)) - 0.5
        $x = $nx * 2.4
        $y = $ny * 1.6

        $sample = GetSdfSample -X $x -Y $y
        $gradX = (GetSdfSample -X ($x + $delta) -Y $y).Distance - (GetSdfSample -X ($x - $delta) -Y $y).Distance
        $gradY = (GetSdfSample -X $x -Y ($y + $delta)).Distance - (GetSdfSample -X $x -Y ($y - $delta)).Distance
        $normalAngle = [math]::Atan2($gradY, $gradX)

        $distance = $sample.Distance
        $glow = [math]::Exp( - [math]::Abs($distance) * 45)
        $ringGlow = [math]::Exp( - [math]::Abs($sample.Ring) * 30)
        $coreGlow = [math]::Exp( - [math]::Abs($sample.Core) * 20)
        $ribbonGlow = [math]::Exp( - [math]::Abs($sample.Ribbon) * 24)

        $hue = (($sample.Angle / (2 * [math]::PI)) + 0.48 + 0.16 * [math]::Sin($sample.Radius * 3.2)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.52 + 0.35 * $coreGlow + 0.25 * $ringGlow) -Min 0 -Max 1
        $value = Clamp -Value (0.18 + 0.65 * $glow + 0.25 * $ringGlow + 0.2 * $ribbonGlow) -Min 0.18 -Max 1

        $symbol =
        if ($distance -lt -0.05) { '◎' }
        elseif ($distance -lt -0.015) { '◉' }
        elseif ([math]::Abs($distance) -lt 0.012) {
            if ([math]::Sin($normalAngle) * [math]::Cos($normalAngle) -gt 0) { '╱' } else { '╲' }
        }
        elseif ($ringGlow -gt 0.35) { '∙' }
        elseif ($glow -gt 0.22) { '·' }
        else { ' ' }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
