# Unique Concept: Crystal lattice structures with atomic arrangements, unit cells, and diffraction patterns.

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

# Lattice parameters
$latticeA = 8
$latticeB = 6
$latticeAngle = [math]::PI / 3  # 60 degrees for hexagonal

for ($y = 0; $y -lt $height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        # Convert to lattice coordinates
        $latticeX = $x / $latticeA
        $latticeY = $y / $latticeB

        # Fractional coordinates within unit cell
        $fracX = $latticeX - [math]::Floor($latticeX)
        $fracY = $latticeY - [math]::Floor($latticeY)

        # Distance to nearest lattice points
        $distances = @()

        # FCC/HCP lattice points
        for ($i = -1; $i -le 1; $i++) {
            for ($j = -1; $j -le 1; $j++) {
                $dx = $fracX - $i
                $dy = $fracY - $j
                $distances += [math]::Sqrt($dx * $dx + $dy * $dy)

                # Additional points for complex lattices
                $dx2 = $fracX - $i - 0.5
                $dy2 = $fracY - $j - 0.5
                $distances += [math]::Sqrt($dx2 * $dx2 + $dy2 * $dy2)
            }
        }

        $minDistance = ($distances | Measure-Object -Minimum).Minimum
        $secondMinDistance = ($distances | Sort-Object | Select-Object -Skip 1 -First 1)

        # Voronoi-like coloring based on nearest neighbors
        $hue = ($latticeX * 0.1 + $latticeY * 0.15 + $minDistance * 2) % 1
        $saturation = 0.6 + 0.4 * [math]::Sin($minDistance * 10)
        $value = 0.3 + 0.7 * [math]::Exp(-$minDistance * 3)

        # Atomic sites (bright spots)
        $isAtom = $false
        if ($minDistance -lt 0.15) {
            $value = [math]::Min(1.0, $value + 0.5)
            $saturation = [math]::Min(1.0, $saturation + 0.3)
            $isAtom = $true
        }

        # Bonds between atoms
        $bondStrength = [math]::Max(0, 1 - ($minDistance / 0.3))
        if ($bondStrength -gt 0.3 -and -not $isAtom) {
            $hue = ($hue + 0.5) % 1  # Shift hue for bonds
            $value = [math]::Min(1.0, $value + $bondStrength * 0.4)
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

        # Symbol selection based on structure
        if ($isAtom) {
            $symbol = '●'
        }
        elseif ($bondStrength -gt 0.5) {
            $symbol = '━'
        }
        elseif ($minDistance -lt 0.4) {
            $symbols = @('·', '◦', '◎', '◇')
            $symbol = $symbols[[math]::Floor($minDistance * 10) % 4]
        }
        else {
            $symbol = ' '
        }

        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
