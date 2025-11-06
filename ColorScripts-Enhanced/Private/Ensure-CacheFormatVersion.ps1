if (-not $script:CacheFormatVersion) {
    $script:CacheFormatVersion = 2
}

function Update-CacheFormatVersion {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$CacheDirectory
    )

    if (-not (Test-Path -LiteralPath $CacheDirectory -PathType Container)) {
        return
    }

    $metadataPath = Join-Path -Path $CacheDirectory -ChildPath 'cache-metadata.json'
    $currentVersion = $null

    if (Test-Path -LiteralPath $metadataPath -PathType Leaf) {
        try {
            $metadataJson = Get-Content -LiteralPath $metadataPath -Raw
            if ($metadataJson) {
                $metadata = ConvertFrom-Json -InputObject $metadataJson -ErrorAction Stop
                if ($metadata -and $metadata.PSObject.Properties.Match('Version')) {
                    $currentVersion = [int]$metadata.Version
                }
            }
        }
        catch {
            Write-Verbose ("Cache metadata read failed: {0}" -f $_.Exception.Message)
            $currentVersion = $null
        }
    }

    $targetVersion = [int]$script:CacheFormatVersion
    if ($currentVersion -eq $targetVersion) {
        return
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
        Version       = $targetVersion
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
