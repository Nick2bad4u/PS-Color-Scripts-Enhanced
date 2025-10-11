# Unique Concept: Boids flocking algorithm - simulates bird/fish swarm behavior with cohesion, separation, and alignment.
# Each boid follows three rules creating emergent collective motion patterns colored by velocity and density.

# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

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

$width = 90
$height = 30
$numBoids = 200  # Increased for more detail
$rand = [System.Random]::new(789)

# Initialize boids with random positions and velocities
$boids = for ($i = 0; $i -lt $numBoids; $i++) {
    [pscustomobject]@{
        X  = $rand.NextDouble() * $width
        Y  = $rand.NextDouble() * $height
        Vx = ($rand.NextDouble() - 0.5) * 2.0
        Vy = ($rand.NextDouble() - 0.5) * 2.0
    }
}

# Simulate several steps to create interesting patterns
$steps = 15
for ($step = 0; $step -lt $steps; $step++) {
    foreach ($boid in $boids) {
        # Flocking rules
        $cohesionX = 0.0
        $cohesionY = 0.0
        $separationX = 0.0
        $separationY = 0.0
        $alignmentX = 0.0
        $alignmentY = 0.0
        $nearCount = 0

        foreach ($other in $boids) {
            if ($other -eq $boid) { continue }

            $dx = $other.X - $boid.X
            $dy = $other.Y - $boid.Y
            $dist = [math]::Sqrt($dx * $dx + $dy * $dy)

            if ($dist -lt 15) {
                # Cohesion - move toward average position
                $cohesionX += $other.X
                $cohesionY += $other.Y

                # Alignment - match velocity
                $alignmentX += $other.Vx
                $alignmentY += $other.Vy

                $nearCount++

                # Separation - avoid crowding
                if ($dist -lt 5 -and $dist -gt 0) {
                    $separationX -= $dx / $dist
                    $separationY -= $dy / $dist
                }
            }
        }

        if ($nearCount -gt 0) {
            $cohesionX = ($cohesionX / $nearCount - $boid.X) * 0.01
            $cohesionY = ($cohesionY / $nearCount - $boid.Y) * 0.01
            $alignmentX = ($alignmentX / $nearCount) * 0.08
            $alignmentY = ($alignmentY / $nearCount) * 0.08
        }

        $separationX *= 0.1
        $separationY *= 0.1

        # Update velocity
        $boid.Vx += $cohesionX + $separationX + $alignmentX
        $boid.Vy += $cohesionY + $separationY + $alignmentY

        # Limit speed
        $speed = [math]::Sqrt($boid.Vx * $boid.Vx + $boid.Vy * $boid.Vy)
        if ($speed -gt 3.0) {
            $boid.Vx = ($boid.Vx / $speed) * 3.0
            $boid.Vy = ($boid.Vy / $speed) * 3.0
        }
    }

    # Update positions
    foreach ($boid in $boids) {
        $boid.X += $boid.Vx
        $boid.Y += $boid.Vy

        # Wrap around edges
        if ($boid.X -lt 0) { $boid.X += $width }
        if ($boid.X -ge $width) { $boid.X -= $width }
        if ($boid.Y -lt 0) { $boid.Y += $height }
        if ($boid.Y -ge $height) { $boid.Y -= $height }
    }
}

# Create density and velocity heatmap
$grid = @{}
foreach ($boid in $boids) {
    $gx = [int]$boid.X
    $gy = [int]$boid.Y

    if ($gx -ge 0 -and $gx -lt $width -and $gy -ge 0 -and $gy -lt $height) {
        $key = "$gx,$gy"
        $speed = [math]::Sqrt($boid.Vx * $boid.Vx + $boid.Vy * $boid.Vy)

        if ($grid.ContainsKey($key)) {
            $grid[$key].Count++
            $grid[$key].Speed += $speed
        }
        else {
            $grid[$key] = [pscustomobject]@{
                Count = 1
                Speed = $speed
                Vx    = $boid.Vx
                Vy    = $boid.Vy
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
            $avgSpeed = $cell.Speed / $cell.Count

            # Color by speed and density
            $hue = (0.55 + $avgSpeed * 0.15) % 1
            $saturation = Clamp -Value (0.5 + 0.4 * ($cell.Count / 5.0)) -Min 0 -Max 1
            $value = Clamp -Value (0.35 + 0.6 * ($avgSpeed / 3.0)) -Min 0.3 -Max 1.0

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            # Symbol shows direction
            $angle = [math]::Atan2($cell.Vy, $cell.Vx)
            $octant = [int](($angle + [math]::PI) / (2 * [math]::PI) * 8) % 8

            $symbol = switch ($octant) {
                0 { '→' }
                1 { '↗' }
                2 { '↑' }
                3 { '↖' }
                4 { '←' }
                5 { '↙' }
                6 { '↓' }
                7 { '↘' }
                default { '●' }
            }

            if ($cell.Count -gt 3) { $symbol = '◉' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;10;10;15m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
