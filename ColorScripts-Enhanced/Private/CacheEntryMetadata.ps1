if (-not $script:CacheEntryMetadataExtension) {
    $script:CacheEntryMetadataExtension = '.cacheinfo'
}

if (-not $script:CacheEntryMetadataVersion -or $script:CacheEntryMetadataVersion -lt 1) {
    $script:CacheEntryMetadataVersion = 1
}

function Get-CacheEntryMetadataPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [object]$ScriptName,

        [Parameter()]
        [string]$CacheRoot
    )

    $root = if ($PSBoundParameters.ContainsKey('CacheRoot') -and $CacheRoot) { $CacheRoot } else { $script:CacheDir }
    if (-not $root) {
        return $null
    }

    $scriptNameValue = if ($null -ne $ScriptName) { [string]$ScriptName } else { $null }
    $trimmed = if ($scriptNameValue) { $scriptNameValue.Trim() } else { $null }
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        return $null
    }

    return Join-Path -Path $root -ChildPath ("{0}{1}" -f $trimmed, $script:CacheEntryMetadataExtension)
}

function Remove-CacheEntryMetadataFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$ScriptName,

        [Parameter()]
        [string]$CacheRoot
    )

    $metadataPath = Get-CacheEntryMetadataPath -ScriptName $ScriptName -CacheRoot $CacheRoot
    if (-not $metadataPath) {
        return
    }

    if (-not (Test-Path -LiteralPath $metadataPath -PathType Leaf)) {
        return
    }

    try {
        Remove-Item -LiteralPath $metadataPath -Force -ErrorAction Stop
    }
    catch {
        Write-Verbose ("Failed to remove cache metadata '{0}': {1}" -f $metadataPath, $_.Exception.Message)
    }
}

function Write-CacheEntryMetadataFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ScriptName,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [pscustomobject]$Signature,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$CacheFile,

        [Parameter()]
        [string]$CacheGeneratedUtc,

        [Parameter()]
        [string]$ModuleVersionOverride
    )

    if (-not $script:CacheDir) {
        return
    }

    $metadataPath = Get-CacheEntryMetadataPath -ScriptName $ScriptName
    if (-not $metadataPath) {
        return
    }

    $nowUtc = (Get-Date).ToUniversalTime()
    $generatedUtc = if ([string]::IsNullOrWhiteSpace($CacheGeneratedUtc)) { $nowUtc.ToString('o') } else { $CacheGeneratedUtc }

    $moduleVersion = $ModuleVersionOverride
    if (-not $moduleVersion) {
        try {
            if ($ExecutionContext -and $ExecutionContext.SessionState -and $ExecutionContext.SessionState.Module) {
                $moduleVersion = $ExecutionContext.SessionState.Module.Version.ToString()
            }
        }
        catch {
            $moduleVersion = $null
        }
    }

    $hashAlgorithm = if ($Signature.PSObject.Properties['HashAlgorithm'] -and $Signature.HashAlgorithm) {
        [string]$Signature.HashAlgorithm
    }
    elseif ($script:CacheEntryHashAlgorithm) {
        $script:CacheEntryHashAlgorithm
    }
    else {
        'SHA256'
    }

    $metadataObject = [pscustomobject]@{
        Version              = $script:CacheEntryMetadataVersion
        CacheFile            = [System.IO.Path]::GetFileName($CacheFile)
        ModuleVersion        = $moduleVersion
        CacheGeneratedUtc    = $generatedUtc
        LastValidatedUtc     = $nowUtc.ToString('o')
        ScriptLength         = [long]$Signature.Length
        ScriptHash           = if ($Signature.PSObject.Properties['Hash']) { $Signature.Hash } else { $null }
        ScriptHashAlgorithm  = $hashAlgorithm
        ScriptLastWriteTimeUtc = if ($Signature.PSObject.Properties['LastWriteTimeUtc'] -and $Signature.LastWriteTimeUtc) { $Signature.LastWriteTimeUtc.ToString('o') } else { $null }
    }

    $json = $metadataObject | ConvertTo-Json -Depth 5
    Invoke-FileWriteAllText -Path $metadataPath -Content $json -Encoding $script:Utf8NoBomEncoding
}
