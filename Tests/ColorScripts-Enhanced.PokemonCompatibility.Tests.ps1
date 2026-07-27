Describe 'Pokemon compatibility parameters' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    It 'retains the legacy public parameters for one compatibility release' {
        $profileParameters = (Get-Command Add-ColorScriptProfile -ErrorAction Stop).Parameters
        $cacheParameters = (Get-Command New-ColorScriptCache -ErrorAction Stop).Parameters

        $profileParameters.ContainsKey('IncludePokemon') | Should -BeTrue
        $profileParameters.ContainsKey('SkipPokemonPrompt') | Should -BeTrue
        $profileParameters.ContainsKey('PokemonPromptResponse') | Should -BeTrue
        $cacheParameters.ContainsKey('IncludePokemon') | Should -BeTrue
    }

    It 'ignores profile switches and prompt overrides without prompting' {
        $profilePath = Join-Path -Path $TestDrive -ChildPath 'compatibility-profile.ps1'
        $previousEnvironmentResponse = $env:COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE
        $hadGlobalResponse = Test-Path -LiteralPath 'Variable:\global:ColorScriptsEnhancedPokemonPromptResponse'
        $previousGlobalResponse = if ($hadGlobalResponse) {
            Get-Variable -Name ColorScriptsEnhancedPokemonPromptResponse -Scope Global -ValueOnly
        }
        else {
            $null
        }
        Set-Variable -Name ColorScriptsEnhancedPokemonPromptResponse -Scope Global -Value 'N' -Force
        $env:COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE = 'N'

        try {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ profilePath = $profilePath } {
                param($profilePath)

                Mock -CommandName Read-Host -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'The obsolete Pokemon prompt must not run.'
                }

                $warnings = @()
                $profileResult = Add-ColorScriptProfile `
                    -ProfilePath $profilePath `
                    -AutoShow `
                    -IncludePokemon `
                    -SkipPokemonPrompt `
                    -PokemonPromptResponse N `
                    -SkipCacheBuild `
                    -Confirm:$false `
                    -WarningVariable warnings

                [pscustomobject]@{
                    ProfileResult = $profileResult
                    Warnings      = @($warnings)
                }
            }

            $content = Get-Content -LiteralPath $profilePath -Raw
            $content | Should -Match '(?m)^\s*Show-ColorScript\s*$'
            $content | Should -Not -Match 'IncludePokemon'
            $result.ProfileResult.IncludePokemon | Should -BeTrue
            $result.Warnings | Should -BeNullOrEmpty
            Should-Invoke -CommandName Read-Host -ModuleName ColorScripts-Enhanced -Times 0
        }
        finally {
            $env:COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE = $previousEnvironmentResponse
            if ($hadGlobalResponse) {
                Set-Variable -Name ColorScriptsEnhancedPokemonPromptResponse -Scope Global -Value $previousGlobalResponse -Force
            }
            else {
                Remove-Variable -Name ColorScriptsEnhancedPokemonPromptResponse -Scope Global -ErrorAction SilentlyContinue
            }
        }
    }

    It 'removes the obsolete switch when forcing a managed profile refresh' {
        $profilePath = Join-Path -Path $TestDrive -ChildPath 'managed-profile.ps1'
        $existingContent = @(
            '# BEGIN ColorScripts-Enhanced managed block'
            '# Added by ColorScripts-Enhanced on 2026-01-01 00:00:00Z'
            'Import-Module ColorScripts-Enhanced'
            'try {'
            '    Show-ColorScript -IncludePokemon'
            '}'
            'catch {'
            '    Write-Warning "ColorScripts-Enhanced startup snippet failed: $($_.Exception.Message)"'
            '}'
            '# END ColorScripts-Enhanced managed block'
            ''
        ) -join [Environment]::NewLine
        [System.IO.File]::WriteAllText($profilePath, $existingContent, (New-Object System.Text.UTF8Encoding($false)))

        $result = Add-ColorScriptProfile -ProfilePath $profilePath -AutoShow -Force -SkipCacheBuild -Confirm:$false

        $content = Get-Content -LiteralPath $profilePath -Raw
        ([regex]::Matches($content, '# BEGIN ColorScripts-Enhanced managed block')).Count | Should -Be 1
        $content | Should -Match '(?m)^\s*Show-ColorScript\s*$'
        $content | Should -Not -Match 'IncludePokemon'
        $result.IncludePokemon | Should -BeTrue
    }

    It 'uses the same cache policy with and without the compatibility switch' {
        $withoutCompatibilitySwitch = @(
            New-ColorScriptCache -All -Force -PassThru -Quiet -WhatIf
        )
        $withCompatibilitySwitch = @(
            New-ColorScriptCache -All -Force -PassThru -Quiet -IncludePokemon -WhatIf
        )

        $withoutCompatibilitySwitch.Name | Should -Be $withCompatibilitySwitch.Name
        $withoutCompatibilitySwitch.Status | Should -Be $withCompatibilitySwitch.Status
        $withoutCompatibilitySwitch | Should -HaveCount $withCompatibilitySwitch.Count
    }
}
