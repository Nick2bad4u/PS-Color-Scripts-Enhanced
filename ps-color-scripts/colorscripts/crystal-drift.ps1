$esc = [char]27
$reset = "$esc[0m"
$ansiPattern = "$([char]27)\[[0-9;]*m"

function Write-CenteredLine {
    param([string]$text, [int]$width)

    $visible = ([regex]::Replace($text, $ansiPattern, '')).Length
    $padLeft = [math]::Max(0, [int](($width - $visible) / 2))
    $padRight = [math]::Max(0, $width - $visible - $padLeft)
    Write-Host ((' ' * $padLeft) + $text + (' ' * $padRight) + $reset)
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

$rows = 18
$cols = 66
$centers = @(
    @{ X = 16; Y = 6; Hue = 0.55 }
    @{ X = 33; Y = 3; Hue = 0.75 }
    @{ X = 50; Y = 6; Hue = 0.12 }
    @{ X = 33; Y = 12; Hue = 0.38 }
)

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $best = [double]::PositiveInfinity
        $hue = 0.0
        foreach ($center in $centers) {
            $dx = ($x - $center.X)
            $dy = ($y - $center.Y) * 1.25
            $dist = [math]::Sqrt($dx * $dx + $dy * $dy)
            if ($dist -lt $best) {
                $best = $dist
                $hue = $center.Hue
            }
        }

        $fade = [math]::Max(0.0, 1.0 - ($best / 9.5))
        if ($fade -le 0) {
            $null = $sb.Append(' ')
            continue
        }

        $value = 0.35 + $fade * 0.65
        $sat = 0.75 + 0.2 * $fade
        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $sat -Value $value
        $char = switch ($fade) {
            { $_ -gt 0.78 } { '◆' }
            { $_ -gt 0.6 } { '◇' }
            { $_ -gt 0.42 } { '✧' }
            default { '·' }
        }
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}

$tag = "$esc[38;2;180;225;255m❄$esc[0m"
$label = "$esc[38;2;120;180;255m" + $tag + ' CRYSTAL DRIFT ' + $tag
Write-CenteredLine $label $cols
Write-Host $reset
