Describe 'Add-ColorScriptProfile test defaults' -Tag 'Setup' {
    BeforeAll {
        $PSDefaultParameterValues['Add-ColorScriptProfile:SkipPokemonPrompt'] = $true
        $PSDefaultParameterValues['Add-ColorScriptProfile:SkipCacheBuild'] = $true
        $PSDefaultParameterValues['Add-ColorScriptProfile:PokemonPromptResponse'] = 'N'

        $env:COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE = 'N'
        $env:COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD = '1'

        Set-Variable -Name ColorScriptsEnhancedSkipCacheBuild -Scope Global -Value $true -Force
        Set-Variable -Name ColorScriptsEnhancedPokemonPromptResponse -Scope Global -Value 'N' -Force
    }

    AfterAll {
        Remove-Variable -Name ColorScriptsEnhancedSkipCacheBuild -Scope Global -ErrorAction SilentlyContinue
        Remove-Variable -Name ColorScriptsEnhancedPokemonPromptResponse -Scope Global -ErrorAction SilentlyContinue
    }

    It 'establishes Add-ColorScriptProfile defaults for tests' {
        $PSDefaultParameterValues.ContainsKey('Add-ColorScriptProfile:SkipCacheBuild') | Should -BeTrue
    }
}
