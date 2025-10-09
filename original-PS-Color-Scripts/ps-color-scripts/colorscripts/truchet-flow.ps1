# Unique Concept: Truchet tiles with random rotations creating maze-like flowing patterns.
# Each tile is a quarter-circle arc that connects to neighbors, forming organic pathways.

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

$width = 60
$height = 24
$rand = [System.Random]::new(567)

# Truchet tile sets with Unicode box drawing
$tiles = @(
    @('╭', '╮', '╰', '╯'),  # Rounded corners
    @('┏', '┓', '┗', '┛'),  # Sharp corners
    @('◜', '◝', '◟', '◞'),  # Round arcs
    @('◸', '◹', '◺', '◿')   # Triangular
)

for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        # Choose tile type and rotation
        $tileSet = $tiles[$rand.Next($tiles.Count)]
        $rotation = $rand.Next(4)
        $symbol = $tileSet[$rotation]

        # Flow-based coloring
        $flowX = [math]::Sin($col * 0.3 + $row * 0.2)
        $flowY = [math]::Cos($row * 0.3 - $col * 0.2)
        $flow = ($flowX + $flowY + 2.0) / 4.0

        $hue = ($flow * 0.6 + $rotation * 0.1) % 1
        $saturation = 0.6 + 0.3 * $flow
        $value = 0.5 + 0.45 * $flow

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
