return
<#
# Additional Pester tests targeting internal helper functions and edge cases

BeforeAll {
    $script:OriginalIsWindows = $IsWindows
    $script:OriginalIsMacOS = $IsMacOS
    $script:OriginalIsLinux = $IsLinux
    $script:OriginalAppData = $env:APPDATA
    $script:OriginalXdgConfig = $env:XDG_CONFIG_HOME
    $script:OriginalCacheOverride = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
    $script:OriginalConfigOverride = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT

    $modulePath = Join-Path -Path $PSScriptRoot -ChildPath "..\ColorScripts-Enhanced"
    Import-Module $modulePath -Force
}

AfterAll {
    $env:APPDATA = $script:OriginalAppData
    if ($null -eq $script:OriginalXdgConfig) {
        Remove-Item Env:XDG_CONFIG_HOME -ErrorAction SilentlyContinue
    }
    else {
        $env:XDG_CONFIG_HOME = $script:OriginalXdgConfig
    }

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

    Set-Variable -Name IsWindows -Value $script:OriginalIsWindows -Scope Global -Force
    Set-Variable -Name IsMacOS -Value $script:OriginalIsMacOS -Scope Global -Force
    Set-Variable -Name IsLinux -Value $script:OriginalIsLinux -Scope Global -Force

    Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue
}

Describe "Copy-ColorScriptHashtable and Merge-ColorScriptConfiguration" {
    It "Performs deep copy of heterogeneous hashtable" {
        InModuleScope ColorScripts-Enhanced {
            $source = @{
                Nested     = @{ Foo = 1 }
                Numbers    = @(1, 2, 3)
                Cloneable  = [System.Collections.ArrayList]::new(@('a', 'b'))
                Enumerable = [System.Collections.Generic.List[string]]::new()
                Text       = 'hello'
            }
            $source.Enumerable.Add('xyz')

            $clone = Copy-ColorScriptHashtable $source

            $clone | Should -Not -Be $null
            $clone -ne $source | Should -BeTrue
            $clone.Nested.Foo = 42
            $source.Nested.Foo | Should -Be 1
            $clone.Numbers[0] = 99
            $source.Numbers[0] | Should -Be 1
            $clone.Cloneable.Add('c')
            $source.Cloneable.Count | Should -Be 2
            $clone.Enumerable | Should -BeOfType [System.Object[]]
            $clone.Enumerable[0] | Should -Be 'xyz'
        }
    }

    It "Returns empty hashtable when source is null" {
        InModuleScope ColorScripts-Enhanced {
            $result = Copy-ColorScriptHashtable $null
            $result | Should -Not -BeNullOrEmpty
            $result.Keys.Count | Should -Be 0
        }
    }

    It "Merges nested configuration structures without mutating base" {
        InModuleScope ColorScripts-Enhanced {
            $base = [ordered]@{
                Cache = @{ Path = 'C:\Cache'; Settings = @{ Enabled = $true; Level = 1 } }
                Tags  = @('one')
                Data  = [System.Collections.ArrayList]::new(@('alpha'))
            }

            $override = [ordered]@{
                Cache = @{ Settings = @{ Level = 5; Mode = 'Fast' } }
                Tags  = @('two')
                Data  = [System.Collections.ArrayList]::new(@('beta'))
                Extra = [System.Collections.Generic.List[string]]::new(('x', 'y'))
            }

            $result = Merge-ColorScriptConfiguration $base $override

            $result.Cache.Settings.Level | Should -Be 5
            $result.Cache.Settings.Mode | Should -Be 'Fast'
            $result.Cache.Path | Should -Be 'C:\Cache'
            $result.Tags | Should -Contain 'one'
            $result.Tags | Should -Contain 'two'
            $result.Data | Should -Not -Be $base.Data
            $result.Data.Count | Should -Be 1
            $result.Extra | Should -BeOfType [System.Object[]]
            $base.Cache.Settings.Keys | Should -Not -Contain 'Mode'
        }
    }
}
#>
#>

