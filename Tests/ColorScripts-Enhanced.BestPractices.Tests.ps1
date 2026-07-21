#Requires -Version 5.1

Describe 'PowerShell best-practice regressions' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleManifest = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
        $script:OriginalConfigRoot = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
        $script:OriginalCacheRoot = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
    }

    BeforeEach {
        Remove-Module -Name ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
        $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = Join-Path -Path $TestDrive -ChildPath ([guid]::NewGuid().ToString('N') + '-config')
        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = Join-Path -Path $TestDrive -ChildPath ([guid]::NewGuid().ToString('N') + '-cache')
        Import-Module -Name $script:ModuleManifest -Force -ErrorAction Stop
    }

    AfterAll {
        Remove-Module -Name ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
        $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $script:OriginalConfigRoot
        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $script:OriginalCacheRoot
    }

    It 'does not create configuration or cache directories from a getter' {
        $configuration = Get-ColorScriptConfiguration

        $configuration.Cache.EffectivePath | Should -Not -BeNullOrEmpty
        Test-Path -LiteralPath $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT | Should -BeFalse
        Test-Path -LiteralPath $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH | Should -BeFalse
    }

    It 'preserves malformed configuration for recovery' {
        New-Item -ItemType Directory -Path $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT -Force | Out-Null
        $configPath = Join-Path -Path $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT -ChildPath 'config.json'
        [System.IO.File]::WriteAllText($configPath, '{not-json', (New-Object System.Text.UTF8Encoding($false)))

        InModuleScope ColorScripts-Enhanced {
            $script:ConfigurationInitialized = $false
            $script:ConfigurationRoot = $null
            $script:ConfigurationData = $null
            Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced

            Initialize-Configuration

            Should-Invoke -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -Times 1
            $script:ConfigurationData.Startup.AutoShowOnImport | Should -BeFalse
        }

        (Get-Content -LiteralPath $configPath -Raw).Trim() | Should -Be '{not-json'
    }

    It 'does not create directories for configuration WhatIf' {
        $requestedCache = Join-Path -Path $TestDrive -ChildPath 'whatif-cache'

        Set-ColorScriptConfiguration -CachePath $requestedCache -WhatIf

        Test-Path -LiteralPath $requestedCache | Should -BeFalse
        Test-Path -LiteralPath $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT | Should -BeFalse
    }

    It 'does not create a scaffold output directory for WhatIf' {
        $outputDirectory = Join-Path -Path $TestDrive -ChildPath 'whatif-output'

        New-ColorScript -Name 'whatif-script' -OutputPath $outputDirectory -WhatIf

        Test-Path -LiteralPath $outputDirectory | Should -BeFalse
    }

    It 'does not create a profile directory for WhatIf' {
        $profilePath = Join-Path -Path $TestDrive -ChildPath 'profile-parent/profile.ps1'

        Add-ColorScriptProfile -ProfilePath $profilePath -SkipCacheBuild -SkipPokemonPrompt -WhatIf

        Test-Path -LiteralPath (Split-Path -Path $profilePath -Parent) | Should -BeFalse
    }

    It 'replaces only its managed profile block when forced' {
        $profilePath = Join-Path -Path $TestDrive -ChildPath 'profile.ps1'
        Add-ColorScriptProfile -ProfilePath $profilePath -SkipCacheBuild -SkipPokemonPrompt -Confirm:$false | Out-Null
        [System.IO.File]::AppendAllText(
            $profilePath,
            "`nShow-ColorScript -Name 'user-owned'`n",
            (New-Object System.Text.UTF8Encoding($false)))

        Add-ColorScriptProfile -ProfilePath $profilePath -SkipCacheBuild -SkipPokemonPrompt -Force -Confirm:$false | Out-Null

        $content = Get-Content -LiteralPath $profilePath -Raw
        ([regex]::Matches($content, '# BEGIN ColorScripts-Enhanced managed block')).Count | Should -Be 1
        ([regex]::Matches($content, '# END ColorScripts-Enhanced managed block')).Count | Should -Be 1
        $content | Should -Match "Show-ColorScript -Name 'user-owned'"
    }

    It 'drains large child-process output and error streams without deadlocking' {
        $scriptPath = Join-Path -Path $TestDrive -ChildPath 'large-stderr.ps1'
        [System.IO.File]::WriteAllText(
            $scriptPath,
            "[Console]::Error.Write(('x' * 262144)); Write-Host 'done'",
            (New-Object System.Text.UTF8Encoding($true)))

        $result = InModuleScope ColorScripts-Enhanced -Parameters @{ TestScriptPath = $scriptPath } {
            param($TestScriptPath)
            Invoke-ColorScriptChildProcess -ScriptPath $TestScriptPath
        }

        $result.Success | Should -BeTrue
        $result.StdOut | Should -Match 'done'
        $result.StdErr.Length | Should -BeGreaterOrEqual 262144
    }
}
