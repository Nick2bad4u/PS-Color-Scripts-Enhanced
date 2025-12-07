function Get-PokemonScriptNameSet {
    $metadataPath = $script:MetadataPath
    if (-not $metadataPath -or -not (Test-Path -LiteralPath $metadataPath)) {
        return $null
    }

    $timestamp = $null
    try {
        $timestamp = (Get-Item -LiteralPath $metadataPath -ErrorAction Stop).LastWriteTimeUtc
    }
    catch {
        $timestamp = $null
    }

    if ($script:PokemonNameSetCache -and $script:PokemonNameSetCacheStamp -and $timestamp -eq $script:PokemonNameSetCacheStamp) {
        return $script:PokemonNameSetCache
    }

    $nameSet = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
    $importParams = @{ Path = $metadataPath }
    $command = $null
    try {
        $command = Get-Command -Name 'Import-PowerShellDataFile' -ErrorAction SilentlyContinue
    }
    catch {
        $command = $null
    }

    if ($command -and $command.Parameters.ContainsKey('SkipLimitCheck')) {
        $importParams['SkipLimitCheck'] = $true
    }

    try {
        $metadata = Import-PowerShellDataFile @importParams
    }
    catch {
        return $null
    }

    if ($metadata -and $metadata.Categories -is [hashtable]) {
        foreach ($category in @('Pokemon', 'ShinyPokemon')) {
            if ($metadata.Categories.ContainsKey($category)) {
                foreach ($entry in @($metadata.Categories[$category])) {
                    if (-not [string]::IsNullOrWhiteSpace($entry)) {
                        [void]$nameSet.Add([string]$entry)
                    }
                }
            }
        }
    }

    $script:PokemonNameSetCache = $nameSet
    $script:PokemonNameSetCacheStamp = $timestamp
    return $nameSet
}
