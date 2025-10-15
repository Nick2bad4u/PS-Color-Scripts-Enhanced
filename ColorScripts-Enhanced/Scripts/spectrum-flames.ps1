$esc = [char]27
$reset = "$esc[0m"

# Spectrum Flames: upward spectral streaks with layered sine turbulence
$rows = 22
$cols = 80

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $line = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $t = $x * 0.09
        $noise = [math]::Sin($t + $y * 0.18) + 0.5 * [math]::Sin($t * 2.2 - $y * 0.31) + 0.25 * [math]::Sin($t * 3.7 + $y * 0.53)
        $h = ($x + 12 * $noise) / [double]([math]::Max($cols - 1, 1)) * 6.28318530718
        $r = [int](120 + 120 * [math]::Sin($h))
        $g = [int](120 + 120 * [math]::Sin($h + 2.094))
        $b = [int](120 + 120 * [math]::Sin($h + 4.188))
        $heat = 0.6 + 0.4 * [math]::Exp( - [math]::Max(0.0, ($rows - 1 - $y)) * 0.09)
        $r = [int]([math]::Min(255, $r * $heat))
        $g = [int]([math]::Min(255, $g * $heat))
        $b = [int]([math]::Min(255, $b * $heat))
        if ( ($x + 2 * $y) % 11 -eq 0 ) { $r = [int]($r * 0.5); $g = [int]($g * 0.5); $b = [int]($b * 0.5) }
        $null = $line.Append("$esc[48;2;$r;$g;$b" + "m ")
    }
    $null = $line.Append($reset)
    Write-Host $line.ToString()
}
Write-Host $reset
