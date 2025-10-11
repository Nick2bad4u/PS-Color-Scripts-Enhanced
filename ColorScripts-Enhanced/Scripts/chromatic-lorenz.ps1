# Unique Concept: Lorenz attractor plotted across a terminal grid with time-coded hues and speed-weighted highlights.


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

$width = 96
$height = 40
$steps = 5200
$dt = 0.008

$sigma = 10.0
$rho = 28.0
$beta = 8.0 / 3.0

$x = 0.1
$y = 0.0
$z = 0.0

$points = New-Object 'System.Collections.Generic.List[object]'
$minX = [double]::PositiveInfinity
$maxX = [double]::NegativeInfinity
$minZ = [double]::PositiveInfinity
$maxZ = [double]::NegativeInfinity
$minSpeed = [double]::PositiveInfinity
$maxSpeed = [double]::NegativeInfinity

for ($i = 0; $i -lt $steps; $i++) {
    $dx = $sigma * ($y - $x)
    $dy = $x * ($rho - $z) - $y
    $dz = ($x * $y) - ($beta * $z)

    $speed = [math]::Sqrt($dx * $dx + $dy * $dy + $dz * $dz)

    $x += $dx * $dt
    $y += $dy * $dt
    $z += $dz * $dt

    if ($x -lt $minX) { $minX = $x }
    if ($x -gt $maxX) { $maxX = $x }
    if ($z -lt $minZ) { $minZ = $z }
    if ($z -gt $maxZ) { $maxZ = $z }
    if ($speed -lt $minSpeed) { $minSpeed = $speed }
    if ($speed -gt $maxSpeed) { $maxSpeed = $speed }

    $null = $points.Add([pscustomobject]@{
            X     = $x
            Y     = $y
            Z     = $z
            Index = $i
            Speed = $speed
        })
}

if ($maxX -eq $minX) { $maxX = $minX + 1e-6 }
if ($maxZ -eq $minZ) { $maxZ = $minZ + 1e-6 }
if ($maxSpeed -eq $minSpeed) { $maxSpeed = $minSpeed + 1e-6 }

$grid = @{}

foreach ($p in $points) {
    $gx = [math]::Floor((($p.X - $minX) / ($maxX - $minX)) * ($width - 1))
    $gy = [math]::Floor((($p.Z - $minZ) / ($maxZ - $minZ)) * ($height - 1))

    if ($gx -lt 0) { $gx = 0 }
    if ($gx -ge $width) { $gx = $width - 1 }
    if ($gy -lt 0) { $gy = 0 }
    if ($gy -ge $height) { $gy = $height - 1 }

    $key = "$gx,$gy"
    $progress = $p.Index / ($steps - 1)
    $speedFactor = ($p.Speed - $minSpeed) / ($maxSpeed - $minSpeed)

    if (-not $grid.ContainsKey($key) -or $p.Index -gt $grid[$key].Index) {
        $char =
        if ($speedFactor -gt 0.75) { '✶' }
        elseif ($speedFactor -gt 0.35) { '•' }
        else { '·' }

        $grid[$key] = [pscustomobject]@{
            Index      = $p.Index
            Hue        = $progress
            Saturation = 0.9
            Value      = 0.35 + (0.6 * $speedFactor)
            Char       = $char
        }
    }
}

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"
        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]
            $rgb = Convert-HsvToRgb -Hue $cell.Hue -Saturation $cell.Saturation -Value $cell.Value
            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$($cell.Char)")
        }
        else {
            $null = $sb.Append("$esc[38;2;12;12;18m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
