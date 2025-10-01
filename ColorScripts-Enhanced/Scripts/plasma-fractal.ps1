# Unique Concept: Plasma fractal using diamond-square algorithm for terrain-like color gradients.
# Generates organic noise patterns through recursive midpoint displacement with interpolated colors.

# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

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

function Clamp([double]$Value, [double]$Min, [double]$Max) {
    if ($Value -lt $Min) { return $Min }
    if ($Value -gt $Max) { return $Max }
    return $Value
}

$width = 65
$height = 25
$size = 64  # Power of 2

# Initialize grid
$grid = [double[][]]::new($size + 1)
for ($i = 0; $i -le $size; $i++) {
    $grid[$i] = [double[]]::new($size + 1)
}

$rand = [System.Random]::new(999)

# Set corners
$grid[0][0] = $rand.NextDouble()
$grid[0][$size] = $rand.NextDouble()
$grid[$size][0] = $rand.NextDouble()
$grid[$size][$size] = $rand.NextDouble()

# Diamond-square algorithm
$stepSize = $size
$scale = 1.0

while ($stepSize -gt 1) {
    $halfStep = $stepSize / 2

    # Diamond step
    for ($y = $halfStep; $y -lt $size; $y += $stepSize) {
        for ($x = $halfStep; $x -lt $size; $x += $stepSize) {
            $avg = ($grid[$y - $halfStep][$x - $halfStep] +
                $grid[$y - $halfStep][$x + $halfStep] +
                $grid[$y + $halfStep][$x - $halfStep] +
                $grid[$y + $halfStep][$x + $halfStep]) / 4.0

            $grid[$y][$x] = $avg + ($rand.NextDouble() - 0.5) * $scale
        }
    }

    # Square step
    for ($y = 0; $y -le $size; $y += $halfStep) {
        for ($x = (($y / $halfStep) % 2) * $halfStep; $x -le $size; $x += $stepSize) {
            $sum = 0.0
            $count = 0

            if ($y - $halfStep -ge 0) { $sum += $grid[$y - $halfStep][$x]; $count++ }
            if ($y + $halfStep -le $size) { $sum += $grid[$y + $halfStep][$x]; $count++ }
            if ($x - $halfStep -ge 0) { $sum += $grid[$y][$x - $halfStep]; $count++ }
            if ($x + $halfStep -le $size) { $sum += $grid[$y][$x + $halfStep]; $count++ }

            $grid[$y][$x] = $sum / $count + ($rand.NextDouble() - 0.5) * $scale
        }
    }

    $stepSize = $halfStep
    $scale *= 0.5
}

# Render
for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $value = $grid[$row][$col]
        $normalized = Clamp -Value $value -Min 0 -Max 1

        # Multi-hue plasma effect
        $hue = (0.5 + $normalized * 0.4 + [math]::Sin($normalized * 6.28) * 0.15) % 1
        $saturation = 0.7 + 0.25 * [math]::Abs([math]::Sin($normalized * 3.14))
        $brightness = 0.35 + 0.6 * $normalized

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $brightness

        $symbol = if ($normalized -gt 0.8) { '█' }
        elseif ($normalized -gt 0.6) { '▓' }
        elseif ($normalized -gt 0.4) { '▒' }
        elseif ($normalized -gt 0.2) { '░' }
        else { '·' }

        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
