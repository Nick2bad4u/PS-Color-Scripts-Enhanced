# Unique Concept: Superposition of rotated Gabor wavelets forming colorized ridges with gradient-oriented glyphs.


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

$wavelets = @(
    @{ X = -0.65; Y = -0.2; Theta = 0.35; Frequency = 2.6; SigmaX = 0.28; SigmaY = 0.12; Phase = 0.0 },
    @{ X = 0.48; Y = -0.15; Theta = -0.55; Frequency = 2.9; SigmaX = 0.32; SigmaY = 0.14; Phase = 0.6 },
    @{ X = -0.2; Y = 0.45; Theta = 1.05; Frequency = 1.9; SigmaX = 0.35; SigmaY = 0.15; Phase = 1.2 },
    @{ X = 0.55; Y = 0.5; Theta = -1.1; Frequency = 2.4; SigmaX = 0.3; SigmaY = 0.13; Phase = -0.4 }
)

function GetWaveletField {
    param(
        [double]$X,
        [double]$Y
    )

    $sum = 0.0
    foreach ($w in $wavelets) {
        $cosT = [math]::Cos($w.Theta)
        $sinT = [math]::Sin($w.Theta)
        $dx = $X - $w.X
        $dy = $Y - $w.Y
        $rotX = $dx * $cosT + $dy * $sinT
        $rotY = - $dx * $sinT + $dy * $cosT
        $gauss = [math]::Exp( - (($rotX * $rotX) / ($w.SigmaX * $w.SigmaX) + ($rotY * $rotY) / ($w.SigmaY * $w.SigmaY)))
        $sum += $gauss * [math]::Cos((2 * [math]::PI * $w.Frequency * $rotX) + $w.Phase)
    }

    return $sum
}

$width = 98
$height = 36
$delta = 0.01

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = ($col / [double]($width - 1)) * 2.0 - 1.0
        $ny = ($row / [double]($height - 1)) * 2.0 - 1.0
        $px = $nx * 1.2
        $py = $ny * 0.9

        $field = GetWaveletField -X $px -Y $py
        $sampleXPlus = GetWaveletField -X ($px + $delta) -Y $py
        $sampleXMinus = GetWaveletField -X ($px - $delta) -Y $py
        $sampleYPlus = GetWaveletField -X $px -Y ($py + $delta)
        $sampleYMinus = GetWaveletField -X $px -Y ($py - $delta)

        $gradX = ($sampleXPlus - $sampleXMinus) / (2 * $delta)
        $gradY = ($sampleYPlus - $sampleYMinus) / (2 * $delta)
        $angle = [math]::Atan2($gradY, $gradX)

        $intensity = [math]::Tanh([math]::Abs($field) * 1.3)
        $hue = (0.58 + 0.22 * $field + 0.1 * [math]::Sin($px * 3.2 + $py * 4.1)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.5 + 0.3 * $intensity) -Min 0 -Max 1
        $value = Clamp -Value (0.22 + 0.6 * $intensity + 0.12 * [math]::Sin($field * 2.5)) -Min 0.2 -Max 1

        $absCos = [math]::Abs([math]::Cos($angle))
        $absSin = [math]::Abs([math]::Sin($angle))
        $symbol = if ($intensity -lt 0.18) {
            '·'
        }
        elseif ($absCos -gt 0.78 -and $absSin -lt 0.4) {
            '━'
        }
        elseif ($absSin -gt 0.78 -and $absCos -lt 0.4) {
            '┃'
        }
        elseif ([math]::Sin($angle) * [math]::Cos($angle) -gt 0) {
            '╱'
        }
        else {
            '╲'
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
