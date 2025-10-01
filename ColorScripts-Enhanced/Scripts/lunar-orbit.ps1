# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$reset = "$esc[0m"

$rows = 24
$cols = 72
$moons = @(
    @{ X = 16.0; Y = 11.0; Radius = 5.0; Hue = 0.62; Phase = 0.2 },
    @{ X = 36.0; Y = 9.0;  Radius = 6.0; Hue = 0.58; Phase = 0.5 },
    @{ X = 56.0; Y = 13.0; Radius = 4.2; Hue = 0.66; Phase = 0.85 }
)
$orbits = @(
    @{ CX = 36.0; CY = 11.5; A = 26.0; B = 9.5 },
    @{ CX = 36.0; CY = 11.5; A = 18.0; B = 6.5 }
)

function HslToRgb {
    param(
        [double]$Hue,
        [double]$Saturation,
        [double]$Lightness
    )

    if ($Saturation -eq 0) {
        $value = [int]([math]::Round($Lightness * 255))
        return @($value, $value, $value)
    }

    $q = if ($Lightness -lt 0.5) { $Lightness * (1 + $Saturation) } else { $Lightness + $Saturation - $Lightness * $Saturation }
    $p = 2 * $Lightness - $q
    $hk = $Hue % 1
    $toRgb = {
        param($t)
        if ($t -lt 0) { $t += 1 }
        if ($t -gt 1) { $t -= 1 }
        if (6 * $t -lt 1) { return $p + ($q - $p) * 6 * $t }
        if (2 * $t -lt 1) { return $q }
        if (3 * $t -lt 2) { return $p + ($q - $p) * ((2/3) - $t) * 6 }
        return $p
    }
    $r = & $toRgb ($hk + 1.0/3.0)
    $g = & $toRgb $hk
    $b = & $toRgb ($hk - 1.0/3.0)
    return @([int]([math]::Round($r * 255)), [int]([math]::Round($g * 255)), [int]([math]::Round($b * 255)))
}

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    $ny = $y / [double]($rows - 1)
    $baseHue = 0.6 + 0.05 * [math]::Sin($ny * [math]::PI)
    $baseLight = 0.12 + 0.25 * (1 - $ny)
    $baseRgb = HslToRgb -Hue $baseHue -Saturation 0.55 -Lightness $baseLight
    for ($x = 0; $x -lt $cols; $x++) {
        $char = '·'
        $rgb = $baseRgb.Clone()

        foreach ($orbit in $orbits) {
            $dx = ($x - $orbit.CX) / $orbit.A
            $dy = ($y - $orbit.CY) / $orbit.B
            $value = $dx * $dx + $dy * $dy
            if ([math]::Abs($value - 1.0) -lt 0.04) {
                $char = '∙'
                $rgb = HslToRgb -Hue 0.58 -Saturation 0.6 -Lightness 0.5
            }
        }

        foreach ($moon in $moons) {
            $dx = $x - $moon.X
            $dy = ($y - $moon.Y) * 1.2
            $dist = [math]::Sqrt($dx * $dx + $dy * $dy)
            if ($dist -le $moon.Radius) {
                $ratio = 1 - ($dist / $moon.Radius)
                $rgb = HslToRgb -Hue $moon.Hue -Saturation (0.35 + 0.4 * $ratio) -Lightness (0.6 + 0.2 * $ratio)
                $angle = ([math]::Atan2($dy, $dx) + [math]::PI * 2) % (2 * [math]::PI)
                $phaseAngle = ($moon.Phase * 2 * [math]::PI)
                $diff = [math]::Abs($angle - $phaseAngle)
                if ($diff -gt [math]::PI) { $diff = 2 * [math]::PI - $diff }
                $char = if ($diff -lt 0.5) { '◕' } elseif ($diff -lt 1.0) { '◑' } elseif ($diff -lt 1.5) { '◐' } else { '○' }
                break
            }
        }

        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])" + "m$char")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}

$label = "$esc[38;2;200;220;255mLUNAR$esc[0m $esc[38;2;160;200;255mORBIT$esc[0m"
$padLeft = [math]::Max(0, [int](($cols - ([regex]::Replace($label, "$([char]27)\[[0-9;]*m", '')).Length) / 2))
Write-Host ((' ' * $padLeft) + $label)
Write-Host $reset
