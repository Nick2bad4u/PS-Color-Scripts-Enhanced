# Unique Concept: Chaos game with Sierpinski triangle and fractal attractors.

$ErrorActionPreference = 'Stop'
$esc = [char]27
$reset = "$esc[0m"

function Convert-HsvToRgb {
    param(
        [double]$Hue,
        [double]$Saturation,
        [double]$Value
    )

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

$width = 120
$height = 30

# Sierpinski triangle vertices
$vertices = @(
    @{ X = $width / 2; Y = 5 },
    @{ X = 10; Y = $height - 5 },
    @{ X = $width - 10; Y = $height - 5 }
)

# Chaos game points
$points = @()
$numPoints = 5000

# Start with a random point
$currentX = Get-Random -Minimum 0 -Maximum $width
$currentY = Get-Random -Minimum 0 -Maximum $height

for ($i = 0; $i -lt $numPoints; $i++) {
    # Choose a random vertex
    $vertexIndex = Get-Random -Minimum 0 -Maximum 3

    # Move halfway to the chosen vertex
    $targetX = $vertices[$vertexIndex].X
    $targetY = $vertices[$vertexIndex].Y

    $currentX = ($currentX + $targetX) / 2
    $currentY = ($currentY + $targetY) / 2

    $points += @{ X = [int]$currentX; Y = [int]$currentY; Vertex = $vertexIndex; Step = $i }
}

# Create density grid
$grid = @{}
foreach ($point in $points) {
    $key = "$($point.X),$($point.Y)"
    if (-not $grid.ContainsKey($key)) {
        $grid[$key] = @{ Count = 0; VertexCounts = @(0, 0, 0) }
    }
    $grid[$key].Count++
    $grid[$key].VertexCounts[$point.Vertex]++
}

for ($y = 0; $y -lt $height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        $key = "$x,$y"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]

            # Determine dominant vertex
            $maxCount = 0
            $dominantVertex = 0
            for ($v = 0; $v -lt 3; $v++) {
                if ($cell.VertexCounts[$v] -gt $maxCount) {
                    $maxCount = $cell.VertexCounts[$v]
                    $dominantVertex = $v
                }
            }

            $hue = ($dominantVertex * 0.3 + $cell.Count * 0.01) % 1
            $saturation = 0.8
            $value = 0.3 + 0.7 * [math]::Min($cell.Count / 10.0, 1.0)

            $symbols = @('·', '◦', '●', '◉', '◎', '◆', '◇', '◈')
            $symbol = $symbols[[math]::Min([int]($cell.Count / 5), 7)]

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;2;2;8m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
