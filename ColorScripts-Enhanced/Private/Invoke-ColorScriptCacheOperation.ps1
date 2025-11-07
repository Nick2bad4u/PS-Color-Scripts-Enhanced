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

        if ($cacheResult.StdErr) {
            $message = $cacheResult.StdErr
        }
        elseif ($null -ne $cacheResult.ExitCode) {
            $message = $script:Messages.ScriptExitedWithCode -f $cacheResult.ExitCode
        }
        else {
            $message = 'Cache build failed.'
        }

        $warningMessage = "Failed to cache ${ScriptName}: $message"
        $cacheExists = $false
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
