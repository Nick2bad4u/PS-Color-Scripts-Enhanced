$result = Invoke-Pester -Path "./Tests/ColorScripts-Enhanced.CoverageExpansion.Tests.ps1" -PassThru -Output None
Write-Host "Failed: $($result.FailedCount)"
foreach ($failed in $result.Failed) {
    Write-Host '---'
    Write-Host $failed.Name
    Write-Host $failed.FailureMessage
    if ($failed.ErrorRecord) {
        Write-Host $failed.ErrorRecord.Exception.GetType().FullName
        Write-Host $failed.ErrorRecord.Exception.Message
        Write-Host $failed.ErrorRecord.InvocationInfo.PositionMessage
        Write-Host $failed.ErrorRecord.ScriptStackTrace
    }
}
