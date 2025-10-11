$esc = [char]27
$reset = "$esc[0m"
$ansiPattern = "$([char]27)\[[0-9;]*m"

function Write-AlignedLine {
    param([string]$text, [int]$width)

    $visible = ([regex]::Replace($text, $ansiPattern, '')).Length
    if ($visible -lt $width) {
        $text += ' ' * ($width - $visible)
    }

    Write-Host ($text + $reset)
}

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

$rows = 24
$cols = 60
$targetWidth = 120

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $nx = $x / $cols
        $ny = $y / $rows
        $trunk = [math]::Abs($nx - 0.5) -lt 0.02
        $branch1 = [math]::Abs($ny - 0.4 + ($nx - 0.5) * 0.5) -lt 0.02 -and $nx -gt 0.5
        $branch2 = [math]::Abs($ny - 0.3 - ($nx - 0.5) * 0.7) -lt 0.02 -and $nx -lt 0.5
        $branch3 = [math]::Abs($ny - 0.2 + ($nx - 0.5) * 1.2) -lt 0.02 -and $nx -gt 0.5
        $branch4 = [math]::Abs($ny - 0.15 - ($nx - 0.5) * 1.5) -lt 0.02 -and $nx -lt 0.5
        $leaves = [math]::Sin($nx * 50 + $ny * 40) * [math]::Cos($nx * 30 - $ny * 35) * [math]::Exp(-$ny * 2)
        $trunkVal = if ($trunk) { 1 } else { 0 }
        $branch1Val = if ($branch1) { 1 } else { 0 }
        $branch2Val = if ($branch2) { 1 } else { 0 }
        $branch3Val = if ($branch3) { 1 } else { 0 }
        $branch4Val = if ($branch4) { 1 } else { 0 }
        $fractal = [math]::Max([math]::Max([math]::Max([math]::Max($trunkVal, $branch1Val), $branch2Val), $branch3Val), $branch4Val) + [math]::Abs($leaves)
        $hue = 0.25 - 0.2 * $ny + 0.1 * [math]::Sin($fractal * 5)  # Green to brown
        $sat = 0.7 + 0.3 * $fractal
        $val = 0.3 + 0.7 * $fractal
        $rgb = Convert-HsvToRgb -Hue $hue -Saturation ([math]::Min([math]::Max($sat, 0.0), 1.0)) -Value ([math]::Min([math]::Max($val, 0.0), 1.0))
        if ($trunk -or $branch1 -or $branch2 -or $branch3 -or $branch4) {
            $symbol = '|'
        }
        else {
            $symbols = @(' ', '.', '░', '▒', '▓', '█', '✦', '❋')
            $symbolIndex = [math]::Floor([math]::Abs($leaves) * $symbols.Length) % $symbols.Length
            $symbol = $symbols[$symbolIndex]
        }
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])" + "m$symbol")
    }
    Write-AlignedLine ($sb.ToString()) $targetWidth
}

Write-Host $reset
