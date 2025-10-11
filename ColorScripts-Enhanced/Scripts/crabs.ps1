# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27


$boldon = "$esc[1m"
$reset = "$esc[0m"

# Crab design (single column)
$crab = @(
    "░░▄█▀▀▀░░░░░░░░▀▀▀█▄  ",
    "▄███▄▄░░▀▄██▄▀░░▄▄███▄",
    "▀██▄▄▄▄████████▄▄▄▄██▀",
    "░░▄▄▄▄██████████▄▄▄▄  ",
    "░▐▐▀▐▀░▀██████▀░▀▌▀▌▌ "
)

# 6 colors: Red, Yellow, Cyan, Green, Magenta, Blue
$colors = @(31, 33, 36, 32, 35, 34)

Write-Host
for ($row = 0; $row -lt $crab.Count; $row++) {
    $line = ""
    for ($col = 0; $col -lt 6; $col++) {
        $color = $colors[$col]
        $line += "$esc[${color}m$($crab[$row])$reset "
    }
    Write-Host "$boldon$line"
}
Write-Host "$reset"
