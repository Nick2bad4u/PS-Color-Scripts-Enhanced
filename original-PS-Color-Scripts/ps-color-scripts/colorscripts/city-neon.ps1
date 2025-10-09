# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$reset = "$esc[0m"
$width = 78
$ansiPattern = "$([char]27)\[[0-9;]*m"

function Write-Aligned {
    param([string]$text)

    $visibleLength = ([regex]::Replace($text, $ansiPattern, '')).Length
    if ($visibleLength -lt $width) {
        $text += ' ' * ($width - $visibleLength)
    }

    Write-Host ($text + $reset)
}

function Write-Centered {
    param([string]$text)

    $visible = ([regex]::Replace($text, $ansiPattern, '')).Length
    $padLeft = [math]::Max(0, [int](($width - $visible) / 2))
    $padRight = [math]::Max(0, $width - $visible - $padLeft)
    Write-Host ((' ' * $padLeft) + $text + (' ' * $padRight) + $reset)
}

$skyBands = @(
    @(20, 18, 48),
    @(32, 22, 68),
    @(44, 26, 88),
    @(68, 32, 112),
    @(92, 38, 140)
)

foreach ($band in $skyBands) {
    Write-Aligned("$esc[48;2;$($band[0]);$($band[1]);$($band[2])" + 'm' + (' ' * $width))
}


$moon = "$esc[38;2;255;246;196m"
$accent = "$esc[38;2;180;130;255m"
$neon = "$esc[38;2;255;0;170m"
$grid = "$esc[38;2;110;220;255m"
$buildingDark = "$esc[38;2;28;24;48m"
$buildingLight = "$esc[38;2;40;36;70m"
$windowWarm = "$esc[38;2;255;204;102m"
$windowCool = "$esc[38;2;120;240;255m"
$street = "$esc[38;2;16;16;28m"
$streetNeon = "$esc[38;2;255;75;120m"

$line1 = "$accent✦         $moon◐$accent              ╭─$neonＮＥＯＮ$accent─╮"
$line2 = "$accent$buildingLight▄$grid███████████████████████████████████████████$buildingLight▄"
Write-Centered $line1
Write-Centered $line2

$roofSpan = 68
Write-Centered ($buildingDark + '▄' + ('█' * $roofSpan) + '▄')

$windowPalettes = @(
    @($windowWarm, $windowCool, $windowWarm, $neon),
    @($windowCool, $windowWarm, $neon, $windowCool),
    @($neon, $windowWarm, $windowCool, $windowWarm),
    @($windowWarm, $windowCool, $windowWarm, $neon)
)

$windowCount = 17
foreach ($palette in $windowPalettes) {
    $sb = [System.Text.StringBuilder]::new()
    for ($i = 0; $i -lt $windowCount; $i++) {
        $color = $palette[$i % $palette.Length]
        $null = $sb.Append($buildingDark + '█')
        $null = $sb.Append($color + '██')
        $null = $sb.Append($buildingDark + '█')
    }

    Write-Centered ($sb.ToString())
}

$parapetWidth = 68
Write-Centered ($buildingLight + '▄▀' + ('▀' * $parapetWidth) + '▀▄')
Write-Centered ($street + '█' + ('█' * $parapetWidth) + '█')
Write-Centered ($streetNeon + '╭─────────────╯' + $grid + ' NEON CITY NIGHTS ' + $streetNeon + '╰──────────────╮')
Write-Centered ($street + ('█' * ($parapetWidth + 2)))
Write-Host $reset
