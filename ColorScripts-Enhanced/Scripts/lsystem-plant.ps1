# Unique Concept: L-system fractal tree with branching rules and angle variations.
# Uses string rewriting to generate plant-like structures with recursive growth patterns.


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

# L-system: Axiom: F, Rules: F -> FF+[+F-F-F]-[-F+F+F]
$axiom = "F"
$rules = @{ 'F' = 'FF+[+F-F]-[-F+F]' }

# Apply L-system rules
$current = $axiom
for ($i = 0; $i -lt 4; $i++) {
    $next = ""
    foreach ($char in $current.ToCharArray()) {
        if ($rules.ContainsKey([string]$char)) {
            $next += $rules[[string]$char]
        }
        else {
            $next += $char
        }
    }
    $current = $next
}

# Interpret L-system to draw
$width = 100
$height = 26
$grid = @{}

$x = 50.0
$y = 25.0
$angle = -90.0  # Start pointing up
$angleIncrement = 25.0
$stepSize = 0.8
$stack = New-Object 'System.Collections.Generic.Stack[object]'
$depth = 0

foreach ($char in $current.ToCharArray()) {
    switch ($char) {
        'F' {
            # Draw forward
            $rad = $angle * [math]::PI / 180.0
            $newX = $x + $stepSize * [math]::Cos($rad)
            $newY = $y + $stepSize * [math]::Sin($rad)

            # Interpolate line
            $steps = 3
            for ($s = 0; $s -le $steps; $s++) {
                $t = $s / [double]$steps
                $px = [int]($x + ($newX - $x) * $t)
                $py = [int]($y + ($newY - $y) * $t)

                if ($px -ge 0 -and $px -lt $width -and $py -ge 0 -and $py -lt $height) {
                    $key = "$px,$py"
                    if (-not $grid.ContainsKey($key) -or $grid[$key].Depth -lt $depth) {
                        $grid[$key] = @{ Depth = $depth; Order = $grid.Count }
                    }
                }
            }

            $x = $newX
            $y = $newY
        }
        '+' { $angle += $angleIncrement }
        '-' { $angle -= $angleIncrement }
        '[' {
            $stack.Push(@{ X = $x; Y = $y; Angle = $angle; Depth = $depth })
            $depth++
        }
        ']' {
            if ($stack.Count -gt 0) {
                $state = $stack.Pop()
                $x = $state.X
                $y = $state.Y
                $angle = $state.Angle
                $depth = $state.Depth
            }
        }
    }
}

# Render
$maxDepth = ($grid.Values | Measure-Object -Property Depth -Maximum).Maximum
if ($null -eq $maxDepth) { $maxDepth = 1 }

for ($row = $height - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $key = "$col,$row"

        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]
            $depthRatio = $cell.Depth / [double]$maxDepth

            $hue = (0.25 + $depthRatio * 0.35) % 1
            $saturation = 0.7 - 0.3 * $depthRatio
            $value = 0.9 - 0.4 * $depthRatio

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $symbol = if ($depthRatio -lt 0.3) { '█' } elseif ($depthRatio -lt 0.6) { '▓' } else { '░' }

            $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
        }
        else {
            $null = $sb.Append("$esc[38;2;8;8;12m ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}
Write-Host $reset
