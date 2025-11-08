Describe 'ColorScripts-Enhanced directory resolution and synchronization coverage' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force
    }

    AfterAll { Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue }

    Context 'Resolve-PreferredDirectory' {
        It 'returns null and invokes resolution failure callback when path cannot resolve' {
            $calls = [System.Collections.Generic.List[string]]::new()
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ calls = $calls } {
                param($calls)
                Resolve-PreferredDirectory -Path "`t`n" -OnResolutionFailure { param($p) $null = $calls.Add($p) }
            }
            $result | Should -Be $null
            $calls.Count | Should -Be 1
        }

        It 'creates directory when missing and returns resolved path' {
            $driveRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
            $target = Join-Path -Path $driveRoot -ChildPath ([guid]::NewGuid().ToString())
            $resolved = InModuleScope ColorScripts-Enhanced -Parameters @{ target = $target } {
                param($target)
                Resolve-PreferredDirectory -Path $target
            }
            $resolved | Should -Not -BeNullOrEmpty
            Test-Path -LiteralPath $resolved -PathType Container | Should -BeTrue
        }

        It 'invokes create failure callback on exception' {
            $driveRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
            $target = Join-Path -Path $driveRoot -ChildPath ([guid]::NewGuid().ToString())
            $failures = [System.Collections.Generic.List[string]]::new()
            $resolved = InModuleScope ColorScripts-Enhanced -Parameters @{ target = $target; failures = $failures } {
                param($target, $failures)
                Resolve-PreferredDirectory -Path $target -CreateDirectory { param($p) throw 'boom' } -OnCreateFailure { param($p, $e) $null = $failures.Add($e.Exception.Message) }
            }
            $resolved | Should -Be $null
            $failures.Count | Should -Be 1
            $failures[0] | Should -Match 'boom'
        }
    }

    Context 'Resolve-PreferredDirectoryCandidate' {
        It 'returns the resolvable candidate path' {
            $driveRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
            $candidate = Join-Path $driveRoot ([guid]::NewGuid().ToString())
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ c = @($candidate) } {
                param($c)
                Resolve-PreferredDirectoryCandidate -CandidatePaths $c
            }
            $result | Should -Not -BeNullOrEmpty
            Test-Path -LiteralPath $result -PathType Container | Should -BeTrue
        }
    }

    Context 'Invoke-ModuleSynchronized' {
        It 'executes action under lock when SyncRoot provided' {
            $sync = [System.Object]::new()
            $value = InModuleScope ColorScripts-Enhanced -Parameters @{ s = $sync } {
                param($s)
                Invoke-ModuleSynchronized -SyncRoot $s -Action { 'locked' }
            }
            $value | Should -Be 'locked'
        }
    }

    Context 'Invoke-ShouldProcess' {
        It 'uses ShouldProcessEvaluator override when defined' {
            $result = InModuleScope ColorScripts-Enhanced {
                $originalEvaluator = $script:ShouldProcessEvaluator
                try {
                    $script:ShouldProcessEvaluator = { param($cmd, $t, $a) $false }
                    Invoke-ShouldProcess -Cmdlet $null -Target 'X' -Action 'Y'
                }
                finally { $script:ShouldProcessEvaluator = $originalEvaluator }
            }
            $result | Should -BeFalse
        }

        It 'uses ShouldProcessOverride when evaluator absent' {
            $result = InModuleScope ColorScripts-Enhanced {
                $originalOverride = $script:ShouldProcessOverride
                try {
                    $script:ShouldProcessOverride = { param($cmd, $t, $a) $true }
                    Invoke-ShouldProcess -Cmdlet $null -Target 'A' -Action 'B'
                }
                finally { $script:ShouldProcessOverride = $originalOverride }
            }
            $result | Should -BeTrue
        }
    }
}
