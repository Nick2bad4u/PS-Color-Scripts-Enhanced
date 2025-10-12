# Unique Concept: Static tessellation with interlocking geometric shapes and color transitions.

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

# Tessellation grid
$tileSize = 6

for ($y = 0; $y -lt $height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        $tileX = [math]::Floor($x / $tileSize)
        $tileY = [math]::Floor($y / $tileSize)
        $localX = $x % $tileSize
        $localY = $y % $tileSize

        # Determine tile type based on position
        $tileType = ($tileX + $tileY) % 3

        $hue = ($tileType * 0.3 + $tileX * 0.05 + $tileY * 0.07) % 1
        $saturation = 0.8
        $value = 0.6

        # Different patterns for different tile types
        switch ($tileType) {
            0 {
                # Triangle pattern
                if ($localY -le $localX -and $localY -le $tileSize - 1 - $localX) {
                    $hue = ($hue + 0.1) % 1
                    $symbol = '▲'
                }
                elseif ($localY -ge $localX -and $localY -ge $tileSize - 1 - $localX) {
                    $hue = ($hue + 0.2) % 1
                    $symbol = '▼'
                }
                else {
                    $value = 0.3
                    $symbol = ' '
                }
            }
            1 {
                # Diamond pattern
                if ([math]::Abs($localX - $tileSize/2) + [math]::Abs($localY - $tileSize/2) -le $tileSize/2) {
                    $hue = ($hue + 0.3) % 1
                    $symbol = '◆'
                }
                else {
                    $value = 0.3
                    $symbol = ' '
                }
            }
            2 {
                # Hexagon pattern
                $centerX = $tileSize / 2
                $centerY = $tileSize / 2
                $dx = [math]::Abs($localX - $centerX)
                $dy = [math]::Abs($localY - $centerY)

                if ($dx * 2 + $dy -le $centerX) {
                    $hue = ($hue + 0.4) % 1
                    $symbol = '⬡'
                }
                else {
                    $value = 0.3
                    $symbol = ' '
                }
            }
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
