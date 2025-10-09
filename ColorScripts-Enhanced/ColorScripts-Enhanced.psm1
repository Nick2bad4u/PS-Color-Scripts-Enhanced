#Requires -Version 5.1

# ColorScripts-Enhanced Module
# High-performance colorscripts with intelligent caching

# Module variables
$script:ModuleRoot = $PSScriptRoot
$script:ScriptsPath = Join-Path $PSScriptRoot "Scripts"
$script:CacheDir = Join-Path $env:APPDATA "ColorScripts-Enhanced\cache"

# Ensure cache directory exists
if (-not (Test-Path $script:CacheDir)) {
    New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
}

#region Helper Functions

function Get-CachedOutput {
    <#
    .SYNOPSIS
        Retrieves cached output for a colorscript if available and valid.

    .PARAMETER ScriptPath
        The full path to the colorscript file.

    .OUTPUTS
        Returns $true if cache was used, $false otherwise.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    if (-not (Test-Path $ScriptPath)) {
        return $false
    }

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"

    # Check if cache exists and is valid
    if (Test-Path $cacheFile) {
        $scriptTime = (Get-Item $ScriptPath).LastWriteTime
        $cacheTime = (Get-Item $cacheFile).LastWriteTime

        if ($scriptTime -le $cacheTime) {
            # Cache is valid - output it
            $content = [System.IO.File]::ReadAllText($cacheFile)
            $originalEncoding = [Console]::OutputEncoding
            [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
            try {
                [Console]::Write($content)
            }
            finally {
                [Console]::OutputEncoding = $originalEncoding
            }
            return $true
        }
    }

    return $false
}

function Build-ScriptCache {
    <#
    .SYNOPSIS
        Builds cache for a specific colorscript.

    .PARAMETER ScriptPath
        The full path to the colorscript file.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"

    try {
        # Execute script and capture output
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = "pwsh.exe"
        $startInfo.Arguments = "-NoProfile -NonInteractive -Command `"[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; & '$ScriptPath'`""
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
        $startInfo.StandardErrorEncoding = [System.Text.Encoding]::UTF8

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $null = $process.Start()

        $output = $process.StandardOutput.ReadToEnd()
        $process.WaitForExit()

        if ($process.ExitCode -eq 0) {
            [System.IO.File]::WriteAllText($cacheFile, $output)
            (Get-Item $cacheFile).LastWriteTime = (Get-Date).AddSeconds(1)
            return $true
        }
    }
    catch {
        Write-Warning "Failed to cache $scriptName : $_"
    }

    return $false
}

#endregion

#region Public Functions

function Show-ColorScript {
    <#
    .SYNOPSIS
        Displays a colorscript with automatic caching.

    .DESCRIPTION
        Shows a beautiful ANSI colorscript in your terminal. If no name is specified,
        displays a random script. Uses intelligent caching for 6-19x faster performance.

    .PARAMETER Name
        The name of the colorscript to display (without .ps1 extension).

    .PARAMETER List
        Lists all available colorscripts.

    .PARAMETER Random
        Display a random colorscript (default behavior).

    .PARAMETER NoCache
        Bypass cache and execute script directly.

    .EXAMPLE
        Show-ColorScript
        Displays a random colorscript.

    .EXAMPLE
        Show-ColorScript -Name "mandelbrot-zoom"
        Displays the mandelbrot-zoom colorscript.

    .EXAMPLE
        Show-ColorScript -List
        Lists all available colorscripts.

    .EXAMPLE
        scs hearts
        Uses the alias to display the hearts colorscript.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Random')]
    [Alias('scs')]
    param(
        [Parameter(ParameterSetName = 'Named', Position = 0)]
        [string]$Name,

        [Parameter(ParameterSetName = 'List')]
        [switch]$List,

        [Parameter(ParameterSetName = 'Random')]
        [switch]$Random,

        [Parameter()]
        [switch]$NoCache
    )

    # Handle list request
    if ($List) {
        Get-ColorScriptList
        return
    }

    # Get all available scripts
    $availableScripts = Get-ChildItem -Path $script:ScriptsPath -Filter "*.ps1" |
        Where-Object { $_.Name -ne 'ColorScriptCache.ps1' }

    if ($availableScripts.Count -eq 0) {
        Write-Warning "No colorscripts found in $script:ScriptsPath"
        return
    }

    $useRandom = $Random -or $PSCmdlet.ParameterSetName -eq 'Random'

    # Select script
    if ($Name) {
        $script = $availableScripts | Where-Object { $_.BaseName -eq $Name } | Select-Object -First 1
        if (-not $script) {
            Write-Warning "Colorscript '$Name' not found. Use -List to see available scripts."
            return
        }
    }
    elseif ($useRandom) {
        # Random selection
        $script = $availableScripts | Get-Random
    }
    else {
        $script = $availableScripts | Select-Object -First 1
    }

    # Try to use cache first (unless NoCache specified)
    if (-not $NoCache) {
        if (Get-CachedOutput -ScriptPath $script.FullName) {
            return
        }
    }

    # Execute script directly
    $originalEncoding = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    try {
        & $script.FullName
    }
    finally {
        [Console]::OutputEncoding = $originalEncoding
    }

    # Build cache for next time if not already cached
    if (-not $NoCache) {
        Build-ScriptCache -ScriptPath $script.FullName | Out-Null
    }
}

function Get-ColorScriptList {
    <#
    .SYNOPSIS
        Lists all available colorscripts.

    .DESCRIPTION
        Returns a formatted list of all colorscripts available in the module.

    .EXAMPLE
        Get-ColorScriptList
        Lists all colorscripts.
    #>
    [CmdletBinding()]
    param()

    $scripts = Get-ChildItem -Path $script:ScriptsPath -Filter "*.ps1" |
        Where-Object { $_.Name -ne 'ColorScriptCache.ps1' } |
        Sort-Object Name

    Write-Host "`nAvailable ColorScripts ($($scripts.Count)):" -ForegroundColor Cyan
    Write-Host ("=" * 60) -ForegroundColor Cyan

    $columnWidth = 30
    $columns = 2
    $rows = [math]::Ceiling($scripts.Count / $columns)

    for ($i = 0; $i -lt $rows; $i++) {
        $line = ""
        for ($j = 0; $j -lt $columns; $j++) {
            $index = $i + ($j * $rows)
            if ($index -lt $scripts.Count) {
                $name = $scripts[$index].BaseName
                $line += $name.PadRight($columnWidth)
            }
        }
        Write-Host $line
    }

    Write-Host "`nUsage: Show-ColorScript -Name <name>" -ForegroundColor Yellow
    Write-Host "       Show-ColorScript (random)" -ForegroundColor Yellow
}

function Build-ColorScriptCache {
    <#
    .SYNOPSIS
        Builds cache files for colorscripts.

    .DESCRIPTION
        Pre-generates cache files for faster colorscript loading. Can cache all scripts
        or specific ones.

    .PARAMETER Name
        Specific script name(s) to cache. If not specified, caches all scripts.

    .PARAMETER All
        Cache all available colorscripts.

    .PARAMETER Force
        Force rebuild even if cache already exists.

    .EXAMPLE
        Build-ColorScriptCache -All
        Caches all colorscripts.

    .EXAMPLE
        Build-ColorScriptCache -Name "bars","hearts","arch"
        Caches specific colorscripts.

    .EXAMPLE
        Build-ColorScriptCache -All -Force
        Rebuilds cache for all scripts.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string[]]$Name,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [switch]$Force
    )

    # Determine which scripts to cache
    if ($Name) {
        $scriptFiles = $Name | ForEach-Object {
            $path = Join-Path $script:ScriptsPath "$_.ps1"
            if (Test-Path $path) {
                Get-Item $path
            }
            else {
                Write-Warning "Script not found: $_"
            }
        }
    }
    elseif ($All) {
        $scriptFiles = Get-ChildItem -Path $script:ScriptsPath -Filter "*.ps1" |
            Where-Object { $_.Name -ne 'ColorScriptCache.ps1' }
    }
    else {
        Write-Host "Usage: Build-ColorScriptCache -All | -Name script1,script2,..." -ForegroundColor Yellow
        return
    }

    $total = $scriptFiles.Count
    $current = 0
    $success = 0
    $failed = 0

    Write-Host "`nBuilding cache for $total colorscript(s)...`n" -ForegroundColor Yellow

    foreach ($script in $scriptFiles) {
        $current++
        $scriptName = $script.BaseName
        $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"

        # Check if we need to rebuild
        if (-not $Force -and (Test-Path $cacheFile)) {
            $scriptTime = $script.LastWriteTime
            $cacheTime = (Get-Item $cacheFile).LastWriteTime

            if (($scriptTime - $cacheTime).TotalHours -lt 24 -and $cacheTime -gt $scriptTime) {
                Write-Host "[$current/$total] ✓ $scriptName (cache up to date)" -ForegroundColor Green
                $success++
                continue
            }
        }

        Write-Host "[$current/$total] Building cache for $scriptName..." -ForegroundColor Cyan -NoNewline

        if (Build-ScriptCache -ScriptPath $script.FullName) {
            Write-Host " ✓" -ForegroundColor Green
            $success++
        }
        else {
            Write-Host " ✗" -ForegroundColor Red
            $failed++
        }
    }

    Write-Host "`nCache building complete!" -ForegroundColor Green
    Write-Host "  Success: $success" -ForegroundColor Green
    if ($failed -gt 0) {
        Write-Host "  Failed: $failed" -ForegroundColor Red
    }
    Write-Host "  Cache location: $script:CacheDir`n" -ForegroundColor Cyan
}

function Clear-ColorScriptCache {
    <#
    .SYNOPSIS
        Clears the colorscript cache.

    .DESCRIPTION
        Removes all cached colorscript output files. Use this if you want to force
        regeneration of all caches.

    .PARAMETER Name
        Clear cache for specific script(s) only.

    .PARAMETER All
        Clear all cache files.

    .EXAMPLE
        Clear-ColorScriptCache -All
        Removes all cache files.

    .EXAMPLE
        Clear-ColorScriptCache -Name "mandelbrot-zoom"
        Removes cache for a specific script.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()]
        [string[]]$Name,

        [Parameter()]
        [switch]$All
    )

    if ($Name) {
        foreach ($scriptName in $Name) {
            $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"
            if (Test-Path $cacheFile) {
                if ($PSCmdlet.ShouldProcess($scriptName, "Clear cache")) {
                    Remove-Item $cacheFile -Force
                    Write-Host "✓ Cleared cache for: $scriptName" -ForegroundColor Green
                }
            }
            else {
                Write-Warning "No cache found for: $scriptName"
            }
        }
    }
    elseif ($All) {
        $cacheFiles = Get-ChildItem -Path $script:CacheDir -Filter "*.cache"
        if ($cacheFiles.Count -eq 0) {
            Write-Host "No cache files found." -ForegroundColor Yellow
            return
        }

        if ($PSCmdlet.ShouldProcess("$($cacheFiles.Count) cache files", "Clear all")) {
            $cacheFiles | Remove-Item -Force
            Write-Host "✓ Cleared $($cacheFiles.Count) cache files" -ForegroundColor Green
        }
    }
    else {
        Write-Host "Usage: Clear-ColorScriptCache -All | -Name script1,script2,..." -ForegroundColor Yellow
    }
}

