# Unique Concept: Recursive binary tree fractal with asymmetric branching and autumn colors.
# Each branch splits into two with varying angles creating an organic tree structure.


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

function Write-Branch {
    param($X, $Y, $Angle, $Length, $Depth, $MaxDepth)

    if ($Depth -gt $MaxDepth -or $Length -lt 0.8) { return }

    # Draw branch line
    $endX = $X + $Length * [math]::Cos($Angle)
    $endY = $Y + $Length * [math]::Sin($Angle)

    $steps = [int]($Length * 3)
    if ($steps -lt 2) { $steps = 2 }

    for ($s = 0; $s -le $steps; $s++) {
        $t = $s / [double]$steps
        $px = [int]($X + ($endX - $X) * $t)
        $py = [int]($Y + ($endY - $Y) * $t)

        if ($px -ge 0 -and $px -lt $script:width -and $py -ge 0 -and $py -lt $script:height) {
            $key = "$px,$py"
            if (-not $script:grid.ContainsKey($key) -or $script:grid[$key].Depth -lt $Depth) {
                $script:grid[$key] = @{
                    Depth  = $Depth
                    Length = $Length
                }
            }
        }
    }

    # Recursive branching
    $leftAngle = $Angle - 0.5 - (7 - $Depth) * 0.08
    $rightAngle = $Angle + 0.4 + (7 - $Depth) * 0.06
    $newLength = $Length * 0.72

    Write-Branch -X $endX -Y $endY -Angle $leftAngle -Length $newLength -Depth ($Depth + 1) -MaxDepth $MaxDepth
    Write-Branch -X $endX -Y $endY -Angle $rightAngle -Length $newLength -Depth ($Depth + 1) -MaxDepth $MaxDepth
}

# Start tree from bottom center
Write-Branch -X 50 -Y 25 -Angle ( - [math]::PI / 2) -Length 8 -Depth 0 -MaxDepth 9

# Render
$maxDepth = ($grid.Values | Measure-Object -Property Depth -Maximum).Maximum
if ($null -eq $maxDepth) { $maxDepth = 1 }

for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]
            $depthRatio = $cell.Depth / [double]$maxDepth

            # Autumn color gradient from brown trunk to red/yellow leaves
            $hue = if ($depthRatio -lt 0.3) { 0.08 }  # Brown trunk
            elseif ($depthRatio -lt 0.6) { 0.05 + $depthRatio * 0.08 }  # Transition
            else { 0.08 + ($depthRatio - 0.6) * 0.15 }  # Red-yellow leaves

            $saturation = 0.6 + 0.35 * $depthRatio
            $value = 0.85 - 0.35 * $depthRatio

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            $symbol = if ($cell.Length -gt 5) { '█' }
            elseif ($cell.Length -gt 3) { '▓' }
            elseif ($cell.Length -gt 1.5) { '▒' }
            else { '░' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
