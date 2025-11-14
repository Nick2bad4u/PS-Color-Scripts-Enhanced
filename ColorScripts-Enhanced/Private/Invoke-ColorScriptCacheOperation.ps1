function Invoke-ColorScriptCacheOperation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ScriptName,
        [Parameter(Mandatory)][string]$ScriptPath
    )

    $resultRecord = $null
    $warningMessage = $null
    $updated = 0
    $failed = 0

    $initializationError = $null
    try {
        Initialize-CacheDirectory
    }
    catch {
        $initializationError = $_.Exception
    }

    if (-not $script:CacheDir) {
        $failed = 1
        $status = 'Failed'
        $detail = if ($initializationError) { $initializationError.Message } else { $null }

        $messageTemplate = if ($script:Messages -and $script:Messages.ContainsKey('CacheOperationInitializationFailed')) {
            $script:Messages.CacheOperationInitializationFailed
        }
        else {
            'Unable to initialize the cache directory: {0}'
        }

        $detailValue = if (-not [string]::IsNullOrWhiteSpace($detail)) { $detail } else { 'n/a' }
        $message = $messageTemplate -f $detailValue
        $warningMessage = $message

        $resultRecord = [pscustomobject]@{
            Name        = $ScriptName
            ScriptPath  = $ScriptPath
            CacheFile   = $null
            Status      = $status
            Message     = $message
            CacheExists = $false
            ExitCode    = $null
            StdOut      = ''
            StdErr      = $detail
        }

        return [pscustomobject]@{
            Result  = $resultRecord
            Updated = $updated
            Failed  = $failed
            Warning = $warningMessage
        }
    }

    try {
        $cacheResult = Build-ScriptCache -ScriptPath $ScriptPath
    }
    catch {
        if (-not $script:CacheDir) {
            Initialize-CacheDirectory
        }
        $cacheResult = [pscustomobject]@{
            ScriptName = $ScriptName
            CacheFile  = Join-Path -Path $script:CacheDir -ChildPath ("{0}.cache" -f $ScriptName)
            Success    = $false
            ExitCode   = $null
            StdOut     = ''
            StdErr     = $_.Exception.Message
        }
    }

    if ($cacheResult.Success) {
        $updated = 1
        $status = 'Updated'
        $message = $script:Messages.StatusCached
        $cacheExists = $true
    }
    else {
        $failed = 1
        $status = 'Failed'

        $detailMessage = if ($cacheResult.StdErr) {
            $cacheResult.StdErr
        }
        elseif ($null -ne $cacheResult.ExitCode) {
            if ($script:Messages -and $script:Messages.ContainsKey('ScriptExitedWithCode')) {
                $script:Messages.ScriptExitedWithCode -f $cacheResult.ExitCode
            }
            else {
                "Script exited with code $($cacheResult.ExitCode)."
            }
        }
        else {
            if ($script:Messages -and $script:Messages.ContainsKey('CacheBuildGenericFailure')) {
                $script:Messages.CacheBuildGenericFailure
            }
            else {
                'Cache build failed.'
            }
        }

        $messageTemplate = if ($script:Messages -and $script:Messages.ContainsKey('CacheBuildFailedForScript')) {
            $script:Messages.CacheBuildFailedForScript
        }
        else {
            "Cache build failed for {0}: {1}"
        }

        $warningTemplate = if ($script:Messages -and $script:Messages.ContainsKey('CacheOperationWarning')) {
            $script:Messages.CacheOperationWarning
        }
        else {
            "Failed to cache '{0}': {1}"
        }

        $message = $detailMessage
        $warningMessage = $warningTemplate -f $ScriptName, $detailMessage
        $cacheExists = $false
        $cacheResult.CacheFile = if ($cacheResult.CacheFile) { $cacheResult.CacheFile } else { Join-Path -Path $script:CacheDir -ChildPath ("{0}.cache" -f $ScriptName) }

        $detailMessage = $messageTemplate -f $ScriptName, $detailMessage
        if (-not $warningMessage) {
            $warningMessage = $detailMessage
        }
        $message = $detailMessage
    }

    $resultRecord = [pscustomobject]@{
        Name        = if ($cacheResult.ScriptName) { $cacheResult.ScriptName } else { $ScriptName }
        ScriptPath  = $ScriptPath
        CacheFile   = $cacheResult.CacheFile
        Status      = $status
        Message     = $message
        CacheExists = $cacheExists
        ExitCode    = $cacheResult.ExitCode
        StdOut      = $cacheResult.StdOut
        StdErr      = $cacheResult.StdErr
    }

    return [pscustomobject]@{
        Result  = $resultRecord
        Updated = $updated
        Failed  = $failed
        Warning = $warningMessage
    }
}
