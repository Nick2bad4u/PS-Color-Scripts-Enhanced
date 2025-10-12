# Unique Concept: Tie-dye spiral with swirling color patterns and fluid dye flows.
# Psychedelic tie-dye effect with multiple color streams mixing in spiral patterns.

$ErrorActionPreference = 'Stop'
$esc = [char]27
$reset = "$esc[0m"

function Convert-HsvToRgb {
    param(
        [double]$Hue,
        [double]$Saturation,
        [double]$Value
    )

    # Ensure valid inputs
    $Hue = Clamp -Value $Hue -Min 0 -Max 1
    $Saturation = Clamp -Value $Saturation -Min 0 -Max 1
    $Value = Clamp -Value $Value -Min 0 -Max 1

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

$width = 100
$height = 30

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $centerX = $width / 2.0
        $centerY = $height / 2.0
        $dx = $col - $centerX
        $dy = $row - $centerY
        $distance = [math]::Sqrt($dx * $dx + $dy * $dy)
        $angle = [math]::Atan2($dy, $dx)
        if ($angle -lt 0) { $angle += 2 * [math]::PI }

        $normalizedDist = Clamp -Value ($distance / [math]::Max($centerX, $centerY)) -Min 0 -Max 1

        # Multiple color streams
        $stream1 = [math]::Sin($angle * 3 + $normalizedDist * 8) * 0.5 + 0.5
        $stream2 = [math]::Sin($angle * 5 + $normalizedDist * 12 + 1) * 0.5 + 0.5
        $stream3 = [math]::Sin($angle * 7 + $normalizedDist * 6 + 2) * 0.5 + 0.5
        $stream4 = [math]::Sin($angle * 2 + $normalizedDist * 10 + 3) * 0.5 + 0.5

        # Mix colors based on distance
        $mix = ($stream1 + $stream2 + $stream3 + $stream4) / 4.0
        $turbulence = [math]::Sin($normalizedDist * 15 + $angle * 4) * 0.2

        $hue = Clamp -Value (($mix + $turbulence + $angle / (2 * [math]::PI)) % 1) -Min 0 -Max 1
        $saturation = Clamp -Value (0.8 + 0.2 * [math]::Sin($normalizedDist * 20)) -Min 0.6 -Max 1
        $value = Clamp -Value (0.3 + 0.7 * [math]::Pow(1 - $normalizedDist, 0.5)) -Min 0.2 -Max 1

        $symbol =
        if ($mix -gt 0.8) { '◎' }
        elseif ($mix -gt 0.6) { '◉' }
        elseif ($mix -gt 0.4) { '●' }
        elseif ($mix -gt 0.2) { '◦' }
        else { '·' }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
