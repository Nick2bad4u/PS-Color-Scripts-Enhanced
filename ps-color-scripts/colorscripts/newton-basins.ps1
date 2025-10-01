# Unique Concept: Newton's method visualization for finding polynomial roots in the complex plane.
# Colors show which root each point converges to, creating beautiful basin boundaries.

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

# Newton's method for z^5 - 1 = 0
# Derivative: 5*z^4
function Apply-NewtonIteration {
    param(
        [double]$Zr,
        [double]$Zi,
        [int]$MaxIter
    )

    $x = $Zr
    $y = $Zi

    for ($iter = 0; $iter -lt $MaxIter; $iter++) {
        # Calculate z^5
        $x2 = $x * $x
        $y2 = $y * $y
        $x4 = $x2 * $x2 - $y2 * $y2
        $y4 = 2 * $x2 * $y2

        $z5r = $x4 * $x - $y4 * $y - $y2 * $y * 2 * $x2 - $y2 * $y * $y2
        $z5i = $x4 * $y + $y4 * $x + 2 * $x2 * $x * $y2 + $x * $y2 * $y2

        # Subtract 1 from z^5
        $fr = $z5r - 1.0
        $fi = $z5i

        # Calculate 5*z^4
        $fpr = 5 * ($x4 - $y4)
        $fpi = 5 * (4 * $x * $x2 * $y - 4 * $x * $y * $y2)

        # Avoid division by zero
        $denom = $fpr * $fpr + $fpi * $fpi
        if ($denom -lt 1e-10) { break }

        # z = z - f(z)/f'(z)
        $divr = ($fr * $fpr + $fi * $fpi) / $denom
        $divi = ($fi * $fpr - $fr * $fpi) / $denom

        $xNew = $x - $divr
        $yNew = $y - $divi

        # Check convergence
        $diff = [math]::Sqrt(($xNew - $x) * ($xNew - $x) + ($yNew - $y) * ($yNew - $y))
        if ($diff -lt 1e-6) {
            return @{
                X    = $xNew
                Y    = $yNew
                Iter = $iter
            }
        }

        $x = $xNew
        $y = $yNew
    }

    return @{
        X    = $x
        Y    = $y
        Iter = $MaxIter
    }
}

# Calculate the 5 roots of z^5 = 1
$roots = @()
for ($k = 0; $k -lt 5; $k++) {
    $angle = 2 * [math]::PI * $k / 5.0
    $roots += @{
        X   = [math]::Cos($angle)
        Y   = [math]::Sin($angle)
        Hue = $k / 5.0
    }
}

$width = 120
$height = 40
$zoom = 1.5

for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $zr = ($col - $width / 2.0) / ($width / 2.0) * $zoom * 1.5
        $zi = ($row - $height / 2.0) / ($height / 2.0) * $zoom

        $result = Apply-NewtonIteration -Zr $zr -Zi $zi -MaxIter 50

        # Find which root we converged to
        $closestRoot = 0
        $minDist = [double]::MaxValue

        for ($i = 0; $i -lt $roots.Count; $i++) {
            $dx = $result.X - $roots[$i].X
            $dy = $result.Y - $roots[$i].Y
            $dist = $dx * $dx + $dy * $dy

            if ($dist -lt $minDist) {
                $minDist = $dist
                $closestRoot = $i
            }
        }

        $hue = $roots[$closestRoot].Hue

        # Brightness based on convergence speed
        $normalized = 1.0 - ($result.Iter / 50.0)
        $saturation = Clamp -Value (0.65 + 0.3 * $normalized) -Min 0 -Max 1
        $value = Clamp -Value (0.3 + 0.65 * [math]::Pow($normalized, 0.7)) -Min 0.25 -Max 1.0

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

        # Symbol by convergence speed
        if ($result.Iter -lt 5) { $symbol = '█' }
        elseif ($result.Iter -lt 10) { $symbol = '▓' }
        elseif ($result.Iter -lt 20) { $symbol = '▒' }
        elseif ($result.Iter -lt 35) { $symbol = '░' }
        else { $symbol = '·' }

        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
