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
for ($row = 0; $row -lt 2; $row++) {
    foreach ($line in $catLines) {
        $coloredLine = ""
        for ($i = 0; $i -lt 3; $i++) {
            $colorIdx = ($row * 3 + $i) % $colors.Count
            $color = $colors[$colorIdx]
            $coloredLine += "$esc[${color}m$boldon$line$reset"
        }
        $output += "$coloredLine`n"
    }
}

Write-Host "$reset$output"
