# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$reset = "$esc[0m"
$width = 74
$ansiPattern = "$([char]27)\[[0-9;]*m"

function Write-Centered {
    param([string]$text)
    $visible = ([regex]::Replace($text, $ansiPattern, '')).Length
    $padLeft = [math]::Max(0, [int](($width - $visible) / 2))
    $padRight = [math]::Max(0, $width - $visible - $padLeft)
    Write-Host ((' ' * $padLeft) + $text + (' ' * $padRight) + $reset)
}

$map = @{
    'A' = "$esc[38;2;40;130;60m" + '✿'
    'B' = "$esc[38;2;60;180;90m" + '❀'
    'C' = "$esc[38;2;90;200;140m" + '✤'
    'D' = "$esc[38;2;140;230;160m" + '✣'
    'E' = "$esc[38;2;220;255;220m" + '✧'
    'F' = "$esc[38;2;255;240;180m" + '✶'
    'G' = "$esc[38;2;160;255;225m" + '❉'
    'H' = "$esc[38;2;120;200;255m" + '✺'
    '|' = "$esc[38;2;120;72;48m" + '║'
    'm' = "$esc[38;2;255;160;200m" + 'ღ'
    '.' = ' '
    ' ' = ' '
    '_' = "$esc[38;2;30;80;50m" + '▂'
    '~' = "$esc[38;2;60;110;70m" + '▃'
}

$twilight = @(
    @(22, 30, 48),
    @(30, 42, 70),
    @(38, 54, 90),
    @(48, 72, 110)
)
foreach ($band in $twilight) {
    Write-Host("$esc[48;2;$($band[0]);$($band[1]);$($band[2])" + 'm' + (' ' * $width) + $reset)
}

$pattern = @'
............F...........G.....F...........G............
.........F....AABBBBAA....G.....F....AABBBBAA....G......
......AABBBBAAABBCCCBBAABBCCCBBAABBCCCBBAABBBAA........
.....AABBCCCDDDCCBBCCDDDCCBBCCDDDCCBBCCDDDCCBBAA......
....AABCCDDEEEEDCCBCCDDEEDCCBCCDDEEDCCBCCDDEECCBA.....
...AABCCDDEEFFFGEDDCCEFFGGEDDCCEFFGGEDDCCEFFGGECBA....
....AABBCCDEEFFGGEDDFFGGGGFFEDDGGGGFFEDDGGFFEECCBA....
......||....||........||....||........||....||.........
.....||||..||||......||||..||||......||||..||||........
......mm....mm........mm....mm........mm....mm.........
_____~~~___~~~____~~~~~____~~~____~~~~~____~~~____~~~~_
'@

Write-Host
foreach ($line in ($pattern -split "`n" | Where-Object { $_.Length -gt 0 })) {
    $sb = [System.Text.StringBuilder]::new()
    foreach ($ch in $line.ToCharArray()) {
        $symbol = [string]$ch
        if ($map.ContainsKey($symbol)) {
            $null = $sb.Append($map[$symbol])
        }
        else {
            $null = $sb.Append($symbol)
        }
    }
    Write-Centered $sb.ToString()
}

Write-Centered ("$esc[38;2;140;255;200m❖ ENCHANTED FOREST ❖")
Write-Host $reset
