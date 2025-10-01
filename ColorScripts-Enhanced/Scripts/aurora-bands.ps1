# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$reset = "$esc[0m"

# Aurora Bands: flowing vertical gradients with brightness waves
$rows = 18
$cols = 80

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $t = $x / [double]([math]::Max($cols-1,1))
        $phase = $t * 6.28318530718
        $r = [int](120 + 120 * [math]::Sin($phase))
        $g = [int](120 + 120 * [math]::Sin($phase + 2.3))
        $b = [int](120 + 120 * [math]::Sin($phase + 4.6))
        $bright = 0.75 + 0.25 * [math]::Sin($y * 0.35 + $x * 0.08)
        $r = [int]([math]::Min(255, $r * $bright))
        $g = [int]([math]::Min(255, $g * $bright))
        $b = [int]([math]::Min(255, $b * $bright))

        $char = if ( (($x + $y) % 6) -lt 3 ) { '▀' } else { '▄' }
        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
