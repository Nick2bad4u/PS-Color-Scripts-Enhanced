# Unique Concept: Poincaré-disk bloom using hyperbolic reflections and geodesic interference bands.

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

$width = 96
$height = 36
$segments = 7
$segmentAngle = (2 * [math]::PI) / $segments

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = ($col / [double]($width - 1)) * 2.0 - 1.0
        $ny = ($row / [double]($height - 1)) * 2.0 - 1.0

        $rSquared = ($nx * $nx) + ($ny * $ny)
        if ($rSquared -ge 1.0) {
            $null = $sb.Append("$esc[38;2;8;9;12m ")
            continue
        }

        $r = [math]::Sqrt($rSquared)
        $theta = [math]::Atan2($ny, $nx)
        if ($theta -lt 0) { $theta += 2 * [math]::PI }

        $segmentIndex = [math]::Floor($theta / $segmentAngle)
        $thetaLocal = $theta - ($segmentIndex * $segmentAngle)
        if ($thetaLocal -gt ($segmentAngle / 2)) {
            $thetaLocal = $segmentAngle - $thetaLocal
        }
        $thetaNormalized = $thetaLocal / ($segmentAngle / 2)

        $hyperRadius = 2.0 * [math]::Atanh($r)
        $geodesic = [math]::Sin($hyperRadius * 2.35 + $thetaNormalized * [math]::PI * 3.6)

        $hue = (($segmentIndex / [double]$segments) + 0.12 * $thetaNormalized + 0.1 * [math]::Sin($hyperRadius * 1.17)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.58 + 0.35 * [math]::Exp(-$hyperRadius * 0.35)) -Min 0 -Max 1
        $value = Clamp -Value (0.2 + 0.78 * [math]::Exp( - ($hyperRadius - 1.1) * ($hyperRadius - 1.1) * 0.45) + 0.1 * [math]::Sin($thetaNormalized * [math]::PI)) -Min 0.18 -Max 1.0

        $symbol =
        if ([math]::Abs($geodesic) -lt 0.18) { '✦' }
        elseif ($geodesic -gt 0.45) { '◉' }
        elseif ($geodesic -lt -0.45) { '◇' }
        else { '·' }

        $edgeGlow = Clamp -Value (0.6 - ($r * 0.45)) -Min 0 -Max 1
        $value = Clamp -Value ($value + (0.25 * $edgeGlow)) -Min 0.2 -Max 1.0

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}
