Describe 'Selective colorscript output caching' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context 'Cache policy' {
        It 'contains a unique, resolvable set of explicitly cacheable scripts' {
            $policy = Import-PowerShellDataFile (Join-Path -Path $script:ModuleRoot -ChildPath 'CachePolicy.psd1')
            $uniqueNames = @($policy.CacheableScripts | Sort-Object -Unique)

            $policy.CacheableScripts.Count | Should -BeGreaterThan 0
            $uniqueNames | Should -HaveCount $policy.CacheableScripts.Count

            foreach ($scriptName in $policy.CacheableScripts) {
                $scriptPath = Join-Path -Path $script:ModuleRoot -ChildPath ("Scripts/{0}.ps1" -f $scriptName)
                Test-Path -LiteralPath $scriptPath -PathType Leaf | Should -BeTrue -Because "cache policy entry '$scriptName' must resolve"
            }
        }

        It 'excludes static output and includes the computational examples' {
            $classification = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:ModuleRoot } {
                param($root)

                [pscustomobject]@{
                    Static    = Test-ColorScriptRequiresCache -ScriptPath (Join-Path -Path $root -ChildPath 'Scripts/1998-01-fev-ice.ps1')
                    Bars      = Test-ColorScriptRequiresCache -ScriptPath (Join-Path -Path $root -ChildPath 'Scripts/bars.ps1')
                    Benchmark = Test-ColorScriptRequiresCache -ScriptPath (Join-Path -Path $root -ChildPath 'Scripts/terminal-benchmark.ps1')
                    IsoCubes  = Test-ColorScriptRequiresCache -ScriptPath (Join-Path -Path $root -ChildPath 'Scripts/iso-cubes.ps1')
                    Penrose   = Test-ColorScriptRequiresCache -ScriptPath (Join-Path -Path $root -ChildPath 'Scripts/penrose-quasicrystal.ps1')
                    Perlin    = Test-ColorScriptRequiresCache -ScriptPath (Join-Path -Path $root -ChildPath 'Scripts/perlin-clouds.ps1')
                    Unknown   = Test-ColorScriptRequiresCache -ScriptPath (Join-Path -Path $root -ChildPath 'Scripts/custom-unlisted.ps1')
                }
            }

            $classification.Static | Should -BeFalse
            $classification.Bars | Should -BeFalse
            $classification.Benchmark | Should -BeFalse
            $classification.IsoCubes | Should -BeTrue
            $classification.Penrose | Should -BeTrue
            $classification.Perlin | Should -BeTrue
            $classification.Unknown | Should -BeFalse
        }
    }

    Context 'Cache creation' {
        It 'skips static output even with Force and removes a legacy entry' {
            $result = InModuleScope ColorScripts-Enhanced {
                $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'selective-static'
                New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                $script:CacheInitialized = $true

                $cachePath = Join-Path -Path $script:CacheDir -ChildPath '1998-01-fev-ice.cache'
                $metadataPath = Join-Path -Path $script:CacheDir -ChildPath '1998-01-fev-ice.cacheinfo'
                Set-Content -LiteralPath $cachePath -Value 'legacy cached output' -Encoding UTF8
                Set-Content -LiteralPath $metadataPath -Value '{}' -Encoding UTF8

                $record = New-ColorScriptCache -Name '1998-01-fev-ice' -Force -PassThru
                [pscustomobject]@{
                    Record         = $record
                    CacheExists    = Test-Path -LiteralPath $cachePath
                    MetadataExists = Test-Path -LiteralPath $metadataPath
                }
            }

            $result.Record.Status | Should -Be 'SkippedNotRequired'
            $result.Record.CacheExists | Should -BeFalse
            $result.CacheExists | Should -BeFalse
            $result.MetadataExists | Should -BeFalse
        }

        It 'preserves obsolete static cache files during WhatIf' {
            $result = InModuleScope ColorScripts-Enhanced {
                $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'selective-whatif'
                New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                $script:CacheInitialized = $true

                $cachePath = Join-Path -Path $script:CacheDir -ChildPath '1998-01-fev-ice.cache'
                $metadataPath = Join-Path -Path $script:CacheDir -ChildPath '1998-01-fev-ice.cacheinfo'
                Set-Content -LiteralPath $cachePath -Value 'legacy cached output' -Encoding UTF8
                Set-Content -LiteralPath $metadataPath -Value '{}' -Encoding UTF8

                $record = New-ColorScriptCache -Name '1998-01-fev-ice' -Force -WhatIf -PassThru
                [pscustomobject]@{
                    Record         = $record
                    CacheExists    = Test-Path -LiteralPath $cachePath
                    MetadataExists = Test-Path -LiteralPath $metadataPath
                }
            }

            $result.Record.Status | Should -Be 'SkippedNotRequired'
            $result.Record.CacheExists | Should -BeTrue
            $result.CacheExists | Should -BeTrue
            $result.MetadataExists | Should -BeTrue
        }

        It 'applies the same skip policy before parallel work is queued' {
            $result = InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Invoke-ColorScriptCacheOperation -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'Static output must not reach a cache worker.'
                }

                $record = New-ColorScriptCache -Name '1998-01-fev-ice' -Force -Parallel -ThrottleLimit 2 -PassThru
                Assert-MockCalled -CommandName Invoke-ColorScriptCacheOperation -ModuleName ColorScripts-Enhanced -Times 0 -Exactly
                $record
            }

            $result.Status | Should -Be 'SkippedNotRequired'
        }

        It 'defensively refuses direct cache builds for static output' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:ModuleRoot } {
                param($root)

                Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'Static output must not be executed by the cache builder.'
                }

                $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'selective-build'
                New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                $script:CacheInitialized = $true
                $build = Build-ScriptCache -ScriptPath (Join-Path -Path $root -ChildPath 'Scripts/1998-01-fev-ice.ps1')

                Assert-MockCalled -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -Times 0 -Exactly
                $build
            }

            $result.Success | Should -BeTrue
            $result.CacheRequired | Should -BeFalse
            $result.CacheCreated | Should -BeFalse
            $result.CacheFile | Should -BeNullOrEmpty
        }
    }

    Context 'Display routing' {
        It 'executes static output directly and never consults a legacy cache' {
            $result = InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'Static output must not initialize the cache.'
                }
                Mock -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'Static output must not read cached content.'
                }
                Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'Static output must not build cached content.'
                }
                Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{ Success = $true; StdOut = 'direct static output'; StdErr = ''; ExitCode = 0 }
                }

                $text = Show-ColorScript -Name '1998-01-fev-ice' -ReturnText -Quiet

                Assert-MockCalled -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -Times 0 -Exactly
                Assert-MockCalled -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -Times 0 -Exactly
                Assert-MockCalled -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -Times 0 -Exactly
                Assert-MockCalled -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -Times 1 -Exactly
                $text
            }

            $result | Should -BeExactly 'direct static output'
        }

        It 'retains the cache path for computational output' {
            $result = InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced
                Mock -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{ Available = $true; Content = 'cached penrose output' }
                }
                Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'An available cache must not be rebuilt.'
                }
                Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'A cache hit must not execute the script.'
                }

                $text = Show-ColorScript -Name 'penrose-quasicrystal' -ReturnText -Quiet

                Assert-MockCalled -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -Times 1 -Exactly
                Assert-MockCalled -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -Times 1 -Exactly
                Assert-MockCalled -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -Times 0 -Exactly
                Assert-MockCalled -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -Times 0 -Exactly
                $text
            }

            $result | Should -BeExactly 'cached penrose output'
        }
    }
}
