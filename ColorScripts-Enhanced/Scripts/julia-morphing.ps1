# Unique Concept: Julia set with morphing constant parameter creating multi-frame animation effect.
# The constant C rotates in complex plane, creating a dynamic transformation of the fractal structure.

# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

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

function Get-JuliaValue {
    param(
        [double]$Zx,
        [double]$Zy,
        [double]$Cx,
        [double]$Cy,
        [int]$MaxIter
    )

    $x = $Zx
    $y = $Zy
    $iter = 0

    while ($iter -lt $MaxIter) {
        $x2 = $x * $x
        $y2 = $y * $y

        if ($x2 + $y2 -gt 4.0) {
            $smoothIter = $iter + 1 - [math]::Log([math]::Log([math]::Sqrt($x2 + $y2))) / [math]::Log(2)
            return $smoothIter
        }

        $yTemp = 2.0 * $x * $y + $Cy
        $x = $x2 - $y2 + $Cx
        $y = $yTemp
        $iter++
    }

    return -1
}

$width = 110
$height = 38
$maxIter = 180
$zoom = 1.6

# Animate Julia constant in a circle around origin
$time = ([DateTime]::Now.Ticks / 10000000.0) % 60
$angle = $time * 0.3
$radius = 0.7885

$cx = $radius * [math]::Cos($angle)
$cy = $radius * [math]::Sin($angle)

for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $x = ($col - $width / 2.0) / ($width / 2.0) * $zoom * 1.5
        $y = ($row - $height / 2.0) / ($height / 2.0) * $zoom

        $value = Get-JuliaValue -Zx $x -Zy $y -Cx $cx -Cy $cy -MaxIter $maxIter

        if ($value -lt 0) {
            # Inside Julia set
            $dist = [math]::Sqrt($x * $x + $y * $y)
            $hue = ($angle / 6.28 + $dist * 0.3) % 1
            $rgb = Convert-HsvToRgb -Hue $hue -Saturation 0.65 -Value 0.25
            $symbol = '●'
        }
        else {
            # Outside - color by escape iteration
            $normalized = $value / $maxIter
            $hue = ($angle / 6.28 + $normalized * 1.8 + [math]::Sin($normalized * 12.56) * 0.15) % 1
            $saturation = Clamp -Value (0.6 + 0.35 * [math]::Sin($normalized * 6.28)) -Min 0 -Max 1
            $value = Clamp -Value (0.35 + 0.6 * [math]::Pow($normalized, 0.5)) -Min 0.25 -Max 1.0

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            if ($normalized -lt 0.1) { $symbol = '◉' }
            elseif ($normalized -lt 0.25) { $symbol = '◎' }
            elseif ($normalized -lt 0.45) { $symbol = '○' }
            elseif ($normalized -lt 0.7) { $symbol = '∘' }
            else { $symbol = '·' }
        }

        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
