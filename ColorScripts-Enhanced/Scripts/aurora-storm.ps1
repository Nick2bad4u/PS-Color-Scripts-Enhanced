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

$rows = 24
$cols = 60
$targetWidth = 120

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $nx = $x / $cols
        $ny = $y / $rows
        $wave1 = [math]::Sin($nx * 10 + $ny * 5) * 0.5
        $wave2 = [math]::Sin($nx * 15 - $ny * 8) * 0.3
        $wave3 = [math]::Sin($nx * 20 + $ny * 12) * 0.2
        $intensity = ($wave1 + $wave2 + $wave3 + 1.5) / 3
        $polar = [math]::Abs([math]::Sin([math]::Atan2($ny - 0.5, $nx - 0.5) * 4 + $intensity * 2))
        $hue = 0.35 + 0.15 * [math]::Sin($intensity * 3)  # Green to blue range
        $sat = 0.8 + 0.2 * $polar
        $val = 0.2 + 0.8 * $intensity * $polar
        $rgb = Convert-HsvToRgb -Hue $hue -Saturation ([math]::Min([math]::Max($sat, 0.0), 1.0)) -Value ([math]::Min([math]::Max($val, 0.0), 1.0))
        $symbols = @(' ', '.', '░', '▒', '▓', '█', '▉', '▊')
        $symbolIndex = [math]::Floor($intensity * $polar * $symbols.Length) % $symbols.Length
        $symbol = $symbols[$symbolIndex]
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])" + "m$symbol")
    }
    Write-AlignedLine ($sb.ToString()) $targetWidth
}

Write-Host $reset
