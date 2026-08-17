function ConvertTo-CachedOutputResult {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][bool]$Available,
        [Parameter()][AllowNull()][object]$CacheFile,
        [Parameter()][AllowEmptyString()][string]$Content = '',
        [Parameter()][AllowNull()][object]$LastWriteTime = $null
    )

    return [pscustomobject]@{
        Available     = $Available
        CacheFile     = $CacheFile
        Content       = $Content
        LastWriteTime = $LastWriteTime
    }
}

function ConvertTo-CachedOutputValidationResult {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][bool]$Success,
        [Parameter()][AllowNull()][object]$Value = $null
    )

    return [pscustomobject]@{
        Success = $Success
        Value   = $Value
    }
}

function Test-CachedOutputScriptFile {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)][string]$ScriptPath
    )

    try {
        return [bool](& $script:FileExistsDelegate $ScriptPath)
    }
    catch {
        Write-Verbose "Unable to verify script existence for ${ScriptPath}: $($_.Exception.Message)"
        return $false
    }
}

function Get-CachedOutputInitialSnapshot {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$ScriptPath,
        [Parameter(Mandatory)][string]$CacheFile,
        [Parameter(Mandatory)][string]$MetadataPath
    )

    if (-not (Test-Path -LiteralPath $CacheFile) -or
        -not (Test-Path -LiteralPath $MetadataPath -PathType Leaf)) {
        Remove-CachedOutputMemoryEntry -CacheFile $CacheFile
        return $null
    }

    $snapshot = Get-CachedOutputFileSnapshot -ScriptPath $ScriptPath -CacheFile $CacheFile -MetadataPath $MetadataPath
    if (-not $snapshot) {
        Remove-CachedOutputMemoryEntry -CacheFile $CacheFile
        return $null
    }

    return $snapshot
}

function Resolve-CachedOutputMemoryResult {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$ScriptPath,
        [Parameter(Mandatory)][string]$CacheFile,
        [Parameter(Mandatory)][string]$MetadataPath,
        [Parameter(Mandatory)][object]$Snapshot,
        [switch]$MetadataOnly
    )

    $memoryEntry = Get-CachedOutputMemoryEntry -CacheFile $CacheFile
    if (-not $memoryEntry) {
        return [pscustomobject]@{ Resolved = $false; Result = $null }
    }

    if (-not (Test-CachedOutputMemoryEntryCurrent -Entry $memoryEntry -Snapshot $Snapshot)) {
        Remove-CachedOutputMemoryEntry -CacheFile $CacheFile
        return [pscustomobject]@{ Resolved = $false; Result = $null }
    }

    if ($MetadataOnly) {
        $result = ConvertTo-CachedOutputResult -Available $true -CacheFile $CacheFile -LastWriteTime $Snapshot.CacheInfo.LastWriteTimeUtc
        return [pscustomobject]@{ Resolved = $true; Result = $result }
    }

    if ($memoryEntry.ContentLoaded) {
        $result = ConvertTo-CachedOutputResult -Available $true -CacheFile $CacheFile -Content ([string]$memoryEntry.Content) -LastWriteTime $Snapshot.CacheInfo.LastWriteTimeUtc
        return [pscustomobject]@{ Resolved = $true; Result = $result }
    }

    $content = & $script:FileReadAllTextDelegate $CacheFile $script:Utf8NoBomEncoding
    Set-CachedOutputMemoryEntry -CacheFile $CacheFile -ScriptPath $ScriptPath -MetadataPath $MetadataPath -ScriptInfo $Snapshot.ScriptInfo -CacheInfo $Snapshot.CacheInfo -MetadataInfo $Snapshot.MetadataInfo -ContentLoaded $true -Content $content
    $result = ConvertTo-CachedOutputResult -Available $true -CacheFile $CacheFile -Content $content -LastWriteTime $Snapshot.CacheInfo.LastWriteTimeUtc
    return [pscustomobject]@{ Resolved = $true; Result = $result }
}

