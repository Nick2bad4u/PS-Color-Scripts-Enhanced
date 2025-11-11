Describe 'New-ColorScriptCache targeted coverage' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleManifest = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force

        InModuleScope ColorScripts-Enhanced {
            $script:CacheTestRecords = @(
                [pscustomobject]@{ Name = 'alpha'; Path = 'TestDrive:\alpha.ans' },
                [pscustomobject]@{ Name = 'beta'; Path = 'TestDrive:\beta.ans' }
            )
        }
    }

    AfterAll {
        InModuleScope ColorScripts-Enhanced {
            Remove-Variable -Name CacheTestRecords -Scope Script -ErrorAction SilentlyContinue
        }
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context 'Help and validation' {
        It 'invokes Show-ColorScriptHelp when -h is provided' {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced
                New-ColorScriptCache -h
                Assert-MockCalled Show-ColorScriptHelp -Times 1 -Exactly
                Assert-MockCalled Initialize-CacheDirectory -Times 0 -Exactly
            }
        }

        It 'throws when -All is specified as false' {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Invoke-ColorScriptError -ModuleName ColorScripts-Enhanced -MockWith { throw [System.InvalidOperationException]::new('selection missing') }
                $threw = $false
                try {
                    New-ColorScriptCache -All:$false
                }
                catch {
                    $threw = $true
                    $_.Exception.Message | Should -Be 'selection missing'
                }
                $threw | Should -BeTrue
            }
        }
    }

    Context 'Sequential execution scenarios' {
        It 'skips cached entries and respects ShouldProcess opt-out' {
            $result = InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheTestRecords }
                $script:CacheResponses = @(
                    [pscustomobject]@{ Available = $true; CacheFile = 'alpha.cache'; Content = 'cached-alpha' },
                    [pscustomobject]@{ Available = $false; CacheFile = 'beta.cache'; Content = '' }
                )
                $script:CacheIndex = 0
                Mock -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -MockWith {
                    $response = $script:CacheResponses[$script:CacheIndex]
                    $script:CacheIndex++
                    return $response
                }
                $script:ShouldProcessResponses = @( $false )
                $script:ShouldProcessIndex = 0
                Mock -CommandName Invoke-ShouldProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    $response = $script:ShouldProcessResponses[$script:ShouldProcessIndex]
                    $script:ShouldProcessIndex++
                    return $response
                }
                $script:OperationCallCount = 0
                Mock -CommandName Invoke-ColorScriptCacheOperation -ModuleName ColorScripts-Enhanced -MockWith { $script:OperationCallCount++ }

                $output = New-ColorScriptCache -Name 'alpha', 'beta' -PassThru

                [pscustomobject]@{
                    Output         = $output
                    CacheHits      = $script:CacheIndex
                    ShouldCalls    = $script:ShouldProcessIndex
                    OperationCalls = $script:OperationCallCount
                }
            }

            $result.Output | Should -HaveCount 2
            ($result.Output | Where-Object Name -EQ 'alpha').Status | Should -Be 'SkippedUpToDate'
            ($result.Output | Where-Object Name -EQ 'beta').Status | Should -Be 'SkippedByUser'
            $result.CacheHits | Should -Be 2
            $result.ShouldCalls | Should -Be 1
            $result.OperationCalls | Should -Be 0
        }

        It 'builds caches, emits warnings, and summarizes results' {
            $result = InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheTestRecords }
                Mock -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -MockWith { [pscustomobject]@{ Available = $false; CacheFile = $null; Content = '' } }
                $script:ShouldProcessResponses = @( $true, $true )
                $script:ShouldProcessIndex = 0
                Mock -CommandName Invoke-ShouldProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    $response = $script:ShouldProcessResponses[$script:ShouldProcessIndex]
                    $script:ShouldProcessIndex++
                    return $response
                }
                $script:OperationResponses = @(
                    [pscustomobject]@{
                        Result  = [pscustomobject]@{
                            Name        = 'alpha'
                            ScriptPath  = 'TestDrive:\alpha.ans'
                            CacheFile   = 'alpha.cache'
                            Status      = 'Updated'
                            Message     = 'cached alpha'
                            CacheExists = $true
                            ExitCode    = 0
                            StdOut      = 'stdout'
                            StdErr      = ''
                        }
                        Updated = 1
                        Failed  = 0
                        Warning = 'alpha warning'
                    },
                    [pscustomobject]@{
                        Result  = [pscustomobject]@{
                            Name        = 'beta'
                            ScriptPath  = 'TestDrive:\beta.ans'
                            CacheFile   = 'beta.cache'
                            Status      = 'Failed'
                            Message     = 'failure'
                            CacheExists = $false
                            ExitCode    = 1
                            StdOut      = ''
                            StdErr      = 'error'
                        }
                        Updated = 0
                        Failed  = 1
                        Warning = $null
                    }
                )
                $script:OperationIndex = 0
                Mock -CommandName Invoke-ColorScriptCacheOperation -ModuleName ColorScripts-Enhanced -MockWith {
                    $response = $script:OperationResponses[$script:OperationIndex]
                    $script:OperationIndex++
                    return $response
                }
                $script:Warnings = New-Object System.Collections.Generic.List[string]
                Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith { param($Message) $null = $script:Warnings.Add($Message) }
                Mock -CommandName New-ColorScriptAnsiText -ModuleName ColorScripts-Enhanced -MockWith { param($Text) $Text }
                Mock -CommandName Write-ColorScriptInformation -ModuleName ColorScripts-Enhanced -MockWith { param($Message, $Quiet) $script:SummaryMessage = $Message }

                $output = New-ColorScriptCache -Name 'alpha', 'beta'

                [pscustomobject]@{
                    Warnings       = $script:Warnings.ToArray()
                    SummaryMessage = $script:SummaryMessage
                    OperationCalls = $script:OperationIndex
                    ShouldProcess  = $script:ShouldProcessIndex
                }
            }

            $result.OperationCalls | Should -Be 2
            $result.ShouldProcess | Should -Be 2
            $result.Warnings | Should -Contain 'alpha warning'
            $result.SummaryMessage | Should -Match 'Processed 2'
        }
    }
}
