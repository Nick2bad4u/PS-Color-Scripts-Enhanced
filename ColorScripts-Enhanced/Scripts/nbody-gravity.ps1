# Unique Concept: N-body gravitational simulation showing orbital mechanics and gravitational lensing effects.
# Multiple masses interact via Newton's law of gravitation, creating dynamic orbital patterns.


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
$G = 0.5  # Gravitational constant

# Initialize bodies with mass, position, velocity
$bodies = @(
    @{ Mass = 50.0; X = 60.0; Y = 20.0; Vx = 0.0; Vy = 0.3; Hue = 0.05 },
    @{ Mass = 30.0; X = 80.0; Y = 25.0; Vx = 0.0; Vy = -0.4; Hue = 0.15 },
    @{ Mass = 25.0; X = 50.0; Y = 15.0; Vx = 0.35; Vy = 0.0; Hue = 0.55 },
    @{ Mass = 20.0; X = 70.0; Y = 30.0; Vx = -0.3; Vy = 0.15; Hue = 0.65 },
    @{ Mass = 15.0; X = 55.0; Y = 28.0; Vx = 0.2; Vy = -0.25; Hue = 0.8 }
)

# Simulate orbital motion and collect trail data
$trails = New-Object 'System.Collections.Generic.List[object]'
$steps = 180
$dt = 0.15

for ($step = 0; $step -lt $steps; $step++) {
    # Calculate gravitational forces
    foreach ($body in $bodies) {
        $body.Ax = 0.0
        $body.Ay = 0.0

        foreach ($other in $bodies) {
            if ($body -eq $other) { continue }

            $dx = $other.X - $body.X
            $dy = $other.Y - $body.Y
            $distSq = $dx * $dx + $dy * $dy

            # Prevent singularities
            if ($distSq -lt 1.0) { $distSq = 1.0 }

            $dist = [math]::Sqrt($distSq)
            $force = $G * $other.Mass / $distSq

            $body.Ax += $force * ($dx / $dist)
            $body.Ay += $force * ($dy / $dist)
        }
    }

    # Update velocities and positions
    foreach ($body in $bodies) {
        $body.Vx += $body.Ax * $dt
        $body.Vy += $body.Ay * $dt
        $body.X += $body.Vx * $dt
        $body.Y += $body.Vy * $dt

        # Record trail
        $trails.Add([pscustomobject]@{
                X   = $body.X
                Y   = $body.Y
                Hue = $body.Hue
                Age = $step
            })
    }
}

# Create grid with trail intensities
$grid = @{}
$maxAge = $steps

foreach ($point in $trails) {
    $gx = [int]$point.X
    $gy = [int]$point.Y

    if ($gx -ge 0 -and $gx -lt $width -and $gy -ge 0 -and $gy -lt $height) {
        $key = "$gx,$gy"
        $age = $point.Age / [double]$maxAge

        if ($grid.ContainsKey($key)) {
            $grid[$key].Count++
            if ($age -gt $grid[$key].Age) {
                $grid[$key].Age = $age
                $grid[$key].Hue = $point.Hue
            }
        }
        else {
            $grid[$key] = [pscustomobject]@{
                Count = 1
                Age   = $age
                Hue   = $point.Hue
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

            # Color by body hue, brightness by recency and density
            $hue = $cell.Hue
            $saturation = Clamp -Value (0.6 + 0.35 * $cell.Age) -Min 0 -Max 1
            $value = Clamp -Value (0.25 + 0.7 * $cell.Age + 0.15 * ($cell.Count / 10.0)) -Min 0.2 -Max 1.0

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            # Symbol by density
            if ($cell.Count -gt 8) { $symbol = '◉' }
            elseif ($cell.Count -gt 5) { $symbol = '●' }
            elseif ($cell.Count -gt 3) { $symbol = '◎' }
            elseif ($cell.Count -gt 1) { $symbol = '∙' }
            else { $symbol = '·' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
