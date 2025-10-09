# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$reset = "$esc[0m"

$rows = 26
$cols = 70
$timeShift = Get-Random -Minimum 0.0 -Maximum ([math]::PI * 2)

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $t = $x / [double]($cols - 1)
        $phase = $timeShift + $t * [math]::PI * 2
        $rain = [math]::Sin($phase + $y * 0.6)
        $speed = [math]::Sin($phase * 1.5 + $y * 0.3)

        $h = ($t + $rain * 0.05) % 1
        if ($h -lt 0) { $h += 1 }
        $s = 0.65 + 0.25 * $rain
        $l = 0.35 + 0.4 * (1 - $y / [double]$rows)

        $r = [int][math]::Round(255 * (1 - $s * [math]::Max(0, [math]::Min(1, ([math]::Abs($h * 6 - 3) - 1)))))
        $g = [int][math]::Round(255 * (1 - $s * [math]::Max(0, [math]::Min(1, ([math]::Abs($h * 6 - 1) - 1)))))
        $b = [int][math]::Round(255 * (1 - $s * [math]::Max(0, [math]::Min(1, ([math]::Abs($h * 6 - 5) - 1)))))
        $r = [int][math]::Round($r * $l)
        $g = [int][math]::Round($g * $l)
        $b = [int][math]::Round($b * $l)

        $rainPhase = ($rain + $speed) / 2
        $char = if ($rainPhase -gt 0.45) { '│' }
        elseif ($rainPhase -gt 0.2) { '╎' }
        elseif ($rainPhase -gt -0.1) { '╵' }
        else { '·' }

        $null = $sb.Append("$esc[38;2;$r;$g;$b" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}

$label = "$esc[38;2;180;220;255mPRISMATIC$esc[0m $esc[38;2;255;190;220mRAIN$esc[0m"
$padLeft = [math]::Max(0, [int](($cols - ([regex]::Replace($label, "$([char]27)\[[0-9;]*m", '')).Length) / 2))
Write-Host ((' ' * $padLeft) + $label)
Write-Host $reset
