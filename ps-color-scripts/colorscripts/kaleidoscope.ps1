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
        0 { $r = $Value; $g = $t;      $b = $p }
        1 { $r = $q;     $g = $Value;  $b = $p }
        2 { $r = $p;     $g = $Value;  $b = $t }
        3 { $r = $p;     $g = $q;      $b = $Value }
        4 { $r = $t;     $g = $p;      $b = $Value }
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
        $centerX = $cols / 2.0
        $centerY = $rows / 2.0
        $dx = $x - $centerX
        $dy = $y - $centerY
        $angle = [math]::Atan2($dy, $dx)
        $distance = [math]::Sqrt($dx * $dx + $dy * $dy)
        $segments = 8
        $segmentAngle = (2 * [math]::PI) / $segments
        $segment = [math]::Floor($angle / $segmentAngle)
        $foldedAngle = $angle - $segment * $segmentAngle
        $hue = ($foldedAngle / $segmentAngle + $segment * 0.1 + $distance * 0.05) % 1
        $sat = 0.8
        $val = 1 - ($distance / [math]::Max($centerX, $centerY))
        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $sat -Value ([math]::Min([math]::Max($val, 0.0), 1.0))
        $symbols = @('▲', '▼', '◀', '▶', '◆', '◇', '●', '○')
        $symbol = $symbols[$segment % $symbols.Length]
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])" + "m$symbol")
    }
    Write-AlignedLine ($sb.ToString()) $targetWidth
}

Write-Host $reset
