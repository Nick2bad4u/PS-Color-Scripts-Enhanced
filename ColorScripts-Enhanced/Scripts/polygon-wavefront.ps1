# Unique Concept: Rotating heptagon wavefronts with edge-distance pulses and interior/exterior phase separation.


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

function Get-DistanceToSegment {
    param(
        [double]$PX,
        [double]$PY,
        [double]$AX,
        [double]$AY,
        [double]$BX,
        [double]$BY
    )

    $vx = $BX - $AX
    $vy = $BY - $AY
    $wx = $PX - $AX
    $wy = $PY - $AY

    $c1 = $vx * $wx + $vy * $wy
    if ($c1 -le 0) { return [math]::Sqrt(($PX - $AX) * ($PX - $AX) + ($PY - $AY) * ($PY - $AY)) }

    $c2 = $vx * $vx + $vy * $vy
    if ($c2 -le $c1) { return [math]::Sqrt(($PX - $BX) * ($PX - $BX) + ($PY - $BY) * ($PY - $BY)) }

    $b = $c1 / $c2
    $projX = $AX + ($b * $vx)
    $projY = $AY + ($b * $vy)
    return [math]::Sqrt(($PX - $projX) * ($PX - $projX) + ($PY - $projY) * ($PY - $projY))
}

function Test-PointInPolygon {
    param(
        [double]$X,
        [double]$Y,
        [object[]]$Vertices
    )

    $inside = $false
    $count = $Vertices.Count
    for ($i = 0; $i -lt $count; $i++) {
        $j = ($i + $count - 1) % $count
        $xi = $Vertices[$i].X
        $yi = $Vertices[$i].Y
        $xj = $Vertices[$j].X
        $yj = $Vertices[$j].Y

        $intersect = (($yi -le $Y -and $Y -lt $yj) -or ($yj -le $Y -and $Y -lt $yi)) -and ($X -lt ($xj - $xi) * ($Y - $yi) / (($yj - $yi) + 1e-9) + $xi)
        if ($intersect) { $inside = -not $inside }
    }

    return $inside
}

$width = 104
$height = 36
$angles = 0..6 | ForEach-Object { (2 * [math]::PI / 7) * $_ }

for ($row = $height - 1; $row -ge 0; $row--) {
    $rowNorm = $row / [double]($height - 1)
    $rotation = 0.8 * $rowNorm

    $vertices = @()
    foreach ($angle in $angles) {
        $radius = 0.78 + 0.12 * [math]::Sin($rowNorm * 6 + $angle * 2.1)
        $vx = [math]::Cos($angle + $rotation) * $radius
        $vy = [math]::Sin($angle + $rotation) * $radius * 0.65
        $vertices += [pscustomobject]@{ X = $vx; Y = $vy }
    }

    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = ($col / [double]($width - 1)) * 2.0 - 1.0
        $ny = ($row / [double]($height - 1)) * 2.0 - 1.0
        $px = $nx * 1.15
        $py = $ny * 0.72

        $inside = Test-PointInPolygon -X $px -Y $py -Vertices $vertices
        $minDist = [double]::PositiveInfinity

        for ($i = 0; $i -lt $vertices.Count; $i++) {
            $j = ($i + 1) % $vertices.Count
            $dist = Get-DistanceToSegment -PX $px -PY $py -AX $vertices[$i].X -AY $vertices[$i].Y -BX $vertices[$j].X -BY $vertices[$j].Y
            if ($dist -lt $minDist) { $minDist = $dist }
        }

        $wave = [math]::Sin($minDist * 12.5 + $rowNorm * 6.2)
        if (-not $inside) { $wave = - $wave }

        $hue = (0.53 + 0.22 * $wave + 0.12 * $rowNorm + 0.08 * [math]::Sin($col * 0.06)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.48 + 0.35 * [math]::Exp(-$minDist * 4) + 0.2 * $wave) -Min 0 -Max 1
        $value = Clamp -Value (0.22 + 0.65 * [math]::Exp(-$minDist * 6) + 0.18 * $wave) -Min 0.18 -Max 1

        $symbol = if ($inside) {
            if ($minDist -lt 0.035) { '◆' }
            elseif ($wave -gt 0.45) { '◈' }
            elseif ($wave -gt -0.2) { '∙' }
            else { '·' }
        }
        else {
            if ($minDist -lt 0.03) {
                if ($wave -gt 0) { '╱' } else { '╲' }
            }
            elseif ($minDist -lt 0.07) {
                '·'
            }
            else {
                ' '
            }
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}
