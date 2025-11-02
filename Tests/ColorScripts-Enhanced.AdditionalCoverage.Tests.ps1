Describe "ColorScripts-Enhanced additional coverage" {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModulePath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModulePath -ChildPath 'ColorScripts-Enhanced.psd1'
        $script:OriginalModuleRootOverride = $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT
        $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT = $script:ModulePath
        Import-Module $script:ModuleManifest -Force

        $script:OriginalCacheDir = InModuleScope ColorScripts-Enhanced { $script:CacheDir }
        $script:OriginalCacheInitialized = InModuleScope ColorScripts-Enhanced { $script:CacheInitialized }
        $script:OriginalUtf8Encoding = InModuleScope ColorScripts-Enhanced { $script:Utf8NoBomEncoding }

        if (-not ('CoverageHost.StubHost' -as [type])) {
            Add-Type -TypeDefinition @"
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Management.Automation;
using System.Management.Automation.Host;
using System.Security;

namespace CoverageHost
{
    internal sealed class StubRawUI : PSHostRawUserInterface
    {
        private ConsoleColor backgroundColor = ConsoleColor.Black;
        private ConsoleColor foregroundColor = ConsoleColor.Gray;
        private Size bufferSize = new Size { Width = 120, Height = 600 };
        private Coordinates cursorPosition = new Coordinates(0, 0);
        private int cursorSize = 1;
        private Size windowSize = new Size { Width = 120, Height = 30 };
        private Coordinates windowPosition = new Coordinates(0, 0);
        private string windowTitle = "CoverageHost";

        public override ConsoleColor BackgroundColor
        {
            get { return backgroundColor; }
            set { backgroundColor = value; }
        }

        public override ConsoleColor ForegroundColor
        {
            get { return foregroundColor; }
            set { foregroundColor = value; }
        }

        public override Size BufferSize
        {
            get { return bufferSize; }
            set { bufferSize = value; }
        }

        public override Coordinates CursorPosition
        {
            get { return cursorPosition; }
            set { cursorPosition = value; }
        }

        public override int CursorSize
        {
            get { return cursorSize; }
            set { cursorSize = value; }
        }

        public override Size WindowSize
        {
            get { return windowSize; }
            set { windowSize = value; }
        }

        public override Coordinates WindowPosition
        {
            get { return windowPosition; }
            set { windowPosition = value; }
        }

        public override string WindowTitle
        {
            get { return windowTitle; }
            set { windowTitle = value; }
        }

        public override Size MaxWindowSize
        {
            get { return windowSize; }
        }

        public override Size MaxPhysicalWindowSize
        {
            get { return windowSize; }
        }
        public override void FlushInputBuffer() { }
        public override BufferCell[,] GetBufferContents(Rectangle rectangle)
        {
            return new BufferCell[rectangle.Bottom - rectangle.Top + 1, rectangle.Right - rectangle.Left + 1];
        }
        public override KeyInfo ReadKey(ReadKeyOptions options)
        {
            return new KeyInfo();
        }
        public override void ScrollBufferContents(Rectangle source, Coordinates destination, Rectangle clip, BufferCell fill) { }
        public override void SetBufferContents(Rectangle rectangle, BufferCell fill) { }
        public override void SetBufferContents(Coordinates origin, BufferCell[,] contents) { }
        public override bool KeyAvailable
        {
            get { return false; }
        }
    }

    internal sealed class StubHostUI : PSHostUserInterface
    {
        private readonly StubRawUI rawUI = new StubRawUI();
        private readonly Queue<int> responses;

        internal StubHostUI(IEnumerable<int> responses)
        {
            this.responses = new Queue<int>(responses ?? Array.Empty<int>());
        }

        public override PSHostRawUserInterface RawUI
        {
            get { return rawUI; }
        }

        public override void Write(string value) { }
        public override void Write(ConsoleColor foregroundColor, ConsoleColor backgroundColor, string value) { }
        public override void WriteLine(string value) { }
        public override void WriteErrorLine(string value) { }
        public override void WriteDebugLine(string message) { }
        public override void WriteProgress(long sourceId, ProgressRecord record) { }
        public override void WriteVerboseLine(string message) { }
        public override void WriteWarningLine(string message) { }

        public override Dictionary<string, PSObject> Prompt(string caption, string message, Collection<FieldDescription> descriptions)
        {
            var result = new Dictionary<string, PSObject>(StringComparer.OrdinalIgnoreCase);
            if (descriptions != null)
            {
                foreach (var field in descriptions)
                {
                    var defaultValue = field.DefaultValue ?? string.Empty;
                    result[field.Name] = PSObject.AsPSObject(defaultValue);
                }
            }
            return result;
        }

        public override int PromptForChoice(string caption, string message, Collection<ChoiceDescription> choices, int defaultChoice)
        {
            if (responses.Count > 0)
            {
                return responses.Dequeue();
            }
            return defaultChoice;
        }

        private static SecureString CreateSecureString(string value)
        {
            var secure = new SecureString();
            if (!string.IsNullOrEmpty(value))
            {
                foreach (var ch in value)
                {
                    secure.AppendChar(ch);
                }
            }
            secure.MakeReadOnly();
            return secure;
        }

        public override PSCredential PromptForCredential(string caption, string message, string userName, string targetName)
        {
            return new PSCredential(userName ?? "user", CreateSecureString("password"));
        }

        public override PSCredential PromptForCredential(string caption, string message, string userName, string targetName, PSCredentialTypes allowedCredentialTypes, PSCredentialUIOptions options)
        {
            return new PSCredential(userName ?? "user", CreateSecureString("password"));
        }

        public override string ReadLine()
        {
            return string.Empty;
        }

        public override SecureString ReadLineAsSecureString()
        {
            var secure = new SecureString();
            secure.MakeReadOnly();
            return secure;
        }
    }

    public sealed class StubHost : PSHost
    {
        private readonly Guid instanceId = Guid.NewGuid();
        private readonly StubHostUI ui;

        public StubHost(IEnumerable<int> responses)
        {
            ui = new StubHostUI(responses);
        }

        public override Guid InstanceId
        {
            get { return instanceId; }
        }

        public override string Name
        {
            get { return "CoverageHost"; }
        }

        public override Version Version
        {
            get { return new Version(1, 0); }
        }

        public override PSHostUserInterface UI
        {
            get { return ui; }
        }

        public override PSObject PrivateData
        {
            get { return PSObject.AsPSObject(null); }
        }

        public override CultureInfo CurrentCulture
        {
            get { return CultureInfo.InvariantCulture; }
        }

        public override CultureInfo CurrentUICulture
        {
            get { return CultureInfo.InvariantCulture; }
        }
        public override void EnterNestedPrompt() { }
        public override void ExitNestedPrompt() { }
        public override void NotifyBeginApplication() { }
        public override void NotifyEndApplication() { }
        public override void SetShouldExit(int exitCode) { }
    }
}
"@
        }

        function Invoke-WithCoverageHost {
            param(
                [Parameter(Mandatory)]
                [scriptblock]$ScriptBlock,
                [int[]]$ChoiceResponses
            )

            $responseList = New-Object 'System.Collections.Generic.List[int]'
            if ($ChoiceResponses) {
                foreach ($choice in $ChoiceResponses) {
                    [void]$responseList.Add([int]$choice)
                }
            }

            $coverageHost = [CoverageHost.StubHost]::new($responseList)
            $runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace($coverageHost)
            $powerShell = $null

            try {
                $runspace.Open()
                $powerShell = [System.Management.Automation.PowerShell]::Create()
                $powerShell.Runspace = $runspace
                $null = $powerShell.AddScript("Import-Module '$($script:ModulePath)' -Force")
                $null = $powerShell.Invoke()
                $powerShell.Commands.Clear()

                $null = $powerShell.AddScript($ScriptBlock.ToString())
                $result = $powerShell.Invoke()

                if ($powerShell.Streams.Error.Count -gt 0) {
                    throw $powerShell.Streams.Error[0]
                }

                return $result
            }
            finally {
                if ($powerShell) { $powerShell.Dispose() }
                if ($runspace) { $runspace.Dispose() }
            }
        }

        $script:OriginalAppData = $env:APPDATA
        $script:OriginalHome = $env:HOME
        $script:OriginalProfileObject = $PROFILE
        $script:OriginalCi = $env:CI
        $script:OriginalGitHubActions = $env:GITHUB_ACTIONS
        $script:OriginalAutoShowOverride = $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT

        $existingSenderInfo = Get-Variable -Name PSSenderInfo -Scope Global -ErrorAction SilentlyContinue
        if ($existingSenderInfo) {
            $script:HadPSSenderInfo = $true
            $script:OriginalPSSenderInfo = $existingSenderInfo.Value
        }
        else {
            $script:HadPSSenderInfo = $false
            $script:OriginalPSSenderInfo = $null
        }
    }

    AfterEach {
        InModuleScope ColorScripts-Enhanced {
            $script:CacheDir = $null
            $script:CacheInitialized = $false
            $script:ConfigurationData = $null
            $script:ConfigurationInitialized = $false
            Reset-ScriptInventoryCache
        }

        if ($null -eq $script:OriginalAppData) {
            Remove-Item Env:APPDATA -ErrorAction SilentlyContinue
        }
        else {
            $env:APPDATA = $script:OriginalAppData
        }

        if ($null -eq $script:OriginalHome) {
            Remove-Item Env:HOME -ErrorAction SilentlyContinue
        }
        else {
            $env:HOME = $script:OriginalHome
        }

        if ($null -eq $script:OriginalCi) {
            Remove-Item Env:CI -ErrorAction SilentlyContinue
        }
        else {
            $env:CI = $script:OriginalCi
        }

        if ($null -eq $script:OriginalGitHubActions) {
            Remove-Item Env:GITHUB_ACTIONS -ErrorAction SilentlyContinue
        }
        else {
            $env:GITHUB_ACTIONS = $script:OriginalGitHubActions
        }

        if ($null -eq $script:OriginalAutoShowOverride) {
            Remove-Item Env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT -ErrorAction SilentlyContinue
        }
        else {
            $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT = $script:OriginalAutoShowOverride
        }

        if ($script:HadPSSenderInfo) {
            Set-Variable -Name PSSenderInfo -Scope Global -Value $script:OriginalPSSenderInfo -Force
        }
        else {
            Remove-Variable -Name PSSenderInfo -Scope Global -ErrorAction SilentlyContinue
        }

        if ($null -ne $script:OriginalProfileObject) {
            Set-Variable -Name PROFILE -Scope Global -Value $script:OriginalProfileObject -Force
        }
        else {
            Remove-Variable -Name PROFILE -Scope Global -ErrorAction SilentlyContinue
        }

        Remove-Item Env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -ErrorAction SilentlyContinue
    }

    AfterAll {
        InModuleScope ColorScripts-Enhanced {
            $script:CacheDir = $script:OriginalCacheDir
            $script:CacheInitialized = $script:OriginalCacheInitialized
            if ($script:OriginalUtf8Encoding) {
                $script:Utf8NoBomEncoding = $script:OriginalUtf8Encoding
            }
        }

        if ($null -ne $script:OriginalAppData) { $env:APPDATA = $script:OriginalAppData } else { Remove-Item Env:APPDATA -ErrorAction SilentlyContinue }
        if ($null -ne $script:OriginalHome) { $env:HOME = $script:OriginalHome } else { Remove-Item Env:HOME -ErrorAction SilentlyContinue }
        if ($null -ne $script:OriginalCi) { $env:CI = $script:OriginalCi } else { Remove-Item Env:CI -ErrorAction SilentlyContinue }
        if ($null -ne $script:OriginalGitHubActions) { $env:GITHUB_ACTIONS = $script:OriginalGitHubActions } else { Remove-Item Env:GITHUB_ACTIONS -ErrorAction SilentlyContinue }
        if ($null -ne $script:OriginalAutoShowOverride) { $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT = $script:OriginalAutoShowOverride } else { Remove-Item Env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT -ErrorAction SilentlyContinue }

        if ($script:HadPSSenderInfo) {
            Set-Variable -Name PSSenderInfo -Scope Global -Value $script:OriginalPSSenderInfo -Force
        }
        else {
            Remove-Variable -Name PSSenderInfo -Scope Global -ErrorAction SilentlyContinue
        }

        if ($null -ne $script:OriginalProfileObject) {
            Set-Variable -Name PROFILE -Scope Global -Value $script:OriginalProfileObject -Force
        }
        else {
            Remove-Variable -Name PROFILE -Scope Global -ErrorAction SilentlyContinue
        }

        Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue

        if ($null -ne $script:OriginalModuleRootOverride) {
            $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT = $script:OriginalModuleRootOverride
        }
        else {
            Remove-Item Env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT -ErrorAction SilentlyContinue
        }
    }

    Context "Get-CachedOutput" {
        It "returns unavailable when script path is missing" {
            InModuleScope ColorScripts-Enhanced {
                $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
                $script:CacheDir = $cacheRoot
                $script:CacheInitialized = $true

                $result = Get-CachedOutput -ScriptPath (Join-Path -Path $cacheRoot -ChildPath 'missing-script.ps1')

                $result.Available | Should -BeFalse
                $result.CacheFile | Should -Be $null
                $result.Content | Should -Be ''
            }
        }

        It "reports cache path but unavailable when cache is missing" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $cacheRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null

                $scriptPath = Join-Path -Path $testDrive -ChildPath 'sample-script.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'hello'" -Encoding UTF8

                $script:CacheDir = $cacheRoot
                $script:CacheInitialized = $true

                $result = Get-CachedOutput -ScriptPath $scriptPath

                $result.Available | Should -BeFalse
                $result.CacheFile | Should -Not -BeNullOrEmpty
                Test-Path -LiteralPath $result.CacheFile | Should -BeFalse
                $result.LastWriteTime | Should -Be $null
            }
        }

        It "invalidates cache when script is newer" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $cacheRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null

                $scriptPath = Join-Path -Path $testDrive -ChildPath 'fresh-script.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'hello'" -Encoding UTF8

                $cacheFile = Join-Path -Path $cacheRoot -ChildPath 'fresh-script.cache'
                Set-Content -Path $cacheFile -Value 'stale cache' -Encoding UTF8
                [System.IO.File]::SetLastWriteTimeUtc($cacheFile, (Get-Date).AddMinutes(-10))
                [System.IO.File]::SetLastWriteTimeUtc($scriptPath, (Get-Date).AddMinutes(-1))

                $script:CacheDir = $cacheRoot
                $script:CacheInitialized = $true

                $result = Get-CachedOutput -ScriptPath $scriptPath

                $result.Available | Should -BeFalse
                $result.CacheFile | Should -Be $cacheFile
                $result.LastWriteTime | Should -Be ([System.IO.File]::GetLastWriteTimeUtc($cacheFile))
            }
        }

        It "returns cached content when cache is up-to-date" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $cacheRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null

                $scriptPath = Join-Path -Path $testDrive -ChildPath 'cached-script.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'hello'" -Encoding UTF8

                $cacheFile = Join-Path -Path $cacheRoot -ChildPath 'cached-script.cache'
                Set-Content -Path $cacheFile -Value 'cached output' -Encoding UTF8
                [System.IO.File]::SetLastWriteTimeUtc($cacheFile, (Get-Date).AddMinutes(1))
                [System.IO.File]::SetLastWriteTimeUtc($scriptPath, (Get-Date))

                $script:CacheDir = $cacheRoot
                $script:CacheInitialized = $true

                $result = Get-CachedOutput -ScriptPath $scriptPath

                $result.Available | Should -BeTrue
                $result.Content.Trim() | Should -Be 'cached output'
            }
        }

        It "handles cache read errors gracefully" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $cacheRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null

                $scriptPath = Join-Path -Path $testDrive -ChildPath 'locked-script.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'hello'" -Encoding UTF8

                $cacheFile = Join-Path -Path $cacheRoot -ChildPath 'locked-script.cache'
                Set-Content -Path $cacheFile -Value 'locked cache' -Encoding UTF8
                [System.IO.File]::SetLastWriteTimeUtc($cacheFile, (Get-Date).AddMinutes(1))
                [System.IO.File]::SetLastWriteTimeUtc($scriptPath, (Get-Date))

                $script:CacheDir = $cacheRoot
                $script:CacheInitialized = $true

                $stream = [System.IO.File]::Open($cacheFile, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
                try {
                    $result = Get-CachedOutput -ScriptPath $scriptPath
                }
                finally {
                    $stream.Dispose()
                }

                $result.Available | Should -BeFalse
                $result.CacheFile | Should -Be $cacheFile
                $result.Content | Should -Be ''
            }
        }
    }

    Context "Initialize-CacheDirectory" {
        It "uses environment override when resolvable" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Initialize-Configuration -ModuleName ColorScripts-Enhanced

                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $override = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())

                Set-Item -Path Env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -Value $override

                $script:CacheDir = $null
                $script:CacheInitialized = $false

                Initialize-CacheDirectory

                $resolvedOverride = (Resolve-Path -LiteralPath $override -ErrorAction SilentlyContinue)
                $resolvedOverride | Should -Not -BeNullOrEmpty
                $script:CacheDir | Should -Be $resolvedOverride.ProviderPath
                Test-Path -LiteralPath $script:CacheDir | Should -BeTrue
            }
        }

        It "warns when configured cache path cannot be resolved" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Initialize-Configuration -ModuleName ColorScripts-Enhanced

                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $env:APPDATA = Join-Path -Path $testDrive -ChildPath 'AppData'
                New-Item -ItemType Directory -Path $env:APPDATA -Force | Out-Null

                $script:CacheDir = $null
                $script:CacheInitialized = $false
                $script:ConfigurationData = @{ Cache = @{ Path = 'ZZ:\invalid-path' } }

                Set-Variable -Name __capturedWarnings -Scope Script -Value @()
                Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Message)
                    $current = (Get-Variable -Name __capturedWarnings -Scope Script -ValueOnly)
                    Set-Variable -Name __capturedWarnings -Scope Script -Value ($current + $Message)
                }

                Initialize-CacheDirectory

                $warnings = Get-Variable -Name __capturedWarnings -Scope Script -ValueOnly
                $warnings | Should -Contain "Configured cache path 'ZZ:\invalid-path' could not be resolved. Falling back to default locations."
                $script:CacheDir | Should -Match 'ColorScripts-Enhanced'
                Test-Path -LiteralPath $script:CacheDir | Should -BeTrue

                Remove-Variable -Name __capturedWarnings -Scope Script -ErrorAction SilentlyContinue
            }
        }

        It "continues with next candidate when override creation fails" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Initialize-Configuration -ModuleName ColorScripts-Enhanced

                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $override = Join-Path -Path $testDrive -ChildPath 'override-cache'
                $configured = Join-Path -Path $testDrive -ChildPath 'configured-cache'

                Set-Item -Path Env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -Value $override
                $script:ConfigurationData = @{ Cache = @{ Path = $configured } }

                Set-Variable -Name newItemCalls -Scope Script -Value 0

                Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Path)
                    if ($Path -eq $override) {
                        return $override
                    }
                    elseif ($Path -eq $configured) {
                        return $configured
                    }

                    return $Path
                }

                Mock -CommandName New-Item -ModuleName ColorScripts-Enhanced -MockWith {
                    param([string]$Path, [string]$ItemType, [switch]$Force, [System.Management.Automation.ActionPreference]$ErrorAction)
                    [void]$Force
                    [void]$ErrorAction
                    $count = (Get-Variable -Name newItemCalls -Scope Script -ValueOnly)
                    $count++
                    Set-Variable -Name newItemCalls -Scope Script -Value $count

                    if ($count -eq 1) {
                        throw 'simulated failure'
                    }

                    if ($ItemType -eq 'Directory') {
                        [System.IO.Directory]::CreateDirectory($Path) | Out-Null
                        return
                    }

                    return [pscustomobject]@{ Path = $Path; ItemType = $ItemType }
                }

                Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced

                $script:CacheDir = $null
                $script:CacheInitialized = $false

                Initialize-CacheDirectory

                Assert-MockCalled -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -Times 1 -ParameterFilter { $Message -like "Unable to prepare cache directory*" }
                (Get-Variable -Name newItemCalls -Scope Script -ValueOnly) | Should -Be 2
                Test-Path -LiteralPath $script:CacheDir | Should -BeTrue
                $script:CacheDir | Should -Match ([Regex]::Escape('configured-cache'))

                Remove-Variable -Name newItemCalls -Scope Script -ErrorAction SilentlyContinue
            }
        }
    }

    Context "Build-ScriptCache" {
        BeforeEach {
            InModuleScope ColorScripts-Enhanced {
                $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                $script:CacheInitialized = $true
            }
        }

        It "returns failure when script path is missing" {
            InModuleScope ColorScripts-Enhanced {
                $missingPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'missing-script.ps1'

                $result = Build-ScriptCache -ScriptPath $missingPath

                $result.Success | Should -BeFalse
                $result.StdErr | Should -Be 'Script path not found.'
                $result.CacheFile | Should -Match ([Regex]::Escape('missing-script.cache'))
                Test-Path -LiteralPath $result.CacheFile | Should -BeFalse
            }
        }

        It "returns failure when invocation fails" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $scriptPath = Join-Path -Path $testDrive -ChildPath 'failing-script.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'noop'" -Encoding UTF8

                Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    param($ScriptPath)
                    [pscustomobject]@{
                        ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
                        StdOut     = ''
                        StdErr     = 'execution failed'
                        ExitCode   = 1
                        Success    = $false
                    }
                }

                $result = Build-ScriptCache -ScriptPath $scriptPath

                $result.Success | Should -BeFalse
                $result.StdErr | Should -Be 'execution failed'
                Test-Path -LiteralPath $result.CacheFile | Should -BeFalse
            }
        }

        It "writes cache when invocation succeeds" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $scriptPath = Join-Path -Path $testDrive -ChildPath 'successful-script.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'noop'" -Encoding UTF8

                $expectedOutput = "rendered text"
                $now = (Get-Date).AddMinutes(-5)
                [System.IO.File]::SetLastWriteTimeUtc($scriptPath, $now)

                Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    param($ScriptPath)
                    [pscustomobject]@{
                        ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
                        StdOut     = $expectedOutput
                        StdErr     = ''
                        ExitCode   = 0
                        Success    = $true
                    }
                }

                $result = Build-ScriptCache -ScriptPath $scriptPath

                $result.Success | Should -BeTrue
                $result.CacheFile | Should -Not -BeNullOrEmpty
                Test-Path -LiteralPath $result.CacheFile | Should -BeTrue
                (Get-Content -LiteralPath $result.CacheFile -Raw) | Should -Be $expectedOutput
                [System.IO.File]::GetLastWriteTimeUtc($result.CacheFile) | Should -Be ([System.IO.File]::GetLastWriteTimeUtc($scriptPath))
            }
        }

        It "populates stderr when exit code indicates failure" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $scriptPath = Join-Path -Path $testDrive -ChildPath 'exit-fail-script.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'noop'" -Encoding UTF8

                Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
                        StdOut     = ''
                        StdErr     = ''
                        ExitCode   = 99
                        Success    = $false
                    }
                }

                $result = Build-ScriptCache -ScriptPath $scriptPath

                $result.Success | Should -BeFalse
                $result.StdErr | Should -Be 'Script exited with code 99.'
            }
        }

        It "falls back to non-UTC timestamps when UTC updates fail" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $scriptPath = Join-Path -Path $testDrive -ChildPath 'utc-fallback-script.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'noop'" -Encoding UTF8

                Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    param($ScriptPath)
                    [pscustomobject]@{
                        ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
                        StdOut     = 'cache text'
                        StdErr     = ''
                        ExitCode   = 0
                        Success    = $true
                    }
                }

                Set-Variable -Name __fallbackTriggered -Scope Script -Value $false

                Mock -CommandName Get-FileLastWriteTimeUtc -ModuleName ColorScripts-Enhanced -MockWith { throw 'utc not available' }
                Mock -CommandName Set-FileLastWriteTimeUtc -ModuleName ColorScripts-Enhanced -MockWith { throw 'set utc failed' }
                Mock -CommandName Get-FileLastWriteTime -ModuleName ColorScripts-Enhanced -MockWith { (Get-Date).AddMinutes(-3) }
                Mock -CommandName Set-FileLastWriteTime -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Path, $Timestamp)
                    [void]$Path
                    [void]$Timestamp
                    Set-Variable -Name __fallbackTriggered -Scope Script -Value $true
                }

                $result = Build-ScriptCache -ScriptPath $scriptPath

                $result.Success | Should -BeTrue
                (Get-Variable -Name __fallbackTriggered -Scope Script -ValueOnly) | Should -BeTrue
                Remove-Variable -Name __fallbackTriggered -Scope Script -ErrorAction SilentlyContinue
            }
        }

        It "captures write failures as error messages" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $scriptPath = Join-Path -Path $testDrive -ChildPath 'write-error-script.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'noop'" -Encoding UTF8

                Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    param($ScriptPath)
                    [pscustomobject]@{
                        ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
                        StdOut     = 'content'
                        StdErr     = ''
                        ExitCode   = 0
                        Success    = $true
                    }
                }

                Mock -CommandName Invoke-FileWriteAllText -ModuleName ColorScripts-Enhanced -MockWith { throw ([System.ArgumentNullException]::new('encoding')) }

                $result = Build-ScriptCache -ScriptPath $scriptPath

                $result.Success | Should -BeFalse
                $result.StdErr | Should -Match 'encoding'
            }
        }
    }

    Context "New-ColorScriptCache" {
        BeforeEach {
            InModuleScope ColorScripts-Enhanced {
                $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                $script:CacheInitialized = $true
            }
        }

        It "throws when All is explicitly disabled without names" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    $list = [System.Collections.Generic.List[psobject]]::new()
                    , $list
                }

                Should -Throw -ActualValue { New-ColorScriptCache -All:$false } -ExpectedMessage 'Specify -Name to select scripts when -All is explicitly disabled.'
            }
        }
        It "shows help when requested" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced

                New-ColorScriptCache -h

                Assert-MockCalled -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced -Times 1 -ParameterFilter { $CommandName -eq 'New-ColorScriptCache' }
            }
        }

        It "returns empty result when no scripts are selected" {
            InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith {
                    $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                    New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                    $script:CacheInitialized = $true
                }
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith { @() }
                Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced

                $result = New-ColorScriptCache -Category 'None'

                $result | Should -BeNullOrEmpty
            }
        }

        It "normalizes enumerable results and filters null values" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith {
                    $script:CacheDir = Join-Path -Path $testDrive -ChildPath 'cache-enumeration'
                    New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                    $script:CacheInitialized = $true
                }

                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    $list = [System.Collections.ArrayList]::new()
                    $null = $list.Add($null)
                    $null = $list.Add([pscustomobject]@{ Name = 'enum-test'; Path = Join-Path $testDrive 'enum-test.ps1' })
                    , $list
                }
                Set-Content -Path (Join-Path $testDrive 'enum-test.ps1') -Value "Write-Host 'test'" -Encoding UTF8
                Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        CacheFile = Join-Path $script:CacheDir 'enum-test.cache'
                        ExitCode  = 0
                        StdOut    = 'cached'
                        StdErr    = ''
                        Success   = $true
                    }
                }
                Mock -CommandName Write-Progress -ModuleName ColorScripts-Enhanced

                $result = New-ColorScriptCache -PassThru

                $result | Should -HaveCount 1
                $result[0].Name | Should -Be 'enum-test'
            }
        }

        It "wraps single record into array when necessary" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith {
                    $script:CacheDir = Join-Path -Path $testDrive -ChildPath 'cache-single'
                    New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                    $script:CacheInitialized = $true
                }
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{ Name = 'single-test'; Path = Join-Path $testDrive 'single-test.ps1' }
                }
                Set-Content -Path (Join-Path $testDrive 'single-test.ps1') -Value "Write-Host 'test'" -Encoding UTF8
                Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        CacheFile = Join-Path $script:CacheDir 'single-test.cache'
                        ExitCode  = 0
                        StdOut    = 'output'
                        StdErr    = ''
                        Success   = $true
                    }
                }
                Mock -CommandName Write-Progress -ModuleName ColorScripts-Enhanced

                $result = New-ColorScriptCache -PassThru

                $result | Should -HaveCount 1
                $result[0].Status | Should -Be 'Updated'
            }
        }

        It "warns when named scripts are not found" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith {
                    param()
                    $script:CacheDir = Join-Path -Path $testDrive -ChildPath 'cacheMissing'
                    New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                    $script:CacheInitialized = $true
                }

                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    $list = [System.Collections.Generic.List[psobject]]::new()
                    , $list
                }
                Set-Variable -Name __missingWarnings -Scope Script -Value @()
                Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Message)
                    $current = (Get-Variable -Name __missingWarnings -Scope Script -ValueOnly)
                    Set-Variable -Name __missingWarnings -Scope Script -Value ($current + $Message)
                }

                New-ColorScriptCache -Name 'ghost-script'

                $warnings = Get-Variable -Name __missingWarnings -Scope Script -ValueOnly
                $warnings | Should -Contain "Script not found: ghost-script"
                Remove-Variable -Name __missingWarnings -Scope Script -ErrorAction SilentlyContinue
            }
        }

        It "skips cache builds when entries are up-to-date" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $scriptPath = Join-Path -Path $testDrive -ChildPath 'beta.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'beta'" -Encoding UTF8

                $cachePath = Join-Path -Path $script:CacheDir -ChildPath 'beta.cache'
                Set-Content -Path $cachePath -Value 'cached' -Encoding UTF8
                $stamp = (Get-Date)
                [System.IO.File]::SetLastWriteTimeUtc($scriptPath, $stamp)
                [System.IO.File]::SetLastWriteTimeUtc($cachePath, $stamp.AddMinutes(1))

                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith {
                    param()
                    $script:CacheInitialized = $true
                }
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    $list = [System.Collections.Generic.List[psobject]]::new()
                    $null = $list.Add([pscustomobject]@{ Name = 'beta'; Path = $scriptPath })
                    , $list
                }
                Mock -CommandName Write-Progress -ModuleName ColorScripts-Enhanced

                $result = New-ColorScriptCache -Name 'beta' -PassThru

                $result | Should -HaveCount 1
                $result[0].Status | Should -Be 'SkippedUpToDate'
                $result[0].CacheFile | Should -Be $cachePath
            }
        }

        It "returns empty result when ShouldProcess declines" {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $scriptPath = Join-Path -Path $testDrive -ChildPath 'decline.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'decline'" -Encoding UTF8
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith {
                    param()
                    $script:CacheInitialized = $true
                    $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                    New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                }

                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    @([pscustomobject]@{ Name = 'decline'; Path = $scriptPath })
                }

                Mock -CommandName Write-Progress -ModuleName ColorScripts-Enhanced

                $result = New-ColorScriptCache -All -WhatIf

                $result | Should -BeNullOrEmpty
            }
        }

        It "summarizes outcomes with status colors and failure details" -Skip {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath

                $skipScript = Join-Path -Path $testDrive -ChildPath 'skip.ps1'
                Set-Content -Path $skipScript -Value "Write-Host 'skip'" -Encoding UTF8
                $skipCache = Join-Path -Path $script:CacheDir -ChildPath 'skip.cache'
                Set-Content -Path $skipCache -Value 'old cache' -Encoding UTF8
                $now = Get-Date
                [System.IO.File]::SetLastWriteTimeUtc($skipScript, $now)
                [System.IO.File]::SetLastWriteTimeUtc($skipCache, $now.AddMinutes(5))

                $freshScript = Join-Path -Path $testDrive -ChildPath 'fresh.ps1'
                Set-Content -Path $freshScript -Value "Write-Host 'fresh'" -Encoding UTF8

                $brokenScript = Join-Path -Path $testDrive -ChildPath 'broken.ps1'
                Set-Content -Path $brokenScript -Value "Write-Host 'broken'" -Encoding UTF8

                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    @(
                        [pscustomobject]@{ Name = 'skip'; Path = $skipScript },
                        [pscustomobject]@{ Name = 'fresh'; Path = $freshScript },
                        [pscustomobject]@{ Name = 'broken'; Path = $brokenScript }
                    )
                }

                Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                    param($ScriptPath)
                    $name = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
                    switch ($name) {
                        'fresh' {
                            return [pscustomobject]@{
                                CacheFile = Join-Path $script:CacheDir 'fresh.cache'
                                ExitCode  = 0
                                StdOut    = 'fresh output'
                                StdErr    = ''
                                Success   = $true
                            }
                        }
                        'broken' {
                            return [pscustomobject]@{
                                CacheFile = Join-Path $script:CacheDir 'broken.cache'
                                ExitCode  = 1
                                StdOut    = ''
                                StdErr    = 'boom'
                                Success   = $false
                            }
                        }
                        default {
                            return [pscustomobject]@{
                                CacheFile = Join-Path $script:CacheDir "$name.cache"
                                ExitCode  = 0
                                StdOut    = 'noop'
                                StdErr    = ''
                                Success   = $true
                            }
                        }
                    }
                }

                Mock -CommandName Group-Object -ModuleName ColorScripts-Enhanced -MockWith {
                    @(
                        [pscustomobject]@{ Name = 'Updated'; Count = 1 },
                        [pscustomobject]@{ Name = 'SkippedUpToDate'; Count = 1 },
                        [pscustomobject]@{ Name = 'Failed'; Count = 1 },
                        [pscustomobject]@{ Name = 'SkippedByUser'; Count = 1 },
                        [pscustomobject]@{ Name = 'OtherStatus'; Count = 1 }
                    )
                } -ParameterFilter { $Property -eq 'Status' }

                Set-Variable -Name __summaryMessages -Scope Script -Value @()
                Mock -CommandName Write-Host -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Object, [System.ConsoleColor]$ForegroundColor)
                    [void]$ForegroundColor
                    $current = (Get-Variable -Name __summaryMessages -Scope Script -ValueOnly)
                    Set-Variable -Name __summaryMessages -Scope Script -Value ($current + [string]$Object)
                }

                Mock -CommandName Write-Progress -ModuleName ColorScripts-Enhanced

                New-ColorScriptCache -Name @('skip', 'fresh', 'broken')

                $messages = Get-Variable -Name __summaryMessages -Scope Script -ValueOnly
                ($messages | Where-Object { $_ -like '*Cache Build Summary*' }) | Should -Not -BeNullOrEmpty
                ($messages | Where-Object { $_ -like '*Failed scripts*' }) | Should -Not -BeNullOrEmpty
                $messages | Should -Contain '  Up-to-date (skipped)      1'
                $messages | Should -Contain '  Skipped by user           1'
                ($messages | Where-Object { $_ -like '*Total scripts processed: 3*' }) | Should -Not -BeNullOrEmpty
                Remove-Variable -Name __summaryMessages -Scope Script -ErrorAction SilentlyContinue
            }
        }

        It "captures failures from Build-ScriptCache" -Skip {
            InModuleScope ColorScripts-Enhanced {
                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $scriptPath = Join-Path -Path $testDrive -ChildPath 'gamma.ps1'
                Set-Content -Path $scriptPath -Value "Write-Host 'gamma'" -Encoding UTF8

                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith {
                    param()
                    $script:CacheInitialized = $true
                }
                Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                    $list = [System.Collections.Generic.List[psobject]]::new()
                    $null = $list.Add([pscustomobject]@{ Name = 'gamma'; Path = $scriptPath })
                    , $list
                }
                Mock -CommandName Write-Progress -ModuleName ColorScripts-Enhanced
                Mock -CommandName Write-Host -ModuleName ColorScripts-Enhanced

                Set-Variable -Name __failureWarnings -Scope Script -Value @()
                Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Message)
                    $current = (Get-Variable -Name __failureWarnings -Scope Script -ValueOnly)
                    Set-Variable -Name __failureWarnings -Scope Script -Value ($current + $Message)
                }

                Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        CacheFile = Join-Path $script:CacheDir 'gamma.cache'
                        ExitCode  = 1
                        StdOut    = ''
                        StdErr    = 'permission denied'
                        Success   = $false
                    }
                }

                $result = New-ColorScriptCache -Name 'gamma' -PassThru

                $result | Should -HaveCount 1
                $result[0].Status | Should -Be 'Failed'
                $result[0].StdErr | Should -Be 'permission denied'
                (Get-Variable -Name __failureWarnings -Scope Script -ValueOnly) | Should -Contain "Failed to cache gamma: permission denied"
                Remove-Variable -Name __failureWarnings -Scope Script -ErrorAction SilentlyContinue
            }
        }

        Context "New-ColorScript" {
            It "shows help when requested" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced

                    New-ColorScript -Name 'demo' -h

                    Assert-MockCalled -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced -Times 1 -ParameterFilter { $CommandName -eq 'New-ColorScript' }
                }
            }

            It "throws when output path cannot be resolved" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith { $null }
                }

                $errorRecord = $null
                try {
                    New-ColorScript -Name 'invalid' -OutputPath '::invalid::'
                }
                catch {
                    $errorRecord = $_
                }

                $errorRecord | Should -Not -BeNullOrEmpty
                $errorRecord.Exception.Message | Should -Be "Unable to resolve output path '::invalid::'."
            }

            It "throws when script exists without force" {
                $targetDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                $existingPath = Join-Path -Path $targetDir -ChildPath 'duplicate.ps1'
                Set-Content -LiteralPath $existingPath -Value "Write-Host 'existing'" -Encoding UTF8

                { New-ColorScript -Name 'duplicate' -OutputPath $targetDir } | Should -Throw -ErrorId '*'
            }

            It "generates metadata snippet with default values" {
                $targetDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                Mock -CommandName Reset-ScriptInventoryCache -ModuleName ColorScripts-Enhanced

                $result = New-ColorScript -Name 'snippet' -OutputPath $targetDir

                Test-Path -LiteralPath (Join-Path -Path $targetDir -ChildPath 'snippet.ps1') | Should -BeTrue
            }

            It "supplies default metadata snippet values when tags are omitted" {
                $targetDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                Mock -CommandName Reset-ScriptInventoryCache -ModuleName ColorScripts-Enhanced

                $result = New-ColorScript -Name 'guidance' -OutputPath $targetDir -GenerateMetadataSnippet

                $result.MetadataGuidance | Should -Match "Tags:"
                $result.MetadataGuidance | Should -Match "'Custom'"
            }
        }

        Context "Clear-ColorScriptCache" {
            BeforeEach {
                InModuleScope ColorScripts-Enhanced {
                    $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                    New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                    $script:CacheInitialized = $true
                }
            }

            It "throws when no selection is provided" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }

                    Should -Throw -ActualValue { Clear-ColorScriptCache } -ExpectedMessage 'Specify -All or -Name to clear cache entries.'
                }
            }

            It "warns when cache path cannot be resolved" {
                InModuleScope ColorScripts-Enhanced {
                    $script:CapturedWarnings = [System.Collections.Generic.List[string]]::new()
                    Mock -CommandName Write-Warning -MockWith {
                        param($Message)
                        $null = $script:CapturedWarnings.Add($Message)
                    }
                }

                $result = Clear-ColorScriptCache -All -Path 'Z:\nonexistent'

                $result | Should -BeNullOrEmpty

                $capturedWarnings = InModuleScope ColorScripts-Enhanced { $script:CapturedWarnings }
                $capturedWarnings | Should -Contain "Cache path not found: Z:\nonexistent"
                InModuleScope ColorScripts-Enhanced { Remove-Variable -Name CapturedWarnings -Scope Script -ErrorAction SilentlyContinue }
            }

            It "returns missing status for absent cache files" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }

                    $result = Clear-ColorScriptCache -Name 'ghost-script'

                    $result | Should -HaveCount 1
                    $result[0].Status | Should -Be 'Missing'
                    $result[0].Message | Should -Be 'Cache file not found.'
                }
            }

            It "performs dry run without deleting files" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }

                    $cachePath = Join-Path -Path $script:CacheDir -ChildPath 'alpha.cache'
                    Set-Content -Path $cachePath -Value 'cached output' -Encoding UTF8

                    $result = Clear-ColorScriptCache -Name 'alpha' -DryRun

                    Test-Path -LiteralPath $cachePath | Should -BeTrue
                    $result | Should -HaveCount 1
                    $result[0].Status | Should -Be 'DryRun'
                    $result[0].Message | Should -Be 'No changes applied.'
                }
            }

            It "removes cache files when requested" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }

                    $cachePath = Join-Path -Path $script:CacheDir -ChildPath 'beta.cache'
                    Set-Content -Path $cachePath -Value 'cached output' -Encoding UTF8

                    $result = Clear-ColorScriptCache -Name 'beta'

                    Test-Path -LiteralPath $cachePath | Should -BeFalse
                    $result | Should -HaveCount 1
                    $result[0].Status | Should -Be 'Removed'
                    $result[0].Message | Should -Be ''
                }
            }

            It "warns when no cache files exist for -All" {
                $emptyDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $emptyDir -Force | Out-Null

                InModuleScope ColorScripts-Enhanced {
                    $script:CapturedWarnings = [System.Collections.Generic.List[string]]::new()
                    Mock -CommandName Write-Warning -MockWith {
                        param($Message)
                        $null = $script:CapturedWarnings.Add($Message)
                    }
                }

                $result = Clear-ColorScriptCache -All -Path $emptyDir

                $result | Should -BeNullOrEmpty
                $resolvedDir = (Resolve-Path -LiteralPath $emptyDir).ProviderPath

                $capturedWarnings = InModuleScope ColorScripts-Enhanced { $script:CapturedWarnings }
                $capturedWarnings | Should -Contain "No cache files found at $resolvedDir."
                InModuleScope ColorScripts-Enhanced { Remove-Variable -Name CapturedWarnings -Scope Script -ErrorAction SilentlyContinue }
            }

            It "reports missing when cache record lacks a file" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }
                    Mock -CommandName Get-ChildItem -ModuleName ColorScripts-Enhanced -MockWith {
                        @([pscustomobject]@{ BaseName = 'orphan'; FullName = Join-Path $script:CacheDir 'orphan.cache'; Extension = '.cache' })
                    }

                    $result = Clear-ColorScriptCache -Name 'orphan'

                    $result | Should -HaveCount 1
                    $result[0].Status | Should -Be 'Missing'
                    $result[0].CacheFile | Should -Match 'orphan.cache'
                }
            }

            It "performs dry run for all cache files" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }

                    $cacheA = Join-Path -Path $script:CacheDir -ChildPath 'runA.cache'
                    $cacheB = Join-Path -Path $script:CacheDir -ChildPath 'runB.cache'
                    Set-Content -LiteralPath $cacheA -Value 'cacheA' -Encoding UTF8
                    Set-Content -LiteralPath $cacheB -Value 'cacheB' -Encoding UTF8

                    $result = Clear-ColorScriptCache -All -DryRun

                    $result | Should -HaveCount 2
                    $result.Status | Sort-Object -Unique | Should -Be @('DryRun')
                    Test-Path -LiteralPath $cacheA | Should -BeTrue
                    Test-Path -LiteralPath $cacheB | Should -BeTrue
                }
            }

            It "captures errors when removal fails" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }

                    $cachePath = Join-Path -Path $script:CacheDir -ChildPath 'error.cache'
                    Set-Content -LiteralPath $cachePath -Value 'error' -Encoding UTF8

                    Mock -CommandName Remove-Item -ModuleName ColorScripts-Enhanced -MockWith {
                        throw [System.IO.IOException]::new('cannot delete')
                    }

                    $result = Clear-ColorScriptCache -Name 'error'

                    $result | Should -HaveCount 1
                    $result[0].Status | Should -Be 'Error'
                    $result[0].Message | Should -Match 'cannot delete'
                }
            }

            It "applies filters and warns for unmatched names" {
                InModuleScope ColorScripts-Enhanced {
                    $script:CapturedWarnings = [System.Collections.Generic.List[string]]::new()

                    Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }
                    Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                        @([pscustomobject]@{ Name = 'keep'; Path = 'keep.ps1' })
                    }
                    Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Message)
                        $null = $script:CapturedWarnings.Add($Message)
                    }
                }

                $result = Clear-ColorScriptCache -Name 'keep', 'drop' -Category 'demo'

                $result.Name | Should -Contain 'keep'
                $result.Name | Should -Not -Contain 'drop'

                $warnings = InModuleScope ColorScripts-Enhanced { $script:CapturedWarnings }
                ($warnings | Where-Object { $_ -like "Script '*drop*will be skipped." }) | Should -Not -BeNullOrEmpty
                InModuleScope ColorScripts-Enhanced { Remove-Variable -Name CapturedWarnings -Scope Script -ErrorAction SilentlyContinue }
            }

            It "marks entries as skipped when ShouldProcess declines" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }

                    $cachePath = Join-Path -Path $script:CacheDir -ChildPath 'skipped.cache'
                    Set-Content -Path $cachePath -Value 'cached' -Encoding UTF8

                    $result = Clear-ColorScriptCache -Name 'skipped' -WhatIf

                    $result | Should -HaveCount 1
                    $result[0].Status | Should -Be 'SkippedByUser'
                }
            }

            It "returns empty array when clearing all and ShouldProcess declines" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { $script:CacheInitialized = $true }

                    $cachePath = Join-Path -Path $script:CacheDir -ChildPath 'all.cache'
                    Set-Content -Path $cachePath -Value 'cached' -Encoding UTF8
                }

                $result = Clear-ColorScriptCache -All -WhatIf

                $result | Should -BeNullOrEmpty
                $cacheRoot = InModuleScope ColorScripts-Enhanced { $script:CacheDir }
                Test-Path -LiteralPath (Join-Path -Path $cacheRoot -ChildPath 'all.cache') | Should -BeTrue
            }
        }

        Context "Configuration helpers" {
            It "does not rewrite when configuration is unchanged" {
                InModuleScope ColorScripts-Enhanced {
                    $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                    $configRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                    New-Item -ItemType Directory -Path $configRoot -Force | Out-Null

                    Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $configRoot }

                    $configuration = @{ Cache = @{ Path = 'relative-cache' }; Startup = @{ AutoShowOnImport = $true } }
                    $existing = $configuration | ConvertTo-Json -Depth 6

                    Save-ColorScriptConfiguration -Configuration $configuration -ExistingContent $existing

                    $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'
                    Test-Path -LiteralPath $configPath | Should -BeFalse
                }
            }

            It "writes configuration when existing content is unreadable" {
                InModuleScope ColorScripts-Enhanced {
                    $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                    $configRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                    New-Item -ItemType Directory -Path $configRoot -Force | Out-Null
                    $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'
                    Set-Content -Path $configPath -Value '{"Cache":{"Path":"stale"}}' -Encoding UTF8

                    Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $configRoot }
                    Mock -CommandName Get-Content -ModuleName ColorScripts-Enhanced -MockWith { throw 'simulated read failure' }

                    $configuration = @{ Cache = @{ Path = 'updated-cache' }; Startup = @{ AutoShowOnImport = $false } }

                    Save-ColorScriptConfiguration -Configuration $configuration

                    $raw = [System.IO.File]::ReadAllText($configPath)
                    $raw | Should -Match 'updated-cache'
                }
            }

            It "initializes configuration when file contains whitespace" {
                InModuleScope ColorScripts-Enhanced {
                    $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                    $configRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                    New-Item -ItemType Directory -Path $configRoot -Force | Out-Null
                    $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'
                    Set-Content -Path $configPath -Value "`r`n" -Encoding UTF8

                    Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $configRoot }

                    $script:ConfigurationInitialized = $false
                    $script:ConfigurationData = $null

                    Initialize-Configuration

                    $script:ConfigurationInitialized | Should -BeTrue
                    $script:ConfigurationData | Should -Not -BeNullOrEmpty
                }
            }

            It "throws when cache path cannot be resolved" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith {
                        $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                        $configRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                        New-Item -ItemType Directory -Path $configRoot -Force | Out-Null
                        return $configRoot
                    }
                    Mock -CommandName Get-ConfigurationDataInternal -ModuleName ColorScripts-Enhanced -MockWith {
                        @{ Startup = @{ AutoShowOnImport = $false }; Cache = @{ Path = $null } }
                    }
                    Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith { $null }

                    Should -Throw -ActualValue { Set-ColorScriptConfiguration -CachePath '::invalid::' } -ExpectedMessage "Unable to resolve cache path*"
                }
            }
        }

        Context "Add-ColorScriptProfile" {
            BeforeEach {
                InModuleScope ColorScripts-Enhanced {
                    $script:ConfigurationData = @{ Startup = @{ AutoShowOnImport = $true; ProfileAutoShow = $true; DefaultScript = 'bars' }; Cache = @{ Path = $null } }
                }
            }

            It "shows help when requested" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced

                    Add-ColorScriptProfile -h

                    Assert-MockCalled -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced -Times 1 -ParameterFilter { $CommandName -eq 'Add-ColorScriptProfile' }
                }
            }

            It "returns remote session response when PSSenderInfo exists" {
                Set-Variable -Name PSSenderInfo -Scope Global -Value ([pscustomobject]@{ ApplicationArguments = 'RemoteSession' }) -Force
                try {
                    $result = Add-ColorScriptProfile -Confirm:$false

                    $result.Path | Should -Be $null
                    $result.Changed | Should -BeFalse
                    $result.Message | Should -Match 'Remote session'
                }
                finally {
                    Remove-Variable -Name PSSenderInfo -Scope Global -ErrorAction SilentlyContinue
                }
            }

            It "continues when configuration retrieval fails" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Get-ColorScriptConfiguration -ModuleName ColorScripts-Enhanced -MockWith { throw 'config failure' }

                    $profileRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                    New-Item -ItemType Directory -Path $profileRoot -Force | Out-Null
                    $profilePath = Join-Path -Path $profileRoot -ChildPath 'profile.ps1'

                    Set-Variable -Name PROFILE -Scope Global -Value ([pscustomobject]@{ CurrentUserAllHosts = $profilePath }) -Force

                    Add-ColorScriptProfile -Confirm:$false -Verbose

                    Test-Path -LiteralPath $profilePath | Should -BeTrue
                    (Get-Content -LiteralPath $profilePath -Raw) | Should -Match 'Import-Module ColorScripts-Enhanced'
                }
            }

            It "throws when explicit path cannot be resolved" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Path)
                        [void]$Path
                        $null
                    }

                    Should -Throw -ActualValue { Add-ColorScriptProfile -Path 'X:\missing\profile.ps1' -Confirm:$false } -ExpectedMessage "Unable to resolve profile path 'X:\missing\profile.ps1'."
                }
            }

            It "throws when profile scope path is undefined" {
                InModuleScope ColorScripts-Enhanced {
                    Set-Variable -Name PROFILE -Scope Global -Value ([pscustomobject]@{ CurrentUserAllHosts = '' }) -Force

                    Should -Throw -ActualValue { Add-ColorScriptProfile -Confirm:$false } -ExpectedMessage "Profile path for scope 'CurrentUserAllHosts' is not defined."
                }
            }

            It "uses current location for relative profile paths" {
                InModuleScope ColorScripts-Enhanced {
                    $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                    Push-Location $testDrive
                    try {
                        Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                            param($Path)
                            [void]$Path
                            $null
                        }

                        Set-Variable -Name PROFILE -Scope Global -Value ([pscustomobject]@{ CurrentUserAllHosts = 'profiles\profile.ps1' }) -Force

                        Add-ColorScriptProfile -Confirm:$false

                        $resolved = Join-Path -Path $testDrive -ChildPath 'profiles\profile.ps1'
                        Test-Path -LiteralPath $resolved | Should -BeTrue
                    }
                    finally {
                        Pop-Location
                    }
                }
            }

            It "skips adding snippet when already present" {
                InModuleScope ColorScripts-Enhanced {
                    $profileRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                    New-Item -ItemType Directory -Path $profileRoot -Force | Out-Null
                    $profilePath = Join-Path -Path $profileRoot -ChildPath 'profile.ps1'

                    $existing = "# Added by ColorScripts-Enhanced on 2024-01-01`r`nImport-Module ColorScripts-Enhanced`r`nShow-ColorScript`r`n"
                    Set-Content -Path $profilePath -Value $existing -Encoding UTF8

                    Set-Variable -Name PROFILE -Scope Global -Value ([pscustomobject]@{ CurrentUserAllHosts = $profilePath }) -Force

                    $result = Add-ColorScriptProfile -Confirm:$false

                    $result.Changed | Should -BeFalse
                    $result.Message | Should -Match 'already configured'
                }
            }

            It "forces update to replace existing snippet" {
                InModuleScope ColorScripts-Enhanced {
                    $profileRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                    New-Item -ItemType Directory -Path $profileRoot -Force | Out-Null
                    $profilePath = Join-Path -Path $profileRoot -ChildPath 'profile.ps1'

                    $existing = @(
                        '# Added by ColorScripts-Enhanced on 2024-01-01',
                        'Import-Module ColorScripts-Enhanced',
                        'Show-ColorScript',
                        ''
                    ) -join "`n"
                    Set-Content -Path $profilePath -Value $existing -Encoding UTF8

                    Set-Variable -Name PROFILE -Scope Global -Value ([pscustomobject]@{ CurrentUserAllHosts = $profilePath }) -Force

                    $result = Add-ColorScriptProfile -Force -Confirm:$false

                    $result.Changed | Should -BeTrue
                    $content = Get-Content -LiteralPath $profilePath -Raw
                    ($content -split "`r?`n") | Where-Object { $_ -match 'Show-ColorScript' } | Should -HaveCount 1
                }
            }

            It "preserves newline style and escapes default script name" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Get-ColorScriptConfiguration -ModuleName ColorScripts-Enhanced -MockWith {
                        @{ Startup = @{ AutoShowOnImport = $true; ProfileAutoShow = $true; DefaultScript = "d'angelo" } }
                    }

                    $profileRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                    New-Item -ItemType Directory -Path $profileRoot -Force | Out-Null
                    $profilePath = Join-Path -Path $profileRoot -ChildPath 'profile.ps1'

                    [System.IO.File]::WriteAllText($profilePath, "Write-Host 'Existing content'`n", [System.Text.Encoding]::UTF8)

                    Set-Variable -Name PROFILE -Scope Global -Value ([pscustomobject]@{ CurrentUserAllHosts = $profilePath }) -Force

                    $result = Add-ColorScriptProfile -Confirm:$false

                    $result.Changed | Should -BeTrue
                    $content = Get-Content -LiteralPath $profilePath -Raw
                    $content | Should -Match "Show-ColorScript -Name 'd''angelo'"
                    $content | Should -Match "Write-Host 'Existing content'`n`n# Added by ColorScripts-Enhanced"
                    $content | Should -Not -Match "`r`n"
                }
            }
        }

        Context "Get-ColorScriptEntry" {
            BeforeEach {
                InModuleScope ColorScripts-Enhanced {
                    $script:ScriptInventoryInitialized = $true
                    $stamp = [System.IO.Directory]::GetLastWriteTimeUtc($script:ScriptsPath)
                    if ($stamp -eq [datetime]::MinValue) {
                        $stamp = Get-Date
                    }
                    $script:ScriptInventoryStamp = $stamp
                    $script:ScriptInventory = @(
                        [pscustomobject]@{ BaseName = 'nebula'; FullName = 'nebula.ps1' },
                        [pscustomobject]@{ BaseName = 'aurora'; FullName = 'aurora.ps1' }
                    )
                    $script:ScriptInventoryRecords = $null
                }
            }

            It "assigns default metadata when none exists" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Get-ColorScriptMetadataTable -ModuleName ColorScripts-Enhanced -MockWith { @{} }

                    $entries = Get-ColorScriptEntry

                    $entries | Should -HaveCount 2
                    foreach ($entry in $entries) {
                        $entry.Category | Should -Be 'Abstract'
                        $entry.Categories | Should -Contain 'Abstract'
                        $entry.Tags | Should -Contain 'Category:Abstract'
                    }
                }
            }

            It "filters by category and tag when metadata is present" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Get-ColorScriptMetadataTable -ModuleName ColorScripts-Enhanced -MockWith {
                        @{
                            nebula = [pscustomobject]@{
                                Category    = 'Nature'
                                Categories  = @('Nature', 'Space')
                                Tags        = @('Category:Nature', 'Category:Space', 'Featured')
                                Description = 'A cosmic script'
                            }
                            aurora = [pscustomobject]@{
                                Category    = 'Nature'
                                Categories  = @('Nature')
                                Tags        = @('Category:Nature', 'Lights')
                                Description = 'Aurora display'
                            }
                        }
                    }

                    $entries = Get-ColorScriptEntry -Category 'space' -Tag 'featured'

                    $entries | Should -HaveCount 1
                    $entries[0].Name | Should -Be 'nebula'
                    $entries[0].Description | Should -Be 'A cosmic script'
                    $entries[0].Tags | Should -Contain 'Category:Space'
                }
            }

            It "applies name selection with wildcard patterns" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Get-ColorScriptMetadataTable -ModuleName ColorScripts-Enhanced -MockWith {
                        @{
                            nebula = [pscustomobject]@{ Category = 'Nature'; Categories = @('Nature'); Tags = @('Category:Nature') }
                            aurora = [pscustomobject]@{ Category = 'Nature'; Categories = @('Nature'); Tags = @('Category:Nature') }
                        }
                    }

                    $entries = Get-ColorScriptEntry -Name 'neb*'

                    $entries | Should -HaveCount 1
                    $entries[0].Name | Should -Be 'nebula'
                }
            }
        }

        Context "Get-ColorScriptInventory" {
            BeforeEach {
                InModuleScope ColorScripts-Enhanced {
                    $script:ScriptsPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                    New-Item -ItemType Directory -Path $script:ScriptsPath -Force | Out-Null
                    $script:ScriptInventoryInitialized = $false
                    $script:ScriptInventory = $null
                    $script:ScriptInventoryRecords = $null
                    $script:ScriptInventoryStamp = $null
                }
            }

            It "builds and caches inventory from script files" {
                InModuleScope ColorScripts-Enhanced {
                    $scriptPath = Join-Path -Path $script:ScriptsPath -ChildPath 'sample.ps1'
                    Set-Content -Path $scriptPath -Value "Write-Host 'hi'" -Encoding UTF8

                    $records = Get-ColorScriptInventory

                    $records | Should -HaveCount 1
                    $records[0].Name | Should -Be 'sample'
                    $records[0].Path | Should -Be $scriptPath
                    $script:ScriptInventoryInitialized | Should -BeTrue
                    $script:ScriptInventoryRecords | Should -Not -BeNullOrEmpty

                    $cached = Get-ColorScriptInventory
                    $cached | Should -HaveCount 1
                }
            }

            It "returns empty inventory when scripts directory is missing" {
                InModuleScope ColorScripts-Enhanced {
                    $script:ScriptsPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([guid]::NewGuid().ToString())

                    $records = Get-ColorScriptInventory

                    Should -BeNullOrEmpty -ActualValue $records
                    $script:ScriptInventoryInitialized | Should -BeTrue
                    Should -BeNullOrEmpty -ActualValue $script:ScriptInventory
                }
            }

            It "reconstructs records cache when needed" {
                InModuleScope ColorScripts-Enhanced {
                    $scriptPath = Join-Path -Path $script:ScriptsPath -ChildPath 'alpha.ps1'
                    Set-Content -Path $scriptPath -Value "Write-Host 'alpha'" -Encoding UTF8

                    $null = Get-ColorScriptInventory
                    $script:ScriptInventoryRecords = $null

                    $records = Get-ColorScriptInventory

                    $records | Should -HaveCount 1
                    $records[0].Name | Should -Be 'alpha'
                    $records[0].Path | Should -Be $scriptPath
                }
            }

            It "refreshes inventory when directory timestamp changes" {
                InModuleScope ColorScripts-Enhanced {
                    $initialScript = Join-Path -Path $script:ScriptsPath -ChildPath 'first.ps1'
                    Set-Content -Path $initialScript -Value "Write-Host 'first'" -Encoding UTF8

                    $null = Get-ColorScriptInventory
                    $previousStamp = $script:ScriptInventoryStamp

                    Start-Sleep -Milliseconds 50
                    $newScript = Join-Path -Path $script:ScriptsPath -ChildPath 'second.ps1'
                    Set-Content -Path $newScript -Value "Write-Host 'second'" -Encoding UTF8

                    $script:ScriptInventoryInitialized = $true
                    $script:ScriptInventoryStamp = $previousStamp

                    $records = Get-ColorScriptInventory

                    $records | Should -HaveCount 2
                    ($records | Where-Object Name -EQ 'second') | Should -Not -BeNullOrEmpty
                }
            }

            It "clears cached records when directory changes" {
                InModuleScope ColorScripts-Enhanced {
                    $scriptPath = Join-Path -Path $script:ScriptsPath -ChildPath 'gamma.ps1'
                    Set-Content -Path $scriptPath -Value "Write-Host 'gamma'" -Encoding UTF8

                    $initial = Get-ColorScriptInventory
                    $initial | Should -HaveCount 1

                    Remove-Item -LiteralPath $scriptPath -Force
                    $script:ScriptInventoryInitialized = $true

                    $refreshed = Get-ColorScriptInventory
                    $refreshed | Should -HaveCount 0
                }
            }
        }

        Context "Reset-ScriptInventoryCache" {
            It "clears script inventory state" {
                InModuleScope ColorScripts-Enhanced {
                    $script:ScriptInventory = @('item')
                    $script:ScriptInventoryStamp = Get-Date
                    $script:ScriptInventoryInitialized = $true
                    $script:ScriptInventoryRecords = @('record')

                    Reset-ScriptInventoryCache

                    $script:ScriptInventory | Should -BeNullOrEmpty
                    $script:ScriptInventoryStamp | Should -BeNullOrEmpty
                    $script:ScriptInventoryInitialized | Should -BeFalse
                    $script:ScriptInventoryRecords | Should -BeNullOrEmpty
                }
            }
        }

        Context "Helper wrappers" {
            It "updates file last write time using wrappers" {
                InModuleScope ColorScripts-Enhanced {
                    $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                    $filePath = Join-Path -Path $testRoot -ChildPath ("{0}.txt" -f [guid]::NewGuid())
                    Set-Content -LiteralPath $filePath -Value 'timestamps' -Encoding UTF8

                    $targetStamp = (Get-Date).AddMinutes(-10)
                    Set-FileLastWriteTime -Path $filePath -Timestamp $targetStamp
                    $observed = Get-FileLastWriteTime -Path $filePath

                    $delta = [Math]::Abs(($observed - $targetStamp).TotalSeconds)
                    $delta | Should -BeLessThan 1
                }
            }

            It "returns empty matcher set when no patterns are provided" {
                $matchers = InModuleScope ColorScripts-Enhanced { New-NameMatcherSet -Patterns $null }
                $matchers | Should -BeNullOrEmpty
            }

            It "caches resolved PowerShell executable" {
                InModuleScope ColorScripts-Enhanced {
                    $script:PowerShellExecutable = $null
                }

                Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Name)
                    [void]$Name
                    [pscustomobject]@{ Path = 'C:\Program Files\PowerShell\7\pwsh.exe' }
                }

                $first = InModuleScope ColorScripts-Enhanced {
                    Get-PowerShellExecutable
                }

                $second = InModuleScope ColorScripts-Enhanced {
                    Get-PowerShellExecutable
                }

                $first | Should -Be 'C:\Program Files\PowerShell\7\pwsh.exe'
                $second | Should -Be $first
                Assert-MockCalled -CommandName Get-Command -ModuleName ColorScripts-Enhanced -Times 1

                InModuleScope ColorScripts-Enhanced {
                    $script:PowerShellExecutable = $null
                }
            }

            It "falls back to current process module when pwsh is unavailable" {
                InModuleScope ColorScripts-Enhanced {
                    $script:PowerShellExecutable = $null
                }

                Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith { $null }

                $expectedPath = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
                $process = [pscustomobject]@{ MainModule = [pscustomobject]@{ FileName = $expectedPath } }

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ processObj = $process } {
                    param($processObj)
                    [void]$processObj
                    $originalDelegate = $script:GetCurrentProcessDelegate
                    try {
                        $script:GetCurrentProcessDelegate = { $processObj }
                        Get-PowerShellExecutable
                    }
                    finally {
                        $script:GetCurrentProcessDelegate = $originalDelegate
                    }
                }

                $result | Should -Be $expectedPath

                InModuleScope ColorScripts-Enhanced {
                    $script:PowerShellExecutable = $null
                }
            }

            It "falls back to command line arguments when process access fails" {
                InModuleScope ColorScripts-Enhanced {
                    $script:PowerShellExecutable = $null
                }

                Mock -CommandName Get-Command -ModuleName ColorScripts-Enhanced -MockWith { $null }

                $result = InModuleScope ColorScripts-Enhanced {
                    $originalDelegate = $script:GetCurrentProcessDelegate
                    try {
                        $script:GetCurrentProcessDelegate = { throw [System.InvalidOperationException]::new('process unavailable') }
                        Get-PowerShellExecutable
                    }
                    finally {
                        $script:GetCurrentProcessDelegate = $originalDelegate
                    }
                }

                $result | Should -Be ([System.Environment]::GetCommandLineArgs()[0])

                InModuleScope ColorScripts-Enhanced {
                    $script:PowerShellExecutable = $null
                }
            }
        }

        Context "Test-ColorScriptTextEmission" {
            It "returns true when ReturnText is requested" {
                $result = InModuleScope ColorScripts-Enhanced {
                    Test-ColorScriptTextEmission -ReturnText $true -PassThru $false -PipelineLength 1 -BoundParameters @{}
                }

                $result | Should -BeTrue
            }

            It "returns false when PassThru is specified" {
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

            It "returns true when OutVariable is bound" {
                $bound = @{ OutVariable = 'var' }

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ bound = $bound } {
                    param($bound)
                    Test-ColorScriptTextEmission -ReturnText $false -PassThru $false -PipelineLength 1 -BoundParameters $bound
                }

                $result | Should -BeTrue
            }

            It "returns false when no conditions are met" {
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
            It "appends newline when output lacks terminator" {
                $result = InModuleScope ColorScripts-Enhanced {
                    $originalDelegate = $script:ConsoleWriteDelegate
                    try {
                        $script:__Rendered = [System.Collections.Generic.List[string]]::new()
                        $script:ConsoleWriteDelegate = {
                            param($Text)
                            $null = $script:__Rendered.Add([string]$Text)
                        }

                        Write-RenderedText -Text 'sample'
                        $script:__Rendered.ToArray()
                    }
                    finally {
                        $script:ConsoleWriteDelegate = $originalDelegate
                        Remove-Variable -Name __Rendered -Scope Script -ErrorAction SilentlyContinue
                    }
                }

                (-join $result) | Should -Be ('sample' + [Environment]::NewLine)
            }

            It "avoids duplicate newline when text already terminated" {
                $result = InModuleScope ColorScripts-Enhanced {
                    $originalDelegate = $script:ConsoleWriteDelegate
                    try {
                        $script:__Rendered = [System.Collections.Generic.List[string]]::new()
                        $script:ConsoleWriteDelegate = {
                            param($Text)
                            $null = $script:__Rendered.Add([string]$Text)
                        }

                        Write-RenderedText -Text "ready`n"
                        $script:__Rendered.ToArray()
                    }
                    finally {
                        $script:ConsoleWriteDelegate = $originalDelegate
                        Remove-Variable -Name __Rendered -Scope Script -ErrorAction SilentlyContinue
                    }
                }

                (-join $result) | Should -Be "ready`n"
            }

            It "handles null input by writing empty line" {
                $result = InModuleScope ColorScripts-Enhanced {
                    $originalDelegate = $script:ConsoleWriteDelegate
                    try {
                        $script:__Rendered = [System.Collections.Generic.List[string]]::new()
                        $script:ConsoleWriteDelegate = {
                            param($Text)
                            $null = $script:__Rendered.Add([string]$Text)
                        }

                        Write-RenderedText -Text $null
                        $script:__Rendered.ToArray()
                    }
                    finally {
                        $script:ConsoleWriteDelegate = $originalDelegate
                        Remove-Variable -Name __Rendered -Scope Script -ErrorAction SilentlyContinue
                    }
                }

                (-join $result) | Should -Be ([Environment]::NewLine)
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
                        $script:MockConsoleEncoding = [System.Text.Encoding]::Unicode
                        $script:GetConsoleOutputEncodingDelegate = { $script:MockConsoleEncoding }

                        $setEncodings = [System.Collections.Generic.List[string]]::new()
                        $script:SetConsoleOutputEncodingDelegate = {
                            param([System.Text.Encoding]$Encoding)
                            $null = $setEncodings.Add($Encoding.WebName)
                            $script:MockConsoleEncoding = $Encoding
                        }

                        $invoked = $false

                        Invoke-WithUtf8Encoding -ScriptBlock {
                            param([ref]$Flag)
                            $Flag.Value = $true
                        } -Arguments @([ref]$invoked)

                        $invoked | Should -BeTrue
                        $setEncodings | Should -Contain 'utf-8'
                        $setEncodings | Should -Contain 'utf-16'
                        $script:MockConsoleEncoding.WebName | Should -Be 'utf-16'
                    }
                    finally {
                        $script:IsOutputRedirectedDelegate = $originalIsRedirected
                        $script:GetConsoleOutputEncodingDelegate = $originalGetEncoding
                        $script:SetConsoleOutputEncodingDelegate = $originalSetEncoding
                        Remove-Variable -Name MockConsoleEncoding -Scope Script -ErrorAction SilentlyContinue
                    }
                }
            }
        }

        Context "Resolve-CachePath" {
            It "returns absolute paths unchanged" {
                $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $target = Join-Path -Path $testRoot -ChildPath 'cache-location'
                New-Item -ItemType Directory -Path $target -Force | Out-Null

                $resolved = InModuleScope ColorScripts-Enhanced -Parameters @{ target = $target } {
                    param($target)
                    Resolve-CachePath -Path $target
                }

                $resolved | Should -Be $target
            }

            It "expands tilde to the user profile" {
                $userProfile = [System.Environment]::GetFolderPath('UserProfile')
                $resolved = InModuleScope ColorScripts-Enhanced {
                    Resolve-CachePath -Path '~/ColorScripts-Cache'
                }

                if (-not [string]::IsNullOrEmpty($userProfile)) {
                    $expected = Join-Path -Path $userProfile -ChildPath 'ColorScripts-Cache'
                    $resolved | Should -Be $expected
                }
                else {
                    $resolved | Should -Match 'ColorScripts-Cache$'
                }
            }

            It "combines relative paths with the current directory" {
                $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath

                Push-Location $testRoot
                try {
                    $resolved = InModuleScope ColorScripts-Enhanced {
                        Resolve-CachePath -Path 'relative\folder'
                    }
                }
                finally {
                    Pop-Location
                }

                $resolved | Should -Be (Join-Path -Path $testRoot -ChildPath 'relative\folder')
            }

            It "uses HOME fallback when profile delegate is null" {
                $expectedHome = $HOME

                $result = InModuleScope ColorScripts-Enhanced {
                    $originalDelegate = $script:GetUserProfilePathDelegate
                    try {
                        $script:GetUserProfilePathDelegate = { $null }
                        Resolve-CachePath -Path '~'
                    }
                    finally {
                        $script:GetUserProfilePathDelegate = $originalDelegate
                    }
                }

                $result | Should -Be $expectedHome
            }

            It "returns null when provider and directory delegates fail" {
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

            It "logs verbose message when full path resolution fails" {
                $resultData = InModuleScope ColorScripts-Enhanced {
                    $originalFullPath = $script:GetFullPathDelegate
                    try {
                        $script:GetFullPathDelegate = {
                            param($path)
                            [void]$path
                            throw [System.Exception]::new('full path failure')
                        }

                        $script:__ResolveVerbose = [System.Collections.Generic.List[string]]::new()
                        Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                            param($Message)
                            $null = $script:__ResolveVerbose.Add($Message)
                        }

                        $value = Resolve-CachePath -Path 'relative/path'
                        [pscustomobject]@{
                            Result  = $value
                            Verbose = $script:__ResolveVerbose.ToArray()
                        }
                    }
                    finally {
                        $script:GetFullPathDelegate = $originalFullPath
                        Remove-Variable -Name __ResolveVerbose -Scope Script -ErrorAction SilentlyContinue
                    }
                }

                $resultData.Result | Should -Be $null
                ($resultData.Verbose | Where-Object { $_ -like 'Unable to resolve cache path*' }) | Should -Not -BeNullOrEmpty
            }
        }

        Context "Initialize-CacheDirectory" {
            BeforeEach {
                InModuleScope ColorScripts-Enhanced {
                    $script:CacheInitialized = $false
                    $script:CacheDir = $null
                    $script:ConfigurationData = $null
                }
            }

            It "ignores override when path cannot be resolved" {
                $capturedVerbose = [System.Collections.Generic.List[string]]::new()
                $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
                $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = '~\missing'

                Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Path)
                    [void]$Path
                    $null
                }
                Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Message)
                    $null = $capturedVerbose.Add($Message)
                }

                try {
                    InModuleScope ColorScripts-Enhanced {
                        Initialize-CacheDirectory
                    }
                }
                finally {
                    $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $originalOverride
                }

                ($capturedVerbose | Where-Object { $_ -like 'Ignoring COLOR_SCRIPTS_ENHANCED_CACHE_PATH override*' }) | Should -Not -BeNullOrEmpty
            }

            It "uses macOS cache locations when applicable" -Skip:($PSVersionTable.PSVersion.Major -le 5) {
                $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $homePath = Join-Path -Path $testRoot -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $homePath -Force | Out-Null

                # Pre-create the macOS directory structure
                $macCachePath = Join-Path -Path $homePath -ChildPath 'Library\Application Support\ColorScripts-Enhanced\cache'
                New-Item -ItemType Directory -Path $macCachePath -Force | Out-Null

                Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Path)
                    $Path
                }

                InModuleScope ColorScripts-Enhanced -Parameters @{ TestHomePath = $homePath } {
                    param($TestHomePath)
                    $originalHome = Get-Variable -Name HOME -Scope Global -ValueOnly
                    $originalAppData = $env:APPDATA
                    $originalXdg = $env:XDG_CACHE_HOME
                    $script:CacheInitialized = $false
                    $script:CacheDir = $null
                    $script:ConfigurationData = @{ Cache = @{} ; Startup = @{} }
                    $script:ConfigurationInitialized = $false
                    $script:IsWindows = $false
                    $script:IsMacOS = $true
                    Set-Variable -Name HOME -Scope Global -Value $TestHomePath -Force
                    $env:APPDATA = $null
                    $env:XDG_CACHE_HOME = $null
                    try {
                        Initialize-CacheDirectory
                        $script:CacheDir | Should -Match 'Library[/\\]Application Support[/\\]ColorScripts-Enhanced[/\\]cache$'
                    }
                    finally {
                        $script:IsWindows = $IsWindows
                        $script:IsMacOS = $IsMacOS
                        Set-Variable -Name HOME -Scope Global -Value $originalHome -Force
                        $env:APPDATA = $originalAppData
                        $env:XDG_CACHE_HOME = $originalXdg
                    }
                }
            }

            It "uses XDG cache home on non-windows platforms" -Skip:($PSVersionTable.PSVersion.Major -le 5) {
                $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $xdgPath = Join-Path -Path $testRoot -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $xdgPath -Force | Out-Null

                # Pre-create the XDG cache directory
                $xdgCachePath = Join-Path -Path $xdgPath -ChildPath 'ColorScripts-Enhanced'
                New-Item -ItemType Directory -Path $xdgCachePath -Force | Out-Null

                Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Path)
                    $Path
                }

                InModuleScope ColorScripts-Enhanced -Parameters @{ TestXdgPath = $xdgPath } {
                    param($TestXdgPath)
                    $originalHome = Get-Variable -Name HOME -Scope Global -ValueOnly
                    $originalXdg = $env:XDG_CACHE_HOME
                    $originalAppData = $env:APPDATA
                    $script:CacheInitialized = $false
                    $script:CacheDir = $null
                    $script:ConfigurationData = @{ Cache = @{} ; Startup = @{} }
                    $script:ConfigurationInitialized = $false
                    $script:IsWindows = $false
                    $script:IsMacOS = $false
                    Set-Variable -Name HOME -Scope Global -Value (Join-Path -Path $TestXdgPath -ChildPath 'fakehome') -Force
                    $env:XDG_CACHE_HOME = $TestXdgPath
                    $env:APPDATA = $null
                    try {
                        Initialize-CacheDirectory
                        $script:CacheDir | Should -Match 'ColorScripts-Enhanced$'
                        $script:CacheDir | Should -Match ([regex]::Escape($TestXdgPath))
                    }
                    finally {
                        $script:IsWindows = $IsWindows
                        $script:IsMacOS = $IsMacOS
                        Set-Variable -Name HOME -Scope Global -Value $originalHome -Force
                        $env:XDG_CACHE_HOME = $originalXdg
                        $env:APPDATA = $originalAppData
                    }
                }
            }

            It "creates fallback directory when all candidates fail" {
                Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Path)
                    [void]$Path
                    $null
                }

                InModuleScope ColorScripts-Enhanced {
                    Initialize-CacheDirectory
                    $script:CacheDir | Should -Not -BeNullOrEmpty
                    Test-Path -LiteralPath $script:CacheDir | Should -BeTrue
                }
            }

            It "retains target path when resolution fails" {
                Mock -CommandName Resolve-CachePath -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Path)
                    $Path
                }

                Mock -CommandName Resolve-Path -ModuleName ColorScripts-Enhanced -MockWith {
                    throw [System.IO.IOException]::new('resolve')
                }

                InModuleScope ColorScripts-Enhanced {
                    Initialize-CacheDirectory
                    $script:CacheDir | Should -Not -BeNullOrEmpty
                }
            }

            It "marks cache as initialized after setup" {
                InModuleScope ColorScripts-Enhanced {
                    $script:CacheInitialized = $false
                    $script:CacheDir = $null

                    Initialize-CacheDirectory

                    $script:CacheInitialized | Should -BeTrue
                    $script:CacheDir | Should -Not -BeNullOrEmpty
                }
            }
        }

        Context "Select-RecordsByName" {
            It "returns missing patterns when nothing matches" {
                $records = @(
                    [pscustomobject]@{ Name = 'alpha' },
                    [pscustomobject]@{ Name = 'beta' }
                )

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ records = $records } {
                    param($records)
                    Select-RecordsByName -Records $records -Name 'gamma'
                }

                $result.Records | Should -BeNullOrEmpty
                $result.MissingPatterns | Should -Contain 'gamma'
            }

            It "handles empty name input" {
                $records = @(
                    [pscustomobject]@{ Name = 'alpha' }
                )

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ records = $records } {
                    param($records)
                    Select-RecordsByName -Records $records -Name @()
                }

                $result.Records | Should -HaveCount 1
                $result.MissingPatterns | Should -BeNullOrEmpty
            }

            It "ignores whitespace-only name patterns" {
                $records = @(
                    [pscustomobject]@{ Name = 'alpha' },
                    [pscustomobject]@{ Name = 'beta' }
                )

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ records = $records } {
                    param($records)
                    Select-RecordsByName -Records $records -Name @('   ', "`t")
                }

                $result.Records | Should -BeNullOrEmpty
                $result.MissingPatterns | Should -BeNullOrEmpty
            }
        }

        Context "Get-ColorScriptList" {
            It "shows help when requested" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced

                    Get-ColorScriptList -h

                    Assert-MockCalled -CommandName Show-ColorScriptHelp -ModuleName ColorScripts-Enhanced -Times 1 -ParameterFilter { $CommandName -eq 'Get-ColorScriptList' }
                }
            }

            It "warns when named scripts are missing" -Skip {
                $resultData = InModuleScope ColorScripts-Enhanced {
                    $capturedWarnings = [System.Collections.Generic.List[string]]::new()

                    Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                        @(
                            [pscustomobject]@{ Name = 'alpha'; Category = 'Demo'; Tags = @('Tag1'); Description = 'demo' },
                            [pscustomobject]@{ Name = 'beta'; Category = 'Demo'; Tags = @('Tag2'); Description = 'second' }
                        )
                    }

                    Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Message)
                        $null = $capturedWarnings.Add($Message)
                    }

                    $records = Get-ColorScriptList -Name 'missing' -AsObject

                    [pscustomobject]@{
                        Records  = $records
                        Warnings = $capturedWarnings.ToArray()
                    }
                }

                $resultData.Records | Should -BeNullOrEmpty
                ($resultData.Warnings | Where-Object { $_ -like "Colorscript 'missing'*" }) | Should -Not -BeNullOrEmpty
            }

            It "warns when filters return no scripts" {
                $resultData = InModuleScope ColorScripts-Enhanced {
                    $warnings = [System.Collections.Generic.List[string]]::new()

                    Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith { @() }

                    Mock -CommandName Write-Warning -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Message)
                        $null = $warnings.Add($Message)
                    }

                    $records = Get-ColorScriptList -Category 'none' -AsObject

                    [pscustomobject]@{
                        Records = $records
                        Warnings = $warnings.ToArray()
                    }
                }

                $resultData.Records | Should -BeNullOrEmpty
                ($resultData.Warnings | Where-Object { $_ -like 'No colorscripts available*' }) | Should -Not -BeNullOrEmpty
            }

            It "formats detailed output with joined tags" {
                $resultData = InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                        @([pscustomobject]@{
                                Name        = 'format-demo'
                                Category    = 'Demo'
                                Tags        = @('TagA', 'TagB')
                                Description = 'Formatting demo'
                            })
                    }

                    $capturedOutput = [System.Collections.Generic.List[string]]::new()
                    Mock -CommandName Write-Host -ModuleName ColorScripts-Enhanced -MockWith {
                        param($Object, [System.ConsoleColor]$ForegroundColor)
                        [void]$ForegroundColor
                        if ($null -ne $Object) {
                            $null = $capturedOutput.Add([string]$Object)
                        }
                    }

                    $records = Get-ColorScriptList -Detailed

                    [pscustomobject]@{
                        Records = $records
                        Output  = $capturedOutput.ToArray()
                    }
                }

                $resultData.Records | Should -HaveCount 1
                $resultData.Records[0].Tags | Should -Contain 'TagA'
                ($resultData.Output | Where-Object { $_ -like '*TagA, TagB*' }) | Should -Not -BeNullOrEmpty
            }
        }

        Context "Invoke-ColorScriptProcess" {
            It "returns error when script path is missing" {
                $missingPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'does-not-exist.ps1'

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ missingPath = $missingPath } {
                    param($missingPath)
                    Invoke-ColorScriptProcess -ScriptPath $missingPath
                }

                $result.Success | Should -BeFalse
                $result.StdErr | Should -Be 'Script path not found.'
                $result.ScriptName | Should -Be 'does-not-exist'
            }

            It "executes script successfully without mocks" {
                $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $scriptPath = Join-Path -Path $testRoot -ChildPath 'process-real.ps1'
                Set-Content -LiteralPath $scriptPath -Value "Write-Output 'solid coverage'" -Encoding UTF8

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ scriptPath = $scriptPath } {
                    param($scriptPath)
                    Invoke-ColorScriptProcess -ScriptPath $scriptPath
                }

                $result.Success | Should -BeTrue
                $result.StdErr | Should -Be ''
                ($result.StdOut.Trim()) | Should -Be 'solid coverage'
            }

            It "executes script successfully with mocked process" {
                $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $scriptPath = Join-Path -Path $testRoot -ChildPath 'process-success.ps1'
                Set-Content -LiteralPath $scriptPath -Value "Write-Host 'process success'" -Encoding UTF8

                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Get-PowerShellExecutable -ModuleName ColorScripts-Enhanced -MockWith { 'pwsh' }

                    Mock -CommandName New-Object -ModuleName ColorScripts-Enhanced -MockWith {
                        param($TypeName)

                        if ($TypeName -eq 'System.Diagnostics.ProcessStartInfo') {
                            return [pscustomobject]@{
                                FileName                = $null
                                Arguments               = $null
                                UseShellExecute         = $null
                                RedirectStandardOutput  = $null
                                RedirectStandardError   = $null
                                StandardOutputEncoding  = $null
                                StandardErrorEncoding   = $null
                                WorkingDirectory        = $null
                            }
                        }

                        if ($TypeName -eq 'System.Text.StringBuilder') {
                            return [System.Text.StringBuilder]::new()
                        }

                        if ($TypeName -eq 'System.Diagnostics.Process') {
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

                        throw "Unexpected type: $TypeName"
                    }
                }

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ scriptPath = $scriptPath } {
                    param($scriptPath)
                    Invoke-ColorScriptProcess -ScriptPath $scriptPath
                }

                $result.Success | Should -BeTrue
                $result.StdOut | Should -Be 'stdout-data'
                $result.StdErr | Should -Be 'stderr-data'
            }

            It "captures process exceptions" {
                $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $scriptPath = Join-Path -Path $testRoot -ChildPath 'process-fail.ps1'
                Set-Content -LiteralPath $scriptPath -Value "Write-Host 'process fail'" -Encoding UTF8

                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Get-PowerShellExecutable -ModuleName ColorScripts-Enhanced -MockWith { 'pwsh' }
                    Mock -CommandName New-Object -ModuleName ColorScripts-Enhanced -MockWith {
                        param($TypeName)
                        if ($TypeName -eq 'System.Diagnostics.ProcessStartInfo') {
                            return [pscustomobject]@{
                                FileName                = $null
                                Arguments               = $null
                                UseShellExecute         = $false
                                RedirectStandardOutput  = $false
                                RedirectStandardError   = $false
                                StandardOutputEncoding  = $null
                                StandardErrorEncoding   = $null
                                WorkingDirectory        = $null
                            }
                        }

                        if ($TypeName -eq 'System.Text.StringBuilder') {
                            return [System.Text.StringBuilder]::new()
                        }

                        if ($TypeName -eq 'System.Diagnostics.Process') {
                            throw [System.Exception]::new('process creation failure')
                        }

                        throw "Unexpected type: $TypeName"
                    }
                }

                $result = InModuleScope ColorScripts-Enhanced -Parameters @{ scriptPath = $scriptPath } {
                    param($scriptPath)
                    Invoke-ColorScriptProcess -ScriptPath $scriptPath
                }

                $result.Success | Should -BeFalse
                $result.StdErr | Should -Match 'process creation failure'
            }
        }

        Context "Invoke-ColorScriptsStartup" {
            It "forces startup when override is enabled" {
                $originalOverride = $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT
                $originalCI = $env:CI
                $originalGitHubActions = $env:GITHUB_ACTIONS
                $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT = 'true'
                $env:CI = $null
                $env:GITHUB_ACTIONS = $null

                try {
                    InModuleScope ColorScripts-Enhanced {
                        Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                        Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith {
                            $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                            $configRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                            New-Item -ItemType Directory -Path $configRoot -Force | Out-Null
                            return $configRoot
                        }
                        Mock -CommandName Get-ConfigurationDataInternal -ModuleName ColorScripts-Enhanced -MockWith {
                            @{ Startup = @{ AutoShowOnImport = $false; DefaultScript = 'demo-script' } }
                        }
                        Mock -CommandName Show-ColorScript -ModuleName ColorScripts-Enhanced -MockWith { }

                        Invoke-ColorScriptsStartup

                        Assert-MockCalled -CommandName Show-ColorScript -ModuleName ColorScripts-Enhanced -Times 1 -ParameterFilter { $Name -eq 'demo-script' }
                    }
                }
                finally {
                    $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT = $originalOverride
                    if ($null -eq $originalCI) { Remove-Item Env:CI -ErrorAction SilentlyContinue } else { $env:CI = $originalCI }
                    if ($null -eq $originalGitHubActions) { Remove-Item Env:GITHUB_ACTIONS -ErrorAction SilentlyContinue } else { $env:GITHUB_ACTIONS = $originalGitHubActions }
                }
            }

            It "shows configured default script when auto show is enabled" {
                $originalCI = $env:CI
                $originalGitHubActions = $env:GITHUB_ACTIONS
                $env:CI = $null
                $env:GITHUB_ACTIONS = $null

                try {
                    InModuleScope ColorScripts-Enhanced {
                        Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                        Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith {
                            $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                            $configRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                            New-Item -ItemType Directory -Path $configRoot -Force | Out-Null
                            $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'
                            Set-Content -Path $configPath -Value '{}' -Encoding UTF8
                            return $configRoot
                        }
                        Mock -CommandName Get-ConfigurationDataInternal -ModuleName ColorScripts-Enhanced -MockWith {
                            @{ Startup = @{ AutoShowOnImport = $true; DefaultScript = 'galaxy' } }
                        }

                        Mock -CommandName Show-ColorScript -ModuleName ColorScripts-Enhanced -MockWith { }

                        Invoke-ColorScriptsStartup

                        Assert-MockCalled -CommandName Show-ColorScript -ModuleName ColorScripts-Enhanced -Times 1 -ParameterFilter { $Name -eq 'galaxy' }
                    }
                }
                finally {
                    if ($null -eq $originalCI) { Remove-Item Env:CI -ErrorAction SilentlyContinue } else { $env:CI = $originalCI }
                    if ($null -eq $originalGitHubActions) { Remove-Item Env:GITHUB_ACTIONS -ErrorAction SilentlyContinue } else { $env:GITHUB_ACTIONS = $originalGitHubActions }
                }
            }

            It "falls back to general show when no default script is set" {
                $originalCI = $env:CI
                $originalGitHubActions = $env:GITHUB_ACTIONS
                $env:CI = $null
                $env:GITHUB_ACTIONS = $null

                try {
                    InModuleScope ColorScripts-Enhanced {
                        $script:StartupCallHistory = [System.Collections.Generic.List[bool]]::new()

                        try {
                            Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                            Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith {
                                $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                                $configRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                                New-Item -ItemType Directory -Path $configRoot -Force | Out-Null
                                $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'
                                Set-Content -Path $configPath -Value '{}' -Encoding UTF8
                                return $configRoot
                            }
                            Mock -CommandName Get-ConfigurationDataInternal -ModuleName ColorScripts-Enhanced -MockWith {
                                @{ Startup = @{ AutoShowOnImport = $true; DefaultScript = '' } }
                            }

                            Mock -CommandName Show-ColorScript -ModuleName ColorScripts-Enhanced -MockWith {
                                $hasName = $PSBoundParameters.ContainsKey('Name')
                                $null = $script:StartupCallHistory.Add($hasName)
                            }

                            Invoke-ColorScriptsStartup

                            $history = $script:StartupCallHistory.ToArray()
                            $history.Length | Should -Be 1
                            $history[0] | Should -BeFalse
                        }
                        finally {
                            Remove-Variable -Name StartupCallHistory -Scope Script -ErrorAction SilentlyContinue
                        }
                    }
                }
                finally {
                    if ($null -eq $originalCI) { Remove-Item Env:CI -ErrorAction SilentlyContinue } else { $env:CI = $originalCI }
                    if ($null -eq $originalGitHubActions) { Remove-Item Env:GITHUB_ACTIONS -ErrorAction SilentlyContinue } else { $env:GITHUB_ACTIONS = $originalGitHubActions }
                }
            }

            It "logs verbose message when startup handling fails" {
                $originalCI = $env:CI
                $originalGitHubActions = $env:GITHUB_ACTIONS
                $env:CI = $null
                $env:GITHUB_ACTIONS = $null

                try {
                    $resultData = InModuleScope ColorScripts-Enhanced {
                        $capturedVerbose = [System.Collections.Generic.List[string]]::new()

                        Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                        Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith {
                            $testDrive = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                            $configRoot = Join-Path -Path $testDrive -ChildPath ([guid]::NewGuid().ToString())
                            New-Item -ItemType Directory -Path $configRoot -Force | Out-Null
                            $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'
                            Set-Content -Path $configPath -Value '{}' -Encoding UTF8
                            return $configRoot
                        }
                        Mock -CommandName Get-ConfigurationDataInternal -ModuleName ColorScripts-Enhanced -MockWith {
                            @{ Startup = @{ AutoShowOnImport = $true; DefaultScript = 'throws' } }
                        }
                        Mock -CommandName Show-ColorScript -ModuleName ColorScripts-Enhanced -MockWith {
                            throw 'startup failure'
                        }
                        Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                            param($Message)
                            $null = $capturedVerbose.Add($Message)
                        }

                        Invoke-ColorScriptsStartup

                        [pscustomobject]@{
                            Verbose = $capturedVerbose.ToArray()
                        }
                    }

                    ($resultData.Verbose | Where-Object { $_ -like 'Auto-show on import skipped*' }) | Should -Not -BeNullOrEmpty
                }
                finally {
                    if ($null -eq $originalCI) { Remove-Item Env:CI -ErrorAction SilentlyContinue } else { $env:CI = $originalCI }
                    if ($null -eq $originalGitHubActions) { Remove-Item Env:GITHUB_ACTIONS -ErrorAction SilentlyContinue } else { $env:GITHUB_ACTIONS = $originalGitHubActions }
                }
            }

            It "does not display scripts when auto show is disabled" {
                InModuleScope ColorScripts-Enhanced {
                    Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { $null }
                    Mock -CommandName Get-ConfigurationDataInternal -ModuleName ColorScripts-Enhanced -MockWith {
                        @{ Startup = @{ AutoShowOnImport = $false; DefaultScript = 'ignored' } }
                    }

                    Mock -CommandName Show-ColorScript -ModuleName ColorScripts-Enhanced -MockWith { }

                    Invoke-ColorScriptsStartup

                    Assert-MockCalled -CommandName Show-ColorScript -ModuleName ColorScripts-Enhanced -Times 0
                }
            }

            It "logs verbose output when configuration root retrieval fails" {
                $originalCI = $env:CI
                $originalGitHubActions = $env:GITHUB_ACTIONS
                $env:CI = $null
                $env:GITHUB_ACTIONS = $null

                try {
                    $result = InModuleScope ColorScripts-Enhanced {
                        Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                        Mock -CommandName Get-ColorScriptsConfigurationRoot -ModuleName ColorScripts-Enhanced -MockWith { throw [System.IO.IOException]::new('config root missing') }
                        Mock -CommandName Get-ConfigurationDataInternal -ModuleName ColorScripts-Enhanced -MockWith {
                            @{ Startup = @{ AutoShowOnImport = $false } }
                        }
                        $script:__StartupVerbose = [System.Collections.Generic.List[string]]::new()
                        Mock -CommandName Write-Verbose -ModuleName ColorScripts-Enhanced -MockWith {
                            param($Message)
                            $null = $script:__StartupVerbose.Add($Message)
                        }

                        Invoke-ColorScriptsStartup
                        $script:__StartupVerbose.ToArray()
                    }

                    ($result | Where-Object { $_ -like 'Unable to locate configuration root*' }) | Should -Not -BeNullOrEmpty
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

        Context "Initialize-SystemDelegateState" {
            It "restores default delegates and functions" {
                $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
                $sampleFile = Join-Path -Path $testRoot -ChildPath 'delegate-check.txt'
                Set-Content -LiteralPath $sampleFile -Value 'Delegate test content' -Encoding UTF8

                InModuleScope ColorScripts-Enhanced -Parameters @{ sample = $sampleFile; directory = $testRoot } {
                    param($sample, $directory)
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

                    $originals = @{}
                    foreach ($name in $delegateNames) {
                        $originals[$name] = Get-Variable -Name $name -Scope Script -ValueOnly
                        Set-Variable -Name $name -Scope Script -Value $null
                    }

                    try {
                        Initialize-SystemDelegateState

                        & $script:GetUserProfilePathDelegate | Should -Not -BeNullOrEmpty
                        & $script:IsPathRootedDelegate $PSScriptRoot | Should -BeTrue
                        & $script:GetFullPathDelegate '.' | Should -Not -BeNullOrEmpty
                        & $script:GetCurrentDirectoryDelegate | Should -Not -BeNullOrEmpty
                        & $script:GetCurrentProviderPathDelegate | Should -Not -BeNullOrEmpty

                        & $script:DirectoryGetLastWriteTimeUtcDelegate $directory | Should -BeOfType [datetime]

                        & $script:FileExistsDelegate $sample | Should -BeTrue
                        & $script:FileGetLastWriteTimeUtcDelegate $sample | Should -BeOfType [datetime]
                        & $script:FileReadAllTextDelegate $sample ([System.Text.Encoding]::UTF8) | Should -Match 'Delegate test content'

                        & $script:GetCurrentProcessDelegate | Should -BeOfType [System.Diagnostics.Process]
                        & $script:IsOutputRedirectedDelegate | Should -BeOfType [bool]

                        $encoding = & $script:GetConsoleOutputEncodingDelegate
                        $encoding | Should -BeOfType [System.Text.Encoding]

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
                            Set-Variable -Name $name -Scope Script -Value $originals[$name]
                        }
                    }
                }
            }
        }
    }
}
