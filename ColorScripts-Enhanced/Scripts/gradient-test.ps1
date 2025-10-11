# Gradient Test - Shows various gradient patterns and blending modes
# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27

function HSVtoRGB($h, $s, $v) {
    $h = $h % 1
    $i = [math]::Floor($h * 6)
    $f = $h * 6 - $i
    $p = $v * (1 - $s)
    $q = $v * (1 - $f * $s)
    $t = $v * (1 - (1 - $f) * $s)

    switch ($i % 6) {
        0 { $r = $v; $g = $t; $b = $p }
        1 { $r = $q; $g = $v; $b = $p }
        2 { $r = $p; $g = $v; $b = $t }
        3 { $r = $p; $g = $q; $b = $v }
        4 { $r = $t; $g = $p; $b = $v }
        5 { $r = $v; $g = $p; $b = $q }
    }

    return @([int]($r * 255), [int]($g * 255), [int]($b * 255))
}

Write-Host "`n  GRADIENT PATTERNS & COLOR BLENDING`n" -ForegroundColor Cyan

# Horizontal HSV sweep
Write-Host "  HSV Hue Sweep (Full Saturation & Value):"
Write-Host -NoNewline "  "
for ($i = 0; $i -lt 120; $i++) {
    $rgb = HSVtoRGB -h ($i / 119.0) -s 1.0 -v 1.0
    Write-Host -NoNewline "$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m▓$esc[0m"
}
Write-Host "`n"

# Saturation gradient (red hue)
Write-Host "  Saturation Gradient (Red Hue, 0% → 100%):"
Write-Host -NoNewline "  "
for ($i = 0; $i -lt 120; $i++) {
    $rgb = HSVtoRGB -h 0.0 -s ($i / 119.0) -v 1.0
    Write-Host -NoNewline "$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m▓$esc[0m"
}
Write-Host "`n"

# Value/Brightness gradient
Write-Host "  Value Gradient (Cyan Hue, 0% → 100%):"
Write-Host -NoNewline "  "
for ($i = 0; $i -lt 120; $i++) {
    $rgb = HSVtoRGB -h 0.5 -s 1.0 -v ($i / 119.0)
    Write-Host -NoNewline "$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m▓$esc[0m"
}
Write-Host "`n"

# Diagonal gradients
Write-Host "  2D Gradient (Hue × Brightness):"
for ($y = 0; $y -lt 12; $y++) {
    Write-Host -NoNewline "  "
    for ($x = 0; $x -lt 120; $x++) {
        $rgb = HSVtoRGB -h ($x / 119.0) -s 1.0 -v (1.0 - $y / 11.0)
        Write-Host -NoNewline "$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m▓$esc[0m"
    }
    Write-Host ""
}
Write-Host ""

# Radial-ish gradient
Write-Host "  Radial-Style Gradient Pattern:"
for ($y = 0; $y -lt 12; $y++) {
    Write-Host -NoNewline "  "
    for ($x = 0; $x -lt 120; $x++) {
        $dx = ($x - 60) / 60.0
        $dy = ($y - 6) / 6.0
        $dist = [math]::Sqrt($dx * $dx + $dy * $dy)
        $angle = [math]::Atan2($dy, $dx) / [math]::PI / 2 + 0.5
        $rgb = HSVtoRGB -h $angle -s 1.0 -v (1.0 - [math]::Min($dist, 1.0))
        Write-Host -NoNewline "$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m▓$esc[0m"
    }
    Write-Host ""
}
Write-Host ""
