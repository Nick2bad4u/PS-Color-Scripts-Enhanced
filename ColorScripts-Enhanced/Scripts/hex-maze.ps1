# Unique Concept: Hexagonal maze generation using recursive division with colored path finding.
# Creates a hex-tiled labyrinth with gradient coloring showing distance from center.

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

$width = 90
$height = 25
$rand = [System.Random]::new(654)

# Hex grid
$hexes = @{}

for ($row = 0; $row -lt $height; $row++) {
    for ($col = 0; $col -lt $width; $col += 2) {
        $q = $col
        $r = $row - [math]::Floor($col / 2.0)

        # Skip some hexes randomly to create maze
        if ($rand.NextDouble() -lt 0.35) { continue }

        $dx = $q - 45
        $dy = $r - 12
        $dist = [math]::Sqrt($dx * $dx + $dy * $dy)

        $key = "$q,$r"
        $hexes[$key] = @{
            Col  = $col
            Row  = $row
            Dist = $dist
        }
    }
}

# Hex symbols
$hexSymbols = @('⬢', '⬡', '◯')

for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $q = ($col / 2) * 2
        $r = $row - [math]::Floor($q / 2.0)
        $key = "$q,$r"

        if ($hexes.ContainsKey($key)) {
            $hex = $hexes[$key]

            if ($hex.Col -eq $col) {
                $distRatio = $hex.Dist / 30.0
                if ($distRatio -gt 1.0) { $distRatio = 1.0 }

                $hue = (0.5 + $distRatio * 0.4) % 1
                $saturation = 0.7
                $value = 0.5 + 0.45 * (1.0 - $distRatio)

                $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

                $symbolIdx = [int]($distRatio * 3)
                if ($symbolIdx -ge $hexSymbols.Count) { $symbolIdx = $hexSymbols.Count - 1 }
                $symbol = $hexSymbols[$symbolIdx]

                $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
            }
            else {
                $null = $sb.Append("$esc[38;2;15;15;20m ")
            }
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
