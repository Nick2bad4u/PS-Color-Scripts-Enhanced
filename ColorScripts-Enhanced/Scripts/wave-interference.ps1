# Unique Concept: Multi-source wave interference pattern with phase-shifted ripples creating Moiré effects.
# Simulates water waves emanating from multiple point sources with amplitude decay and constructive/destructive interference.

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

$width = 120
$height = 40

# Define wave sources with different frequencies and phases
$sources = @(
    @{ X = 0.25; Y = 0.3; Freq = 8.0; Phase = 0.0; Amplitude = 1.0 },
    @{ X = 0.75; Y = 0.3; Freq = 7.5; Phase = 1.2; Amplitude = 0.9 },
    @{ X = 0.5; Y = 0.7; Freq = 9.0; Phase = 2.4; Amplitude = 0.85 },
    @{ X = 0.35; Y = 0.65; Freq = 6.8; Phase = 0.8; Amplitude = 0.8 },
    @{ X = 0.65; Y = 0.55; Freq = 8.5; Phase = 1.6; Amplitude = 0.75 }
)

$time = ([DateTime]::Now.Ticks / 10000000.0) % 60

for ($row = 0; $row -lt $height; $row++) {
    $sb = [System.Text.StringBuilder]::new()
    for ($col = 0; $col -lt $width; $col++) {
        $x = $col / [double]($width - 1)
        $y = $row / [double]($height - 1)

        # Sum waves from all sources
        $totalWave = 0.0
        $totalWeight = 0.0

        foreach ($src in $sources) {
            $dx = $x - $src.X
            $dy = $y - $src.Y
            $distance = [math]::Sqrt($dx * $dx + $dy * $dy)

            # Prevent division by zero at source
            if ($distance -lt 0.01) { $distance = 0.01 }

            # Wave equation: A * sin(freq * distance - time + phase) / distance
            $amplitude = $src.Amplitude / $distance
            $wave = $amplitude * [math]::Sin($src.Freq * $distance - $time * 2.0 + $src.Phase)

            $totalWave += $wave
            $totalWeight += $amplitude
        }

        # Normalize
        if ($totalWeight -gt 0) {
            $totalWave = $totalWave / $totalWeight
        }

        # Map wave amplitude to color
        $normalized = ($totalWave + 1.0) / 2.0  # Map from [-1,1] to [0,1]

        # Use wave phase to determine hue
        $hue = ($normalized * 0.5 + 0.5) % 1
        $saturation = Clamp -Value (0.6 + 0.35 * [math]::Abs($totalWave)) -Min 0 -Max 1
        $value = Clamp -Value (0.3 + 0.65 * $normalized) -Min 0.25 -Max 1.0

        $rgb = Convert-HsvToRgb -Hue $hue -Saturation $saturation -Value $value

        # Symbol based on wave amplitude
        if ($totalWave -gt 0.7) { $symbol = '█' }
        elseif ($totalWave -gt 0.3) { $symbol = '▓' }
        elseif ($totalWave -gt 0) { $symbol = '▒' }
        elseif ($totalWave -gt -0.3) { $symbol = '░' }
        elseif ($totalWave -gt -0.7) { $symbol = '∙' }
        else { $symbol = '·' }

        $null = $sb.Append("$esc[38;2;$($rgb[0]);$($rgb[1]);$($rgb[2])m$symbol")
    }
    Write-Host ($sb.ToString() + $reset)
}

Write-Host $reset
