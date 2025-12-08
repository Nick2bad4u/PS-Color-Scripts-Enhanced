Describe 'ColorScripts-Enhanced localization initialization' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRootPath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context 'Warm start and embedded defaults' {
        It 'returns existing localization details when already initialized' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/Initialize-ColorScriptsLocalization.ps1')
                $script:LocalizationInitialized = $true
                $script:Messages = @{ Existing = 'data' }
                $script:LocalizationDetails = $null
                Initialize-ColorScriptsLocalization
            }

            $result.LocalizedDataLoaded | Should -BeTrue
            $result.Source | Should -Be 'Import-LocalizedData'
        }

        It 'uses embedded defaults when requested and no resources exist' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/Initialize-ColorScriptsLocalization.ps1')
                $script:LocalizationInitialized = $false
                $script:LocalizationMode = 'Embedded'
                $script:ModuleRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $script:EmbeddedDefaultMessages = @{ Default = 'message' }
                Initialize-ColorScriptsLocalization -CandidateRoots @() -UseDefaultCandidates
            }

            $result.LocalizedDataLoaded | Should -BeFalse
            $result.Source | Should -Be 'EmbeddedDefaults'
        }
    }

    Context 'Importing localized resources' {
        It 'loads messages from candidate roots using Import-LocalizedData' {
            $payload = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/Initialize-ColorScriptsLocalization.ps1')
                $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $root -Force | Out-Null
                $messagesPath = Join-Path -Path $root -ChildPath 'Messages.psd1'
                "@{ CacheOperationInitializationFailed = 'init {0}' }" | Set-Content -LiteralPath $messagesPath -Encoding utf8
                Initialize-ColorScriptsLocalization -CandidateRoots $root
            }

            $payload.LocalizedDataLoaded | Should -BeTrue
            $payload.Source | Should -Match 'Import-LocalizedData'
            InModuleScope ColorScripts-Enhanced { $script:Messages.CacheOperationInitializationFailed } | Should -Match 'init'
        }
    }

    Context 'Import-LocalizedMessagesFromFile variations' {
        It 'imports from direct file path and records resolved path' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/Import-LocalizedMessagesFromFile.ps1')
                $filePath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'Messages.psd1'
                "@{ Greeting = 'Hello' }" | Set-Content -LiteralPath $filePath -Encoding utf8
                Import-LocalizedMessagesFromFile -FilePath $filePath
            }

            $result.Messages.Greeting | Should -Be 'Hello'
            Test-Path -LiteralPath $result.FilePath | Should -BeTrue
        }

        It 'falls back to Import-PowerShellDataFile when Import-LocalizedData fails' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/Import-LocalizedMessagesFromFile.ps1')
                $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $root -Force | Out-Null
                $messagesPath = Join-Path -Path $root -ChildPath 'Messages.psd1'
                "@{ Farewell = 'Goodbye' }" | Set-Content -LiteralPath $messagesPath -Encoding utf8
                Mock -CommandName Import-LocalizedData -ModuleName ColorScripts-Enhanced -MockWith { throw 'bad import' }
                Import-LocalizedMessagesFromFile -BaseDirectory $root
            }

            $result.Messages.Farewell | Should -Be 'Goodbye'
            $result.Source | Should -Match 'Import-PowerShellDataFile'
        }

        It 'converts non-dictionary results when Import-PowerShellDataFile succeeds' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/Import-LocalizedMessagesFromFile.ps1')
                $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $root -Force | Out-Null
                $messagesPath = Join-Path -Path $root -ChildPath 'Messages.psd1'
                "@{ Greeting = 'hola' }" | Set-Content -LiteralPath $messagesPath -Encoding utf8
                Mock -CommandName Import-LocalizedData -ModuleName ColorScripts-Enhanced -MockWith { throw 'not used' }
                Mock -CommandName Import-PowerShellDataFile -ModuleName ColorScripts-Enhanced -MockWith { [pscustomobject]@{ Greeting = 'hola' } }
                Import-LocalizedMessagesFromFile -BaseDirectory $root -FallbackUICulture 'es'
            }

            $result.Messages.Greeting | Should -Be 'hola'
            $result.Source | Should -Match 'Import-PowerShellDataFile'
        }
    }
}
