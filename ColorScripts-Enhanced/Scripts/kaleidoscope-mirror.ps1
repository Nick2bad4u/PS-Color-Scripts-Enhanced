# Unique Concept: Kaleidoscope mirror patterns with reflective symmetry, fractal reflections, and geometric harmony.

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

# Kaleidoscope parameters
$numMirrors = 8
$mirrorAngle = 2 * [math]::PI / $numMirrors

for ($y = 0; $y -lt $height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        $centerX = $width / 2
        $centerY = $height / 2

        $dx = $x - $centerX
        $dy = $y - $centerY
        $distance = [math]::Sqrt($dx * $dx + $dy * $dy)
        $angle = [math]::Atan2($dy, $dx)

        if ($distance -eq 0) { $distance = 0.001 }

        # Kaleidoscope folding
        $foldedAngle = $angle % $mirrorAngle
        if ($foldedAngle -gt $mirrorAngle / 2) {
            $foldedAngle = $mirrorAngle - $foldedAngle
        }

        # Create pattern in folded space
        $patternX = $distance * [math]::Cos($foldedAngle)
        $patternY = $distance * [math]::Sin($foldedAngle)

        # Multiple pattern layers
        $wave1 = [math]::Sin($patternX * 0.1 + $time * 0.2) * [math]::Cos($patternY * 0.1 + $time * 0.1)
        $wave2 = [math]::Sin($patternX * 0.05 + $patternY * 0.07 + $time * 0.15) * 0.5
        $wave3 = [math]::Cos($patternX * 0.03 - $patternY * 0.04 + $time * 0.25) * 0.3

        $intensity = ($wave1 + $wave2 + $wave3 + 3) / 6  # Normalize to 0-1

        # Color based on position in kaleidoscope
        $hue = ($foldedAngle / ([math]::PI / $numMirrors) + $intensity * 0.3 + $distance * 0.01) % 1
        $saturation = 0.7 + 0.3 * [math]::Sin($foldedAngle * 4)
        $value = 0.3 + 0.7 * $intensity

        # Mirror edge highlighting
        $mirrorDistance = [math]::Abs($foldedAngle - $mirrorAngle / 2) / ($mirrorAngle / 2)
        if ($mirrorDistance -lt 0.1) {
            $value = [math]::Min(1.0, $value + 0.4)
            $saturation = [math]::Min(1.0, $saturation + 0.2)
        }

        # Fractal reflections
        $fractalDepth = [math]::Floor([math]::Log($distance + 1) / [math]::Log(2))
        if ($fractalDepth -gt 0) {
            $hue = ($hue + $fractalDepth * 0.1) % 1
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

        # Symbols based on intensity and mirror position
        $symbols = @('·', '◦', '●', '◉', '◎', '◆', '◇', '◈', '⬡', '⬢', '⬣')
        $symbolIndex = [math]::Min([int]($intensity * 11), 10)
        $symbol = $symbols[$symbolIndex]

        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
