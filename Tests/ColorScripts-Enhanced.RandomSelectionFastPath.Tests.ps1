Describe 'ColorScripts-Enhanced random selection fast path' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleManifest = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced\ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force

        $script:OriginalInventoryState = InModuleScope ColorScripts-Enhanced {
            [pscustomobject]@{
                ScriptsPath       = $script:ScriptsPath
                DirectoryDelegate = $script:DirectoryGetLastWriteTimeUtcDelegate
                Inventory         = $script:ScriptInventory
                Records           = $script:ScriptInventoryRecords
                Initialized       = $script:ScriptInventoryInitialized
                Stamp             = $script:ScriptInventoryStamp
            }
        }
    }

    BeforeEach {
        $script:TestScriptsPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $script:TestScriptsPath -Force | Out-Null

        InModuleScope ColorScripts-Enhanced -Parameters @{ scriptsPath = $script:TestScriptsPath } {
            param($scriptsPath)

            $script:ScriptsPath = $scriptsPath
            $script:DirectoryGetLastWriteTimeUtcDelegate = {
                param($path)
                [System.IO.Directory]::GetLastWriteTimeUtc($path)
            }
            Reset-ScriptInventoryCache
        }
    }

    AfterAll {
        InModuleScope ColorScripts-Enhanced -Parameters @{ state = $script:OriginalInventoryState } {
            param($state)

            $script:ScriptsPath = $state.ScriptsPath
            $script:DirectoryGetLastWriteTimeUtcDelegate = $state.DirectoryDelegate
            $script:ScriptInventory = $state.Inventory
            $script:ScriptInventoryRecords = $state.Records
            $script:ScriptInventoryInitialized = $state.Initialized
            $script:ScriptInventoryStamp = $state.Stamp
        }

        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    It 'initializes raw files without materializing inventory records' {
        Set-Content -LiteralPath (Join-Path -Path $script:TestScriptsPath -ChildPath 'alpha.ps1') -Value "'alpha'"
        Set-Content -LiteralPath (Join-Path -Path $script:TestScriptsPath -ChildPath 'beta.ps1') -Value "'beta'"

        $state = InModuleScope ColorScripts-Enhanced {
            $raw = @(Get-ColorScriptInventory -Raw)
            $recordsBeforeMaterialization = $script:ScriptInventoryRecords
            $records = @(Get-ColorScriptInventory)

            [pscustomobject]@{
                RawCount                     = $raw.Count
                RecordsBeforeMaterialization = $recordsBeforeMaterialization
                RecordCount                  = $records.Count
                CachedRecordCount            = $script:ScriptInventoryRecords.Count
            }
        }

        $state.RawCount | Should -Be 2
        $state.RecordsBeforeMaterialization | Should -BeNullOrEmpty
        $state.RecordCount | Should -Be 2
        $state.CachedRecordCount | Should -Be 2
    }

    It 'selects one raw file without materializing the complete record inventory' {
        Set-Content -LiteralPath (Join-Path -Path $script:TestScriptsPath -ChildPath 'alpha.ps1') -Value "'alpha'"
        Set-Content -LiteralPath (Join-Path -Path $script:TestScriptsPath -ChildPath 'beta.ps1') -Value "'beta'"

        $state = InModuleScope ColorScripts-Enhanced {
            $raw = @(Get-ColorScriptInventory -Raw)
            Mock -CommandName Get-Random -ModuleName ColorScripts-Enhanced -MockWith { 0 }

            $selected = Get-RandomColorScriptInventoryRecord

            [pscustomobject]@{
                ExpectedName        = $raw[0].BaseName
                SelectedName        = $selected.Name
                SelectedPath        = $selected.Path
                RecordsMaterialized = $null -ne $script:ScriptInventoryRecords
            }
        }

        $state.SelectedName | Should -Be $state.ExpectedName
        $state.SelectedPath | Should -Be (Join-Path -Path $script:TestScriptsPath -ChildPath ($state.ExpectedName + '.ps1'))
        $state.RecordsMaterialized | Should -BeFalse
    }

    It 'refreshes both cache layers before random selection when the directory changes' {
        Set-Content -LiteralPath (Join-Path -Path $script:TestScriptsPath -ChildPath 'alpha.ps1') -Value "'alpha'"

        $state = InModuleScope ColorScripts-Enhanced -Parameters @{ scriptsPath = $script:TestScriptsPath } {
            param($scriptsPath)

            $script:TestInventoryStamp = [datetime]'2026-01-01T00:00:00Z'
            $script:DirectoryGetLastWriteTimeUtcDelegate = { $script:TestInventoryStamp }
            $null = Get-ColorScriptInventory

            Set-Content -LiteralPath (Join-Path -Path $scriptsPath -ChildPath 'beta.ps1') -Value "'beta'"
            $script:TestInventoryStamp = $script:TestInventoryStamp.AddSeconds(1)
            Mock -CommandName Get-Random -ModuleName ColorScripts-Enhanced -MockWith {
                param($Minimum, $Maximum)

                $null = $Minimum
                $Maximum - 1
            }

            $selected = Get-RandomColorScriptInventoryRecord

            [pscustomobject]@{
                RawCount             = $script:ScriptInventory.Count
                RecordsMaterialized  = $null -ne $script:ScriptInventoryRecords
                SelectedName         = $selected.Name
                InventoryInitialized = $script:ScriptInventoryInitialized
            }
        }

        $state.RawCount | Should -Be 2
        $state.RecordsMaterialized | Should -BeFalse
        $state.SelectedName | Should -Be 'beta'
        $state.InventoryInitialized | Should -BeTrue
    }

    It 'returns no record for an empty scripts directory' {
        $state = InModuleScope ColorScripts-Enhanced {
            [pscustomobject]@{
                Selection = Get-RandomColorScriptInventoryRecord
                Records   = $script:ScriptInventoryRecords
            }
        }

        $state.Selection | Should -BeNullOrEmpty
        $state.Records | Should -BeNullOrEmpty
    }

    It 'routes plain random display through the fast path with IncludePokemon as a no-op' {
        $outputs = InModuleScope ColorScripts-Enhanced {
            Mock -CommandName Get-ColorScriptInventory -ModuleName ColorScripts-Enhanced -MockWith {
                throw 'The full inventory must not be requested by plain random display.'
            }
            Mock -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -MockWith {
                throw 'Metadata must not be requested by plain random display.'
            }
            Mock -CommandName Get-RandomColorScriptInventoryRecord -ModuleName ColorScripts-Enhanced -MockWith {
                [pscustomobject]@{
                    Name        = 'pokemon-test'
                    Path        = 'C:\scripts\pokemon-test.ps1'
                    Category    = $null
                    Categories  = @()
                    Tags        = @()
                    Description = $null
                    Metadata    = $null
                }
            }
            Mock -CommandName Test-ColorScriptRequiresCache -ModuleName ColorScripts-Enhanced -MockWith { $false }
            Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                [pscustomobject]@{
                    Success  = $true
                    StdOut   = 'pokemon output'
                    StdErr   = ''
                    ExitCode = 0
                }
            }

            $defaultOutput = Show-ColorScript -ReturnText
            $compatibilityOutput = Show-ColorScript -IncludePokemon -ReturnText

            Should -Invoke -CommandName Get-RandomColorScriptInventoryRecord -ModuleName ColorScripts-Enhanced -Times 2 -Exactly
            Should -Invoke -CommandName Get-ColorScriptInventory -ModuleName ColorScripts-Enhanced -Times 0 -Exactly
            Should -Invoke -CommandName Get-ColorScriptEntry -ModuleName ColorScripts-Enhanced -Times 0 -Exactly

            @($defaultOutput, $compatibilityOutput)
        }

        $outputs | Should -HaveCount 2
        $outputs[0] | Should -Be 'pokemon output'
        $outputs[1] | Should -Be 'pokemon output'
    }
}