Describe 'Show-ColorScriptHelp rendering' {
    It 'Colorizes help sections and metadata' {
        InModuleScope ColorScripts-Enhanced {
            Mock -CommandName Get-Help -ModuleName ColorScripts-Enhanced -MockWith {
                @'
NAME
Show-ColorScript
SYNOPSIS
Displays content
SYNTAX
 -- example syntax
PARAMETERS
    -Name <String>
    Required? true
    Position? 0
    Default value false
    Accept pipeline input? false
    Accept wildcard characters? false
EXAMPLES
EXAMPLE 1
    -- Show-ColorScript
NOTES
Additional text
RELATED LINKS
https://example.com
'@
            }

            Mock -CommandName Write-Host -ModuleName ColorScripts-Enhanced -MockWith {
                param([Parameter(Position = 0)]$Object, [Parameter(Position = 1)]$ForegroundColor)
                $null = $Object
                $null = $ForegroundColor
            }

            Show-ColorScriptHelp -CommandName 'Show-ColorScript'

            Assert-MockCalled -CommandName Get-Help -ModuleName ColorScripts-Enhanced -Times 1 -Exactly
            Assert-MockCalled -CommandName Write-Host -ModuleName ColorScripts-Enhanced -Times 1 -AtLeast -ParameterFilter { $ForegroundColor -eq 'Cyan' }
            Assert-MockCalled -CommandName Write-Host -ModuleName ColorScripts-Enhanced -Times 1 -AtLeast -ParameterFilter { $ForegroundColor -eq 'Yellow' }
            Assert-MockCalled -CommandName Write-Host -ModuleName ColorScripts-Enhanced -Times 1 -AtLeast -ParameterFilter { $ForegroundColor -eq 'Green' }
            Assert-MockCalled -CommandName Write-Host -ModuleName ColorScripts-Enhanced -Times 1 -AtLeast -ParameterFilter { $ForegroundColor -eq 'Magenta' }
            Assert-MockCalled -CommandName Write-Host -ModuleName ColorScripts-Enhanced -Times 1 -AtLeast -ParameterFilter { $ForegroundColor -eq 'DarkGray' }
            Assert-MockCalled -CommandName Write-Host -ModuleName ColorScripts-Enhanced -Times 1 -AtLeast -ParameterFilter { $null -eq $ForegroundColor }

            Remove-Mock -CommandName Get-Help -ModuleName ColorScripts-Enhanced
            Remove-Mock -CommandName Write-Host -ModuleName ColorScripts-Enhanced
        }
    }
}

Describe 'Configuration root resolution' {
    It 'Honors explicit configuration override' {
        $override = Join-Path $TestDrive 'ConfigOverride'
        $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $override

        InModuleScope ColorScripts-Enhanced {
            $script:ConfigurationRoot = $null
            $result = Get-ColorScriptsConfigurationRoot
            $result | Should -Be (Resolve-CachePath -Path $override)
            Test-Path $result | Should -BeTrue
        }
    }

    It 'Builds macOS style path when platform reported as mac' {
        $testRoot = Join-Path $TestDrive 'MacConfig'
        if (-not (Test-Path $testRoot)) { New-Item -ItemType Directory -Path $testRoot | Out-Null }

        Set-Variable -Name IsWindows -Value $false -Scope Global -Force
        Set-Variable -Name IsMacOS -Value $true -Scope Global -Force
        $env:APPDATA = $null
        $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $null

        InModuleScope ColorScripts-Enhanced {
            $script:ConfigurationRoot = $null
            Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                param($Path)
                $null = $Path
                return Join-Path $using:testRoot 'ColorScripts-Enhanced'
            }

            $result = Get-ColorScriptsConfigurationRoot
            $result | Should -Match 'ColorScripts-Enhanced'
            Test-Path $result | Should -BeTrue

            Remove-Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced
        }
    }

    It 'Falls back to XDG config path on Linux' {
        $testRoot = Join-Path $TestDrive 'LinuxConfig'
        if (-not (Test-Path $testRoot)) { New-Item -ItemType Directory -Path $testRoot | Out-Null }

        Set-Variable -Name IsWindows -Value $false -Scope Global -Force
        Set-Variable -Name IsMacOS -Value $false -Scope Global -Force
        Set-Variable -Name IsLinux -Value $true -Scope Global -Force
        $env:XDG_CONFIG_HOME = $testRoot
        $env:APPDATA = $null
        $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $null

        InModuleScope ColorScripts-Enhanced {
            $script:ConfigurationRoot = $null
            $result = Get-ColorScriptsConfigurationRoot
            $result | Should -Match 'ColorScripts-Enhanced'
            Test-Path $result | Should -BeTrue
        }
    }
}

