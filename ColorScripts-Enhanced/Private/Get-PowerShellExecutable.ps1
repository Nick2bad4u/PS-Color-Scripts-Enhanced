function Get-PowerShellExecutable {
    if (-not $script:PowerShellExecutable) {
        # Windows PowerShell 5.1 can coexist with pwsh. Prefer its current executable so the
        # module's child renderer preserves the engine semantics of the caller.
        if ($PSVersionTable.PSVersion.Major -le 5) {
            try {
                $process = & $script:GetCurrentProcessDelegate
                $module = if ($process) { $process.MainModule } else { $null }
                if ($module -and $module.FileName) {
                    $script:PowerShellExecutable = $module.FileName
                }
            }
            catch {
                Write-Verbose ("Unable to resolve the current Windows PowerShell executable: {0}" -f $_.Exception.Message)
            }
        }

        if (-not $script:PowerShellExecutable) {
            $candidate = Get-Command -Name pwsh -ErrorAction SilentlyContinue
            if ($candidate -and $candidate.Path) {
                $script:PowerShellExecutable = $candidate.Path
            }
        }

        if (-not $script:PowerShellExecutable) {
            try {
                $process = & $script:GetCurrentProcessDelegate
                $module = if ($process) { $process.MainModule } else { $null }
                if ($module -and $module.FileName) {
                    $script:PowerShellExecutable = $module.FileName
                }
                else {
                    throw [System.InvalidOperationException]::new('Process module unavailable.')
                }
            }
            catch {
                $script:PowerShellExecutable = [System.Environment]::GetCommandLineArgs()[0]
            }
        }
    }

    return $script:PowerShellExecutable
}
