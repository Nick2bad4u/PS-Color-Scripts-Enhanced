# Unique Concept: Static labyrinth pattern with maze-like paths and color-coded sections.

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

# Generate labyrinth pattern using distance fields
for ($y = 0; $y -lt $height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        # Multiple circular paths
        $minDistance = [double]::MaxValue
        $pathIndex = 0

        for ($ring = 1; $ring -le 6; $ring++) {
            $ringRadius = $ring * 4
            $centerX = $width / 2
            $centerY = $height / 2

            $dx = $x - $centerX
            $dy = $y - $centerY
            $distance = [math]::Sqrt($dx * $dx + $dy * $dy)

            $ringDistance = [math]::Abs($distance - $ringRadius)
            if ($ringDistance -lt $minDistance) {
                $minDistance = $ringDistance
                $pathIndex = $ring
            }
        }

        # Spiral elements
        $spiralAngle = [math]::Atan2($y - $height/2, $x - $width/2)
        $spiralRadius = [math]::Sqrt(($x - $width/2) * ($x - $width/2) + ($y - $height/2) * ($y - $height/2))
        $spiralValue = [math]::Sin($spiralRadius * 0.3 + $spiralAngle * 2)

        if ($minDistance -lt 1.5) {
            # Path walls
            $hue = ($pathIndex * 0.15) % 1
            $saturation = 0.9
            $value = 0.7
            $symbol = '█'
        }
        elseif ($minDistance -lt 3) {
            # Path corridors
            $hue = ($pathIndex * 0.15 + 0.5) % 1
            $saturation = 0.6
            $value = 0.4
            $symbol = '░'
        }
        else {
            # Spiral decorations
            if ([math]::Abs($spiralValue) -gt 0.7) {
                $hue = (0.8 + $spiralValue * 0.1) % 1
                $saturation = 0.8
                $value = 0.6
                $symbol = '✦'
            }
            else {
                $hue = 0.4
                $saturation = 0.2
                $value = 0.1
                $symbol = ' '
            }
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
