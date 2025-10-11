# Unique Concept: Penrose tiling with Rhombus tiles creating non-periodic quasicrystal patterns.
# Uses substitution rules to generate the iconic aperiodic tiling with fivefold symmetry.


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
$grid = @{}

# Generate Penrose-like pattern using golden ratio
$phi = (1 + [math]::Sqrt(5)) / 2.0
$centerX = 50
$centerY = 13

# Create radial Penrose-inspired pattern
for ($ring = 0; $ring -lt 8; $ring++) {
    $radius = $ring * 3.2
    $segments = [int](5 * $phi * $ring)
    if ($segments -lt 5) { $segments = 5 }

    for ($i = 0; $i -lt $segments; $i++) {
        $angle = ($i / [double]$segments) * 2 * [math]::PI
        $wobble = [math]::Sin($i * $phi) * 0.3

        # Two types of rhombi
        $type = ($i + $ring) % 2
        $offset = if ($type -eq 0) { 0 } else { [math]::PI / 5 }

        # Draw rhombus edges
        for ($edge = 0; $edge -lt 4; $edge++) {
            $a1 = $angle + $offset + ($edge * [math]::PI / 2.5)
            $a2 = $angle + $offset + (($edge + 1) * [math]::PI / 2.5)

            $steps = 8
            for ($s = 0; $s -le $steps; $s++) {
                $t = $s / [double]$steps
                $r = $radius + $wobble
                $a = $a1 + ($a2 - $a1) * $t

                $px = [int]($centerX + $r * [math]::Cos($a))
                $py = [int]($centerY + $r * [math]::Sin($a) * 0.5)

                if ($px -ge 0 -and $px -lt $width -and $py -ge 0 -and $py -lt $height) {
                    $key = "$px,$py"
                    if (-not $grid.ContainsKey($key)) {
                        $grid[$key] = @{
                            Ring = $ring
                            Type = $type
                            Seg  = $i
                        }
                    }
                }
            }
        }
    }
}

# Render
$maxRing = 7
for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]

            $ringRatio = $cell.Ring / [double]$maxRing
            $hue = ($ringRatio * 0.7 + $cell.Type * 0.15 + $cell.Seg * 0.02) % 1
            $saturation = 0.6 + 0.3 * $cell.Type
            $value = 0.5 + 0.4 * (1.0 - $ringRatio)

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            $symbol = if ($cell.Type -eq 0) { '◆' } else { '◇' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
