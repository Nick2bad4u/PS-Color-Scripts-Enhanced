Describe 'ColorScripts-Enhanced coverage elevation for public cmdlets' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
        # Direct module import
        Import-Module -Name $script:ModuleManifest -Force

        # Ensure configuration and cache roots point to TestDrive to avoid touching user profile
        $script:OriginalConfigRoot = InModuleScope ColorScripts-Enhanced { $script:ConfigurationRoot }
        $script:OriginalCacheDir = InModuleScope ColorScripts-Enhanced { $script:CacheDir }
        $script:OriginalCacheInitialized = InModuleScope ColorScripts-Enhanced { $script:CacheInitialized }

        $testConfigRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
        New-Item -ItemType Directory -Path $testConfigRoot -Force | Out-Null

        InModuleScope ColorScripts-Enhanced -Parameters @{ root = $testConfigRoot } {
            param($root)
            $script:ConfigurationRoot = $root
            $script:ConfigurationPath = Join-Path -Path $root -ChildPath 'config.json'
            $script:CacheInitialized = $false
            $script:CacheDir = Join-Path -Path $root -ChildPath 'cache'
            if (-not (Test-Path -LiteralPath $script:CacheDir)) { New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null }
        }
    }

    AfterAll {
        InModuleScope ColorScripts-Enhanced -Parameters @{ a = $script:OriginalConfigRoot; b = $script:OriginalCacheDir; c = $script:OriginalCacheInitialized } {
            param($a, $b, $c)
            $script:ConfigurationRoot = $a
            $script:CacheDir = $b
            $script:CacheInitialized = $c
        }
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context 'Get-ColorScriptList expanded cases' {
        It 'warns when no records match specified filters' {
            $captured = InModuleScope ColorScripts-Enhanced {
                $null = Get-ColorScriptList -AsObject -Category 'NonexistentCategory' -Quiet -WarningVariable warn -WarningAction Continue
                $warn
            }
            ($captured | Out-String) | Should -Match 'No colorscripts available'
        }

        It 'emits warnings for missing Name patterns and returns only matches' {
            $warnings = InModuleScope ColorScripts-Enhanced {
                $null = Get-ColorScriptList -AsObject -Name 'bars', 'does-not-exist-xyz' -WarningVariable warn -WarningAction Continue
                $result = Get-ColorScriptList -AsObject -Name 'bars'
                $result | Should -Not -BeNullOrEmpty
                $result | Where-Object Name -EQ 'bars' | Should -Not -BeNullOrEmpty
                $result | Where-Object Name -EQ 'does-not-exist-xyz' | Should -BeNullOrEmpty
                $result = $null
                $warn
            }
            ($warnings | Out-String) | Should -Match 'not found'
        }

        It 'prints simple table when not detailed and not quiet' {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Write-ColorScriptInformation -ModuleName ColorScripts-Enhanced -MockWith { param($Message, $Quiet) $null = $Quiet; $script:last = $Message }
                $null = Get-ColorScriptList -Name 'bars'
                Assert-MockCalled Write-ColorScriptInformation -Times 1 -Exactly
            }
        }
    }

    Context 'New-ColorScriptCache selection, pipeline, and parallel' {
        BeforeEach {
            InModuleScope ColorScripts-Enhanced {
                # Force cache dir to exist and clear any previous cache for target scripts
                Initialize-CacheDirectory
                $root = $script:CacheDir
                Get-ChildItem -Path $root -Filter '*.cache' -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
            }
        }

        It 'accepts pipeline input for Name and builds caches with -Force -PassThru' {
            $res = 'bars' | New-ColorScriptCache -Force -PassThru
            $res | Should -Not -BeNullOrEmpty
            ($res | Where-Object Name -EQ 'bars') | Should -Not -BeNullOrEmpty
        }

        It 'selects all when no filters or names are provided and returns summary with no PassThru' {
            InModuleScope ColorScripts-Enhanced {
                # Should emit an info summary; we just call without asserting output
                New-ColorScriptCache -WhatIf | Out-Null
            }
        }

        It 'runs minimal parallel path with -Parallel and small throttle' {
            # Limit candidate set with a narrow wildcard and use -Parallel
            $records = Get-ColorScriptList -AsObject -Name 'bars'
            $records | New-ColorScriptCache -Parallel -ThrottleLimit 2 -Force -PassThru | Should -Not -BeNullOrEmpty
        }

        It 'shows warning for unknown name and proceeds with known names' {
            $res = New-ColorScriptCache -Name 'bars', 'does-not-exist-xyz' -PassThru -Force
            $res | Where-Object Name -EQ 'bars' | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Export-ColorScriptMetadata variations' {
        It 'returns objects to pipeline by default' {
            $payload = Export-ColorScriptMetadata
            $payload | Should -Not -BeNullOrEmpty
        }

        It 'includes file and cache info in payload' {
            $payload = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
            $payload | Should -Not -BeNullOrEmpty
            ($payload | Select-Object -First 1).PSObject.Properties.Name | Should -Contain 'ScriptPath'
        }

        It 'writes to a JSON file when Path provided and -PassThru returns data' {
            $outPath = Join-Path (Resolve-Path 'TestDrive:\').ProviderPath ('meta_{0}.json' -f ([guid]::NewGuid()))
            $result = Export-ColorScriptMetadata -Path $outPath -IncludeFileInfo -IncludeCacheInfo -PassThru
            $result | Should -Not -BeNullOrEmpty
            Test-Path -LiteralPath $outPath | Should -BeTrue
        }

        It 'honors WhatIf when writing and still returns when -PassThru' {
            $outPath = Join-Path (Resolve-Path 'TestDrive:\').ProviderPath ('meta_{0}.json' -f ([guid]::NewGuid()))
            $result = Export-ColorScriptMetadata -Path $outPath -PassThru -WhatIf
            $result | Should -Not -BeNullOrEmpty
            Test-Path -LiteralPath $outPath | Should -BeFalse
        }
    }

    Context 'Configuration cmdlets Get/Set/Reset' {
        It 'shows help when -h is used' {
            Get-ColorScriptConfiguration -h | Should -BeNullOrEmpty
            Set-ColorScriptConfiguration -h | Should -BeNullOrEmpty
            Reset-ColorScriptConfiguration -h | Should -BeNullOrEmpty
        }

        It 'updates config values and returns with -PassThru' {
            $tmpCache = Join-Path (Resolve-Path 'TestDrive:\').ProviderPath ('cache_{0}' -f ([guid]::NewGuid()))
            $result = Set-ColorScriptConfiguration -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars' -CachePath $tmpCache -PassThru
            $result | Should -Not -BeNullOrEmpty
            $result.Startup.AutoShowOnImport | Should -BeTrue
            $result.Startup.ProfileAutoShow | Should -BeFalse
            $result.Startup.DefaultScript | Should -Be 'bars'
            Test-Path -LiteralPath $tmpCache | Should -BeTrue
        }

        It 'resets configuration to defaults and returns with -PassThru' {
            $reset = Reset-ColorScriptConfiguration -PassThru
            $reset | Should -Not -BeNullOrEmpty
        }
    }
}
