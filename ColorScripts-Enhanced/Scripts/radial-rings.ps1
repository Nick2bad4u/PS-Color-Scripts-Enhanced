# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27
$reset = "$esc[0m"

# Radial Rings: concentric spectral rings with crisp spokes
$rows = 24
$cols = 80

Write-Host
$cx = ($cols - 1) / 2.0
$cy = ($rows - 1) / 2.0
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $dx = $x - $cx
        $dy = $y - $cy
        $angle = [math]::Atan2($dy, $dx)
        if ($angle -lt 0) { $angle += 6.28318530718 }
        $dist = [math]::Sqrt($dx*$dx + $dy*$dy)

        $r = [int](128 + 127 * [math]::Sin($angle))
        $g = [int](128 + 127 * [math]::Sin($angle + 2.094))
        $b = [int](128 + 127 * [math]::Sin($angle + 4.188))

        # Rings every 2.2 units, and thin spokes every ~15 degrees
        if ( ([int]([math]::Round($dist / 2.2))) % 2 -eq 0 ) { $r = [int]($r * 0.55); $g = [int]($g * 0.55); $b = [int]($b * 0.55) }
        if ( ([int]([math]::Round($angle / 0.262))) % 4 -eq 0 ) { $r = [math]::Min(255, $r + 70); $g = [math]::Min(255, $g + 70); $b = [math]::Min(255, $b + 70) }

        $null = $sb.Append("$esc[48;2;$r;$g;$b" + "m ")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
