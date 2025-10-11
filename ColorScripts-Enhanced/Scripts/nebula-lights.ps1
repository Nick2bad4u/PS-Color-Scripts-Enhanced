# Nebula Lights - soft starfields awash with cosmic gradients

$esc = [char]27
$reset = "$esc[0m"

$rows = 26
$cols = 82
$starChars = @('.', '·', '*', '+')

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $t = $x / [double]([math]::Max($cols - 1, 1))
        $vertical = $y / [double]([math]::Max($rows - 1, 1))
        $phase = ($x * 0.13) + ($y * 0.21)
        $glow = (1 + [math]::Sin($phase)) / 2
        $r = [int]([math]::Min(255, 110 + 90 * $glow + 60 * $t))
        $g = [int]([math]::Min(255, 80 + 100 * $vertical + 70 * (1 - $t)))
        $b = [int]([math]::Min(255, 160 + 95 * $glow + 40 * (1 - $vertical)))
        if ($r -lt 0) { $r = 0 }
        if ($g -lt 0) { $g = 0 }
        if ($b -lt 0) { $b = 0 }
        $char = $starChars[($x * 3 + $y) % $starChars.Count]
        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
