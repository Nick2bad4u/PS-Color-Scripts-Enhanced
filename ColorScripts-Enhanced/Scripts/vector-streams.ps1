# Unique Concept: Curl-driven vector field streamlines traced with direction-aware glyphs and magnitude-responsive color.

# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

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

$width = 102
$height = 38
$seedCount = 36

$vortices = @(
    @{ X = 0.28; Y = 0.32; Strength = 0.9 },
    @{ X = 0.68; Y = 0.28; Strength = -0.75 },
    @{ X = 0.52; Y = 0.68; Strength = 1.05 }
)

function GetVectorField {
    param(
        [double]$X,
        [double]$Y
    )

    $vx = 0.18 * [math]::Sin(3.0 * $Y) + 0.07 * [math]::Cos(5.0 * ($X + $Y))
    $vy = 0.18 * [math]::Sin(3.0 * $X + 0.3) - 0.07 * [math]::Cos(5.0 * ($Y - $X))

    foreach ($vortex in $vortices) {
        $dx = $X - $vortex.X
        $dy = $Y - $vortex.Y
        $r2 = ($dx * $dx) + ($dy * $dy) + 1e-5
        $inv = $vortex.Strength / $r2
        $vx += - $inv * $dy
        $vy += $inv * $dx
    }

    return @($vx, $vy)
}

$grid = @{}
$maxMag = 0.0
$minMag = [double]::PositiveInfinity

for ($s = 0; $s -lt $seedCount; $s++) {
    $seedY = ($s + 0.5) / $seedCount
    $x = 0.05
    $y = $seedY
    $seedHue = $s / [double]$seedCount

    for ($step = 0; $step -lt 170; $step++) {
        $field = GetVectorField -X $x -Y $y
        $vx = $field[0]
        $vy = $field[1]
        $mag = [math]::Sqrt($vx * $vx + $vy * $vy)
        if ($mag -lt 1e-4) { break }

        $dirX = $vx / $mag
        $dirY = $vy / $mag
        $stepSize = 0.013 + 0.007 * [math]::Sin($mag * 3.1)
        $x += $dirX * $stepSize
        $y += $dirY * $stepSize

        if ($x -lt 0 -or $x -gt 1 -or $y -lt 0 -or $y -gt 1) { break }

        $gx = [math]::Floor($x * ($width - 1))
        $gy = [math]::Floor($y * ($height - 1))
        $key = "$gx,$gy"

        if (-not $grid.ContainsKey($key) -or $mag -gt $grid[$key].Mag) {
            $grid[$key] = [pscustomobject]@{
                Mag     = $mag
                Angle   = [math]::Atan2($vy, $vx)
                SeedHue = $seedHue
            }
        }

        if ($mag -gt $maxMag) { $maxMag = $mag }
        if ($mag -lt $minMag) { $minMag = $mag }
    }
}

if ($maxMag -eq $minMag) { $maxMag = $minMag + 1e-6 }

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"
        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]
            $normalized = ($cell.Mag - $minMag) / ($maxMag - $minMag)
            $angle = $cell.Angle

            $cosAngle = [math]::Cos($angle)
            $sinAngle = [math]::Sin($angle)
            $absCos = [math]::Abs($cosAngle)
            $absSin = [math]::Abs($sinAngle)

            if ($normalized -lt 0.18) {
                $symbol = '·'
            }
            elseif ($absCos -gt 0.78 -and $absSin -lt 0.35) {
                $symbol = '━'
            }
            elseif ($absSin -gt 0.78 -and $absCos -lt 0.35) {
                $symbol = '┃'
            }
            elseif ($sinAngle * $cosAngle -ge 0) {
                $symbol = '╱'
            }
            else {
                $symbol = '╲'
            }

            $hue = ($cell.SeedHue + 0.18 * $normalized + 0.09 * [math]::Sin($angle * 3)) % 1
            if ($hue -lt 0) { $hue += 1 }
            $saturation = Clamp -Value (0.55 + 0.4 * $normalized) -Min 0 -Max 1
            $value = Clamp -Value (0.25 + 0.65 * $normalized) -Min 0.2 -Max 1.0

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;10;11;14m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
