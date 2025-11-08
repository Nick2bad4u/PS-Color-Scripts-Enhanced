Describe 'ColorScripts-Enhanced Install script coverage' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force
        $script:InstallScript = Join-Path -Path $script:ModuleRoot -ChildPath 'Install.ps1'
        . $script:InstallScript
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context 'Get-ModuleInstallRoot' {
        It 'returns a user scope path by default' {
            $path = Get-ModuleInstallRoot
            $path | Should -Not -BeNullOrEmpty
        }

        It 'returns an all-users path when requested' {
            $path = Get-ModuleInstallRoot -AllUsersScope
            $path | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Install.ps1 invocation (WhatIf)' {
        BeforeEach {
            # Avoid side effects during installation flow
            Mock -CommandName Import-Module -MockWith { $null } -Verifiable
            Mock -CommandName New-Item -MockWith { $null } -Verifiable
            Mock -CommandName Remove-Item -MockWith { $null } -Verifiable
            Mock -CommandName Copy-Item -MockWith { $null } -Verifiable
        }

        It 'runs in CurrentUser scope with -WhatIf and returns result object' {
            $result = & $script:InstallScript -WhatIf
            $result | Should -Not -BeNullOrEmpty
            $result.Scope | Should -Be 'CurrentUser'
            $result.SourcePath | Should -Not -BeNullOrEmpty
            $result.DestinationPath | Should -Not -BeNullOrEmpty
        }

        It 'runs in AllUsers scope with -WhatIf and returns result object' {
            $result = & $script:InstallScript -AllUsers -WhatIf
            $result | Should -Not -BeNullOrEmpty
            $result.Scope | Should -Be 'AllUsers'
        }
    }
}
