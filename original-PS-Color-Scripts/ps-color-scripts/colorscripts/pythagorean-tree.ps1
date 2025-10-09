# Unique Concept: Pythagorean tree fractal - squares branching at right angles creating organic growth.
# Each square spawns two smaller squares rotated 45° creating a tree-like structure.

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
$grid = @{}

function Add-PythagoreanSquare {
    param($CenterX, $CenterY, $Size, $Angle, $Depth, $MaxDepth)

    if ($Depth -gt $MaxDepth -or $Size -lt 0.6) { return }

    # Draw filled square
    $halfSize = $Size / 2.0

    for ($dy = - $halfSize; $dy -le $halfSize; $dy += 0.5) {
        for ($dx = - $halfSize; $dx -le $halfSize; $dx += 0.5) {
            # Rotate point
            $rotX = $dx * [math]::Cos($Angle) - $dy * [math]::Sin($Angle)
            $rotY = $dx * [math]::Sin($Angle) + $dy * [math]::Cos($Angle)

            $px = [int]($CenterX + $rotX)
            $py = [int]($CenterY + $rotY)

            if ($px -ge 0 -and $px -lt $script:width -and $py -ge 0 -and $py -lt $script:height) {
                $key = "$px,$py"
                if (-not $script:grid.ContainsKey($key) -or $script:grid[$key].Size -gt $Size) {
                    $script:grid[$key] = @{
                        Size  = $Size
                        Depth = $Depth
                    }
                }
            }
        }
    }

    # Calculate branch positions
    $topCenterX = $CenterX + $halfSize * [math]::Sin($Angle)
    $topCenterY = $CenterY - $halfSize * [math]::Cos($Angle)

    $newSize = $Size * 0.7
    $angleLeft = $Angle - [math]::PI / 4
    $angleRight = $Angle + [math]::PI / 4

    $offsetDist = $newSize / 2.0 + $halfSize / 2.0

    $leftX = $topCenterX + $offsetDist * [math]::Sin($angleLeft)
    $leftY = $topCenterY - $offsetDist * [math]::Cos($angleLeft)

    $rightX = $topCenterX + $offsetDist * [math]::Sin($angleRight)
    $rightY = $topCenterY - $offsetDist * [math]::Cos($angleRight)

    Add-PythagoreanSquare -CenterX $leftX -CenterY $leftY -Size $newSize -Angle $angleLeft -Depth ($Depth + 1) -MaxDepth $MaxDepth
    Add-PythagoreanSquare -CenterX $rightX -CenterY $rightY -Size $newSize -Angle $angleRight -Depth ($Depth + 1) -MaxDepth $MaxDepth
}

# Start with base square
Add-PythagoreanSquare -CenterX 50 -CenterY 24 -Size 8 -Angle 0 -Depth 0 -MaxDepth 7

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

            $hue = (0.15 + $depthRatio * 0.3) % 1
            $saturation = 0.7
            $value = 0.9 - 0.5 * $depthRatio

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $symbol = '█'

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
