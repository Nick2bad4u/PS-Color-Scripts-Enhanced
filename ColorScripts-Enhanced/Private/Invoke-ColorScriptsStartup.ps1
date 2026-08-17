function Get-ColorScriptStartupOverride {
    $value = $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT
    return [pscustomobject]@{
        Requested = -not [string]::IsNullOrEmpty($value)
        Enabled   = -not [string]::IsNullOrEmpty($value) -and $value -match '^(1|true|yes)$'
    }
}

function Test-ColorScriptStartupOutputRedirected {
    try {
        return Test-ConsoleOutputRedirected
    }
    catch {
        return $false
    }
}

function Test-ColorScriptStartupEnvironment {
    param(
        [Parameter(Mandatory)]
        [bool]$OverrideEnabled,

        [Parameter(Mandatory)]
        [bool]$OutputRedirected
    )

    if ($OverrideEnabled) {
        if ($OutputRedirected) {
            Write-Verbose 'Console output is redirected; skipping auto-show despite override.'
            return $false
        }

        return $true
    }

    if ($env:CI -eq 'true' -or $env:GITHUB_ACTIONS -eq 'true') {
        return $false
    }

    if ($Host.Name -eq 'ServerRemoteHost') {
        return $false
    }

    return -not $OutputRedirected
}

function Get-ColorScriptStartupConfigRoot {
    param(
        [Parameter(Mandatory)]
        [bool]$OverrideEnabled
    )

    try {
        if ($OverrideEnabled) {
            return Get-ColorScriptsConfigurationRoot
        }

        return Get-ColorScriptsConfigurationRoot -NoCreate
    }
    catch {
        Write-Verbose "Unable to locate configuration root: $($_.Exception.Message)"
        return $null
    }
}

function Get-ColorScriptStartupConfiguration {
    param(
        [Parameter(Mandatory)]
        [bool]$OverrideEnabled,

        [AllowNull()]
        [string]$ConfigPath
    )

    if ($OverrideEnabled) {
        try {
            return Get-ConfigurationDataInternal
        }
        catch {
            return $script:DefaultConfiguration
        }
    }

    if ($ConfigPath -and (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) {
        return Get-ConfigurationDataInternal
    }

    return $script:DefaultConfiguration
}

function Show-ColorScriptStartupSelection {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary]$Configuration
    )

    $defaultScript = if ($Configuration.Startup.ContainsKey('DefaultScript')) {
        $Configuration.Startup.DefaultScript
    }
    else {
        $null
    }

    if ([string]::IsNullOrWhiteSpace($defaultScript)) {
        Show-ColorScript -ErrorAction SilentlyContinue | Out-Null
        return
    }

    Show-ColorScript -Name $defaultScript -ErrorAction SilentlyContinue | Out-Null
}

function Invoke-ColorScriptsStartup {
    try {
        $override = Get-ColorScriptStartupOverride
        if ($override.Requested -and -not $override.Enabled) {
            return
        }

        $outputRedirected = Test-ColorScriptStartupOutputRedirected
        if (-not (Test-ColorScriptStartupEnvironment -OverrideEnabled $override.Enabled -OutputRedirected $outputRedirected)) {
            return
        }

        $configRoot = Get-ColorScriptStartupConfigRoot -OverrideEnabled $override.Enabled
        $configPath = if ($configRoot) {
            Join-Path -Path $configRoot -ChildPath 'config.json'
        }
        else {
            $null
        }

        if (-not $override.Enabled -and (-not $configPath -or -not (Test-Path -LiteralPath $configPath -PathType Leaf))) {
            return
        }

        $configuration = Get-ColorScriptStartupConfiguration -OverrideEnabled $override.Enabled -ConfigPath $configPath
        if (-not $configuration.Startup.AutoShowOnImport -and -not $override.Enabled) {
            return
        }

        Show-ColorScriptStartupSelection -Configuration $configuration
    }
    catch {
        Write-Verbose "Auto-show on import skipped: $($_.Exception.Message)"
    }
}
