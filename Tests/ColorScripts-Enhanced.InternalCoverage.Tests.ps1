# Internal verification tests for ColorScripts-Enhanced private helpers

Describe "ColorScripts-Enhanced internal coverage" {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModulePath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModulePath -ChildPath 'ColorScripts-Enhanced.psd1'
        Import-Module $script:ModuleManifest -Force

        InModuleScope ColorScripts-Enhanced {
            Set-Variable -Name OriginalModuleRoot -Scope Script -Value $script:ModuleRoot
        }

        $script:OriginalIsWindows = $IsWindows
        $script:OriginalIsMacOS = $IsMacOS
        $script:OriginalIsLinux = $IsLinux

        $script:OriginalAppData = $env:APPDATA
        $script:OriginalConfigOverride = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
        $script:OriginalCacheOverride = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
        $script:OriginalXdgConfig = $env:XDG_CONFIG_HOME
        $script:OriginalHomeEnv = $env:HOME
        $script:OriginalHomeVariable = $HOME
        $script:OriginalTraceEnv = $env:COLOR_SCRIPTS_ENHANCED_TRACE

        $script:TestDriveRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
    }

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

        if ($null -eq $script:OriginalXdgConfig) {
            Remove-Item Env:XDG_CONFIG_HOME -ErrorAction SilentlyContinue
        }
        else {
            $env:XDG_CONFIG_HOME = $script:OriginalXdgConfig
        }

        $env:APPDATA = $script:OriginalAppData
        if ($null -eq $script:OriginalHomeEnv) {
            Remove-Item Env:HOME -ErrorAction SilentlyContinue
        }
        else {
            $env:HOME = $script:OriginalHomeEnv
        }
        if ($null -ne $script:OriginalHomeVariable) {
            Set-Variable -Name HOME -Scope Global -Force -Value $script:OriginalHomeVariable
        }

        if ($null -eq $script:OriginalTraceEnv) {
            Remove-Item Env:COLOR_SCRIPTS_ENHANCED_TRACE -ErrorAction SilentlyContinue
        }
        else {
            $env:COLOR_SCRIPTS_ENHANCED_TRACE = $script:OriginalTraceEnv
        }

        Set-Variable -Name IsWindows -Scope Global -Force -Value $script:OriginalIsWindows
        Set-Variable -Name IsMacOS -Scope Global -Force -Value $script:OriginalIsMacOS
        Set-Variable -Name IsLinux -Scope Global -Force -Value $script:OriginalIsLinux

        InModuleScope ColorScripts-Enhanced {
            $script:IsWindows = $IsWindows
            $script:IsMacOS = $IsMacOS
            $script:IsLinux = $IsLinux
        }

        Remove-Variable -Name TestOverridePath -Scope Global -ErrorAction SilentlyContinue

        InModuleScope ColorScripts-Enhanced {
            $script:ConfigurationRoot = $null
            $script:ConfigurationPath = $null
            $script:ConfigurationData = $null
            $script:ConfigurationInitialized = $false
            Initialize-ColorScriptsLocalization -CandidateRoots ($moduleRootCandidates | Select-Object -Unique) | Out-Null
        }
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue
    }

    Context "Copy-ColorScriptHashtable" {
        It "performs deep copy for nested and enumerable values" {
            InModuleScope ColorScripts-Enhanced {
                $arrayList = [System.Collections.ArrayList]::new()
                $arrayList.AddRange(@('a', 'b'))
                $list = [System.Collections.Generic.List[string]]::new()
                $null = $list.Add('xyz')

                $source = @{
                    Nested     = @{ Foo = 1 }
                    Numbers    = @(1, 2, 3)
                    Cloneable  = $arrayList
                    Enumerable = $list
                    Text       = 'hello'
                }

                $clone = Copy-ColorScriptHashtable $source

                $clone | Should -Not -BeNullOrEmpty
                $clone | Should -Not -Be $source

                $clone.Nested.Foo = 42
                $source.Nested.Foo | Should -Be 1

                $clone.Numbers[0] = 99
                $source.Numbers[0] | Should -Be 1

                $clone.Cloneable.Add('c') | Out-Null
                $source.Cloneable.Count | Should -Be 2

                ($clone.Enumerable).GetType().FullName | Should -BeExactly 'System.Object[]'
                $clone.Enumerable[0] | Should -Be 'xyz'
            }
        }

        It "returns empty hashtable when source is null" {
            InModuleScope ColorScripts-Enhanced {
                $result = Copy-ColorScriptHashtable $null
                $result.Keys.Count | Should -Be 0
            }
        }
    }

    Context "Localization resolution" {
        It "resolves culture directories via enumeration when direct Test-Path fails" {
            InModuleScope ColorScripts-Enhanced {
                $baseDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
                $cultureDir = Join-Path -Path $baseDir -ChildPath 'en-us'
                $messagesPath = Join-Path -Path $cultureDir -ChildPath 'Messages.psd1'

                New-Item -ItemType Directory -Path $cultureDir -Force | Out-Null
                Set-Content -LiteralPath $messagesPath -Value "ConvertFrom-StringData @'`nKey = Value`n'@" -Encoding UTF8

                $leafPath = $messagesPath
                $cultureContainerPath = Join-Path -Path $baseDir -ChildPath 'en-US'
                Set-Variable -Name LocalizationLeafCheckCount -Scope Script -Value 0

                Mock -CommandName Test-Path -ParameterFilter {
                    $PathType -eq 'Container' -and $LiteralPath -eq $cultureContainerPath
                } -MockWith { return $false }
                Mock -CommandName Test-Path -ParameterFilter {
                    $PathType -eq 'Leaf' -and $LiteralPath -eq $leafPath
                } -MockWith {
                    $count = Get-Variable -Name LocalizationLeafCheckCount -Scope Script -ErrorAction SilentlyContinue
                    $current = if ($count) { $count.Value } else { 0 }
                    Set-Variable -Name LocalizationLeafCheckCount -Scope Script -Value ($current + 1)
                    if ($current -eq 0) { return $false }
                    return [System.IO.File]::Exists($leafPath)
                }

                $result = Resolve-LocalizedMessagesFile -BaseDirectory $baseDir -CultureFallback @('en-US')

                $result | Should -Not -BeNullOrEmpty
                $result.CultureName | Should -Be 'en-US'
                $resolvedMessagesPath = (Resolve-Path -LiteralPath $messagesPath).ProviderPath
                $result.FilePath | Should -Be $resolvedMessagesPath
            }
        }

        It "falls back to root Messages.psd1 when no culture directory matches" {
            InModuleScope ColorScripts-Enhanced {
                $baseDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
                $rootMessages = Join-Path -Path $baseDir -ChildPath 'Messages.psd1'

                New-Item -ItemType Directory -Path $baseDir -Force | Out-Null
                Set-Content -LiteralPath $rootMessages -Value "ConvertFrom-StringData @'`nRoot = True`n'@" -Encoding UTF8

                Set-Variable -Name RootLeafCheckCount -Scope Script -Value 0

                Mock -CommandName Test-Path -ParameterFilter {
                    $PathType -eq 'Leaf' -and $LiteralPath -eq $rootMessages
                } -MockWith {
                    $count = Get-Variable -Name RootLeafCheckCount -Scope Script -ErrorAction SilentlyContinue
                    $current = if ($count) { $count.Value } else { 0 }
                    Set-Variable -Name RootLeafCheckCount -Scope Script -Value ($current + 1)
                    if ($current -eq 0) { return $false }
                    return [System.IO.File]::Exists($rootMessages)
                }

                $result = Resolve-LocalizedMessagesFile -BaseDirectory $baseDir -CultureFallback @('zz-ZZ')

                $result | Should -Not -BeNullOrEmpty
                $result.CultureName | Should -Be $null
                $resolvedMessagesPath = (Resolve-Path -LiteralPath $rootMessages).ProviderPath
                $result.FilePath | Should -Be $resolvedMessagesPath
            }
        }

        It "imports messages from ConvertFrom-StringData payload" {
            InModuleScope ColorScripts-Enhanced {
                $baseDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
                $cultureDir = Join-Path -Path $baseDir -ChildPath 'en-US'
                $messagesPath = Join-Path -Path $cultureDir -ChildPath 'Messages.psd1'

                New-Item -ItemType Directory -Path $cultureDir -Force | Out-Null
                Set-Content -LiteralPath $messagesPath -Value "ConvertFrom-StringData @'`nGreeting = Hello`n'@" -Encoding UTF8

                $script:Messages = $null

                Import-LocalizedMessagesFromFile -FilePath $messagesPath

                $script:Messages | Should -Not -BeNullOrEmpty
                $script:Messages.Greeting | Should -Be 'Hello'
            }
        }

        It "imports messages via Import-PowerShellDataFile when no ConvertFrom-StringData block exists" {
            InModuleScope ColorScripts-Enhanced {
                $baseDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
                $messagesPath = Join-Path -Path $baseDir -ChildPath 'Messages.psd1'

                New-Item -ItemType Directory -Path $baseDir -Force | Out-Null
                Set-Content -LiteralPath $messagesPath -Value "@{ Farewell = 'Goodbye' }" -Encoding UTF8

                $script:Messages = $null

                Import-LocalizedMessagesFromFile -FilePath $messagesPath

                $script:Messages | Should -Not -BeNullOrEmpty
                $script:Messages.Farewell | Should -Be 'Goodbye'
            }
        }

        It "falls back to embedded messages when no localized files exist" {
            InModuleScope ColorScripts-Enhanced {
                $baseDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $baseDir -Force | Out-Null

                $result = Initialize-ColorScriptsLocalization -CandidateRoots @($baseDir)

                $result.LocalizedDataLoaded | Should -BeFalse
                $script:ModuleRoot | Should -Not -BeNullOrEmpty
                $script:Messages | Should -Not -BeNullOrEmpty
                $script:Messages.ContainsKey('ModuleLoadedSuccessfully') | Should -BeTrue
            }
        }

        It "continues to next candidate when import fails and succeeds on fallback" -Skip:($IsLinux -and $env:CI) {
            InModuleScope ColorScripts-Enhanced {
                $invalidDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
                $validDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
                $invalidMessages = Join-Path -Path $invalidDir -ChildPath 'en-US'
                $invalidFile = Join-Path -Path $invalidMessages -ChildPath 'Messages.psd1'
                $validMessages = Join-Path -Path $validDir -ChildPath 'en-US'
                $validFile = Join-Path -Path $validMessages -ChildPath 'Messages.psd1'

                New-Item -ItemType Directory -Path $invalidMessages -Force | Out-Null
                Set-Content -LiteralPath $invalidFile -Value "Invalid-Localization" -Encoding UTF8

                New-Item -ItemType Directory -Path $validMessages -Force | Out-Null
                Set-Content -LiteralPath $validFile -Value "ConvertFrom-StringData @'`nMessage = Hello`n'@" -Encoding UTF8

                $result = Initialize-ColorScriptsLocalization -CandidateRoots @($invalidDir, $validDir)

                $result.LocalizedDataLoaded | Should -BeTrue
                $result.ModuleRoot | Should -Be $validDir
                $script:Messages.Message | Should -Be 'Hello'
            }
        }
    }

    Context "Module trace configuration" {
        BeforeEach {
            Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue
        }

        AfterEach {
            Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue

            if ($null -eq $script:OriginalTraceEnv) {
                Remove-Item Env:COLOR_SCRIPTS_ENHANCED_TRACE -ErrorAction SilentlyContinue
            }
            else {
                $env:COLOR_SCRIPTS_ENHANCED_TRACE = $script:OriginalTraceEnv
            }

            Import-Module $script:ModuleManifest -Force

            InModuleScope ColorScripts-Enhanced {
                Set-Variable -Name OriginalModuleRoot -Scope Script -Value $script:ModuleRoot
            }
        }

        It "enables verbose trace mode when requested" {
            $env:COLOR_SCRIPTS_ENHANCED_TRACE = 'true'

            Import-Module $script:ModuleManifest -Force

            InModuleScope ColorScripts-Enhanced {
                $script:ModuleTraceEnabled | Should -BeTrue
                $script:ModuleTraceUseVerbose | Should -BeTrue
                $script:ModuleTraceUseFile | Should -BeFalse

                $previousVerbose = $VerbosePreference
                try {
                    $VerbosePreference = 'Continue'
                    { Write-ModuleTrace 'verbose-message' } | Should -Not -Throw
                }
                finally {
                    $VerbosePreference = $previousVerbose
                }
            }
        }

        It "writes trace output to specified file and supports debug mode" {
            $tracePath = Join-Path -Path $script:TestDriveRoot -ChildPath 'trace-output.log'
            $env:COLOR_SCRIPTS_ENHANCED_TRACE = "debug,path:$tracePath"

            Import-Module $script:ModuleManifest -Force

            InModuleScope ColorScripts-Enhanced -ScriptBlock {
                param($expectedTracePath)

                $script:ModuleTraceEnabled | Should -BeTrue
                $script:ModuleTraceUseDebug | Should -BeTrue
                $script:ModuleTraceUseFile | Should -BeTrue
                $script:ModuleTraceFile | Should -Be $expectedTracePath

                $previousDebug = $DebugPreference
                try {
                    $DebugPreference = 'Continue'
                    { Write-ModuleTrace 'file-message' } | Should -Not -Throw
                }
                finally {
                    $DebugPreference = $previousDebug
                }
            } -ArgumentList $tracePath

            Test-Path -LiteralPath $tracePath | Should -BeTrue
            (Get-Content -LiteralPath $tracePath -Raw) | Should -Match 'file-message'
        }

        It "treats absolute paths as file trace targets" {
            $simpleTracePath = Join-Path -Path $script:TestDriveRoot -ChildPath 'simple-trace.log'
            $env:COLOR_SCRIPTS_ENHANCED_TRACE = $simpleTracePath

            Import-Module $script:ModuleManifest -Force

            $expectedResolvedPath = [System.IO.Path]::GetFullPath($simpleTracePath)

            InModuleScope ColorScripts-Enhanced -ScriptBlock {
                param($expectedTracePath)

                $script:ModuleTraceEnabled | Should -BeTrue
                $script:ModuleTraceUseFile | Should -BeTrue
                $script:ModuleTraceFile | Should -Be $expectedTracePath

                { Write-ModuleTrace 'simple-message' } | Should -Not -Throw
            } -ArgumentList $expectedResolvedPath

            Test-Path -LiteralPath $simpleTracePath | Should -BeTrue
            (Get-Content -LiteralPath $simpleTracePath -Raw) | Should -Match 'simple-message'
        }
    }

    Context "ConvertFrom-JsonToHashtable" {
        It "returns hashtable for JSON input" {
            InModuleScope ColorScripts-Enhanced {
                $json = '{"Name":"Test","Nested":{"Value":5},"Numbers":[1,2,3]}'
                $result = ConvertFrom-JsonToHashtable -InputObject $json

                $result | Should -Not -BeNullOrEmpty
                $result.Name | Should -Be 'Test'
                $result.Nested.Value | Should -Be 5
                $result.Numbers[2] | Should -Be 3
            }
        }

        It "converts PSCustomObject structures via helper" {
            InModuleScope ColorScripts-Enhanced {
                $object = [pscustomobject]@{
                    Title   = 'Sample'
                    Details = [pscustomobject]@{
                        Count = 2
                    }
                    Items   = @(
                        [pscustomobject]@{ Id = 1 }
                        [pscustomobject]@{ Id = 2 }
                    )
                }

                $result = ConvertTo-HashtableInternal $object

                $result | Should -Not -BeNullOrEmpty
                $result.Title | Should -Be 'Sample'
                $result.Details.Count | Should -Be 2
                $result.Items.Count | Should -Be 2
                $result.Items[0].Id | Should -Be 1
                $result.Items[1].Id | Should -Be 2
            }
        }
    }

    Context "Merge-ColorScriptConfiguration" {
        It "merges nested dictionaries and arrays without mutating base" {
            InModuleScope ColorScripts-Enhanced {
                $baseArray = [System.Collections.ArrayList]::new()
                $baseArray.Add('alpha') | Out-Null

                $base = [ordered]@{
                    Cache = @{ Path = 'C:\Cache'; Settings = @{ Enabled = $true; Level = 1 } }
                    Tags  = @('one')
                    Data  = $baseArray
                }

                $overrideArray = [System.Collections.ArrayList]::new()
                $overrideArray.Add('beta') | Out-Null

                $override = [ordered]@{
                    Cache = @{ Settings = @{ Level = 5; Mode = 'Fast' } }
                    Tags  = @('two')
                    Data  = $overrideArray
                }

                $result = Merge-ColorScriptConfiguration $base $override

                $result.Cache.Settings.Level | Should -Be 5
                $result.Cache.Settings.Mode | Should -Be 'Fast'
                $result.Cache.Path | Should -Be 'C:\Cache'
                ($result.Tags -is [System.Array]) | Should -BeTrue
                $result.Tags | Should -Contain 'two'
                $result.Data | Should -Not -Be $base.Data
                $result.Data.Count | Should -Be 1
                $base.Data.Count | Should -Be 1
                $base.Cache.Settings.ContainsKey('Mode') | Should -BeFalse
            }
        }

        It "clones override dictionaries and enumerables" {
            InModuleScope ColorScripts-Enhanced {
                $base = [ordered]@{
                    Settings = @{ Theme = 'Light' }
                }

                $enumerable = [System.Collections.Generic.List[string]]::new()
                $null = $enumerable.Add('entry')

                $override = [ordered]@{
                    Settings = @{ Preferences = @{ FontSize = 14 } }
                    Names    = $enumerable
                }

                $result = Merge-ColorScriptConfiguration $base $override

                $result.Settings.Theme | Should -Be 'Light'
                $result.Settings.Preferences.FontSize | Should -Be 14
                ($result.Names -is [System.Array]) | Should -BeTrue
                $result.Names[0] | Should -Be 'entry'
                $base.Settings.ContainsKey('Preferences') | Should -BeFalse
            }
        }
    }

    Context "Resolve-CachePath" {
        It "returns null for empty input" {
            InModuleScope ColorScripts-Enhanced {
                Resolve-CachePath -Path $null | Should -Be $null
                Resolve-CachePath -Path '   ' | Should -Be $null
            }
        }

        It "expands user profile shortcuts" {
            InModuleScope ColorScripts-Enhanced {
                $expectedHome = [System.Environment]::GetFolderPath('UserProfile')
                $resolvedHome = Resolve-CachePath -Path '~'
                $resolvedRelative = Resolve-CachePath -Path '~\ColorScripts'

                $resolvedHome | Should -Be $expectedHome
                $resolvedRelative | Should -Be (Join-Path -Path $expectedHome -ChildPath 'ColorScripts')
            }
        }

        It "resolves relative paths against current location" {
            InModuleScope ColorScripts-Enhanced {
                Push-Location -LiteralPath 'TestDrive:'
                try {
                    $target = Resolve-CachePath -Path 'relative\cache'
                    $target | Should -Be (Join-Path -Path (Get-Location).ProviderPath -ChildPath 'relative\cache')
                }
                finally {
                    Pop-Location
                }
            }
        }

        It "returns null when drive qualifier is missing" {
            InModuleScope ColorScripts-Enhanced {
                Resolve-CachePath -Path 'ZZ:\missing\dir' | Should -Be $null
            }
        }

        It "handles invalid path characters gracefully" {
            InModuleScope ColorScripts-Enhanced {
                $result = Resolve-CachePath -Path 'C:\path|invalid'
                @($null, 'C:\path|invalid') | Should -Contain $result
            }
        }
    }

    Context "Show-ColorScriptHelp" {
        It "emits colored sections for help text" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Get-Help -ModuleName ColorScripts-Enhanced -MockWith {
                    @(
                        'NAME',
                        'Show-ColorScript',
                        'SYNOPSIS',
                        'Displays content',
                        'SYNTAX',
                        ' -- example syntax',
                        'PARAMETERS',
                        '    -Name <String>',
                        '    Required? true',
                        '    Position? 0',
                        '    Default value false',
                        '    Accept pipeline input? false',
                        '    Accept wildcard characters? false',
                        'EXAMPLES',
                        'EXAMPLE 1',
                        '    -- Show-ColorScript',
                        'NOTES',
                        'Additional text',
                        'RELATED LINKS',
                        'https://example.com'
                    ) -join "`n"
                }

                Show-ColorScriptHelp -CommandName 'Show-ColorScript'

                Assert-MockCalled -CommandName Get-Help -ModuleName ColorScripts-Enhanced -Times 1
            }
        }
    }

    Context "Configuration root resolution" {
        It "honors explicit override path" {
            InModuleScope ColorScripts-Enhanced {
                $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $root
                $script:ConfigurationRoot = $null

                $result = Get-ColorScriptsConfigurationRoot
                $result | Should -Be (Resolve-CachePath -Path $root)
                Test-Path $result | Should -BeTrue
            }
        }

        It "prefers macOS location when platform set to mac" {
            Set-Variable -Name IsWindows -Scope Global -Force -Value $false
            Set-Variable -Name IsMacOS -Scope Global -Force -Value $true

            InModuleScope ColorScripts-Enhanced {
                $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'MacConfig'
                $script:ConfigurationRoot = $null
                $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $null
                Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Path)
                    [void]$Path
                    $null = $Path
                    Join-Path $root 'ColorScripts-Enhanced'
                }

                $result = Get-ColorScriptsConfigurationRoot
                $result | Should -Match 'ColorScripts-Enhanced'
            }
        }

        It "evaluates XDG config path on linux" {
            Set-Variable -Name IsWindows -Scope Global -Force -Value $false
            Set-Variable -Name IsMacOS -Scope Global -Force -Value $false
            Set-Variable -Name IsLinux -Scope Global -Force -Value $true
            $env:XDG_CONFIG_HOME = Join-Path $script:TestDriveRoot 'xdg'

            InModuleScope ColorScripts-Enhanced {
                $script:ConfigurationRoot = $null
                $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $null
                $result = Get-ColorScriptsConfigurationRoot
                $result | Should -Match 'ColorScripts-Enhanced'
                Test-Path $result | Should -BeTrue
            }
        }

        It "falls back to home .config when no XDG path" {
            if ($PSVersionTable.PSEdition -eq 'Desktop') {
                Set-ItResult -Skipped -Because 'PowerShell 5.1 uses Windows-specific configuration paths.'
                return
            }

            $originalWindows = $IsWindows
            $originalMac = $IsMacOS
            $originalLinux = $IsLinux
            $originalXdg = $env:XDG_CONFIG_HOME

            Set-Variable -Name IsWindows -Scope Global -Force -Value $false
            Set-Variable -Name IsMacOS -Scope Global -Force -Value $false
            Set-Variable -Name IsLinux -Scope Global -Force -Value $true
            Remove-Item Env:XDG_CONFIG_HOME -ErrorAction SilentlyContinue

            $origHomeVar = $HOME
            $origHomeEnv = $env:HOME

            try {
                InModuleScope ColorScripts-Enhanced -Parameters @{ OrigHome = $origHomeVar; OrigHomeEnv = $origHomeEnv } {
                    param($OrigHome, $OrigHomeEnv)

                    $originalScriptWindows = $script:IsWindows
                    $originalScriptMac = $script:IsMacOS
                    $originalScriptLinux = $script:IsLinux

                    $newHome = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'linuxHome'
                    Set-Variable -Name HOME -Scope Global -Force -Value $newHome
                    $env:HOME = $newHome

                    try {
                        $script:IsWindows = $false
                        $script:IsMacOS = $false
                        $script:IsLinux = $true

                        $script:ConfigurationRoot = $null
                        $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $null
                        $result = Get-ColorScriptsConfigurationRoot
                        $configRoot = Join-Path -Path $HOME -ChildPath '.config'
                        $expected = Join-Path -Path $configRoot -ChildPath 'ColorScripts-Enhanced'
                        $result | Should -Be $expected
                        Test-Path $configRoot | Should -BeTrue
                    }
                    finally {
                        Set-Variable -Name HOME -Scope Global -Force -Value $OrigHome
                        if ($null -eq $OrigHomeEnv) {
                            Remove-Item Env:HOME -ErrorAction SilentlyContinue
                        }
                        else {
                            $env:HOME = $OrigHomeEnv
                        }

                        $script:IsWindows = $originalScriptWindows
                        $script:IsMacOS = $originalScriptMac
                        $script:IsLinux = $originalScriptLinux
                    }
                }
            }
            finally {
                if ($null -eq $originalXdg) {
                    Remove-Item Env:XDG_CONFIG_HOME -ErrorAction SilentlyContinue
                }
                else {
                    $env:XDG_CONFIG_HOME = $originalXdg
                }

                Set-Variable -Name IsWindows -Scope Global -Force -Value $originalWindows
                Set-Variable -Name IsMacOS -Scope Global -Force -Value $originalMac
                Set-Variable -Name IsLinux -Scope Global -Force -Value $originalLinux
            }
        }

        It "throws when configuration directories cannot be prepared" {
            Set-Variable -Name IsWindows -Scope Global -Force -Value $true
            Set-Variable -Name IsMacOS -Scope Global -Force -Value $false
            Set-Variable -Name IsLinux -Scope Global -Force -Value $false
            $env:APPDATA = $null
            Remove-Item Env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT -ErrorAction SilentlyContinue

            InModuleScope ColorScripts-Enhanced {
                $script:ConfigurationRoot = $null
                $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $null
                $verbosePreference = $VerbosePreference
                $VerbosePreference = 'Continue'

                $fallback = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'failing-config'
                Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Path)
                    [void]$Path
                    $Path
                }
                Mock -CommandName Test-Path -ModuleName ColorScripts-Enhanced -MockWith { $false }

                $originalCreateDelegate = $script:CreateDirectoryDelegate
                $script:CreateDirectoryDelegate = {
                    param($Path)
                    [void]$Path
                    throw [System.IO.IOException]::new('failure')
                }

                try {
                    { Get-ColorScriptsConfigurationRoot } | Should -Throw
                }
                finally {
                    $script:CreateDirectoryDelegate = $originalCreateDelegate
                    $VerbosePreference = $verbosePreference
                }
            }
        }
    }

    Context "Configuration persistence" {
        It "skips writing when configuration is unchanged" {
            InModuleScope ColorScripts-Enhanced {
                $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $root -Force | Out-Null

                Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $root }

                $config = @{ Cache = @{ Path = 'A:\Cache' } }
                $path = Join-Path -Path $root -ChildPath 'config.json'
                $json = ($config | ConvertTo-Json -Depth 6) + [Environment]::NewLine
                Set-Content -Path $path -Value $json -Encoding UTF8

                $before = (Get-Item -Path $path).LastWriteTimeUtc
                Start-Sleep -Milliseconds 10

                Save-ColorScriptConfiguration -Configuration $config

                (Get-Item -Path $path).LastWriteTimeUtc | Should -Be $before
            }
        }

        It "writes updated configuration when changes are present" {
            InModuleScope ColorScripts-Enhanced {
                $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $root -Force | Out-Null

                Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $root }

                $path = Join-Path -Path $root -ChildPath 'config.json'
                $initialConfig = @{ Cache = @{ Path = 'A:\Cache' } }
                Set-Content -Path $path -Value (($initialConfig | ConvertTo-Json -Depth 6) + [Environment]::NewLine) -Encoding UTF8

                $updated = @{ Cache = @{ Path = 'B:\Cache'; Enabled = $true } }
                Save-ColorScriptConfiguration -Configuration $updated -Force

                $written = Get-Content -LiteralPath $path -Raw
                $written | Should -Match '"Enabled"\s*:\s*true'
                $written | Should -Match '"Path"\s*:\s*"B:'
            }
        }

        It "throws when configuration root cannot be resolved" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $null }
                { Save-ColorScriptConfiguration -Configuration @{ } } | Should -Throw
            }
        }

        It "reinitializes configuration when JSON cannot be parsed" {
            InModuleScope ColorScripts-Enhanced {
                $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $root -Force | Out-Null

                Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $root }

                $path = Join-Path -Path $root -ChildPath 'config.json'
                Set-Content -Path $path -Value '{ invalid json' -Encoding UTF8

                Initialize-Configuration

                $script:ConfigurationInitialized | Should -BeTrue
                $script:ConfigurationData | Should -Not -BeNullOrEmpty
                Test-Path -LiteralPath $path | Should -BeTrue
            }
        }

        It "continues writing when existing file content cannot be read" {
            InModuleScope ColorScripts-Enhanced {
                $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $root -Force | Out-Null

                Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $root }

                $path = Join-Path -Path $root -ChildPath 'config.json'
                Set-Content -Path $path -Value '{}' -Encoding UTF8

                Mock -CommandName Get-Content -ModuleName ColorScripts-Enhanced -ParameterFilter { $LiteralPath -eq $path } -MockWith { throw 'cannot read' }

                $updated = @{ Cache = @{ Path = 'C:\Cache' } }
                Save-ColorScriptConfiguration -Configuration $updated

                $written = Get-Content -LiteralPath $path -Raw
                $written | Should -Match '"Cache"'
            }
        }

        It "invokes help for configuration cmdlets" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced

                Get-ColorScriptConfiguration -Help
                Set-ColorScriptConfiguration -Help
                Reset-ColorScriptConfiguration -Help

                Assert-MockCalled -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced -Times 3
            }
        }

        It "clears cache path when CachePath is blank" {
            InModuleScope ColorScripts-Enhanced {
                $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $root -Force | Out-Null

                Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $root }

                Initialize-Configuration
                $script:ConfigurationData.Cache.Path = 'C:\Cache'

                Set-ColorScriptConfiguration -CachePath ''
                $script:ConfigurationData.Cache.Path | Should -BeNull
            }
        }

        It "throws when cache path cannot be resolved" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith { $null }
                { Set-ColorScriptConfiguration -CachePath 'ZZ:\invalid' } | Should -Throw
            }
        }

        It "returns updated configuration on reset" {
            InModuleScope ColorScripts-Enhanced {
                $root = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $root -Force | Out-Null
                Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $root }

                $result = Reset-ColorScriptConfiguration -PassThru -Confirm:$false
                $result | Should -Not -BeNullOrEmpty
                $result.Cache.ContainsKey('Path') | Should -BeTrue
            }
        }
    }

    Context "Cache directory initialization" {
        It "uses environment override when resolvable" {
            $override = Join-Path $script:TestDriveRoot ('CacheOverride_' + [guid]::NewGuid())
            $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $override

            InModuleScope ColorScripts-Enhanced {
                $script:CacheDir = $null
                $script:CacheInitialized = $false

                Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Path)
                    $null = $Path
                    Join-Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath 'CacheOverrideResolved'
                }

                Initialize-CacheDirectory
                $script:CacheDir | Should -Match 'CacheOverrideResolved'
                $script:CacheInitialized | Should -BeTrue
            }
        }

        It "falls back to temp directory when candidates fail" {
            # Clear all environment overrides so we test the fallback path
            $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
            $originalAppData = $env:APPDATA
            $originalWindows = $IsWindows
            $originalMac = $IsMacOS
            $originalLinux = $IsLinux

            Remove-Item Env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -ErrorAction SilentlyContinue
            $env:APPDATA = $null
            Set-Variable -Name IsWindows -Scope Global -Force -Value $false
            Set-Variable -Name IsMacOS -Scope Global -Force -Value $false
            Set-Variable -Name IsLinux -Scope Global -Force -Value $true

            try {
                InModuleScope ColorScripts-Enhanced {
                    $script:CacheDir = $null
                    $script:CacheInitialized = $false
                    $script:ConfigurationInitialized = $false
                    $script:ConfigurationData = @{
                        Cache = @{ Path = $null }
                    }

                    # Mock to make all candidates fail to create directories
                    Mock -CommandName Test-Path -ModuleName ColorScripts-Enhanced -MockWith { $false } -ParameterFilter {
                        $LiteralPath -match 'cache|Cache|CACHE'
                    }
                    Mock -CommandName New-Item -ModuleName ColorScripts-Enhanced -MockWith {
                        throw 'simulated failure'
                    } -ParameterFilter {
                        $Path -match 'cache|Cache|CACHE' -and $Path -notmatch 'Temp'
                    }

                    Initialize-CacheDirectory

                    $expectedTempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ColorScripts-Enhanced'
                    $expectedResolved = $expectedTempDir
                    try {
                        $expectedResolved = (Resolve-Path -LiteralPath $expectedTempDir -ErrorAction Stop).ProviderPath
                    }
                    catch {
                        $expectedResolved = [System.IO.Path]::GetFullPath($expectedTempDir)
                    }

                    $script:CacheDir | Should -Match 'ColorScripts-Enhanced'
                    $script:CacheDir.StartsWith([System.IO.Path]::GetTempPath()) | Should -BeTrue
                    Test-Path -LiteralPath $script:CacheDir | Should -BeTrue
                    $script:CacheInitialized | Should -BeTrue
                }
            }
            finally {
                if ($null -eq $originalOverride) {
                    Remove-Item Env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -ErrorAction SilentlyContinue
                }
                else {
                    $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $originalOverride
                }

                if ($null -eq $originalAppData) {
                    Remove-Item Env:APPDATA -ErrorAction SilentlyContinue
                }
                else {
                    $env:APPDATA = $originalAppData
                }

                Set-Variable -Name IsWindows -Scope Global -Force -Value $originalWindows
                Set-Variable -Name IsMacOS -Scope Global -Force -Value $originalMac
                Set-Variable -Name IsLinux -Scope Global -Force -Value $originalLinux
            }
        }
    }

    Context "Metadata table caching" {
        It "loads metadata and reuses cache" {
            $cacheRoot = Join-Path $script:TestDriveRoot ('MetaCache_' + [guid]::NewGuid())
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null

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
                $second.Keys | Should -Contain 'bars'
            }
        }
    }

    Context "Script inventory refresh" {
        It "refreshes when directory timestamp changes" {
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

    Context "Utility helpers" {
        It "evaluates text emission scenarios" {
            InModuleScope ColorScripts-Enhanced {
                $isRedirected = [Console]::IsOutputRedirected

                Test-ColorScriptTextEmission -ReturnText $true -PassThru $false -PipelineLength 0 -BoundParameters @{} | Should -BeTrue
                Test-ColorScriptTextEmission -ReturnText $false -PassThru $true -PipelineLength 0 -BoundParameters @{} | Should -Be $isRedirected
                Test-ColorScriptTextEmission -ReturnText $false -PassThru $false -PipelineLength 2 -BoundParameters @{} | Should -BeTrue
                Test-ColorScriptTextEmission -ReturnText $false -PassThru $false -PipelineLength 1 -BoundParameters @{ OutVariable = 'ov' } | Should -BeTrue
                Test-ColorScriptTextEmission -ReturnText $false -PassThru $false -PipelineLength 1 -BoundParameters @{} | Should -Be $isRedirected
            }
        }

        It "prefers pwsh command path when available" {
            InModuleScope ColorScripts-Enhanced {
                $script:PowerShellExecutable = $null
                Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith { [pscustomobject]@{ Path = 'C:\Tools\pwsh.exe' } }

                Get-PowerShellExecutable | Should -Be 'C:\Tools\pwsh.exe'
            }
        }

        It "falls back to current process when pwsh command not found" {
            InModuleScope ColorScripts-Enhanced {
                $script:PowerShellExecutable = $null
                Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith { $null }

                $result = Get-PowerShellExecutable
                $result | Should -Not -BeNullOrEmpty
            }
        }

        It "invokes scriptblocks with and without arguments" {
            InModuleScope ColorScripts-Enhanced {
                Invoke-WithUtf8Encoding -ScriptBlock { 'no-args' } | Should -Be 'no-args'
                $sum = Invoke-WithUtf8Encoding -ScriptBlock { param($a, $b) $a + $b } -Arguments @(2, 3)
                $sum | Should -Be 5
            }
        }

        It "writes rendered text to the console" {
            InModuleScope ColorScripts-Enhanced {
                $original = [Console]::Out
                $writer = New-Object System.IO.StringWriter

                try {
                    [Console]::SetOut($writer)
                    Write-RenderedText -Text 'Rendered Line'
                    Write-RenderedText -Text $null
                }
                finally {
                    [Console]::SetOut($original)
                }

                $writer.ToString() | Should -Match 'Rendered Line'
            }
        }

        It "strips ANSI sequences when NoAnsiOutput is specified" {
            InModuleScope ColorScripts-Enhanced {
                $original = [Console]::Out
                $writer = New-Object System.IO.StringWriter

                try {
                    [Console]::SetOut($writer)
                    $ansiText = "${([char]27)}[31mColor${([char]27)}[0m"
                    Write-RenderedText -Text $ansiText -NoAnsiOutput
                }
                finally {
                    [Console]::SetOut($original)
                }

                $captured = $writer.ToString()
                $captured | Should -Be "Color$([Environment]::NewLine)"
                $captured | Should -Not -Match "${([char]27)}\["
            }
        }

        It "wraps colored message segments with ANSI when allowed" {
            InModuleScope ColorScripts-Enhanced {
                $result = New-ColorScriptAnsiText -Text 'Sample' -Color 'Cyan'
                $result | Should -Match "${([char]27)}\[36m"
                $result | Should -Match "${([char]27)}\[0m"
            }
        }

        It "omits ANSI sequences when disabled" {
            InModuleScope ColorScripts-Enhanced {
                $result = New-ColorScriptAnsiText -Text 'Sample' -Color 'Cyan' -NoAnsiOutput
                $result | Should -Be 'Sample'
            }
        }

        It "respects quiet flag when writing informational messages" {
            InModuleScope ColorScripts-Enhanced {
                $script:Captured = @()
                Mock -CommandName Write-Information -ModuleName ColorScripts-Enhanced -MockWith {
                    param($MessageData, $Tags, $InformationAction)
                    $null = $Tags
                    $null = $InformationAction
                    $script:Captured += $MessageData
                }

                Write-ColorScriptInformation -Message 'visible'
                Write-ColorScriptInformation -Message 'hidden' -Quiet

                $script:Captured | Should -Contain 'visible'
                $script:Captured | Should -Not -Contain 'hidden'
            }
        }

        It "builds matcher sets and selects records" {
            InModuleScope ColorScripts-Enhanced {
                $matchers = New-NameMatcherSet -Patterns @('alpha*', 'beta')
                $matchers.Count | Should -Be 2
                @($matchers | Where-Object { $_.IsWildcard }).Count | Should -Be 1

                $records = @(
                    [pscustomobject]@{ Name = 'alphaOne'; Path = 'one' },
                    [pscustomobject]@{ Name = 'beta'; Path = 'two' },
                    [pscustomobject]@{ Name = 'gamma'; Path = 'three' }
                )

                $selection = Select-RecordsByName -Records $records -Name @('alpha*', 'delta')
                $selection.Records.Count | Should -Be 1
                $selection.Records[0].Name | Should -Be 'alphaOne'
                $selection.MissingPatterns | Should -Contain 'delta'
                $selection.MatchMap.Count | Should -Be 2
            }
        }
    }
}
