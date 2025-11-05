function Invoke-ColorScriptsStartup {
    try {
        $autoShowOverride = $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT
        $overrideEnabled = $false
        if ($autoShowOverride) {
            $overrideEnabled = $autoShowOverride -match '^(1|true|yes)$'
            if (-not $overrideEnabled) {
                return
            }
        }

        $outputRedirected = $false
        try {
            $outputRedirected = Test-ConsoleOutputRedirected
        }
        catch {
            $outputRedirected = $false
        }

        if (-not $overrideEnabled) {
            if ($env:CI -eq 'true' -or $env:GITHUB_ACTIONS -eq 'true') {
                return
            }

            if ($Host.Name -eq 'ServerRemoteHost') {
                return
            }

            if ($outputRedirected) {
                return
            }
        }
        elseif ($outputRedirected) {
            Write-Verbose 'Console output is redirected; skipping auto-show despite override.'
            return
        }

        $configRoot = $null
        try {
            $configRoot = Get-ColorScriptsConfigurationRoot
        }
        catch {
            Write-Verbose "Unable to locate configuration root: $($_.Exception.Message)"
            if (-not $overrideEnabled) {
                return
            }
        }

        $configPath = if ($configRoot) { Join-Path -Path $configRoot -ChildPath 'config.json' } else { $null }
        if (-not $overrideEnabled -and $configPath -and -not (Test-Path -LiteralPath $configPath)) {
            return
        }

        $configuration = Get-ConfigurationDataInternal
        if (-not $configuration.Startup.AutoShowOnImport -and -not $overrideEnabled) {
            return
        }

        $defaultScript = if ($configuration.Startup.ContainsKey('DefaultScript')) { $configuration.Startup.DefaultScript } else { $null }

        if (-not [string]::IsNullOrWhiteSpace($defaultScript)) {
            Show-ColorScript -Name $defaultScript -ErrorAction SilentlyContinue | Out-Null
        }
        else {
            Show-ColorScript -ErrorAction SilentlyContinue | Out-Null
        }
    }
    catch {
        Write-Verbose "Auto-show on import skipped: $($_.Exception.Message)"
    }
}
