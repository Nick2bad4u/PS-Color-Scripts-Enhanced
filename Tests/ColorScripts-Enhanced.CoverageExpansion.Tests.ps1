# Additional coverage-oriented tests for ColorScripts-Enhanced public commands

Describe "ColorScripts-Enhanced extended coverage" {
    BeforeAll {
        $script:ModulePath = Join-Path -Path $PSScriptRoot -ChildPath "..\ColorScripts-Enhanced"
        Import-Module $script:ModulePath -Force

        $script:OriginalConfigOverride = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
        $script:OriginalCacheOverride = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
        $script:OriginalHomeEnv = $env:HOME
        $script:OriginalHomeVar = $HOME

        $moduleState = InModuleScope ColorScripts-Enhanced {
            [pscustomobject]@{
                ScriptsPath  = $script:ScriptsPath
                MetadataPath = $script:MetadataPath
                CacheDir     = $script:CacheDir
            }
        }

        $script:OriginalScriptsPath = $moduleState.ScriptsPath
        $script:OriginalMetadataPath = $moduleState.MetadataPath
        $script:OriginalCacheDir = $moduleState.CacheDir

        Set-Variable -Name __CoverageOriginalScriptsPath -Scope Global -Value $moduleState.ScriptsPath
        Set-Variable -Name __CoverageOriginalMetadataPath -Scope Global -Value $moduleState.MetadataPath
        Set-Variable -Name __CoverageOriginalCacheDir -Scope Global -Value $moduleState.CacheDir
    }

    BeforeEach {
        $script:TestRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
        New-Item -ItemType Directory -Path $script:TestRoot -Force | Out-Null

        $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $script:TestRoot
        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = Join-Path -Path $script:TestRoot -ChildPath 'cache'
        if (-not (Test-Path -LiteralPath $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH)) {
            New-Item -ItemType Directory -Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -Force | Out-Null
        }

        $env:HOME = $script:TestRoot
        Set-Variable -Name HOME -Scope Global -Force -Value $script:TestRoot

        $script:ScriptsDir = Join-Path -Path $script:TestRoot -ChildPath 'scripts'
        New-Item -ItemType Directory -Path $script:ScriptsDir -Force | Out-Null
        $script:MetadataFile = Join-Path -Path $script:TestRoot -ChildPath 'metadata.psd1'
        $script:CachePath = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH

        Set-Variable -Name __CoverageScriptsDir -Scope Global -Value $script:ScriptsDir
        Set-Variable -Name __CoverageMetadataPath -Scope Global -Value $script:MetadataFile
        Set-Variable -Name __CoverageCachePath -Scope Global -Value $script:CachePath

        $metadataCacheFile = Join-Path -Path $script:CachePath -ChildPath 'metadata.cache.json'
        if (Test-Path -LiteralPath $metadataCacheFile) {
            Remove-Item -LiteralPath $metadataCacheFile -Force
        }

        InModuleScope ColorScripts-Enhanced {
            $script:ScriptsPath = (Get-Variable -Name '__CoverageScriptsDir' -Scope Global -ValueOnly)
            $script:MetadataPath = (Get-Variable -Name '__CoverageMetadataPath' -Scope Global -ValueOnly)
            $script:CacheDir = (Get-Variable -Name '__CoverageCachePath' -Scope Global -ValueOnly)
            $script:ConfigurationRoot = $null
            $script:ConfigurationPath = $null
            $script:ConfigurationData = $null
            $script:ConfigurationInitialized = $false
            $script:CacheInitialized = $false
            AfterEach {
                if ($null -eq $script:OriginalConfigOverride) {
                    Remove-Item Env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT -ErrorAction SilentlyContinue
                }
                else {
                    $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $script:OriginalConfigOverride
                }

                if ($null -eq $script:OriginalCacheOverride) {
                    Remove-Item Env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -ErrorAction SilentlyContinue
                }
                else {
                    $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $script:OriginalCacheOverride
                }

                if ($null -eq $script:OriginalHomeEnv) {
                    Remove-Item Env:HOME -ErrorAction SilentlyContinue
                }
                else {
                    $env:HOME = $script:OriginalHomeEnv
                }

                if ($null -ne $script:OriginalHomeVar) {
                    Set-Variable -Name HOME -Scope Global -Force -Value $script:OriginalHomeVar
                }

                Remove-Variable -Name __CoverageScriptsDir -Scope Global -ErrorAction SilentlyContinue
                Remove-Variable -Name __CoverageMetadataPath -Scope Global -ErrorAction SilentlyContinue
                Remove-Variable -Name __CoverageCachePath -Scope Global -ErrorAction SilentlyContinue

                InModuleScope ColorScripts-Enhanced {
                    $script:ConfigurationRoot = $null
                    $script:ConfigurationPath = $null
                    $script:ConfigurationData = $null
                    $script:ConfigurationInitialized = $false
                    $script:CacheInitialized = $false
                    $script:CacheDir = $null
                    $script:MetadataCache = $null
                    $script:MetadataLastWriteTime = $null
                    Reset-ScriptInventoryCache
                }
            }
            $script:MetadataCache = $null
            $script:MetadataLastWriteTime = $null
            Reset-ScriptInventoryCache
        }
    }

    AfterAll {
        if ($null -ne $script:OriginalConfigOverride) {
            $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $script:OriginalConfigOverride
        }
        if ($null -ne $script:OriginalCacheOverride) {
            $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $script:OriginalCacheOverride
        }
        if ($null -ne $script:OriginalHomeEnv) {
            $env:HOME = $script:OriginalHomeEnv
        }
        if ($null -ne $script:OriginalHomeVar) {
            Set-Variable -Name HOME -Scope Global -Force -Value $script:OriginalHomeVar
        }

        InModuleScope ColorScripts-Enhanced {
            $script:ScriptsPath = (Get-Variable -Name '__CoverageOriginalScriptsPath' -Scope Global -ValueOnly)
            $script:MetadataPath = (Get-Variable -Name '__CoverageOriginalMetadataPath' -Scope Global -ValueOnly)
            $script:CacheDir = (Get-Variable -Name '__CoverageOriginalCacheDir' -Scope Global -ValueOnly)
            Reset-ScriptInventoryCache
        }

        Remove-Variable -Name __CoverageOriginalScriptsPath -Scope Global -ErrorAction SilentlyContinue
        Remove-Variable -Name __CoverageOriginalMetadataPath -Scope Global -ErrorAction SilentlyContinue
        Remove-Variable -Name __CoverageOriginalCacheDir -Scope Global -ErrorAction SilentlyContinue

        Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue
    }

    Context "Clear-ColorScriptCache" {
        BeforeEach {
            $script:CacheWarnings = @()
            InModuleScope ColorScripts-Enhanced {
                $script:CacheDir = (Get-Variable -Name '__CoverageCachePath' -Scope Global -ValueOnly)
                $script:CacheInitialized = $true
            }
            Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { }
            Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith { @() }
        }

        It "shows help when requested" {
            Mock -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced -MockWith { param($CommandName) $script:HelpCommand = $CommandName }

            Clear-ColorScriptCache -h

            $script:HelpCommand | Should -Be 'Clear-ColorScriptCache'
        }

        It "throws when neither name nor all is provided" {
            $errorRecord = $null
            try {
                Clear-ColorScriptCache
            }
            catch {
                $errorRecord = $_
            }

            $errorRecord | Should -Not -BeNullOrEmpty
            $errorRecord.Exception.Message | Should -Be 'Specify -All or -Name to clear cache entries.'
        }

        It "removes a specific cache file" {
            $cacheFile = Join-Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH 'alpha.cache'
            Set-Content -LiteralPath $cacheFile -Value 'cached data'

            $result = Clear-ColorScriptCache -Name 'alpha'

            Test-Path -LiteralPath $cacheFile | Should -BeFalse
            $result.Status | Should -Contain 'Removed'
        }

        It "supports dry-run mode" {
            $cacheFile = Join-Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH 'alpha.cache'
            Set-Content -LiteralPath $cacheFile -Value 'cached data'

            $result = Clear-ColorScriptCache -Name 'alpha' -DryRun

            Test-Path -LiteralPath $cacheFile | Should -BeTrue
            $result.Status | Should -Contain 'DryRun'
        }

        It "reports missing cache entries" {
            $result = Clear-ColorScriptCache -Name 'unknown'

            ($result | Where-Object { $_.Name -eq 'unknown' }).Status | Should -Contain 'Missing'
        }

        It "surfaces removal errors" {
            $cacheFile = Join-Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH 'alpha.cache'
            Set-Content -LiteralPath $cacheFile -Value 'cached data'
            Mock -CommandName Remove-Item -ModuleName ColorScripts-Enhanced -MockWith { throw 'remove failure' }

            $result = Clear-ColorScriptCache -Name 'alpha'

            ($result | Where-Object { $_.Name -eq 'alpha' }).Status | Should -Contain 'Error'
        }

        It "warns when cache path is missing" {
            Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith { param($Message) $script:CacheWarnings += $Message }
            $result = Clear-ColorScriptCache -All -Path (Join-Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH 'missing-subdir')

            ($script:CacheWarnings | Where-Object { $_ -like 'Cache path not found*' }).Count | Should -BeGreaterThan 0
            $result.Count | Should -Be 0
        }

        It "clears all cache files" {
            $alpha = Join-Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH 'alpha.cache'
            $beta = Join-Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH 'beta.cache'
            Set-Content -LiteralPath $alpha -Value 'alpha'
            Set-Content -LiteralPath $beta -Value 'beta'

            $result = Clear-ColorScriptCache -All

            (Test-Path -LiteralPath $alpha) | Should -BeFalse
            (Test-Path -LiteralPath $beta) | Should -BeFalse
            ($result | Where-Object { $_.Name -eq 'alpha' }).Status | Should -Contain 'Removed'
        }

        It "warns when clearing all but no files exist" {
            Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith { param($Message) $script:CacheWarnings += $Message }
            Get-ChildItem -LiteralPath $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -Filter '*.cache' -ErrorAction SilentlyContinue | Remove-Item -Force

            $result = Clear-ColorScriptCache -All

            ($script:CacheWarnings | Where-Object { $_ -like 'No cache files found*' }).Count | Should -BeGreaterThan 0
            $result.Count | Should -Be 0
        }

        It "skips entries that do not satisfy filters" {
            Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                @([pscustomobject]@{ Name = 'alpha' })
            }
            Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith { param($Message) $script:CacheWarnings += $Message }

            $result = Clear-ColorScriptCache -Name 'beta' -Category 'Test'

            ($script:CacheWarnings | Where-Object { $_ -like "Script 'beta' does not satisfy*" }).Count | Should -BeGreaterThan 0
            $result.Count | Should -Be 0
        }

        It "selects filtered entries automatically when using -All" {
            $alpha = Join-Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH 'alpha.cache'
            $beta = Join-Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH 'beta.cache'
            Set-Content -LiteralPath $alpha -Value 'alpha'
            Set-Content -LiteralPath $beta -Value 'beta'

            Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                @([pscustomobject]@{ Name = 'alpha' }, [pscustomobject]@{ Name = 'beta' })
            }

            $result = Clear-ColorScriptCache -All -Category 'Test'

            (Test-Path -LiteralPath $alpha) | Should -BeFalse
            (Test-Path -LiteralPath $beta) | Should -BeFalse
            $result.Status | Should -Not -BeNullOrEmpty
        }

        It "warns when filters match no scripts" {
            Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith { param($Message) $script:CacheWarnings += $Message }
            $result = Clear-ColorScriptCache -Category 'Empty'

            ($script:CacheWarnings | Where-Object { $_ -like 'No scripts matched*' }).Count | Should -BeGreaterThan 0
            $result.Count | Should -Be 0
        }

        It "respects -WhatIf by skipping removal" {
            $cacheFile = Join-Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH 'alpha.cache'
            Set-Content -LiteralPath $cacheFile -Value 'alpha'

            $result = Clear-ColorScriptCache -Name 'alpha' -WhatIf

            Test-Path -LiteralPath $cacheFile | Should -BeTrue
            ($result | Where-Object { $_.Name -eq 'alpha' }).Status | Should -Contain 'SkippedByUser'
        }

        AfterEach {
            Get-ChildItem -LiteralPath $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -Filter '*.cache' -ErrorAction SilentlyContinue | Remove-Item -Force
        }
    }

    Context "Export-ColorScriptMetadata" {
        It "writes metadata with file and cache details" {
            $scriptPath = Join-Path -Path $script:ScriptsDir -ChildPath 'export.ps1'
            Set-Content -LiteralPath $scriptPath -Value "Write-Output 'export'" -Encoding UTF8

            $outputFile = Join-Path -Path $script:TestRoot -ChildPath 'metadata.json'

            $result = Export-ColorScriptMetadata -Path $outputFile -IncludeFileInfo -IncludeCacheInfo -PassThru

            $result | Should -Not -BeNullOrEmpty
            Test-Path -LiteralPath $outputFile | Should -BeTrue
        }

        It "throws when the output path is unresolved" {
            Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith { $null } -ParameterFilter { $Path -eq '::invalid::' }

            $caught = $null
            try {
                Export-ColorScriptMetadata -Path '::invalid::'
            }
            catch {
                $caught = $_
            }

            $caught | Should -Not -BeNullOrEmpty
            $caught.Exception.Message | Should -Be "Unable to resolve output path '::invalid::'."
        }
    }

    Context "Get-ColorScriptMetadataTable" {
        It "builds metadata from PSD1 and saves JSON cache" {
            $scriptsDir = $script:ScriptsDir
            $metadataPath = $script:MetadataFile

            $metadataPath | Should -Not -BeNullOrEmpty

            foreach ($name in @('aurora-bands', 'autoflow', 'plain1', 'num123')) {
                $scriptPath = Join-Path -Path $scriptsDir -ChildPath "$name.ps1"
                Set-Content -LiteralPath $scriptPath -Value "Write-Output '$name'" -Encoding UTF8
            }

            $metadataContent = @"
@{
    Categories = @{
        Nature  = @('aurora-bands')
        Special = @('plain1')
    }
    Difficulty = @{ Beginner = @('aurora-bands') }
    Complexity = @{ Moderate = @('aurora-bands') }
    Recommended = @('aurora-bands')
    Tags = @{
        'aurora-bands' = @('Aurora', 'Sky')
        'plain1'       = 'PlainTag'
    }
    Descriptions = @{
        'aurora-bands' = 'Beautiful aurora'
        'plain1'       = 'Plain description'
    }
    AutoCategories = @(
        @{ Category = 'AutoMagic'; Patterns = 'auto.*'; Tags = @('AutoTag','Magic') }
        @{ Category = 'Numeric';   Patterns = '.*123$';  Tags = 'NumberTag' }
    )
}
"@

            Set-Content -LiteralPath $metadataPath -Value $metadataContent -Encoding UTF8

            InModuleScope ColorScripts-Enhanced {
                Reset-ScriptInventoryCache
                $script:CacheInitialized = $true

                $result = Get-ColorScriptMetadataTable

                $result.Keys | Should -Contain 'aurora-bands'
                $result['aurora-bands'].Tags | Should -Contain 'Category:Nature'
                $result['autoflow'].Categories | Should -Contain 'AutoMagic'
                $result['num123'].Tags | Should -Contain 'NumberTag'

                $jsonPath = Join-Path -Path $script:CacheDir -ChildPath 'metadata.cache.json'
                Test-Path -LiteralPath $jsonPath | Should -BeTrue
            }
        }

        It "returns cached metadata when timestamp is unchanged" {
            $scriptsDir = $script:ScriptsDir
            $metadataPath = $script:MetadataFile

            New-Item -ItemType File -Path (Join-Path -Path $scriptsDir -ChildPath 'cached.ps1') -Force | Out-Null
            $metadataContent = @'
@{
    Categories = @{
        Abstract = @("cached")
    }
}
'@
            [System.IO.File]::WriteAllText($metadataPath, $metadataContent, [System.Text.Encoding]::UTF8)

            $result = InModuleScope ColorScripts-Enhanced {
                Reset-ScriptInventoryCache
                $script:CacheInitialized = $true
                $first = Get-ColorScriptMetadataTable
                $first['cached'].Description = 'cached description'
                $second = Get-ColorScriptMetadataTable
                [pscustomobject]@{
                    First  = $first
                    Second = $second
                }
            }

            $result.Second['cached'].Description | Should -Be 'cached description'
            [object]::ReferenceEquals($result.Second, $result.First) | Should -BeTrue
        }

        It "loads from JSON cache when in-memory cache is cleared" {
            $scriptsDir = $script:ScriptsDir
            $metadataPath = $script:MetadataFile

            New-Item -ItemType File -Path (Join-Path -Path $scriptsDir -ChildPath 'jsonload.ps1') -Force | Out-Null
            Set-Content -LiteralPath $metadataPath -Value "@{ Categories = @{ Demo = @('jsonload') } }" -Encoding UTF8

            InModuleScope ColorScripts-Enhanced {
                Reset-ScriptInventoryCache
                $script:CacheInitialized = $true

                $initial = Get-ColorScriptMetadataTable
                $initial['jsonload'].Tags | Should -Contain 'Category:Demo'

                $script:MetadataCache = $null
                $script:MetadataLastWriteTime = $null

                $loaded = Get-ColorScriptMetadataTable
                $loaded['jsonload'].Tags | Should -Contain 'Category:Demo'
            }
        }

        It "rebuilds metadata when JSON cache is invalid" {
            $scriptsDir = $script:ScriptsDir
            $metadataPath = $script:MetadataFile

            New-Item -ItemType File -Path (Join-Path -Path $scriptsDir -ChildPath 'invalidjson.ps1') -Force | Out-Null
            Set-Content -LiteralPath $metadataPath -Value "@{ Categories = @{ Demo = @('invalidjson') } }" -Encoding UTF8

            InModuleScope ColorScripts-Enhanced {
                Reset-ScriptInventoryCache
                $script:CacheInitialized = $true

                [void] (Get-ColorScriptMetadataTable)

                $jsonPath = Join-Path -Path $script:CacheDir -ChildPath 'metadata.cache.json'
                Set-Content -LiteralPath $jsonPath -Value '{ invalid json' -Encoding UTF8

                $script:MetadataCache = $null
                $script:MetadataLastWriteTime = $null

                $result = Get-ColorScriptMetadataTable
                $result['invalidjson'].Category | Should -Be 'Demo'
            }
        }

        It "logs and continues when metadata timestamp cannot be determined" {
            $scriptsDir = $script:ScriptsDir
            $metadataPath = $script:MetadataFile

            New-Item -ItemType File -Path (Join-Path -Path $scriptsDir -ChildPath 'timestamp.ps1') -Force | Out-Null
            Set-Content -LiteralPath $metadataPath -Value "@{ Categories = @{ Demo = @('timestamp') } }" -Encoding UTF8

            InModuleScope ColorScripts-Enhanced {
                Reset-ScriptInventoryCache
                $script:CacheInitialized = $true

                Mock -CommandName Get-Item -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'metadata broken'
                } -ParameterFilter {
                    $LiteralPath -eq (Get-Variable -Name '__CoverageMetadataPath' -Scope Global -ValueOnly)
                }

                { Get-ColorScriptMetadataTable } | Should -Not -Throw
            }
        }

        It "handles missing metadata file using defaults" {
            $scriptsDir = $script:ScriptsDir

            New-Item -ItemType File -Path (Join-Path -Path $scriptsDir -ChildPath 'fallback.ps1') -Force | Out-Null

            InModuleScope ColorScripts-Enhanced {
                Reset-ScriptInventoryCache
                $script:CacheInitialized = $true
                $script:MetadataPath = Join-Path -Path (Get-Variable -Name '__CoverageScriptsDir' -Scope Global -ValueOnly) -ChildPath 'missing-metadata.psd1'

                $result = Get-ColorScriptMetadataTable
                $result['fallback'].Category | Should -Be 'Abstract'
                $result['fallback'].Tags | Should -Contain 'AutoCategorized'
            }
        }

        It "continues when JSON cache save fails" {
            $scriptsDir = $script:ScriptsDir
            $metadataPath = $script:MetadataFile

            New-Item -ItemType File -Path (Join-Path -Path $scriptsDir -ChildPath 'saveskip.ps1') -Force | Out-Null
            Set-Content -LiteralPath $metadataPath -Value "@{ Categories = @{ Demo = @('saveskip') } }" -Encoding UTF8

            InModuleScope ColorScripts-Enhanced {
                Reset-ScriptInventoryCache
                $script:CacheInitialized = $true

                Mock -CommandName Set-Content -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'disk full'
                } -ParameterFilter { $LiteralPath -like '*metadata.cache.json' }

                { Get-ColorScriptMetadataTable } | Should -Not -Throw
            }
        }

        It "normalizes metadata values expressed as strings" {
            $scriptsDir = $script:ScriptsDir
            $metadataPath = $script:MetadataFile

            foreach ($name in @('stringcat', 'stringauto', 'nometa')) {
                New-Item -ItemType File -Path (Join-Path -Path $scriptsDir -ChildPath "${name}.ps1") -Force | Out-Null
            }

            $metadataContent = @'
@{
    Categories = @{
        SingleCategory = 'stringcat'
    }
    Tags = @{
        'stringcat' = 'ManualTag'
    }
    AutoCategories = @(
        @{ Category = 'AutoSingle'; Patterns = 'stringauto'; Tags = 'AutoTagSingle' }
    )
}
'@
            [System.IO.File]::WriteAllText($metadataPath, $metadataContent, [System.Text.Encoding]::UTF8)

            $result = InModuleScope ColorScripts-Enhanced {
                Reset-ScriptInventoryCache
                $script:CacheInitialized = $true
                $table = Get-ColorScriptMetadataTable
                [pscustomobject]@{
                    StringCat  = $table['stringcat']
                    StringAuto = $table['stringauto']
                    NoMeta     = $table['nometa']
                }
            }

            $result.StringCat.Categories | Should -Be @('SingleCategory')
            $result.StringCat.Tags | Should -Contain 'ManualTag'

            $result.StringAuto.Categories | Should -Contain 'AutoSingle'
            $result.StringAuto.Tags | Should -Contain 'AutoTagSingle'
            $result.StringAuto.Tags | Should -Contain 'Category:AutoSingle'

            $result.NoMeta.Category | Should -Be 'Abstract'
            $result.NoMeta.Tags | Should -Contain 'AutoCategorized'
        }
    }

    Context "Show-ColorScript" {
        BeforeEach {
            $script:RenderedOutputs = @()
            $script:Warnings = @()
            $script:SleepLog = @()
            $script:ListParams = $null

            Mock -CommandName Write-Host -ModuleName ColorScripts-Enhanced -MockWith { } -Verifiable:$false
            Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith {
                param($Message)
                $script:Warnings += $Message
            }
            Mock -CommandName Clear-Host -ModuleName ColorScripts-Enhanced -MockWith { }
            Mock -CommandName Start-Sleep -ModuleName ColorScripts-Enhanced -MockWith {
                param([int]$Milliseconds)
                $script:SleepLog += $Milliseconds
            }
            Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { }
            Mock -CommandName Get-ColorScriptList -ModuleName ColorScripts-Enhanced -MockWith {
                param($Category, $Tag)
                $script:ListParams = @{ Category = $Category; Tag = $Tag }
                @()
            }
            Mock -CommandName Get-ColorScriptInventory -ModuleName ColorScripts-Enhanced -MockWith {
                @(
                    [pscustomobject]@{ Name = 'alpha-one'; Path = 'C:\scripts\alpha-one.ps1' }
                    [pscustomobject]@{ Name = 'alpha-two'; Path = 'C:\scripts\alpha-two.ps1' }
                )
            }
            Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                @(
                    [pscustomobject]@{
                        Name        = 'alpha-one'
                        Path        = 'C:\scripts\alpha-one.ps1'
                        Category    = 'CategoryA'
                        Categories  = @('CategoryA')
                        Tags        = @('Category:CategoryA')
                        Description = 'First entry'
                        Metadata    = $null
                    }
                    [pscustomobject]@{
                        Name        = 'alpha-two'
                        Path        = 'C:\scripts\alpha-two.ps1'
                        Category    = 'CategoryB'
                        Categories  = @('CategoryB')
                        Tags        = @('Category:CategoryB')
                        Description = 'Second entry'
                        Metadata    = $null
                    }
                )
            }
            Mock -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Available = $false; Content = $null }
            }
            Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Success = $true; StdOut = 'built output'; StdErr = ''; ExitCode = 0 }
            }
            Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Success = $true; StdOut = 'process output'; StdErr = ''; ExitCode = 0 }
            }
            Mock -CommandName Invoke-WithUtf8Encoding -ModuleName ColorScripts-Enhanced -MockWith {
                param($ScriptBlock, [object[]]$Arguments)
                & $ScriptBlock @Arguments
            }
            Mock -CommandName Write-RenderedText -ModuleName ColorScripts-Enhanced -MockWith {
                param($Text)
                $script:RenderedOutputs += $Text
            }
        }

        It "lists scripts when requested" {
            Show-ColorScript -List -Category 'Nature' -Tag 'Bright'

            $script:ListParams.Category | Should -Be 'Nature'
            $script:ListParams.Tag | Should -Be 'Bright'
        }

        It "shows command help when requested" {
            Mock -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced -MockWith {
                param($CommandName)
                $script:HelpCalled = $CommandName
            }

            Show-ColorScript -h

            $script:HelpCalled | Should -Be 'Show-ColorScript'
        }

        It "returns cached output when available and passes through metadata" {
            Mock -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Available = $true; Content = 'cached output' }
            }

            $originalVerbose = $VerbosePreference
            $VerbosePreference = 'Continue'
            try {
                $result = Show-ColorScript -Name 'alpha*' -PassThru
            }
            finally {
                $VerbosePreference = $originalVerbose
            }

            Assert-MockCalled -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -Times 0
            ($script:RenderedOutputs | Select-Object -First 1) | Should -Be 'cached output'
            $result.Name | Should -Be 'alpha-one'
        }

        It "builds cache when cached output is missing" {
            $null = Show-ColorScript -Name 'alpha-one'

            Assert-MockCalled -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -Times 1
            ($script:RenderedOutputs | Select-Object -First 1) | Should -Be 'built output'
        }

        It "falls back to stdout when cache build reports failure" {
            Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Success = $false; StdOut = 'fallback output'; StdErr = 'simulated failure'; ExitCode = 1 }
            }

            $null = Show-ColorScript -Name 'alpha-one'

            ($script:Warnings -join [Environment]::NewLine) | Should -Match 'simulated failure'
            ($script:RenderedOutputs | Select-Object -First 1) | Should -Be 'fallback output'
        }

        It "throws when cache build fails without output" {
            Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Success = $false; StdOut = ''; StdErr = ''; ExitCode = 2 }
            }

            $caught = $null
            try {
                Show-ColorScript -Name 'alpha-one' | Out-Null
            }
            catch {
                $caught = $_
            }

            $caught | Should -Not -BeNullOrEmpty
        }

        It "executes script directly when NoCache is specified" {
            Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Success = $true; StdOut = 'direct output'; StdErr = ''; ExitCode = 0 }
            }

            $null = Show-ColorScript -Name 'alpha-one' -NoCache

            ($script:RenderedOutputs | Select-Object -First 1) | Should -Be 'direct output'
            Assert-MockCalled -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -Times 0
        }

        It "throws when direct execution fails" {
            Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Success = $false; StdOut = ''; StdErr = 'runtime error'; ExitCode = 3 }
            }

            $caught = $null
            try {
                Show-ColorScript -Name 'alpha-one' -NoCache | Out-Null
            }
            catch {
                $caught = $_
            }

            $caught | Should -Not -BeNullOrEmpty
            $caught.Exception.Message | Should -Match 'runtime error'
        }

        It "emits rendered text to the pipeline when ReturnText is used" {
            Mock -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Available = $true; Content = 'pipeline output' }
            }

            $output = Show-ColorScript -Name 'alpha-one' -ReturnText

            $output | Should -Be 'pipeline output'
        }

        It "cycles through all scripts without waiting for input" {
            Show-ColorScript -All

            Assert-MockCalled -CommandName Get-ColorScriptInventory -ModuleName ColorScripts-Enhanced -Times 1
            ($script:RenderedOutputs | Select-Object -First 1) | Should -Be 'built output'
            $script:SleepLog.Count | Should -BeGreaterThan 0
        }

        It "supports wait-for-input navigation and quit shortcut" {
            Mock -CommandName Get-ColorScriptInventory -ModuleName ColorScripts-Enhanced -MockWith {
                @(
                    [pscustomobject]@{ Name = 'alpha-one'; Path = 'C:\scripts\alpha-one.ps1' }
                    [pscustomobject]@{ Name = 'alpha-two'; Path = 'C:\scripts\alpha-two.ps1' }
                    [pscustomobject]@{ Name = 'alpha-three'; Path = 'C:\scripts\alpha-three.ps1' }
                )
            }

            InModuleScope ColorScripts-Enhanced {
                $script:ReadKeyQueue = [System.Collections.Generic.Queue[object]]::new()
                $script:ReadKeyQueue.Enqueue([pscustomobject]@{ VirtualKeyCode = 32; Character = ' ' })
                $script:ReadKeyQueue.Enqueue([pscustomobject]@{ VirtualKeyCode = 81; Character = 'q' })

                $rawUI = $Host.UI.RawUI
                $rawUI | Add-Member -MemberType ScriptMethod -Name ReadKey -Force -Value {
                    param($Options)
                    $null = $Options  # Parameter required for ReadKey signature compatibility
                    if ($script:ReadKeyQueue.Count -gt 0) {
                        return $script:ReadKeyQueue.Dequeue()
                    }
                    return [pscustomobject]@{ VirtualKeyCode = 81; Character = 'q' }
                }
            }

            Show-ColorScript -All -WaitForInput

            $script:RenderedOutputs.Count | Should -BeGreaterThan 0
        }

        It "filters all scripts and warns when no matches" {
            Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith { @() }

            Show-ColorScript -All -Category 'Custom'

            ($script:Warnings -join [Environment]::NewLine) | Should -Match 'specified criteria'
        }

        It "uses cached output when cycling all scripts" {
            Mock -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Available = $true; Content = 'all cached output' }
            }

            Show-ColorScript -All

            ($script:RenderedOutputs | Select-Object -First 1) | Should -Be 'all cached output'
        }

        It "executes all scripts directly when NoCache is set" {
            Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Success = $true; StdOut = 'all direct output'; StdErr = ''; ExitCode = 0 }
            }

            Show-ColorScript -All -NoCache

            ($script:RenderedOutputs | Select-Object -First 1) | Should -Be 'all direct output'
        }

        It "selects a random script when requested" {
            Mock -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Available = $true; Content = 'random output' }
            }

            Show-ColorScript -Random

            ($script:RenderedOutputs | Select-Object -First 1) | Should -Be 'random output'
        }

        It "defaults to the first script when metadata filtering is applied" {
            Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                @(
                    [pscustomobject]@{
                        Name        = 'cat-one'
                        Path        = 'C:\scripts\cat-one.ps1'
                        Category    = 'CategoryA'
                        Categories  = @('CategoryA')
                        Tags        = @('Category:CategoryA')
                        Description = 'First filtered entry'
                        Metadata    = $null
                    }
                    [pscustomobject]@{
                        Name        = 'cat-two'
                        Path        = 'C:\scripts\cat-two.ps1'
                        Category    = 'CategoryA'
                        Categories  = @('CategoryA')
                        Tags        = @('Category:CategoryA')
                        Description = 'Second filtered entry'
                        Metadata    = $null
                    }
                )
            }

            Mock -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Available = $true; Content = 'default output' }
            }

            Show-ColorScript -Category 'CategoryA'

            ($script:RenderedOutputs | Select-Object -First 1) | Should -Be 'default output'
        }

        It "warns when no scripts are available" {
            Mock -CommandName Get-ColorScriptInventory -ModuleName ColorScripts-Enhanced -MockWith { @() }

            Show-ColorScript

            ($script:Warnings -join [Environment]::NewLine) | Should -Match 'No colorscripts found'
        }

        It "warns when requested names are missing" {
            Show-ColorScript -Name 'missing*'

            ($script:Warnings -join [Environment]::NewLine) | Should -Match 'missing'
        }

        It "reports exit code when direct execution fails without stderr" {
            Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Success = $false; StdOut = ''; StdErr = ''; ExitCode = 42 }
            }

            $caught = $null
            try {
                Show-ColorScript -Name 'alpha-one' -NoCache
            }
            catch {
                $caught = $_
            }

            $caught.Exception.Message | Should -Match '42'
        }

        It "normalizes null rendered output to empty text" {
            Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Success = $true; StdOut = $null; StdErr = ''; ExitCode = 0 }
            }

            Show-ColorScript -Name 'alpha-one'

            ($script:RenderedOutputs | Select-Object -First 1) | Should -Be ''
        }

        AfterEach {
            InModuleScope ColorScripts-Enhanced {
                if ($Host.UI.RawUI.PSObject.Methods['ReadKey'] -and $Host.UI.RawUI.PSObject.Methods['ReadKey'].MemberType -eq 'ScriptMethod') {
                    $Host.UI.RawUI.PSObject.Methods.Remove('ReadKey') | Out-Null
                }
                if ($script:ReadKeyQueue) {
                    Remove-Variable -Name ReadKeyQueue -Scope Script -ErrorAction SilentlyContinue
                }
            }
        }
    }
}
