# Unique Concept: Penrose-like quasicrystal bloom formed by irrational plane-wave interference and directional shading.


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

$width = 94
$height = 36
$waveCount = 9
$golden = (1 + [math]::Sqrt(5.0)) / 2.0
$script:waves = for ($i = 0; $i -lt $waveCount; $i++) {
    $angle = ((2 * [math]::PI * $i) / $waveCount) * $golden
    [pscustomobject]@{
        X         = [math]::Cos($angle)
        Y         = [math]::Sin($angle)
        Frequency = 2.7 + 0.35 * [math]::Sin($i * 0.9)
        Phase     = $i * 0.77
    }
}

function GetInterference {
    param(
        [double]$X,
        [double]$Y
    )

    $sum = 0.0
    foreach ($w in $script:waves) {
        $sum += [math]::Cos((($X * $w.X) + ($Y * $w.Y)) * $w.Frequency + $w.Phase)
    }

    return $sum
}

$delta = 0.015

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = ($col / [double]($width - 1)) - 0.5
        $ny = ($row / [double]($height - 1)) - 0.5
        $px = $nx * 4.0
        $py = $ny * 4.0

        $amp = GetInterference -X $px -Y $py
        $ampNorm = ($amp + $waveCount) / (2.0 * $waveCount)
        $ampSharp = [math]::Pow(([math]::Abs($amp) / $waveCount), 0.65)

        $gradX = (GetInterference -X ($px + $delta) -Y $py) - (GetInterference -X ($px - $delta) -Y $py)
        $gradY = (GetInterference -X $px -Y ($py + $delta)) - (GetInterference -X $px -Y ($py - $delta))
        $angle = [math]::Atan2($gradY, $gradX)

        $directionIndex = [int](([math]::Floor((($angle + [math]::PI) / ([math]::PI / 2)))) % 4)
        if ($directionIndex -lt 0) { $directionIndex += 4 }
        $directionChars = @('╱', '─', '╲', '│')
        $symbol = $directionChars[$directionIndex]

        if ($ampSharp -gt 0.82) {
            $symbol = '✶'
        }
        elseif ($ampSharp -lt 0.22) {
            $symbol = '·'
        }

        $hue = ($ampNorm * 0.72 + 0.18 * [math]::Sin($px * 1.9) + 0.1 * [math]::Cos($py * 2.3)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.5 + 0.45 * $ampSharp) -Min 0 -Max 1
        $value = Clamp -Value (0.18 + 0.75 * [math]::Pow($ampNorm, 0.8) + 0.12 * [math]::Sin($px * 3.7 + $py * 2.6)) -Min 0.2 -Max 1.0

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
