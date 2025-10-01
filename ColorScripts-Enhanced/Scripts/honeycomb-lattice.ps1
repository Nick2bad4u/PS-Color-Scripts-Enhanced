# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

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

$rows = 18
$cols = 22
$targetWidth = ($cols * 2) + 1

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    if ($y % 2 -eq 1) { $null = $sb.Append(' ') }
    for ($x = 0; $x -lt $cols; $x++) {
        $hue = (($x / [double]$cols) + ($y * 0.08)) % 1
        $sat = 0.65 + 0.25 * [math]::Sin(($x + $y) * 0.35)
        $val = 0.55 + 0.35 * [math]::Cos(($x * 0.3) - ($y * 0.2))
        $rgb = Convert-HsvToRgb -Hue $hue -Saturation ([math]::Min([math]::Max($sat, 0.0), 1.0)) -Value ([math]::Min([math]::Max($val, 0.0), 1.0))
        $symbol = if ((($x + $y) % 3) -eq 0) { '⬢' } elseif ((($x + $y) % 3) -eq 1) { '⬡' } else { '⬣' }
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])" + "m$symbol ")
    }
    Write-AlignedLine ($sb.ToString()) $targetWidth
}

Write-Host $reset
