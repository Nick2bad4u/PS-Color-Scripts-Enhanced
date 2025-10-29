Describe "ColorScripts-Enhanced coverage finalization" {
    BeforeAll {
        $script:ModulePath = Join-Path -Path $PSScriptRoot -ChildPath "..\ColorScripts-Enhanced"
        Import-Module $script:ModulePath -Force

        $script:OriginalHome = $HOME
        $script:OriginalEnv = @{
            HOME           = $env:HOME
            APPDATA        = $env:APPDATA
            XDG            = $env:XDG_CONFIG_HOME
            CONFIG_ROOT    = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
            CACHE_PATH     = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
            AUTOSHOW       = $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT
            CI             = $env:CI
            GITHUB_ACTIONS = $env:GITHUB_ACTIONS
        }
    }

    AfterEach {
        Set-Variable -Name HOME -Scope Global -Force -Value $script:OriginalHome

        $envMap = @{
            HOME           = 'HOME'
            APPDATA        = 'APPDATA'
            XDG            = 'XDG_CONFIG_HOME'
            CONFIG_ROOT    = 'COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT'
            CACHE_PATH     = 'COLOR_SCRIPTS_ENHANCED_CACHE_PATH'
            AUTOSHOW       = 'COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT'
            CI             = 'CI'
            GITHUB_ACTIONS = 'GITHUB_ACTIONS'
        }

        foreach ($entry in $envMap.GetEnumerator()) {
            $value = $script:OriginalEnv[$entry.Key]
            if ($null -eq $value) {
                Remove-Item -Path "Env:$($entry.Value)" -ErrorAction SilentlyContinue
            }
            else {
                Set-Item -Path "Env:$($entry.Value)" -Value $value | Out-Null
            }
        }

        InModuleScope ColorScripts-Enhanced {
            $script:ConfigurationRoot = $null
            $script:ConfigurationPath = $null
            $script:ConfigurationData = $null
            $script:ConfigurationInitialized = $false
            $script:CacheDir = $null
            $script:CacheInitialized = $false
            $script:MetadataCache = $null
            $script:MetadataLastWriteTime = $null
            $script:ShouldProcessOverride = $null
            $script:PowerShellExecutable = $null
            Reset-ScriptInventoryCache
            Initialize-SystemDelegateState

            Remove-Variable -Name __ShouldProcessCall -Scope Script -ErrorAction SilentlyContinue
            Remove-Variable -Name __VerboseMessages -Scope Script -ErrorAction SilentlyContinue
            Remove-Variable -Name __StartupCalled -Scope Script -ErrorAction SilentlyContinue
            Remove-Variable -Name __EncodingCallCount -Scope Script -ErrorAction SilentlyContinue
        }
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context "Invoke-ShouldProcess overrides" {
        It "invokes script override when defined" {
            $result = InModuleScope ColorScripts-Enhanced {
                $script:ShouldProcessOverride = {
                    param($cmdlet, $target, $action)
                    [void]$cmdlet
                    $script:__ShouldProcessCall = '{0}:{1}' -f $target, $action
                    return $false
                }

                [pscustomobject]@{
                    ReturnValue = Invoke-ShouldProcess -Cmdlet $null -Target 'alpha' -Action 'beta'
                    CallInfo    = $script:__ShouldProcessCall
                }
            }

            $result.ReturnValue | Should -BeFalse
            $result.CallInfo | Should -Be 'alpha:beta'
        }
    }

    Context "Configuration root selection" {
        It "selects macOS application support directory" {
            $homePath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            New-Item -ItemType Directory -Path $homePath -Force | Out-Null

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ TestHome = $homePath } {
                param($TestHome)
                $original = @{
                    ConfigRoot = $script:ConfigurationRoot
                    IsWindows  = $script:IsWindows
                    IsMacOS    = $script:IsMacOS
                    CacheInit  = $script:CacheInitialized
                }
                $originalHome     = $HOME
                $originalEnvHome  = $env:HOME
                $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
                $originalAppData  = $env:APPDATA
                $originalXdg      = $env:XDG_CONFIG_HOME

                try {
                    $script:ConfigurationRoot = $null
                    $script:IsWindows = $false
                    $script:IsMacOS = $true
                    $script:CacheInitialized = $false
                    Set-Variable -Name HOME -Scope Global -Force -Value $TestHome
                    $env:HOME = $TestHome
                    $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $null
                    $env:APPDATA = $null
                    $env:XDG_CONFIG_HOME = $null

                    $expected = Join-Path -Path $TestHome -ChildPath 'Library\Application Support\ColorScripts-Enhanced'
                    if (Test-Path -LiteralPath $expected) {
                        Remove-Item -LiteralPath $expected -Recurse -Force -ErrorAction SilentlyContinue
                    }

                    $resolved = Get-ColorScriptsConfigurationRoot
                    [pscustomobject]@{
                        Expected = (Resolve-Path -LiteralPath $expected).ProviderPath
                        Result   = $resolved
                    }
                }
                finally {
                    $script:ConfigurationRoot = $original.ConfigRoot
                    $script:IsWindows = $original.IsWindows
                    $script:IsMacOS = $original.IsMacOS
                    $script:CacheInitialized = $original.CacheInit
                    Set-Variable -Name HOME -Scope Global -Force -Value $originalHome
                    $env:HOME = $originalEnvHome
                    $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $originalOverride
                    $env:APPDATA = $originalAppData
                    $env:XDG_CONFIG_HOME = $originalXdg
                }
            }

            $result.Result | Should -Be $result.Expected
        }

        It "uses XDG config path when defined" {
            $homePath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            $xdgPath  = Join-Path -Path $homePath -ChildPath '.config'
            New-Item -ItemType Directory -Path $xdgPath -Force | Out-Null

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ TestHome = $homePath; XdgRoot = $xdgPath } {
                param($TestHome, $XdgRoot)
                $original = @{
                    ConfigRoot = $script:ConfigurationRoot
                    IsWindows  = $script:IsWindows
                    IsMacOS    = $script:IsMacOS
                }
                $originalHome     = $HOME
                $originalEnvHome  = $env:HOME
                $originalXdg      = $env:XDG_CONFIG_HOME
                $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
                $originalAppData  = $env:APPDATA

                try {
                    $script:ConfigurationRoot = $null
                    $script:IsWindows = $false
                    $script:IsMacOS = $false
                    Set-Variable -Name HOME -Scope Global -Force -Value $TestHome
                    $env:HOME = $TestHome
                    $env:XDG_CONFIG_HOME = $XdgRoot
                    $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $null
                    $env:APPDATA = $null

                    $expected = Join-Path -Path $XdgRoot -ChildPath 'ColorScripts-Enhanced'
                    if (Test-Path -LiteralPath $expected) {
                        Remove-Item -LiteralPath $expected -Recurse -Force -ErrorAction SilentlyContinue
                    }

                    $resolved = Get-ColorScriptsConfigurationRoot
                    [pscustomobject]@{
                        Expected = (Resolve-Path -LiteralPath $expected).ProviderPath
                        Result   = $resolved
                    }
                }
                finally {
                    $script:ConfigurationRoot = $original.ConfigRoot
                    $script:IsWindows = $original.IsWindows
                    $script:IsMacOS = $original.IsMacOS
                    Set-Variable -Name HOME -Scope Global -Force -Value $originalHome
                    $env:HOME = $originalEnvHome
                    $env:XDG_CONFIG_HOME = $originalXdg
                    $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $originalOverride
                    $env:APPDATA = $originalAppData
                }
            }

            $result.Result | Should -Be $result.Expected
        }
    }

    Context "Resolve-CachePath fallbacks" {
        It "expands tilde using profile delegate" {
            $customHome = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'profile-home'
            New-Item -ItemType Directory -Path $customHome -Force | Out-Null

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ HomePath = $customHome } {
                param($HomePath)
                [void]$HomePath
                $original = $script:GetUserProfilePathDelegate
                try {
                    $script:GetUserProfilePathDelegate = { $HomePath }
                    Resolve-CachePath -Path '~\cache'
                }
                finally {
                    $script:GetUserProfilePathDelegate = $original
                }
            }

            $result | Should -Be (Join-Path -Path $customHome -ChildPath 'cache')
        }

        It "logs verbose when rooted evaluation fails" {
            $messages = InModuleScope ColorScripts-Enhanced {
                $original = $script:IsPathRootedDelegate
                try {
                    $script:IsPathRootedDelegate = { throw [System.Exception]::new('rooted failure') }
                    $script:__VerboseMessages = [System.Collections.Generic.List[string]]::new()

                    Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Message)
                        $null = $script:__VerboseMessages.Add($Message)
                    }

                    Resolve-CachePath -Path 'relative\path' | Out-Null
                    $script:__VerboseMessages.ToArray()
                }
                finally {
                    $script:IsPathRootedDelegate = $original
                }
            }

            ($messages | Where-Object { $_ -like 'Unable to evaluate rooted state*' }) | Should -Not -BeNullOrEmpty
        }
    }

    Context "Get-ColorScriptInventory refresh scenarios" {
        It "treats minimum timestamp as null" {
            $stamp = InModuleScope ColorScripts-Enhanced {
                $original = $script:DirectoryGetLastWriteTimeUtcDelegate
                try {
                    $script:DirectoryGetLastWriteTimeUtcDelegate = { [datetime]::MinValue }
                    Reset-ScriptInventoryCache
                    $null = Get-ColorScriptInventory -Raw
                    $script:ScriptInventoryStamp
                }
                finally {
                    $script:DirectoryGetLastWriteTimeUtcDelegate = $original
                }
            }

            $stamp | Should -BeNullOrEmpty
        }

        It "refreshes inventory when directory timestamp changes" {
            InModuleScope ColorScripts-Enhanced {
                $original = $script:DirectoryGetLastWriteTimeUtcDelegate
                try {
                    $firstStamp = [datetime]::UtcNow
                    $script:DirectoryGetLastWriteTimeUtcDelegate = { $firstStamp }
                    Reset-ScriptInventoryCache
                    $null = Get-ColorScriptInventory -Raw

                    $script:ScriptInventoryInitialized | Should -BeTrue
                    $script:ScriptInventoryStamp | Should -Be $firstStamp

                    $script:DirectoryGetLastWriteTimeUtcDelegate = { $firstStamp.AddMinutes(1) }
                    $null = Get-ColorScriptInventory -Raw
                    $script:ScriptInventoryStamp | Should -BeGreaterThan $firstStamp
                }
                finally {
                    $script:DirectoryGetLastWriteTimeUtcDelegate = $original
                }
            }
        }
    }

    Context "Get-PowerShellExecutable fallback" {
        It "falls back to command line when process module is unavailable" {
            $result = InModuleScope ColorScripts-Enhanced {
                $script:PowerShellExecutable = $null
                Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith { $null }
                $script:GetCurrentProcessDelegate = { [pscustomobject]@{ MainModule = $null } }

                Get-PowerShellExecutable
            }

            $result | Should -Be ([System.Environment]::GetCommandLineArgs()[0])
        }
    }

    Context "Invoke-WithUtf8Encoding verbose coverage" {
        It "logs verbose when console encoding cannot be read" {
            $messages = InModuleScope ColorScripts-Enhanced {
                $script:IsOutputRedirectedDelegate = { $false }
                $script:GetConsoleOutputEncodingDelegate = { throw [System.IO.IOException]::new('unavailable') }
                $script:__VerboseMessages = [System.Collections.Generic.List[string]]::new()

                Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Message)
                    [void]$Message
                    $null = $script:__VerboseMessages.Add($Message)
                }

                Invoke-WithUtf8Encoding -ScriptBlock { 'value' } | Out-Null
                $script:__VerboseMessages.ToArray()
            }

            $messages | Should -Contain 'Console handle unavailable; skipping OutputEncoding change.'
        }

        It "logs verbose when console encoding cannot be restored" {
            $messages = InModuleScope ColorScripts-Enhanced {
                $script:IsOutputRedirectedDelegate = { $false }
                $script:GetConsoleOutputEncodingDelegate = { [System.Text.Encoding]::Unicode }
                $script:__EncodingCallCount = 0
                $script:SetConsoleOutputEncodingDelegate = {
                    param([System.Text.Encoding]$Encoding)
                    [void]$Encoding
                    $script:__EncodingCallCount++
                    if ($script:__EncodingCallCount -gt 1) {
                        throw [System.IO.IOException]::new('restore failure')
                    }
                }
                $script:__VerboseMessages = [System.Collections.Generic.List[string]]::new()

                Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Message)
                    $null = $script:__VerboseMessages.Add($Message)
                }

                Invoke-WithUtf8Encoding -ScriptBlock { 'value' } | Out-Null
                $script:__VerboseMessages.ToArray()
            }

            $messages | Should -Contain 'Console handle unavailable; unable to restore OutputEncoding.'
        }
    }

    Context "Write-RenderedText fallback" {
        It "writes to pipeline when console output fails" {
            $result = InModuleScope ColorScripts-Enhanced {
                $original = $script:ConsoleWriteDelegate
                try {
                    $script:ConsoleWriteDelegate = {
                        param($Text)
                        [void]$Text
                        throw [System.IO.IOException]::new('console unavailable')
                    }
                    Write-RenderedText -Text 'fallback text'
                }
                finally {
                    $script:ConsoleWriteDelegate = $original
                }
            }

            $result | Should -Be 'fallback text'
        }
    }

    Context "Initialize-CacheDirectory fallback" {
        It "creates fallback directory when all candidates fail" {
            $result = InModuleScope ColorScripts-Enhanced {
                $script:ConfigurationInitialized = $true
                $script:ConfigurationRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $script:ConfigurationRoot -Force | Out-Null
                $script:CacheInitialized = $false
                $script:CacheDir = $null

                Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith { $null }

                Initialize-CacheDirectory

                $expected = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ColorScripts-Enhanced'
                [pscustomobject]@{
                    CacheDir    = $script:CacheDir
                    Expected    = (Resolve-Path -LiteralPath $expected).ProviderPath
                    Initialized = $script:CacheInitialized
                }
            }

            $result.Initialized | Should -BeTrue
            $result.CacheDir | Should -Be $result.Expected
        }
    }

    Context "Metadata normalization coverage" {
        It "combines manual and automatic metadata values" {
            $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            $scriptsDir = Join-Path -Path $root -ChildPath 'scripts'
            $cacheDir = Join-Path -Path $root -ChildPath 'cache'
            New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
            New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null

            foreach ($name in @('manual-script', 'list-script', 'string-script', 'auto-script', 'plain-script')) {
                $scriptFile = Join-Path -Path $scriptsDir -ChildPath "$name.ps1"
                $content = "Write-Host '$name'"
                Set-Content -LiteralPath $scriptFile -Value $content -Encoding UTF8
            }

            $metadataPath = Join-Path -Path $root -ChildPath 'metadata.psd1'
            $metadataContent = @'
@{
    Categories = @{
        Manual = @('manual-script')
    }
    Tags = @{
        'manual-script' = 'ManualTag'
        'list-script'   = @('TagListA','TagListB')
    }
    AutoCategories = @(
        @{ Category = 'AutoRule'; Patterns = @('^auto-script$','^list-script$'); Tags = @('AutoTag','EnumTag') }
        @{ Category = 'AutoString'; Patterns = '^string-script$'; Tags = 'SingleAuto' }
    )
}
'@
            Set-Content -LiteralPath $metadataPath -Value $metadataContent -Encoding UTF8

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ MetaPath = $metadataPath; ScriptPath = $scriptsDir; CachePath = $cacheDir } {
                param($MetaPath, $ScriptPath, $CachePath)
                $original = @{
                    MetadataPath = $script:MetadataPath
                    ScriptsPath  = $script:ScriptsPath
                    CacheDir     = $script:CacheDir
                    CacheInit    = $script:CacheInitialized
                    MetadataCache = $script:MetadataCache
                    MetadataLastWriteTime = $script:MetadataLastWriteTime
                }
                try {
                    $script:MetadataPath = $MetaPath
                    $script:ScriptsPath = $ScriptPath
                    $script:CacheDir = $CachePath
                    $script:CacheInitialized = $true
                    $script:MetadataCache = $null
                    $script:MetadataLastWriteTime = $null
                    Reset-ScriptInventoryCache

                    $store = Get-ColorScriptMetadataTable
                    $entry = Get-ColorScriptEntry -Name 'plain-script'

                    [pscustomobject]@{
                        Store = $store
                        Entry = $entry
                    }
                }
                finally {
                    $script:MetadataPath = $original.MetadataPath
                    $script:ScriptsPath = $original.ScriptsPath
                    $script:CacheDir = $original.CacheDir
                    $script:CacheInitialized = $original.CacheInit
                    $script:MetadataCache = $original.MetadataCache
                    $script:MetadataLastWriteTime = $original.MetadataLastWriteTime
                }
            }

            $store = $result.Store

            (($store['manual-script']).Category) | Should -Be 'Manual'
            (($store['manual-script']).Tags) | Should -Contain 'ManualTag'
            (($store['manual-script']).Tags) | Should -Contain 'Category:Manual'

            (($store['list-script']).Categories) | Should -Contain 'AutoRule'
            (($store['list-script']).Tags) | Should -Contain 'EnumTag'

            (($store['string-script']).Category) | Should -Be 'AutoString'
            (($store['string-script']).Tags) | Should -Contain 'SingleAuto'

            (($store['auto-script']).Category) | Should -Be 'AutoRule'
            (($store['auto-script']).Tags) | Should -Contain 'AutoTag'

            $plain = $result.Entry | Select-Object -First 1
            $plain.Category | Should -Be 'Abstract'
            $plain.Tags | Should -Contain 'Category:Abstract'
            $plain.Tags | Should -Contain 'AutoCategorized'
        }
    }

    Context "Get-CachedOutput coverage" {
        It "returns placeholder object when cache entry missing" {
            $missingPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'missing-script.ps1'

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ ScriptPath = $missingPath } {
                param($ScriptPath)
                Get-CachedOutput -ScriptPath $ScriptPath
            }

            $result.Available | Should -BeFalse
            $result.CacheFile | Should -BeNullOrEmpty
            $result.Content | Should -Be ''
            $result.LastWriteTime | Should -BeNullOrEmpty
        }
    }

    Context "Invoke-ColorScriptProcess coverage" {
        It "returns descriptive error when script path missing" {
            $missingPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'missing-script.ps1'

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ ScriptPath = $missingPath } {
                param($ScriptPath)
                Invoke-ColorScriptProcess -ScriptPath $ScriptPath
            }

            $result.Success | Should -BeFalse
            $result.StdErr | Should -Be 'Script path not found.'
        }
    }

    Context "Show-ColorScript selection" {
        It "selects the first matching script for wildcard names" {
            $results = Show-ColorScript -Name 'ansi-star-wars-*' -ReturnText -PassThru
            $metadata = $results | Where-Object { $_ -isnot [string] } | Select-Object -First 1
            $metadata.Name | Should -Be 'ansi-star-wars-fil-annie'
        }
    }

    Context "Export-ColorScriptMetadata resilience" {
        It "logs verbose when cache info cannot be retrieved" {
            $outputPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'metadata.json'

            InModuleScope ColorScripts-Enhanced -Parameters @{ OutputPath = $outputPath } {
                param($OutputPath)
                $script:ConfigurationInitialized = $true
                $script:ConfigurationRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $script:ConfigurationRoot -Force | Out-Null
                $script:CacheInitialized = $true
                $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                $cacheFile = Join-Path -Path $script:CacheDir -ChildPath 'bars.cache'
                Set-Content -LiteralPath $cacheFile -Value 'cached' -Encoding UTF8
                $scriptPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'bars.ps1'
                Set-Content -LiteralPath $scriptPath -Value "Write-Host 'bars'" -Encoding UTF8

                Mock -CommandName Write-Verbose -MockWith {
                    param($Message)
                    [void]$Message
                }

                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        Name        = 'bars'
                        Category    = 'Test'
                        Categories  = @('Test')
                        Tags        = @()
                        Description = 'Mock entry'
                        Path        = $scriptPath
                    }
                }

                Mock -CommandName Get-Item -ParameterFilter { $LiteralPath -like '*bars.cache' } -MockWith {
                    throw [System.IO.IOException]::new('cache lookup failed')
                }

                $data = Export-ColorScriptMetadata -IncludeCacheInfo
                $json = $data | ConvertTo-Json -Depth 6
                [System.IO.File]::WriteAllText($OutputPath, $json, [System.Text.Encoding]::UTF8)
                Assert-MockCalled Write-Verbose -Exactly 1 -Scope It -ParameterFilter { $Message -like 'Unable to read cache info*' }
            }

            Test-Path -LiteralPath $outputPath | Should -BeTrue
        }
    }

    Context "Build-ColorScriptCache ShouldProcess" {
        It "reports skipped status when ShouldProcess declines" {
            $result = InModuleScope ColorScripts-Enhanced {
                $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                $script:CacheInitialized = $true

                $script:ShouldProcessEvaluator = {
                    param($cmdlet, $target, $action)
                    [void]$cmdlet
                    [void]$target
                    if ($action -like 'Build cache for*') { $true } else { $false }
                }

                Build-ColorScriptCache -Name 'bars' -PassThru
            }

            $resultArray = @($result)
            $resultArray | Should -Not -BeNullOrEmpty
            ($resultArray | Select-Object -First 1).Status | Should -Be 'SkippedByUser'
        }
    }

    Context "Clear-ColorScriptCache missing entries" {
        It "adds missing results when cache records are absent" {
            $results = InModuleScope ColorScripts-Enhanced {
                $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                $script:CacheInitialized = $true

                Mock -CommandName Select-RecordsByName -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        Records = @()
                        MissingPatterns = @()
                        MatchMap = @(
                            [pscustomobject]@{ Pattern = 'ghost'; IsWildcard = $false; Matched = $false; Matches = @() }
                            [pscustomobject]@{ Pattern = 'missing'; IsWildcard = $false; Matched = $true; Matches = @('missing') }
                        )
                    }
                }

                Clear-ColorScriptCache -Name @('ghost', 'missing')
            }

            $results | Should -HaveCount 2
            ($results | Where-Object { $_.Name -eq 'ghost' }).Status | Should -Be 'Missing'
            ($results | Where-Object { $_.Name -eq 'missing' }).Status | Should -Be 'Missing'
        }
    }

    Context "Invoke-ColorScriptsStartup override" {
        It "continues when override is enabled even if config root fails" {
            $result = InModuleScope ColorScripts-Enhanced {
                $env:CI = 'false'
                $env:GITHUB_ACTIONS = 'false'
                $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT = 'true'

                Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith {
                    throw [System.Exception]::new('config failure')
                }
                Mock -CommandName Get-ConfigurationDataInternal -ModuleName ColorScripts-Enhanced -MockWith {
                    @{ Startup = @{ AutoShowOnImport = $false; DefaultScript = 'bars' } }
                }
                Mock -CommandName Show-ColorScript -ModuleName ColorScripts-Enhanced -MockWith {
                    param([string]$Name, [switch]$ReturnText, [switch]$PassThru)
                    [void]$Name
                    [void]$ReturnText
                    [void]$PassThru
                    $script:__StartupCalled = $true
                    'rendered'
                }

                Invoke-ColorScriptsStartup
                $script:__StartupCalled
            }

            $result | Should -BeTrue
        }
    }
}
