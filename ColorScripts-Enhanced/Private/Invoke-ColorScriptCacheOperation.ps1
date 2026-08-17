function ConvertTo-CacheOperationInitializationFailure {
    param(
        [Parameter(Mandatory)][string]$ScriptName,
        [Parameter(Mandatory)][string]$ScriptPath,
        [AllowNull()][System.Exception]$Exception
    )

    $detail = if ($Exception) { $Exception.Message } else { $null }
    $messageTemplate = if ($script:Messages -and $script:Messages.ContainsKey('CacheOperationInitializationFailed')) {
        $script:Messages.CacheOperationInitializationFailed
    }
    else {
        'Unable to initialize the cache directory: {0}'
    }
    $detailValue = if ([string]::IsNullOrWhiteSpace($detail)) { 'n/a' } else { $detail }
    $message = $messageTemplate -f $detailValue

    return [pscustomobject]@{
        Result  = [pscustomobject]@{
            Name        = $ScriptName
            ScriptPath  = $ScriptPath
            CacheFile   = $null
            Status      = 'Failed'
            Message     = $message
            CacheExists = $false
            ExitCode    = $null
            StdOut      = ''
            StdErr      = $detail
        }
        Updated = 0
        Failed  = 1
        Warning = $message
    }
}

function Invoke-ColorScriptCacheBuild {
    param(
        [Parameter(Mandatory)][string]$ScriptName,
        [Parameter(Mandatory)][string]$ScriptPath,
        [switch]$Force
    )

    $buildOperation = {
        param($lockedScriptName, $lockedScriptPath, $forceRebuild)

        if (-not $forceRebuild) {
            $currentEntry = Get-CachedOutput -ScriptPath $lockedScriptPath
            if ($currentEntry.Available) {
                return [pscustomobject]@{
                    ScriptName          = $lockedScriptName
                    CacheFile           = $currentEntry.CacheFile
                    CacheRequired       = $true
                    CacheCreated        = $false
                    CacheAlreadyCurrent = $true
                    Success             = $true
                    ExitCode            = 0
                    StdOut              = $currentEntry.Content
                    StdErr              = ''
                }
            }
        }

        Build-ScriptCache -ScriptPath $lockedScriptPath -LockAlreadyHeld
    }

    try {
        return Invoke-WithColorScriptCacheEntryLock -CacheRoot $script:CacheDir -ScriptName $ScriptName -Operation $buildOperation -ArgumentList @($ScriptName, $ScriptPath, $Force.IsPresent)
    }
    catch {
        if (-not $script:CacheDir) {
            Initialize-CacheDirectory
        }

        return [pscustomobject]@{
            ScriptName = $ScriptName
            CacheFile  = Join-Path -Path $script:CacheDir -ChildPath ("{0}.cache" -f $ScriptName)
            Success    = $false
            ExitCode   = $null
            StdOut     = ''
            StdErr     = $_.Exception.Message
        }
    }
}

function Get-CacheOperationFailureDetail {
    param(
        [Parameter(Mandatory)]
        [object]$CacheResult
    )

    if ($CacheResult.StdErr) {
        return $CacheResult.StdErr
    }

    if ($null -ne $CacheResult.ExitCode) {
        if ($script:Messages -and $script:Messages.ContainsKey('ScriptExitedWithCode')) {
            return $script:Messages.ScriptExitedWithCode -f $CacheResult.ExitCode
        }
        return "Script exited with code $($CacheResult.ExitCode)."
    }

    if ($script:Messages -and $script:Messages.ContainsKey('CacheBuildGenericFailure')) {
        return $script:Messages.CacheBuildGenericFailure
    }

    return 'Cache build failed.'
}

