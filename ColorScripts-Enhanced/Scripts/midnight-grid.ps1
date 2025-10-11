# Midnight Grid - cool electric matrix pulses
# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27
$reset = "$esc[0m"

$rows = 26
$cols = 76
$chars = '░▒▓█'

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $t = $x / [double]([math]::Max($cols - 1, 1))
        $phase = ($x * 0.18) + ($y * 0.32)
        $glow = (1 + [math]::Sin($phase)) / 2
        $r = [int]([math]::Min(200, 40 + 40 * $glow))
        $g = [int]([math]::Min(255, 80 + 140 * $glow))
        $b = [int]([math]::Min(255, 150 + 100 * $glow))
        $index = ($x + ($y * 3)) % $chars.Length
        $char = $chars[$index]
        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
