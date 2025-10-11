# Unique Concept: Conway's Game of Life with persistent trails showing the history of cell evolution.
# Each cell leaves a fading trail as patterns emerge, stabilize, or create gliders.

# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

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

$width = 90
$height = 24
$iterations = 45
$rand = [System.Random]::new(999)

# Initialize random grid
$grid = [bool[][]]::new($height)
for ($y = 0; $y -lt $height; $y++) {
    $grid[$y] = [bool[]]::new($width)
    for ($x = 0; $x -lt $width; $x++) {
        $grid[$y][$x] = $rand.NextDouble() -lt 0.25
    }
}

# Track activity history
$history = @{}

# Simulate Game of Life
for ($gen = 0; $gen -lt $iterations; $gen++) {
    $next = [bool[][]]::new($height)
    for ($y = 0; $y -lt $height; $y++) {
        $next[$y] = [bool[]]::new($width)
    }

    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            # Count neighbors
            $neighbors = 0
            for ($dy = -1; $dy -le 1; $dy++) {
                for ($dx = -1; $dx -le 1; $dx++) {
                    if ($dx -eq 0 -and $dy -eq 0) { continue }
                    $ny = ($y + $dy + $height) % $height
                    $nx = ($x + $dx + $width) % $width
                    if ($grid[$ny][$nx]) { $neighbors++ }
                }
            }

            # Apply rules
            if ($grid[$y][$x]) {
                $next[$y][$x] = ($neighbors -eq 2 -or $neighbors -eq 3)
            }
            else {
                $next[$y][$x] = ($neighbors -eq 3)
            }

            # Record history
            if ($next[$y][$x]) {
                $key = "$x,$y"
                $history[$key] = $gen
            }
        }
    }
    $grid = $next
}

# Render with trails
for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($history.ContainsKey($key)) {
            $lastSeen = $history[$key] / [double]$iterations
            $isAlive = $grid[$row][$col]

            $hue = (0.3 + $lastSeen * 0.4) % 1
            $saturation = if ($isAlive) { 0.85 } else { 0.4 }
            $value = if ($isAlive) { 0.9 } else { 0.25 + 0.5 * $lastSeen }

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $symbol = if ($isAlive) { '█' } else { '░' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
