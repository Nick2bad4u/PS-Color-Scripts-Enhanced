# Unique Concept: Flower of Life sacred geometry with overlapping circles, metatron's cube, and harmonic proportions.

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

# Flower of Life parameters
$circleRadius = 6
$centerX = $width / 2
$centerY = $height / 2

# Define circle centers for Flower of Life
$circles = @(
    @{ X = $centerX; Y = $centerY; Radius = $circleRadius },  # Center
    @{ X = $centerX + $circleRadius; Y = $centerY; Radius = $circleRadius },  # Right
    @{ X = $centerX - $circleRadius; Y = $centerY; Radius = $circleRadius },  # Left
    @{ X = $centerX + $circleRadius/2; Y = $centerY + $circleRadius * [math]::Sqrt(3)/2; Radius = $circleRadius },  # Top right
    @{ X = $centerX - $circleRadius/2; Y = $centerY + $circleRadius * [math]::Sqrt(3)/2; Radius = $circleRadius },  # Top left
    @{ X = $centerX + $circleRadius/2; Y = $centerY - $circleRadius * [math]::Sqrt(3)/2; Radius = $circleRadius },  # Bottom right
    @{ X = $centerX - $circleRadius/2; Y = $centerY - $circleRadius * [math]::Sqrt(3)/2; Radius = $circleRadius },  # Bottom left
    @{ X = $centerX; Y = $centerY + $circleRadius * [math]::Sqrt(3); Radius = $circleRadius },  # Top
    @{ X = $centerX; Y = $centerY - $circleRadius * [math]::Sqrt(3); Radius = $circleRadius },  # Bottom
    @{ X = $centerX + $circleRadius * 2; Y = $centerY; Radius = $circleRadius },  # Far right
    @{ X = $centerX - $circleRadius * 2; Y = $centerY; Radius = $circleRadius },  # Far left
    @{ X = $centerX; Y = $centerY + $circleRadius * 2 * [math]::Sqrt(3); Radius = $circleRadius },  # Far top
    @{ X = $centerX; Y = $centerY - $circleRadius * 2 * [math]::Sqrt(3); Radius = $circleRadius }   # Far bottom
)

for ($y = 0; $y -lt $height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        $minDistance = [double]::MaxValue
        $circleIndex = -1
        $isIntersection = $false
        $intersectionCount = 0

        # Calculate distance to nearest circle and intersections
        for ($i = 0; $i -lt $circles.Count; $i++) {
            $circle = $circles[$i]
            $dx = $x - $circle.X
            $dy = $y - $circle.Y
            $distance = [math]::Sqrt($dx * $dx + $dy * $dy)

            # Distance to circle edge
            $edgeDistance = [math]::Abs($distance - $circle.Radius)

            if ($edgeDistance -lt $minDistance) {
                $minDistance = $edgeDistance
                $circleIndex = $i
            }

            # Count how many circles contain this point
            if ($distance -le $circle.Radius) {
                $intersectionCount++
            }
        }

        $isIntersection = $intersectionCount -gt 1

        if ($minDistance -lt 2) {
            # On or near circle edge
            $hue = ($circleIndex / [double]$circles.Count + $time * 0.05) % 1
            $saturation = 0.9
            $value = 0.7 + 0.3 * [math]::Exp(-$minDistance)

            if ($isIntersection) {
                # Intersection points (sacred geometry nodes)
                $hue = ($hue + 0.3) % 1  # Shift to different color
                $value = [math]::Min(1.0, $value + 0.3)
                $symbol = '✦'
            }
            else {
                $symbol = '○'
            }
        }
        elseif ($intersectionCount -gt 0) {
            # Inside circles
            $hue = ($intersectionCount * 0.1 + $time * 0.02) % 1
            $saturation = 0.6 + $intersectionCount * 0.1
            $value = 0.4 + $intersectionCount * 0.1

            $symbols = @('·', '◦', '●', '◉', '◎')
            $symbol = $symbols[[math]::Min($intersectionCount, 4)]
        }
        else {
            # Background
            $hue = 0.55  # Blue tint
            $saturation = 0.2
            $value = 0.1
            $symbol = ' '
        }

        # Add golden ratio harmonics
        $goldenRatio = (1 + [math]::Sqrt(5)) / 2
        $harmonicX = [math]::Sin($x * $goldenRatio * 0.1) * [math]::Cos($y * $goldenRatio * 0.1)
        $hue = ($hue + $harmonicX * 0.1) % 1

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
