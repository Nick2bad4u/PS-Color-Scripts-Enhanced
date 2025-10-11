# Unique Concept: Abelian sandpile stabilization with radial ignition palette and height-coded tessellation.


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
    param(
        [double]$Value,
        [double]$Min,
        [double]$Max
    )

    if ($Value -lt $Min) { return $Min }
    if ($Value -gt $Max) { return $Max }
    return $Value
}

$size = 33
$grid = New-Object 'int[,]' $size, $size
$rand = [System.Random]::new(512)

for ($y = 0; $y -lt $size; $y++) {
    for ($x = 0; $x -lt $size; $x++) {
        $grid[$x, $y] = $rand.Next(0, 6)
    }
}

$center = [int]($size / 2)
for ($i = 0; $i -lt 600; $i++) {
    $grid[$center, $center] += 4
}

$maxIterations = 60000
$iteration = 0
$neighbors = @(
    @{ dx = 1; dy = 0 },
    @{ dx = -1; dy = 0 },
    @{ dx = 0; dy = 1 },
    @{ dx = 0; dy = -1 }
)

$unstable = $true
while ($unstable -and $iteration -lt $maxIterations) {
    $unstable = $false
    for ($y = 0; $y -lt $size; $y++) {
        for ($x = 0; $x -lt $size; $x++) {
            while ($grid[$x, $y] -ge 4) {
                $grid[$x, $y] -= 4
                foreach ($n in $neighbors) {
                    $nx = $x + $n.dx
                    $ny = $y + $n.dy
                    if ($nx -ge 0 -and $nx -lt $size -and $ny -ge 0 -and $ny -lt $size) {
                        $grid[$nx, $ny] += 1
                    }
                }
                $unstable = $true
            }
        }
    }
    $iteration++
}

$maxRadius = [math]::Sqrt(2 * ($center * $center))

for ($y = $size - 1; $y -ge 0; $y--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $size; $x++) {
        $value = $grid[$x, $y]
        $radius = [math]::Sqrt((($x - $center) * ($x - $center)) + (($y - $center) * ($y - $center))) / $maxRadius

        $hue = (0.08 + 0.22 * $value + 0.18 * $radius + 0.12 * [math]::Sin($x * 0.3 - $y * 0.21)) % 1
        if ($hue -lt 0) { $hue += 1 }
        $saturation = Clamp -Value (0.52 - 0.15 * $radius + 0.08 * $value) -Min 0 -Max 1
        $valueLevel = Clamp -Value (0.24 + 0.2 * $value + 0.35 * [math]::Exp(-$radius * 2.2)) -Min 0.2 -Max 1

        $symbol = switch ($value) {
            0 { '·' }
            1 { '░' }
            2 { '▒' }
            3 { '▓' }
            default { '█' }
        }

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $valueLevel
        $token = "$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol"
        $null = $sb.Append($token)
        $null = $sb.Append($token)
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
