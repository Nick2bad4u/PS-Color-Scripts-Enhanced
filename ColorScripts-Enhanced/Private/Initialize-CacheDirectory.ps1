function Write-InitializedCacheMetadataFile {
    param(
        [switch]$RefreshMetadata
    )

    if (-not $RefreshMetadata) {
        return
    }

    $metadataFileName = 'cache-metadata-v{0}.json' -f $script:CacheFormatVersion
    Write-CacheMetadataFile -CacheDirectory $script:CacheDir -MetadataFileName $metadataFileName
    $script:CacheValidationPerformed = $true
    $script:CacheValidationManualOverride = $false
}

function Get-CacheDirectoryCandidate {
    $candidatePaths = New-Object 'System.Collections.Generic.List[string]'
    $overrideCacheRoot = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
    if ($overrideCacheRoot) {
        $resolvedOverride = Resolve-CachePath -Path $overrideCacheRoot
        if ($resolvedOverride) {
            [void]$candidatePaths.Add($resolvedOverride)
        }
        else {
            Write-Verbose "Ignoring COLOR_SCRIPTS_ENHANCED_CACHE_PATH override '$overrideCacheRoot' because the path could not be resolved."
        }
    }

    $configData = $script:ConfigurationData
    if ($configData -and $configData.Cache -and $configData.Cache.Path) {
        $configuredPath = Resolve-CachePath -Path $configData.Cache.Path
        if ($configuredPath) {
            [void]$candidatePaths.Add($configuredPath)
        }
        else {
            Write-Warning ($script:Messages.ConfiguredCachePathInvalid -f $configData.Cache.Path)
        }
    }

    if ($script:IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
        if ($env:APPDATA) {
            $windowsBase = Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced'
            [void]$candidatePaths.Add((Join-Path -Path $windowsBase -ChildPath 'cache'))
        }
    }
    elseif ($script:IsMacOS) {
        $macBase = Join-Path -Path $HOME -ChildPath 'Library'
        $macBase = Join-Path -Path $macBase -ChildPath 'Application Support'
        $macBase = Join-Path -Path $macBase -ChildPath 'ColorScripts-Enhanced'
        [void]$candidatePaths.Add((Join-Path -Path $macBase -ChildPath 'cache'))
    }
    else {
        $xdgCache = if ($env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME } else { Join-Path -Path $HOME -ChildPath '.cache' }
        if ($xdgCache) {
            [void]$candidatePaths.Add((Join-Path -Path $xdgCache -ChildPath 'ColorScripts-Enhanced'))
        }
    }

    return @($candidatePaths | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
}

function Resolve-ReadOnlyCacheDirectory {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]]$CandidatePath
    )

    foreach ($candidate in $CandidatePath) {
        $resolvedCandidate = Resolve-CachePath -Path $candidate
        if (-not $resolvedCandidate -or (Test-Path -LiteralPath $resolvedCandidate -PathType Leaf)) {
            continue
        }

        if (Test-Path -LiteralPath $resolvedCandidate -PathType Container) {
            try {
                $resolvedCandidate = (Resolve-Path -LiteralPath $resolvedCandidate -ErrorAction Stop).ProviderPath
            }
            catch {
                Write-ModuleTrace ("Read-only cache path normalization failed for '{0}': {1}" -f $resolvedCandidate, $_.Exception.Message)
            }
        }

        return $resolvedCandidate
    }

    return Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ColorScripts-Enhanced'
}

function Write-CacheDirectoryCreationFailure {
    param(
        [Parameter(Mandatory)][string]$Target,
        [AllowNull()][object]$ErrorRecord
    )

    $message = if ($ErrorRecord -and $ErrorRecord.Exception) {
        $ErrorRecord.Exception.Message
    }
    elseif ($ErrorRecord) {
        $ErrorRecord.ToString()
    }
    else {
        'unknown reason'
    }
    Write-Warning ($script:Messages.UnableToPrepareCacheDirectory -f $Target, $message)
}

function Write-CacheDirectoryResolutionFailure {
    param(
        [Parameter(Mandatory)]
        [string]$OriginalPath
    )

    Write-Verbose ("Skipping cache candidate '{0}' because it could not be resolved." -f $OriginalPath)
}

