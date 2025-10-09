# Unique Concept: Fourier epicycles drawing a path - multiple circles rotating to trace a complex curve.
# Demonstrates how combining circular motions at different frequencies creates intricate patterns.

# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

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

function Clamp {
    param([double]$Value, [double]$Min, [double]$Max)
    if ($Value -lt $Min) { return $Min }
    if ($Value -gt $Max) { return $Max }
    return $Value
}

$width = 120
$height = 40

# Define epicycle parameters: radius, frequency, phase
$epicycles = @(
    @{ Radius = 0.45; Freq = 1; Phase = 0 },
    @{ Radius = 0.25; Freq = -3; Phase = 1.2 },
    @{ Radius = 0.15; Freq = 5; Phase = 0.5 },
    @{ Radius = 0.12; Freq = -7; Phase = 2.1 },
    @{ Radius = 0.08; Freq = 11; Phase = 0.8 },
    @{ Radius = 0.06; Freq = -13; Phase = 1.7 },
    @{ Radius = 0.04; Freq = 17; Phase = 0.3 }
)

# Generate the path traced by epicycles
$pathPoints = @()
$steps = 360
for ($step = 0; $step -lt $steps; $step++) {
    $t = ($step / [double]$steps) * 2 * [math]::PI

    $x = 0.0
    $y = 0.0

    foreach ($epi in $epicycles) {
        $angle = $t * $epi.Freq + $epi.Phase
        $x += $epi.Radius * [math]::Cos($angle)
        $y += $epi.Radius * [math]::Sin($angle)
    }

    $pathPoints += @{ X = $x; Y = $y; T = $t }
}

# Also calculate current epicycle positions for visualization
$currentT = (([DateTime]::Now.Ticks / 10000000.0) % 10) / 10.0 * 2 * [math]::PI
$circles = @()
$cx = 0.0
$cy = 0.0

foreach ($epi in $epicycles) {
    $angle = $currentT * $epi.Freq + $epi.Phase
    $nextX = $cx + $epi.Radius * [math]::Cos($angle)
    $nextY = $cy + $epi.Radius * [math]::Sin($angle)

    $circles += @{
        CenterX = $cx
        CenterY = $cy
        Radius  = $epi.Radius
        EndX    = $nextX
        EndY    = $nextY
    }

    $cx = $nextX
    $cy = $nextY
}

# Create grid
$grid = @{}

# Draw the traced path
foreach ($pt in $pathPoints) {
    $gridX = [int](($pt.X + 1.2) / 2.4 * ($width - 1))
    $gridY = [int](($pt.Y + 0.8) / 1.6 * ($height - 1))

    if ($gridX -ge 0 -and $gridX -lt $width -and $gridY -ge 0 -and $gridY -lt $height) {
        $key = "$gridX,$gridY"
        $grid[$key] = [pscustomobject]@{
            Type = 'Path'
            T    = $pt.T / (2 * [math]::PI)
        }
    }
}

# Draw current epicycle circles
foreach ($circ in $circles) {
    # Draw circle outline
    for ($angle = 0; $angle -lt 360; $angle += 8) {
        $rad = $angle * [math]::PI / 180.0
        $px = $circ.CenterX + $circ.Radius * [math]::Cos($rad)
        $py = $circ.CenterY + $circ.Radius * [math]::Sin($rad)

        $gridX = [int](($px + 1.2) / 2.4 * ($width - 1))
        $gridY = [int](($py + 0.8) / 1.6 * ($height - 1))

        if ($gridX -ge 0 -and $gridX -lt $width -and $gridY -ge 0 -and $gridY -lt $height) {
            $key = "$gridX,$gridY"
            if (-not $grid.ContainsKey($key)) {
                $grid[$key] = [pscustomobject]@{ Type = 'Circle' }
            }
        }
    }

    # Draw arm from center to end
    $steps = 20
    for ($i = 0; $i -le $steps; $i++) {
        $t = $i / [double]$steps
        $px = $circ.CenterX + ($circ.EndX - $circ.CenterX) * $t
        $py = $circ.CenterY + ($circ.EndY - $circ.CenterY) * $t

        $gridX = [int](($px + 1.2) / 2.4 * ($width - 1))
        $gridY = [int](($py + 0.8) / 1.6 * ($height - 1))

        if ($gridX -ge 0 -and $gridX -lt $width -and $gridY -ge 0 -and $gridY -lt $height) {
            $key = "$gridX,$gridY"
            if (-not $grid.ContainsKey($key)) {
                $grid[$key] = [pscustomobject]@{ Type = 'Arm' }
            }
        }
    }
}

# Render
for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]

            if ($cell.Type -eq 'Path') {
                $hue = ($cell.T * 0.8 + 0.1) % 1
                $saturation = 0.85
                $value = 0.9
                $symbol = '●'
            }
            elseif ($cell.Type -eq 'Circle') {
                $hue = 0.55
                $saturation = 0.6
                $value = 0.7
                $symbol = '○'
            }
            else {
                # Arm
                $hue = 0.15
                $saturation = 0.7
                $value = 0.6
                $symbol = '─'
            }

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;10;10;15m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
