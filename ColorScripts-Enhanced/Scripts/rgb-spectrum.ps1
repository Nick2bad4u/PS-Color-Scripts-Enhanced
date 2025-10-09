# RGB Spectrum - Shows true color (24-bit) gradient spectrum across the terminal
# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$reset = "$esc[0m"

Write-Host "`n  RGB SPECTRUM - 24-bit True Color Gradients`n" -ForegroundColor Cyan

# Red gradient
Write-Host -NoNewline "  Red     "
for ($i = 0; $i -lt 100; $i++) {
    $r = [int](($i / 99.0) * 255)
    Write-Host -NoNewline "$esc[38;2;$r;0;0m█$reset"
}
Write-Host "  0 → 255"

# Green gradient
Write-Host -NoNewline "  Green   "
for ($i = 0; $i -lt 100; $i++) {
    $g = [int](($i / 99.0) * 255)
    Write-Host -NoNewline "$esc[38;2;0;$g;0m█$reset"
}
Write-Host "  0 → 255"

# Blue gradient
Write-Host -NoNewline "  Blue    "
for ($i = 0; $i -lt 100; $i++) {
    $b = [int](($i / 99.0) * 255)
    Write-Host -NoNewline "$esc[38;2;0;0;${b}m█$reset"
}
Write-Host "  0 → 255"

Write-Host ""

# Rainbow spectrum
Write-Host -NoNewline "  Rainbow "
for ($i = 0; $i -lt 100; $i++) {
    $hue = $i / 99.0 * 360
    $rad = $hue * [math]::PI / 180
    $r = [int]([math]::Max(0, [math]::Min(255, 255 * [math]::Sin($rad))))
    $g = [int]([math]::Max(0, [math]::Min(255, 255 * [math]::Sin($rad + 2.094))))
    $b = [int]([math]::Max(0, [math]::Min(255, 255 * [math]::Sin($rad + 4.188))))
    Write-Host -NoNewline "$esc[38;2;$r;$g;${b}m█$reset"
}
Write-Host "  Full Hue"

# Cyan to Magenta
Write-Host -NoNewline "  C → M   "
for ($i = 0; $i -lt 100; $i++) {
    $t = $i / 99.0
    $r = [int]($t * 255)
    $g = [int]((1 - $t) * 255)
    $b = 255
    Write-Host -NoNewline "$esc[38;2;$r;$g;${b}m█$reset"
}
Write-Host "  Cyan → Magenta"

# Yellow to Blue
Write-Host -NoNewline "  Y → B   "
for ($i = 0; $i -lt 100; $i++) {
    $t = $i / 99.0
    $r = [int]((1 - $t) * 255)
    $g = [int]((1 - $t) * 255)
    $b = [int]($t * 255)
    Write-Host -NoNewline "$esc[38;2;$r;$g;${b}m█$reset"
}
Write-Host "  Yellow → Blue"

Write-Host ""
