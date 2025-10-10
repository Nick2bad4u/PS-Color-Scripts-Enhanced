# Horizon Stripes - bold layers fading toward the skyline
# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$reset = "$esc[0m"

$rows = 24
$cols = 82
$bands = @(
    @{
        R      = 245
        G      = 140
        B      = 90
        Symbol = '─'
    }
    @{
        R      = 255
        G      = 200
        B      = 120
        Symbol = '═'
    }
    @{
        R      = 110
        G      = 170
        B      = 220
        Symbol = '─'
    }
    @{
        R      = 40
        G      = 80
        B      = 140
        Symbol = '═'
    }
)

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    $bandIndex = [int]([math]::Floor(($y / $rows) * $bands.Count * 1.0001))
    if ($bandIndex -ge $bands.Count) { $bandIndex = $bands.Count - 1 }
    $band = $bands[$bandIndex]
    for ($x = 0; $x -lt $cols; $x++) {
        $t = $x / [double]([math]::Max($cols - 1, 1))
        $glow = 0.6 + 0.4 * [math]::Sin($t * 6.28318530718 + $bandIndex)
        $r = [int]([math]::Max([math]::Min(255, $band.R * $glow), 0))
        $g = [int]([math]::Max([math]::Min(255, $band.G * $glow), 0))
        $b = [int]([math]::Max([math]::Min(255, $band.B * $glow), 0))
        $char = $band.Symbol
        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
