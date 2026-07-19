function Invoke-WithColorScriptCacheEntryLock {
    <#
    .SYNOPSIS
        Serializes cache mutations for one colorscript across processes.

    .DESCRIPTION
        New-ColorScriptCache can be started concurrently from profiles, terminals, or explicit
        warm-up commands. A named mutex prevents competing writers from corrupting or deleting
        the same cache entry while still allowing different scripts to build in parallel.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$CacheRoot,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ScriptName,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [scriptblock]$Operation,

        [Parameter()]
        [ValidateRange(1, 3600)]
        [int]$TimeoutSeconds = 600,

        [Parameter()]
        [object[]]$ArgumentList = @()
    )

    $cachePath = Join-Path -Path $CacheRoot -ChildPath ("{0}.cache" -f $ScriptName)
    try {
        $cachePath = [System.IO.Path]::GetFullPath($cachePath)
    }
    catch {
        Write-Verbose ("Unable to normalize cache lock path '{0}': {1}" -f $cachePath, $_.Exception.Message)
    }

    if ([System.IO.Path]::DirectorySeparatorChar -eq '\') {
        $cachePath = $cachePath.ToUpperInvariant()
    }

    $hashAlgorithm = [System.Security.Cryptography.SHA256]::Create()
    try {
        $identityBytes = [System.Text.Encoding]::UTF8.GetBytes($cachePath)
        $identityHash = $hashAlgorithm.ComputeHash($identityBytes)
        $mutexSuffix = ([System.BitConverter]::ToString($identityHash)).Replace('-', '')
    }
    finally {
        $hashAlgorithm.Dispose()
    }

    $mutexName = 'ColorScriptsEnhanced.CacheEntry.{0}' -f $mutexSuffix
    $mutex = [System.Threading.Mutex]::new($false, $mutexName)
    $lockTaken = $false

    try {
        try {
            $lockTaken = $mutex.WaitOne([TimeSpan]::FromSeconds($TimeoutSeconds))
        }
        catch [System.Threading.AbandonedMutexException] {
            # The previous owner terminated without releasing the mutex. Ownership transfers to
            # this thread, so the cache operation can safely recover the entry.
            $lockTaken = $true
        }

        if (-not $lockTaken) {
            throw [System.TimeoutException]::new(
                ("Timed out after {0} seconds waiting to update cache entry '{1}'." -f $TimeoutSeconds, $ScriptName)
            )
        }

        & $Operation @ArgumentList
    }
    finally {
        if ($lockTaken) {
            $mutex.ReleaseMutex()
        }

        $mutex.Dispose()
    }
}
