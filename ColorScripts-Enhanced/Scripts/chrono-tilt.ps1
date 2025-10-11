# Unique Concept: Time-synchronized diagonal tiling that reorients with seconds and recolors by hour.

# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

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

$now = Get-Date
$secondFraction = ($now.Second + $now.Millisecond / 1000.0) / 60.0
$minuteFraction = ($now.Minute + ($now.Second / 60.0)) / 60.0
$hourFraction = (($now.Hour % 12) + $minuteFraction) / 12.0

$tiltAngle = ($secondFraction * 2 * [math]::PI) - [math]::PI
$cosTilt = [math]::Cos($tiltAngle)
$sinTilt = [math]::Sin($tiltAngle)
$tempo = 8.0 + 4.0 * [math]::Sin($minuteFraction * 2 * [math]::PI)
$perpTempo = 6.0 + 2.5 * [math]::Cos($minuteFraction * 2 * [math]::PI)

$width = 108
$height = 34

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = $col / [double]($width - 1)
        $ny = $row / [double]($height - 1)
        $cx = $nx - 0.5
        $cy = $ny - 0.5

        $tiltCoord = $cx * $cosTilt + $cy * $sinTilt
        $perpCoord = - $cx * $sinTilt + $cy * $cosTilt

        $band = [math]::Sin($tiltCoord * $tempo + $hourFraction * 6 * [math]::PI + $cx * 1.8)
        $cross = [math]::Sin($perpCoord * $perpTempo + $hourFraction * 4 * [math]::PI)

        $intensity = [math]::Tanh([math]::Abs($band) * 1.25)
        $hue = ($hourFraction + 0.25 * $band + 0.05 * $minuteFraction) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.48 + 0.3 * $intensity + 0.18 * $cross) -Min 0 -Max 1
        $value = Clamp -Value (0.22 + 0.65 * $intensity + 0.12 * $minuteFraction) -Min 0.2 -Max 1

        $symbol = if ([math]::Abs($cross) -lt 0.1) {
            if ($cross -ge 0) { '╱' } else { '╲' }
        }
        elseif ($band -gt 0.6) {
            '█'
        }
        elseif ($band -gt 0.2) {
            '▓'
        }
        elseif ($band -gt -0.2) {
            '▒'
        }
        elseif ($band -gt -0.6) {
            '░'
        }
        else {
            '·'
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
