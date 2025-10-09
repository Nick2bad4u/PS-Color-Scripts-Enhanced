# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$reset = "$esc[0m"

$rows = 16
$cols = 84

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $phase = ($x / [double]($cols - 1)) * [math]::PI * 2 + $y * 0.33
        $variance = [math]::Sin($y * 0.2)
        $r = [int][math]::Round(125 + 110 * [math]::Sin($phase + 0.7))
        $g = [int][math]::Round(135 + 100 * [math]::Sin($phase + 2.3 + $variance))
        $b = [int][math]::Round(165 + 95 * [math]::Sin($phase + 4.4 - $variance))

        if ($r -lt 0) { $r = 0 } elseif ($r -gt 255) { $r = 255 }
        if ($g -lt 0) { $g = 0 } elseif ($g -gt 255) { $g = 255 }
        if ($b -lt 0) { $b = 0 } elseif ($b -gt 255) { $b = 255 }

        $char = if ((($x + $y) % 4) -lt 2) { '▀' } else { '▄' }
        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