Describe 'Save and initialize configuration' {
    BeforeEach {
        $script:ConfigRootPath = Join-Path $TestDrive ('ConfigRoot_' + [guid]::NewGuid())
        New-Item -ItemType Directory -Path $script:ConfigRootPath | Out-Null
    }

    It 'Skips writing when content unchanged' {
        InModuleScope ColorScripts-Enhanced {
            $script:ConfigurationRoot = $using:ConfigRootPath
            Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $using:ConfigRootPath }

            $config = @{ Cache = @{ Path = $null } }
            $json = ($config | ConvertTo-Json -Depth 6)
            $configPath = Join-Path $using:ConfigRootPath 'config.json'
            Set-Content -Path $configPath -Value ($json + [Environment]::NewLine) -Encoding UTF8
            $timestamp = (Get-Item $configPath).LastWriteTimeUtc

            Start-Sleep -Milliseconds 20
            Save-ColorScriptConfiguration -Configuration $config -ExistingContent ($json + [Environment]::NewLine)

            ((Get-Item $configPath).LastWriteTimeUtc) | Should -Be $timestamp

            Remove-Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced
        }
    }

    It 'Writes new configuration when content differs' {
        InModuleScope ColorScripts-Enhanced {
            $script:ConfigurationRoot = $using:ConfigRootPath
            Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $using:ConfigRootPath }

            $config = @{ Cache = @{ Path = 'custom' } }
            Save-ColorScriptConfiguration -Configuration $config -Force

            $configPath = Join-Path $using:ConfigRootPath 'config.json'
            Test-Path $configPath | Should -BeTrue
            $content = Get-Content -Path $configPath -Raw
            $content | Should -Match '"custom"'

            Remove-Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced
        }
    }

    It 'Handles invalid JSON on initialization' {
        $configPath = Join-Path $script:ConfigRootPath 'config.json'
        Set-Content -Path $configPath -Value '{not-json' -Encoding UTF8

        InModuleScope ColorScripts-Enhanced {
            $script:ConfigurationInitialized = $false
            $script:ConfigurationRoot = $using:ConfigRootPath
            $script:ConfigurationData = $null

            Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $using:ConfigRootPath }
            Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced

            Initialize-Configuration

            Assert-MockCalled -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -Times 1 -AtLeast
            Test-Path $configPath | Should -BeTrue
            $content = Get-Content -Path $configPath -Raw
            $content | Should -Match 'AutoShowOnImport'

            Remove-Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced
            Remove-Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced
        }
    }
}

