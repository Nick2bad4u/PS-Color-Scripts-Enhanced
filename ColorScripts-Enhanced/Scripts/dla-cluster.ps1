# Unique Concept: Diffusion-Limited Aggregation (DLA) - particles performing random walk stick to a growing cluster.
# Creates dendritic, snowflake-like structures with branch coloring based on growth order.

# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

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

function Clamp {
    param([double]$Value, [double]$Min, [double]$Max)
    if ($Value -lt $Min) { return $Min }
    if ($Value -gt $Max) { return $Max }
    return $Value
}

$size = 80
$particles = 2500
$rand = [System.Random]::new(42)

# Grid to track occupied positions
$grid = @{}
$centerX = [int]($size / 2)
$centerY = [int]($size / 2)

# Start with center seed
$grid["$centerX,$centerY"] = [pscustomobject]@{ Order = 0; Distance = 0 }
$maxOrder = 0

# Grow the cluster
for ($p = 0; $p -lt $particles; $p++) {
    # Spawn particle at random position on circle
    $spawnAngle = $rand.NextDouble() * 2 * [math]::PI
    $spawnRadius = 35
    $x = $centerX + [int]($spawnRadius * [math]::Cos($spawnAngle))
    $y = $centerY + [int]($spawnRadius * [math]::Sin($spawnAngle))

    # Random walk until it sticks or escapes
    $stuck = $false
    $maxSteps = 5000

    for ($step = 0; $step -lt $maxSteps; $step++) {
        # Check if adjacent to cluster
        $neighbors = @(
            "$($x-1),$y", "$($x+1),$y",
            "$x,$($y-1)", "$x,$($y+1)",
            "$($x-1),$($y-1)", "$($x+1),$($y-1)",
            "$($x-1),$($y+1)", "$($x+1),$($y+1)"
        )

        $hasNeighbor = $false
        foreach ($n in $neighbors) {
            if ($grid.ContainsKey($n)) {
                $hasNeighbor = $true
                break
            }
        }

        if ($hasNeighbor) {
            # Stick to cluster
            $dx = $x - $centerX
            $dy = $y - $centerY
            $dist = [math]::Sqrt($dx * $dx + $dy * $dy)
            $grid["$x,$y"] = [pscustomobject]@{
                Order    = $p
                Distance = $dist
            }
            $maxOrder = $p
            $stuck = $true
            break
        }

        # Random walk
        $direction = $rand.Next(8)
        switch ($direction) {
            0 { $x-- }
            1 { $x++ }
            2 { $y-- }
            3 { $y++ }
            4 { $x--; $y-- }
            5 { $x++; $y-- }
            6 { $x--; $y++ }
            7 { $x++; $y++ }
        }

        # Check bounds - if too far, give up
        $dx = $x - $centerX
        $dy = $y - $centerY
        if ($dx * $dx + $dy * $dy -gt 1600) { break }
    }
}

# Render the cluster
for ($row = $size - 1; $row -ge 0; $row--) {
    # Check if this row has any occupied positions
    $hasOccupied = $false
    for ($col = 0; $col -lt $size; $col++) {
        if ($grid.ContainsKey("$col,$row")) {
            $hasOccupied = $true
            break
        }
    }
    if (-not $hasOccupied) { continue }

    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $size; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]

            # Color by growth order and distance
            $orderRatio = $cell.Order / [double]$maxOrder
            $hue = ($orderRatio * 0.7 + 0.15) % 1
            $saturation = Clamp -Value (0.6 + 0.35 * (1.0 - $orderRatio)) -Min 0 -Max 1
            $value = Clamp -Value (0.4 + 0.55 * (1.0 - $orderRatio * 0.5)) -Min 0.3 -Max 1.0

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            # Symbol by distance from center
            if ($cell.Distance -lt 5) { $symbol = '◉' }
            elseif ($cell.Distance -lt 12) { $symbol = '●' }
            elseif ($cell.Distance -lt 20) { $symbol = '◆' }
            elseif ($cell.Distance -lt 28) { $symbol = '◇' }
            else { $symbol = '∙' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    [Console]::WriteLine($sb.ToString() + $reset)
}

[Console]::Write($reset)


