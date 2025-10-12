# Unique Concept: Interlocking geometric tessellations with hexagonal and triangular patterns creating crystalline formations.

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

# Hexagonal grid parameters
$hexSize = 3
$hexWidth = $hexSize * 2
$hexHeight = $hexSize * [math]::Sqrt(3)

for ($y = 0; $y -lt $height; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        # Calculate which hexagon this pixel belongs to
        $hexX = [math]::Floor($x / ($hexWidth * 0.75))
        $hexY = [math]::Floor($y / $hexHeight)

        # Offset every other row
        $offsetX = ($hexY % 2) * ($hexWidth * 0.375)

        # Local coordinates within the hexagon
        $localX = $x - $hexX * ($hexWidth * 0.75) - $offsetX
        $localY = $y - $hexY * $hexHeight

        # Distance from hexagon center
        $centerX = $hexWidth * 0.375
        $centerY = $hexHeight * 0.5
        $dx = $localX - $centerX
        $dy = $localY - $centerY

        # Hexagon boundary check (approximate)
        $distFromCenter = [math]::Sqrt($dx * $dx + $dy * $dy)
        $angle = [math]::Atan2($dy, $dx)

        # Create tessellation pattern
        $ring = [math]::Floor($distFromCenter / $hexSize)
        $sector = [math]::Floor(($angle + [math]::PI) / ([math]::PI / 3))

        # Color based on position and tessellation
        $hue = (($hexX * 0.1 + $hexY * 0.15 + $ring * 0.2 + $sector * 0.05) % 1)
        $saturation = 0.7 + 0.3 * [math]::Sin($distFromCenter * 0.5)
        $value = 0.4 + 0.6 * [math]::Cos($angle * 2 + $ring)

        # Different symbols for different tessellation elements
        $symbols = @('⬡', '⬢', '⬣', '▴', '▾', '◈', '◇')
        $symbolIndex = ($ring + $sector) % $symbols.Length
        $symbol = $symbols[$symbolIndex]

        # Edge highlighting
        $edgeDistance = [math]::Abs($distFromCenter - $ring * $hexSize)
        if ($edgeDistance -lt 0.5) {
            $value = [math]::Min(1.0, $value + 0.3)
            $saturation = [math]::Min(1.0, $saturation + 0.2)
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
