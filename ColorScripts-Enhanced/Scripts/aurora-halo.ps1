# Aurora Halo - concentric waves of luminous greens and violets
# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27
$reset = "$esc[0m"

$rows = 28
$cols = 78
$charSteps = '▂▃▄▅▆▇█'
$centerY = ($rows - 1) / 2.0
$centerX = ($cols - 1) / 2.0

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $dx = ($x - $centerX) / $centerX
        $dy = ($y - $centerY) / $centerY
        $distance = [math]::Sqrt($dx * $dx + $dy * $dy)
        $wave = [math]::Sin($distance * 6.5 - ($y * 0.08))
        $r = [int]([math]::Min(255, 120 + 80 * $wave + 60 * (1 - $distance)))
        $g = [int]([math]::Min(255, 160 + 90 * $wave))
        $b = [int]([math]::Min(255, 200 - 140 * $distance + 80 * $wave))
        if ($r -lt 0) { $r = 0 }
        if ($g -lt 0) { $g = 0 }
        if ($b -lt 0) { $b = 0 }
        $scaled = [math]::Floor(([math]::Min(0.999, [math]::Max(0, ($wave + 1) / 2))) * ($charSteps.Length))
        $index = [int]([math]::Min($charSteps.Length - 1, $scaled))
        $char = $charSteps[$index]
        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
