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

$rows = 28
$cols = 70
$targetWidth = 120

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $centerX = $cols / 2.0
        $centerY = $rows / 2.0
        $dx = $x - $centerX
        $dy = $y - $centerY
        $distance = [math]::Sqrt($dx * $dx + $dy * $dy) / [math]::Max($centerX, $centerY)
        $angle = [math]::Atan2($dy, $dx)
        $spiral1 = [math]::Abs([math]::Log($distance + 0.1) * 2 + $angle * 3 / [math]::PI) % 2 - 1
        $spiral2 = [math]::Abs([math]::Log($distance + 0.1) * 2 + ($angle + [math]::PI) * 3 / [math]::PI) % 2 - 1
        $arm = [math]::Min([math]::Abs($spiral1), [math]::Abs($spiral2))
        $core = 1 - $distance
        $starField = [math]::Sin($x * 0.5 + $y * 0.3) * [math]::Cos($x * 0.7 - $y * 0.4)
        $galaxy = [math]::Max($core * 0.5, $arm * 0.8) + [math]::Abs($starField) * 0.2
        $hue = 0.6 - 0.4 * $distance + 0.2 * [math]::Sin($galaxy * 4)  # Blue center to yellow arms
        $sat = 0.8 + 0.2 * $galaxy
        $val = 0.2 + 0.8 * $galaxy
        $rgb = Convert-HsvToRgb -Hue $hue -Saturation ([math]::Min([math]::Max($sat, 0.0), 1.0)) -Value ([math]::Min([math]::Max($val, 0.0), 1.0))
        $symbols = @(' ', '.', '*', '✦', '✧', '✩', '✪', '✫')
        $symbolIndex = [math]::Floor($galaxy * $symbols.Length) % $symbols.Length
        $symbol = $symbols[$symbolIndex]
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])" + "m$symbol")
    }
    Write-AlignedLine ($sb.ToString()) $targetWidth
}

Write-Host $reset
