# Unique Concept: Static flow field with streamlines and vector field visualization.

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

# Generate flow field
$flowField = @{}
for ($x = 0; $x -lt $width; $x++) {
    for ($y = 0; $y -lt $height; $y++) {
        # Perlin-like noise for flow direction
        $angle = [math]::Sin($x * 0.1) * [math]::Cos($y * 0.15) + [math]::Sin($x * 0.05 + $y * 0.08) * 2
        $flowField["$x,$y"] = $angle
    }
}

# Generate streamlines
$streamlines = @()
$numStreamlines = 20

for ($i = 0; $i -lt $numStreamlines; $i++) {
    $startX = $i * 6
    $startY = 5 + ($i % 2) * 20
    $streamline = @()

    $currentX = $startX
    $currentY = $startY
    $steps = 50

    for ($step = 0; $step -lt $steps; $step++) {
        if ($currentX -ge 0 -and $currentX -lt $width -and $currentY -ge 0 -and $currentY -lt $height) {
            $streamline += @{ X = [int]$currentX; Y = [int]$currentY }
            $angle = $flowField["$([int]$currentX),$([int]$currentY)"]
            $currentX += [math]::Cos($angle) * 0.5
            $currentY += [math]::Sin($angle) * 0.5
        }
        else {
            break
        }
    }

    $streamlines += $streamline
}

# Create density grid
$grid = @{}
foreach ($streamline in $streamlines) {
    foreach ($point in $streamline) {
        $key = "$($point.X),$($point.Y)"
        if (-not $grid.ContainsKey($key)) {
            $grid[$key] = 0
        }
        $grid[$key]++
    }
}

for ($y = 0; $y -lt $height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        $key = "$x,$y"

        if ($grid.ContainsKey($key)) {
            $density = $grid[$key]
            $angle = $flowField[$key]

            $hue = ($angle / (2 * [math]::PI) + 0.5) % 1
            $saturation = 0.8
            $value = 0.4 + 0.6 * [math]::Min($density / 5.0, 1.0)

            $symbols = @('·', '◦', '●', '◉', '◎')
            $symbol = $symbols[[math]::Min([int]($density / 2), 4)]
        }
        else {
            $angle = $flowField[$key]
            $hue = ($angle / (2 * [math]::PI) + 0.5) % 1
            $saturation = 0.3
            $value = 0.1
            $symbol = ' '
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
