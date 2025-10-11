# Unique Concept: Barnsley fern fractal using iterated function system with probabilistic transformations.
# Creates realistic fern shapes through chaos game method with affine transformations.

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

$width = 80
$height = 26
$rand = [System.Random]::new(321)

$x = 0.0
$y = 0.0
$grid = @{}
$iterations = 25000

for ($i = 0; $i -lt $iterations; $i++) {
    $r = $rand.NextDouble()

    # Barnsley fern IFS transformations
    if ($r -lt 0.01) {
        # Stem
        $xNew = 0
        $yNew = 0.16 * $y
    }
    elseif ($r -lt 0.86) {
        # Successively smaller leaflets
        $xNew = 0.85 * $x + 0.04 * $y
        $yNew = -0.04 * $x + 0.85 * $y + 1.6
    }
    elseif ($r -lt 0.93) {
        # Largest left-hand leaflet
        $xNew = 0.2 * $x - 0.26 * $y
        $yNew = 0.23 * $x + 0.22 * $y + 1.6
    }
    else {
        # Largest right-hand leaflet
        $xNew = -0.15 * $x + 0.28 * $y
        $yNew = 0.26 * $x + 0.24 * $y + 0.44
    }

    $x = $xNew
    $y = $yNew

    # Map to grid
    $px = [int](($x + 3) * 12 + 5)
    $py = [int](26 - $y * 2.4)

    if ($px -ge 0 -and $px -lt $width -and $py -ge 0 -and $py -lt $height) {
        $key = "$px,$py"
        if ($grid.ContainsKey($key)) {
            $grid[$key].Count++
        }
        else {
            $grid[$key] = @{
                Count = 1
                Y     = $y
            }
        }
    }
}

# Render
for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]

            $yRatio = $cell.Y / 10.0
            $hue = 0.3 + $yRatio * 0.15
            $saturation = 0.6 + 0.3 * $yRatio
            $value = 0.4 + 0.5 * ([math]::Log($cell.Count + 1) / 4.0)
            if ($value -gt 1.0) { $value = 1.0 }

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            $symbol = if ($cell.Count -gt 15) { '█' }
            elseif ($cell.Count -gt 8) { '▓' }
            elseif ($cell.Count -gt 3) { '▒' }
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
