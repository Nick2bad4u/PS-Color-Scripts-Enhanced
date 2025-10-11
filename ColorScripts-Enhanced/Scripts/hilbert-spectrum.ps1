# Unique Concept: Order-5 Hilbert curve traced with corner-aware box drawing and spectral progression along the path.


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

function Get-HilbertPoint {
    param(
        [int]$Index,
        [int]$Order
    )

    $x = 0
    $y = 0
    $t = $Index
    $n = 1 -shl $Order

    for ($s = 1; $s -lt $n; $s = $s * 2) {
        $rx = ($t -band 2) -shr 1
        $ry = (($t -band 1) -bxor $rx)

        if ($ry -eq 0) {
            if ($rx -eq 1) {
                $x = $s - 1 - $x
                $y = $s - 1 - $y
            }
            $swap = $x
            $x = $y
            $y = $swap
        }

        $x += $rx * $s
        $y += $ry * $s
        $t = $t -shr 2
    }

    return [pscustomobject]@{ X = $x; Y = $y }
}

$order = 5
$size = 1 -shl $order
$total = $size * $size
$xs = New-Object 'int[]' $total
$ys = New-Object 'int[]' $total

for ($i = 0; $i -lt $total; $i++) {
    $pt = Get-HilbertPoint -Index $i -Order $order
    $xs[$i] = $pt.X
    $ys[$i] = $pt.Y
}

$grid = @{}
for ($i = 0; $i -lt $total; $i++) {
    $x = $xs[$i]
    $y = $ys[$i]
    if (-not $grid.ContainsKey("$x,$y")) {
        $prevX = if ($i -gt 0) { $x - $xs[$i - 1] } else { 0 }
        $prevY = if ($i -gt 0) { $y - $ys[$i - 1] } else { 0 }
        $nextX = if ($i -lt $total - 1) { $xs[$i + 1] - $x } else { 0 }
        $nextY = if ($i -lt $total - 1) { $ys[$i + 1] - $y } else { 0 }

        $grid["$x,$y"] = [pscustomobject]@{
            Index = $i
            PrevX = $prevX
            PrevY = $prevY
            NextX = $nextX
            NextY = $nextY
        }
    }
}

$cornerMap = @{
    '-1,0|0,1'  = '┛'
    '-1,0|0,-1' = '┓'
    '1,0|0,1'   = '┗'
    '1,0|0,-1'  = '┏'
    '0,1|1,0'   = '┏'
    '0,1|-1,0'  = '┓'
    '0,-1|1,0'  = '┗'
    '0,-1|-1,0' = '┛'
}

for ($row = $size - 1; $row -ge 0; $row--) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $size; $col++) {
        $key = "$col,$row"
        if ($grid.ContainsKey($key)) {
            $cell = $grid[$key]
            $progress = $cell.Index / [double]($total - 1)

            $entryX = - $cell.PrevX
            $entryY = - $cell.PrevY
            $exitX = $cell.NextX
            $exitY = $cell.NextY

            if ($entryX -eq 0 -and $entryY -eq 0) {
                $symbol = '●'
            }
            elseif ($exitX -eq 0 -and $exitY -eq 0) {
                $symbol = '◎'
            }
            elseif ($entryY -eq 0 -and $exitY -eq 0) {
                $symbol = '━'
            }
            elseif ($entryX -eq 0 -and $exitX -eq 0) {
                $symbol = '┃'
            }
            else {
                $lookup = "$entryX,$entryY|$exitX,$exitY"
                if ($cornerMap.ContainsKey($lookup)) {
                    $symbol = $cornerMap[$lookup]
                }
                else {
                    $symbol = '╳'
                }
            }

            $hue = ($progress + 0.18 * [math]::Sin(($col + $row) * 0.28) + 0.12 * [math]::Cos(($col - $row) * 0.31)) % 1
            if ($hue -lt 0) { $hue += 1 }
            $saturation = Clamp -Value (0.5 + 0.42 * [math]::Sin($progress * [math]::PI)) -Min 0 -Max 1
            $value = Clamp -Value (0.28 + 0.7 * [math]::Pow($progress, 0.6)) -Min 0.25 -Max 1

            $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value
            $token = "$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol"
            $null = $sb.Append($token)
            $null = $sb.Append($token)
        }
        else {
            $null = $sb.Append("$esc[38;2;8;9;12m  ")
        }
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
