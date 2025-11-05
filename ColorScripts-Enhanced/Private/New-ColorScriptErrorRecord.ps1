function New-ColorScriptErrorRecord {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [Parameter()]
        [string]$ErrorId = 'ColorScriptsEnhanced.RuntimeError',

        [Parameter()]
        [System.Management.Automation.ErrorCategory]$Category = [System.Management.Automation.ErrorCategory]::InvalidOperation,

        [Parameter()]
        [object]$TargetObject,

        [Parameter()]
        [System.Exception]$Exception,

        [Parameter()]
        [string]$RecommendedAction
    )

    if (-not [string]::IsNullOrWhiteSpace($Message)) {
        $effectiveMessage = $Message
    }
    elseif ($Exception) {
        $effectiveMessage = $Exception.Message
    }
    else {
        $effectiveMessage = 'An error occurred within ColorScripts-Enhanced.'
    }

    if (-not $Exception) {
        $Exception = [System.Management.Automation.RuntimeException]::new($effectiveMessage)
    }
    elseif ($effectiveMessage -and $Exception.Message -ne $effectiveMessage) {
        $Exception = [System.Management.Automation.RuntimeException]::new($effectiveMessage, $Exception)
    }

    $errorRecord = [System.Management.Automation.ErrorRecord]::new($Exception, $ErrorId, $Category, $TargetObject)

    if (-not $errorRecord.ErrorDetails) {
        $errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($effectiveMessage)
    }
    elseif ($effectiveMessage -and [string]::IsNullOrWhiteSpace($errorRecord.ErrorDetails.Message)) {
        $errorRecord.ErrorDetails.Message = $effectiveMessage
    }

    if ($RecommendedAction) {
        if (-not $errorRecord.ErrorDetails) {
            $errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($effectiveMessage)
        }
        $errorRecord.ErrorDetails.RecommendedAction = $RecommendedAction
    }

    return $errorRecord
}
