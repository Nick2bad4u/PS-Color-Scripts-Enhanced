# Additional coverage-oriented tests for ColorScripts-Enhanced public commands

Describe "ColorScripts-Enhanced extended coverage" {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModulePath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModulePath -ChildPath 'ColorScripts-Enhanced.psd1'
        $script:OriginalModuleRootOverride = $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT
        $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT = $script:ModulePath
        Import-Module $script:ModuleManifest -Force

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

        if ($null -ne $script:OriginalModuleRootOverride) {
            $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT = $script:OriginalModuleRootOverride
        }
        else {
            Remove-Item Env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT -ErrorAction SilentlyContinue
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
            $caught.FullyQualifiedErrorId | Should -Match '^ColorScriptsEnhanced.InvalidOutputPath'
            $caught.CategoryInfo.Category | Should -Be ([System.Management.Automation.ErrorCategory]::InvalidArgument)
            $caught.Exception.Message | Should -Be "Unable to resolve output path '::invalid::'."
        }

        It "shows help when requested" {
            Mock -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced

            Export-ColorScriptMetadata -h

            Assert-MockCalled -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced -Times 1 -ParameterFilter { $CommandName -eq 'Export-ColorScriptMetadata' }
        }

        It "continues when file info cannot be retrieved" {
            $unavailablePath = 'Z:\nonexistent\failinfo.ps1'

            $capturedVerbose = [System.Collections.Generic.List[string]]::new()

            Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                @([pscustomobject]@{
                        Name        = 'failinfo'
                        Path        = $unavailablePath
                        Category    = 'Demo'
                        Categories  = @('Demo')
                        Tags        = @('Demo')
                        Description = 'demo'
                    })
            }

            Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                param($Message)
                $null = $capturedVerbose.Add($Message)
            }

            $result = Export-ColorScriptMetadata -IncludeFileInfo -PassThru

            $result | Should -HaveCount 1
            $result[0].ScriptPath | Should -Be $unavailablePath
            $result[0].ScriptSizeBytes | Should -Be $null
            $result[0].ScriptLastWriteTimeUtc | Should -Be $null
            ($capturedVerbose | Where-Object { $_ -like "Unable to retrieve file info for 'failinfo'*" }) | Should -Not -BeNullOrEmpty
        }

        It "includes cache metadata when available" {
            $scriptPath = Join-Path -Path $script:ScriptsDir -ChildPath 'cacheerr.ps1'
            Set-Content -LiteralPath $scriptPath -Value "Write-Host 'cacheerr'" -Encoding UTF8

            $cacheDirectory = InModuleScope ColorScripts-Enhanced {
                Initialize-CacheDirectory
                $script:CacheDir
            }

            $cachePath = Join-Path -Path $cacheDirectory -ChildPath 'cacheerr.cache'
            Set-Content -LiteralPath $cachePath -Value 'cached' -Encoding UTF8

            InModuleScope ColorScripts-Enhanced -Parameters @{ testScriptPath = $scriptPath; testCachePath = $cachePath } {
                param($testScriptPath, $testCachePath)
                [void]$testScriptPath
                [void]$testCachePath
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    @([pscustomobject]@{
                            Name        = 'cacheerr'
                            Path        = $testScriptPath
                            Category    = 'Demo'
                            Categories  = @('Demo')
                            Tags        = @('Demo')
                            Description = 'demo'
                        })
                }

                $result = Export-ColorScriptMetadata -IncludeCacheInfo -PassThru

                $result | Should -HaveCount 1
                $result[0].CachePath | Should -Match 'cacheerr.cache'
                $result[0].CacheExists | Should -BeTrue
                $result[0].CacheLastWriteTimeUtc | Should -BeGreaterThan ([datetime]::MinValue)
            }
        }

        It "creates the output directory when exporting to a file" {
            $scriptPath = Join-Path -Path $script:ScriptsDir -ChildPath 'dircreate.ps1'
            Set-Content -LiteralPath $scriptPath -Value "Write-Host 'dircreate'" -Encoding UTF8

            Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                @([pscustomobject]@{
                        Name        = 'dircreate'
                        Path        = $scriptPath
                        Category    = 'Demo'
                        Categories  = @('Demo')
                        Tags        = @('Demo')
                        Description = 'demo'
                    })
            }

            $targetDir = Join-Path -Path $script:TestRoot -ChildPath ([guid]::NewGuid().ToString())
            $outputPath = Join-Path -Path $targetDir -ChildPath 'export.json'

            $payload = Export-ColorScriptMetadata -Path $outputPath -PassThru

            Test-Path -LiteralPath $targetDir | Should -BeTrue
            Test-Path -LiteralPath $outputPath | Should -BeTrue
            $payload | Should -HaveCount 1
        }

        It "honors WhatIf when exporting metadata to a file" {
            $scriptPath = Join-Path -Path $script:ScriptsDir -ChildPath 'export-whatif.ps1'
            Set-Content -LiteralPath $scriptPath -Value "Write-Output 'whatif'" -Encoding UTF8

            $targetDir = Join-Path -Path $script:TestRoot -ChildPath ([guid]::NewGuid().ToString())
            $outputPath = Join-Path -Path $targetDir -ChildPath 'metadata.json'

            $result = Export-ColorScriptMetadata -Path $outputPath -PassThru -WhatIf

            $result | Should -Not -BeNullOrEmpty
            Test-Path -LiteralPath $targetDir | Should -BeFalse
            Test-Path -LiteralPath $outputPath | Should -BeFalse
        }

        It "defers export when directory creation is declined" {
            $scriptPath = Join-Path -Path $script:ScriptsDir -ChildPath 'export-shouldprocess.ps1'
            Set-Content -LiteralPath $scriptPath -Value "Write-Output 'shouldprocess'" -Encoding UTF8

            $targetDir = Join-Path -Path $script:TestRoot -ChildPath ([guid]::NewGuid().ToString())
            $outputPath = Join-Path -Path $targetDir -ChildPath 'metadata.json'
            $callLog = [System.Collections.Generic.List[string]]::new()

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ Path = $outputPath; Log = $callLog } {
                param($Path, $Log)
                $script:ShouldProcessOverride = {
                    param($cmdlet, $target, $action)
                    $null = $Log.Add("${action}:${target}")
                    switch ($action) {
                        'Create export directory' { return $false }
                        default { return $true }
                    }
                }

                try {
                    Export-ColorScriptMetadata -Path $Path -PassThru
                }
                finally {
                    $script:ShouldProcessOverride = $null
                }
            }

            $result | Should -Not -BeNullOrEmpty
            $normalizedLog = $callLog | ForEach-Object { $_.ToLowerInvariant() }
            $normalizedLog | Should -Contain ('export colorscript metadata:{0}' -f $outputPath.ToLowerInvariant())
            $normalizedLog | Should -Contain ('create export directory:{0}' -f $targetDir.ToLowerInvariant())
            Test-Path -LiteralPath $targetDir | Should -BeFalse
            Test-Path -LiteralPath $outputPath | Should -BeFalse
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
            Set-Content -LiteralPath (Join-Path -Path $scriptsDir -ChildPath 'cached.ps1') -Value "Write-Host 'cached script'" -Encoding UTF8
            $metadataContent = @'
