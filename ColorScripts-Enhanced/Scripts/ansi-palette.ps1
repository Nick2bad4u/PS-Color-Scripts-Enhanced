# ANSI Palette - Comprehensive 256-color palette display
# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27

Write-Host "`n  ANSI 256-COLOR PALETTE`n" -ForegroundColor Cyan

# Standard 16 colors
Write-Host "  Standard 16 Colors (0-15):"
Write-Host -NoNewline "  "
for ($i = 0; $i -lt 8; $i++) {
    Write-Host -NoNewline "$esc[48;5;${i}m    $esc[0m "
}
Write-Host ""
Write-Host -NoNewline "  "
for ($i = 8; $i -lt 16; $i++) {
    Write-Host -NoNewline "$esc[48;5;${i}m    $esc[0m "
}
Write-Host "`n"

# 216 color cube (6x6x6)
Write-Host "  216-Color Cube (16-231):"
for ($g = 0; $g -lt 6; $g++) {
    Write-Host "  "
    for ($r = 0; $r -lt 6; $r++) {
        Write-Host -NoNewline "  "
        for ($b = 0; $b -lt 6; $b++) {
            $color = 16 + ($r * 36) + ($g * 6) + $b
            Write-Host -NoNewline "$esc[48;5;${color}m  $esc[0m"
        }
    }
    Write-Host ""
}
Write-Host ""

# Grayscale ramp
Write-Host "  Grayscale Ramp (232-255):"
Write-Host -NoNewline "  "
for ($i = 232; $i -lt 256; $i++) {
    Write-Host -NoNewline "$esc[48;5;${i}m   $esc[0m"
    if (($i - 231) % 12 -eq 0 -and $i -ne 255) {
        Write-Host ""
        Write-Host -NoNewline "  "
    }
}
Write-Host "`n"

# Color samples with labels
Write-Host "  Foreground & Background Combinations:"
$colors = @(
    @(196, "Red"),
    @(208, "Orange"),
    @(226, "Yellow"),
    @(46, "Green"),
    @(51, "Cyan"),
    @(21, "Blue"),
    @(201, "Magenta"),
    @(231, "White")
)

foreach ($c in $colors) {
    $fg = $c[0]
    $name = $c[1]
    Write-Host -NoNewline "  $esc[38;5;${fg}m●$esc[0m "
    Write-Host -NoNewline "$name".PadRight(10)
    Write-Host -NoNewline "$esc[48;5;${fg}m       $esc[0m  "
    Write-Host -NoNewline "$esc[38;5;${fg}m▓▓▓▓▓▓▓$esc[0m  "
    Write-Host "$esc[38;5;${fg};1m★ Bold Star ★$esc[0m"
}
Write-Host ""
