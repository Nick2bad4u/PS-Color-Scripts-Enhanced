function Build-ScriptCache {
    <#
    .SYNOPSIS
        Builds cache for a specific colorscript.

        The full path to the colorscript file.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"
    Remove-CacheEntryMetadataFile -ScriptName $scriptName

    $result = [pscustomobject]@{
        ScriptName    = $scriptName
        CacheFile     = $cacheFile
        CacheRequired = $true
        CacheCreated  = $false
        Success       = $false
        ExitCode      = $null
        StdOut        = ''
        StdErr        = ''
    }

    if (-not [System.IO.File]::Exists($ScriptPath)) {
        $result.StdErr = $script:Messages.ScriptPathNotFound
        return $result
    }

    if (-not (Test-ColorScriptRequiresCache -ScriptPath $ScriptPath)) {
        $cleanup = Remove-ColorScriptCacheEntry -ScriptName $scriptName
        $result.CacheFile = if ($cleanup.CacheExists) { $cleanup.CacheFile } else { $null }
        $result.CacheRequired = $false
        $result.Success = $true
        return $result
    }

    $execution = Invoke-ColorScriptProcess -ScriptPath $ScriptPath -ForCache
    $result.ExitCode = $execution.ExitCode
    $result.StdOut = $execution.StdOut
    $result.StdErr = $execution.StdErr

    if ($execution.Success) {
        try {
            Invoke-FileWriteAllText -Path $cacheFile -Content $execution.StdOut -Encoding $script:Utf8NoBomEncoding

            try {
                $cacheStamp = (Get-Date).ToUniversalTime()
                Set-FileLastWriteTimeUtc -Path $cacheFile -Timestamp $cacheStamp
            }
            catch {
                $cacheStamp = Get-Date
                Set-FileLastWriteTime -Path $cacheFile -Timestamp $cacheStamp
            }

            $signature = Get-FileContentSignature -Path $ScriptPath -IncludeHash
            Write-CacheEntryMetadataFile -ScriptName $scriptName -Signature $signature -CacheFile $cacheFile
            $result.CacheCreated = $true
            $result.Success = $true
        }
        catch {
            $result.StdErr = $_.Exception.Message
            try {
                if (Test-Path -LiteralPath $cacheFile -PathType Leaf) {
                    Remove-Item -LiteralPath $cacheFile -Force -ErrorAction Stop
                }
            }
            catch {
                Write-Verbose ("Failed to remove incomplete cache '{0}': {1}" -f $cacheFile, $_.Exception.Message)
            }

            Remove-CacheEntryMetadataFile -ScriptName $scriptName
        }
    }
    elseif (-not $result.StdErr) {
        $result.StdErr = ($script:Messages.ScriptExitedWithCode -f $execution.ExitCode)
    }

    return $result
}
