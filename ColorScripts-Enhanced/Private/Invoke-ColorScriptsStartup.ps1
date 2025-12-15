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
            # Import-time optimization: when startup is NOT forced, do not create the configuration
            # directory just to determine whether startup is enabled.
            if ($overrideEnabled) {
                $configRoot = Get-ColorScriptsConfigurationRoot
            }
            else {
                $configRoot = Get-ColorScriptsConfigurationRoot -NoCreate
            }
        }
        catch {
            Write-Verbose "Unable to locate configuration root: $($_.Exception.Message)"
            if (-not $overrideEnabled) {
                return
            }

            $configRoot = $null
        }

        $configPath = if ($configRoot) { Join-Path -Path $configRoot -ChildPath 'config.json' } else { $null }

        if (-not $overrideEnabled) {
            if (-not $configPath -or -not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
                return
            }
        }

        $configuration = $null
        if ($overrideEnabled) {
            # Preserve legacy behavior: override forces startup and should still honor DefaultScript
            # from the configuration provider (even if config.json is not present).
            try {
                $configuration = Get-ConfigurationDataInternal
            }
            catch {
                $configuration = $script:DefaultConfiguration
            }
        }
        elseif ($configPath -and (Test-Path -LiteralPath $configPath -PathType Leaf)) {
            $configuration = Get-ConfigurationDataInternal
        }
        else {
            $configuration = $script:DefaultConfiguration
        }

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
