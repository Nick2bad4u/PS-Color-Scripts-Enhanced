# Unique Concept: Diffusion-limited aggregation nebula with distance-graded spectral cores and soft particulate halo.

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

$size = 58
$center = [int]($size / 2)
$occupied = New-Object 'bool[,]' $size, $size
$age = New-Object 'int[,]' $size, $size
$rand = [System.Random]::new(421)
$clusterPoints = New-Object 'System.Collections.Generic.List[object]'

$occupied[$center, $center] = $true
$age[$center, $center] = 0
$null = $clusterPoints.Add([pscustomobject]@{ X = $center; Y = $center; Radius = 0.0; Age = 0 })

$maxRadius = 0.0
$maxAge = 0
$spawnRadius = 6.0
$maxSpawn = ($size / 2) - 2
$particles = 320
$stepLimit = 1200

for ($p = 1; $p -le $particles; $p++) {
    $angle = 2 * [math]::PI * $rand.NextDouble()
    $radius = [math]::Min($spawnRadius + 1.5 * $rand.NextDouble(), $maxSpawn)
    $x = [int][math]::Round($center + [math]::Cos($angle) * $radius)
    $y = [int][math]::Round($center + [math]::Sin($angle) * $radius)

    if ($x -lt 1) { $x = 1 }
    if ($x -ge $size - 1) { $x = $size - 2 }
    if ($y -lt 1) { $y = 1 }
    if ($y -ge $size - 1) { $y = $size - 2 }

    for ($step = 0; $step -lt $stepLimit; $step++) {
        $attached = $false
        for ($dy = -1; $dy -le 1 -and -not $attached; $dy++) {
            for ($dx = -1; $dx -le 1; $dx++) {
                if ($dx -eq 0 -and $dy -eq 0) { continue }
                $nx = $x + $dx
                $ny = $y + $dy
                if ($nx -ge 0 -and $nx -lt $size -and $ny -ge 0 -and $ny -lt $size) {
                    if ($occupied[$nx, $ny]) {
                        $attached = $true
                        break
                    }
                }
            }
        }

        if ($attached) {
            if (-not $occupied[$x, $y]) {
                $occupied[$x, $y] = $true
                $age[$x, $y] = $p
                $dist = [math]::Sqrt((($x - $center) * ($x - $center)) + (($y - $center) * ($y - $center)))
                $null = $clusterPoints.Add([pscustomobject]@{ X = $x; Y = $y; Radius = $dist; Age = $p })
                if ($dist -gt $maxRadius) { $maxRadius = $dist }
                if ($p -gt $maxAge) { $maxAge = $p }
                if ($dist + 4 -gt $spawnRadius) {
                    $spawnRadius = [math]::Min($dist + 4, $maxSpawn)
                }
            }
            break
        }

        switch ($rand.Next(0, 8)) {
            0 { $x++ }
            1 { $x-- }
            2 { $y++ }
            3 { $y-- }
            4 { $x++; $y++ }
            5 { $x++; $y-- }
            6 { $x--; $y++ }
            default { $x--; $y-- }
        }

        if ($x -lt 1) { $x = 1 }
        if ($x -ge $size - 1) { $x = $size - 2 }
        if ($y -lt 1) { $y = 1 }
        if ($y -ge $size - 1) { $y = $size - 2 }

        $currentRadius = [math]::Sqrt((($x - $center) * ($x - $center)) + (($y - $center) * ($y - $center)))
        if ($currentRadius -gt $spawnRadius + 4) { break }
    }
}

if ($maxRadius -eq 0) { $maxRadius = 1 }
if ($maxAge -eq 0) { $maxAge = 1 }

$lines = @()
for ($y = 0; $y -lt $size; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $size; $x++) {
        if ($occupied[$x, $y]) {
            $dist = [math]::Sqrt((($x - $center) * ($x - $center)) + (($y - $center) * ($y - $center)))
            $radial = $dist / $maxRadius
            $ageNorm = $age[$x, $y] / [double]$maxAge

            $hue = ($ageNorm * 0.68 + 0.24 * [math]::Sin($radial * 4.3)) % 1
            $saturation = Clamp -Value (0.55 + 0.38 * (1 - $radial)) -Min 0 -Max 1
            $value = Clamp -Value (0.28 + 0.72 * (1 - [math]::Pow($radial, 1.35))) -Min 0.25 -Max 1.0

            $symbol =
            if ($radial -lt 0.18) { '✸' }
            elseif ($radial -lt 0.45) { '✶' }
            elseif ($radial -lt 0.7) { '✷' }
            else { '·' }

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $token = "$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol"
            $null = $sb.Append($token)
        }
        else {
            $minHalo = 6.0
            foreach ($pt in $clusterPoints) {
                $dx = $x - $pt.X
                $dy = $y - $pt.Y
                $dist = [math]::Sqrt(($dx * $dx) + ($dy * $dy))
                if ($dist -lt $minHalo) { $minHalo = $dist }
                if ($minHalo -lt 1.5) { break }
            }

            if ($minHalo -lt 3.2) {
                $haloFactor = [math]::Exp(-$minHalo * 0.85)
                $hue = (0.72 + 0.08 * $haloFactor) % 1
                $saturation = 0.35 + 0.3 * $haloFactor
                $value = 0.12 + 0.4 * $haloFactor
                $symbol = if ($minHalo -lt 1.6) { '·' } else { ' ' }

                $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
                $token = "$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol"
                $null = $sb.Append($token)
            }
            else {
                $null = $sb.Append("$esc[38;2;6;7;10m ")
            }
        }
    }
    $lines += $sb.ToString() + $reset
}

$background = ("$esc[38;2;6;7;10m " * $size) + $reset
$minY = 0
$maxY = $size - 1
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -ne $background) {
        $minY = $i
        break
    }
}
for ($i = $lines.Count - 1; $i -ge 0; $i--) {
    if ($lines[$i] -ne $background) {
        $maxY = $i
        break
    }
}
for ($i = $minY; $i -le $maxY; $i++) {
    Write-Host $lines[$i]
}
