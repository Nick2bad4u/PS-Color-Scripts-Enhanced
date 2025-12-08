if (-not $script:CacheFormatVersion) {
    $script:CacheFormatVersion = 2
}

if ($null -eq $script:CacheValidationManualOverride) {
    $script:CacheValidationManualOverride = $false
}

if ($null -eq $script:CacheValidationPerformed) {
    $script:CacheValidationPerformed = $false
}

function Set-CacheValidationOverride {
    param(
        [Parameter(Mandatory)]
        [bool]$Value
    )

    $script:CacheValidationManualOverride = $Value

    if ($Value) {
        $script:CacheValidationPerformed = $false
    }
}

function Update-CacheFormatVersion {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$CacheDirectory,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$MetadataFileName
    )

    if (-not (Test-Path -LiteralPath $CacheDirectory -PathType Container)) {
        return
    }

    $metadataPath = Join-Path -Path $CacheDirectory -ChildPath $MetadataFileName

    try {
        Get-ChildItem -LiteralPath $CacheDirectory -Filter 'cache-metadata*.json' -File -ErrorAction Stop |
            Where-Object { $_.Name -ne $MetadataFileName } |
                ForEach-Object {
                    try {
                        Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop
                    }
                    catch {
                        Write-Verbose ("Failed to remove obsolete cache metadata '{0}': {1}" -f $_.FullName, $_.Exception.Message)
                    }
                }
    }
    catch {
        Write-Verbose ("Cache metadata cleanup failed: {0}" -f $_.Exception.Message)
    }

    try {
        Get-ChildItem -LiteralPath $CacheDirectory -Filter '*.cache' -File -ErrorAction Stop | ForEach-Object {
            try {
                Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop
            }
            catch {
                Write-Verbose ("Failed to remove cache file '{0}': {1}" -f $_.FullName, $_.Exception.Message)
            }
        }
    }
    catch {
        Write-Verbose ("Cache purge enumeration failed: {0}" -f $_.Exception.Message)
    }

    try {
        Get-ChildItem -LiteralPath $CacheDirectory -Filter ('*{0}' -f $script:CacheEntryMetadataExtension) -File -ErrorAction Stop | ForEach-Object {
            try {
                Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop
            }
            catch {
                Write-Verbose ("Failed to remove cache metadata file '{0}': {1}" -f $_.FullName, $_.Exception.Message)
            }
        }
    }
    catch {
        Write-Verbose ("Cache metadata purge enumeration failed: {0}" -f $_.Exception.Message)
    }

    $moduleVersion = $null
    try {
        if ($ExecutionContext.SessionState -and $ExecutionContext.SessionState.Module) {
            $moduleVersion = $ExecutionContext.SessionState.Module.Version.ToString()
        }
    }
    catch {
        $moduleVersion = $null
    }

    $metadataObject = [pscustomobject]@{
        Version       = [int]$script:CacheFormatVersion
        ModuleVersion = $moduleVersion
        UpdatedUtc    = (Get-Date).ToUniversalTime().ToString('o')
    }

    $metadataJson = $metadataObject | ConvertTo-Json -Depth 3
    $encoding = New-Object System.Text.UTF8Encoding($false)

    try {
        [System.IO.File]::WriteAllText($metadataPath, $metadataJson, $encoding)
    }
    catch {
        Write-Verbose ("Cache metadata write failed: {0}" -f $_.Exception.Message)
    }
}
