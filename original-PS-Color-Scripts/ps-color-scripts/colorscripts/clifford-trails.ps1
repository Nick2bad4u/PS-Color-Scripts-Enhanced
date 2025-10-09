# Unique Concept: Clifford attractor with particle trail accumulation and velocity-based color intensity.
# Creates organic flowing patterns using the equations: x' = sin(a*y) + c*cos(a*x), y' = sin(b*x) + d*cos(b*y)

# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$ErrorActionPreference = 'Stop'
$esc = [char]27
$reset = "$esc[0m"

function Convert-HsvToRgb {
    param(
        [double]$Hue,
        [double]$Saturation,
        [double]$Value
    )
    $h = ($Hue % 1) * 6
    $sector = [math]::Floor($h)
    $fraction = $h - $sector
    $p = $Value * (1 - $Saturation)
    $q = $Value * (1 - $fraction * $Saturation)
    $t = $Value * (1 - (1 - $fraction) * $Saturation)
    switch ($sector) {
        0 { $r = $Value; $g = $t; $b = $p }
        1 { $r = $q; $g = $Value; $b = $p }
        2 { $r = $p; $g = $Value; $b = $t }
        3 { $r = $p; $g = $q; $b = $Value }
        4 { $r = $t; $g = $p; $b = $Value }
        default { $r = $Value; $g = $p; $b = $q }
    }
    return @([int][math]::Round($r * 255), [int][math]::Round($g * 255), [int][math]::Round($b * 255))
}

function Clamp {
    param([double]$Value, [double]$Min, [double]$Max)
    if ($Value -lt $Min) { return $Min }
    if ($Value -gt $Max) { return $Max }
    return $Value
}

$width = 120
$height = 40
$iterations = 50000

# Clifford attractor parameters for interesting pattern
$a = -1.4
$b = 1.6
$c = 1.0
$d = 0.7

# Initialize position
$x = 0.1
$y = 0.1

# Track visited points with intensity
$heatmap = @{}
$maxIntensity = 0.0

# Generate attractor path
for ($i = 0; $i -lt $iterations; $i++) {
    $xNew = [math]::Sin($a * $y) + $c * [math]::Cos($a * $x)
    $yNew = [math]::Sin($b * $x) + $d * [math]::Cos($b * $y)

    $x = $xNew
    $y = $yNew

    # Map to grid coordinates
    $gridX = [int](($x + 2.5) / 5.0 * ($width - 1))
    $gridY = [int](($y + 2.5) / 5.0 * ($height - 1))

    if ($gridX -ge 0 -and $gridX -lt $width -and $gridY -ge 0 -and $gridY -lt $height) {
        $key = "$gridX,$gridY"
        if ($heatmap.ContainsKey($key)) {
            $heatmap[$key].Count++
            $heatmap[$key].LastSeen = $i
            if ($heatmap[$key].Count -gt $maxIntensity) {
                $maxIntensity = $heatmap[$key].Count
            }
        }
        else {
            $heatmap[$key] = [pscustomobject]@{
                Count    = 1
                LastSeen = $i
                X        = $x
                Y        = $y
            }
        }
    }
}

# Render the heatmap
for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($heatmap.ContainsKey($key)) {
            $cell = $heatmap[$key]
            $intensity = $cell.Count / $maxIntensity
            $age = $cell.LastSeen / [double]$iterations

            # Color based on position and intensity
            $hue = (($col / [double]$width) * 0.4 + ($row / [double]$height) * 0.3 + $age * 0.3) % 1
            $saturation = Clamp -Value (0.55 + 0.4 * $intensity) -Min 0 -Max 1
            $value = Clamp -Value (0.25 + 0.7 * [math]::Pow($intensity, 0.6)) -Min 0.2 -Max 1.0

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            # Symbol by density
            if ($intensity -gt 0.7) { $symbol = '█' }
            elseif ($intensity -gt 0.45) { $symbol = '▓' }
            elseif ($intensity -gt 0.25) { $symbol = '▒' }
            elseif ($intensity -gt 0.12) { $symbol = '░' }
            elseif ($intensity -gt 0.05) { $symbol = '∙' }
            else { $symbol = '·' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
