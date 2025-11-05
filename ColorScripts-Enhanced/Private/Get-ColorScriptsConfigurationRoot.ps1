function Get-ColorScriptsConfigurationRoot {
    if ($script:ConfigurationRoot) {
        return $script:ConfigurationRoot
    }

    $candidates = @()

    $overrideRoot = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
    if (-not [string]::IsNullOrWhiteSpace($overrideRoot)) {
        $candidates += $overrideRoot
    }

    if ($script:IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
        if ($env:APPDATA) {
            $candidates += (Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced')
        }
    }
    elseif ($script:IsMacOS) {
        $macBase = Join-Path -Path $HOME -ChildPath 'Library'
        $macBase = Join-Path -Path $macBase -ChildPath 'Application Support'
        $candidates += (Join-Path -Path $macBase -ChildPath 'ColorScripts-Enhanced')
    }
    else {
        $xdgConfig = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path -Path $HOME -ChildPath '.config' }
        if (-not [string]::IsNullOrWhiteSpace($xdgConfig)) {
            $candidates += (Join-Path -Path $xdgConfig -ChildPath 'ColorScripts-Enhanced')
        }
    }

    if ($candidates.Count -eq 0) {
        $candidates = @([System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), 'ColorScripts-Enhanced'))
    }

    $candidates = @($candidates | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

    $createDirectoryAction = {
        param($path)

        if ($script:CreateDirectoryDelegate) {
            $null = & $script:CreateDirectoryDelegate $path
        }
        else {
            New-Item -ItemType Directory -Path $path -Force -ErrorAction Stop | Out-Null
        }
    }

    $onCreateFailure = {
        param($target, $errorRecord)
        $message = if ($errorRecord -and $errorRecord.Exception) { $errorRecord.Exception.Message } elseif ($errorRecord) { $errorRecord.ToString() } else { 'unknown reason' }
        Write-Verbose ("Unable to prepare configuration directory '{0}': {1}" -f $target, $message)
    }

    $resolvedRoot = Resolve-PreferredDirectoryCandidate -CandidatePaths $candidates -CreateDirectory $createDirectoryAction -OnCreateFailure $onCreateFailure

    if ($resolvedRoot) {
        $script:ConfigurationRoot = $resolvedRoot
        return $script:ConfigurationRoot
    }

    Invoke-ColorScriptError -Message $script:Messages.UnableToDetermineConfigurationDirectory -ErrorId 'ColorScriptsEnhanced.ConfigurationRootUnavailable' -Category ([System.Management.Automation.ErrorCategory]::ResourceUnavailable)
}
