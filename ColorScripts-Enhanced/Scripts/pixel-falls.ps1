# Pixel Falls - cascading columns of neon rainfall

$esc = [char]27
$reset = "$esc[0m"

$rows = 28
$cols = 70
$glyphs = @('|', '!', '¦', 'i')

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $phase = ($x * 0.25) + ($y * 0.45)
        $intensity = (1 + [math]::Sin($phase)) / 2
        $r = [int]([math]::Min(255, 40 + 100 * $intensity))
        $g = [int]([math]::Min(255, 180 + 70 * $intensity))
        $b = [int]([math]::Min(255, 120 + 60 * $intensity))
        if ($r -lt 0) { $r = 0 }
        if ($g -lt 0) { $g = 0 }
        if ($b -lt 0) { $b = 0 }
        $glyph = $glyphs[($x + ($y * 2)) % $glyphs.Count]
        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$glyph")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