function Read-CachedOutputMetadataFile {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$ScriptPath,
        [Parameter(Mandatory)][string]$MetadataPath
    )

    try {
        $metadataContent = & $script:FileReadAllTextDelegate $MetadataPath $script:Utf8NoBomEncoding
        if ([string]::IsNullOrWhiteSpace($metadataContent)) {
            return $null
        }

        return $metadataContent | ConvertFrom-Json
    }
    catch {
        Write-Verbose ("Cache metadata read error for {0}: {1}" -f $ScriptPath, $_.Exception.Message)
        return $null
    }
}

function ConvertTo-CachedOutputMetadataHeader {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][object]$Metadata
    )

    $metadataVersion = if ($Metadata.PSObject.Properties['Version']) { [int]$Metadata.Version } else { 0 }
    if ($metadataVersion -ne $script:CacheEntryMetadataVersion) {
        return ConvertTo-CachedOutputValidationResult -Success $false
    }

    $metadataLength = if ($Metadata.PSObject.Properties['ScriptLength']) { [long]$Metadata.ScriptLength } else { $null }
    if ($null -eq $metadataLength) {
        return ConvertTo-CachedOutputValidationResult -Success $false
    }

    return ConvertTo-CachedOutputValidationResult -Success $true -Value $metadataLength
}

function ConvertTo-CachedOutputMetadataLastWriteTime {
    [CmdletBinding()]
    [OutputType([datetime])]
    param(
        [Parameter(Mandatory)][object]$Metadata
    )

    if (-not $Metadata.PSObject.Properties['ScriptLastWriteTimeUtc'] -or -not $Metadata.ScriptLastWriteTimeUtc) {
        return $null
    }

    try {
        $lastWriteTime = [System.DateTime]::ParseExact(
            [string]$Metadata.ScriptLastWriteTimeUtc,
            'o',
            [System.Globalization.CultureInfo]::InvariantCulture,
            [System.Globalization.DateTimeStyles]::AdjustToUniversal)
        return $lastWriteTime.ToUniversalTime()
    }
    catch {
        return $null
    }
}

function Get-CachedOutputMetadataHashAlgorithm {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)][object]$Metadata
    )

    if ($Metadata.PSObject.Properties['ScriptHashAlgorithm'] -and $Metadata.ScriptHashAlgorithm) {
        return [string]$Metadata.ScriptHashAlgorithm
    }

    if ($script:CacheEntryHashAlgorithm) {
        return $script:CacheEntryHashAlgorithm
    }

    return 'SHA256'
}

function Get-CachedOutputCacheLastWriteTime {
    [CmdletBinding()]
    [OutputType([datetime])]
    param(
        [Parameter(Mandatory)][string]$CacheFile
    )

    try {
        $lastWriteTime = & $script:FileGetLastWriteTimeUtcDelegate $CacheFile
        if ($lastWriteTime) {
            return $lastWriteTime
        }
    }
    catch {
        Write-ModuleTrace ("Cache timestamp delegate failed for '{0}': {1}" -f $CacheFile, $_.Exception.Message)
    }

    try {
        return [System.IO.File]::GetLastWriteTimeUtc($CacheFile)
    }
    catch {
        try {
            return [System.IO.File]::GetLastWriteTime($CacheFile)
        }
        catch {
            return $null
        }
    }
}

function Test-CachedOutputScriptSignature {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)][string]$ScriptPath,
        [Parameter(Mandatory)][string]$ScriptName,
        [Parameter(Mandatory)][string]$CacheFile,
        [Parameter(Mandatory)][long]$MetadataLength,
        [Parameter()][AllowNull()][object]$MetadataLastWriteTime,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$MetadataHash,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$CacheGeneratedUtc,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$StoredModuleVersion,
        [Parameter(Mandatory)][datetime]$ScriptLastWriteTimeUtc
    )

    if ($MetadataLastWriteTime -and $ScriptLastWriteTimeUtc -eq $MetadataLastWriteTime) {
        return $true
    }

    if ([string]::IsNullOrWhiteSpace($MetadataHash)) {
        return $false
    }

    try {
        $computedSignature = Get-FileContentSignature -Path $ScriptPath -IncludeHash
    }
    catch {
        Write-Verbose ("Failed to compute file signature for {0}: {1}" -f $ScriptPath, $_.Exception.Message)
        return $false
    }

    if (-not $computedSignature -or
        [long]$computedSignature.Length -ne $MetadataLength -or
        [string]::IsNullOrWhiteSpace($computedSignature.Hash) -or
        $MetadataHash.ToLowerInvariant() -ne $computedSignature.Hash.ToLowerInvariant()) {
        return $false
    }

    try {
        Write-CacheEntryMetadataFile -ScriptName $ScriptName -Signature $computedSignature -CacheFile $CacheFile -CacheGeneratedUtc $CacheGeneratedUtc -ModuleVersionOverride $StoredModuleVersion
    }
    catch {
        Write-Verbose ("Cache metadata refresh failed for {0}: {1}" -f $ScriptPath, $_.Exception.Message)
    }

    return $true
}

