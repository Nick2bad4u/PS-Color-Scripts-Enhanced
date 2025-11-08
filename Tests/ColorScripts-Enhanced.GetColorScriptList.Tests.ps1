Describe 'Get-ColorScriptList targeted coverage' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleManifest = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force

        InModuleScope ColorScripts-Enhanced {
            $script:SampleListRecords = @(
                [pscustomobject]@{ Name = 'bars'; Category = 'Patterns'; Tags = @('pattern', 'featured'); Description = 'Bold bars' },
                [pscustomobject]@{ Name = 'aurora-waves'; Category = 'Nature'; Tags = @('aurora', 'nature'); Description = 'Dancing lights' },
                [pscustomobject]@{ Name = 'cyberstar'; Category = 'SciFi'; Tags = @('featured', 'futuristic'); Description = 'Neon star' }
            )
        }
    }

    AfterAll {
        InModuleScope ColorScripts-Enhanced {
            Remove-Variable -Name SampleListRecords -Scope Script -ErrorAction SilentlyContinue
        }
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context 'help and formatting branches' {
        It 'invokes Show-ColorScriptHelp when -h is supplied' {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced
                $result = Get-ColorScriptList -h
                $result | Should -BeNullOrEmpty
                Assert-MockCalled Show-ColorScriptHelp -Times 1 -Exactly
            }
        }

        It 'formats detailed table, removes ANSI, and writes information' {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith { $script:SampleListRecords }
                Mock -CommandName Remove-ColorScriptAnsiSequence -ModuleName ColorScripts-Enhanced -MockWith { param($Text) $Text }
                Mock -CommandName Write-ColorScriptInformation -ModuleName ColorScripts-Enhanced -MockWith { param($Message, $Quiet) $script:LastMessage = $Message }

                $result = Get-ColorScriptList -Name 'bars' -Detailed -NoAnsiOutput
                $result | Should -Not -BeNullOrEmpty
                Assert-MockCalled Remove-ColorScriptAnsiSequence -Times 1
                Assert-MockCalled Write-ColorScriptInformation -Times 1
                $script:LastMessage | Should -Match 'bars'

                Remove-Variable -Name LastMessage -Scope Script -ErrorAction SilentlyContinue
            }
        }

        It 'suppresses formatting when -Quiet is used' {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith { $script:SampleListRecords }
                Mock -CommandName Write-ColorScriptInformation -ModuleName ColorScripts-Enhanced
                $result = Get-ColorScriptList -Name 'aurora-waves' -AsObject -Quiet
                $result | Should -HaveCount 1
                Assert-MockCalled Write-ColorScriptInformation -Times 0 -Exactly
            }
        }
    }

    Context 'filtering and warning branches' {
        It 'emits warning and returns empty array when filters yield no records' {
            $outcome = InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Category, $Tag)
                    @()
                }
                $warningVar = $null
                $result = Get-ColorScriptList -Category 'NonExisting' -WarningVariable warningVar
                [pscustomobject]@{ Result = $result; Warning = $warningVar }
            }
            $outcome.Result | Should -BeNullOrEmpty
            ($outcome.Warning | Out-String) | Should -Match 'No colorscripts available'
        }

        It 'writes warnings for missing name patterns and returns matches' {
            $outcome = InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith { $script:SampleListRecords }
                $warningVar = $null
                $records = Get-ColorScriptList -Name 'bars', 'does-not-exist' -WarningVariable warningVar -AsObject
                [pscustomobject]@{ Records = $records; Warning = $warningVar }
            }
            $outcome.Records | Should -Not -BeNullOrEmpty
            ($outcome.Warning | Out-String) | Should -Match 'does-not-exist'
            ($outcome.Records | Select-Object -ExpandProperty Name) | Should -Contain 'bars'
        }

        It 'filters by tag returning only matching scripts' {
            $result = InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Category, $Tag)
                    $script:SampleListRecords | Where-Object {
                        $tags = $_.Tags
                        foreach ($t in @($Tag)) {
                            if ($tags -contains $t) { return $true }
                        }
                        return $false
                    }
                }
                Get-ColorScriptList -Tag 'futuristic' -AsObject
            }
            $result | Should -HaveCount 1
            $result.Name | Should -Be 'cyberstar'
        }
    }
}
