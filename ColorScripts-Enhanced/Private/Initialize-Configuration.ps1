function Initialize-Configuration {
    if ($script:ConfigurationInitialized -and $script:ConfigurationData) {
        return
    }

    Invoke-ModuleSynchronized $script:ConfigurationSyncRoot {
        if ($script:ConfigurationInitialized -and $script:ConfigurationData) {
            return
        }

        $configRoot = Get-ColorScriptsConfigurationRoot
        $script:ConfigurationPath = Join-Path -Path $configRoot -ChildPath 'config.json'

        $existing = $null
        $raw = $null
        $forceSave = $false
        $configExists = Test-Path -LiteralPath $script:ConfigurationPath

        if ($configExists) {
            try {
                $raw = Get-Content -LiteralPath $script:ConfigurationPath -Raw -ErrorAction Stop
                if (-not [string]::IsNullOrWhiteSpace($raw)) {
                    $existing = ConvertFrom-JsonToHashtable -InputObject $raw
                }
                else {
                    $raw = $null
                }
            }
            catch {
                Write-Warning ($script:Messages.FailedToParseConfigurationFile -f $script:ConfigurationPath, $_.Exception.Message)
                $forceSave = $true
                $raw = $null
            }
        }

        $script:ConfigurationData = Merge-ColorScriptConfiguration $script:DefaultConfiguration $existing

        if ($forceSave -or -not $configExists) {
            Save-ColorScriptConfiguration -Configuration $script:ConfigurationData -ExistingContent $raw -Force:$forceSave
        }

        $script:ConfigurationInitialized = $true
    }
}
