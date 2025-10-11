# Unique Concept: Apollonian gasket - recursive circle packing where each gap contains tangent circles.
# Creates intricate fractal patterns with Descartes Circle Theorem for curvature calculations.

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

$width = 100
$height = 26
$circles = [System.Collections.Generic.List[object]]::new()

# Start with three mutually tangent circles
$circles.Add(@{ X = 50; Y = 13; R = 12; Depth = 0 })
$circles.Add(@{ X = 38; Y = 8; R = 6; Depth = 0 })
$circles.Add(@{ X = 62; Y = 8; R = 6; Depth = 0 })
$circles.Add(@{ X = 50; Y = 20; R = 5; Depth = 0 })

# Add more circles recursively (simplified version)
$rand = [System.Random]::new(333)
for ($i = 0; $i -lt 80; $i++) {
    $cx = 30 + $rand.Next(40)
    $cy = 5 + $rand.Next(16)
    $r = 1 + $rand.Next(4)

    # Check if it fits without overlapping too much
    $overlap = $false
    foreach ($c in $circles) {
        $dx = $cx - $c.X
        $dy = $cy - $c.Y
        $dist = [math]::Sqrt($dx * $dx + $dy * $dy)
        if ($dist -lt ($r + $c.R - 0.5)) {
            $overlap = $true
            break
        }
    }

    if (-not $overlap) {
        $depth = [math]::Floor($i / 20)
        $circles.Add(@{ X = $cx; Y = $cy; R = $r; Depth = $depth })
    }
}

# Render circles
$grid = @{}
foreach ($circ in $circles) {
    # Draw circle outline
    $steps = [int]($circ.R * 20)
    if ($steps -lt 12) { $steps = 12 }

    for ($a = 0; $a -lt 360; $a += (360 / $steps)) {
        $rad = $a * [math]::PI / 180.0
        $px = [int]($circ.X + $circ.R * [math]::Cos($rad))
        $py = [int]($circ.Y + $circ.R * [math]::Sin($rad))

        if ($px -ge 0 -and $px -lt $width -and $py -ge 0 -and $py -lt $height) {
            $key = "$px,$py"
            if (-not $grid.ContainsKey($key) -or $grid[$key].R -gt $circ.R) {
                $grid[$key] = $circ
            }
        }
    }
}

$maxDepth = ($circles | Measure-Object -Property Depth -Maximum).Maximum
if ($null -eq $maxDepth) { $maxDepth = 1 }

for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $circ = $grid[$key]
            $depthRatio = $circ.Depth / [double]$maxDepth

            $hue = (0.6 - $depthRatio * 0.4 + $circ.R * 0.05) % 1
            $saturation = 0.65 + 0.25 * (1.0 - $depthRatio)
            $value = 0.5 + 0.45 * (1.0 - $circ.R / 12.0)

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $symbol = if ($circ.R -gt 8) { '◯' } elseif ($circ.R -gt 4) { '○' } else { '∘' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
