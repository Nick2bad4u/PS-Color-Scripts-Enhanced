Describe 'Gap-filler 2 for list, cache, and emission' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleManifest = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force

        # Isolated cache dir
        $script:TempRoot = Join-Path (Resolve-Path 'TestDrive:\').ProviderPath ([guid]::NewGuid().ToString())
        New-Item -ItemType Directory -Path $script:TempRoot -Force | Out-Null
        $script:CacheRoot = Join-Path $script:TempRoot 'Cache'
        New-Item -ItemType Directory -Path $script:CacheRoot -Force | Out-Null

        InModuleScope ColorScripts-Enhanced -Parameters @{ r = $script:CacheRoot } {
            param($r)
            $script:CacheDir = $r
            $script:CacheInitialized = $true
        }
    }

    AfterAll { Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue }

    Context 'Get-ColorScriptList formatting branches' {
        It 'prints detailed table without ANSI when -Detailed -NoAnsiOutput (not AsObject, not Quiet)' {
            InModuleScope ColorScripts-Enhanced {
                $messages = [System.Collections.Generic.List[string]]::new()
                Mock -CommandName Write-ColorScriptInformation -ModuleName ColorScripts-Enhanced -MockWith { param($Message, $Quiet) $null = $messages.Add([string]$Message) }
                Get-ColorScriptList -Name 'bars' -Detailed -NoAnsiOutput | Out-Null
                Assert-MockCalled Write-ColorScriptInformation -Times 1 -Exactly
                ($messages | Select-Object -First 1) | Should -Match 'Name'
            }
        }
    }

    Context 'New-ColorScriptCache skipped and error paths' {
        It 'throws when -All is explicitly provided as false (parameter present but false)' {
            { New-ColorScriptCache -All:$false } | Should -Throw
        }

        It 'skips by user when ShouldProcess declines for a targeted name' {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Invoke-ShouldProcess -ModuleName ColorScripts-Enhanced -MockWith { $false }
                $res = New-ColorScriptCache -Name 'bars' -PassThru -Force
                $res | Should -Not -BeNullOrEmpty
                ($res | Select-Object -First 1).Status | Should -Be 'SkippedByUser'
            }
        }

        It 'skips up-to-date when cache is fresh and returns cached content' {
            InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:CacheRoot } {
                param($root)
                # Prepare a fresh cache file newer than the script source
                $cachePath = Join-Path $root 'bars.cache'
                Set-Content -Path $cachePath -Value 'precache' -Encoding utf8
                (Get-Item $cachePath).LastWriteTimeUtc = (Get-Date).ToUniversalTime().AddMinutes(10)
                $res = New-ColorScriptCache -Name 'bars' -PassThru
                $rec = $res | Where-Object Name -EQ 'bars' | Select-Object -First 1
                $rec.Status | Should -Be 'SkippedUpToDate'
                $rec.StdOut | Should -Match '^precache'
            }
        }
    }

    Context 'Test-ColorScriptTextEmission decision matrix' {
        It 'honors ReturnText regardless of pipeline and PassThru' {
            InModuleScope ColorScripts-Enhanced {
                Test-ColorScriptTextEmission -ReturnText:$true -PassThru:$false -PipelineLength 0 -BoundParameters @{} | Should -BeTrue
                Test-ColorScriptTextEmission -ReturnText:$true -PassThru:$true -PipelineLength 2 -BoundParameters @{} | Should -BeTrue
            }
        }

        It 'uses redirect and pipeline length logic for other cases' {
            InModuleScope ColorScripts-Enhanced {
                $old = $script:IsOutputRedirectedDelegate
                try {
                    $script:IsOutputRedirectedDelegate = { $false }
                    Test-ColorScriptTextEmission -ReturnText:$false -PassThru:$false -PipelineLength 2 -BoundParameters @{} | Should -BeTrue
                    Test-ColorScriptTextEmission -ReturnText:$false -PassThru:$false -PipelineLength 0 -BoundParameters @{ OutVariable = 'x' } | Should -BeTrue
                    Test-ColorScriptTextEmission -ReturnText:$false -PassThru:$true -PipelineLength 0 -BoundParameters @{} | Should -BeFalse
                    $script:IsOutputRedirectedDelegate = { $true }
                    Test-ColorScriptTextEmission -ReturnText:$false -PassThru:$true -PipelineLength 0 -BoundParameters @{} | Should -BeTrue
                }
                finally { $script:IsOutputRedirectedDelegate = $old }
            }
        }
    }
}
