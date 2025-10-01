# Unique Concept: Electrostatic potential lattice with field-directed glyphs and dual-polarity color grading.

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

$charges = @(
    @{ X = 0.22; Y = 0.28; Q = 1.15 },
    @{ X = 0.74; Y = 0.32; Q = -1.05 },
    @{ X = 0.48; Y = 0.75; Q = 0.9 },
    @{ X = 0.68; Y = 0.72; Q = -0.85 }
)

$width = 112
$height = 40

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = $col / [double]($width - 1)
        $ny = $row / [double]($height - 1)

        $potential = 0.0
        $fieldX = 0.0
        $fieldY = 0.0

        foreach ($charge in $charges) {
            $dx = $nx - $charge.X
            $dy = $ny - $charge.Y
            $r2 = ($dx * $dx) + ($dy * $dy) + 1e-6
            $r = [math]::Sqrt($r2)
            $potential += $charge.Q / $r
            $inv = $charge.Q / ($r2 * $r)
            $fieldX += $inv * $dx
            $fieldY += $inv * $dy
        }

        $magnitude = [math]::Sqrt($fieldX * $fieldX + $fieldY * $fieldY)
        $level = [math]::Tanh([math]::Abs($potential) * 1.15)
        $sign = if ($potential -ge 0) { 1 } else { -1 }

        $hue = if ($sign -gt 0) {
            (0.06 + 0.18 * $level + 0.04 * [math]::Sin($nx * 6 - $ny * 3)) % 1
        }
        else {
            (0.64 - 0.18 * $level + 0.04 * [math]::Cos($nx * 5 + $ny * 4)) % 1
        }
        if ($hue -lt 0) { $hue += 1 }

        $saturation = Clamp -Value (0.45 + 0.42 * $level) -Min 0 -Max 1
        $value = Clamp -Value (0.22 + 0.55 * [math]::Tanh($magnitude * 0.45) + 0.12 * $level) -Min 0.2 -Max 1

        $equipotential = [math]::Abs([math]::Sin($potential * 3.2 + $nx * 6 - $ny * 5))
        $absX = [math]::Abs($fieldX)
        $absY = [math]::Abs($fieldY)

        $symbol =
        if ($equipotential -lt 0.06) { '≈' }
        elseif ($magnitude -lt 0.08) { '·' }
        elseif ($absX -lt 0.35 * $absY) { '┃' }
        elseif ($absY -lt 0.35 * $absX) { '━' }
        elseif ($fieldX * $fieldY -gt 0) { '╱' }
        else { '╲' }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