function Repair-CachedOutputLegacyTimestamp {
    [CmdletBinding()]
    [OutputType([datetime])]
    param(
        [Parameter(Mandatory)][string]$CacheFile,
        [Parameter()][AllowNull()][object]$CacheLastWriteTime,
        [Parameter(Mandatory)][datetime]$ScriptLastWriteTimeUtc
    )

    if (-not $CacheLastWriteTime -or $CacheLastWriteTime -ne $ScriptLastWriteTimeUtc) {
        return $CacheLastWriteTime
    }

    # Older versions backdated cache files to the source timestamp. Touch that legacy stamp
    # once so external cleanup tools do not remove a valid payload but leave its sidecar behind.
    try {
        $nowUtc = (Get-Date).ToUniversalTime()
        try {
            $null = Set-FileLastWriteTimeUtc -Path $CacheFile -Timestamp $nowUtc
            return $nowUtc
        }
        catch {
            try {
                $nowLocal = Get-Date
                $null = Set-FileLastWriteTime -Path $CacheFile -Timestamp $nowLocal
                return $nowLocal.ToUniversalTime()
            }
            catch {
                Write-Verbose ("Failed to touch cache file timestamp for {0}: {1}" -f $CacheFile, $_.Exception.Message)
                return $CacheLastWriteTime
            }
        }
    }
    catch {
        Write-Verbose ("Cache timestamp migration check failed for {0}: {1}" -f $CacheFile, $_.Exception.Message)
        return $CacheLastWriteTime
    }
}

function Get-ValidatedCachedOutput {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$ScriptPath,
        [Parameter(Mandatory)][string]$ScriptName,
        [Parameter(Mandatory)][string]$CacheFile,
        [Parameter(Mandatory)][string]$MetadataPath,
        [switch]$MetadataOnly
    )

    $metadata = Read-CachedOutputMetadataFile -ScriptPath $ScriptPath -MetadataPath $MetadataPath
    if (-not $metadata) {
        return ConvertTo-CachedOutputResult -Available $false -CacheFile $CacheFile
    }

    $header = ConvertTo-CachedOutputMetadataHeader -Metadata $metadata
    if (-not $header.Success) {
        return ConvertTo-CachedOutputResult -Available $false -CacheFile $CacheFile
    }

    $metadataLength = [long]$header.Value
    $scriptInfo = Get-Item -LiteralPath $ScriptPath -ErrorAction Stop
    $cacheLastWriteTime = Get-CachedOutputCacheLastWriteTime -CacheFile $CacheFile
    if ([long]$scriptInfo.Length -ne $metadataLength) {
        return ConvertTo-CachedOutputResult -Available $false -CacheFile $CacheFile -LastWriteTime $cacheLastWriteTime
    }

    $metadataHashAlgorithm = Get-CachedOutputMetadataHashAlgorithm -Metadata $metadata
    if ($metadataHashAlgorithm.ToUpperInvariant() -ne 'SHA256') {
        return ConvertTo-CachedOutputResult -Available $false -CacheFile $CacheFile -LastWriteTime $cacheLastWriteTime
    }

    $metadataLastWriteTime = ConvertTo-CachedOutputMetadataLastWriteTime -Metadata $metadata
    $metadataHash = if ($metadata.PSObject.Properties['ScriptHash']) { [string]$metadata.ScriptHash } else { $null }
    $cacheGeneratedUtc = if ($metadata.PSObject.Properties['CacheGeneratedUtc']) { [string]$metadata.CacheGeneratedUtc } else { $null }
    $storedModuleVersion = if ($metadata.PSObject.Properties['ModuleVersion']) { [string]$metadata.ModuleVersion } else { $null }
    $signatureMatches = Test-CachedOutputScriptSignature -ScriptPath $ScriptPath -ScriptName $ScriptName -CacheFile $CacheFile -MetadataLength $metadataLength -MetadataLastWriteTime $metadataLastWriteTime -MetadataHash $metadataHash -CacheGeneratedUtc $cacheGeneratedUtc -StoredModuleVersion $storedModuleVersion -ScriptLastWriteTimeUtc $scriptInfo.LastWriteTimeUtc
    if (-not $signatureMatches) {
        return ConvertTo-CachedOutputResult -Available $false -CacheFile $CacheFile -LastWriteTime $cacheLastWriteTime
    }

    $cacheLastWriteTime = Repair-CachedOutputLegacyTimestamp -CacheFile $CacheFile -CacheLastWriteTime $cacheLastWriteTime -ScriptLastWriteTimeUtc $scriptInfo.LastWriteTimeUtc
    $content = if ($MetadataOnly) { '' } else { & $script:FileReadAllTextDelegate $CacheFile $script:Utf8NoBomEncoding }
    $validatedSnapshot = Get-CachedOutputFileSnapshot -ScriptPath $ScriptPath -CacheFile $CacheFile -MetadataPath $MetadataPath
    if ($validatedSnapshot) {
        Set-CachedOutputMemoryEntry -CacheFile $CacheFile -ScriptPath $ScriptPath -MetadataPath $MetadataPath -ScriptInfo $validatedSnapshot.ScriptInfo -CacheInfo $validatedSnapshot.CacheInfo -MetadataInfo $validatedSnapshot.MetadataInfo -ContentLoaded (-not $MetadataOnly.IsPresent) -Content $content
    }

    return ConvertTo-CachedOutputResult -Available $true -CacheFile $CacheFile -Content $content -LastWriteTime $cacheLastWriteTime
}