@{
    Categories = @{
        Abstract = @("cached")
    }

    Context "Resolve-CachePath delegate scenarios" {
        It "uses HOME fallback when user profile delegate unavailable" {
            $customHome = Join-Path -Path $script:TestRoot -ChildPath 'home-fallback'
            New-Item -ItemType Directory -Path $customHome -Force | Out-Null

            $previousHome = $HOME
            $previousEnvHome = $env:HOME
            $originalDelegate = InModuleScope ColorScripts-Enhanced {
                $script:GetUserProfilePathDelegate
            }

            try {
                Set-Variable -Name HOME -Scope Global -Force -Value $customHome
                $env:HOME = $customHome

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ expectedHome = $customHome } {
                    param($expectedHome)
                    $script:GetUserProfilePathDelegate = { $null }
                    Resolve-CachePath -Path '~'
                }

                $result | Should -Be $customHome
            }
            finally {
                Set-Variable -Name HOME -Scope Global -Force -Value $previousHome
                $env:HOME = $previousEnvHome
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:GetUserProfilePathDelegate = $delegate
                }
            }
        }

        It "returns null when provider path and current directory unavailable" {
            $originalProvider = InModuleScope ColorScripts-Enhanced { $script:GetCurrentProviderPathDelegate }
            $originalCurrent = InModuleScope ColorScripts-Enhanced { $script:GetCurrentDirectoryDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:GetCurrentProviderPathDelegate = {
                        throw [System.Management.Automation.RuntimeException]::new('missing provider path')
                    }
                    $script:GetCurrentDirectoryDelegate = {
                        throw [System.IO.IOException]::new('missing directory path')
                    }
                }

                $result = InModuleScope ColorScripts-Enhanced {
                    Resolve-CachePath -Path 'relative\cache'
                }

                $result | Should -Be $null
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ provider = $originalProvider; current = $originalCurrent } {
                    param($provider, $current)
                    $script:GetCurrentProviderPathDelegate = $provider
                    $script:GetCurrentDirectoryDelegate = $current
                }
            }
        }

        It "handles full path failures gracefully" {
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:GetFullPathDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:GetFullPathDelegate = {
                        param($path)
                        throw [System.Exception]::new('full-path failure')
                    }
                }

                $result = InModuleScope ColorScripts-Enhanced {
                    Resolve-CachePath -Path 'relative\cache'
                }

                $result | Should -Be $null
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:GetFullPathDelegate = $delegate
                }
            }
        }

        It "continues when qualifier resolution fails" {
            Mock -CommandName Split-Path -ModuleName ColorScripts-Enhanced -MockWith {
                throw [System.Management.Automation.RuntimeException]::new('qualifier failure')
            } -ParameterFilter { $Qualifier }

            Push-Location -LiteralPath $script:TestRoot
            try {
                $expected = Join-Path -Path (Get-Location).ProviderPath -ChildPath 'relative\cache'

                $result = InModuleScope ColorScripts-Enhanced {
                    Resolve-CachePath -Path 'relative\cache'
                }

                $result | Should -Be $expected
            }
            finally {
                Pop-Location
                Remove-Mock -CommandName Split-Path -ModuleName ColorScripts-Enhanced
            }
        }

        It "returns null when path rooted check fails" {
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:IsPathRootedDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:IsPathRootedDelegate = {
                        param($path)
                        throw [System.Exception]::new('rooted failure')
                    }
                }

                $result = InModuleScope ColorScripts-Enhanced {
                    Resolve-CachePath -Path 'relative\cache'
                }

                $result | Should -Be $null
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:IsPathRootedDelegate = $delegate
                }
            }
        }

        It "reinitializes system delegate defaults" {
            InModuleScope ColorScripts-Enhanced {
                $script:GetUserProfilePathDelegate = $null
                $script:IsPathRootedDelegate = $null
                $script:GetFullPathDelegate = $null
                $script:GetCurrentDirectoryDelegate = $null
                $script:GetCurrentProviderPathDelegate = $null
                $script:DirectoryGetLastWriteTimeUtcDelegate = $null
                $script:FileExistsDelegate = $null
                $script:FileGetLastWriteTimeUtcDelegate = $null
                $script:FileReadAllTextDelegate = $null
                $script:GetCurrentProcessDelegate = $null
                $script:IsOutputRedirectedDelegate = $null
                $script:GetConsoleOutputEncodingDelegate = $null
                $script:SetConsoleOutputEncodingDelegate = $null
                $script:ConsoleWriteDelegate = $null
            }

            InModuleScope ColorScripts-Enhanced {
                Initialize-SystemDelegateState
            }

            InModuleScope ColorScripts-Enhanced {
                $script:GetUserProfilePathDelegate  | Should -Not -BeNullOrEmpty
                $script:IsPathRootedDelegate        | Should -Not -BeNullOrEmpty
                $script:GetFullPathDelegate         | Should -Not -BeNullOrEmpty
                $script:GetCurrentDirectoryDelegate | Should -Not -BeNullOrEmpty
                $script:GetCurrentProviderPathDelegate | Should -Not -BeNullOrEmpty
                $script:DirectoryGetLastWriteTimeUtcDelegate | Should -Not -BeNullOrEmpty
                $script:FileExistsDelegate          | Should -Not -BeNullOrEmpty
                $script:FileGetLastWriteTimeUtcDelegate | Should -Not -BeNullOrEmpty
                $script:FileReadAllTextDelegate     | Should -Not -BeNullOrEmpty
                $script:GetCurrentProcessDelegate   | Should -Not -BeNullOrEmpty
                $script:IsOutputRedirectedDelegate  | Should -Not -BeNullOrEmpty
                $script:GetConsoleOutputEncodingDelegate | Should -Not -BeNullOrEmpty
                $script:SetConsoleOutputEncodingDelegate | Should -Not -BeNullOrEmpty
                $script:ConsoleWriteDelegate        | Should -Not -BeNullOrEmpty
            }
        }

        It "expands relative home paths" {
            $previousHome = $HOME
            $previousEnvHome = $env:HOME
            Set-Variable -Name HOME -Scope Global -Force -Value $script:TestRoot
            $env:HOME = $script:TestRoot

            try {
                $result = InModuleScope ColorScripts-Enhanced {
                    Resolve-CachePath -Path '~\relative'
                }

                $result | Should -Be (Join-Path -Path $script:TestRoot -ChildPath 'relative')
            }
            finally {
                Set-Variable -Name HOME -Scope Global -Force -Value $previousHome
                $env:HOME = $previousEnvHome
            }
        }

        It "returns null for whitespace input" {
            $result = InModuleScope ColorScripts-Enhanced {
                Resolve-CachePath -Path '   '
            }

            $result | Should -Be $null
        }

        It "rejects invalid drive qualifier" {
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:IsPathRootedDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:IsPathRootedDelegate = {
                        param($path)
                        $false
                    }
                }

                $result = InModuleScope ColorScripts-Enhanced {
                    Resolve-CachePath -Path 'ZZ:\missing\dir'
                }

                $result | Should -Be $null
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:IsPathRootedDelegate = $delegate
                }
            }
        }
    }

    Context "Get-PowerShellExecutable fallbacks" {
        It "prefers pwsh when available" {
            Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith {
                [pscustomobject]@{ Path = 'C:\Program Files\PowerShell\7\pwsh.exe' }
            }

            InModuleScope ColorScripts-Enhanced {
                $script:PowerShellExecutable = $null
            }

            $result = InModuleScope ColorScripts-Enhanced {
                Get-PowerShellExecutable
            }

            $result | Should -Be 'C:\Program Files\PowerShell\7\pwsh.exe'

            Remove-Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced
        }

        It "uses command line args when process module unavailable" {
            Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith { $null }

            $processStub = [pscustomobject]@{ MainModule = $null }
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:GetCurrentProcessDelegate }

            try {
                InModuleScope ColorScripts-Enhanced -Parameters @{ stub = $processStub } {
                    param($stub)
                    $script:GetCurrentProcessDelegate = { $stub }
                    $script:PowerShellExecutable = $null
                }

                $result = InModuleScope ColorScripts-Enhanced {
                    Get-PowerShellExecutable
                }

                $result | Should -Be ([System.Environment]::GetCommandLineArgs()[0])
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:GetCurrentProcessDelegate = $delegate
                }
                Remove-Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced
            }
        }

        It "handles process retrieval exceptions" {
            Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith { $null }
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:GetCurrentProcessDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:GetCurrentProcessDelegate = {
                        throw [System.InvalidOperationException]::new('process unavailable')
                    }
                    $script:PowerShellExecutable = $null
                }

                $result = InModuleScope ColorScripts-Enhanced {
                    Get-PowerShellExecutable
                }

                $result | Should -Be ([System.Environment]::GetCommandLineArgs()[0])
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:GetCurrentProcessDelegate = $delegate
                }
                Remove-Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced
            }
        }
    }

    Context "Invoke-WithUtf8Encoding console handling" {
        It "continues when setting output encoding fails" {
            $originalIsRedirected = InModuleScope ColorScripts-Enhanced { $script:IsOutputRedirectedDelegate }
            $originalGetEncoding = InModuleScope ColorScripts-Enhanced { $script:GetConsoleOutputEncodingDelegate }
            $originalSetEncoding = InModuleScope ColorScripts-Enhanced { $script:SetConsoleOutputEncodingDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:IsOutputRedirectedDelegate = { $false }
                    $script:GetConsoleOutputEncodingDelegate = { [System.Text.Encoding]::Unicode }
                    $script:SetConsoleOutputEncodingDelegate = {
                        param($encoding)
                        throw [System.IO.IOException]::new('set failure')
                    }
                }

                Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Message)
                    $script:VerboseMessages = @($script:VerboseMessages + $Message)
                }

                $state = [ref]$false
                InModuleScope ColorScripts-Enhanced -Parameters @{ state = $state } {
                    param($state)
                    Invoke-WithUtf8Encoding -ScriptBlock {
                        param($stateRef)
                        $stateRef.Value = $true
                    } -Arguments @($state)
                }

                $state.Value | Should -BeTrue
                Assert-MockCalled -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -ParameterFilter { $Message -like 'Console handle unavailable; skipping*' } -Times 1
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ isDel = $originalIsRedirected; getDel = $originalGetEncoding; setDel = $originalSetEncoding } {
                    param($isDel, $getDel, $setDel)
                    $script:IsOutputRedirectedDelegate = $isDel
                    $script:GetConsoleOutputEncodingDelegate = $getDel
                    $script:SetConsoleOutputEncodingDelegate = $setDel
                }
            }
        }

        It "logs when restoring output encoding fails" {
            $originalIsRedirected = InModuleScope ColorScripts-Enhanced { $script:IsOutputRedirectedDelegate }
            $originalGetEncoding = InModuleScope ColorScripts-Enhanced { $script:GetConsoleOutputEncodingDelegate }
            $originalSetEncoding = InModuleScope ColorScripts-Enhanced { $script:SetConsoleOutputEncodingDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:IsOutputRedirectedDelegate = { $false }
                    $script:GetConsoleOutputEncodingDelegate = { [System.Text.Encoding]::Unicode }
                    $script:EncodingSetCounter = 0
                    $script:SetConsoleOutputEncodingDelegate = {
                        param($encoding)
                        $script:EncodingSetCounter++
                        if ($script:EncodingSetCounter -eq 2) {
                            throw [System.IO.IOException]::new('restore failure')
                        }
                    }
                }

                Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Message)
                    $script:VerboseMessages = @($script:VerboseMessages + $Message)
                }

                InModuleScope ColorScripts-Enhanced {
                    Invoke-WithUtf8Encoding -ScriptBlock { 'ok' } | Out-Null
                }

                Assert-MockCalled -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -ParameterFilter { $Message -like 'Console handle unavailable; unable to restore*' } -Times 1
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ isDel = $originalIsRedirected; getDel = $originalGetEncoding; setDel = $originalSetEncoding } {
                    param($isDel, $getDel, $setDel)
                    $script:IsOutputRedirectedDelegate = $isDel
                    $script:GetConsoleOutputEncodingDelegate = $getDel
                    $script:SetConsoleOutputEncodingDelegate = $setDel
                    Remove-Variable -Name EncodingSetCounter -Scope Script -ErrorAction SilentlyContinue
                }
            }
        }
    }

    Context "Write-RenderedText error handling" {
        It "writes to pipeline when console write fails" {
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:ConsoleWriteDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:ConsoleWriteDelegate = {
                        param($text)
                        throw [System.IO.IOException]::new('write failure')
                    }
                }

                Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith { param($Message) }

                $result = InModuleScope ColorScripts-Enhanced {
                    Write-RenderedText -Text 'hello'
                }

                $result | Should -Be 'hello'
                Assert-MockCalled -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -ParameterFilter { $Message -like 'Console handle unavailable during cached render*' } -Times 1
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:ConsoleWriteDelegate = $delegate
                }
            }
        }
    }

    Context "Get-CachedOutput resilience" {
        It "handles exceptions when verifying script existence" {
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:FileExistsDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:FileExistsDelegate = {
                        param($path)
                        throw [System.Exception]::new('existence failure')
                    }
                }

                $result = InModuleScope ColorScripts-Enhanced {
                    Get-CachedOutput -ScriptPath (Join-Path -Path (Get-Variable -Name '__CoverageScriptsDir' -Scope Global -ValueOnly) -ChildPath 'missing.ps1')
                }

                $result.Available | Should -BeFalse
                $result.CacheFile | Should -BeNull
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:FileExistsDelegate = $delegate
                }
            }
        }

        It "handles cache read failures gracefully" {
            $scriptPath = Join-Path -Path $script:ScriptsDir -ChildPath 'alpha.ps1'
            Set-Content -LiteralPath $scriptPath -Value 'Write-Host alpha' -Encoding UTF8

            $cacheFile = Join-Path -Path $script:CachePath -ChildPath 'alpha.cache'
            Set-Content -LiteralPath $cacheFile -Value 'cached' -Encoding UTF8

            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:FileReadAllTextDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:FileReadAllTextDelegate = {
                        param($path, $encoding)
                        throw [System.Exception]::new('read failure')
                    }
                }

                Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith { param($Message) }

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $scriptPath } {
                    param($path)
                    Get-CachedOutput -ScriptPath $path
                }

                $result.Available | Should -BeFalse
                $result.CacheFile | Should -Be (Join-Path -Path (Get-Variable -Name '__CoverageCachePath' -Scope Global -ValueOnly) -ChildPath 'alpha.cache')
                Assert-MockCalled -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -ParameterFilter { $Message -like 'Cache read error*' } -Times 1
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:FileReadAllTextDelegate = $delegate
                }
            }
        }
    }

    Context "Test-ConsoleOutputRedirected safety" {
        It "returns false when delegate throws" {
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:IsOutputRedirectedDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:IsOutputRedirectedDelegate = {
                        throw [System.IO.IOException]::new('redirect failure')
                    }
                }

                $result = InModuleScope ColorScripts-Enhanced {
                    Test-ConsoleOutputRedirected
                }

                $result | Should -BeFalse
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:IsOutputRedirectedDelegate = $delegate
                }
            }
        }
    }

    Context "Get-ColorScriptInventory edge cases" {
        BeforeEach {
            $scriptFile = Join-Path -Path $script:ScriptsDir -ChildPath 'inventory-test.ps1'
            Set-Content -LiteralPath $scriptFile -Value 'Write-Host inventory' -Encoding UTF8
        }

        It "continues when directory timestamp retrieval fails" {
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:DirectoryGetLastWriteTimeUtcDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:DirectoryGetLastWriteTimeUtcDelegate = {
                        param($path)
                        throw [System.Exception]::new('timestamp failure')
                    }
                }

                $result = InModuleScope ColorScripts-Enhanced {
                    Get-ColorScriptInventory
                }

                $result | Should -Not -BeNullOrEmpty
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:DirectoryGetLastWriteTimeUtcDelegate = $delegate
                }
            }
        }

        It "treats minimum timestamp as null" {
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:DirectoryGetLastWriteTimeUtcDelegate }

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:DirectoryGetLastWriteTimeUtcDelegate = {
                        param($path)
                        [datetime]::MinValue
                    }
                    $script:ScriptInventoryStamp = $null
                    $script:ScriptInventoryInitialized = $false
                }

                InModuleScope ColorScripts-Enhanced {
                    Get-ColorScriptInventory | Out-Null
                }

                $stamp = InModuleScope ColorScripts-Enhanced { $script:ScriptInventoryStamp }
                $stamp | Should -BeNullOrEmpty
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:DirectoryGetLastWriteTimeUtcDelegate = $delegate
                }
            }
        }

        It "recovers when child item enumeration fails" {
            Mock -CommandName Get-ChildItem -ModuleName ColorScripts-Enhanced -MockWith {
                throw [System.IO.IOException]::new('enumeration failure')
            }

            InModuleScope ColorScripts-Enhanced {
                $script:ScriptInventoryInitialized = $false
            }

            $result = InModuleScope ColorScripts-Enhanced {
                Get-ColorScriptInventory
            }

            $result | Should -BeEmpty

            Remove-Mock -CommandName Get-ChildItem -ModuleName ColorScripts-Enhanced
        }

        It "rebuilds inventory records when cache is absent" {
            InModuleScope ColorScripts-Enhanced {
                $script:ScriptInventory = @()
                $script:ScriptInventoryRecords = $null
            }

            $records = InModuleScope ColorScripts-Enhanced {
                Get-ColorScriptInventory -Raw | Out-Null
                Get-ColorScriptInventory
            }

            $records | Should -Not -BeNullOrEmpty
        }

        It "refreshes when inventory timestamp changes" {
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:DirectoryGetLastWriteTimeUtcDelegate }
            $newStamp = [datetime]::UtcNow.AddMinutes(5)

            try {
                InModuleScope ColorScripts-Enhanced -Parameters @{ stamp = $newStamp } {
                    param($stamp)
                    $script:ScriptInventoryInitialized = $true
                    $script:ScriptInventoryStamp = [datetime]::UtcNow
                    $script:DirectoryGetLastWriteTimeUtcDelegate = {
                        param($path)
                        $stamp
                    }
                }

                $result = InModuleScope ColorScripts-Enhanced {
                    Get-ColorScriptInventory
                }

                $result | Should -Not -BeNullOrEmpty
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:DirectoryGetLastWriteTimeUtcDelegate = $delegate
                    $script:ScriptInventoryInitialized = $false
                    $script:ScriptInventoryStamp = $null
                }
            }
        }

        It "refreshes when inventory was previously missing" {
            $originalDelegate = InModuleScope ColorScripts-Enhanced { $script:DirectoryGetLastWriteTimeUtcDelegate }
            $newStamp = [datetime]::UtcNow.AddMinutes(10)

            try {
                InModuleScope ColorScripts-Enhanced -Parameters @{ stamp = $newStamp } {
                    param($stamp)
                    $script:ScriptInventoryInitialized = $true
                    $script:ScriptInventoryStamp = $null
                    $script:DirectoryGetLastWriteTimeUtcDelegate = {
                        param($path)
                        $stamp
                    }
                }

                $result = InModuleScope ColorScripts-Enhanced {
                    Get-ColorScriptInventory
                }

                $result | Should -Not -BeNullOrEmpty
            }
            finally {
                InModuleScope ColorScripts-Enhanced -Parameters @{ delegate = $originalDelegate } {
                    param($delegate)
                    $script:DirectoryGetLastWriteTimeUtcDelegate = $delegate
                    $script:ScriptInventoryInitialized = $false
                    $script:ScriptInventoryStamp = $null
                }
            }
        }
    }

    Context "Initialize-CacheDirectory edge cases" {
        BeforeEach {
            InModuleScope ColorScripts-Enhanced {
                $script:CacheInitialized = $false
                $script:CacheDir = $null
            }
        }

        It "ignores invalid override cache path" {
            $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
            $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = 'ZZ:\invalid\cache'

            Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith { param($Message) }

            InModuleScope ColorScripts-Enhanced {
                Initialize-CacheDirectory
            }

            Assert-MockCalled -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -ParameterFilter { $Message -like 'Ignoring COLOR_SCRIPTS_ENHANCED_CACHE_PATH override*' } -Times 1

            $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $originalOverride
        }

        It "warns when configuration cache path cannot be resolved" {
            InModuleScope ColorScripts-Enhanced {
                $script:ConfigurationData = @{
                    Cache = @{ Path = '::invalid::' }
                }
                $script:ConfigurationInitialized = $true
            }

            Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith { param($Message) }

            InModuleScope ColorScripts-Enhanced {
                Initialize-CacheDirectory
            }

            Assert-MockCalled -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -ParameterFilter { $Message -like 'Configured cache path*could not be resolved*' } -Times 1

            InModuleScope ColorScripts-Enhanced {
                $script:ConfigurationData = $null
                $script:ConfigurationInitialized = $false
            }
        }

        It "skips unresolved candidate paths" -Skip:($PSVersionTable.PSVersion.Major -le 5) {
            Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith { param($Message) }

            InModuleScope ColorScripts-Enhanced {
                $originalAppData = $env:APPDATA
                $env:APPDATA = 'ZZ:\MissingAppData'
                try {
                    Initialize-CacheDirectory
                }
                finally {
                    $env:APPDATA = $originalAppData
                }
            }

            Assert-MockCalled -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -ParameterFilter { $Message -like 'Skipping cache candidate*' } -Times 1
        }

        It "warns when candidate directory creation fails" {
            $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
            $overridePath = Join-Path -Path $script:TestRoot -ChildPath 'blocked'
            $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $overridePath

            Mock -CommandName New-Item -ModuleName ColorScripts-Enhanced -MockWith {
                param([Parameter(ValueFromRemainingArguments = $true)]$Args)
                throw [System.UnauthorizedAccessException]::new('creation blocked')
            }

            Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith { param($Message) }

            InModuleScope ColorScripts-Enhanced {
                Initialize-CacheDirectory
            }

            Assert-MockCalled -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -ParameterFilter { $Message -like 'Unable to prepare cache directory*' } -Times 1

            Remove-Mock -CommandName New-Item -ModuleName ColorScripts-Enhanced
            $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $originalOverride
        }

        It "falls back when resolving final path fails" {
            Mock -CommandName Resolve-Path -ModuleName ColorScripts-Enhanced -MockWith {
                param($LiteralPath, $ErrorAction)
                throw [System.IO.IOException]::new('resolve failure')
            }

            InModuleScope ColorScripts-Enhanced {
                Initialize-CacheDirectory
            }

            $cacheDir = InModuleScope ColorScripts-Enhanced { $script:CacheDir }
            $cacheDir | Should -Be (Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ColorScripts-Enhanced')

            Remove-Mock -CommandName Resolve-Path -ModuleName ColorScripts-Enhanced
        }
    }
}
'@
            $metadataContent = @"
