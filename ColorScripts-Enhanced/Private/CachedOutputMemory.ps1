if (-not $script:CachedOutputMemory) {
    $script:CachedOutputMemory = New-Object 'System.Collections.Generic.Dictionary[string,object]' ([System.StringComparer]::OrdinalIgnoreCase)
}

function Get-CachedOutputMemoryEntry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$CacheFile
    )

    $cacheFileKey = $CacheFile
    return Invoke-ModuleSynchronized $script:CachedOutputMemorySyncRoot {
        $entry = $null
        if ($script:CachedOutputMemory.TryGetValue($cacheFileKey, [ref]$entry)) {
            return $entry
        }

        return $null
    }
}

function Set-CachedOutputMemoryEntry {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Updates only process-local memoized cache state; no external system state changes.')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$CacheFile,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ScriptPath,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$MetadataPath,

        [Parameter(Mandatory)]
        [System.IO.FileInfo]$ScriptInfo,

        [Parameter(Mandatory)]
        [System.IO.FileInfo]$CacheInfo,

        [Parameter(Mandatory)]
        [System.IO.FileInfo]$MetadataInfo,

        [Parameter(Mandatory)]
        [bool]$ContentLoaded,

        [Parameter()]
        [AllowNull()]
        [string]$Content
    )

    $entry = [pscustomobject]@{
        ScriptPath                    = $ScriptPath
        ScriptLength                  = [long]$ScriptInfo.Length
        ScriptLastWriteTimeUtcTicks   = [long]$ScriptInfo.LastWriteTimeUtc.Ticks
        CacheFile                     = $CacheFile
        CacheLength                   = [long]$CacheInfo.Length
        CacheLastWriteTimeUtcTicks    = [long]$CacheInfo.LastWriteTimeUtc.Ticks
        MetadataPath                  = $MetadataPath
        MetadataLength                = [long]$MetadataInfo.Length
        MetadataLastWriteTimeUtcTicks = [long]$MetadataInfo.LastWriteTimeUtc.Ticks
        ContentLoaded                 = $ContentLoaded
        Content                       = if ($ContentLoaded) { $Content } else { $null }
    }

    Invoke-ModuleSynchronized $script:CachedOutputMemorySyncRoot {
        $null = $script:CachedOutputMemory[$CacheFile] = $entry
    }
}

function Remove-CachedOutputMemoryEntry {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Removes only process-local memoized cache state; no external system state changes.')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$CacheFile
    )

    $cacheFileKey = $CacheFile
    Invoke-ModuleSynchronized $script:CachedOutputMemorySyncRoot {
        $null = $script:CachedOutputMemory.Remove($cacheFileKey)
    }
}

function Reset-CachedOutputMemory {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Clears only process-local memoized cache state; no external system state changes.')]
    [CmdletBinding()]
    param()

    Invoke-ModuleSynchronized $script:CachedOutputMemorySyncRoot {
        $script:CachedOutputMemory.Clear()
    }
}

function Get-CachedOutputFileSnapshot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ScriptPath,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$CacheFile,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$MetadataPath
    )

    try {
        $scriptInfo = [System.IO.FileInfo]$ScriptPath
        $cacheInfo = [System.IO.FileInfo]$CacheFile
        $metadataInfo = [System.IO.FileInfo]$MetadataPath

        if (-not $scriptInfo.Exists -or -not $cacheInfo.Exists -or -not $metadataInfo.Exists) {
            return $null
        }

        return [pscustomobject]@{
            ScriptInfo   = $scriptInfo
            CacheInfo    = $cacheInfo
            MetadataInfo = $metadataInfo
        }
    }
    catch {
        Write-ModuleTrace ("Unable to snapshot cached output files: {0}" -f $_.Exception.Message)
        return $null
    }
}

function Test-CachedOutputMemoryEntryCurrent {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [psobject]$Entry,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [psobject]$Snapshot
    )

    return (
        [long]$Entry.ScriptLength -eq [long]$Snapshot.ScriptInfo.Length -and
        [long]$Entry.ScriptLastWriteTimeUtcTicks -eq [long]$Snapshot.ScriptInfo.LastWriteTimeUtc.Ticks -and
        [long]$Entry.CacheLength -eq [long]$Snapshot.CacheInfo.Length -and
        [long]$Entry.CacheLastWriteTimeUtcTicks -eq [long]$Snapshot.CacheInfo.LastWriteTimeUtc.Ticks -and
        [long]$Entry.MetadataLength -eq [long]$Snapshot.MetadataInfo.Length -and
        [long]$Entry.MetadataLastWriteTimeUtcTicks -eq [long]$Snapshot.MetadataInfo.LastWriteTimeUtc.Ticks
    )
}
