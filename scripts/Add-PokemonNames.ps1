<#
.SYNOPSIS
    Adds Pokemon names to the bottom of all Pokemon color scripts in batch.

.DESCRIPTION
    This script processes all .ps1 files in the Scripts directory and adds
    a colored "Pokemon: [Name]" line at the bottom of each script.

    The colors are extracted from the dominant colors already present in each
    script's ASCII art to ensure visual harmony.

.PARAMETER ScriptsPath
    Path to the Scripts directory containing the Pokemon color scripts.

.PARAMETER Filter
    Wildcard pattern to filter which scripts to process. Default is '*' (all).
    Examples: 'abra*', 'pokemon-*'

.PARAMETER SkipExisting
    If specified, skips scripts that already have a Pokemon name.

.EXAMPLE
    # Process all Pokemon scripts
    .\Add-PokemonNames.ps1

.EXAMPLE
    # Process only Abra variants
    .\Add-PokemonNames.ps1 -Filter 'abra*'

.EXAMPLE
    # Process all scripts, skip ones already updated
    .\Add-PokemonNames.ps1 -SkipExisting
#>

param(
    [string]$ScriptsPath = (Join-Path $PSScriptRoot '..\ColorScripts-Enhanced\Scripts'),
    [string]$Filter = '*',
    [string]$PokemonListPath = (Join-Path $PSScriptRoot '..\assets\ansi-files\pokemon-colorscripts'),
    [switch]$SkipExisting
)

# Color sets for different Pokemon (RGB values as strings for RGB24-bit ANSI codes)
# Format: @{Name = "pokemonname"; Colors = @("r;g;b", "r;g;b", ...)}
$colorSchemes = @{
    'clefairy' = @('165;115;49', '214;140;132', '255;189;165', '214;140;132', '165;115;49')
}

function Get-ValidPokemonNames {
    <#
    .SYNOPSIS
        Get list of valid Pokemon names from the pokemon-colorscripts directory.
        Reads from files (not directories) in the small/regular and small/shiny folders.
    #>
    param([string]$PokemonListPath)

    if (-not (Test-Path $PokemonListPath)) {
        Write-Host "Warning: Pokemon list path not found: $PokemonListPath" -ForegroundColor Yellow
        Write-Host "Processing all scripts instead..." -ForegroundColor Yellow
        return $null
    }

    $pokemonNames = @()

    # Check for small/regular and small/shiny structure
    $regularPath = Join-Path $PokemonListPath 'small\regular'
    $shinyPath = Join-Path $PokemonListPath 'small\shiny'

    # Fallback to direct regular/shiny structure
    if (-not (Test-Path $regularPath)) {
        $regularPath = Join-Path $PokemonListPath 'regular'
    }
    if (-not (Test-Path $shinyPath)) {
        $shinyPath = Join-Path $PokemonListPath 'shiny'
    }

    # Get all files (Pokemon names) from both regular and shiny subdirectories
    if (Test-Path $regularPath) {
        $pokemonNames += Get-ChildItem $regularPath -File -ErrorAction SilentlyContinue | Select-Object -ExpandProperty BaseName
    }

    if (Test-Path $shinyPath) {
        $pokemonNames += Get-ChildItem $shinyPath -File -ErrorAction SilentlyContinue | Select-Object -ExpandProperty BaseName
    }

    return $pokemonNames | Sort-Object -Unique
}

function Test-IsPokemonScript {
    <#
    .SYNOPSIS
        Check if a script filename matches a valid Pokemon name from the list.
    #>
    param(
        [string]$Filename,
        [string[]]$ValidPokemonNames
    )

    if ($null -eq $ValidPokemonNames -or $ValidPokemonNames.Count -eq 0) {
        return $true  # If no list provided, process all
    }

    $scriptName = $Filename -replace '\.ps1$', ''

    # Check if the script name matches any valid Pokemon (exact or with variants like -shiny, -mega)
    foreach ($pokemonName in $ValidPokemonNames) {
        if ($scriptName -eq $pokemonName -or $scriptName -match "^${pokemonName}(-shiny|-mega|_)") {
            return $true
        }
    }

    return $false
}

function Get-DominantColors {
    <#
    .SYNOPSIS
        Extract the most used colors from a Pokemon script.
        Filters out very dark colors (near black) to avoid visibility issues.
    #>
    param([string]$ScriptContent)

    # Find all RGB color codes in format 38;2;R;G;B or 48;2;R;G;B
    $rgbPattern = '\[?38;2;(\d+;\d+;\d+)'
    $matches = [regex]::Matches($ScriptContent, $rgbPattern)

    if ($matches.Count -eq 0) {
        return @('200;100;100', '150;150;150', '100;100;100')  # Fallback colors
    }

    # Count color frequencies, filtering out very dark colors
    $colorFreq = @{}
    foreach ($match in $matches) {
        $color = $match.Groups[1].Value
        $rgb = $color -split ';'
        $r = [int]$rgb[0]
        $g = [int]$rgb[1]
        $b = [int]$rgb[2]

        # Skip very dark colors (near black) - brightness < 80
        $brightness = ($r + $g + $b) / 3
        if ($brightness -lt 80) {
            continue
        }

        $colorFreq[$color] = ($colorFreq[$color] -as [int]) + 1
    }

    # If all colors were filtered out, use fallback
    if ($colorFreq.Count -eq 0) {
        return @('200;100;100', '150;150;150', '100;100;100')  # Fallback colors
    }

    # Get top 3 colors
    $topColors = $colorFreq.GetEnumerator() | Sort-Object -Property Value -Descending | Select-Object -First 3 -ExpandProperty Name

    # If we have fewer than 3 colors, duplicate/cycle them
    while ($topColors.Count -lt 3) {
        $topColors += $topColors[0]
    }

    return $topColors
}

