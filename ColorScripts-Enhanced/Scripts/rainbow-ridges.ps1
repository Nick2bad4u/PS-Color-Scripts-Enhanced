# Rainbow Ridges - chromatic terrain carved into repeating waves
# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$reset = "$esc[0m"

$rows = 25
$cols = 80
$pattern = @('/', '\\', '_', '\\', '/')

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $t = $x / [double]([math]::Max($cols - 1, 1))
        $phase = $t * 6.28318530718
        $offset = ($y * 0.22)
        $r = [int]([math]::Min(255, 140 + 110 * [math]::Sin($phase + $offset)))
        $g = [int]([math]::Min(255, 140 + 110 * [math]::Sin($phase + $offset + 2.094)))
        $b = [int]([math]::Min(255, 140 + 110 * [math]::Sin($phase + $offset + 4.188)))
        if ($r -lt 0) { $r = 0 }
        if ($g -lt 0) { $g = 0 }
        if ($b -lt 0) { $b = 0 }
        $char = $pattern[($x + $y) % $pattern.Count]
        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
