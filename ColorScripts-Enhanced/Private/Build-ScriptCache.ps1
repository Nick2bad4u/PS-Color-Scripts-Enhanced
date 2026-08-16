function Invoke-BuildScriptCacheOperation {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath,

        [Parameter(Mandatory)]
        [string]$ScriptName,

        [Parameter(Mandatory)]
        [string]$CacheFile,

        [Parameter(Mandatory)]
        [pscustomobject]$Result
    )

    Remove-CacheEntryMetadataFile -ScriptName $ScriptName

    if (-not (Test-ColorScriptRequiresCache -ScriptPath $ScriptPath)) {
        $cleanup = Remove-ColorScriptCacheEntry -ScriptName $ScriptName
        $Result.CacheFile = if ($cleanup.CacheExists) { $cleanup.CacheFile } else { $null }
        $Result.CacheRequired = $false
        $Result.Success = $true
        return $Result
    }

    $execution = Invoke-ColorScriptProcess -ScriptPath $ScriptPath -ForCache
    $Result.ExitCode = $execution.ExitCode
    $Result.StdOut = $execution.StdOut
    $Result.StdErr = $execution.StdErr

    if (-not $execution.Success) {
        if (-not $Result.StdErr) {
            $Result.StdErr = ($script:Messages.ScriptExitedWithCode -f $execution.ExitCode)
        }
        return $Result
    }

    try {
        Invoke-FileWriteAllText -Path $CacheFile -Content $execution.StdOut -Encoding $script:Utf8NoBomEncoding

        try {
            $cacheStamp = (Get-Date).ToUniversalTime()
            Set-FileLastWriteTimeUtc -Path $CacheFile -Timestamp $cacheStamp
        }
        catch {
            $cacheStamp = Get-Date
            Set-FileLastWriteTime -Path $CacheFile -Timestamp $cacheStamp
        }

        $signature = Get-FileContentSignature -Path $ScriptPath -IncludeHash
        Write-CacheEntryMetadataFile -ScriptName $ScriptName -Signature $signature -CacheFile $CacheFile
        $Result.CacheCreated = $true
        $Result.Success = $true
    }
    catch {
        $Result.StdErr = $_.Exception.Message
        try {
            if (Test-Path -LiteralPath $CacheFile -PathType Leaf) {
                Remove-Item -LiteralPath $CacheFile -Force -ErrorAction Stop
            }
        }
        catch {
            Write-Verbose ("Failed to remove incomplete cache '{0}': {1}" -f $CacheFile, $_.Exception.Message)
        }

        Remove-CacheEntryMetadataFile -ScriptName $ScriptName
    }

    return $Result
}

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
        Invoke-BuildScriptCacheOperation -ScriptPath $lockedScriptPath -ScriptName $lockedScriptName -CacheFile $lockedCacheFile -Result $lockedResult
    }

    if ($LockAlreadyHeld) {
        return & $operation $ScriptPath $scriptName $cacheFile $result
    }

    return Invoke-WithColorScriptCacheEntryLock -CacheRoot $script:CacheDir -ScriptName $scriptName -Operation $operation -ArgumentList @($ScriptPath, $scriptName, $cacheFile, $result)
}