@{
    Categories = @{
        Abstract = @('cached')
    }
    Descriptions = @{
        cached = 'Initial description'
    }
}
"@
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

        It "combines manual metadata with automatic category fallbacks" {
            $scriptsDir = $script:ScriptsDir
            $metadataPath = $script:MetadataFile

            foreach ($name in @('solo', 'autoarray', 'autostring', 'nocategory')) {
                New-Item -ItemType File -Path (Join-Path -Path $scriptsDir -ChildPath "$name.ps1") -Force | Out-Null
            }

            $metadataContent = @"
@{
    Categories = @{
        Custom = @('solo')
    }
    Tags = @{
        'solo'       = 'SoloTag'
        'nocategory' = @('ListTag1', 'ListTag2')
    }
    Descriptions = @{
        'solo' = 'Solo description'
    }
    AutoCategories = @(
        @{ Category = 'ArrayCat';  Patterns = @('^autoarray$'); Tags = @('ArrayTag1', 'ArrayTag2') }
        @{ Category = 'StringCat'; Patterns = 'autostring';    Tags = 'StringTag' }
    )
}
"@

            [System.IO.File]::WriteAllText($metadataPath, $metadataContent, [System.Text.Encoding]::UTF8)

            $table = InModuleScope ColorScripts-Enhanced {
                Reset-ScriptInventoryCache
                $script:CacheInitialized = $true
                Get-ColorScriptMetadataTable
            }

            $table['solo'].Category | Should -Be 'Custom'
            $table['solo'].Tags | Should -Contain 'SoloTag'
            $table['solo'].Tags | Should -Contain 'Category:Custom'

            $table['autoarray'].Categories | Should -Contain 'ArrayCat'
            $table['autoarray'].Tags | Should -Contain 'ArrayTag1'
            $table['autoarray'].Tags | Should -Contain 'AutoCategorized'

            $table['autostring'].Categories | Should -Contain 'StringCat'
            $table['autostring'].Tags | Should -Contain 'StringTag'
            $table['autostring'].Tags | Should -Contain 'Category:StringCat'

            $table['nocategory'].Category | Should -Be 'Abstract'
            $table['nocategory'].Tags | Should -Contain 'AutoCategorized'
            $table['nocategory'].Tags | Should -Contain 'ListTag1'
        }
    }

    Context "Show-ColorScript" {
        BeforeEach {
            $script:RenderedOutputs = @()
            $script:Warnings = @()
            $script:SleepLog = @()
            InModuleScope ColorScripts-Enhanced { $script:ListParams = $null }
            $script:InfoMessages = @()
            $script:LastRenderedTextArgs = $null
            $script:RenderedTextCalls = @()
            $script:InvokeWithUtf8Calls = @()

            Mock -CommandName Write-Host -ModuleName ColorScripts-Enhanced -MockWith { } -Verifiable:$false
            Mock -CommandName Write-Information -ModuleName ColorScripts-Enhanced -MockWith {
                param(
                    [object]$MessageData,
                    [string[]]$Tags,
                    [System.Management.Automation.ActionPreference]$InformationAction
                )

                $null = $Tags
                $null = $InformationAction
                if ($null -ne $MessageData) {
                    $script:InfoMessages += [string]$MessageData
                }
            }
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
                param()
                $script:ListParams = @{}
                foreach ($key in $PSBoundParameters.Keys) {
                    $script:ListParams[$key] = $PSBoundParameters[$key]
                }
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

                if ($null -ne $Arguments -and $Arguments.Count -gt 0) {
                    $script:RenderedOutputs += $Arguments[0]
                }

                $noAnsiArgument = if ($Arguments.Count -ge 3) {
                    $Arguments[2]
                }
                elseif ($Arguments.Count -ge 2) {
                    $Arguments[1]
                }
                else {
                    $false
                }

                $callSnapshot = @{
                    Arguments    = $Arguments
                    NoAnsiOutput = [bool]$noAnsiArgument
                }

                if (-not $script:InvokeWithUtf8Calls) {
                    $script:InvokeWithUtf8Calls = @()
                }

                $script:InvokeWithUtf8Calls += $callSnapshot

                & $ScriptBlock @Arguments
            }
            Mock -CommandName Write-RenderedText -ModuleName ColorScripts-Enhanced -MockWith {
                param($Text, $NoAnsiOutput)
                $callRecord = @{
                    Text         = $Text
                    NoAnsiOutput = [bool]$NoAnsiOutput
                }

                $script:LastRenderedTextArgs = $callRecord
                if (-not $script:RenderedTextCalls) {
                    $script:RenderedTextCalls = @()
                }

                $script:RenderedTextCalls += $callRecord
            }
        }

        It "lists scripts when requested" {
            Show-ColorScript -List -Category 'Nature' -Tag 'Bright'

            Assert-MockCalled -CommandName Get-ColorScriptList -ModuleName ColorScripts-Enhanced -Times 1 -ParameterFilter {
                ($Category -and $Category.Count -eq 1 -and $Category[0] -eq 'Nature') -and
                ($Tag -and $Tag.Count -eq 1 -and $Tag[0] -eq 'Bright') -and
                (-not [bool]$Quiet) -and
                (-not [bool]$NoAnsiOutput)
            }
        }

        It "forwards quiet and no-ANSI flags to list operations" {
            Show-ColorScript -List -Quiet -NoAnsiOutput

            Assert-MockCalled -CommandName Get-ColorScriptList -ModuleName ColorScripts-Enhanced -Times 1 -ParameterFilter {
                [bool]$Quiet -and [bool]$NoAnsiOutput
            }
        }

        It "defaults to the first script when no name is specified" {
            $null = Show-ColorScript

            Assert-MockCalled -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -Times 1
            ($script:RenderedOutputs | Select-Object -First 1) | Should -Be 'built output'
        }

        It "emits structured error when cache build produces no output" {
            Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Success = $false; StdOut = ''; StdErr = ''; ExitCode = 1 }
            }

            $errorRecord = $null
            try {
                Show-ColorScript -Name 'alpha-one' -ErrorAction Stop
            }
            catch {
                $errorRecord = $_
            }

            $errorRecord | Should -Not -BeNullOrEmpty
            $errorRecord.FullyQualifiedErrorId | Should -Match '^ColorScriptsEnhanced.CacheBuildFailed'
            $errorRecord.CategoryInfo.Category | Should -Be ([System.Management.Automation.ErrorCategory]::InvalidOperation)
        }

        It "emits structured error when process invocation fails" {
            Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                @{ Success = $false; StdOut = ''; StdErr = 'boom'; ExitCode = 9 }
            }

            $errorRecord = $null
            try {
                Show-ColorScript -Name 'alpha-one' -NoCache -ErrorAction Stop
            }
            catch {
                $errorRecord = $_
            }

            $errorRecord | Should -Not -BeNullOrEmpty
            $errorRecord.FullyQualifiedErrorId | Should -Match '^ColorScriptsEnhanced.ScriptExecutionFailed'
            $errorRecord.CategoryInfo.Category | Should -Be ([System.Management.Automation.ErrorCategory]::InvalidOperation)
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

        It "clears the host before each script when cycling all" {
            Show-ColorScript -All

            Assert-MockCalled -CommandName Clear-Host -ModuleName ColorScripts-Enhanced -Times 2
        }

        It "skips host clearing when NoClear is specified" {
            Show-ColorScript -All -NoClear

            Assert-MockCalled -CommandName Clear-Host -ModuleName ColorScripts-Enhanced -Times 0
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

        It "still displays wait-for-input prompts when quiet" {
            Mock -CommandName Get-ColorScriptInventory -ModuleName ColorScripts-Enhanced -MockWith {
                @(
                    [pscustomobject]@{ Name = 'alpha-one'; Path = 'C:\scripts\alpha-one.ps1' }
                    [pscustomobject]@{ Name = 'alpha-two'; Path = 'C:\scripts\alpha-two.ps1' }
                )
            }

            InModuleScope ColorScripts-Enhanced {
                $script:ReadKeyQueue = [System.Collections.Generic.Queue[object]]::new()
                $script:ReadKeyQueue.Enqueue([pscustomobject]@{ VirtualKeyCode = 32; Character = ' ' })
                $script:ReadKeyQueue.Enqueue([pscustomobject]@{ VirtualKeyCode = 81; Character = 'q' })

                $rawUI = $Host.UI.RawUI
                $rawUI | Add-Member -MemberType ScriptMethod -Name ReadKey -Force -Value {
                    param($Options)
                    $null = $Options
                    if ($script:ReadKeyQueue.Count -gt 0) {
                        return $script:ReadKeyQueue.Dequeue()
                    }
                    return [pscustomobject]@{ VirtualKeyCode = 81; Character = 'q' }
                }
            }

            Show-ColorScript -All -WaitForInput -Quiet

            ($script:InfoMessages | Where-Object { $_ -match 'Press' }) | Should -Not -BeNullOrEmpty
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

        It "defaults to ANSI rendering when not disabled" {
            Show-ColorScript -Name 'alpha-one'

            ($script:InvokeWithUtf8Calls | Select-Object -Last 1).NoAnsiOutput | Should -BeFalse
        }

        It "disables ANSI sequences when NoAnsiOutput is specified" {
            Show-ColorScript -Name 'alpha-one' -NoAnsiOutput

            ($script:InvokeWithUtf8Calls | Where-Object { $_.NoAnsiOutput }).Count | Should -BeGreaterThan 0
        }

        It "suppresses informational messages when quiet" {
            Show-ColorScript -All -Quiet

            $script:InfoMessages | Where-Object { $_ -ne '' } | Should -BeNullOrEmpty
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
