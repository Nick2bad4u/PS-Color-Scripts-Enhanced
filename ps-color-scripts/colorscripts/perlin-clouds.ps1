# Unique Concept: 3D Perlin noise slice with multi-octave turbulence creating organic cloud-like formations.
# Samples noise at different frequencies and combines them for detailed terrain-like patterns.

# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$ErrorActionPreference = 'Stop'
$esc = [char]27
$reset = "$esc[0m"

function Convert-HsvToRgb {
    param([double]$Hue, [double]$Saturation, [double]$Value)
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

function Clamp([double]$Value, [double]$Min, [double]$Max) {
    if ($Value -lt $Min) { return $Min }
    if ($Value -gt $Max) { return $Max }
    return $Value
}

function Get-PerlinNoise([double]$x, [double]$y) {
    # Simplified Perlin-like noise using sine waves
    $n = [math]::Sin($x * 2.1 + [math]::Sin($y * 1.7)) +
    [math]::Sin($y * 2.3 + [math]::Cos($x * 1.9)) +
    [math]::Sin(($x + $y) * 1.5) +
    [math]::Sin([math]::Sqrt($x * $x + $y * $y) * 2.8)
    return $n / 4.0
}

$width = 110
$height = 26
$time = ([DateTime]::Now.Ticks / 10000000.0) % 100

for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $x = $col / 15.0
        $y = $row / 15.0

        # Multi-octave noise
        $noise = Get-PerlinNoise -x $x -y $y
        $noise += 0.5 * (Get-PerlinNoise -x ($x * 2) -y ($y * 2))
        $noise += 0.25 * (Get-PerlinNoise -x ($x * 4 + $time * 0.1) -y ($y * 4))
        $noise = $noise / 1.75

        $normalized = ($noise + 1.0) / 2.0

        $hue = (0.55 + $normalized * 0.3 + [math]::Sin($x + $y) * 0.1) % 1
        $saturation = Clamp -Value (0.5 + 0.4 * $normalized) -Min 0 -Max 1
        $value = Clamp -Value (0.3 + 0.65 * $normalized) -Min 0.25 -Max 1

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

        $symbol = if ($normalized -gt 0.75) { '█' }
        elseif ($normalized -gt 0.55) { '▓' }
        elseif ($normalized -gt 0.4) { '▒' }
        elseif ($normalized -gt 0.25) { '░' }
        else { '·' }

        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
