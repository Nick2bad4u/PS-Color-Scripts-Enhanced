# Build-ColorScriptCache.ps1
# Utility script to pre-generate cache files for all colorscripts
# This significantly improves performance by storing pre-rendered output

param(
    [Parameter()]
    [string[]]$Scripts,

    [Parameter()]
    [switch]$All,

    [Parameter()]
    [switch]$Force,

    [Parameter()]
    [switch]$AddCacheCheck
)

$ErrorActionPreference = 'Stop'
# Use centralized cache in AppData\Roaming for OS-wide consistency
$cacheDir = Join-Path $env:APPDATA "ps-color-scripts\cache"
$scriptsDir = Join-Path $PSScriptRoot "colorscripts"
$cacheCheckLine = "if (. `"`$PSScriptRoot\..\ColorScriptCache.ps1`") { return }"

# Ensure cache directory exists
if (-not (Test-Path $cacheDir)) {
    New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null
}

function Add-CacheCheckToScript {
    param([string]$ScriptPath)

    $content = Get-Content $ScriptPath -Raw

    # Check if cache check already exists
    if ($content -match [regex]::Escape($cacheCheckLine)) {
        return $false
    }

    # Get all lines
    $lines = @(Get-Content $ScriptPath)
    if ($lines.Count -eq 0) {
        return $false
    }

    # Find the best insertion point
    $insertIndex = 0
    $inMultilineComment = $false
    $inHereString = $false

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $trimmed = $line.Trim()

        # Check for multiline comment start/end
        if ($trimmed.StartsWith('<#')) {
            $inMultilineComment = $true
        }
        if ($trimmed.EndsWith('#>')) {
            $inMultilineComment = $false
            $insertIndex = $i + 1
            continue
        }

        # Check for here-string delimiters
        if ($trimmed -match '@["'']$') {
            $inHereString = $true
        }
        if ($inHereString -and $trimmed -match '^["'']@') {
            $inHereString = $false
            continue
        }

        # Skip if we're in a comment or here-string
        if ($inMultilineComment -or $inHereString) {
            continue
        }

        # Skip single-line comments and empty lines at the top
        if ($trimmed -eq '' -or $trimmed.StartsWith('#')) {
            $insertIndex = $i + 1
        }
        else {
            # Found first non-comment, non-empty line
            break
        }
    }

    # Insert cache check
    $newLines = @()
    if ($insertIndex -gt 0) {
        $newLines += $lines[0..($insertIndex - 1)]
        # Add blank line if previous line wasn't blank
        if ($insertIndex -gt 0 -and $lines[$insertIndex - 1].Trim() -ne '') {
            $newLines += ''
        }
    }
    $newLines += "# Check cache first for instant output"
    $newLines += $cacheCheckLine
    $newLines += ''
    if ($insertIndex -lt $lines.Count) {
        $newLines += $lines[$insertIndex..($lines.Count - 1)]
    }

    Set-Content -Path $ScriptPath -Value $newLines -Force
    return $true
}

function Build-CacheForScript {
    param(
        [string]$ScriptPath
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path $cacheDir "$scriptName.cache"

    # Add cache check to script if requested
    if ($AddCacheCheck) {
        if (Add-CacheCheckToScript -ScriptPath $ScriptPath) {
            Write-Host "  Added cache check to $scriptName" -ForegroundColor Cyan
        }
    }

    # Check if cache already exists and is valid (for non-forced builds)
    # We'll be more lenient: only check if cache is very old (> 1 day older than script)
    if (-not $Force -and (Test-Path $cacheFile)) {
        $scriptTime = (Get-Item $ScriptPath).LastWriteTime
        $cacheTime = (Get-Item $cacheFile).LastWriteTime
        $timeDiff = ($scriptTime - $cacheTime).TotalHours

        # Cache is valid if it's less than 24 hours older than script
        # This allows for adding cache checks without invalidating
        if ($timeDiff -lt 24 -and $timeDiff -gt -1) {
            Write-Host "✓ $scriptName (cache up to date)" -ForegroundColor Green
            return
        }
    }

    Write-Host "Building cache for $scriptName..." -ForegroundColor Cyan

    try {
        # Execute script and capture all console output
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = "pwsh.exe"
        $startInfo.Arguments = "-NoProfile -NonInteractive -File `"$ScriptPath`""
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.UseShellExecute = $false
        $startInfo.CreateNoWindow = $true

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $null = $process.Start()

        # Read output
        $output = $process.StandardOutput.ReadToEnd()
        $errors = $process.StandardError.ReadToEnd()
        $process.WaitForExit()

        if ($process.ExitCode -eq 0) {
            # Save to cache
            [System.IO.File]::WriteAllText($cacheFile, $output)

            # Touch the cache file to be slightly newer than the script
            # This prevents invalidation on next check
            (Get-Item $cacheFile).LastWriteTime = (Get-Date).AddSeconds(1)

            Write-Host "✓ $scriptName (cached successfully)" -ForegroundColor Green
        }
        else {
            Write-Host "✗ $scriptName (script failed with exit code $($process.ExitCode))" -ForegroundColor Red
            if ($errors) {
                Write-Host "  Error: $errors" -ForegroundColor Red
            }
        }

    }
    catch {
        Write-Host "✗ $scriptName (error: $($_.Exception.Message))" -ForegroundColor Red
    }
}

# Determine which scripts to process
if ($Scripts) {
    $scriptFiles = $Scripts | ForEach-Object {
        $path = Join-Path $scriptsDir "$_.ps1"
        if (Test-Path $path) {
            Get-Item $path
        }
        else {
            Write-Warning "Script not found: $_"
        }
    }
}
elseif ($All) {
    $scriptFiles = Get-ChildItem -Path $scriptsDir -Filter "*.ps1"
}
else {
    Write-Host "Usage: Build-ColorScriptCache.ps1 [-All] [-Scripts script1,script2,...] [-Force] [-AddCacheCheck]"
    Write-Host ""
    Write-Host "  -All            Build cache for all colorscripts"
    Write-Host "  -Scripts        Build cache for specific scripts (comma-separated names)"
    Write-Host "  -Force          Rebuild cache even if it's up to date"
    Write-Host "  -AddCacheCheck  Automatically add cache check line to scripts"
    Write-Host ""
    Write-Host "Example: Build-ColorScriptCache.ps1 -Scripts bars,hearts,arch"
    Write-Host "Example: Build-ColorScriptCache.ps1 -All -AddCacheCheck"
    exit 1
}

# Process scripts
$total = $scriptFiles.Count
$current = 0

Write-Host "`nBuilding cache for $total colorscript(s)...`n" -ForegroundColor Yellow

foreach ($scriptFile in $scriptFiles) {
    $current++
    Write-Host "[$current/$total] " -NoNewline -ForegroundColor Gray
    Build-CacheForScript -ScriptPath $scriptFile.FullName
}

Write-Host "`nCache building complete!`n" -ForegroundColor Green
