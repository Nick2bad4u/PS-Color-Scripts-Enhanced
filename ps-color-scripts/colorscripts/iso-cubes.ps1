$esc = [char]27
$reset = "$esc[0m"

# Iso Cubes: isometric cube illusion with spectral shading
$rows = 18
$cols = 78

Write-Host
for ($y = 0; $y -lt $rows; $y++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($x = 0; $x -lt $cols; $x++) {
        $h = ($x / [double]([math]::Max($cols-1,1))) * 6.28318530718
        $baseR = [int](120 + 120 * [math]::Sin($h))
        $baseG = [int](120 + 120 * [math]::Sin($h + 2.094))
        $baseB = [int](120 + 120 * [math]::Sin($h + 4.188))

        # create cube facets via repeating diamonds
        $u = ($x + 2*$y)
        $v = ($x - 2*$y)
        $side = ((($u / 6) -as [int]) + (($v / 6) -as [int])) % 3
        # Normalize to 0..2 range
        $side = ($side + 3) % 3
        switch ($side) {
            0 { $r=$baseR; $g=$baseG; $b=$baseB }
            1 { $r=[int]($baseR*0.70); $g=[int]($baseG*0.70); $b=[int]($baseB*0.70) }
            2 { $r=[int]([math]::Min(255,$baseR*1.15)); $g=[int]([math]::Min(255,$baseG*1.15)); $b=[int]([math]::Min(255,$baseB*1.15)) }
        }

        # thin grid lines
        if ( ($x % 6) -eq 0 -or ($y % 3) -eq 0 ) { $r=[int]($r*0.55); $g=[int]($g*0.55); $b=[int]($b*0.55) }

        $null = $sb.Append("$esc[48;2;$r;$g;$b" + "m ")
    }
    $null = $sb.Append($reset)
    Write-Host $sb.ToString()
}
Write-Host $reset