function ConvertTo-CacheOperationFailureStatus {
    param(
        [Parameter(Mandatory)][string]$ScriptName,
        [Parameter(Mandatory)][object]$CacheResult
    )

    $detailMessage = Get-CacheOperationFailureDetail -CacheResult $CacheResult
    $messageTemplate = if ($script:Messages -and $script:Messages.ContainsKey('CacheBuildFailedForScript')) {
        $script:Messages.CacheBuildFailedForScript
    }
    else {
        'Cache build failed for {0}: {1}'
    }
    $warningTemplate = if ($script:Messages -and $script:Messages.ContainsKey('CacheOperationWarning')) {
        $script:Messages.CacheOperationWarning
    }
    else {
        "Failed to cache '{0}': {1}"
    }

    if (-not $CacheResult.CacheFile) {
        $CacheResult.CacheFile = Join-Path -Path $script:CacheDir -ChildPath ("{0}.cache" -f $ScriptName)
    }

    $message = $messageTemplate -f $ScriptName, $detailMessage
    $warning = $warningTemplate -f $ScriptName, $detailMessage
    if (-not $warning) {
        $warning = $message
    }

    return [pscustomobject]@{
        Status      = 'Failed'
        Message     = $message
        CacheExists = $false
        Updated     = 0
        Failed      = 1
        Warning     = $warning
    }
}

function ConvertTo-CacheOperationStatus {
    param(
        [Parameter(Mandatory)][string]$ScriptName,
        [Parameter(Mandatory)][object]$CacheResult
    )

    if ($CacheResult.PSObject.Properties['CacheAlreadyCurrent'] -and $CacheResult.CacheAlreadyCurrent) {
        return [pscustomobject]@{
            Status = 'SkippedUpToDate'; Message = $script:Messages.StatusSkippedUpToDate
            CacheExists = $true; Updated = 0; Failed = 0; Warning = $null
        }
    }

    if ($CacheResult.PSObject.Properties['CacheRequired'] -and -not $CacheResult.CacheRequired) {
        $message = if ($script:Messages -and $script:Messages.ContainsKey('StatusSkippedNotRequired')) {
            $script:Messages.StatusSkippedNotRequired
        }
        else {
            'Skipped (caching not required)'
        }
        return [pscustomobject]@{
            Status = 'SkippedNotRequired'; Message = $message
            CacheExists = $false; Updated = 0; Failed = 0; Warning = $null
        }
    }

    if ($CacheResult.Success) {
        return [pscustomobject]@{
            Status = 'Updated'; Message = $script:Messages.StatusCached
            CacheExists = $true; Updated = 1; Failed = 0; Warning = $null
        }
    }

    return ConvertTo-CacheOperationFailureStatus -ScriptName $ScriptName -CacheResult $CacheResult
}

function ConvertTo-CacheOperationResult {
    param(
        [Parameter(Mandatory)][string]$ScriptName,
        [Parameter(Mandatory)][string]$ScriptPath,
        [Parameter(Mandatory)][object]$CacheResult,
        [Parameter(Mandatory)][object]$Status
    )

    $name = if ($CacheResult.ScriptName) { $CacheResult.ScriptName } else { $ScriptName }
    return [pscustomobject]@{
        Result  = [pscustomobject]@{
            Name        = $name
            ScriptPath  = $ScriptPath
            CacheFile   = $CacheResult.CacheFile
            Status      = $Status.Status
            Message     = $Status.Message
            CacheExists = $Status.CacheExists
            ExitCode    = $CacheResult.ExitCode
            StdOut      = $CacheResult.StdOut
            StdErr      = $CacheResult.StdErr
        }
        Updated = $Status.Updated
        Failed  = $Status.Failed
        Warning = $Status.Warning
    }
}

function Invoke-ColorScriptCacheOperation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ScriptName,
        [Parameter(Mandatory)][string]$ScriptPath,
        [switch]$Force
    )

    try {
        Initialize-CacheDirectory
        $initializationError = $null
    }
    catch {
        $initializationError = $_.Exception
    }

    if (-not $script:CacheDir) {
        return ConvertTo-CacheOperationInitializationFailure -ScriptName $ScriptName -ScriptPath $ScriptPath -Exception $initializationError
    }

    $cacheResult = Invoke-ColorScriptCacheBuild -ScriptName $ScriptName -ScriptPath $ScriptPath -Force:$Force
    $status = ConvertTo-CacheOperationStatus -ScriptName $ScriptName -CacheResult $cacheResult
    return ConvertTo-CacheOperationResult -ScriptName $ScriptName -ScriptPath $ScriptPath -CacheResult $cacheResult -Status $status
}
