# Rainbow Spiral - Static spiral pattern with rainbow colors
# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27
$width = 120
$height = 30
$centerX = $width / 2
$centerY = $height / 2

function HSVtoRGB($h, $s, $v) {
    $h = $h % 1
    $i = [math]::Floor($h * 6)
    $f = $h * 6 - $i
    $p = $v * (1 - $s)
    $q = $v * (1 - $f * $s)
    $t = $v * (1 - (1 - $f) * $s)

    switch ($i % 6) {
        0 { $r = $v; $g = $t; $b = $p }
        1 { $r = $q; $g = $v; $b = $p }
        2 { $r = $p; $g = $v; $b = $t }
        3 { $r = $p; $g = $q; $b = $v }
        4 { $r = $t; $g = $p; $b = $v }
        default { $r = $v; $g = $p; $b = $q }
    }

    return @([int]($r * 255), [int]($g * 255), [int]($b * 255))
}

# Static frame (no animation loop)
$frame = 90

Write-Host ""
for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $dx = $x - $centerX
        $dy = $y - $centerY
        $distance = [math]::Sqrt($dx * $dx + $dy * $dy)
        $angle = [math]::Atan2($dy, $dx)

        # Create spiral pattern
        $spiral = $angle + $distance * 0.1 + $frame * 0.05
        $hue = ($spiral / (2 * [math]::PI)) % 1

        # Add some variation
        $wave = [math]::Sin($distance * 0.2 + $frame * 0.1) * 0.1
        $hue = ($hue + $wave) % 1

        # Vary saturation and brightness
        $saturation = 0.8 + 0.2 * [math]::Sin($distance * 0.05)
        $value = 0.4 + 0.6 * [math]::Sin($angle * 2 + $frame * 0.02)

        $rgb = HSVtoRGB -h $hue -s $saturation -v $value

        Write-Host "$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m█$esc[0m" -NoNewline
    }
    Write-Host ""
}
Write-Host ""
