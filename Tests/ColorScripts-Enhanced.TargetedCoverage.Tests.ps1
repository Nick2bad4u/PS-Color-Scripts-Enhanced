Describe "ColorScripts-Enhanced targeted coverage" {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
        Import-Module $script:ModuleManifest -Force
    }

    AfterEach {
        InModuleScope ColorScripts-Enhanced {
            $script:CacheDir = $null
            $script:CacheInitialized = $false
            $script:ConfigurationData = $null
            $script:ConfigurationInitialized = $false
        }
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context "Resolve-CachePath fallback scenarios" {
        It "falls back to HOME when user profile delegate returns null" {
            $homeOverride = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
            New-Item -ItemType Directory -Path $homeOverride -Force | Out-Null

            $paths = InModuleScope ColorScripts-Enhanced -Parameters @{ overrideHome = $homeOverride } {
                param($overrideHome)
                $originalDelegate = $script:GetUserProfilePathDelegate
                $originalHome = $HOME
                try {
                    $script:GetUserProfilePathDelegate = { $null }
                    Set-Variable -Name HOME -Scope Global -Force -Value $overrideHome
                    $resolved = Resolve-CachePath -Path '~'
                    [pscustomobject]@{
                        Resolved = $resolved
                        Expected = $overrideHome
                    }
                }
                finally {
                    $script:GetUserProfilePathDelegate = $originalDelegate
                    Set-Variable -Name HOME -Scope Global -Force -Value $originalHome
                }
            }

            $paths.Resolved | Should -Be $paths.Expected
        }

        It "returns null when current path delegates fail" {
            $result = InModuleScope ColorScripts-Enhanced {
                $originalProvider = $script:GetCurrentProviderPathDelegate
                $originalDirectory = $script:GetCurrentDirectoryDelegate
                try {
                    $script:GetCurrentProviderPathDelegate = { throw 'provider missing' }
                    $script:GetCurrentDirectoryDelegate = { throw 'directory missing' }
                    Resolve-CachePath -Path 'relative/path'
                }
                finally {
                    $script:GetCurrentProviderPathDelegate = $originalProvider
                    $script:GetCurrentDirectoryDelegate = $originalDirectory
                }
            }

            $result | Should -Be $null
        }

        It "logs verbose warning when full path resolution fails" {
            $result = InModuleScope ColorScripts-Enhanced {
                $originalFullPath = $script:GetFullPathDelegate
                try {
                    $script:GetFullPathDelegate = {
                        param($path)
                        [void]$path
                        throw [System.Exception]::new('full path failure')
                    }

                    $script:__Verbose = [System.Collections.Generic.List[string]]::new()
                    Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Message)
                        $null = $script:__Verbose.Add($Message)
                    }

                    $value = Resolve-CachePath -Path 'relative/path'
                    [pscustomobject]@{
                        Value   = $value
                        Verbose = $script:__Verbose.ToArray()
                    }
                }
                finally {
                    $script:GetFullPathDelegate = $originalFullPath
                    Remove-Variable -Name __Verbose -Scope Script -ErrorAction SilentlyContinue
                }
            }

            $result.Value | Should -Be $null
            ($result.Verbose | Where-Object { $_ -like 'Unable to resolve cache path*' }) | Should -Not -BeNullOrEmpty
        }
    }

    Context "Test-ColorScriptTextEmission" {
        It "returns true when ReturnText is requested" {
            $result = InModuleScope ColorScripts-Enhanced {
                Test-ColorScriptTextEmission -ReturnText $true -PassThru $false -PipelineLength 1 -BoundParameters @{}
            }

            $result | Should -BeTrue
        }

        It "returns false when PassThru is enabled" {
            $result = InModuleScope ColorScripts-Enhanced {
                Test-ColorScriptTextEmission -ReturnText $false -PassThru $true -PipelineLength 1 -BoundParameters @{}
            }

            $expected = InModuleScope ColorScripts-Enhanced {
                if ($script:IsOutputRedirectedDelegate) {
                    & $script:IsOutputRedirectedDelegate
                }
                else {
                    [Console]::IsOutputRedirected
                }
            }

            $result | Should -Be $expected
        }

        It "returns true for pipeline length greater than one" {
            $result = InModuleScope ColorScripts-Enhanced {
                Test-ColorScriptTextEmission -ReturnText $false -PassThru $false -PipelineLength 2 -BoundParameters @{}
            }

            $result | Should -BeTrue
        }

        It "returns true when OutVariable is present" {
            $bound = @{ OutVariable = 'var' }
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ bound = $bound } {
                param($bound)
                Test-ColorScriptTextEmission -ReturnText $false -PassThru $false -PipelineLength 1 -BoundParameters $bound
            }

            $result | Should -BeTrue
        }

        It "returns false when no special conditions apply" {
            $result = InModuleScope ColorScripts-Enhanced {
                Test-ColorScriptTextEmission -ReturnText $false -PassThru $false -PipelineLength 1 -BoundParameters @{}
            }

            $expected = InModuleScope ColorScripts-Enhanced {
                if ($script:IsOutputRedirectedDelegate) {
                    & $script:IsOutputRedirectedDelegate
                }
                else {
                    [Console]::IsOutputRedirected
                }
            }

            $result | Should -Be $expected
        }
    }

    Context "Write-RenderedText" {
        It "appends newline when missing" {
            $joined = InModuleScope ColorScripts-Enhanced {
                $originalDelegate = $script:ConsoleWriteDelegate
                try {
                    $script:__Rendered = [System.Collections.Generic.List[string]]::new()
                    $script:ConsoleWriteDelegate = {
                        param($Text)
                        $null = $script:__Rendered.Add([string]$Text)
                    }

                    Write-RenderedText -Text 'sample'
                    -join $script:__Rendered
                }
                finally {
                    $script:ConsoleWriteDelegate = $originalDelegate
                    Remove-Variable -Name __Rendered -Scope Script -ErrorAction SilentlyContinue
                }
            }

            $joined | Should -Be ('sample' + [Environment]::NewLine)
        }

        It "avoids duplicate newline when text already terminated" {
            $joined = InModuleScope ColorScripts-Enhanced {
                $originalDelegate = $script:ConsoleWriteDelegate
                try {
                    $script:__Rendered = [System.Collections.Generic.List[string]]::new()
                    $script:ConsoleWriteDelegate = {
                        param($Text)
                        $null = $script:__Rendered.Add([string]$Text)
                    }

                    Write-RenderedText -Text "ready`n"
                    -join $script:__Rendered
                }
                finally {
                    $script:ConsoleWriteDelegate = $originalDelegate
                    Remove-Variable -Name __Rendered -Scope Script -ErrorAction SilentlyContinue
                }
            }

            $joined | Should -Be "ready`n"
        }

        It "writes newline when input text is null" {
            $joined = InModuleScope ColorScripts-Enhanced {
                $originalDelegate = $script:ConsoleWriteDelegate
                try {
                    $script:__Rendered = [System.Collections.Generic.List[string]]::new()
                    $script:ConsoleWriteDelegate = {
                        param($Text)
                        $null = $script:__Rendered.Add([string]$Text)
                    }

                    Write-RenderedText -Text $null
                    -join $script:__Rendered
                }
                finally {
                    $script:ConsoleWriteDelegate = $originalDelegate
                    Remove-Variable -Name __Rendered -Scope Script -ErrorAction SilentlyContinue
                }
            }

            $joined | Should -Be ([Environment]::NewLine)
        }
    }

    Context "Invoke-WithUtf8Encoding" {
        It "switches encoding to UTF-8 and restores original" {
            InModuleScope ColorScripts-Enhanced {
                $originalIsRedirected = $script:IsOutputRedirectedDelegate
                $originalGetEncoding = $script:GetConsoleOutputEncodingDelegate
                $originalSetEncoding = $script:SetConsoleOutputEncodingDelegate

                try {
                    $script:IsOutputRedirectedDelegate = { $false }
                    $script:GetConsoleOutputEncodingDelegate = { [System.Text.Encoding]::Unicode }

                    $setEncodings = [System.Collections.Generic.List[string]]::new()
                    $script:SetConsoleOutputEncodingDelegate = {
                        param([System.Text.Encoding]$Encoding)
                        $null = $setEncodings.Add($Encoding.WebName)
                        [Console]::OutputEncoding = $Encoding
                    }

                    $flag = $false
                    Invoke-WithUtf8Encoding -ScriptBlock {
                        param([ref]$State)
                        $State.Value = $true
                    } -Arguments @([ref]$flag)

                    $flag | Should -BeTrue
                    $setEncodings | Should -Contain 'utf-8'
                    $setEncodings | Should -Contain ([Console]::OutputEncoding.WebName)
                }
                finally {
                    $script:IsOutputRedirectedDelegate = $originalIsRedirected
                    $script:GetConsoleOutputEncodingDelegate = $originalGetEncoding
                    $script:SetConsoleOutputEncodingDelegate = $originalSetEncoding
                }
            }
        }
    }

    Context "Get-PowerShellExecutable fallback" {
        It "uses current process module when pwsh is unavailable" {
            InModuleScope ColorScripts-Enhanced {
                $script:PowerShellExecutable = $null
            }

            Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith { $null }

            $expected = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
            $process = [pscustomobject]@{ MainModule = [pscustomobject]@{ FileName = $expected } }

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ proc = $process } {
                param($proc)
                [void]$proc
                $original = $script:GetCurrentProcessDelegate
                try {
                    $script:GetCurrentProcessDelegate = { $proc }
                    Get-PowerShellExecutable
                }
                finally {
                    $script:GetCurrentProcessDelegate = $original
                }
            }

            $result | Should -Be $expected
        }

        It "falls back to command line when process access fails" {
            InModuleScope ColorScripts-Enhanced {
                $script:PowerShellExecutable = $null
            }

            Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith { $null }

            $result = InModuleScope ColorScripts-Enhanced {
                $original = $script:GetCurrentProcessDelegate
                try {
                    $script:GetCurrentProcessDelegate = { throw [System.InvalidOperationException]::new('unavailable') }
                    Get-PowerShellExecutable
                }
                finally {
                    $script:GetCurrentProcessDelegate = $original
                }
            }

            $result | Should -Be ([System.Environment]::GetCommandLineArgs()[0])
        }
    }

    Context "Reset-ScriptInventoryCache" {
        It "clears cached inventory state" {
            InModuleScope ColorScripts-Enhanced {
                $script:ScriptInventory = @('item')
                $script:ScriptInventoryInitialized = $true
                $script:ScriptInventoryRecords = @('record')
                $script:ScriptInventoryStamp = Get-Date

                Reset-ScriptInventoryCache

                $script:ScriptInventory | Should -BeNullOrEmpty
                $script:ScriptInventoryInitialized | Should -BeFalse
                $script:ScriptInventoryRecords | Should -BeNullOrEmpty
                $script:ScriptInventoryStamp | Should -BeNullOrEmpty
            }
        }
    }

    Context "Initialize-SystemDelegateState" {
        It "reinitializes default delegates" {
            $root = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
            $sample = Join-Path -Path $root -ChildPath 'delegate.txt'
            Set-Content -LiteralPath $sample -Value 'Delegate test content' -Encoding UTF8

            InModuleScope ColorScripts-Enhanced -Parameters @{ samplePath = $sample; sampleRoot = $root } {
                param($samplePath, $sampleRoot)

                $delegateNames = @(
                    'GetUserProfilePathDelegate',
                    'IsPathRootedDelegate',
                    'GetFullPathDelegate',
                    'GetCurrentDirectoryDelegate',
                    'GetCurrentProviderPathDelegate',
                    'DirectoryGetLastWriteTimeUtcDelegate',
                    'FileExistsDelegate',
                    'FileGetLastWriteTimeUtcDelegate',
                    'FileReadAllTextDelegate',
                    'GetCurrentProcessDelegate',
                    'IsOutputRedirectedDelegate',
                    'GetConsoleOutputEncodingDelegate',
                    'SetConsoleOutputEncodingDelegate',
                    'ConsoleWriteDelegate'
                )

                $saved = @{}
                foreach ($name in $delegateNames) {
                    $saved[$name] = Get-Variable -Name $name -Scope Script -ValueOnly
                    Set-Variable -Name $name -Scope Script -Value $null
                }

                try {
                    Initialize-SystemDelegateState

                    & $script:GetUserProfilePathDelegate | Should -Not -BeNullOrEmpty
                    & $script:IsPathRootedDelegate $sampleRoot | Should -BeTrue
                    & $script:GetFullPathDelegate '.' | Should -Not -BeNullOrEmpty
                    & $script:GetCurrentDirectoryDelegate | Should -Not -BeNullOrEmpty
                    & $script:GetCurrentProviderPathDelegate | Should -Not -BeNullOrEmpty
                    & $script:DirectoryGetLastWriteTimeUtcDelegate $sampleRoot | Should -BeOfType [datetime]
                    & $script:FileExistsDelegate $samplePath | Should -BeTrue
                    & $script:FileGetLastWriteTimeUtcDelegate $samplePath | Should -BeOfType [datetime]
                    & $script:FileReadAllTextDelegate $samplePath ([System.Text.Encoding]::UTF8) | Should -Match 'Delegate test content'
                    & $script:GetCurrentProcessDelegate | Should -BeOfType [System.Diagnostics.Process]
                    & $script:IsOutputRedirectedDelegate | Should -BeOfType [bool]
                    & $script:GetConsoleOutputEncodingDelegate | Should -BeOfType [System.Text.Encoding]
                    $originalEncoding = [Console]::OutputEncoding
                    try {
                        & $script:SetConsoleOutputEncodingDelegate ([System.Text.Encoding]::UTF8)
                    }
                    finally {
                        [Console]::OutputEncoding = $originalEncoding
                    }
                    & $script:ConsoleWriteDelegate ''
                }
                finally {
                    foreach ($name in $delegateNames) {
                        Set-Variable -Name $name -Scope Script -Value $saved[$name]
                    }
                }
            }
        }
    }

    Context "Clear-ColorScriptCache ShouldProcess" {
        BeforeEach {
            InModuleScope ColorScripts-Enhanced {
                $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                $script:CacheInitialized = $true
            }
        }

        It "marks entries as skipped when ShouldProcess declines" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }
            }

            $cachePath = InModuleScope ColorScripts-Enhanced {
                $path = Join-Path -Path $script:CacheDir -ChildPath 'skip.cache'
                Set-Content -LiteralPath $path -Value 'cached' -Encoding UTF8
                $path
            }

            $result = Clear-ColorScriptCache -Name 'skip' -WhatIf

            $result | Should -HaveCount 1
            $result[0].Status | Should -Be 'SkippedByUser'
            Test-Path -LiteralPath $cachePath | Should -BeTrue
        }

        It "returns empty array when clearing all with WhatIf" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }
                Set-Content -LiteralPath (Join-Path -Path $script:CacheDir -ChildPath 'all.cache') -Value 'cached' -Encoding UTF8
            }

            $result = Clear-ColorScriptCache -All -WhatIf

            $result | Should -BeNullOrEmpty
        }
    }

    Context "Invoke-ColorScriptProcess" {
        It "captures successful invocation" {
            $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
            $scriptPath = Join-Path -Path $testRoot -ChildPath 'invoke-success.ps1'
            Set-Content -LiteralPath $scriptPath -Value "Write-Host 'Success'" -Encoding UTF8

            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Get-PowerShellExecutable -ModuleName ColorScripts-Enhanced -MockWith { 'pwsh' }
                Mock -CommandName New-Object -ModuleName ColorScripts-Enhanced -MockWith {
                    param($TypeName)
                    switch ($TypeName) {
                        'System.Diagnostics.ProcessStartInfo' {
                            return [pscustomobject]@{
                                FileName               = $null
                                Arguments              = $null
                                UseShellExecute        = $null
                                RedirectStandardOutput = $null
                                RedirectStandardError  = $null
                                StandardOutputEncoding = $null
                                StandardErrorEncoding  = $null
                                WorkingDirectory       = $null
                            }
                        }
                        'System.Text.StringBuilder' {
                            return [System.Text.StringBuilder]::new()
                        }
                        'System.Diagnostics.Process' {
                            $stdout = [pscustomobject]@{}
                            $stdout | Add-Member -MemberType ScriptMethod -Name ReadToEnd -Value { 'stdout-data' }
                            $stderr = [pscustomobject]@{}
                            $stderr | Add-Member -MemberType ScriptMethod -Name ReadToEnd -Value { 'stderr-data' }
                            $process = [pscustomobject]@{ StartInfo = $null; ExitCode = 0; StandardOutput = $stdout; StandardError = $stderr }
                            $process | Add-Member -MemberType ScriptMethod -Name Start -Value { $true }
                            $process | Add-Member -MemberType ScriptMethod -Name WaitForExit -Value { }
                            $process | Add-Member -MemberType ScriptMethod -Name Dispose -Value { }
                            return $process
                        }
                        default {
                            throw "Unexpected type: $TypeName"
                        }
                    }
                }
            }

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $scriptPath } {
                param($path)
                Invoke-ColorScriptProcess -ScriptPath $path
            }

            $result.Success | Should -BeTrue
            $result.StdOut | Should -Be 'stdout-data'
            $result.StdErr | Should -Be 'stderr-data'
        }

        It "captures process creation failures" {
            $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
            $scriptPath = Join-Path -Path $testRoot -ChildPath 'invoke-fail.ps1'
            Set-Content -LiteralPath $scriptPath -Value "Write-Host 'Failure'" -Encoding UTF8

            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Get-PowerShellExecutable -ModuleName ColorScripts-Enhanced -MockWith { 'pwsh' }
                Mock -CommandName New-Object -ModuleName ColorScripts-Enhanced -MockWith {
                    param($TypeName)
                    switch ($TypeName) {
                        'System.Diagnostics.ProcessStartInfo' {
                            return [pscustomobject]@{
                                FileName               = $null
                                Arguments              = $null
                                UseShellExecute        = $null
                                RedirectStandardOutput = $null
                                RedirectStandardError  = $null
                                StandardOutputEncoding = $null
                                StandardErrorEncoding  = $null
                                WorkingDirectory       = $null
                            }
                        }
                        'System.Text.StringBuilder' { return [System.Text.StringBuilder]::new() }
                        'System.Diagnostics.Process' { throw [System.Exception]::new('process creation failure') }
                        default { throw "Unexpected type: $TypeName" }
                    }
                }
            }

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $scriptPath } {
                param($path)
                Invoke-ColorScriptProcess -ScriptPath $path
            }

            $result.Success | Should -BeFalse
            $result.StdErr | Should -Match 'process creation failure'
        }
    }

    Context "Invoke-ColorScriptsStartup verbose handling" {
        It "logs verbose output when configuration root lookup fails" {
            $originalCI = $env:CI
            $originalGitHubActions = $env:GITHUB_ACTIONS
            $env:CI = $null
            $env:GITHUB_ACTIONS = $null

            try {
                $verbose = InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                    Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { throw [System.IO.IOException]::new('root missing') }
                    Mock -CommandName Get-ConfigurationDataInternal -ModuleName ColorScripts-Enhanced -MockWith { @{ Startup = @{ AutoShowOnImport = $false } } }
                    $script:__StartupVerbose = [System.Collections.Generic.List[string]]::new()
                    Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Message)
                        $null = $script:__StartupVerbose.Add($Message)
                    }

                    Invoke-ColorScriptsStartup
                    $script:__StartupVerbose.ToArray()
                }

                ($verbose | Where-Object { $_ -like 'Unable to locate configuration root*' }) | Should -Not -BeNullOrEmpty
            }
            finally {
                if ($null -eq $originalCI) { Remove-Item Env:CI -ErrorAction SilentlyContinue } else { $env:CI = $originalCI }
                if ($null -eq $originalGitHubActions) { Remove-Item Env:GITHUB_ACTIONS -ErrorAction SilentlyContinue } else { $env:GITHUB_ACTIONS = $originalGitHubActions }
            }
        }
    }

    Context "Test-ConsoleOutputRedirected" {
        It "returns false when delegate throws" {
            $result = InModuleScope ColorScripts-Enhanced {
                $original = $script:IsOutputRedirectedDelegate
                try {
                    $script:IsOutputRedirectedDelegate = { throw [System.IO.IOException]::new('unavailable') }
                    Test-ConsoleOutputRedirected
                }
                finally {
                    $script:IsOutputRedirectedDelegate = $original
                }
            }

            $result | Should -BeFalse
        }
    }
}
