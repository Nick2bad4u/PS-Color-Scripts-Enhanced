function Get-PowerShellExecutable {
    if (-not $script:PowerShellExecutable) {
        $candidate = Get-Command -Name pwsh -ErrorAction SilentlyContinue
        if ($candidate -and $candidate.Path) {
            $script:PowerShellExecutable = $candidate.Path
        }
        else {
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
