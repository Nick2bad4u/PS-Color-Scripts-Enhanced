# Galaxy Panel: Static star cluster with color-coded depth.

# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27
$w = 100
$h = 12
$stars = 140
$grid = @()
for ($i=0; $i -lt $h; $i++) { $grid += ,(@(" " * $w).ToCharArray()) }

for ($s=0; $s -lt $stars; $s++) {
    $x = Get-Random -Minimum 0 -Maximum $w
    $y = Get-Random -Minimum 0 -Maximum $h
    $depth = Get-Random
    $depth = $depth / [int]::MaxValue
    $char = if ($depth -lt 0.3) { "." } elseif ($depth -lt 0.6) { "•" } else { "✶" }
    $grid[$y][$x] = $char
}

# Add planet in the center (draw a filled circle with radius 5)
$planetX = [int]($w / 2)
$planetY = [int]($h / 2)
$planetRadius = 5
$planetCoreChar = "●"
$planetEdgeChar = "◉"
for ($py = -$planetRadius; $py -le $planetRadius; $py++) {
    for ($px = -$planetRadius; $px -le $planetRadius; $px++) {
        $dist = [math]::Sqrt($px*$px + $py*$py)
        if ($dist -le $planetRadius) {
            $drawX = $planetX + $px
            $drawY = $planetY + $py
            if ($drawX -ge 0 -and $drawX -lt $w -and $drawY -ge 0 -and $drawY -lt $h) {
                if ($dist -le $planetRadius - 1) {
                    $grid[$drawY][$drawX] = $planetCoreChar
                } else {
                    $grid[$drawY][$drawX] = $planetEdgeChar
                }
            }
        }
    }
}

for ($row=0; $row -lt $h; $row++) {
    $line = New-Object System.Text.StringBuilder
    for ($col=0; $col -lt $w; $col++) {
        $ch = $grid[$row][$col]
        switch ($ch) {
            "." { $color = "245;245;255" }
            "•" { $color = "180;200;255" }
            "✶" { $color = "255;220;160" }
            "●" { $color = "80;150;120" } # planet core color
            "◉" { $color = "120;255;180" } # planet edge color
            default { $color = "80;80;90" }
        }
        $null = $line.Append("$esc[38;2;$color" + "m$ch")
    }
    $null = $line.Append("$esc[0m")
    Write-Host $line.ToString()
}
