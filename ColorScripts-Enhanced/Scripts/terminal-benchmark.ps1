# Terminal Benchmark - Performance test for terminal color rendering

$esc = [char]27
$width = 120
$height = 30

Write-Host "`n  TERMINAL COLOR RENDERING BENCHMARK`n" -ForegroundColor Cyan

# Test 1: Simple color blocks
Write-Host "  Test 1: Simple Color Blocks (1000 cells)"
$start = Get-Date
for ($i = 0; $i -lt 1000; $i++) {
    $r = $i % 256
    $g = ($i * 3) % 256
    $b = ($i * 7) % 256
    Write-Host -NoNewline "$esc[38;2;$r;$g;${b}m█$esc[0m"
}
$end = Get-Date
$time1 = ($end - $start).TotalMilliseconds
Write-Host "`n  Time: $([math]::Round($time1, 2))ms`n"

# Test 2: HSV to RGB conversion
Write-Host "  Test 2: HSV to RGB Conversion (10000 conversions)"
$start = Get-Date
for ($i = 0; $i -lt 10000; $i++) {
    $h = ($i / 10000.0) % 1
    $s = 0.8
    $v = 0.6

    $hi = [math]::Floor($h * 6)
    $f = $h * 6 - $hi
    $p = $v * (1 - $s)
    $q = $v * (1 - $f * $s)
    $t = $v * (1 - (1 - $f) * $s)

    switch ($hi % 6) {
        0 { $r = $v; $g = $t; $b = $p }
        1 { $r = $q; $g = $v; $b = $p }
        2 { $r = $p; $g = $v; $b = $t }
        3 { $r = $p; $g = $q; $b = $v }
        4 { $r = $t; $g = $p; $b = $v }
        default { $r = $v; $g = $p; $b = $q }
    }
}
$end = Get-Date
$time2 = ($end - $start).TotalMilliseconds
Write-Host "  Time: $([math]::Round($time2, 2))ms`n"

# Test 3: Full screen rendering
Write-Host "  Test 3: Full Screen Rendering (3600 cells)"
$start = Get-Date
Write-Host "$esc[2J$esc[H" -NoNewline
for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $hue = ($x / $width + $y / $height) % 1
        $rgb = @(
            [int](128 + 127 * [math]::Sin($hue * 2 * [math]::PI)),
            [int](128 + 127 * [math]::Sin($hue * 2 * [math]::PI + 2.094)),
            [int](128 + 127 * [math]::Sin($hue * 2 * [math]::PI + 4.188))
        )
        Write-Host -NoNewline "$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m█$esc[0m"
    }
    Write-Host ""
}
$end = Get-Date
$time3 = ($end - $start).TotalMilliseconds
Write-Host "  Time: $([math]::Round($time3, 2))ms`n"

# Test 4: Mathematical operations
Write-Host "  Test 4: Mathematical Operations (100000 operations)"
$start = Get-Date
$result = 0
for ($i = 0; $i -lt 100000; $i++) {
    $result += [math]::Sin($i * 0.01) * [math]::Cos($i * 0.005) + [math]::Sqrt([math]::Abs($i - 50000))
}
$end = Get-Date
$time4 = ($end - $start).TotalMilliseconds
Write-Host "  Time: $([math]::Round($time4, 2))ms`n"

# Results summary
$totalTime = $time1 + $time2 + $time3 + $time4
Write-Host "  BENCHMARK RESULTS:" -ForegroundColor Yellow
Write-Host "  ──────────────────"
Write-Host "  Color Blocks:     $([math]::Round($time1, 2))ms"
Write-Host "  HSV Conversion:   $([math]::Round($time2, 2))ms"
Write-Host "  Screen Rendering: $([math]::Round($time3, 2))ms"
Write-Host "  Math Operations:  $([math]::Round($time4, 2))ms"
Write-Host "  ──────────────────"
Write-Host "  Total Time:       $([math]::Round($totalTime, 2))ms" -ForegroundColor Green
Write-Host "  Average FPS:      $([math]::Round(1000 / ($totalTime / 4), 1)) FPS`n"

# Performance rating
if ($totalTime -lt 500) {
    Write-Host "  Rating: EXCELLENT! ⚡" -ForegroundColor Green
}
elseif ($totalTime -lt 1000) {
    Write-Host "  Rating: GOOD! 👍" -ForegroundColor Yellow
}
elseif ($totalTime -lt 2000) {
    Write-Host "  Rating: FAIR ⌛" -ForegroundColor Magenta
}
else {
    Write-Host "  Rating: SLOW 🐌" -ForegroundColor Red
}

Write-Host "`n  Terminal Info:" -ForegroundColor Cyan
Write-Host "  Width:  $width columns"
Write-Host "  Height: $height rows"
Write-Host "  Colors: 24-bit True Color (16.7M colors)"
Write-Host "  Test completed successfully! 🎨`n"
