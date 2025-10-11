# Unique Concept: Rössler attractor - a chaotic system creating ribbon-like patterns in 3D space.
# Projects the attractor onto 2D with depth-based coloring showing the folded structure.

# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

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

$width = 100
$height = 26

# Rössler attractor parameters
$a = 0.2
$b = 0.2
$c = 5.7
$dt = 0.05

$x = 0.1
$y = 0.0
$z = 0.0

$points = New-Object 'System.Collections.Generic.List[object]'
$steps = 4000

for ($i = 0; $i -lt $steps; $i++) {
    $dx = - $y - $z
    $dy = $x + $a * $y
    $dz = $b + $z * ($x - $c)

    $x += $dx * $dt
    $y += $dy * $dt
    $z += $dz * $dt

    $points.Add(@{ X = $x; Y = $y; Z = $z; Order = $i })
}

# Find bounds
$minX = ($points | Measure-Object -Property X -Minimum).Minimum
$maxX = ($points | Measure-Object -Property X -Maximum).Maximum
$minY = ($points | Measure-Object -Property Y -Minimum).Minimum
$maxY = ($points | Measure-Object -Property Y -Maximum).Maximum
$minZ = ($points | Measure-Object -Property Z -Minimum).Minimum
$maxZ = ($points | Measure-Object -Property Z -Maximum).Maximum

$grid = @{}

foreach ($pt in $points) {
    $nx = ($pt.X - $minX) / ($maxX - $minX)
    $ny = ($pt.Y - $minY) / ($maxY - $minY)
    $nz = ($pt.Z - $minZ) / ($maxZ - $minZ)

    $gx = [int]($nx * ($width - 1))
    $gy = [int]($ny * ($height - 1))

    if ($gx -ge 0 -and $gx -lt $width -and $gy -ge 0 -and $gy -lt $height) {
        $key = "$gx,$gy"
        $age = $pt.Order / [double]$steps

        if ($grid.ContainsKey($key)) {
            $grid[$key].Count++
            if ($age -gt $grid[$key].Age) {
                $grid[$key].Age = $age
                $grid[$key].Z = $nz
            }
        }
        else {
            $grid[$key] = @{
                Count = 1
                Age   = $age
                Z     = $nz
            }
        }
    }
}

# Render
for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]

            $hue = (0.5 + $cell.Z * 0.4 + $cell.Age * 0.1) % 1
            $saturation = 0.7
            $value = 0.3 + 0.6 * $cell.Age + 0.15 * ($cell.Count / 5.0)
            if ($value -gt 1.0) { $value = 1.0 }

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

            $symbol = if ($cell.Count -gt 4) { '█' }
            elseif ($cell.Count -gt 2) { '▓' }
            else { '∙' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
