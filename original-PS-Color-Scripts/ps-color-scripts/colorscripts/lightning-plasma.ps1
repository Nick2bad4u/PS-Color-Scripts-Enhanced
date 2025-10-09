# Unique Concept: Electric plasma discharge with branching lightning bolts using fractal branching.
# Simulates Lichtenberg figures with probability-based branching and glow effects.

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
$rand = [System.Random]::new(777)

# Lightning branches
$branches = New-Object 'System.Collections.Generic.List[object]'
$branches.Add(@{ X = 50; Y = 0; Vx = 0; Vy = 1; Energy = 100; Depth = 0 })

$grid = @{}
$maxDepth = 0

while ($branches.Count -gt 0 -and $branches.Count -lt 600) {
    $branch = $branches[0]
    $branches.RemoveAt(0)

    if ($branch.Energy -lt 5) { continue }

    # Move branch
    $steps = 3
    for ($s = 0; $s -lt $steps; $s++) {
        $branch.X += $branch.Vx + ($rand.NextDouble() - 0.5) * 0.8
        $branch.Y += $branch.Vy + ($rand.NextDouble() - 0.5) * 0.3

        $gx = [int]$branch.X
        $gy = [int]$branch.Y

        if ($gx -ge 0 -and $gx -lt $width -and $gy -ge 0 -and $gy -lt $height) {
            $key = "$gx,$gy"
            if (-not $grid.ContainsKey($key) -or $grid[$key].Energy -lt $branch.Energy) {
                $grid[$key] = @{
                    Energy = $branch.Energy
                    Depth  = $branch.Depth
                }
                if ($branch.Depth -gt $maxDepth) { $maxDepth = $branch.Depth }
            }
        }

        # Check bounds
        if ($gx -lt 0 -or $gx -ge $width -or $gy -lt 0 -or $gy -ge $height) {
            $branch.Energy = 0
            break
        }
    }

    # Random branching
    if ($rand.NextDouble() -lt 0.15 -and $branch.Energy -gt 20) {
        $angle1 = [math]::Atan2($branch.Vy, $branch.Vx) + ($rand.NextDouble() - 0.5) * 1.2
        $angle2 = [math]::Atan2($branch.Vy, $branch.Vx) - ($rand.NextDouble() - 0.5) * 1.2

        $branches.Add(@{
                X      = $branch.X
                Y      = $branch.Y
                Vx     = [math]::Cos($angle1)
                Vy     = [math]::Sin($angle1)
                Energy = $branch.Energy * 0.6
                Depth  = $branch.Depth + 1
            })

        if ($rand.NextDouble() -lt 0.4) {
            $branches.Add(@{
                    X      = $branch.X
                    Y      = $branch.Y
                    Vx     = [math]::Cos($angle2)
                    Vy     = [math]::Sin($angle2)
                    Energy = $branch.Energy * 0.5
                    Depth  = $branch.Depth + 1
                })
        }
    }

    $branch.Energy -= 2
    if ($branch.Energy -gt 5) {
        $branches.Add($branch)
    }
}

# Render
for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]

            $energyRatio = $cell.Energy / 100.0
            $hue = 0.55 + 0.1 * $energyRatio
            $saturation = 0.8
            $value = 0.5 + 0.5 * $energyRatio

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            $symbol = if ($energyRatio -gt 0.7) { '╬' }
            elseif ($energyRatio -gt 0.4) { '┼' }
            elseif ($energyRatio -gt 0.2) { '┿' }
            else { '╎' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
