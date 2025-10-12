# Unique Concept: Static rose window with stained glass patterns and radial symmetry.

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
$centerX = $width / 2
$centerY = $height / 2

# Rose window parameters
$numSegments = 8
$numRings = 5

for ($y = 0; $y -lt $height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        $dx = $x - $centerX
        $dy = $y - $centerY
        $angle = [math]::Atan2($dy, $dx)
        $radius = [math]::Sqrt($dx * $dx + $dy * $dy)

        # Normalize angle
        if ($angle -lt 0) { $angle += 2 * [math]::PI }

        # Determine segment
        $segmentAngle = 2 * [math]::PI / $numSegments
        $segmentIndex = [math]::Floor($angle / $segmentAngle)

        # Determine ring
        $ringIndex = [math]::Floor($radius / ($height / 2) * $numRings)

        # Stained glass pattern
        $pattern = ($segmentIndex + $ringIndex) % 4

        switch ($pattern) {
            0 {
                $hue = 0.1 + $segmentIndex * 0.1  # Reds
                $saturation = 0.9
                $value = 0.7
                $symbol = '●'
            }
            1 {
                $hue = 0.3 + $ringIndex * 0.05  # Blues
                $saturation = 0.8
                $value = 0.6
                $symbol = '◆'
            }
            2 {
                $hue = 0.5 + $segmentIndex * 0.08  # Greens
                $saturation = 0.85
                $value = 0.65
                $symbol = '◇'
            }
            3 {
                $hue = 0.7 + $ringIndex * 0.03  # Purples
                $saturation = 0.75
                $value = 0.55
                $symbol = '◎'
            }
        }

        # Lead lines between segments
        $angleToSegment = [math]::Abs($angle - ($segmentIndex + 0.5) * $segmentAngle)
        if ($angleToSegment -lt 0.1 -and $radius -gt 2) {
            $hue = 0.0
            $saturation = 0.0
            $value = 0.2
            $symbol = '│'
        }

        # Central medallion
        if ($radius -lt 3) {
            $hue = 0.8
            $saturation = 0.9
            $value = 0.8
            $symbol = '✦'
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
