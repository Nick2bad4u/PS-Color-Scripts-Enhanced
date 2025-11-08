Describe 'Core behaviors: information, config save, cache versioning, install' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModulePath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModulePath -ChildPath 'ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force

        # Prepare isolated config/cache roots
        $script:TempRoot = Join-Path (Resolve-Path 'TestDrive:\').ProviderPath ([guid]::NewGuid().ToString())
        New-Item -ItemType Directory -Path $script:TempRoot -Force | Out-Null
        $script:CacheRoot = Join-Path $script:TempRoot 'Cache'
        $script:ConfigRoot = Join-Path $script:TempRoot 'Config'
        New-Item -ItemType Directory -Path $script:CacheRoot -Force | Out-Null
        New-Item -ItemType Directory -Path $script:ConfigRoot -Force | Out-Null

        InModuleScope ColorScripts-Enhanced -Parameters @{ cache = $script:CacheRoot; cfg = $script:ConfigRoot } {
            param($cache, $cfg)
            $script:CacheDir = $cache
            $script:CacheInitialized = $true
            $script:ConfigurationRoot = $cfg
            $script:ConfigurationInitialized = $true
        }
    }

    AfterAll { Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue }

    Context 'Write-ColorScriptInformation behaviors' {
        It 'returns early when Quiet and does not write' {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Write-RenderedText -ModuleName ColorScripts-Enhanced -MockWith { }
                Mock -CommandName Write-Information -ModuleName ColorScripts-Enhanced -MockWith { }
                Write-ColorScriptInformation -Message 'hello' -Quiet
                Assert-MockCalled Write-RenderedText -Times 0
                Assert-MockCalled Write-Information -Times 0
            }
        }

        It 'strips ANSI for Information payload and SilentlyContinue when console write succeeds' {
            InModuleScope ColorScripts-Enhanced {
                $esc = [char]27
                $msg = "${esc}[32mgreen${esc}[0m"
                Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                Mock -CommandName Test-ConsoleSupportsVirtualTerminal -ModuleName ColorScripts-Enhanced -MockWith { $true }
                Mock -CommandName Write-RenderedText -ModuleName ColorScripts-Enhanced -MockWith { }
                $infoCalls = [System.Collections.Generic.List[hashtable]]::new()
                Mock -CommandName Write-Information -ModuleName ColorScripts-Enhanced -MockWith { param([object]$MessageData, [string]$InformationAction) $null = $infoCalls.Add(@{ msg = $MessageData; act = $InformationAction }) }
                Write-ColorScriptInformation -Message $msg -PreferConsole -Color 'Yellow'
                Assert-MockCalled Write-RenderedText -Times 1 -Exactly
                $infoCalls.Count | Should -Be 1
                ($infoCalls[0].act) | Should -Be 'SilentlyContinue'
                ($infoCalls[0].msg) | Should -Not -Match '\x1b\['
            }
        }

        It 'does not strip ANSI when -NoAnsiOutput is present and falls back color path when console not preferred' {
            InModuleScope ColorScripts-Enhanced {
                $esc = [char]27
                $msg = "${esc}[31mred${esc}[0m"
                Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $true }
                Mock -CommandName Test-ConsoleSupportsVirtualTerminal -ModuleName ColorScripts-Enhanced -MockWith { $false }
                Mock -CommandName Write-RenderedText -ModuleName ColorScripts-Enhanced -MockWith { }
                $infoCalls = [System.Collections.Generic.List[hashtable]]::new()
                Mock -CommandName Write-Information -ModuleName ColorScripts-Enhanced -MockWith { param([object]$MessageData, [string]$InformationAction) $null = $infoCalls.Add(@{ msg = $MessageData; act = $InformationAction }) }
                Write-ColorScriptInformation -Message $msg -Color 'Cyan' -NoAnsiOutput
                Assert-MockCalled Write-RenderedText -Times 0
                $infoCalls.Count | Should -Be 1
                ($infoCalls[0].act) | Should -Be 'Continue'
                ($infoCalls[0].msg) | Should -Match '\x1b\['
            }
        }
    }

    Context 'Save-ColorScriptConfiguration early-return and force' {
        It 'writes when forced and skips when ExistingContent matches' {
            InModuleScope ColorScripts-Enhanced {
                $config = @{ Cache = @{ Path = $script:CacheDir }; Startup = @{ AutoShowOnImport = $false; ProfileAutoShow = $true; DefaultScript = 'bars' } }
                $json = ($config | ConvertTo-Json -Depth 6).TrimEnd("`r", "`n")
                # First invocation (forced) should write
                Mock -CommandName Set-Content -ModuleName ColorScripts-Enhanced -MockWith { }
                Save-ColorScriptConfiguration -Configuration $config -Force
                Assert-MockCalled Set-Content -Times 1 -Exactly
                # Second invocation without Force and with identical ExistingContent should early-return (no extra calls)
                Save-ColorScriptConfiguration -Configuration $config -ExistingContent $json
                Assert-MockCalled Set-Content -Times 1 -Exactly
            }
        }
    }

    Context 'Update-CacheFormatVersion purge and metadata creation' {
        It 'removes obsolete metadata and cache files and writes metadata file' {
            InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:CacheRoot } {
                param($root)
                $metaKeep = Join-Path $root 'cache-metadata.json'
                $metaOld = Join-Path $root 'cache-metadata-old.json'
                Set-Content -Path $metaOld -Value '{}' -Encoding utf8
                Set-Content -Path (Join-Path $root 'a.cache') -Value 'x' -Encoding utf8
                Set-Content -Path (Join-Path $root 'b.cache') -Value 'y' -Encoding utf8
                Update-CacheFormatVersion -CacheDirectory $root -MetadataFileName (Split-Path -Leaf $metaKeep)
                Test-Path -LiteralPath $metaOld | Should -BeFalse
                Test-Path -LiteralPath (Join-Path $root 'a.cache') | Should -BeFalse
                Test-Path -LiteralPath (Join-Path $root 'b.cache') | Should -BeFalse
                Test-Path -LiteralPath $metaKeep | Should -BeTrue
                $doc = Get-Content -LiteralPath $metaKeep -Raw | ConvertFrom-Json
                [int]$doc.Version | Should -BeGreaterThan 0
            }
        }
    }

    Context 'Install script ShouldProcess guarded paths (WhatIf)' {
        It 'emits WhatIf and returns result object without side effects' {
            $installPath = Join-Path $script:ModulePath 'Install.ps1'
            $result = & $installPath -WhatIf -AddToProfile -SkipStartupScript -BuildCache
            $result | Should -Not -BeNullOrEmpty
            $result.SourcePath | Should -Not -BeNullOrEmpty
            $result.DestinationPath | Should -Not -BeNullOrEmpty
            $result.Scope | Should -Be 'CurrentUser'
        }
    }
}
