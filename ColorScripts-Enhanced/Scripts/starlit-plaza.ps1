# Starlit Plaza - geometric tiles under a glowing night sky
# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27
$reset = "$esc[0m"

$rows = 24
$cols = 84
$floorPattern = '+#++#'
$skyChars = @('.', ' ', '*', ' ')
$horizonRow = [int]($rows * 0.35)

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    if ($y -lt $horizonRow) {
        # Night sky portion
        for ($x = 0; $x -lt $cols; $x++) {
            $twinkle = (1 + [math]::Sin(($x * 0.28) + ($y * 0.47))) / 2
            $r = [int]([math]::Min(255, 60 + 40 * $twinkle))
            $g = [int]([math]::Min(255, 110 + 70 * $twinkle))
            $b = [int]([math]::Min(255, 180 + 70 * $twinkle))
            $char = $skyChars[($x * 7 + $y) % $skyChars.Count]
            $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
        }
    }
    else {
        # Plaza tiles
        $band = $y - $horizonRow
        for ($x = 0; $x -lt $cols; $x++) {
            $depth = ($y - $horizonRow) / [double]([math]::Max($rows - $horizonRow - 1, 1))
            $shade = 120 + 80 * (1 - $depth)
            $r = [int]([math]::Min(255, $shade + 20 * [math]::Sin($x * 0.19)))
            $g = [int]([math]::Min(255, $shade - 15 * [math]::Sin($x * 0.21)))
            $b = [int]([math]::Min(255, $shade + 10 * [math]::Cos($x * 0.17)))
            if ($r -lt 0) { $r = 0 }
            if ($g -lt 0) { $g = 0 }
            if ($b -lt 0) { $b = 0 }
            $char = $floorPattern[$x % $floorPattern.Length]
            $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
        }
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
