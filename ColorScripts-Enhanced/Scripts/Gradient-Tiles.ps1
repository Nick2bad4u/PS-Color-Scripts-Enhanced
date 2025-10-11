# Gradient Tiles: 2D block gradient using 24-bit color.


$esc = [char]27
$rows = 8
$cols = 100
for ($y=0; $y -lt $rows; $y++) {
    $line = New-Object System.Text.StringBuilder
    for ($x=0; $x -lt $cols; $x++) {
        $r = [int](30 + 225 * ($x / ($cols-1)))
        $g = [int](30 + 225 * ($y / ($rows-1)))
        $b = [int](30 + 225 * ((($x+$y)/($cols+$rows-2))))
        $null = $line.Append("$esc[48;2;$r;$g;$b" + "m ")
    }
    $null = $line.Append("$esc[0m")
    Write-Host $line.ToString()
}
