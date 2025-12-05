<#
    NOTE: This file is intentionally a no-op stub.

    Earlier versions experimented with a custom Get-PokemonScriptNameSet
    helper to parse ScriptMetadata.psd1 directly for Pokémon names. The
    current implementation no longer uses this helper; Pokémon scripts are
    handled via normal metadata categories using Import-PowerShellDataFile
    with -SkipLimitCheck.

    The file is retained (empty) only to avoid breaking any external tooling
    that might scan the Private folder for file presence.
#>
