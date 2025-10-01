# Unique Concept: Verlet physics rope simulation with hanging chains and wave propagation.
# Shows connected particles with constraint satisfaction creating realistic swaying motion.

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

# Create multiple ropes
$ropes = @()
for ($ropeId = 0; $ropeId -lt 5; $ropeId++) {
    $anchorX = 15 + $ropeId * 18
    $particles = for ($i = 0; $i -lt 20; $i++) {
        @{
            X     = $anchorX + [math]::Sin($i * 0.5 + $ropeId) * 2
            Y     = $i * 1.2
            OldX  = $anchorX + [math]::Sin($i * 0.5 + $ropeId) * 2
            OldY  = $i * 1.2
            Fixed = ($i -eq 0)
        }
    }
    $ropes += , @{ Particles = $particles; Hue = $ropeId / 5.0 }
}

# Simulate Verlet integration
$iterations = 8
for ($sim = 0; $sim -lt $iterations; $sim++) {
    foreach ($rope in $ropes) {
        # Update positions
        foreach ($p in $rope.Particles) {
            if ($p.Fixed) { continue }

            $vx = $p.X - $p.OldX
            $vy = $p.Y - $p.OldY

            $p.OldX = $p.X
            $p.OldY = $p.Y

            $p.X += $vx * 0.98 + [math]::Sin($sim * 0.3) * 0.15
            $p.Y += $vy * 0.98 + 0.08  # Gravity
        }

        # Constraint satisfaction
        for ($iter = 0; $iter -lt 3; $iter++) {
            for ($i = 0; $i -lt ($rope.Particles.Count - 1); $i++) {
                $p1 = $rope.Particles[$i]
                $p2 = $rope.Particles[$i + 1]

                $dx = $p2.X - $p1.X
                $dy = $p2.Y - $p1.Y
                $dist = [math]::Sqrt($dx * $dx + $dy * $dy)
                $targetDist = 1.2

                if ($dist -gt 0.01) {
                    $diff = ($targetDist - $dist) / $dist * 0.5
                    $offsetX = $dx * $diff
                    $offsetY = $dy * $diff

                    if (-not $p1.Fixed) {
                        $p1.X -= $offsetX
                        $p1.Y -= $offsetY
                    }
                    if (-not $p2.Fixed) {
                        $p2.X += $offsetX
                        $p2.Y += $offsetY
                    }
                }
            }
        }
    }
}

# Render
$grid = @{}
foreach ($rope in $ropes) {
    for ($i = 0; $i -lt ($rope.Particles.Count - 1); $i++) {
        $p1 = $rope.Particles[$i]
        $p2 = $rope.Particles[$i + 1]

        # Draw line between particles
        $steps = 5
        for ($s = 0; $s -le $steps; $s++) {
            $t = $s / [double]$steps
            $x = [int]($p1.X + ($p2.X - $p1.X) * $t)
            $y = [int]($p1.Y + ($p2.Y - $p1.Y) * $t)

            if ($x -ge 0 -and $x -lt $width -and $y -ge 0 -and $y -lt $height) {
                $key = "$x,$y"
                $grid[$key] = @{
                    Hue   = $rope.Hue
                    Index = $i
                }
            }
        }
    }
}

for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]

            $hue = ($cell.Hue + $cell.Index * 0.03) % 1
            $saturation = 0.7
            $value = 0.9 - $cell.Index * 0.02

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $symbol = '●'

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
