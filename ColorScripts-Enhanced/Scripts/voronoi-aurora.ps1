# Unique Concept: Aurora-style Voronoi mosaic with luminous region cores and razor-fine spectral borders.

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

$width = 86
$height = 32
$seedCount = 14
$rand = [System.Random]::new(1903)

$seeds = for ($i = 0; $i -lt $seedCount; $i++) {
    [pscustomobject]@{
        X     = $rand.NextDouble()
        Y     = $rand.NextDouble()
        Hue   = $rand.NextDouble()
        Pulse = $rand.NextDouble()
    }
}

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $nx = $col / [double]($width - 1)
        $ny = $row / [double]($height - 1)

        $warpX = $nx + 0.04 * [math]::Sin(4.0 * $ny) + 0.02 * [math]::Cos(6.0 * $nx)
        $warpY = $ny + 0.04 * [math]::Cos(4.0 * $nx) - 0.02 * [math]::Sin(6.0 * $ny)

        $closest = $null
        $minDist = [double]::PositiveInfinity
        $secondDist = [double]::PositiveInfinity

        foreach ($seed in $seeds) {
            $dx = $warpX - $seed.X
            $dy = $warpY - $seed.Y
            $dist = ($dx * $dx) + ($dy * $dy)

            if ($dist -lt $minDist) {
                $secondDist = $minDist
                $minDist = $dist
                $closest = $seed
            }
            elseif ($dist -lt $secondDist) {
                $secondDist = $dist
            }
        }

        $distance = [math]::Sqrt($minDist)
        $edgeGap = [math]::Sqrt($secondDist) - $distance
        $edgeGap = Clamp -Value $edgeGap -Min 0.0001 -Max 1.0

        $hue = ($closest.Hue + 0.08 * [math]::Sin($distance * 9 + $closest.Pulse * 12)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.55 + 0.4 * [math]::Exp(-$distance * 1.8)) -Min 0 -Max 1
        $value = Clamp -Value (0.22 + [math]::Exp(-$distance * 2.2) + 0.15 * [math]::Cos($distance * 9 + $closest.Pulse * 7)) -Min 0.2 -Max 1.0

        $symbol =
        if ($edgeGap -lt 0.025) { '✺' }
        elseif ($distance -lt 0.12) { '●' }
        elseif ($distance -lt 0.23) { '◦' }
        else { '·' }

        $boundaryGlow = Clamp -Value (0.9 - (4.0 * $edgeGap)) -Min 0.2 -Max 1.0
        $value = Clamp -Value ($value + (0.3 * $boundaryGlow)) -Min 0.2 -Max 1.0

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
