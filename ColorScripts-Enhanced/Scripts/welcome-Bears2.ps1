$esc = [char]27


$boldon = "$esc[1m"
$reset = "$esc[0m"

# Define the improved bear lines
$bearLines = @(
    "───▄▀▀▀▄▄▄▄▄▄▄▀▀▀▄───",
    "───█▒▒░░░░░░░░░▒▒█───",
    "────█░░█░░░░░█░░█────",
    "─▄▄──█░░░▀█▀░░░█──▄▄─",
    "█░░█─▀▄░░░░░░░▄▀─█░░█"
)

# Define gradient colors (ANSI codes)
$colors = @(31, 33, 32, 34, 35, 37)  # Red, Yellow, Green, Blue, Magenta, White

# Number of repeats
$repeatCount = 3

# Build the output
$output = ""

# First row (3 bears)
for ($lineIdx = 0; $lineIdx -lt $bearLines.Count; $lineIdx++) {
    $line = ""
    for ($repeat = 0; $repeat -lt $repeatCount; $repeat++) {
        $color = $colors[$repeat % $colors.Count]
        $line += "$esc[${color}m$boldon$($bearLines[$lineIdx])$reset"
    }
    $output += "$line`n"
}

# Second row (3 bears)
for ($lineIdx = 0; $lineIdx -lt $bearLines.Count; $lineIdx++) {
    $line = ""
    for ($repeat = 0; $repeat -lt $repeatCount; $repeat++) {
        $color = $colors[($repeat + 3) % $colors.Count]
        $line += "$esc[${color}m$boldon$($bearLines[$lineIdx])$reset"
    }
    $output += "$line`n"
}

Write-Host "$reset$output"
