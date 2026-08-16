function Get-CurrentPowerShellExecutable {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $process = & $script:GetCurrentProcessDelegate
        $module = if ($process) { $process.MainModule } else { $null }
        if ($module -and $module.FileName) {
            return $module.FileName
        }
        throw [System.InvalidOperationException]::new('Process module unavailable.')
    }
    catch {
        return [System.Environment]::GetCommandLineArgs()[0]
    }
}

function Get-PowerShellExecutable {
    if ($script:PowerShellExecutable) {
        return $script:PowerShellExecutable
    }

    # Prefer modern PowerShell when it is available. Windows PowerShell serializes host and
    # information records as CLIXML when its native streams are redirected, which corrupts
    # captured colorscript output. The current process remains the compatibility fallback.
    $candidate = Get-Command -Name pwsh -ErrorAction SilentlyContinue
    if ($candidate -and $candidate.Path) {
        $script:PowerShellExecutable = $candidate.Path
    }
    else {
        $script:PowerShellExecutable = Get-CurrentPowerShellExecutable
    }

    return $script:PowerShellExecutable
}
