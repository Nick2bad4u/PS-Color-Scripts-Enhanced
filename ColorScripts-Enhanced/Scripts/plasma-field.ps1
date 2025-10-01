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
        $turb1 = [math]::Sin($nx * 8 + $ny * 6 + [math]::Sin($nx * 16) * 0.5)
        $turb2 = [math]::Cos($nx * 12 - $ny * 9 + [math]::Cos($ny * 18) * 0.3)
        $turb3 = [math]::Sin($nx * 20 + $ny * 15) * [math]::Cos($nx * 10 - $ny * 12)
        $plasma = ($turb1 + $turb2 + $turb3) / 3
        $flow = [math]::Abs([math]::Sin($nx * 25 + $ny * 20 + $plasma * 2))
        $hue = 0.05 + 0.15 * [math]::Sin($plasma * 3 + $flow)  # Red to orange
        $sat = 0.8 + 0.2 * $flow
        $val = 0.4 + 0.6 * [math]::Abs($plasma)
        $rgb = Convert-HsvToRgb -Hue $hue -Saturation ([math]::Min([math]::Max($sat, 0.0), 1.0)) -Value ([math]::Min([math]::Max($val, 0.0), 1.0))
        $symbols = @(' ', '░', '▒', '▓', '█', '▚', '▞', '▙')
        $symbolIndex = [math]::Floor([math]::Abs($plasma) * $symbols.Length) % $symbols.Length
        $symbol = $symbols[$symbolIndex]
        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])" + "m$symbol")
    }
    Write-AlignedLine ($sb.ToString()) $targetWidth
}

Write-Host $reset
