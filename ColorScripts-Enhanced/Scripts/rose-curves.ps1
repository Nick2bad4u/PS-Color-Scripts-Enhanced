# Unique Concept: Parametric equations with rose curves and polar coordinate art.

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

$width = 120
$height = 30
$time = ([DateTime]::Now.Ticks / 10000000.0) % 60

$centerX = $width / 2
$centerY = $height / 2

# Rose curves with different petal counts
$roses = @(
    @{ Petals = 3; Scale = 12; Hue = 0.1; Offset = 0 },
    @{ Petals = 4; Scale = 10; Hue = 0.3; Offset = [math]::PI/4 },
    @{ Petals = 5; Scale = 8; Hue = 0.5; Offset = [math]::PI/2 },
    @{ Petals = 6; Scale = 6; Hue = 0.7; Offset = 3*[math]::PI/4 },
    @{ Petals = 7; Scale = 4; Hue = 0.9; Offset = [math]::PI }
)

for ($y = 0; $y -lt $height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        $minDistance = [double]::MaxValue
        $nearestRose = $null

        foreach ($rose in $roses) {
            $dx = $x - $centerX
            $dy = $y - $centerY
            $angle = [math]::Atan2($dy, $dx)

            # Rose curve equation: r = a * cos(k*theta)
            $k = $rose.Petals
            $expectedRadius = $rose.Scale * [math]::Cos($k * ($angle + $rose.Offset + $time * 0.1))

            $actualRadius = [math]::Sqrt($dx * $dx + $dy * $dy)
            $distance = [math]::Abs($actualRadius - [math]::Abs($expectedRadius))

            if ($distance -lt $minDistance) {
                $minDistance = $distance
                $nearestRose = $rose
            }
        }

        if ($minDistance -lt 1) {
            $hue = ($nearestRose.Hue + $time * 0.02) % 1
            $saturation = 0.9
            $value = 0.7 + 0.3 * [math]::Exp(-$minDistance)
            $symbol = '●'
        }
        elseif ($minDistance -lt 2.5) {
            $hue = ($nearestRose.Hue + $minDistance * 0.1) % 1
            $saturation = 0.6
            $value = 0.4 + 0.3 * [math]::Exp(-$minDistance)
            $symbol = '◎'
        }
        else {
            # Background with polar grid
            $dx = $x - $centerX
            $dy = $y - $centerY
            $radius = [math]::Sqrt($dx * $dx + $dy * $dy)
            $angle = [math]::Atan2($dy, $dx)

            $polarPattern = [math]::Sin($radius * 0.2) * [math]::Cos($angle * 6 + $time * 0.1)
            $hue = 0.5 + $polarPattern * 0.1
            $saturation = 0.2
            $value = 0.1 + [math]::Abs($polarPattern) * 0.1
            $symbol = ' '
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