function Get-CachedOutput {
    <#
    .SYNOPSIS
        Retrieves cached output for a colorscript if available and valid.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath,

        [switch]$MetadataOnly
    )

    if ([string]::IsNullOrWhiteSpace($ScriptPath)) {
        return ConvertTo-CachedOutputResult -Available $false -CacheFile $null
    }

    if (-not $script:CacheDir) {
        try {
            Initialize-CacheDirectory
        }
        catch {
            Write-Verbose "Initialize-CacheDirectory failed: $($_.Exception.Message)"
        }
    }

    if (-not $script:CacheDir) {
        return ConvertTo-CachedOutputResult -Available $false -CacheFile $null
    }

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path -Path $script:CacheDir -ChildPath ("{0}.cache" -f $scriptName)
    $metadataPath = Get-CacheEntryMetadataPath -ScriptName $scriptName

    try {
        if (-not (Test-CachedOutputScriptFile -ScriptPath $ScriptPath)) {
            return ConvertTo-CachedOutputResult -Available $false -CacheFile $null
        }

        if (-not $metadataPath) {
            Remove-CachedOutputMemoryEntry -CacheFile $cacheFile
            return ConvertTo-CachedOutputResult -Available $false -CacheFile $cacheFile
        }

        $snapshot = Get-CachedOutputInitialSnapshot -ScriptPath $ScriptPath -CacheFile $cacheFile -MetadataPath $metadataPath
        if (-not $snapshot) {
            return ConvertTo-CachedOutputResult -Available $false -CacheFile $cacheFile
        }

        $memoryResult = Resolve-CachedOutputMemoryResult -ScriptPath $ScriptPath -CacheFile $cacheFile -MetadataPath $metadataPath -Snapshot $snapshot -MetadataOnly:$MetadataOnly
        if ($memoryResult.Resolved) {
            return $memoryResult.Result
        }

        return Get-ValidatedCachedOutput -ScriptPath $ScriptPath -ScriptName $scriptName -CacheFile $cacheFile -MetadataPath $metadataPath -MetadataOnly:$MetadataOnly
    }
    catch {
        Write-Verbose "Cache read error for $ScriptPath : $($_.Exception.Message)"
        return ConvertTo-CachedOutputResult -Available $false -CacheFile $cacheFile
    }
}
