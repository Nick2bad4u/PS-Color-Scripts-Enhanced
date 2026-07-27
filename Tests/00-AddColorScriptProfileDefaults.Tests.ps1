Describe 'Add-ColorScriptProfile test defaults' -Tag 'Setup' {
    BeforeAll {
        $PSDefaultParameterValues['Add-ColorScriptProfile:SkipCacheBuild'] = $true

        $env:COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD = '1'

        Set-Variable -Name ColorScriptsEnhancedSkipCacheBuild -Scope Global -Value $true -Force
    }

    AfterAll {
        Remove-Variable -Name ColorScriptsEnhancedSkipCacheBuild -Scope Global -ErrorAction SilentlyContinue
    }

    It 'establishes Add-ColorScriptProfile defaults for tests' {
        $PSDefaultParameterValues.ContainsKey('Add-ColorScriptProfile:SkipCacheBuild') | Should -BeTrue
    }
}
