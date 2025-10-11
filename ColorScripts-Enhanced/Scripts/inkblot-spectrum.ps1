# Unique Concept: Symmetric spectral inkblot built from stochastic noise with iterative smoothing and mirrored diffusion.

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

$width = 92
$height = 36
$halfWidth = [int][math]::Ceiling($width / 2.0)
$values = New-Object 'double[,]' $width, $height
$rand = [System.Random]::new(953)

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $halfWidth; $x++) {
        $base = $rand.NextDouble()
        if ($rand.NextDouble() -lt 0.12) {
            $base += 0.9 * $rand.NextDouble()
        }
        $base = Clamp -Value $base -Min 0 -Max 1
        $values[$x, $y] = $base
        $mirror = $width - 1 - $x
        $values[$mirror, $y] = $base
    }
}

$blurPasses = 4
for ($pass = 0; $pass -lt $blurPasses; $pass++) {
    $next = New-Object 'double[,]' $width, $height
    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            $sum = 0.0
            $count = 0
            for ($dy = -1; $dy -le 1; $dy++) {
                $ny = $y + $dy
                if ($ny -lt 0 -or $ny -ge $height) { continue }
                for ($dx = -1; $dx -le 1; $dx++) {
                    $nx = $x + $dx
                    if ($nx -lt 0 -or $nx -ge $width) { continue }
                    $weight = if ($dx -eq 0 -and $dy -eq 0) { 4.0 } elseif ($dx -eq 0 -or $dy -eq 0) { 2.0 } else { 1.0 }
                    $sum += $values[$nx, $ny] * $weight
                    $count += $weight
                }
            }
            $next[$x, $y] = $sum / $count
        }
    }
    $values = $next
}

for ($y = $height - 1; $y -ge 0; $y--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $width; $x++) {
        $val = Clamp -Value $values[$x, $y] -Min 0 -Max 1
        $verticalPhase = [math]::Sin(($y / [double]($height - 1)) * [math]::PI)
        $iso = [math]::Abs($val - 0.5)

        $hue = (0.63 + 0.18 * $val + 0.1 * [math]::Sin($y * 0.18) - 0.06 * [math]::Cos($x * 0.1)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.48 + 0.35 * $verticalPhase) -Min 0 -Max 1
        $value = Clamp -Value (0.2 + 0.75 * $val + 0.12 * $verticalPhase) -Min 0.2 -Max 1

        $symbol = if ($iso -lt 0.025) {
            '─'
        }
        elseif ($val -gt 0.75) {
            '█'
        }
        elseif ($val -gt 0.55) {
            '▓'
        }
        elseif ($val -gt 0.35) {
            '▒'
        }
        elseif ($val -gt 0.18) {
            '░'
        }
        else {
            '·'
        }

        if ([math]::Abs($x - ($width / 2.0 - 0.5)) -lt 0.4) {
            $symbol = '│'
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
