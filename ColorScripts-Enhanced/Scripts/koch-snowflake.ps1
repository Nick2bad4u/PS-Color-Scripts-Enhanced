# Unique Concept: Koch snowflake fractal with multiple iterations showing self-similarity.
# Recursive edge replacement creates increasingly complex hexagonal crystal structure.

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

function Get-KochPoint {
    param($P1, $P2, $Depth)

    if ($Depth -eq 0) {
        return @($P1, $P2)
    }

    $dx = $P2.X - $P1.X
    $dy = $P2.Y - $P1.Y

    # Three points dividing the line
    $a = @{ X = $P1.X + $dx / 3; Y = $P1.Y + $dy / 3 }
    $b = @{ X = $P1.X + 2 * $dx / 3; Y = $P1.Y + 2 * $dy / 3 }

    # Peak of triangle
    $px = $a.X + ($b.X - $a.X) * [math]::Cos([math]::PI / 3) - ($b.Y - $a.Y) * [math]::Sin([math]::PI / 3)
    $py = $a.Y + ($b.X - $a.X) * [math]::Sin([math]::PI / 3) + ($b.Y - $a.Y) * [math]::Cos([math]::PI / 3)
    $peak = @{ X = $px; Y = $py }

    # Recursively process four segments
    $result = @()
    $result += Get-KochPoints -P1 $P1 -P2 $a -Depth ($Depth - 1)
    $result += Get-KochPoints -P1 $a -P2 $peak -Depth ($Depth - 1)
    $result += Get-KochPoints -P1 $peak -P2 $b -Depth ($Depth - 1)
    $result += Get-KochPoints -P1 $b -P2 $P2 -Depth ($Depth - 1)

    return $result
}

$width = 100
$height = 26

# Initial triangle
$size = 35
$centerX = 50
$centerY = 15

$p1 = @{ X = $centerX; Y = $centerY - $size * 0.577 }
$p2 = @{ X = $centerX - $size; Y = $centerY + $size * 0.289 }
$p3 = @{ X = $centerX + $size; Y = $centerY + $size * 0.289 }

# Generate Koch curve for each edge
$depth = 4
$edge1 = Get-KochPoints -P1 $p1 -P2 $p2 -Depth $depth
$edge2 = Get-KochPoints -P1 $p2 -P2 $p3 -Depth $depth
$edge3 = Get-KochPoints -P1 $p3 -P2 $p1 -Depth $depth

$allPoints = $edge1 + $edge2 + $edge3

# Draw lines
$grid = @{}
for ($i = 0; $i -lt ($allPoints.Count - 1); $i++) {
    $pt1 = $allPoints[$i]
    $pt2 = $allPoints[$i + 1]

    $dx = $pt2.X - $pt1.X
    $dy = $pt2.Y - $pt1.Y
    $dist = [math]::Sqrt($dx * $dx + $dy * $dy)
    $steps = [int]($dist * 2)
    if ($steps -lt 2) { $steps = 2 }

    for ($s = 0; $s -le $steps; $s++) {
        $t = $s / [double]$steps
        $px = [int]($pt1.X + $dx * $t)
        $py = [int]($pt1.Y + $dy * $t)

        if ($px -ge 0 -and $px -lt $width -and $py -ge 0 -and $py -lt $height) {
            $key = "$px,$py"
            $grid[$key] = $i / [double]$allPoints.Count
        }
    }
}

# Render
for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $progress = $grid[$key]

            $hue = (0.55 + $progress * 0.3) % 1
            $saturation = 0.75
            $value = 0.9

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
