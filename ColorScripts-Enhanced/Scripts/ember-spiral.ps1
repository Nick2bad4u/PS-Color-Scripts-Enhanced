# Ember Spiral - swirling embers caught in a thermal updraft

$esc = [char]27
$reset = "$esc[0m"

$rows = 28
$cols = 78
$centerY = ($rows - 1) / 2.0
$centerX = ($cols - 1) / 2.0
$charSequence = '.:*oO@#'

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $dx = ($x - $centerX)
        $dy = ($y - $centerY)
        $angle = [math]::Atan2($dy, $dx)
        $radius = [math]::Sqrt($dx * $dx + $dy * $dy)
        $wave = [math]::Sin($radius * 0.6 - $angle * 2)
        $heat = [math]::Min(1.0, [math]::Max(0.0, 0.55 + 0.45 * $wave))
        $r = [int](180 + 70 * $heat)
        $g = [int](60 + 90 * $heat)
        $b = [int](30 + 40 * $heat - 20 * ($radius / $centerX))
        if ($b -lt 0) { $b = 0 }
        $index = [int]([math]::Min($charSequence.Length - 1, [math]::Floor($heat * $charSequence.Length)))
        $char = $charSequence[$index]
        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
