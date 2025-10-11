# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27
$reset = "$esc[0m"

# Prism Diagonals: diagonal RGB ribbons with subtle shimmer
$rows = 16
$cols = 80

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $line = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $d = ($x + $y)
        $r = [int](90 + 165 * [math]::Abs([math]::Sin(($d) * 0.12)))
        $g = [int](90 + 165 * [math]::Abs([math]::Sin(($d) * 0.12 + 2.094)))
        $b = [int](90 + 165 * [math]::Abs([math]::Sin(($d) * 0.12 + 4.188)))

        # thin dark separators for crisp diagonal edges
        if ( ($x - $y) % 9 -eq 0 ) { $r = [int]($r * 0.5); $g = [int]($g * 0.5); $b = [int]($b * 0.5) }

        $null = $line.Append("$esc[48;2;$r;$g;$b" + "m ")
    }
    $null = $line.Append($reset)
    Write-Host $line.ToString()
}
Write-Host $reset
