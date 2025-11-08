Describe 'ColorScripts-Enhanced coverage completion' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
        $script:OriginalModuleRootOverride = $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT
        $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT = $script:ModuleRoot
        Import-Module $script:ModuleManifest -Force
        $script:OriginalHome = $HOME
        $script:OriginalEnvHome = $env:HOME
        $script:OriginalTemp = $env:TEMP
        $script:OriginalTmp = $env:TMP

        $script:IsCIEnvironment = $false
        if (-not [string]::IsNullOrWhiteSpace($env:CI)) {
            $normalizedCi = $env:CI.Trim()
            if ([System.String]::Equals($normalizedCi, 'true', [System.StringComparison]::OrdinalIgnoreCase) -or
                [System.String]::Equals($normalizedCi, '1', [System.StringComparison]::OrdinalIgnoreCase) -or
                [System.String]::Equals($normalizedCi, 'yes', [System.StringComparison]::OrdinalIgnoreCase)) {
                $script:IsCIEnvironment = $true
            }
        }
    }

    AfterEach {
        InModuleScope ColorScripts-Enhanced {
            $script:CacheDir = $null
            $script:CacheInitialized = $false
            $script:ConfigurationData = $null
            $script:ConfigurationInitialized = $false
            $script:MetadataCache = $null
            $script:MetadataLastWriteTime = $null
            $script:ShouldProcessEvaluator = {
                param(
                    [System.Management.Automation.PSCmdlet]$Cmdlet,
                    [object]$Target,
                    [string]$Action
                )

                $Cmdlet.ShouldProcess($Target, $Action)
            }
        }

        Set-Variable -Name HOME -Scope Global -Force -Value $script:OriginalHome
        if ($null -eq $script:OriginalEnvHome) {
            Remove-Item Env:HOME -ErrorAction SilentlyContinue
        }
        else {
            $env:HOME = $script:OriginalEnvHome
        }

        if ($null -eq $script:OriginalTemp) {
            Remove-Item Env:TEMP -ErrorAction SilentlyContinue
        }
        else {
            $env:TEMP = $script:OriginalTemp
        }

        if ($null -eq $script:OriginalTmp) {
            Remove-Item Env:TMP -ErrorAction SilentlyContinue
        }
        else {
            $env:TMP = $script:OriginalTmp
        }
    }


    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue

        if ($null -ne $script:OriginalModuleRootOverride) {
            $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT = $script:OriginalModuleRootOverride
        }
        else {
            Remove-Item Env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT -ErrorAction SilentlyContinue
        }
    }

    Context 'Configuration root platform coverage' {
        It 'selects macOS application support location' -Skip:($PSVersionTable.PSVersion.Major -le 5) {
            $testHome = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            New-Item -ItemType Directory -Path $testHome -Force | Out-Null

            InModuleScope ColorScripts-Enhanced -Parameters @{ customHome = $testHome } {
                param($customHome)
                $original = @{
                    ConfigRoot       = $script:ConfigurationRoot
                    IsWindows        = $script:IsWindows
                    IsMacOS          = $script:IsMacOS
                    CacheInitialized = $script:CacheInitialized
                }
                $originalHome = $HOME
                $originalEnvHome = $env:HOME
                $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
                $originalAppData = $env:APPDATA
                $originalXdg = $env:XDG_CONFIG_HOME

                try {
                    $script:ConfigurationRoot = $null
                    $script:IsWindows = $false
                    $script:IsMacOS = $true
                    $script:CacheInitialized = $false
                    $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $null
                    $env:APPDATA = $null
                    $env:XDG_CONFIG_HOME = $null
                    Set-Variable -Name HOME -Scope Global -Force -Value $customHome
                    $env:HOME = $customHome

                    $expected = Join-Path -Path $customHome -ChildPath 'Library\Application Support\ColorScripts-Enhanced'
                    if (Test-Path -LiteralPath $expected) {
                        Remove-Item -LiteralPath $expected -Recurse -Force -ErrorAction SilentlyContinue
                    }

                    $result = Get-ColorScriptsConfigurationRoot
                    Test-Path -LiteralPath $expected | Should -BeTrue
                    $resolvedExpected = (Resolve-Path -LiteralPath $expected).ProviderPath
                    $result | Should -Be $resolvedExpected
                }
                finally {
                    $script:ConfigurationRoot = $original.ConfigRoot
                    $script:IsWindows = $original.IsWindows
                    $script:IsMacOS = $original.IsMacOS
                    $script:CacheInitialized = $original.CacheInitialized
                    Set-Variable -Name HOME -Scope Global -Force -Value $originalHome
                    $env:HOME = $originalEnvHome
                    $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $originalOverride
                    $env:APPDATA = $originalAppData
                    $env:XDG_CONFIG_HOME = $originalXdg
                }
            }
        }

        It 'uses XDG config location when available' -Skip:($PSVersionTable.PSVersion.Major -le 5) {
            $testHome = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            $xdgRoot = Join-Path -Path $testHome -ChildPath '.config'
            New-Item -ItemType Directory -Path $xdgRoot -Force | Out-Null

            InModuleScope ColorScripts-Enhanced -Parameters @{ xdgRootPath = $xdgRoot; customHome = $testHome } {
                param($xdgRootPath, $customHome)
                $original = @{
                    ConfigRoot = $script:ConfigurationRoot
                    IsWindows  = $script:IsWindows
                    IsMacOS    = $script:IsMacOS
                }
                $originalHome = $HOME
                $originalEnvHome = $env:HOME
                $originalXdg = $env:XDG_CONFIG_HOME
                $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
                $originalAppData = $env:APPDATA

                try {
                    $script:ConfigurationRoot = $null
                    $script:IsWindows = $false
                    $script:IsMacOS = $false
                    Set-Variable -Name HOME -Scope Global -Force -Value $customHome
                    $env:HOME = $customHome
                    $env:XDG_CONFIG_HOME = $xdgRootPath
                    $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $null
                    $env:APPDATA = $null

                    $expected = Join-Path -Path $xdgRootPath -ChildPath 'ColorScripts-Enhanced'
                    if (Test-Path -LiteralPath $expected) {
                        Remove-Item -LiteralPath $expected -Recurse -Force -ErrorAction SilentlyContinue
                    }

                    $result = Get-ColorScriptsConfigurationRoot
                    Test-Path -LiteralPath $expected | Should -BeTrue
                    $resolvedExpected = (Resolve-Path -LiteralPath $expected).ProviderPath
                    $result | Should -Be $resolvedExpected
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
        }
    }

    Context 'Resolve-CachePath additional coverage' {
        It 'uses user profile delegate when expanding tilde path' {
            $customHome = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'profile-home'
            New-Item -ItemType Directory -Path $customHome -Force | Out-Null

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ customHome = $customHome } {
                param($customHome)
                $homePath = $customHome
                $original = $script:GetUserProfilePathDelegate
                try {
                    $script:GetUserProfilePathDelegate = { $homePath }
                    Resolve-CachePath -Path '~\cache'
                }
                finally {
                    $script:GetUserProfilePathDelegate = $original
                }
            }

            $result | Should -Be (Join-Path -Path $customHome -ChildPath 'cache')
        }

        It 'logs verbose when rooted evaluation fails' {
            $result = InModuleScope ColorScripts-Enhanced {
                $originalDelegate = $script:IsPathRootedDelegate
                try {
                    $script:IsPathRootedDelegate = {
                        throw [System.Exception]::new('rooted failure')
                    }
                    $script:__Verbose = [System.Collections.Generic.List[string]]::new()
                    Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Message)
                        $null = $script:__Verbose.Add($Message)
                    }

                    $value = Resolve-CachePath -Path 'relative/path'
                    [pscustomobject]@{
                        Value    = $value
                        Messages = $script:__Verbose.ToArray()
                    }
                }
                finally {
                    $script:IsPathRootedDelegate = $originalDelegate
                    Remove-Variable -Name __Verbose -Scope Script -ErrorAction SilentlyContinue
                }
            }

            $result.Value | Should -Be $null
            ($result.Messages | Where-Object { $_ -like 'Unable to evaluate rooted state*' }) | Should -Not -BeNullOrEmpty
        }

        It 'expands bare tilde to the user profile' {
            $customHome = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'bare-tilde-home'
            New-Item -ItemType Directory -Path $customHome -Force | Out-Null

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ customHomePath = $customHome } {
                param($customHomePath)
                $homeValue = $customHomePath
                $original = $script:GetUserProfilePathDelegate
                try {
                    $script:GetUserProfilePathDelegate = { $homeValue }
                    Resolve-CachePath -Path '~'
                }
                finally {
                    $script:GetUserProfilePathDelegate = $original
                }
            }

            $result | Should -Be $customHome
        }
    }

    Context 'Get-ColorScriptInventory edge cases' {
        It 'treats minimum timestamp as null' {
            InModuleScope ColorScripts-Enhanced {
                $originalDelegate = $script:DirectoryGetLastWriteTimeUtcDelegate
                try {
                    $script:DirectoryGetLastWriteTimeUtcDelegate = { [datetime]::MinValue }
                    Reset-ScriptInventoryCache

                    $null = Get-ColorScriptInventory -Raw
                    $script:ScriptInventoryStamp | Should -BeNullOrEmpty
                }
                finally {
                    $script:DirectoryGetLastWriteTimeUtcDelegate = $originalDelegate
                }
            }
        }

        It 'refreshes inventory when timestamp retrieval fails' {
            InModuleScope ColorScripts-Enhanced {
                $originalDelegate = $script:DirectoryGetLastWriteTimeUtcDelegate
                try {
                    $script:DirectoryGetLastWriteTimeUtcDelegate = { throw [System.IO.IOException]::new('timestamp failure') }
                    $script:ScriptInventoryInitialized = $true
                    $script:ScriptInventoryStamp = [datetime]::UtcNow
                    $script:ScriptInventory = @()
                    $script:ScriptInventoryRecords = @()

                    $null = Get-ColorScriptInventory -Raw
                    $script:ScriptInventoryStamp | Should -BeNullOrEmpty
                }
                finally {
                    $script:DirectoryGetLastWriteTimeUtcDelegate = $originalDelegate
                }
            }
        }

        It 'refreshes when stamp was previously missing' {
            $scriptsRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            New-Item -ItemType Directory -Path $scriptsRoot -Force | Out-Null
            $scriptPath = Join-Path -Path $scriptsRoot -ChildPath 'refresh.ps1'
            Set-Content -LiteralPath $scriptPath -Value "Write-Host 'refresh'" -Encoding UTF8

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $scriptsRoot } {
                param($root)
                $timestamp = [datetime]::UtcNow
                $originalState = @{
                    ScriptsPath       = $script:ScriptsPath
                    DirectoryDelegate = $script:DirectoryGetLastWriteTimeUtcDelegate
                    Inventory         = $script:ScriptInventory
                    Records           = $script:ScriptInventoryRecords
                    Initialized       = $script:ScriptInventoryInitialized
                    Stamp             = $script:ScriptInventoryStamp
                }

                try {
                    $script:ScriptsPath = $root
                    $script:DirectoryGetLastWriteTimeUtcDelegate = { $timestamp }
                    $script:ScriptInventoryInitialized = $true
                    $script:ScriptInventoryStamp = $null
                    $script:ScriptInventory = @()
                    $script:ScriptInventoryRecords = @()

                    $inventory = Get-ColorScriptInventory -Raw
                    [pscustomobject]@{
                        Inventory = $inventory
                        Stamp     = $script:ScriptInventoryStamp
                    }
                }
                finally {
                    $script:ScriptsPath = $originalState.ScriptsPath
                    $script:DirectoryGetLastWriteTimeUtcDelegate = $originalState.DirectoryDelegate
                    $script:ScriptInventory = $originalState.Inventory
                    $script:ScriptInventoryRecords = $originalState.Records
                    $script:ScriptInventoryInitialized = $originalState.Initialized
                    $script:ScriptInventoryStamp = $originalState.Stamp
                }
            }

            $result.Inventory | Should -Not -BeNullOrEmpty
            $result.Stamp | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Get-PowerShellExecutable fallback coverage' {
        It 'falls back to command line arguments when process module lacks filename' {
            InModuleScope ColorScripts-Enhanced {
                $script:PowerShellExecutable = $null
            }

            Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith { $null }

            $result = InModuleScope ColorScripts-Enhanced {
                $original = $script:GetCurrentProcessDelegate
                try {
                    $script:GetCurrentProcessDelegate = { [pscustomobject]@{ MainModule = [pscustomobject]@{ FileName = $null } } }
                    Get-PowerShellExecutable
                }
                finally {
                    $script:GetCurrentProcessDelegate = $original
                }
            }

            $result | Should -Be ([System.Environment]::GetCommandLineArgs()[0])
        }

        It 'uses command line when process delegate returns null' {
            InModuleScope ColorScripts-Enhanced {
                $script:PowerShellExecutable = $null
            }

            Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith { $null }

            $value = InModuleScope ColorScripts-Enhanced {
                $original = $script:GetCurrentProcessDelegate
                try {
                    $script:GetCurrentProcessDelegate = { $null }
                    Get-PowerShellExecutable
                }
                finally {
                    $script:GetCurrentProcessDelegate = $original
                }
            }

            $value | Should -Be ([System.Environment]::GetCommandLineArgs()[0])
        }
    }

    Context 'Invoke-WithUtf8Encoding error handling' {
        It 'skips encoding changes when console handles are unavailable' {
            $messages = InModuleScope ColorScripts-Enhanced {
                $originalIsRedirected = $script:IsOutputRedirectedDelegate
                $originalGetEncoding = $script:GetConsoleOutputEncodingDelegate
                $originalSetEncoding = $script:SetConsoleOutputEncodingDelegate
                try {
                    $script:IsOutputRedirectedDelegate = { $false }
                    $script:GetConsoleOutputEncodingDelegate = { throw [System.IO.IOException]::new('no console') }
                    $script:SetConsoleOutputEncodingDelegate = {
                        throw [System.InvalidOperationException]::new('should not set')
                    }
                    $script:__Verbose = [System.Collections.Generic.List[string]]::new()
                    Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Message)
                        $null = $script:__Verbose.Add($Message)
                    }

                    Invoke-WithUtf8Encoding -ScriptBlock { 42 } | Out-Null
                    $script:__Verbose.ToArray()
                }
                finally {
                    $script:IsOutputRedirectedDelegate = $originalIsRedirected
                    $script:GetConsoleOutputEncodingDelegate = $originalGetEncoding
                    $script:SetConsoleOutputEncodingDelegate = $originalSetEncoding
                    Remove-Variable -Name __Verbose -Scope Script -ErrorAction SilentlyContinue
                }
            }

            ($messages | Where-Object { $_ -like 'Console handle unavailable; skipping OutputEncoding change*' }) | Should -Not -BeNullOrEmpty
        }

        It 'logs verbose when output encoding cannot be restored' {
            $messages = InModuleScope ColorScripts-Enhanced {
                $originalIsRedirected = $script:IsOutputRedirectedDelegate
                $originalGetEncoding = $script:GetConsoleOutputEncodingDelegate
                $originalSetEncoding = $script:SetConsoleOutputEncodingDelegate
                $originalConsoleEncoding = [Console]::OutputEncoding
                $originalVerbosePreference = $VerbosePreference
                try {
                    $script:IsOutputRedirectedDelegate = { $false }
                    $script:GetConsoleOutputEncodingDelegate = { [System.Text.Encoding]::Unicode }
                    $script:__EncodingCalls = [System.Collections.Generic.List[string]]::new()
                    $script:SetConsoleOutputEncodingDelegate = {
                        param([System.Text.Encoding]$Encoding)
                        if ($Encoding.WebName -ieq 'utf-8') {
                            $null = $script:__EncodingCalls.Add('set')
                            [Console]::OutputEncoding = $Encoding
                        }
                        else {
                            $null = $script:__EncodingCalls.Add('restore')
                            throw [System.IO.IOException]::new('restore failure')
                        }
                    }
                    $script:__Verbose = [System.Collections.Generic.List[string]]::new()
                    Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Message)
                        $null = $script:__Verbose.Add($Message)
                    }
                    $VerbosePreference = 'Continue'

                    Invoke-WithUtf8Encoding -ScriptBlock { }
                    [pscustomobject]@{
                        Messages = $script:__Verbose.ToArray()
                        Calls    = $script:__EncodingCalls.ToArray()
                    }
                }
                finally {
                    [Console]::OutputEncoding = $originalConsoleEncoding
                    $script:IsOutputRedirectedDelegate = $originalIsRedirected
                    $script:GetConsoleOutputEncodingDelegate = $originalGetEncoding
                    $script:SetConsoleOutputEncodingDelegate = $originalSetEncoding
                    $VerbosePreference = $originalVerbosePreference
                    Remove-Variable -Name __Verbose -Scope Script -ErrorAction SilentlyContinue
                    Remove-Variable -Name __EncodingCalls -Scope Script -ErrorAction SilentlyContinue
                }
            }
            $messages.Calls | Should -Contain 'restore'
            ($messages.Messages | Where-Object { $_ -like 'Console handle unavailable; unable to restore OutputEncoding*' }) | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Write-RenderedText fallback' {
        It 'falls back to pipeline output when console write fails' {
            $result = InModuleScope ColorScripts-Enhanced {
                $originalDelegate = $script:ConsoleWriteDelegate
                try {
                    $script:ConsoleWriteDelegate = {
                        throw [System.IO.IOException]::new('console unavailable')
                    }
                    $script:__Verbose = [System.Collections.Generic.List[string]]::new()
                    Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Message)
                        $null = $script:__Verbose.Add($Message)
                    }
                    $script:__Output = [System.Collections.Generic.List[string]]::new()
                    Mock -CommandName Write-Output -ModuleName ColorScripts-Enhanced -MockWith {
                        param($InputObject)
                        $null = $script:__Output.Add([string]$InputObject)
                    }

                    Write-RenderedText -Text 'fallback-text'
                    [pscustomobject]@{
                        Messages = $script:__Verbose.ToArray()
                        Output   = $script:__Output.ToArray()
                    }
                }
                finally {
                    $script:ConsoleWriteDelegate = $originalDelegate
                    Remove-Variable -Name __Verbose -Scope Script -ErrorAction SilentlyContinue
                    Remove-Variable -Name __Output -Scope Script -ErrorAction SilentlyContinue
                }
            }

            ($result.Messages | Where-Object { $_ -like 'Console handle unavailable during cached render*' }) | Should -Not -BeNullOrEmpty
            $result.Output | Should -Contain 'fallback-text'
        }

        It 'writes empty text and newline when input is null' {
            $captures = InModuleScope ColorScripts-Enhanced {
                $originalDelegate = $script:ConsoleWriteDelegate
                try {
                    $writes = [System.Collections.Generic.List[string]]::new()
                    $script:ConsoleWriteDelegate = {
                        param($Value)
                        $null = $writes.Add($Value)
                    }

                    Write-RenderedText -Text $null
                    $writes.ToArray()
                }
                finally {
                    $script:ConsoleWriteDelegate = $originalDelegate
                }
            }

            $captures | Should -HaveCount 2
            $captures[0] | Should -Be ''
            $captures[1] | Should -Be ([Environment]::NewLine)
        }
    }

    Context 'Initialize-CacheDirectory fallback' {
        It 'creates fallback directory when all candidates fail' -Skip:$script:IsCIEnvironment {
            $basePath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            New-Item -ItemType Directory -Path $basePath -Force | Out-Null
            $originalTemp = $env:TEMP
            $originalTmp = $env:TMP
            $originalTmpDir = $env:TMPDIR

            try {
                $env:TEMP = $basePath
                $env:TMP = $basePath
                $env:TMPDIR = $basePath

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ TestBasePath = $basePath } {
                    param($TestBasePath)
                    $original = @{
                        CacheDir         = $script:CacheDir
                        CacheInitialized = $script:CacheInitialized
                        IsWindows        = $script:IsWindows
                        IsMacOS          = $script:IsMacOS
                        ConfigData       = $script:ConfigurationData
                    }
                    $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
                    $originalAppData = $env:APPDATA
                    $originalXdg = $env:XDG_CACHE_HOME
                    $originalTemp = $env:TEMP
                    $originalTmp = $env:TMP
                    $originalTmpDir = $env:TMPDIR

                    try {
                        $script:CacheDir = $null
                        $script:CacheInitialized = $false
                        $script:IsWindows = $true
                        $script:IsMacOS = $false
                        $script:ConfigurationData = $null
                        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $null
                        $env:APPDATA = $null
                        $env:XDG_CACHE_HOME = $null
                        $env:TEMP = $TestBasePath
                        $env:TMP = $TestBasePath
                        $env:TMPDIR = $TestBasePath

                        $fallbackPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), 'ColorScripts-Enhanced')

                        if (Test-Path -LiteralPath $fallbackPath) {
                            Remove-Item -LiteralPath $fallbackPath -Recurse -Force -ErrorAction SilentlyContinue
                        }

                        $createdPaths = [System.Collections.Generic.List[string]]::new()
                        Mock -CommandName New-Item -ModuleName ColorScripts-Enhanced -MockWith {
                            param($Path)
                            $normalizedPath = $Path.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
                            $normalizedFallback = $fallbackPath.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)

                            if ($normalizedPath -ine $normalizedFallback) {
                                throw [System.IO.IOException]::new("candidate failure for $Path")
                            }

                            $null = $createdPaths.Add($Path)
                            [System.IO.Directory]::CreateDirectory($Path)
                        }

                        Initialize-CacheDirectory

                        [pscustomobject]@{
                            CacheDir         = $script:CacheDir
                            Created          = $createdPaths.ToArray()
                            ExpectedFallback = $fallbackPath
                        }
                    }
                    finally {
                        $script:CacheDir = $original.CacheDir
                        $script:CacheInitialized = $original.CacheInitialized
                        $script:IsWindows = $original.IsWindows
                        $script:IsMacOS = $original.IsMacOS
                        $script:ConfigurationData = $original.ConfigData
                        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $originalOverride
                        $env:APPDATA = $originalAppData
                        $env:XDG_CACHE_HOME = $originalXdg
                        $env:TEMP = $originalTemp
                        $env:TMP = $originalTmp
                        $env:TMPDIR = $originalTmpDir
                    }
                }

                $result.Created | Should -Contain $result.ExpectedFallback
                $result.CacheDir | Should -Be $result.ExpectedFallback
            }
            finally {
                if ($null -eq $originalTemp) { Remove-Item Env:TEMP -ErrorAction SilentlyContinue } else { $env:TEMP = $originalTemp }
                if ($null -eq $originalTmp) { Remove-Item Env:TMP -ErrorAction SilentlyContinue } else { $env:TMP = $originalTmp }
                if ($null -eq $originalTmpDir) { Remove-Item Env:TMPDIR -ErrorAction SilentlyContinue } else { $env:TMPDIR = $originalTmpDir }
            }
        }

        It 'falls back to raw path when fallback resolution fails' {
            $basePath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            New-Item -ItemType Directory -Path $basePath -Force | Out-Null
            $originalTemp = $env:TEMP
            $originalTmp = $env:TMP
            $originalTmpDir = $env:TMPDIR

            try {
                $env:TEMP = $basePath
                $env:TMP = $basePath
                $env:TMPDIR = $basePath

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ TestBasePath = $basePath } {
                    param($TestBasePath)
                    $originalState = @{
                        CacheDir         = $script:CacheDir
                        CacheInitialized = $script:CacheInitialized
                        ConfigData       = $script:ConfigurationData
                    }
                    $originalTemp = $env:TEMP
                    $originalTmp = $env:TMP
                    $originalTmpDir = $env:TMPDIR

                    try {
                        $script:CacheDir = $null
                        $script:CacheInitialized = $false
                        $script:ConfigurationData = $null
                        $env:TEMP = $TestBasePath
                        $env:TMP = $TestBasePath
                        $env:TMPDIR = $TestBasePath

                        Mock -CommandName Resolve-Path -ModuleName ColorScripts-Enhanced -ParameterFilter { $LiteralPath -like '*ColorScripts-Enhanced' } -MockWith {
                            throw [System.IO.IOException]::new('resolve failure')
                        }

                        Initialize-CacheDirectory
                        [pscustomobject]@{
                            CacheDir = $script:CacheDir
                            Exists   = Test-Path -LiteralPath $script:CacheDir
                        }
                    }
                    finally {
                        $script:CacheDir = $originalState.CacheDir
                        $script:CacheInitialized = $originalState.CacheInitialized
                        $script:ConfigurationData = $originalState.ConfigData
                        $env:TEMP = $originalTemp
                        $env:TMP = $originalTmp
                        $env:TMPDIR = $originalTmpDir
                    }
                }

                $result.Exists | Should -BeTrue
                $result.CacheDir | Should -Match '(ColorScripts-Enhanced([/\\]cache)?|[/\\]cache)$'
            }
            finally {
                if ($null -eq $originalTemp) { Remove-Item Env:TEMP -ErrorAction SilentlyContinue } else { $env:TEMP = $originalTemp }
                if ($null -eq $originalTmp) { Remove-Item Env:TMP -ErrorAction SilentlyContinue } else { $env:TMP = $originalTmp }
                if ($null -eq $originalTmpDir) { Remove-Item Env:TMPDIR -ErrorAction SilentlyContinue } else { $env:TMPDIR = $originalTmpDir }
            }
        }
    }



    Context 'Metadata normalization' {
        It 'normalizes mixed metadata inputs and applies automatic categories' {
            $testRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            $scriptsDir = Join-Path -Path $testRoot -ChildPath 'scripts'
            $cacheDir = Join-Path -Path $testRoot -ChildPath 'cache'
            New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
            New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null

            foreach ($name in @('string-script', 'list-script-one', 'auto-script', 'plain-script', 'manual-script')) {
                Set-Content -LiteralPath (Join-Path -Path $scriptsDir -ChildPath "$name.ps1") -Value "Write-Host '$name'" -Encoding UTF8
            }

            $metadataPath = Join-Path -Path $testRoot -ChildPath 'metadata.psd1'
            $metadataContent = @'
@{
    Categories = @{
        Manual   = @('manual-script')
    }
    Tags = @{
        'manual-script'     = 'ManualTag'
        'list-script-one'   = @('TagListA','TagListB')
    }
    Descriptions = @{
        'manual-script' = 'Manual description'
    }
    AutoCategories = @(
        @{ Category = 'AutoEnum'; Patterns = @('^auto-script$','^list-script-one$'); Tags = @('AutoTag','EnumTag') }
        @{ Category = 'AutoString'; Patterns = '^string-script$'; Tags = 'SingleAuto' }
    )
}
'@
            Set-Content -LiteralPath $metadataPath -Value $metadataContent -Encoding UTF8

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ metaPath = $metadataPath; scriptsPath = $scriptsDir; cachePath = $cacheDir } {
                param($metaPath, $scriptsPath, $cachePath)
                $original = @{
                    MetadataPath          = $script:MetadataPath
                    ScriptsPath           = $script:ScriptsPath
                    CacheDir              = $script:CacheDir
                    CacheInitialized      = $script:CacheInitialized
                    MetadataCache         = $script:MetadataCache
                    MetadataLastWriteTime = $script:MetadataLastWriteTime
                }
                try {
                    $script:MetadataPath = $metaPath
                    $script:ScriptsPath = $scriptsPath
                    $script:CacheDir = $cachePath
                    $script:CacheInitialized = $true
                    $script:MetadataCache = $null
                    $script:MetadataLastWriteTime = $null
                    Reset-ScriptInventoryCache

                    $store = Get-ColorScriptMetadataTable

                    $store['manual-script'].Category | Should -Be 'Manual'
                    $store['manual-script'].Tags | Should -Contain 'ManualTag'
                    $store['manual-script'].Tags | Should -Contain 'Category:Manual'

                    $store['list-script-one'].Categories | Should -Contain 'AutoEnum'
                    $store['list-script-one'].Tags | Should -Contain 'EnumTag'

                    $store['string-script'].Category | Should -Be 'AutoString'
                    $store['string-script'].Tags | Should -Contain 'SingleAuto'
                    $store['string-script'].Tags | Should -Contain 'Category:AutoString'

                    $store['auto-script'].Category | Should -Be 'AutoEnum'
                    $store['auto-script'].Tags | Should -Contain 'AutoTag'
                    $store['auto-script'].Tags | Should -Contain 'Category:AutoEnum'

                    $entries = Get-ColorScriptEntry
                    $entry = @($entries | Where-Object { $_.Name -eq 'plain-script' })
                    $entry | Should -HaveCount 1
                    $entry[0].Category | Should -Be 'Abstract'
                    $entry[0].Tags | Should -Contain 'Category:Abstract'
                    $entry[0].Tags | Should -Contain 'AutoCategorized'

                    $store
                }
                finally {
                    $script:MetadataPath = $original.MetadataPath
                    $script:ScriptsPath = $original.ScriptsPath
                    $script:CacheDir = $original.CacheDir
                    $script:CacheInitialized = $original.CacheInitialized
                    $script:MetadataCache = $original.MetadataCache
                    $script:MetadataLastWriteTime = $original.MetadataLastWriteTime
                }
            }

            $result.Keys | Should -Contain 'string-script'
            $result.Keys | Should -Contain 'manual-script'
            $result.Keys | Should -Contain 'plain-script'
        }
    }

    Context 'Get-CachedOutput coverage' {
        It 'returns placeholder when cache entry missing' {
            $missingPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'missing-script.ps1'

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $missingPath } {
                param($path)
                Get-CachedOutput -ScriptPath $path
            }

            $result.Available | Should -BeFalse
            $result.CacheFile | Should -BeNullOrEmpty
            $result.Content | Should -Be ''
            $result.LastWriteTime | Should -BeNullOrEmpty
        }

        It 'returns placeholder when existence check throws' {
            $scriptPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'throw-script.ps1'

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $scriptPath } {
                param($path)
                $originalDelegate = $script:FileExistsDelegate
                try {
                    $script:FileExistsDelegate = {
                        throw [System.IO.IOException]::new('existence failure')
                    }

                    Get-CachedOutput -ScriptPath $path
                }
                finally {
                    $script:FileExistsDelegate = $originalDelegate
                }
            }

            $result.Available | Should -BeFalse
            $result.CacheFile | Should -Be $null
            $result.Content | Should -Be ''
            $result.LastWriteTime | Should -BeNullOrEmpty
        }
    }

    Context 'Clear-ColorScriptCache ShouldProcess coverage' {
        It 'reports missing entries and skips removal when ShouldProcess declines' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
            $cacheFile = Join-Path -Path $cacheRoot -ChildPath 'sample.cache'
            Set-Content -LiteralPath $cacheFile -Value 'cached' -Encoding UTF8

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot } {
                param($root)
                $originalState = @{
                    CacheDir         = $script:CacheDir
                    CacheInitialized = $script:CacheInitialized
                    Evaluator        = $script:ShouldProcessEvaluator
                }

                try {
                    $script:CacheDir = $root
                    $script:CacheInitialized = $true
                    $script:ShouldProcessEvaluator = {
                        param($cmdlet, $target, $action)
                        if ($action -eq 'Clear cache') { return $false }
                        if ($action -like 'Clear * cache file(s)') { return $true }
                        $cmdlet.ShouldProcess($target, $action)
                    }

                    Clear-ColorScriptCache -Name @('ghost', 'sample')
                }
                finally {
                    $script:ShouldProcessEvaluator = $originalState.Evaluator
                    $script:CacheDir = $originalState.CacheDir
                    $script:CacheInitialized = $originalState.CacheInitialized
                }
            }

            $result | Should -HaveCount 2
            ($result | Where-Object { $_.Name -eq 'ghost' }).Status | Should -Be 'Missing'
            ($result | Where-Object { $_.Name -eq 'sample' }).Status | Should -Be 'SkippedByUser'
        }
    }

    Context 'Clear-ColorScriptCache detailed coverage' {
        It 'captures unmatched, missing, and error statuses' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
            $errorCache = Join-Path -Path $cacheRoot -ChildPath 'error.cache'
            Set-Content -LiteralPath $errorCache -Value 'error' -Encoding UTF8

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot } {
                param($root)
                $originalState = @{
                    CacheDir         = $script:CacheDir
                    CacheInitialized = $script:CacheInitialized
                    Evaluator        = $script:ShouldProcessEvaluator
                }

                try {
                    $script:CacheDir = $root
                    $script:CacheInitialized = $true
                    $script:ShouldProcessEvaluator = { $true }

                    Mock -CommandName Get-ChildItem -ModuleName ColorScripts-Enhanced -MockWith { @() }
                    Mock -CommandName Select-RecordsByName -ModuleName ColorScripts-Enhanced -MockWith {
                        [pscustomobject]@{
                            Records  = @(
                                [pscustomobject]@{ Name = 'missing'; CacheFile = Join-Path -Path $root -ChildPath 'missing.cache' }
                                [pscustomobject]@{ Name = 'error'; CacheFile = Join-Path -Path $root -ChildPath 'error.cache' }
                            )
                            MatchMap = @(
                                [pscustomobject]@{ Pattern = 'ghost'; IsWildcard = $false; Matched = $false; Matches = @() }
                                [pscustomobject]@{ Pattern = 'missing'; IsWildcard = $false; Matched = $true; Matches = @('missing') }
                                [pscustomobject]@{ Pattern = 'error'; IsWildcard = $false; Matched = $true; Matches = @('error') }
                            )
                        }
                    }

                    Mock -CommandName Test-Path -ModuleName ColorScripts-Enhanced -ParameterFilter { $LiteralPath -like '*missing.cache' } -MockWith { $false }
                    Mock -CommandName Test-Path -ModuleName ColorScripts-Enhanced -ParameterFilter { $LiteralPath -like '*error.cache' } -MockWith { $true }
                    Mock -CommandName Remove-Item -ModuleName ColorScripts-Enhanced -ParameterFilter { $LiteralPath -like '*error.cache' } -MockWith {
                        throw [System.IO.IOException]::new('remove failure')
                    }

                    Clear-ColorScriptCache -Name @('ghost', 'missing', 'error')
                }
                finally {
                    $script:ShouldProcessEvaluator = $originalState.Evaluator
                    $script:CacheDir = $originalState.CacheDir
                    $script:CacheInitialized = $originalState.CacheInitialized
                }
            }

            $result | Should -HaveCount 3
            ($result | Where-Object { $_.Name -eq 'ghost' }).Status | Should -Be 'Missing'
            ($result | Where-Object { $_.Name -eq 'missing' }).Status | Should -Be 'Missing'
            ($result | Where-Object { $_.Name -eq 'error' }).Status | Should -Be 'Error'
        }
    }

    Context 'Show-ColorScript selection coverage' {
        It 'selects first record when no name supplied' {
            $records = @(
                [pscustomobject]@{ Name = 'alpha'; Path = 'alpha.ps1' },
                [pscustomobject]@{ Name = 'beta'; Path = 'beta.ps1' }
            )

            $captured = InModuleScope ColorScripts-Enhanced -Parameters @{ recs = $records } {
                param($recs)
                $recordsToUse = $recs
                Mock -CommandName Get-ColorScriptInventory -ModuleName ColorScripts-Enhanced -MockWith { $recordsToUse }
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { }
                Mock -CommandName Get-CachedOutput -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        Available     = $true
                        CacheFile     = 'alpha.cache'
                        Content       = 'cached-content'
                        LastWriteTime = Get-Date
                    }
                }
                $script:__CapturedArgs = $null
                $script:__RenderedText = $null
                Mock -CommandName Invoke-WithUtf8Encoding -ModuleName ColorScripts-Enhanced -MockWith {
                    param([scriptblock]$ScriptBlock, [object[]]$Arguments)
                    $script:__CapturedArgs = $Arguments
                    & $ScriptBlock @Arguments
                }
                Mock -CommandName Write-RenderedText -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Text, $NoAnsiOutput)
                    $script:__RenderedText = $Text
                    $script:__RenderedNoAnsi = [bool]$NoAnsiOutput
                }
                Mock -CommandName Test-ColorScriptTextEmission -ModuleName ColorScripts-Enhanced -MockWith { $false }

                Show-ColorScript | Out-Null
                [pscustomobject]@{
                    Arguments = $script:__CapturedArgs
                    Rendered  = $script:__RenderedText
                    NoAnsi    = $script:__RenderedNoAnsi
                }
            }

            $captured.Arguments[0] | Should -Be 'cached-content'
            $captured.Rendered | Should -Be 'cached-content'
            $captured.NoAnsi | Should -BeFalse
        }
    }

    Context 'Export-ColorScriptMetadata error handling' {
        It 'continues when file and cache info cannot be read' {
            $result = InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        Name        = 'broken'
                        Path        = 'Z:\missing\broken.ps1'
                        Category    = 'Manual'
                        Categories  = @('Manual')
                        Tags        = @('Tag')
                        Description = 'desc'
                    }
                }

                $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                $script:CacheInitialized = $true

                Mock -CommandName Test-Path -ModuleName ColorScripts-Enhanced -ParameterFilter { $LiteralPath -like '*.cache' } -MockWith { $true }

                Mock -CommandName Get-Item -ModuleName ColorScripts-Enhanced -MockWith {
                    param($LiteralPath)
                    if ($LiteralPath -like '*.ps1') {
                        throw [System.IO.IOException]::new('script missing')
                    }
                    elseif ($LiteralPath -like '*.cache') {
                        throw [System.IO.IOException]::new('cache missing')
                    }
                    else {
                        throw "Unexpected path $LiteralPath"
                    }
                }

                $script:__Verbose = [System.Collections.Generic.List[string]]::new()
                Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Message)
                    $null = $script:__Verbose.Add($Message)
                }

                $payload = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
                [pscustomobject]@{
                    Payload  = $payload
                    Messages = $script:__Verbose.ToArray()
                }
            }

            $result.Payload | Should -HaveCount 1
            $result.Payload[0].ScriptSizeBytes | Should -BeNullOrEmpty
            $result.Payload[0].CacheLastWriteTimeUtc | Should -BeNullOrEmpty
            ($result.Messages | Where-Object { $_ -like 'Unable to retrieve file info*' }) | Should -Not -BeNullOrEmpty
            ($result.Messages | Where-Object { $_ -like 'Unable to read cache info*' }) | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Invoke-ColorScriptsStartup coverage' {
        It 'honors auto show override and invokes Show-ColorScript' {
            $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT
            $originalCI = $env:CI
            $originalGitHub = $env:GITHUB_ACTIONS
            $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT = 'true'
            $env:CI = $null
            $env:GITHUB_ACTIONS = $null
            $configRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            New-Item -ItemType Directory -Path $configRoot -Force | Out-Null

            try {
                $calls = InModuleScope ColorScripts-Enhanced -Parameters @{ configRoot = $configRoot } {
                    param($configRoot)
                    [void]$configRoot
                    Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                    Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $configRoot }
                    Mock -CommandName Get-ConfigurationDataInternal -ModuleName ColorScripts-Enhanced -MockWith {
                        @{ Startup = @{ AutoShowOnImport = $false; DefaultScript = 'alpha' } }
                    }
                    $script:__Calls = [System.Collections.Generic.List[string]]::new()
                    Mock -CommandName Show-ColorScript -ModuleName ColorScripts-Enhanced -MockWith {
                        param([string]$Name)
                        $null = $script:__Calls.Add($Name)
                        [pscustomobject]@{}
                    }

                    Invoke-ColorScriptsStartup
                    $script:__Calls.ToArray()
                }

                $calls | Should -Contain 'alpha'
            }
            finally {
                if ($null -eq $originalOverride) { Remove-Item Env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT -ErrorAction SilentlyContinue } else { $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT = $originalOverride }
                if ($null -eq $originalCI) { Remove-Item Env:CI -ErrorAction SilentlyContinue } else { $env:CI = $originalCI }
                if ($null -eq $originalGitHub) { Remove-Item Env:GITHUB_ACTIONS -ErrorAction SilentlyContinue } else { $env:GITHUB_ACTIONS = $originalGitHub }
                if (Test-Path -LiteralPath $configRoot) { Remove-Item -LiteralPath $configRoot -Recurse -Force -ErrorAction SilentlyContinue }
            }
        }

        It 'continues when configuration root resolves to null' {
            $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT
            $originalCI = $env:CI
            $originalGitHub = $env:GITHUB_ACTIONS
            $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT = 'true'
            $env:CI = $null
            $env:GITHUB_ACTIONS = $null

            try {
                $result = InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                    Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $null }
                    Mock -CommandName Get-ConfigurationDataInternal -ModuleName ColorScripts-Enhanced -MockWith {
                        @{ Startup = @{ AutoShowOnImport = $false } }
                    }
                    Mock -CommandName Show-ColorScript -ModuleName ColorScripts-Enhanced -MockWith { 'default-shown' }

                    Invoke-ColorScriptsStartup
                }

                $result | Should -Be $null
            }
            finally {
                if ($null -eq $originalOverride) { Remove-Item Env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT -ErrorAction SilentlyContinue } else { $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT = $originalOverride }
                if ($null -eq $originalCI) { Remove-Item Env:CI -ErrorAction SilentlyContinue } else { $env:CI = $originalCI }
                if ($null -eq $originalGitHub) { Remove-Item Env:GITHUB_ACTIONS -ErrorAction SilentlyContinue } else { $env:GITHUB_ACTIONS = $originalGitHub }
            }
        }
    }
}
