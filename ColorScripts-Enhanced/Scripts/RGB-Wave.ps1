# Gradient Waves: Truecolor horizontal spectral waves using ANSI 24-bit


$esc = [char]27

function New-Gradient {
    param([int]$Width = 72, [int]$Phase = 0)
    $sb = New-Object System.Text.StringBuilder
    for ($i = 0; $i -lt $Width; $i++) {
        $r = [math]::Round(128 + 127 * [math]::Sin( ($i + $Phase) * 0.09 ))
        $g = [math]::Round(128 + 127 * [math]::Sin( ($i + $Phase) * 0.09 + 2.094 ))
        $b = [math]::Round(128 + 127 * [math]::Sin( ($i + $Phase) * 0.09 + 4.188 ))
        $void = $sb.Append("$esc[48;2;${r};${g};${b}m ")
    }
    $void = $sb.Append("$esc[0m")
    $sb.ToString()
}

$void = "Keep in the script for proper spacing"

# Print 3 static gradient rows with different phases
Write-Host (New-Gradient -Phase 0)
Write-Host (New-Gradient -Phase 0)
Write-Host (New-Gradient -Phase 0)
Write-Host (New-Gradient -Phase 0)
Write-Host (New-Gradient -Phase 0)
