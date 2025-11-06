function Initialize-CacheDirectory {
    if ($script:CacheInitialized -and $script:CacheDir) {
        return
    }

    Invoke-ModuleSynchronized $script:CacheSyncRoot {
        if ($script:CacheInitialized -and $script:CacheDir) {
            return
        }

        Initialize-Configuration

        $overrideCacheRoot = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
        $resolvedOverride = $null

        if ($overrideCacheRoot) {
            $resolvedOverride = Resolve-CachePath -Path $overrideCacheRoot
            if (-not $resolvedOverride) {
                Write-Verbose "Ignoring COLOR_SCRIPTS_ENHANCED_CACHE_PATH override '$overrideCacheRoot' because the path could not be resolved."
            }
        }

        $candidatePaths = @()

        if ($resolvedOverride) {
            $candidatePaths += $resolvedOverride
        }

        $configData = $script:ConfigurationData
        if ($configData -and $configData.Cache -and $configData.Cache.Path) {
            $configuredPath = Resolve-CachePath -Path $configData.Cache.Path
            if ($configuredPath) {
                $candidatePaths += $configuredPath
            }
            else {
                Write-Warning ($script:Messages.ConfiguredCachePathInvalid -f $configData.Cache.Path)
            }
        }

        if ($script:IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
            if ($env:APPDATA) {
                $windowsBase = Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced'
                $candidatePaths += (Join-Path -Path $windowsBase -ChildPath 'cache')
            }
        }
        elseif ($script:IsMacOS) {
            $macBase = Join-Path -Path $HOME -ChildPath 'Library'
            $macBase = Join-Path -Path $macBase -ChildPath 'Application Support'
            $macBase = Join-Path -Path $macBase -ChildPath 'ColorScripts-Enhanced'
            $candidatePaths += (Join-Path -Path $macBase -ChildPath 'cache')
        }
        else {
            $xdgCache = if ($env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME } else { Join-Path -Path $HOME -ChildPath '.cache' }
            if ($xdgCache) {
                $candidatePaths += (Join-Path -Path $xdgCache -ChildPath 'ColorScripts-Enhanced')
            }
        }

        $candidatePaths = @($candidatePaths | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

        $onCreateFailure = {
            param($target, $errorRecord)
            $message = if ($errorRecord -and $errorRecord.Exception) { $errorRecord.Exception.Message } elseif ($errorRecord) { $errorRecord.ToString() } else { 'unknown reason' }
            Write-Warning ($script:Messages.UnableToPrepareCacheDirectory -f $target, $message)
        }

        $onResolutionFailure = {
            param($originalPath)
            Write-Verbose ("Skipping cache candidate '{0}' because it could not be resolved." -f $originalPath)
        }

        $resolvedCacheDir = Resolve-PreferredDirectoryCandidate -CandidatePaths $candidatePaths -OnCreateFailure $onCreateFailure -OnResolutionFailure $onResolutionFailure

        if ($resolvedCacheDir) {
            $script:CacheDir = $resolvedCacheDir
            $script:CacheInitialized = $true
            Update-CacheFormatVersion -CacheDirectory $script:CacheDir
            return
        }

        $fallback = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ColorScripts-Enhanced'
        try {
            New-Item -ItemType Directory -Path $fallback -Force -ErrorAction Stop | Out-Null
        }
        catch {
            if ($onCreateFailure) {
                & $onCreateFailure $fallback $_
            }

            throw
        }

        try {
            $resolvedFallback = (Resolve-Path -LiteralPath $fallback -ErrorAction Stop).ProviderPath
        }
        catch {
            $resolvedFallback = $fallback
        }

        $script:CacheDir = $resolvedFallback
        $script:CacheInitialized = $true
        Update-CacheFormatVersion -CacheDirectory $script:CacheDir
    }
}
