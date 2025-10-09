# Unique Concept: Particle cyclone with centripetal force creating a swirling vortex.
# Particles spiral inward with velocity-based streaking and density gradients.

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

$width = 100
$height = 26
$rand = [System.Random]::new(234)

# Initialize particles
$particles = for ($i = 0; $i -lt 180; $i++) {
    $angle = $rand.NextDouble() * 2 * [math]::PI
    $radius = 15 + $rand.NextDouble() * 30

    @{
        X     = 50 + $radius * [math]::Cos($angle)
        Y     = 13 + $radius * [math]::Sin($angle) * 0.6
        Angle = $angle
        R     = $radius
        Hue   = $rand.NextDouble()
    }
}

$grid = @{}

# Simulate spiral motion
$steps = 25
foreach ($p in $particles) {
    for ($s = 0; $s -lt $steps; $s++) {
        $t = $s / [double]$steps

        # Spiral inward with rotation
        $r = $p.R * (1.0 - $t * 0.85)
        $angle = $p.Angle + $t * 8.0

        $x = 50 + $r * [math]::Cos($angle)
        $y = 13 + $r * [math]::Sin($angle) * 0.6

        $gx = [int]$x
        $gy = [int]$y

        if ($gx -ge 0 -and $gx -lt $width -and $gy -ge 0 -and $gy -lt $height) {
            $key = "$gx,$gy"
            $speed = 1.0 - $r / 45.0

            if ($grid.ContainsKey($key)) {
                $grid[$key].Count++
                $grid[$key].Speed += $speed
                $grid[$key].Hue += $p.Hue
            }
            else {
                $grid[$key] = @{
                    Count = 1
                    Speed = $speed
                    Hue   = $p.Hue
                    T     = $t
                }
            }
        }
    }
}

# Render
for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]

            $avgHue = ($cell.Hue / $cell.Count + 0.5) % 1
            $avgSpeed = $cell.Speed / $cell.Count

            $hue = ($avgHue + $cell.T * 0.2) % 1
            $saturation = 0.65 + 0.3 * $avgSpeed
            $value = 0.3 + 0.65 * $avgSpeed

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            $symbol = if ($cell.Count -gt 6) { '◉' }
            elseif ($cell.Count -gt 3) { '●' }
            elseif ($cell.Count -gt 1) { '◦' }
            else { '·' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
