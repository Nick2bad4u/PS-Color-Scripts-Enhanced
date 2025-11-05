function Save-ColorScriptConfiguration {
    param(
        [hashtable]$Configuration,
        [string]$ExistingContent,
        [switch]$Force
    )

    $configRoot = Get-ColorScriptsConfigurationRoot
    if (-not $configRoot) {
        Invoke-ColorScriptError -Message $script:Messages.ConfigurationRootCouldNotBeResolved -ErrorId 'ColorScriptsEnhanced.ConfigurationRootNotResolved' -Category ([System.Management.Automation.ErrorCategory]::ResourceUnavailable)
    }

    $script:ConfigurationPath = Join-Path -Path $configRoot -ChildPath 'config.json'
    $json = $Configuration | ConvertTo-Json -Depth 6
    $normalizedNew = $json.TrimEnd("`r", "`n")

    if (-not $Force) {
        if (-not $ExistingContent -and (Test-Path -LiteralPath $script:ConfigurationPath)) {
            try {
                $ExistingContent = Get-Content -LiteralPath $script:ConfigurationPath -Raw -ErrorAction Stop
            }
            catch {
                $ExistingContent = $null
            }
        }

        if ($ExistingContent) {
            $normalizedExisting = $ExistingContent.TrimEnd("`r", "`n")
            if ($normalizedExisting -eq $normalizedNew) {
                return
            }
        }
        elseif (-not (Test-Path -LiteralPath $script:ConfigurationPath)) {
        }
        else {
        }
    }

    Set-Content -Path $script:ConfigurationPath -Value ($json + [Environment]::NewLine) -Encoding UTF8
}
