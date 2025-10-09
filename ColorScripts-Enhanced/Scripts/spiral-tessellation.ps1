# Unique Concept: Golden-angle spiral tessellation with density-coded blooms and phase-driven coloring.

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
$height = 38
$pointCount = 720
$phi = (1 + [math]::Sqrt(5.0)) / 2.0
$goldenAngle = 2 * [math]::PI * (1 - 1 / $phi)
$grid = @{}

for ($i = 0; $i -lt $pointCount; $i++) {
    $progress = $i / [double]($pointCount - 1)
    $radius = [math]::Sqrt($progress)
    $angle = $i * $goldenAngle

    $px = $radius * [math]::Cos($angle) * 0.98
    $py = $radius * [math]::Sin($angle) * 0.82

    $gx = [math]::Floor((($px + 1) / 2.0) * ($width - 1))
    $gy = [math]::Floor((($py + 1) / 2.0) * ($height - 1))

    if ($gx -lt 0 -or $gx -ge $width -or $gy -lt 0 -or $gy -ge $height) {
        continue
    }

    $key = "$gx,$gy"
    if (-not $grid.ContainsKey($key) -or $radius -lt $grid[$key].Radius) {
        $grid[$key] = [pscustomobject]@{
            Progress = $progress
            Radius   = $radius
            Angle    = $angle
        }
    }
}

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"
        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]
            $hue = ($cell.Progress * 0.63 + 0.15 * [math]::Sin($cell.Angle) + 0.08 * [math]::Cos($cell.Angle * 0.5)) % 1
            if ($hue -lt 0) { $hue += 1 }
            $saturation = Clamp -Value (0.52 + 0.3 * (1 - $cell.Radius)) -Min 0 -Max 1
            $value = Clamp -Value (0.25 + 0.65 * (1 - [math]::Pow($cell.Radius, 0.85))) -Min 0.2 -Max 1

            $symbol = if ($cell.Radius -lt 0.18) {
                '✹'
            }
            elseif ($cell.Progress -lt 0.55) {
                '●'
            }
            elseif ($cell.Progress -lt 0.85) {
                '◦'
            }
            else {
                '·'
            }

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;10;11;14m")
            $null = $sb.Append(' ')
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
