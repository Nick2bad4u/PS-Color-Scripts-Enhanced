# Unique Concept: Langton's Ant - a cellular automaton where an "ant" creates emergent ordered patterns from chaos.
# The ant follows simple rules: turn right on white, left on black, flip color, move forward.

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

$width = 110
$height = 30

# Grid: 0 = white, values > 0 = black (with step count)
$grid = @{}

# Ant state
$antX = 55
$antY = 15
$antDir = 0  # 0=up, 1=right, 2=down, 3=left

# Simulate ant movement
$steps = 12000
for ($step = 1; $step -le $steps; $step++) {
    $key = "$antX,$antY"

    # Get current cell state
    $isBlack = $grid.ContainsKey($key)

    if ($isBlack) {
        # Turn left
        $antDir = ($antDir + 3) % 4
        # Flip to white (remove from grid)
        $grid.Remove($key)
    }
    else {
        # Turn right
        $antDir = ($antDir + 1) % 4
        # Flip to black
        $grid[$key] = $step
    }

    # Move forward
    switch ($antDir) {
        0 { $antY-- }  # Up
        1 { $antX++ }  # Right
        2 { $antY++ }  # Down
        3 { $antX-- }  # Left
    }

    # Wrap around
    if ($antX -lt 0) { $antX = $width - 1 }
    if ($antX -ge $width) { $antX = 0 }
    if ($antY -lt 0) { $antY = $height - 1 }
    if ($antY -ge $height) { $antY = 0 }
}

# Render
for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($col -eq $antX -and $row -eq $antY) {
            # Ant position
            $rgb = Convert-HsvToRgb -Hue 0.05 -Saturation 1.0 -Value 1.0
            $symbol = '◉'
        }
        elseif ($grid.ContainsKey($key)) {
            # Black cell - color by age
            $age = $grid[$key] / [double]$steps
            $hue = (0.5 + $age * 0.4) % 1
            $saturation = 0.7
            $value = 0.4 + 0.5 * $age

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $symbol = '█'
        }
        else {
            # White cell
            $null = $sb.Append("$esc[38;2;18;18;22m ")
            continue
        }

        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
