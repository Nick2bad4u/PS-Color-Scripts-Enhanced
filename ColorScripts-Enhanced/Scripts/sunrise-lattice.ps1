# Sunrise Lattice - diagonal weave of warm morning hues

$esc = [char]27
$reset = "$esc[0m"

$rows = 22
$cols = 80
$chars = @('/', '-', '\\', '|')

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $t = $x / [double]([math]::Max($cols - 1, 1))
        $vertical = $y / [double]([math]::Max($rows - 1, 1))
        $r = [int]([math]::Max([math]::Min(255, 200 + 55 * [math]::Cos(($t * 6.28318530718) - 0.5)), 0))
        $g = [int]([math]::Max([math]::Min(255, 120 + 120 * (1 - $vertical)), 0))
        $b = [int]([math]::Max([math]::Min(255, 80 + 150 * $vertical * $t), 0))
        $char = $chars[($x + $y) % $chars.Count]
        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
