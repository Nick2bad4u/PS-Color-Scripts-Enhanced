Describe "ColorScripts-Enhanced module import coverage" {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModulePath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModulePath -ChildPath 'ColorScripts-Enhanced.psd1'
        $script:ModuleName = 'ColorScripts-Enhanced'
        $script:OriginalTrace = $env:COLOR_SCRIPTS_ENHANCED_TRACE
        $script:OriginalRootOverride = $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT

        Remove-Module -Name $script:ModuleName -Force -ErrorAction SilentlyContinue
    }

    AfterEach {
        Remove-Module -Name $script:ModuleName -Force -ErrorAction SilentlyContinue
        $env:COLOR_SCRIPTS_ENHANCED_TRACE = $script:OriginalTrace
        $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT = $script:OriginalRootOverride
    }

    AfterAll {
        Remove-Module -Name $script:ModuleName -Force -ErrorAction SilentlyContinue
        $env:COLOR_SCRIPTS_ENHANCED_TRACE = $script:OriginalTrace
        $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT = $script:OriginalRootOverride
    }

    function script:Import-ModuleUnderTest {
        param(
            [string]$TraceSetting,
            [switch]$ClearTrace,
            [ScriptBlock]$PreImportAction,
            [string]$ManifestPath
        )

        Remove-Module -Name $script:ModuleName -Force -ErrorAction SilentlyContinue

        if ($PSBoundParameters.ContainsKey('TraceSetting')) {
            $env:COLOR_SCRIPTS_ENHANCED_TRACE = $TraceSetting
        }
        elseif ($ClearTrace) {
            Remove-Item Env:COLOR_SCRIPTS_ENHANCED_TRACE -ErrorAction SilentlyContinue
        }
        else {
            $env:COLOR_SCRIPTS_ENHANCED_TRACE = $script:OriginalTrace
        }

        if ($PreImportAction) {
            & $PreImportAction
        }

        $manifestToImport = if ($PSBoundParameters.ContainsKey('ManifestPath')) {
            $ManifestPath
        }
        else {
            $script:ModuleManifest
        }

        Import-Module $manifestToImport -Force -ErrorAction Stop | Out-Null
    }

    Describe "trace configuration handling" {
        It "handles whitespace trace tokens by falling back to trimmed value" {
            Import-ModuleUnderTest -TraceSetting ' , ; '

            InModuleScope $script:ModuleName {
                $script:ModuleTraceEnabled | Should -BeTrue
                $script:ModuleTraceUseVerbose | Should -BeTrue
                $script:ModuleTraceUseFile | Should -BeFalse
            }
        }

        It "sets verbose and file flags for respective tokens and prepares directories" {
            $traceDir = Join-Path -Path (Join-Path -Path $TestDrive -ChildPath 'trace-case') -ChildPath 'nested'
            $traceFile = Join-Path -Path $traceDir -ChildPath 'module-trace.log'

            Import-ModuleUnderTest -TraceSetting "verbose,file,path:$traceFile"

            Test-Path -LiteralPath $traceDir | Should -BeTrue

            $expectedTraceFile = [System.IO.Path]::GetFullPath($traceFile)
            $state = InModuleScope $script:ModuleName {
                [pscustomobject]@{
                    UseVerbose = $script:ModuleTraceUseVerbose
                    UseFile    = $script:ModuleTraceUseFile
                    TraceFile  = $script:ModuleTraceFile
                }
            }

            $state.UseVerbose | Should -BeTrue
            $state.UseFile | Should -BeTrue
            $state.TraceFile | Should -Be $expectedTraceFile
        }

        It "treats unrecognized token with invalid path characters as verbose fallback" {
            Import-ModuleUnderTest -TraceSetting '::invalid::'

            InModuleScope $script:ModuleName {
                $script:ModuleTraceUseVerbose | Should -BeTrue
            }
        }

        It "treats bare path tokens as file destinations" {
            $rawTrace = Join-Path -Path (Join-Path -Path $TestDrive -ChildPath 'implicit-path') -ChildPath 'trace.log'

            Import-ModuleUnderTest -TraceSetting $rawTrace

            $expectedTraceFile = [System.IO.Path]::GetFullPath($rawTrace)
            $state = InModuleScope $script:ModuleName {
                [pscustomobject]@{
                    UseFile   = $script:ModuleTraceUseFile
                    TraceFile = $script:ModuleTraceFile
                }
            }

            $state.UseFile | Should -BeTrue
            $state.TraceFile | Should -Be $expectedTraceFile
        }

        It "assigns default trace file when only file token is provided" {
            Import-ModuleUnderTest -TraceSetting 'file'

            $state = InModuleScope $script:ModuleName {
                [pscustomobject]@{
                    UseFile   = $script:ModuleTraceUseFile
                    TraceFile = $script:ModuleTraceFile
                }
            }

            $state.UseFile | Should -BeTrue
            $state.TraceFile | Should -Match 'cs-module-root-debug\.log$'
            if ($state.TraceFile) {
                Test-Path -LiteralPath (Split-Path -Path $state.TraceFile -Parent) | Should -BeTrue
                if (Test-Path -LiteralPath $state.TraceFile) {
                    Remove-Item -LiteralPath $state.TraceFile -Force -ErrorAction SilentlyContinue
                }
            }
        }

        It "disables file tracing when directory preparation fails" {
            $availableLetters = (65..90 | ForEach-Object { [char]$_ }) | Where-Object { -not (Get-PSDrive -Name $_ -ErrorAction SilentlyContinue) }
            $targetDrive = if ($availableLetters) { $availableLetters[0] } else { 'Z' }
            $invalidPath = '{0}:\nonexistent\trace.log' -f $targetDrive
            $originalPreference = $global:ErrorActionPreference

            try {
                Import-ModuleUnderTest -TraceSetting "file,path:$invalidPath" -PreImportAction { $global:ErrorActionPreference = 'Stop' }

                $state = InModuleScope $script:ModuleName {
                    [pscustomobject]@{
                        UseFile    = $script:ModuleTraceUseFile
                        TraceFile  = $script:ModuleTraceFile
                        UseVerbose = $script:ModuleTraceUseVerbose
                    }
                }

                $state.UseFile | Should -BeFalse
                if ($state.TraceFile) {
                    Test-Path -LiteralPath $state.TraceFile | Should -BeFalse
                }
            }
            finally {
                $global:ErrorActionPreference = $originalPreference
            }
        }

        It "notifies when writing to the trace file fails" {
            $traceTarget = Join-Path -Path $TestDrive -ChildPath 'trace-directory'
            New-Item -Path $traceTarget -ItemType Directory -Force | Out-Null

            Import-ModuleUnderTest -TraceSetting "path:$traceTarget"

            InModuleScope $script:ModuleName {
                $script:ModuleTraceUseFile | Should -BeTrue
                $script:ModuleTraceWriteFailureNotified | Should -BeTrue
            }
        }

        It "falls back when module root override cannot be resolved" {
            $availableLetters = (65..90 | ForEach-Object { [char]$_ }) | Where-Object { -not (Get-PSDrive -Name $_ -ErrorAction SilentlyContinue) }
            $targetDrive = if ($availableLetters) { $availableLetters[0] } else { 'Z' }
            $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT = '{0}:\missing\module-root' -f $targetDrive

            Import-ModuleUnderTest -TraceSetting $null -ClearTrace

            InModuleScope $script:ModuleName {
                $script:ModuleRoot | Should -Not -BeNullOrEmpty
                $script:ModuleRoot.StartsWith(('{0}:' -f $targetDrive)) | Should -BeFalse
            }
        }
    }

    Describe "missing script directories" {
        It "imports with fallback when script directories are unavailable" {
            Remove-Module -Name $script:ModuleName -Force -ErrorAction SilentlyContinue

            $privatePath = Join-Path -Path $script:ModulePath -ChildPath 'Private'
            $publicPath = Join-Path -Path $script:ModulePath -ChildPath 'Public'
            $privateBackup = '{0}.{1}.bak' -f $privatePath, ([Guid]::NewGuid().ToString())
            $publicBackup = '{0}.{1}.bak' -f $publicPath, ([Guid]::NewGuid().ToString())

            if (Test-Path -LiteralPath $privateBackup) { Remove-Item -LiteralPath $privateBackup -Recurse -Force }
            if (Test-Path -LiteralPath $publicBackup) { Remove-Item -LiteralPath $publicBackup -Recurse -Force }

            $privateBackupName = Split-Path -Path $privateBackup -Leaf
            $publicBackupName = Split-Path -Path $publicBackup -Leaf

            $renameAttempts = 0
            while ($true) {
                try {
                    Rename-Item -LiteralPath $privatePath -NewName $privateBackupName -ErrorAction Stop
                    break
                }
                catch {
                    if ($renameAttempts -ge 4) { throw }
                    Start-Sleep -Milliseconds 100
                    $renameAttempts++
                }
            }

            $renameAttempts = 0
            while ($true) {
                try {
                    Rename-Item -LiteralPath $publicPath -NewName $publicBackupName -ErrorAction Stop
                    break
                }
                catch {
                    if ($renameAttempts -ge 4) { throw }
                    Start-Sleep -Milliseconds 100
                    $renameAttempts++
                }
            }

            $stubbedFunctions = @(
                'Initialize-ColorScriptsLocalization',
                'Initialize-SystemDelegateState',
                'Invoke-ColorScriptsStartup',
                'Show-ColorScript',
                'Get-ColorScriptList',
                'New-ColorScriptCache',
                'Clear-ColorScriptCache',
                'Add-ColorScriptProfile',
                'Get-ColorScriptConfiguration',
                'Set-ColorScriptConfiguration',
                'Reset-ColorScriptConfiguration',
                'Export-ColorScriptMetadata',
                'New-ColorScript'
            )

            $definedStubs = @()
            $localizationModuleRoot = $null

            foreach ($name in $stubbedFunctions) {
                switch ($name) {
                    'Initialize-ColorScriptsLocalization' {
                        $localizationStub = {
                            param([string[]]$CandidateRoots, [string[]]$CultureFallbackOverride)
                            $null = $CultureFallbackOverride
                            [pscustomobject]@{
                                LocalizedDataLoaded = $false
                                ModuleRoot          = $localizationModuleRoot
                                SearchedPaths       = $CandidateRoots
                                Source              = 'Stub'
                                FilePath            = $null
                            }
                        }.GetNewClosure()
                        Set-Item -Path "function:global:$name" -Value $localizationStub -Force
                    }
                    'Invoke-ColorScriptsStartup' {
                        Set-Item -Path "function:global:$name" -Value { throw [System.IO.FileNotFoundException]::new('startup missing') } -Force
                    }
                    default {
                        Set-Item -Path "function:global:$name" -Value { } -Force
                    }
                }

                $definedStubs += $name
            }

            try {
                Import-ModuleUnderTest -ClearTrace

                $state = InModuleScope $script:ModuleName {
                    [pscustomobject]@{
                        ModuleRoot       = $script:ModuleRoot
                        TraceEnabled     = $script:ModuleTraceEnabled
                        EmbeddedDefaults = $script:EmbeddedDefaultMessages
                    }
                }

                $expectedRoot = (Resolve-Path -LiteralPath $script:ModulePath -ErrorAction Stop).ProviderPath
                $state.ModuleRoot | Should -Be $expectedRoot
                $state.TraceEnabled | Should -BeFalse
                $state.EmbeddedDefaults | Should -Not -BeNullOrEmpty
            }
            finally {
                Remove-Module -Name $script:ModuleName -Force -ErrorAction SilentlyContinue

                $privateOriginalName = Split-Path -Path $privatePath -Leaf
                $publicOriginalName = Split-Path -Path $publicPath -Leaf

                if (Test-Path -LiteralPath $privateBackup) {
                    Rename-Item -LiteralPath $privateBackup -NewName $privateOriginalName -ErrorAction SilentlyContinue
                }

                if (Test-Path -LiteralPath $publicBackup) {
                    Rename-Item -LiteralPath $publicBackup -NewName $publicOriginalName -ErrorAction SilentlyContinue
                }

                foreach ($name in $definedStubs) {
                    Remove-Item -Path "function:global:$name" -Force -ErrorAction SilentlyContinue
                }
            }
        }

        It "logs when module root resolution fails" {
            Remove-Module -Name $script:ModuleName -Force -ErrorAction SilentlyContinue

            $privatePath = Join-Path -Path $script:ModulePath -ChildPath 'Private'
            $publicPath = Join-Path -Path $script:ModulePath -ChildPath 'Public'
            $privateBackup = '{0}.{1}.bak' -f $privatePath, ([Guid]::NewGuid().ToString())
            $publicBackup = '{0}.{1}.bak' -f $publicPath, ([Guid]::NewGuid().ToString())

            if (Test-Path -LiteralPath $privateBackup) { Remove-Item -LiteralPath $privateBackup -Recurse -Force }
            if (Test-Path -LiteralPath $publicBackup) { Remove-Item -LiteralPath $publicBackup -Recurse -Force }

            $privateBackupName = Split-Path -Path $privateBackup -Leaf
            $publicBackupName = Split-Path -Path $publicBackup -Leaf

            $renameAttempts = 0
            while ($true) {
                try {
                    Rename-Item -LiteralPath $privatePath -NewName $privateBackupName -ErrorAction Stop
                    break
                }
                catch {
                    if ($renameAttempts -ge 4) { throw }
                    Start-Sleep -Milliseconds 100
                    $renameAttempts++
                }
            }

            $renameAttempts = 0
            while ($true) {
                try {
                    Rename-Item -LiteralPath $publicPath -NewName $publicBackupName -ErrorAction Stop
                    break
                }
                catch {
                    if ($renameAttempts -ge 4) { throw }
                    Start-Sleep -Milliseconds 100
                    $renameAttempts++
                }
            }

            $unresolvableRoot = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([Guid]::NewGuid().ToString())

            $stubbedFunctions = @(
                'Initialize-ColorScriptsLocalization',
                'Initialize-SystemDelegateState',
                'Invoke-ColorScriptsStartup',
                'Show-ColorScript',
                'Get-ColorScriptList',
                'New-ColorScriptCache',
                'Clear-ColorScriptCache',
                'Add-ColorScriptProfile',
                'Get-ColorScriptConfiguration',
                'Set-ColorScriptConfiguration',
                'Reset-ColorScriptConfiguration',
                'Export-ColorScriptMetadata',
                'New-ColorScript'
            )

            $definedStubs = @()
            $localizationModuleRoot = $unresolvableRoot

            foreach ($name in $stubbedFunctions) {
                switch ($name) {
                    'Initialize-ColorScriptsLocalization' {
                        $localizationStub = {
                            param([string[]]$CandidateRoots, [string[]]$CultureFallbackOverride)
                            $null = $CultureFallbackOverride
                            [pscustomobject]@{
                                LocalizedDataLoaded = $false
                                ModuleRoot          = $localizationModuleRoot
                                SearchedPaths       = $CandidateRoots
                                Source              = 'Stub'
                                FilePath            = $null
                            }
                        }.GetNewClosure()
                        Set-Item -Path "function:global:$name" -Value $localizationStub -Force
                    }
                    'Invoke-ColorScriptsStartup' {
                        Set-Item -Path "function:global:$name" -Value { throw [System.IO.FileNotFoundException]::new('startup missing') } -Force
                    }
                    default {
                        Set-Item -Path "function:global:$name" -Value { } -Force
                    }
                }

                $definedStubs += $name
            }

            try {
                Import-ModuleUnderTest -ClearTrace

                $state = InModuleScope $script:ModuleName {
                    [pscustomobject]@{
                        ModuleRoot = $script:ModuleRoot
                    }
                }

                $state.ModuleRoot | Should -Be $unresolvableRoot
            }
            finally {
                Remove-Module -Name $script:ModuleName -Force -ErrorAction SilentlyContinue

                $privateOriginalName = Split-Path -Path $privatePath -Leaf
                $publicOriginalName = Split-Path -Path $publicPath -Leaf

                if (Test-Path -LiteralPath $privateBackup) {
                    Rename-Item -LiteralPath $privateBackup -NewName $privateOriginalName -ErrorAction SilentlyContinue
                }

                if (Test-Path -LiteralPath $publicBackup) {
                    Rename-Item -LiteralPath $publicBackup -NewName $publicOriginalName -ErrorAction SilentlyContinue
                }

                foreach ($name in $definedStubs) {
                    Remove-Item -Path "function:global:$name" -Force -ErrorAction SilentlyContinue
                }
            }
        }
    }
}
