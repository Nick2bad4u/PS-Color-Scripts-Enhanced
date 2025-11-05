function Invoke-ColorScriptError {
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
        [string]$RecommendedAction,

        [Parameter()]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    $errorRecord = New-ColorScriptErrorRecord -Message $Message -ErrorId $ErrorId -Category $Category -TargetObject $TargetObject -Exception $Exception -RecommendedAction $RecommendedAction

    if ($Cmdlet) {
        $Cmdlet.ThrowTerminatingError($errorRecord)
    }
    else {
        throw $errorRecord
    }
}
