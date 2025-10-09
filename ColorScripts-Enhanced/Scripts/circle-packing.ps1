# Unique Concept: Circle packing algorithm with growing circles filling space organically.
# Circles expand until touching neighbors creating an efficient space-filling pattern.

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
$rand = [System.Random]::new(101)

# Initialize circles at random positions
$circles = for ($i = 0; $i -lt 150; $i++) {
    @{
        X   = $rand.Next($width)
        Y   = $rand.Next($height)
        R   = 0.5
        Hue = $rand.NextDouble()
    }
}

# Grow circles
$growthSteps = 25
for ($step = 0; $step -lt $growthSteps; $step++) {
    foreach ($circ in $circles) {
        # Check if can grow
        $canGrow = $true
        $maxR = 15.0

        # Check distance to all other circles
        foreach ($other in $circles) {
            if ($circ -eq $other) { continue }

            $dx = $circ.X - $other.X
            $dy = $circ.Y - $other.Y
            $dist = [math]::Sqrt($dx * $dx + $dy * $dy)

            # Must maintain gap
            $minDist = $circ.R + $other.R + 0.8
            if ($dist -lt $minDist) {
                $canGrow = $false
                break
            }
        }

        # Check bounds
        if ($circ.X - $circ.R -lt 0 -or $circ.X + $circ.R -gt $width - 1 -or
            $circ.Y - $circ.R -lt 0 -or $circ.Y + $circ.R -gt $height - 1) {
            $canGrow = $false
        }

        if ($canGrow -and $circ.R -lt $maxR) {
            $circ.R += 0.3
        }
    }
}

# Render
$grid = @{}

foreach ($circ in $circles) {
    # Draw filled circle
    for ($y = [int]($circ.Y - $circ.R); $y -le [int]($circ.Y + $circ.R); $y++) {
        for ($x = [int]($circ.X - $circ.R); $x -le [int]($circ.X + $circ.R); $x++) {
            if ($x -ge 0 -and $x -lt $width -and $y -ge 0 -and $y -lt $height) {
                $dx = $x - $circ.X
                $dy = $y - $circ.Y
                $dist = [math]::Sqrt($dx * $dx + $dy * $dy)

                if ($dist -le $circ.R) {
                    $key = "$x,$y"
                    $edgeDist = $circ.R - $dist

                    if (-not $grid.ContainsKey($key) -or $grid[$key].R -lt $circ.R) {
                        $grid[$key] = @{
                            Hue      = $circ.Hue
                            R        = $circ.R
                            EdgeDist = $edgeDist
                        }
                    }
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

            $hue = $cell.Hue
            $saturation = 0.65 + 0.3 * ($cell.R / 15.0)
            $edgeRatio = $cell.EdgeDist / $cell.R
            $value = 0.4 + 0.5 * $edgeRatio

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            $symbol = if ($edgeRatio -lt 0.15) { '○' }
            elseif ($cell.R -gt 8) { '●' }
            elseif ($cell.R -gt 4) { '◉' }
            else { '∙' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
