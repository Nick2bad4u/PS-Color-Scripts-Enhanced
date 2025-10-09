# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$reset = "$esc[0m"

# Mosaic Shine: beveled color tiles with spectral hues
$rows = 12
$cols = 80

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $line = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $h = ($x / [double]([math]::Max($cols-1, 1))) * 6.28318530718
        $r = [int](120 + 120 * [math]::Sin($h))
        $g = [int](120 + 120 * [math]::Sin($h + 2.094))
        $b = [int](120 + 120 * [math]::Sin($h + 4.188))

        # Soft bevel via cell borders
        $edge = (($x % 6) -eq 0) -or (($y % 3) -eq 0)
        if ($edge) { $r = [math]::Min(255, $r + 60); $g = [math]::Min(255, $g + 60); $b = [math]::Min(255, $b + 60) }

        $null = $line.Append("$esc[48;2;$r;$g;$b" + "m ")
    }
    $null = $line.Append($reset)
    Write-Host $line.ToString()
}
Write-Host $reset
