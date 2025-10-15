# Pester Tests for ColorScripts-Enhanced Module
# Run with: Invoke-Pester

BeforeAll {
    # Import the module (cross-platform path)
    $script:OriginalCacheOverride = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
    $script:OriginalConfigOverride = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
    $testDriveRoot = $null
    if (Test-Path -LiteralPath 'TestDrive:\') {
        $testDriveRoot = (Resolve-Path -LiteralPath 'TestDrive:\' -ErrorAction Stop).ProviderPath
    }
    elseif ($TestDrive) {
        $testDriveRoot = $TestDrive
    }

    if (-not $testDriveRoot) {
        throw 'Pester TestDrive path is unavailable.'
    }

    $script:TestCacheRoot = Join-Path -Path $testDriveRoot -ChildPath 'Cache'
    $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $script:TestCacheRoot
    if (-not (Test-Path $script:TestCacheRoot)) {
        New-Item -ItemType Directory -Path $script:TestCacheRoot -Force | Out-Null
    }

    $script:TestConfigRoot = Join-Path -Path $testDriveRoot -ChildPath 'Config'
    $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $script:TestConfigRoot
    if (-not (Test-Path $script:TestConfigRoot)) {
        New-Item -ItemType Directory -Path $script:TestConfigRoot -Force | Out-Null
    }

    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath ".."
    $ModulePath = Join-Path -Path $ModulePath -ChildPath "ColorScripts-Enhanced"
    Import-Module $ModulePath -Force
}

Describe "ColorScripts-Enhanced Module" {

    Context "Module Loading" {
        It "Should load the module successfully" {
            $module = Get-Module ColorScripts-Enhanced
            $module | Should -Not -BeNullOrEmpty
        }

        It "Should have the correct GUID" {
            $module = Get-Module ColorScripts-Enhanced
            $module.GUID | Should -Be 'f77548d7-23eb-48ce-a6e0-f64b4758d995'
        }

        It "Should export Show-ColorScript function" {
            $module = Get-Module ColorScripts-Enhanced -ErrorAction Stop
            $module.ExportedFunctions.ContainsKey('Show-ColorScript') | Should -BeTrue
        }

        It "Should export Get-ColorScriptList function" {
            $module = Get-Module ColorScripts-Enhanced -ErrorAction Stop
            $module.ExportedFunctions.ContainsKey('Get-ColorScriptList') | Should -BeTrue
        }

        It "Should export Build-ColorScriptCache function" {
            $module = Get-Module ColorScripts-Enhanced -ErrorAction Stop
            $module.ExportedFunctions.ContainsKey('Build-ColorScriptCache') | Should -BeTrue
        }

        It "Should export Clear-ColorScriptCache function" {
            $module = Get-Module ColorScripts-Enhanced -ErrorAction Stop
            $module.ExportedFunctions.ContainsKey('Clear-ColorScriptCache') | Should -BeTrue
        }

        It "Should export Add-ColorScriptProfile function" {
            $module = Get-Module ColorScripts-Enhanced -ErrorAction Stop
            $module.ExportedFunctions.ContainsKey('Add-ColorScriptProfile') | Should -BeTrue
        }

        It "Should export configuration helpers" {
            $module = Get-Module ColorScripts-Enhanced -ErrorAction Stop
            $module.ExportedFunctions.ContainsKey('Get-ColorScriptConfiguration') | Should -BeTrue
            $module.ExportedFunctions.ContainsKey('Set-ColorScriptConfiguration') | Should -BeTrue
            $module.ExportedFunctions.ContainsKey('Reset-ColorScriptConfiguration') | Should -BeTrue
        }

        It "Should export metadata utilities" {
            $module = Get-Module ColorScripts-Enhanced -ErrorAction Stop
            $module.ExportedFunctions.ContainsKey('Export-ColorScriptMetadata') | Should -BeTrue
            $module.ExportedFunctions.ContainsKey('New-ColorScript') | Should -BeTrue
        }

        It "Should have 'scs' alias" {
            $alias = Get-Alias scs -ErrorAction SilentlyContinue
            $alias.Definition | Should -Be 'Show-ColorScript'
        }
    }

    Context "Module Manifest" {
        BeforeAll {
            $script:ManifestPath = Join-Path -Path $PSScriptRoot -ChildPath ".."
            $script:ManifestPath = Join-Path -Path $script:ManifestPath -ChildPath "ColorScripts-Enhanced"
            $script:ManifestPath = Join-Path -Path $script:ManifestPath -ChildPath "ColorScripts-Enhanced.psd1"
            $script:Manifest = Test-ModuleManifest $script:ManifestPath -ErrorAction Stop
        }

        It "Should have a valid manifest" {
            $script:Manifest | Should -Not -BeNullOrEmpty
        }

        It "Should support PowerShell 5.1 and Core" {
            $script:Manifest.CompatiblePSEditions | Should -Contain 'Desktop'
            $script:Manifest.CompatiblePSEditions | Should -Contain 'Core'
        }

        It "Should have proper metadata" {
            $script:Manifest.Author | Should -Not -BeNullOrEmpty
            $script:Manifest.Description | Should -Not -BeNullOrEmpty
            $script:Manifest.ProjectUri | Should -Not -BeNullOrEmpty
        }
    }

    Context "Scripts Directory" {
        It "Should have Scripts directory" {
            $scriptsPath = Join-Path -Path $PSScriptRoot -ChildPath ".."
            $scriptsPath = Join-Path -Path $scriptsPath -ChildPath "ColorScripts-Enhanced"
            $scriptsPath = Join-Path -Path $scriptsPath -ChildPath "Scripts"
            Test-Path $scriptsPath | Should -Be $true
        }

        It "Should contain colorscript files" {
            $scriptsPath = Join-Path -Path $PSScriptRoot -ChildPath ".."
            $scriptsPath = Join-Path -Path $scriptsPath -ChildPath "ColorScripts-Enhanced"
            $scriptsPath = Join-Path -Path $scriptsPath -ChildPath "Scripts"
            $scripts = Get-ChildItem $scriptsPath -Filter "*.ps1"
            $scripts.Count | Should -BeGreaterThan 0
        }
    }

    Context "Cache System" {
        BeforeAll {
            $moduleInstance = Get-Module ColorScripts-Enhanced -ErrorAction Stop
            $script:CacheDir = $moduleInstance.SessionState.PSVariable.GetValue('CacheDir')
        }

        It "Should create cache directory" {
            Test-Path $script:CacheDir | Should -Be $true
        }

        It "Should build cache for a script" {
            $result = Build-ColorScriptCache -Name "bars" -Force -PassThru -ErrorAction Stop
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"

            $result | Should -Not -BeNullOrEmpty
            $result[0].Status | Should -BeIn @('Updated', 'SkippedUpToDate')
            Test-Path $cacheFile | Should -Be $true
        }

        It "Should build cache for wildcard patterns" {
            $result = Build-ColorScriptCache -Name 'aurora-s*' -Force -PassThru -ErrorAction Stop
            $names = $result | Select-Object -ExpandProperty Name
            $names | Should -Contain 'aurora-stream'
            $names | Should -Contain 'aurora-storm'
        }

        It "Should skip cache rebuild when up-to-date" {
            Build-ColorScriptCache -Name "bars" -Force -PassThru -ErrorAction Stop | Out-Null
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"
            [System.IO.File]::SetLastWriteTime($cacheFile, (Get-Date).AddHours(1))

            $result = Build-ColorScriptCache -Name "bars" -PassThru -ErrorAction Stop
            $result[0].Status | Should -Be 'SkippedUpToDate'
        }

        It "Should force cache rebuild even when cache is newer" {
            Build-ColorScriptCache -Name "bars" -Force -PassThru -ErrorAction Stop | Out-Null
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"
            [System.IO.File]::SetLastWriteTime($cacheFile, (Get-Date).AddHours(1))

            $result = Build-ColorScriptCache -Name "bars" -Force -PassThru -ErrorAction Stop
            $result[0].Status | Should -Be 'Updated'
        }

        It "Should write UTF-8 cache without BOM" {
            Build-ColorScriptCache -Name "bars" -Force -PassThru -ErrorAction Stop | Out-Null
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"
            $bytes = [System.IO.File]::ReadAllBytes($cacheFile)

            if ($bytes.Length -ge 3) {
                $bytes[0] | Should -Not -Be 0xEF
                $bytes[1] | Should -Not -Be 0xBB
                $bytes[2] | Should -Not -Be 0xBF
            }
        }

        It "Should build cache during first Show-ColorScript invocation" {
            Clear-ColorScriptCache -Name "bars" -Confirm:$false | Out-Null
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"
            if (Test-Path $cacheFile) {
                Remove-Item -LiteralPath $cacheFile -Force
            }

            $rendered = Show-ColorScript -Name "bars" -ReturnText -ErrorAction Stop

            Test-Path $cacheFile | Should -Be $true
            $cachedText = [System.IO.File]::ReadAllText($cacheFile)
            $cachedText | Should -Be $rendered
        }

        It "Should cache all scripts when no parameters are provided" {
            $module = Get-Module ColorScripts-Enhanced -ErrorAction Stop
            $originalCacheDir = $module.SessionState.PSVariable.GetValue('CacheDir')
            $originalCacheInitialized = $module.SessionState.PSVariable.GetValue('CacheInitialized')
            $temporaryCacheDir = Join-Path -Path $TestDrive -ChildPath ("DefaultCache_{0}" -f ([Guid]::NewGuid()))
            if (-not (Test-Path $temporaryCacheDir)) {
                New-Item -ItemType Directory -Path $temporaryCacheDir -Force | Out-Null
            }

            $module.SessionState.PSVariable.Set('CacheDir', $temporaryCacheDir)
            $module.SessionState.PSVariable.Set('CacheInitialized', $true)

            Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced {
                param([string]$ScriptPath)

                $name = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
                $module = Get-Module ColorScripts-Enhanced -ErrorAction Stop
                $cacheDir = $module.SessionState.PSVariable.GetValue('CacheDir')
                [pscustomobject]@{
                    ScriptName = $name
                    CacheFile  = Join-Path -Path $cacheDir -ChildPath ("{0}.cache" -f $name)
                    Success    = $true
                    ExitCode   = 0
                    StdOut     = ''
                    StdErr     = ''
                }
            }

            try {
                $result = Build-ColorScriptCache -PassThru -ErrorAction Stop
                $result | Should -Not -BeNullOrEmpty

                $expectedCount = (Get-ColorScriptList -AsObject).Count
                $result.Count | Should -Be $expectedCount

                Assert-MockCalled -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -Times $expectedCount -Exactly
            }
            finally {
                $module.SessionState.PSVariable.Set('CacheDir', $originalCacheDir)
                $module.SessionState.PSVariable.Set('CacheInitialized', $originalCacheInitialized)

                if (Test-Path $temporaryCacheDir) {
                    Remove-Item -Path $temporaryCacheDir -Recurse -Force
                }
            }
        }

        It "Should render cached output without re-executing the script" {
            Clear-ColorScriptCache -Name "bars" -Confirm:$false | Out-Null
            Build-ColorScriptCache -Name "bars" -Force -PassThru -ErrorAction Stop | Out-Null

            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"
            Test-Path $cacheFile | Should -Be $true
            $cachedText = [System.IO.File]::ReadAllText($cacheFile)

            Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced {
                throw "Build-ScriptCache should not run when cache is valid."
            }

            $stringWriter = $null
            $originalOut = $null
            $consoleRedirected = $false

            try {
                $stringWriter = New-Object System.IO.StringWriter
                $originalOut = [Console]::Out
                [Console]::SetOut($stringWriter)
                $consoleRedirected = $true
            }
            catch [System.IO.IOException] {
                $consoleRedirected = $false
                $stringWriter = $null
            }

            $executionOutput = $null
            try {
                $executionOutput = Show-ColorScript -Name "bars" -ReturnText -ErrorAction Stop
            }
            finally {
                if ($consoleRedirected -and $originalOut) {
                    [Console]::SetOut($originalOut)
                }
            }

            Assert-MockCalled -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -Times 0 -Exactly

            if ($consoleRedirected -and $stringWriter) {
                $stringWriter.Flush()
                $renderedOutput = $stringWriter.ToString()
            }
            if (-not $renderedOutput -and $executionOutput) {
                $renderedOutput = ($executionOutput -join [Environment]::NewLine)
            }
            else {
                $renderedOutput = $null
            }

            $renderedOutput | Should -Not -BeNullOrEmpty
            $renderedOutput | Should -BeExactly $cachedText
        }

        It "Should clear specific cache" {
            Build-ColorScriptCache -Name "bars" -Force -PassThru -ErrorAction Stop | Out-Null
            $result = Clear-ColorScriptCache -Name "bars" -Confirm:$false
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"

            $result[0].Status | Should -BeIn @('Removed', 'Missing')
            Test-Path $cacheFile | Should -Be $false
        }

        It "Should clear caches using wildcard patterns" {
            Build-ColorScriptCache -Name 'aurora-s*' -Force -PassThru -ErrorAction Stop | Out-Null
            $result = Clear-ColorScriptCache -Name 'aurora-s*' -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $names = $result | Select-Object -ExpandProperty Name
            $names | Should -Contain 'aurora-stream'
            $names | Should -Contain 'aurora-storm'
            $result | ForEach-Object { $_.Status | Should -BeIn @('Removed', 'Missing') }
        }

        It "Should support DryRun cache clearing" {
            Build-ColorScriptCache -Name "bars" -Force -PassThru -ErrorAction Stop | Out-Null
            $dryRun = Clear-ColorScriptCache -Name "bars" -DryRun
            $dryRun[0].Status | Should -Be 'DryRun'
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"
            Test-Path $cacheFile | Should -Be $true
        }
    }

    Context "Configuration" {
        It "Should expose default configuration values" {
            $config = Get-ColorScriptConfiguration
            $config.Cache.Path | Should -Be $null
            $config.Startup.AutoShowOnImport | Should -BeFalse
            $config.Startup.ProfileAutoShow | Should -BeTrue
        }

        It "Should update configuration values" {
            $originalEnvCache = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
            try {
                $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $null
                Reset-ColorScriptConfiguration | Out-Null

                $customCache = Join-Path -Path $script:TestConfigRoot -ChildPath 'ConfiguredCache'
                $result = Set-ColorScriptConfiguration -CachePath $customCache -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars' -PassThru

                $resolved = Resolve-Path -LiteralPath $customCache
                $result.Cache.Path | Should -Be $resolved.ProviderPath
                $result.Startup.AutoShowOnImport | Should -BeTrue
                $result.Startup.ProfileAutoShow | Should -BeFalse
                $result.Startup.DefaultScript | Should -Be 'bars'
            }
            finally {
                if ($null -eq $originalEnvCache) {
                    Remove-Item Env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -ErrorAction SilentlyContinue
                }
                else {
                    $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $originalEnvCache
                }

                Set-ColorScriptConfiguration -CachePath $script:TestCacheRoot -AutoShowOnImport:$false -ProfileAutoShow:$true -DefaultScript '' | Out-Null
            }
        }
    }

    Context "Metadata Export" {
        It "Should export metadata as JSON" {
            $outputPath = Join-Path -Path $script:TestConfigRoot -ChildPath 'metadata.json'
            $records = Export-ColorScriptMetadata -Path $outputPath -IncludeFileInfo -IncludeCacheInfo -PassThru

            Test-Path -LiteralPath $outputPath | Should -BeTrue
            $records | Should -Not -BeNullOrEmpty
            ($records | Where-Object { $_.Name -eq 'bars' }).Category | Should -Not -BeNullOrEmpty

            $parsed = Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json
            $parsed | Should -Not -BeNullOrEmpty
        }
    }

    Context "Scaffolding" {
        It "Should scaffold a new colorscript" {
            $scaffoldRoot = Join-Path -Path $script:TestConfigRoot -ChildPath 'Scaffold'
            $result = New-ColorScript -Name 'test-script' -OutputPath $scaffoldRoot -Force -GenerateMetadataSnippet -Category 'Test' -Tag 'Sample', 'Demo'

            $result | Should -Not -BeNullOrEmpty
            Test-Path -LiteralPath $result.Path | Should -BeTrue
            (Get-Content -LiteralPath $result.Path -Raw) | Should -Match 'Replace this array with your ANSI art'
            $result.MetadataGuidance | Should -Match 'ScriptMetadata'
        }
    }

    Context "Show-ColorScript Function" {
        It "Should have proper help" {
            $help = Get-Help Show-ColorScript
            $help.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "Should support -Name parameter" {
            { Show-ColorScript -Name "bars" -ErrorAction Stop } | Should -Not -Throw
        }

        It "Should support -List parameter" {
            { Show-ColorScript -List -ErrorAction Stop } | Should -Not -Throw
        }

        It "Should support -NoCache parameter" {
            { Show-ColorScript -Name "bars" -NoCache -ErrorAction Stop } | Should -Not -Throw
        }

        It "Should support wildcard Name patterns" {
            $record = Show-ColorScript -Name 'aurora-s*' -NoCache -PassThru
            $record | Should -Not -BeNullOrEmpty
            $record.Name | Should -Be 'aurora-storm'
        }

        It "Should handle non-existent script gracefully" {
            { Show-ColorScript -Name "nonexistent-script-xyz" } | Should -Not -Throw
        }
    }

    Context "Rendering Helpers" {
        It "Should append newline when rendered text lacks terminator" {
            $stringWriter = New-Object System.IO.StringWriter
            $originalOut = [Console]::Out

            try {
                [Console]::SetOut($stringWriter)
                InModuleScope ColorScripts-Enhanced {
                    Write-RenderedText -Text 'Hello world'
                }
            }
            finally {
                if ($originalOut) {
                    [Console]::SetOut($originalOut)
                }
            }

            $result = $stringWriter.ToString()
            $result | Should -Match '^Hello world(\r)?\n$'
            $stringWriter.Dispose()
        }

        It "Should avoid extra newline when output already terminated" {
            $stringWriter = New-Object System.IO.StringWriter
            $originalOut = [Console]::Out

            try {
                [Console]::SetOut($stringWriter)
                InModuleScope ColorScripts-Enhanced {
                    Write-RenderedText -Text "Hello world`r`n"
                }
            }
            finally {
                if ($originalOut) {
                    [Console]::SetOut($originalOut)
                }
            }

            $result = $stringWriter.ToString()
            $result | Should -Match '^Hello world(\r)?\n$'
            $stringWriter.Dispose()
        }
    }

    Context "Get-ColorScriptList Function" {
        It "Should have proper help" {
            $help = Get-Help Get-ColorScriptList
            $help.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "Should execute without error" {
            { Get-ColorScriptList } | Should -Not -Throw
        }

        It "Should filter by name with wildcards" {
            $records = Get-ColorScriptList -AsObject -Name 'aurora-s*'
            $records | Should -Not -BeNullOrEmpty
            ($records | Select-Object -ExpandProperty Name) | Should -Contain 'aurora-storm'
        }
    }

    Context "Metadata and Filtering" {
        It "Should return structured objects when using -AsObject" {
            $records = Get-ColorScriptList -AsObject
            $records | Should -Not -BeNullOrEmpty
            $records[0] | Should -BeOfType [pscustomobject]
            $records[0].Metadata | Should -Not -BeNullOrEmpty
        }

        It "Should filter by category" {
            $records = Get-ColorScriptList -AsObject -Category 'Patterns'
            $records | Should -Not -BeNullOrEmpty
            $records | ForEach-Object {
                $_.Categories | ForEach-Object { $_.ToLowerInvariant() } | Should -Contain 'patterns'
            }
        }

        It "Should filter by tag" {
            $records = Get-ColorScriptList -AsObject -Tag 'recommended'
            $records | Should -Not -BeNullOrEmpty
            $records | ForEach-Object {
                $_.Tags | ForEach-Object { $_.ToLowerInvariant() } | Should -Contain 'recommended'
            }
        }

        It "Show-ColorScript -PassThru should return metadata" {
            $record = Show-ColorScript -Name 'bars' -NoCache -PassThru
            $record.Name | Should -Be 'bars'
            $record.Metadata | Should -Not -BeNullOrEmpty
        }

        It "Should provide metadata for every colorscript" {
            $records = Get-ColorScriptList -AsObject
            $records.Count | Should -BeGreaterThan 0
            $records | ForEach-Object { $_.Metadata | Should -Not -BeNullOrEmpty }
        }

        It "Should not leave any script uncategorized" {
            $records = Get-ColorScriptList -AsObject
            $uncategorized = $records | Where-Object { $_.Category -eq 'Uncategorized' }
            $uncategorized | Should -BeNullOrEmpty
        }

        It "Should categorize city-neon as Artistic" {
            $record = Get-ColorScriptList -AsObject | Where-Object { $_.Name -eq 'city-neon' } | Select-Object -First 1
            $record | Should -Not -BeNullOrEmpty
            $record.Category | Should -Be 'Artistic'
            # City-neon is explicitly categorized, so it should have Category:Artistic tag
            $record.Tags | Should -Contain 'Category:Artistic'
        }

        It "Should expose TerminalThemes category" {
            $records = Get-ColorScriptList -Category 'TerminalThemes' -AsObject
            ($records | Select-Object -ExpandProperty Name) | Should -Contain 'terminal-glow'
        }

        It "Should expose ASCIIArt category" {
            $records = Get-ColorScriptList -Category 'ASCIIArt' -AsObject
            ($records | Select-Object -ExpandProperty Name) | Should -Contain 'thebat'
        }

        It "Should expose Physics category" {
            $records = Get-ColorScriptList -Category 'Physics' -AsObject
            ($records | Select-Object -ExpandProperty Name) | Should -Contain 'nbody-gravity'
        }

        It "Should add category tags to all scripts" {
            $records = Get-ColorScriptList -AsObject
            # Every script should have at least one Category:* tag
            foreach ($record in $records) {
                $categoryTags = $record.Tags | Where-Object { $_ -like 'Category:*' }
                $categoryTags | Should -Not -BeNullOrEmpty -Because "Script '$($record.Name)' should have category tags"
            }
            # Verify city-neon specifically has the Artistic category tag
            $cityNeon = $records | Where-Object { $_.Name -eq 'city-neon' } | Select-Object -First 1
            $cityNeon.Tags | Should -Contain 'Category:Artistic'
        }
    }

    Context "Build-ColorScriptCache Function" {
        It "Should have proper help" {
            $help = Get-Help Build-ColorScriptCache
            $help.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "Should support -Name parameter" {
            { Build-ColorScriptCache -Name "bars" -ErrorAction Stop | Out-Null } | Should -Not -Throw
        }

        It "Should support -Force parameter" {
            { Build-ColorScriptCache -Name "bars" -Force -ErrorAction Stop | Out-Null } | Should -Not -Throw
        }

        It "Should accept pipeline input" {
            $result = @('bars', 'aurora-storm') | Build-ColorScriptCache -Force -PassThru -ErrorAction Stop
            $result | Should -Not -BeNullOrEmpty
            ($result | Select-Object -ExpandProperty Name) | Should -Contain 'bars'
            ($result | Select-Object -ExpandProperty Name) | Should -Contain 'aurora-storm'
        }

        It "Should accept pipeline objects" {
            $records = Get-ColorScriptList -AsObject -Name 'bars', 'aurora-storm'
            $records | Should -Not -BeNullOrEmpty
            $result = $records | Build-ColorScriptCache -Force -PassThru -ErrorAction Stop
            $result | Should -Not -BeNullOrEmpty
            ($result | Select-Object -ExpandProperty Name) | Should -Contain 'bars'
            ($result | Select-Object -ExpandProperty Name) | Should -Contain 'aurora-storm'
        }
    }

    Context "Clear-ColorScriptCache Function" {
        It "Should have proper help" {
            $help = Get-Help Clear-ColorScriptCache
            $help.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "Should support -WhatIf" {
            { Clear-ColorScriptCache -All -WhatIf } | Should -Not -Throw
        }

        It "Should support -Confirm:$false" {
            { Clear-ColorScriptCache -Name "bars" -Confirm:$false } | Should -Not -Throw
        }

        It "Should support custom cache path" {
            $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("ColorScriptsCache_" + [guid]::NewGuid())
            $null = New-Item -ItemType Directory -Path $tempDir
            $tempCache = Join-Path $tempDir 'bars.cache'
            Set-Content -Path $tempCache -Value 'cache-data' -Encoding utf8

            try {
                $result = Clear-ColorScriptCache -Name 'bars' -Path $tempDir -Confirm:$false
                $result[0].Status | Should -Be 'Removed'
                Test-Path $tempCache | Should -BeFalse
            }
            finally {
                if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
            }
        }

        It "Should accept pipeline input" {
            Build-ColorScriptCache -Name 'bars', 'aurora-storm' -Force -ErrorAction Stop | Out-Null
            $result = @('bars', 'aurora-storm') | Clear-ColorScriptCache -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            ($result | Select-Object -ExpandProperty Name) | Should -Contain 'bars'
            ($result | Select-Object -ExpandProperty Name) | Should -Contain 'aurora-storm'
        }

        It "Should accept pipeline objects" {
            Build-ColorScriptCache -Name 'bars', 'aurora-storm' -Force -ErrorAction Stop | Out-Null
            $records = Get-ColorScriptList -AsObject -Name 'bars', 'aurora-storm'
            $records | Should -Not -BeNullOrEmpty
            $result = $records | Clear-ColorScriptCache -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            ($result | Select-Object -ExpandProperty Name) | Should -Contain 'bars'
            ($result | Select-Object -ExpandProperty Name) | Should -Contain 'aurora-storm'
        }
    }

    Context "Help Documentation" {
        It "Should have about help topic" {
            $help = Get-Help about_ColorScripts-Enhanced -ErrorAction SilentlyContinue
            $help | Should -Not -BeNullOrEmpty
        }

        It "Show-ColorScript should have examples" {
            $help = Get-Help Show-ColorScript -Examples
            $help.Examples | Should -Not -BeNullOrEmpty
        }

        It "All functions should have synopsis" {
            $commands = @('Show-ColorScript', 'Get-ColorScriptList', 'Build-ColorScriptCache', 'Clear-ColorScriptCache', 'Add-ColorScriptProfile')
            foreach ($cmd in $commands) {
                $help = Get-Help $cmd
                $help.Synopsis | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Describe "Add-ColorScriptProfile Function" {
    It "Should have proper help" {
        $help = Get-Help Add-ColorScriptProfile
        $help.Synopsis | Should -Not -BeNullOrEmpty
    }

    It "Should create profile snippet at custom path" {
        $tempProfile = Join-Path ([System.IO.Path]::GetTempPath()) ("ColorScriptsProfile_" + [guid]::NewGuid() + '.ps1')
        if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }

        try {
            $result = Add-ColorScriptProfile -Path $tempProfile
            $result.Changed | Should -BeTrue

            Test-Path $tempProfile | Should -BeTrue

            $content = Get-Content $tempProfile -Raw
            $content | Should -Match 'Import-Module\s+ColorScripts-Enhanced'
            $content | Should -Match 'Show-ColorScript'
        }
        finally {
            if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }
        }
    }

    It "Should respect SkipStartupScript" {
        $tempProfile = Join-Path ([System.IO.Path]::GetTempPath()) ("ColorScriptsProfileSkip_" + [guid]::NewGuid() + '.ps1')
        if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }

        try {
            Add-ColorScriptProfile -Path $tempProfile -SkipStartupScript | Out-Null

            $content = Get-Content $tempProfile -Raw
            $content | Should -Match 'Import-Module\s+ColorScripts-Enhanced'
            $content | Should -Not -Match 'Show-ColorScript'
        }
        finally {
            if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }
        }
    }

    It "Should avoid duplicates unless forced" {
        $tempProfile = Join-Path ([System.IO.Path]::GetTempPath()) ("ColorScriptsProfileDup_" + [guid]::NewGuid() + '.ps1')
        $initialContent = 'Import-Module ColorScripts-Enhanced'
        Set-Content -Path $tempProfile -Value $initialContent -Encoding utf8

        try {
            $result = Add-ColorScriptProfile -Path $tempProfile
            $result.Changed | Should -BeFalse

            $content = Get-Content $tempProfile -Raw
            ($content -split [Environment]::NewLine | Where-Object { $_ -match 'Import-Module\s+ColorScripts-Enhanced' }).Count | Should -Be 1

            $forceResult = Add-ColorScriptProfile -Path $tempProfile -Force
            $forceResult.Changed | Should -BeTrue

            $updatedContent = Get-Content $tempProfile -Raw
            (($updatedContent -split [Environment]::NewLine) | Where-Object { $_ -match '# Added by ColorScripts-Enhanced' }).Count | Should -Be 1
            (($updatedContent -split [Environment]::NewLine) | Where-Object { $_ -match 'Import-Module\s+ColorScripts-Enhanced' }).Count | Should -Be 1
        }
        finally {
            if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }
        }
    }

    It "Should expand tilde paths" {
        $uniqueName = "ColorScriptsProfileHome_{0}.ps1" -f ([guid]::NewGuid())
        $tildePath = "~/$uniqueName"
        $expectedPath = [System.IO.Path]::GetFullPath((Join-Path $HOME $uniqueName))

        if (Test-Path $expectedPath) { Remove-Item $expectedPath -Force }

        try {
            $result = Add-ColorScriptProfile -Path $tildePath -SkipStartupScript -Force
            $result.Path | Should -Be $expectedPath
            Test-Path $expectedPath | Should -BeTrue
        }
        finally {
            if (Test-Path $expectedPath) { Remove-Item $expectedPath -Force }
        }
    }
}

Describe "Script Quality" {
    Context "Script Files" {
        BeforeAll {
            $scriptsPath = "$PSScriptRoot\..\ColorScripts-Enhanced\Scripts"
            $script:TestScripts = Get-ChildItem $scriptsPath -Filter "*.ps1" | Select-Object -First 5
        }

        It "Scripts should use UTF-8 encoding" {
            foreach ($script in $script:TestScripts) {
                { Get-Content $script.FullName -ErrorAction Stop } | Should -Not -Throw
            }
        }

        It "Scripts should not reference legacy cache stub" {
            foreach ($script in $script:TestScripts) {
                $content = Get-Content $script.FullName -Raw
                $content | Should -Not -Match 'ColorScriptCache'
            }
        }
    }
}

Describe "Test-AllColorScripts Script" {
    BeforeAll {
        $script:RunnerPath = Join-Path -Path $PSScriptRoot -ChildPath "..\ColorScripts-Enhanced\Test-AllColorScripts.ps1"
    }

    It "Should return structured results for filtered run" {
        $results = & $script:RunnerPath -Filter 'bars' -Delay 0 -SkipErrors
        $results | Should -Not -BeNullOrEmpty
        $results[0].Name | Should -Be 'bars'
        $results[0] | Should -BeOfType [pscustomobject]
    }

    It "Should support parallel execution when available" {
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            $results = & $script:RunnerPath -Filter 'bars' -Delay 0 -SkipErrors -Parallel -ThrottleLimit 1
            $results | Should -Not -BeNullOrEmpty
            $results[0].Name | Should -Be 'bars'
        }
        else {
            Set-ItResult -Skipped -Because "Parallel mode requires PowerShell 7 or later."
        }
    }
}

AfterAll {
    Clear-ColorScriptCache -Name 'bars' -Confirm:$false | Out-Null
    Reset-ColorScriptConfiguration | Out-Null
    if ($null -eq $script:OriginalCacheOverride) {
        Remove-Item Env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -ErrorAction SilentlyContinue
    }
    else {
        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $script:OriginalCacheOverride
    }

    if ($null -eq $script:OriginalConfigOverride) {
        Remove-Item Env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT -ErrorAction SilentlyContinue
    }
    else {
        $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $script:OriginalConfigOverride
    }

    Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue
}
