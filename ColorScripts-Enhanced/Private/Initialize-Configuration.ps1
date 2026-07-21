function Initialize-Configuration {
    if ($script:ConfigurationInitialized -and $script:ConfigurationData) {
        return
    }

    Invoke-ModuleSynchronized $script:ConfigurationSyncRoot {
        if ($script:ConfigurationInitialized -and $script:ConfigurationData) {
            return
        }

        $configRoot = Get-ColorScriptsConfigurationRoot -NoCreate
        $script:ConfigurationPath = if ($configRoot) {
            Join-Path -Path $configRoot -ChildPath 'config.json'
        }
        else {
            $null
        }

        $existing = $null
        $configExists = $script:ConfigurationPath -and (Test-Path -LiteralPath $script:ConfigurationPath)

        if ($configExists) {
            try {
                $raw = Get-Content -LiteralPath $script:ConfigurationPath -Raw -ErrorAction Stop
                if (-not [string]::IsNullOrWhiteSpace($raw)) {
                    $existing = ConvertFrom-JsonToHashtable -InputObject $raw
                }
            }
            catch {
                Write-Warning ($script:Messages.FailedToParseConfigurationFile -f $script:ConfigurationPath, $_.Exception.Message)
            }
        }

        $script:ConfigurationData = Merge-ColorScriptConfiguration $script:DefaultConfiguration $existing
        $script:ConfigurationInitialized = $true
    }
}
