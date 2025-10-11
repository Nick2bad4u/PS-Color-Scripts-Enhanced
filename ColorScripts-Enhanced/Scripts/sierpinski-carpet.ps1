# Unique Concept: Sierpinski carpet fractal with recursive square subdivisions.
# Creates a fractal pattern by repeatedly removing the central ninth of squares.


$ErrorActionPreference = 'Stop'
$esc = [char]27
$reset = "$esc[0m"

function Convert-HsvToRgb {
    param([double]$Hue, [double]$Saturation, [double]$Value)
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

function Test-InCarpet {
    param($X, $Y, $Size)

    while ($Size -ge 1) {
        $mod = $Size / 3
        $cellX = [math]::Floor($X / $mod) % 3
        $cellY = [math]::Floor($Y / $mod) % 3

        # Center cell is removed
        if ($cellX -eq 1 -and $cellY -eq 1) {
            return $false
        }

        $Size = $Size / 3
    }

    return $true
}

$size = 81  # 3^4
$height = 27  # 3^3

for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $size; $col++) {
        $inCarpet = Test-InCarpet -X $col -Y $row -Size $size

        if ($inCarpet) {
            # Calculate depth (how many times subdivided)
            $tempSize = $size
            $depth = 0
            $tempX = $col
            $tempY = $row

            while ($tempSize -ge 3) {
                $mod = $tempSize / 3
                $cellX = [math]::Floor($tempX / $mod) % 3
                $cellY = [math]::Floor($tempY / $mod) % 3

                if ($cellX -ne 1 -or $cellY -ne 1) {
                    $depth++
                }

                $tempSize = $mod
                $tempX = $tempX % $mod
                $tempY = $tempY % $mod
            }

            $depthRatio = $depth / 5.0
            $hue = (0.7 - $depthRatio * 0.4) % 1
            $saturation = 0.65 + 0.3 * $depthRatio
            $value = 0.5 + 0.45 * $depthRatio

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $symbol = '█'

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