function Test-CacheMetadataRefreshRequired {
    param(
        [Parameter(Mandatory)][string]$CacheDirectory,
        [Parameter(Mandatory)][string]$MetadataFileName,
        [switch]$RefreshMetadata,
        [switch]$ForceViaEnvironment,
        [switch]$CompareDirectoryStamp
    )

    if ($RefreshMetadata -or $ForceViaEnvironment -or $script:CacheValidationManualOverride) {
        return $true
    }

    if ($script:CacheValidationPerformed) {
        return $false
    }

    $metadataPath = Join-Path -Path $CacheDirectory -ChildPath $MetadataFileName
    if (-not (Test-Path -LiteralPath $metadataPath -PathType Leaf)) {
        return $true
    }

    if (-not $CompareDirectoryStamp) {
        return $false
    }

    try {
        $directoryStamp = & $script:DirectoryGetLastWriteTimeUtcDelegate $CacheDirectory
        $metadataStamp = & $script:FileGetLastWriteTimeUtcDelegate $metadataPath
        return $directoryStamp -and $metadataStamp -and ($directoryStamp -gt $metadataStamp)
    }
    catch {
        Write-ModuleTrace ("Cache metadata stamp comparison failed: {0}" -f $_.Exception.Message)
        return $false
    }
}

function Initialize-ResolvedCacheDirectory {
    param(
        [Parameter(Mandatory)][string]$CacheDirectory,
        [switch]$RefreshMetadata,
        [switch]$ForceViaEnvironment,
        [switch]$CompareDirectoryStamp
    )

    $script:CacheDir = $CacheDirectory
    $script:CacheInitialized = $true
    $metadataFileName = 'cache-metadata-v{0}.json' -f $script:CacheFormatVersion
    $shouldValidate = Test-CacheMetadataRefreshRequired -CacheDirectory $CacheDirectory -MetadataFileName $metadataFileName -RefreshMetadata:$RefreshMetadata -ForceViaEnvironment:$ForceViaEnvironment -CompareDirectoryStamp:$CompareDirectoryStamp
    if ($shouldValidate) {
        Write-CacheMetadataFile -CacheDirectory $CacheDirectory -MetadataFileName $metadataFileName
        $script:CacheValidationPerformed = $true
    }

    $script:CacheValidationManualOverride = $false
}

function Initialize-FallbackCacheDirectory {
    $fallback = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ColorScripts-Enhanced'
    try {
        New-Item -ItemType Directory -Path $fallback -Force -ErrorAction Stop | Out-Null
    }
    catch {
        Write-CacheDirectoryCreationFailure -Target $fallback -ErrorRecord $_
        throw
    }

    try {
        return (Resolve-Path -LiteralPath $fallback -ErrorAction Stop).ProviderPath
    }
    catch {
        return $fallback
    }
}

function Initialize-CacheDirectoryCore {
    param(
        [switch]$ReadOnly,
        [switch]$RefreshMetadata
    )

    if ($script:CacheInitialized -and $script:CacheDir) {
        Write-InitializedCacheMetadataFile -RefreshMetadata:$RefreshMetadata
        return
    }

    Initialize-Configuration
    $candidatePaths = @(Get-CacheDirectoryCandidate)
    if ($ReadOnly) {
        $script:CacheDir = Resolve-ReadOnlyCacheDirectory -CandidatePath $candidatePaths
        return
    }

    $onCreateFailure = {
        param($target, $errorRecord)
        Write-CacheDirectoryCreationFailure -Target $target -ErrorRecord $errorRecord
    }
    $onResolutionFailure = {
        param($originalPath)
        Write-CacheDirectoryResolutionFailure -OriginalPath $originalPath
    }
    $resolvedCacheDir = Resolve-PreferredDirectoryCandidate -CandidatePaths $candidatePaths -OnCreateFailure $onCreateFailure -OnResolutionFailure $onResolutionFailure
    $forceViaEnvironment = $env:COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE -match '^(1|true|yes)$'

    $usingFallback = -not $resolvedCacheDir
    if ($usingFallback) {
        $resolvedCacheDir = Initialize-FallbackCacheDirectory
    }

    Initialize-ResolvedCacheDirectory -CacheDirectory $resolvedCacheDir -RefreshMetadata:$RefreshMetadata -ForceViaEnvironment:$forceViaEnvironment -CompareDirectoryStamp:(-not $usingFallback)
}

function Initialize-CacheDirectory {
    param(
        [switch]$ReadOnly,
        [switch]$RefreshMetadata
    )

    if ($script:CacheInitialized -and $script:CacheDir -and -not $RefreshMetadata) {
        return
    }

    $shouldRemainReadOnly = $ReadOnly.IsPresent
    Invoke-ModuleSynchronized $script:CacheSyncRoot {
        Initialize-CacheDirectoryCore -ReadOnly:$shouldRemainReadOnly -RefreshMetadata:$RefreshMetadata
    }
}