function Add-ColorScriptProfile {
    <#
    .SYNOPSIS
        Adds ColorScripts-Enhanced import and optional startup snippet to a PowerShell profile.

    .DESCRIPTION
        Appends the module import (and optionally Show-ColorScript) to the specified PowerShell profile
        file. Creates the profile file if it does not already exist. Prevents duplicate entries unless
        -Force is specified.

    .PARAMETER Scope
        Which predefined PowerShell profile path to update. Defaults to CurrentUserAllHosts.

    .PARAMETER Path
        Explicit path to a profile script. Overrides Scope when provided.

    .PARAMETER SkipStartupScript
        Only add Import-Module line; do not add Show-ColorScript.

    .PARAMETER Force
        Add the snippet even if the profile already contains an Import-Module ColorScripts-Enhanced line.

    .EXAMPLE
        Add-ColorScriptProfile
        Adds the import and random colorscript startup to the CurrentUserAllHosts profile.

    .EXAMPLE
        Add-ColorScriptProfile -SkipStartupScript -Scope CurrentUserCurrentHost
        Adds only the import line to the current host profile.
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter()]
        [ValidateSet('CurrentUserAllHosts', 'CurrentUserCurrentHost', 'AllUsersAllHosts', 'AllUsersCurrentHost')]
        [string]$Scope = 'CurrentUserAllHosts',

        [Parameter()]
        [string]$Path,

        [Parameter()]
        [switch]$SkipStartupScript,

        [Parameter()]
        [switch]$Force
    )

    if ($PSBoundParameters.ContainsKey('Path')) {
        $profilePath = $Path
    }
    else {
        $profilePath = $PROFILE.$Scope
    }

    if (-not [System.IO.Path]::IsPathRooted($profilePath)) {
        $profilePath = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $profilePath))
    }

    $profileDirectory = Split-Path -Parent $profilePath
    if (-not (Test-Path $profileDirectory)) {
        New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
    }

    $existingContent = ''
    if (Test-Path $profilePath) {
        $existingContent = Get-Content -Path $profilePath -Raw
        if (-not $Force -and $existingContent -match 'Import-Module\s+ColorScripts-Enhanced') {
            Write-Verbose "Profile already contains ColorScripts-Enhanced import. Skipping (use -Force to append anyway)."
            return [pscustomobject] @{
                Path    = $profilePath
                Changed = $false
                Message = 'Profile already configured.'
            }
        }
    }

    $newline = [Environment]::NewLine
    $timestamp = (Get-Date).ToString('u')
    $snippetLines = @(
        "# Added by ColorScripts-Enhanced on $timestamp",
        'Import-Module ColorScripts-Enhanced'
    )

    if (-not $SkipStartupScript) {
        $snippetLines += 'Show-ColorScript'
    }

    $snippet = ($snippetLines -join $newline)

    $separator = ''
    if ($existingContent -and $existingContent.TrimEnd()) {
        $separator = $newline + $newline
    }

    if ($PSCmdlet.ShouldProcess($profilePath, 'Add ColorScripts-Enhanced profile snippet')) {
        $contentToAppend = $separator + $snippet + $newline
        [System.IO.File]::AppendAllText($profilePath, $contentToAppend, [System.Text.Encoding]::UTF8)

        Write-Host "✓ Added ColorScripts-Enhanced startup snippet to $profilePath" -ForegroundColor Green

        return [pscustomobject] @{
            Path    = $profilePath
            Changed = $true
            Message = 'ColorScripts-Enhanced profile snippet added.'
        }
    }
}

#endregion

# Export module members
Export-ModuleMember -Function @(
    'Show-ColorScript',
    'Get-ColorScriptList',
    'Build-ColorScriptCache',
    'Clear-ColorScriptCache',
    'Add-ColorScriptProfile'
) -Alias @('scs')

# Module initialization message
Write-Verbose "ColorScripts-Enhanced module loaded. Cache location: $script:CacheDir"
