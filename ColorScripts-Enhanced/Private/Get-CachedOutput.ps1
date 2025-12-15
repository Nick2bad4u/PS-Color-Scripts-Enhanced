function Get-CachedOutput {
    <#
    .SYNOPSIS
        Retrieves cached output for a colorscript if available and valid.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    if ([string]::IsNullOrWhiteSpace($ScriptPath)) {
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $null
            Content       = ''
            LastWriteTime = $null
        }
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
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $null
            Content       = ''
            LastWriteTime = $null
        }
    }

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path -Path $script:CacheDir -ChildPath ("{0}.cache" -f $scriptName)
    $metadataPath = Get-CacheEntryMetadataPath -ScriptName $scriptName

    try {
        $scriptFileExists = $false
        try {
            $scriptFileExists = & $script:FileExistsDelegate $ScriptPath
        }
        catch {
            Write-Verbose "Unable to verify script existence for ${ScriptPath}: $($_.Exception.Message)"
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $null
                Content       = ''
                LastWriteTime = $null
            }
        }

        if (-not $scriptFileExists) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $null
                Content       = ''
                LastWriteTime = $null
            }
        }

        if (-not (Test-Path -LiteralPath $cacheFile)) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $null
            }
        }

        if (-not $metadataPath -or -not (Test-Path -LiteralPath $metadataPath -PathType Leaf)) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $null
            }
        }

        $metadata = $null
        try {
            $metadataContent = & $script:FileReadAllTextDelegate $metadataPath $script:Utf8NoBomEncoding
            if (-not [string]::IsNullOrWhiteSpace($metadataContent)) {
                $metadata = $metadataContent | ConvertFrom-Json -Depth 5
            }
        }
        catch {
            Write-Verbose ("Cache metadata read error for {0}: {1}" -f $ScriptPath, $_.Exception.Message)
            $metadata = $null
        }

        if (-not $metadata) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $null
            }
        }

        $metadataVersion = if ($metadata.PSObject.Properties['Version']) { [int]$metadata.Version } else { 0 }
        if ($metadataVersion -ne $script:CacheEntryMetadataVersion) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $null
            }
        }

        $metadataLength = if ($metadata.PSObject.Properties['ScriptLength']) { [long]$metadata.ScriptLength } else { $null }
        if ($null -eq $metadataLength) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $null
            }
        }

        $scriptInfo = Get-Item -LiteralPath $ScriptPath -ErrorAction Stop
        $cacheLastWrite = $null
        try {
            $cacheLastWrite = & $script:FileGetLastWriteTimeUtcDelegate $cacheFile
        }
        catch {
            $cacheLastWrite = $null
        }

        if (-not $cacheLastWrite) {
            try {
                $cacheLastWrite = [System.IO.File]::GetLastWriteTimeUtc($cacheFile)
            }
            catch {
                try {
                    $cacheLastWrite = [System.IO.File]::GetLastWriteTime($cacheFile)
                }
                catch {
                    $cacheLastWrite = $null
                }
            }
        }

        $scriptLastWriteUtc = $scriptInfo.LastWriteTimeUtc

        if ([long]$scriptInfo.Length -ne $metadataLength) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $cacheLastWrite
            }
        }

        $metadataLastWriteUtc = $null
        if ($metadata.PSObject.Properties['ScriptLastWriteTimeUtc'] -and $metadata.ScriptLastWriteTimeUtc) {
            try {
                $metadataLastWriteUtc = [System.DateTime]::ParseExact(
                    [string]$metadata.ScriptLastWriteTimeUtc,
                    'o',
                    [System.Globalization.CultureInfo]::InvariantCulture,
                    [System.Globalization.DateTimeStyles]::AdjustToUniversal)
            }
            catch {
                $metadataLastWriteUtc = $null
            }
        }

        $metadataHash = $null
        if ($metadata.PSObject.Properties['ScriptHash']) {
            $metadataHash = ([string]$metadata.ScriptHash)
        }

        $metadataHashAlgorithm = if ($metadata.PSObject.Properties['ScriptHashAlgorithm'] -and $metadata.ScriptHashAlgorithm) {
            [string]$metadata.ScriptHashAlgorithm
        }
        elseif ($script:CacheEntryHashAlgorithm) {
            $script:CacheEntryHashAlgorithm
        }
        else {
            'SHA256'
        }

        $cacheGeneratedUtc = if ($metadata.PSObject.Properties['CacheGeneratedUtc']) { [string]$metadata.CacheGeneratedUtc } else { $null }
        $storedModuleVersion = if ($metadata.PSObject.Properties['ModuleVersion']) { [string]$metadata.ModuleVersion } else { $null }

        $contentValidated = $false
        if ($metadataLastWriteUtc -and ($scriptLastWriteUtc -eq $metadataLastWriteUtc)) {
            $contentValidated = $true
        }
        else {
            if ([string]::IsNullOrWhiteSpace($metadataHash)) {
                return [pscustomobject]@{
                    Available     = $false
                    CacheFile     = $cacheFile
                    Content       = ''
                    LastWriteTime = $cacheLastWrite
                }
            }

            $algorithmNormalized = $metadataHashAlgorithm.ToUpperInvariant()
            if ($algorithmNormalized -ne 'SHA256') {
                return [pscustomobject]@{
                    Available     = $false
                    CacheFile     = $cacheFile
                    Content       = ''
                    LastWriteTime = $cacheLastWrite
                }
            }

            $computedSignature = $null
            try {
                $computedSignature = Get-FileContentSignature -Path $ScriptPath -IncludeHash
            }
            catch {
                Write-Verbose ("Failed to compute file signature for {0}: {1}" -f $ScriptPath, $_.Exception.Message)
                $computedSignature = $null
            }

            if (-not $computedSignature -or ([long]$computedSignature.Length -ne $metadataLength)) {
                return [pscustomobject]@{
                    Available     = $false
                    CacheFile     = $cacheFile
                    Content       = ''
                    LastWriteTime = $cacheLastWrite
                }
            }

            if ([string]::IsNullOrWhiteSpace($computedSignature.Hash)) {
                return [pscustomobject]@{
                    Available     = $false
                    CacheFile     = $cacheFile
                    Content       = ''
                    LastWriteTime = $cacheLastWrite
                }
            }

            $expectedHash = $metadataHash.ToLowerInvariant()
            $actualHash = $computedSignature.Hash.ToLowerInvariant()
            if ($expectedHash -ne $actualHash) {
                return [pscustomobject]@{
                    Available     = $false
                    CacheFile     = $cacheFile
                    Content       = ''
                    LastWriteTime = $cacheLastWrite
                }
            }

            $contentValidated = $true

            try {
                Write-CacheEntryMetadataFile -ScriptName $scriptName -Signature $computedSignature -CacheFile $cacheFile -CacheGeneratedUtc $cacheGeneratedUtc -ModuleVersionOverride $storedModuleVersion
            }
            catch {
                Write-Verbose ("Cache metadata refresh failed for {0}: {1}" -f $ScriptPath, $_.Exception.Message)
            }
        }

        if (-not $contentValidated) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $cacheLastWrite
            }
        }

        # Migration/robustness:
        # Historically cache files were backdated to the script's LastWriteTimeUtc. That makes
        # *.cache appear old even when they are valid and recently used/validated, and can cause
        # external cleanup tools to delete *.cache while leaving *.cacheinfo behind.
        # If we detect that legacy stamp, touch the cache file to 'now' once.
        try {
            if ($cacheLastWrite -and $scriptLastWriteUtc -and ($cacheLastWrite -eq $scriptLastWriteUtc)) {
                $nowUtc = (Get-Date).ToUniversalTime()
                try {
                    Set-FileLastWriteTimeUtc -Path $cacheFile -Timestamp $nowUtc
                    $cacheLastWrite = $nowUtc
                }
                catch {
                    try {
                        $nowLocal = Get-Date
                        Set-FileLastWriteTime -Path $cacheFile -Timestamp $nowLocal
                        $cacheLastWrite = $nowLocal.ToUniversalTime()
                    }
                    catch {
                        Write-Verbose ("Failed to touch cache file timestamp for {0}: {1}" -f $cacheFile, $_.Exception.Message)
                    }
                }
            }
        }
        catch {
            Write-Verbose ("Cache timestamp migration check failed for {0}: {1}" -f $cacheFile, $_.Exception.Message)
        }

        $content = & $script:FileReadAllTextDelegate $cacheFile $script:Utf8NoBomEncoding

        return [pscustomobject]@{
            Available     = $true
            CacheFile     = $cacheFile
            Content       = $content
            LastWriteTime = $cacheLastWrite
        }
    }
    catch {
        Write-Verbose "Cache read error for $ScriptPath : $($_.Exception.Message)"
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $cacheFile
            Content       = ''
            LastWriteTime = $null
        }
    }
}
