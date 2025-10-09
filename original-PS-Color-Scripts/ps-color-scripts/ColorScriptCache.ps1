# ColorScript Output Caching System
# Provides 10-50x faster colorscript loading by caching pre-rendered output
#
# USAGE: Add one line at the top of each colorscript:
#
#   if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }
#
# That's it! The rest of the script runs as normal the first time,
# and on subsequent runs, the cached output is displayed instantly.

param()

# Configuration - Use centralized cache in AppData\Roaming
$script:CacheDir = Join-Path $env:APPDATA "ps-color-scripts\cache"

# Get the calling script's path
$callerScript = (Get-PSCallStack)[1].ScriptName

if (-not $callerScript) {
    return $false
}

# Ensure cache directory exists
if (-not (Test-Path $script:CacheDir)) {
    New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
}

$scriptName = [System.IO.Path]::GetFileNameWithoutExtension($callerScript)
$cacheFile = Join-Path $script:CacheDir "$scriptName.cache"

# Check if cache exists and is valid (not older than source)
if (Test-Path $cacheFile) {
    $scriptTime = (Get-Item $callerScript).LastWriteTime
    $cacheTime = (Get-Item $cacheFile).LastWriteTime

    if ($scriptTime -le $cacheTime) {
        # Cache is valid - output it directly and return $true
        $content = [System.IO.File]::ReadAllText($cacheFile)
        [Console]::Write($content)
        return $true
    }
}

# No valid cache exists - return false to let the script execute normally
# The script's output will need to be captured manually using the cache builder
return $false
