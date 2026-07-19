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
        [string]$ScriptPath,

        [Parameter(DontShow)]
        [switch]$LockAlreadyHeld
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"

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

    $operation = {
        param($lockedScriptPath, $lockedScriptName, $lockedCacheFile, $lockedResult)

        Remove-CacheEntryMetadataFile -ScriptName $lockedScriptName

        if (-not (Test-ColorScriptRequiresCache -ScriptPath $lockedScriptPath)) {
            $cleanup = Remove-ColorScriptCacheEntry -ScriptName $lockedScriptName
            $lockedResult.CacheFile = if ($cleanup.CacheExists) { $cleanup.CacheFile } else { $null }
            $lockedResult.CacheRequired = $false
            $lockedResult.Success = $true
            return $lockedResult
        }

        $execution = Invoke-ColorScriptProcess -ScriptPath $lockedScriptPath -ForCache
        $lockedResult.ExitCode = $execution.ExitCode
        $lockedResult.StdOut = $execution.StdOut
        $lockedResult.StdErr = $execution.StdErr

        if ($execution.Success) {
            try {
                Invoke-FileWriteAllText -Path $lockedCacheFile -Content $execution.StdOut -Encoding $script:Utf8NoBomEncoding

                try {
                    $cacheStamp = (Get-Date).ToUniversalTime()
                    Set-FileLastWriteTimeUtc -Path $lockedCacheFile -Timestamp $cacheStamp
                }
                catch {
                    $cacheStamp = Get-Date
                    Set-FileLastWriteTime -Path $lockedCacheFile -Timestamp $cacheStamp
                }

                $signature = Get-FileContentSignature -Path $lockedScriptPath -IncludeHash
                Write-CacheEntryMetadataFile -ScriptName $lockedScriptName -Signature $signature -CacheFile $lockedCacheFile
                $lockedResult.CacheCreated = $true
                $lockedResult.Success = $true
            }
            catch {
                $lockedResult.StdErr = $_.Exception.Message
                try {
                    if (Test-Path -LiteralPath $lockedCacheFile -PathType Leaf) {
                        Remove-Item -LiteralPath $lockedCacheFile -Force -ErrorAction Stop
                    }
                }
                catch {
                    Write-Verbose ("Failed to remove incomplete cache '{0}': {1}" -f $lockedCacheFile, $_.Exception.Message)
                }

                Remove-CacheEntryMetadataFile -ScriptName $lockedScriptName
            }
        }
        elseif (-not $lockedResult.StdErr) {
            $lockedResult.StdErr = ($script:Messages.ScriptExitedWithCode -f $execution.ExitCode)
        }

        return $lockedResult
    }

    if ($LockAlreadyHeld) {
        return & $operation $ScriptPath $scriptName $cacheFile $result
    }

    return Invoke-WithColorScriptCacheEntryLock -CacheRoot $script:CacheDir -ScriptName $scriptName -Operation $operation -ArgumentList @($ScriptPath, $scriptName, $cacheFile, $result)
}
