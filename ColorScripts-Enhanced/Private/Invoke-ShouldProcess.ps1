function Invoke-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [System.Management.Automation.PSCmdlet]$Cmdlet,
        [object]$Target,
        [string]$Action
    )

    if ($script:ShouldProcessEvaluator -is [scriptblock]) {
        return & $script:ShouldProcessEvaluator $Cmdlet $Target $Action
    }

    if ($script:ShouldProcessOverride -is [scriptblock]) {
        return & $script:ShouldProcessOverride $Cmdlet $Target $Action
    }

    return $Cmdlet.ShouldProcess($Target, $Action)
}
