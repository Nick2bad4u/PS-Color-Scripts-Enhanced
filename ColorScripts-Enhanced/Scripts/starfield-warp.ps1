# Unique Concept: Starfield warp effect with motion blur and relativistic color shifting.
# Stars stream past with velocity-based trails creating a hyperspace jump visual.

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

$width = 110
$height = 26
$rand = [System.Random]::new(888)

# Generate stars with radial positions
$stars = for ($i = 0; $i -lt 200; $i++) {
    $angle = $rand.NextDouble() * 2 * [math]::PI
    $distance = 0.1 + $rand.NextDouble() * 0.9

    @{
        Angle    = $angle
        Distance = $distance
        Hue      = $rand.NextDouble()
        Speed    = 0.5 + $rand.NextDouble() * 1.5
    }
}

$grid = @{}
$centerX = 55
$centerY = 13

foreach ($star in $stars) {
    # Warp speed increases with distance
    $warpDist = $star.Distance + $star.Speed * 0.15

    # Draw star trail
    $trailSteps = [int]($star.Speed * 12)
    for ($t = 0; $t -lt $trailSteps; $t++) {
        $trailDist = $star.Distance + ($warpDist - $star.Distance) * ($t / [double]$trailSteps)

        $px = [int]($centerX + $trailDist * 50 * [math]::Cos($star.Angle))
        $py = [int]($centerY + $trailDist * 22 * [math]::Sin($star.Angle))

        if ($px -ge 0 -and $px -lt $width -and $py -ge 0 -and $py -lt $height) {
            $key = "$px,$py"
            $intensity = ($t / [double]$trailSteps) * $star.Speed

            if (-not $grid.ContainsKey($key) -or $grid[$key].Intensity -lt $intensity) {
                $grid[$key] = @{
                    Intensity = $intensity
                    Hue       = $star.Hue
                    Distance  = $trailDist
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

            # Blue-shift effect at high speed
            $hue = ($cell.Hue + 0.5 + $cell.Intensity * 0.2) % 1
            $saturation = 0.6 + 0.35 * $cell.Intensity
            $value = 0.3 + 0.65 * $cell.Intensity

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            $symbol = if ($cell.Intensity -gt 1.5) { '━' }
            elseif ($cell.Intensity -gt 1.0) { '─' }
            elseif ($cell.Intensity -gt 0.5) { '∙' }
            else { '·' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;5;5;8m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
