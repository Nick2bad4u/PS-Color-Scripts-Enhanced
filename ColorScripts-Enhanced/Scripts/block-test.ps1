# Block Test - Shows various block characters and shading patterns
# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27

Write-Host "`n  BLOCK CHARACTERS & SHADING PATTERNS`n" -ForegroundColor Cyan

# Full blocks with colors
Write-Host "  Full Blocks (█) - Color Spectrum:"
Write-Host -NoNewline "  "
for ($i = 0; $i -lt 100; $i++) {
    $r = [int](128 + 127 * [math]::Sin($i * 0.1))
    $g = [int](128 + 127 * [math]::Sin($i * 0.1 + 2.094))
    $b = [int](128 + 127 * [math]::Sin($i * 0.1 + 4.188))
    Write-Host -NoNewline "$esc[38;2;$r;$g;${b}m█$esc[0m"
}
Write-Host "`n"

# Shading gradients
Write-Host "  Shading Gradient Levels:"
Write-Host "  Full:    ████████████████████████████████████████"
Write-Host "  Dark:    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
Write-Host "  Medium:  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
Write-Host "  Light:   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
Write-Host "  Dots:    ∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙"
Write-Host ""

# Smooth gradient using all shades
Write-Host "  Smooth Gradient (5 levels):"
Write-Host -NoNewline "  "
for ($i = 0; $i -lt 100; $i++) {
    $level = [int](($i / 99.0) * 4)
    $chars = @(' ', '░', '▒', '▓', '█')
    Write-Host -NoNewline $chars[$level]
}
Write-Host "`n"

# Colored shading patterns
Write-Host "  Colored Shading Patterns:"
$patterns = @(
    @("Red to Black", @(255, 0, 0)),
    @("Green to Black", @(0, 255, 0)),
    @("Blue to Black", @(0, 0, 255)),
    @("Cyan to Black", @(0, 255, 255)),
    @("Magenta to Black", @(255, 0, 255))
)

foreach ($p in $patterns) {
    Write-Host -NoNewline "  $($p[0]):".PadRight(20)
    $baseColor = $p[1]
    for ($i = 0; $i -lt 60; $i++) {
        $t = 1.0 - ($i / 59.0)
        $r = [int]($baseColor[0] * $t)
        $g = [int]($baseColor[1] * $t)
        $b = [int]($baseColor[2] * $t)
        Write-Host -NoNewline "$esc[38;2;$r;$g;${b}m█$esc[0m"
    }
    Write-Host ""
}
Write-Host ""

# Half blocks
Write-Host "  Half Block Characters:"
Write-Host "  Upper Half:  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
Write-Host "  Lower Half:  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
Write-Host "  Left Half:   ▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌"
Write-Host "  Right Half:  ▐▐▐▐▐▐▐▐▐▐▐▐▐▐▐▐▐▐▐▐"
Write-Host ""

# Quarter blocks
Write-Host "  Quarter & Partial Blocks:"
Write-Host "  ▘▝▀▖▌▞▛▗▚▐▜▄▙▟█  ▏▎▍▌▋▊▉█  ▁▂▃▄▅▆▇█  ▔▀"
Write-Host ""

# Patterns
Write-Host "  Block Patterns:"
Write-Host "  Checkerboard: ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀"
Write-Host "                 ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄"
Write-Host "  Diagonal:     ▟▀▜▖▗▛▄▙  ▞▀▚▌▐▞▄▚  ▛▀▀▜▙▄▄▟"
Write-Host "  Mixed:        ▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓"
Write-Host ""

# 3D-ish effect
Write-Host "  3D Effect using Shading:"
Write-Host "  ░░▒▒▓▓██████████████████▓▓▒▒░░"
Write-Host "  ░▒▓███████████████████████▓▒░"
Write-Host "  ▒▓██████████████████████████▓▒"
Write-Host "  ▓████████████████████████████▓"
Write-Host "  ▒▓██████████████████████████▓▒"
Write-Host "  ░▒▓███████████████████████▓▒░"
Write-Host "  ░░▒▒▓▓██████████████████▓▓▒▒░░"
Write-Host ""
