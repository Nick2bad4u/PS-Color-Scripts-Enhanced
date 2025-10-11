# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27

# Colors - Using a vibrant palette
$c1 = "$esc[38;5;196m"  # Bright red
$c2 = "$esc[38;5;208m"  # Orange
$c3 = "$esc[38;5;226m"  # Yellow
$c4 = "$esc[38;5;46m"   # Bright green
$c5 = "$esc[38;5;45m"   # Cyan
$c6 = "$esc[38;5;93m"   # Purple

# Bright variants
$cb1 = "$esc[38;5;203m" # Light red
$cb2 = "$esc[38;5;215m" # Light orange
$cb3 = "$esc[38;5;229m" # Light yellow
$cb4 = "$esc[38;5;120m" # Light green
$cb5 = "$esc[38;5;87m"  # Light cyan
$cb6 = "$esc[38;5;141m" # Light purple

$rst = "$esc[0m"

$lines = @(
    "",
    "$c1     /\\     $c2     /\\     $c3     /\\     $c4     /\\     $c5     /\\     $c6     /\\     $rst",
    "$c1    /  \\    $c2    /  \\    $c3    /  \\    $c4    /  \\    $c5    /  \\    $c6    /  \\    $rst",
    "$c1   /    \\   $c2   /    \\   $c3   /    \\   $c4   /    \\   $c5   /    \\   $c6   /    \\   $rst",
    "$c1  /      \\  $c2  /      \\  $c3  /      \\  $c4  /      \\  $c5  /      \\  $c6  /      \\  $rst",
    "$c1 /        \\ $c2 /        \\ $c3 /        \\ $c4 /        \\ $c5 /        \\ $c6 /        \\ $rst",
    "$c1/__________\\$c2/__________\\$c3/__________\\$c4/__________\\$c5/__________\\$c6/__________\\$rst",
    "",
    "$cb1     /\\     $cb2     /\\     $cb3     /\\     $cb4     /\\     $cb5     /\\     $cb6     /\\     $rst",
    "$cb1    /  \\    $cb2    /  \\    $cb3    /  \\    $cb4    /  \\    $cb5    /  \\    $cb6    /  \\    $rst",
    "$cb1   /    \\   $cb2   /    \\   $cb3   /    \\   $cb4   /    \\   $cb5   /    \\   $cb6   /    \\   $rst",
    "$cb1  /      \\  $cb2  /      \\  $cb3  /      \\  $cb4  /      \\  $cb5  /      \\  $cb6  /      \\  $rst",
    "$cb1 /        \\ $cb2 /        \\ $cb3 /        \\ $cb4 /        \\ $cb5 /        \\ $cb6 /        \\ $rst",
    "$cb1/__________\\$cb2/__________\\$cb3/__________\\$cb4/__________\\$cb5/__________\\$cb6/__________\\$rst",
    "$rst"
)

foreach ($line in $lines) {
    Write-Host $line
}
