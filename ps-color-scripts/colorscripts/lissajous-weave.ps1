# Unique Concept: Lissajous-weaving lattice using intertwined phase fields with orientation-sensitive glyphs.

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
    param(
        [double]$Value,
        [double]$Min,
        [double]$Max
    )

    if ($Value -lt $Min) { return $Min }
    if ($Value -gt $Max) { return $Max }
    return $Value
}

$width = 108
$height = 34

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = $col / [double]($width - 1)
        $ny = $row / [double]($height - 1)

        $phaseX = 3.0 * $nx + 0.27 * [math]::Sin(2.0 * [math]::PI * $ny)
        $phaseY = 4.0 * $ny + 0.33 * [math]::Cos(2.0 * [math]::PI * $nx)
        $phaseCross = 2.3 * ($nx + $ny) + 0.18 * [math]::Sin(4.0 * [math]::PI * ($nx - $ny))

        $waveX = [math]::Sin(2.0 * [math]::PI * $phaseX)
        $waveY = [math]::Sin(2.0 * [math]::PI * $phaseY)
        $waveCross = [math]::Sin(2.0 * [math]::PI * $phaseCross)

        $energy = [math]::Sqrt(($waveX * $waveX + $waveY * $waveY) / 2.0)
        $depth = 0.5 + 0.5 * $waveCross
        $blend = $waveX * $waveY

        $symbol =
        if ($blend -gt 0.45) { '╳' }
        elseif ($waveX -gt 0.55) { '╱' }
        elseif ($waveX -lt -0.55) { '╲' }
        elseif ($waveY -gt 0.55) { '━' }
        elseif ($waveY -lt -0.55) { '┃' }
        elseif ($energy -lt 0.22) { '·' }
        else { '╬' }

        $hue = (0.58 + 0.2 * $waveX + 0.22 * $waveY + 0.12 * [math]::Sin($phaseCross * [math]::PI)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.48 + 0.4 * $energy + 0.18 * ($depth - 0.5)) -Min 0 -Max 1
        $value = Clamp -Value (0.25 + 0.65 * [math]::Pow($energy, 0.65) + 0.1 * $depth) -Min 0.2 -Max 1

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
