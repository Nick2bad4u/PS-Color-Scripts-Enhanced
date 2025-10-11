# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27
$reset = "$esc[0m"
$ansiPattern = "$([char]27)\[[0-9;]*m"

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

$rows = 18
$cols = 76
$timeShift = Get-Random -Minimum 0.0 -Maximum (2 * [math]::PI)

Write-Host
for ($row = 0; $row -lt $rows; $row++) {
    $level = 1.0 - ($row / [double]($rows - 1))
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $t = $x / [double]($cols - 1)
        $wave = 0.5 + 0.32 * [math]::Sin((2 * [math]::PI * $t) + $timeShift)
        $wave += 0.18 * [math]::Sin((4 * [math]::PI * $t) - $timeShift / 2)
        $wave += 0.08 * [math]::Sin((9 * [math]::PI * $t) + $timeShift / 3)

        $rgb = Convert-HsvToRgb -Hue (($t + $wave * 0.2) % 1) -Saturation (0.6 + 0.2 * $wave) -Value (0.45 + 0.5 * $wave)
        if ($level -le $wave) {
            $char = if ((($row + $x) % 2) -eq 0) { '█' } else { '▓' }
            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])" + "m$char")
        }
        else {
            $null = $sb.Append(' ')
        }
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}

$label = "$esc[38;2;255;120;200mWAVEFORM$esc[0m $esc[38;2;120;200;255mSPECTRA$esc[0m"
$visible = ([regex]::Replace($label, $ansiPattern, '')).Length
$padLeft = [math]::Max(0, [int](($cols - $visible) / 2))
$padRight = [math]::Max(0, $cols - $visible - $padLeft)
Write-Host ((' ' * $padLeft) + $label + (' ' * $padRight) + $reset)
Write-Host $reset