Describe 'Resolve-CachePath variations' {
    InModuleScope ColorScripts-Enhanced {
        It 'Returns null for whitespace input' {
            Resolve-CachePath -Path '' | Should -Be $null
        }

        It 'Expands tilde into user profile' {
            $result = Resolve-CachePath -Path '~/subfolder'
            $result | Should -Match 'subfolder'
        }

        It 'Resolves relative path against current location' {
            Push-Location $TestDrive
            try {
                $result = Resolve-CachePath -Path 'relative/path'
                $result | Should -Match 'relative'
                $result | Should -Match 'path'
            }
            finally {
                Pop-Location
            }
        }

        It 'Handles invalid drives gracefully' {
            $invalidDrive = 'Z:\does-not-exist\file.txt'
            if (-not (Get-PSDrive -Name 'Z' -ErrorAction SilentlyContinue)) {
                Resolve-CachePath -Path $invalidDrive | Should -Be $null
            }
            else {
                Set-ItResult -Skipped -Because 'Drive Z: exists on this system.'
            }
        }
    }
}

Describe 'Initialize-CacheDirectory scenarios' {
    BeforeEach {
        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $null
        $env:APPDATA = $script:OriginalAppData
        Set-Variable -Name IsWindows -Value $script:OriginalIsWindows -Scope Global -Force
        Set-Variable -Name IsMacOS -Value $script:OriginalIsMacOS -Scope Global -Force
        Set-Variable -Name IsLinux -Value $script:OriginalIsLinux -Scope Global -Force

        InModuleScope ColorScripts-Enhanced {
            $script:CacheDir = $null
            $script:CacheInitialized = $false
        }
    }

    It 'Uses environment override when resolvable' {
        $override = Join-Path $TestDrive 'CacheOverride'
        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $override
        $testDrivePath = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath

        InModuleScope ColorScripts-Enhanced {
            Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                param($Path)
                $null = $Path
                return Join-Path $using:testDrivePath 'CacheOverrideResolved'
            }

            Initialize-CacheDirectory
            $script:CacheDir | Should -Match 'CacheOverrideResolved'
            $script:CacheInitialized | Should -BeTrue

            Remove-Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced
        }
    }

    It 'Falls back to temp directory when candidates fail' {
        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = '::invalid::'
        $env:APPDATA = $null
        Set-Variable -Name IsWindows -Value $false -Scope Global -Force
        Set-Variable -Name IsMacOS -Value $false -Scope Global -Force
        Set-Variable -Name IsLinux -Value $true -Scope Global -Force

        InModuleScope ColorScripts-Enhanced {
            Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith { return $null }

            Initialize-CacheDirectory
            $script:CacheDir | Should -Match 'ColorScripts-Enhanced'
            $script:CacheInitialized | Should -BeTrue

            Remove-Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced
        }
    }
}

Describe 'Metadata table caching' {
    It 'Loads metadata, writes cache, and uses fast path' {
        $cacheRoot = Join-Path $TestDrive ('MetaCache_' + [guid]::NewGuid())
        New-Item -ItemType Directory -Path $cacheRoot | Out-Null

        InModuleScope ColorScripts-Enhanced {
            $script:CacheDir = $cacheRoot
            $script:CacheInitialized = $true
            $script:MetadataCache = $null
            $script:MetadataLastWriteTime = $null

            $first = Get-ColorScriptMetadataTable
            $first.Count | Should -BeGreaterThan 0

            $script:MetadataCache = $null
            $script:MetadataLastWriteTime = $null

            $second = Get-ColorScriptMetadataTable
            $second.Count | Should -Be $first.Count
            $second['bars'].Tags | Should -Contain 'AutoCategorized'
        }
    }
}

Describe 'Script inventory refresh' {
    It 'Refreshes when directory timestamp changes' {
        InModuleScope ColorScripts-Enhanced {
            Reset-ScriptInventoryCache
            $initial = Get-ColorScriptInventory
            $initial | Should -Not -BeNullOrEmpty

            $script:ScriptInventoryInitialized | Should -BeTrue
            $script:ScriptInventoryStamp | Should -Not -Be $null

            $script:ScriptInventoryStamp = $script:ScriptInventoryStamp.AddSeconds(-30)
            $refreshed = Get-ColorScriptInventory
            $refreshed.Count | Should -Be $initial.Count
        }
    }
}
#>
