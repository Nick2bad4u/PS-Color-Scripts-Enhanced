# Unique Concept: Elliptic-geodesic sunburst combining dual-foci distance sums and anisotropic radial bands.

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

$width = 104
$height = 36
$focusA = @{ X = -0.65; Y = 0.0 }
$focusB = @{ X = 0.65; Y = 0.0 }

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = ($col / [double]($width - 1)) * 2.0 - 1.0
        $ny = ($row / [double]($height - 1)) * 2.0 - 1.0
        $px = $nx * 1.25
        $py = $ny * 0.85

        $dyScale = 1.3
        $d1 = [math]::Sqrt((($px - $focusA.X) * ($px - $focusA.X)) + ((($py - $focusA.Y) * $dyScale) * (($py - $focusA.Y) * $dyScale)))
        $d2 = [math]::Sqrt((($px - $focusB.X) * ($px - $focusB.X)) + ((($py - $focusB.Y) * $dyScale) * (($py - $focusB.Y) * $dyScale)))
        $sum = $d1 + $d2
        $diff = $d1 - $d2

        $radius = [math]::Sqrt($px * $px + ($py * 1.1) * ($py * 1.1))
        $theta = [math]::Atan2($py, $px)

        $geodesic = [math]::Sin($sum * 4.8)
        $radial = [math]::Sin($radius * 7.5 + $theta * 5.0)
        $isoDiff = [math]::Sin($diff * 3.1)
        $intensity = 0.4 + 0.35 * [math]::Cos($sum * 2.1 - $theta * 1.8) + 0.25 * [math]::Cos($radius * 4.5)

        $hue = (0.05 + 0.08 * $sum + 0.18 * $isoDiff + 0.12 * [math]::Sin($theta * 3.5)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.52 + 0.3 * $intensity + 0.18 * $radial) -Min 0 -Max 1
        $value = Clamp -Value (0.22 + 0.62 * [math]::Exp( - [math]::Abs($geodesic) * 2.6) + 0.18 * [math]::Cos($radius * 3.1)) -Min 0.2 -Max 1

        $symbol = if ([math]::Abs($geodesic) -lt 0.12) {
            '═'
        }
        elseif ([math]::Abs($radial) -lt 0.12) {
            '║'
        }
        elseif ([math]::Abs($isoDiff) -lt 0.1) {
            '╳'
        }
        elseif ($intensity -gt 0.6) {
            '·'
        }
        else {
            ' '
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