function ConvertTo-PokemonName {
    <#
    .SYNOPSIS
        Convert filename to Pokemon name format.
    .EXAMPLE
        ConvertTo-PokemonName "abomasnow-mega-shiny.ps1" -> "Abomasnow-Mega-Shiny"
    #>
    param([string]$Filename)

    # Remove .ps1 extension
    $name = $Filename -replace '\.ps1$', ''

    # Split by hyphens and capitalize each word
    $parts = $name -split '-' | ForEach-Object {
        [char]::ToUpper($_[0]) + $_.Substring(1)
    }

    return $parts -join '-'
}

function New-PokemonNameLine {
    <#
    .SYNOPSIS
        Create a colored Pokemon name line with alternating colors.
    #>
    param(
        [string]$PokemonName,
        [string[]]$Colors
    )

    $esc = [char]27
    $line = ""
    $colorIndex = 0
    $charIndex = 0

    foreach ($char in $PokemonName.ToCharArray()) {
        $color = $Colors[$colorIndex % $Colors.Count]
        $line += "$esc[38;2;${color}m$char"

        # Cycle color for each character, but keep colon and spaces simple
        if ($char -ne ':' -and $char -ne ' ') {
            $colorIndex++
        }
    }

    $line += "$esc[0m"
    return $line
}

function Add-PokemonNameToScript {
    <#
    .SYNOPSIS
        Add Pokemon name to a single script file.
    #>
    param(
        [string]$ScriptPath,
        [string]$PokemonName,
        [string[]]$Colors
    )

    try {
        $content = [System.IO.File]::ReadAllText($ScriptPath)

        # Check if already has Pokemon name (comprehensive check)
        if ($content -match '\[38;2.*Pokemon:' -or $content -match 'Pokemon:\s+\w' -or $content -match '^Pokemon:' -or $content -match '\nPokemon:') {
            Write-Host "  ⊘ Skipped (already has Pokemon name): $([System.IO.Path]::GetFileName($ScriptPath))" -ForegroundColor Yellow
            return $false
        }

        # Create the Pokemon name line
        $pokemonLine = New-PokemonNameLine -PokemonName "Pokemon: $PokemonName" -Colors $Colors

        # Replace the closing "@" with Pokemon name + closing "@"
        $newContent = $content -replace '(\[0m\r?\n"@)$', "`n$pokemonLine`n`"@"

        # If the regex didn't match, try a simpler pattern
        if ($newContent -eq $content) {
            $newContent = $content -replace '("@)$', "`n$pokemonLine`n`"@"
        }

        # Write back to file
        [System.IO.File]::WriteAllText($ScriptPath, $newContent)
        Write-Host "  ✓ Updated: $([System.IO.Path]::GetFileName($ScriptPath))" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  ✗ Error processing $([System.IO.Path]::GetFileName($ScriptPath)): $_" -ForegroundColor Red
        return $false
    }
}

# Main processing
try {
    if (-not (Test-Path $ScriptsPath)) {
        throw "Scripts path not found: $ScriptsPath"
    }

    Write-Host "Starting Pokemon name batch processing..." -ForegroundColor Cyan
    Write-Host "Scripts path: $ScriptsPath" -ForegroundColor Gray
    Write-Host "Filter: $Filter" -ForegroundColor Gray

    # Get valid Pokemon names from the pokemon-colorscripts directory
    Write-Host "Loading valid Pokemon names from: $PokemonListPath" -ForegroundColor Gray
    $validPokemonNames = Get-ValidPokemonNames -PokemonListPath $PokemonListPath

    if ($null -ne $validPokemonNames) {
        Write-Host "Found $($validPokemonNames.Count) valid Pokemon names" -ForegroundColor Gray
    }
    Write-Host ""

    # Get all matching scripts
    $scripts = @(Get-ChildItem $ScriptsPath -Filter "${Filter}.ps1" -ErrorAction SilentlyContinue)

    # Filter out non-Pokemon scripts and scripts not in the valid list
    $scripts = $scripts | Where-Object {
        $name = $_.Name
        $isNonGeneric = $name -notmatch '^\d+' -and `
                       $name -ne '00default.ps1' -and `
                       $name -ne 'Test-AllColorScripts.ps1'

        $isValidPokemon = Test-IsPokemonScript -Filename $name -ValidPokemonNames $validPokemonNames

        $isNonGeneric -and $isValidPokemon
    }

    Write-Host "Found $($scripts.Count) matching scripts to process" -ForegroundColor Cyan
    Write-Host ""

    $processed = 0
    $skipped = 0
    $errors = 0

    # Process each script
    foreach ($script in $scripts) {
        $pokemonName = ConvertTo-PokemonName $script.Name

        # Get dominant colors from the script
        $content = Get-Content $script.FullName -Raw
        $colors = Get-DominantColors $content

        $result = Add-PokemonNameToScript -ScriptPath $script.FullName -PokemonName $pokemonName -Colors $colors

        if ($result -eq $true) {
            $processed++
        }
        elseif ($result -eq $false) {
            $skipped++
        }
        else {
            $errors++
        }

        # Progress indicator for large batches
        if (($processed + $skipped + $errors) % 100 -eq 0) {
            $total = $processed + $skipped + $errors
            Write-Host "Progress: $total/$($scripts.Count) scripts processed..." -ForegroundColor Gray
        }
    }

    Write-Host ""
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host "Processing Complete!" -ForegroundColor Green
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host "Processed: $processed" -ForegroundColor Green
    Write-Host "Skipped:   $skipped" -ForegroundColor Yellow
    Write-Host "Errors:    $errors" -ForegroundColor Red
    Write-Host ""
}
catch {
    Write-Host "Fatal error: $_" -ForegroundColor Red
    exit 1
}
