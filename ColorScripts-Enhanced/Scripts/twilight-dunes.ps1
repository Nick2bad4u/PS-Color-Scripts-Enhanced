# Twilight Dunes - flowing desert waves under dusk light
# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$reset = "$esc[0m"

$rows = 24
$cols = 78
$chars = @('~', '_', '~', ' ')

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    $height = [math]::Sin(($y * 0.3))
    for ($x = 0; $x -lt $cols; $x++) {
        $t = $x / [double]([math]::Max($cols - 1, 1))
        $phase = $t * 6.28318530718 + $y * 0.08
        $r = [int]([math]::Max([math]::Min(255, 150 + 70 * [math]::Sin($phase + 1.1)), 0))
        $g = [int]([math]::Max([math]::Min(255, 90 + 60 * [math]::Cos($phase - 0.7)), 0))
        $b = [int]([math]::Max([math]::Min(255, 120 + 100 * (1 - $t) + 40 * $height), 0))
        $char = $chars[($x + [int](($height + 1) * 2)) % $chars.Count]
        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
