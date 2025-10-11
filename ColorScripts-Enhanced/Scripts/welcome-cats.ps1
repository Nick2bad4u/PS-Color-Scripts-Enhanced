# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27


$boldon = "$esc[1m"
$reset = "$esc[0m"

# Define the cat lines
$catLines = @(
    "──────▄▀▄─────▄▀▄─────────",
    "─────▄█░░▀▀▀▀▀░░█▄────────",
    "─▄▄──█░░░░░░░░░░░█──▄▄────",
    "█▄▄█─█░░▀░░┬░░▀░░█─█▄▄█───"
)

# Define 6 gradient colors (ANSI codes)
$colors = @(31, 33, 32, 34, 35, 36)  # Red, Yellow, Green, Blue, Magenta, Cyan

# Build the output
$output = ""
foreach ($line in $catLines) {
    $coloredLine = ""
    for ($i = 0; $i -lt 6; $i++) {
        $color = $colors[$i]
        $coloredLine += "$esc[${color}m$line$reset"
    }
    $output += "$coloredLine`n"
}

Write-Host "$reset$boldon$output"
