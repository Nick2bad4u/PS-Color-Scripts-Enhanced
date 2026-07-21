function Get-PowerShellExecutable {
    if (-not $script:PowerShellExecutable) {
        # Prefer modern PowerShell when it is available. Windows PowerShell serializes host and
        # information records as CLIXML when its native streams are redirected, which corrupts
        # captured colorscript output. The current process remains the compatibility fallback.
        $candidate = Get-Command -Name pwsh -ErrorAction SilentlyContinue
        if ($candidate -and $candidate.Path) {
            $script:PowerShellExecutable = $candidate.Path
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
