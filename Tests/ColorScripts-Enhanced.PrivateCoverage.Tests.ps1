Describe 'ColorScripts-Enhanced private utility coverage' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRootPath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context 'ConvertFrom-JsonToHashtable' {
        It 'uses ConvertTo-HashtableInternal path when PSVersion below 6' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                $original = $global:PSVersionTable.PSVersion
                try {
                    $global:PSVersionTable['PSVersion'] = [version]'5.1.0.0'
                    $payload = '{"Name":"alpha","Values":[1,2,3]}'
                    . (Join-Path -Path $moduleRoot -ChildPath 'Private/ConvertFrom-JsonToHashtable.ps1')
                    . (Join-Path -Path $moduleRoot -ChildPath 'Private/ConvertTo-HashtableInternal.ps1')
                    ConvertFrom-JsonToHashtable -InputObject $payload
                }
                finally {
                    $global:PSVersionTable['PSVersion'] = $original
                }
            }

            $result.Name | Should -Be 'alpha'
            $values = @($result.Values)
            $values.GetType().FullName | Should -Be 'System.Object[]'
            $values | Should -Be @(1, 2, 3)
        }

        It 'returns hashtable directly on modern PowerShell' {
            $output = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/ConvertFrom-JsonToHashtable.ps1')
                ConvertFrom-JsonToHashtable -InputObject '{"Key":"value"}'
            }
            $output.Key | Should -Be 'value'
        }
    }

    Context 'ConvertTo-HashtableInternal' {
        It 'returns null for null input' {
            InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/ConvertTo-HashtableInternal.ps1')
                ConvertTo-HashtableInternal $null | Should -Be $null
            }
        }

        It 'converts dictionaries recursively' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/ConvertTo-HashtableInternal.ps1')
                $dict = @{ Level1 = @{ Level2 = 'value' } }
                ConvertTo-HashtableInternal $dict
            }
            $result.Level1.Level2 | Should -Be 'value'
        }

        It 'converts enumerables excluding strings' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/ConvertTo-HashtableInternal.ps1')
                ConvertTo-HashtableInternal @([pscustomobject]@{ Name = 'alpha' }, [pscustomobject]@{ Name = 'beta' })
            }
            $result.Count | Should -Be 2
            $result[0].Name | Should -Be 'alpha'
        }

        It 'converts PSCustomObject properties to dictionary entries' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/ConvertTo-HashtableInternal.ps1')
                $obj = [pscustomobject]@{ Foo = 'bar'; Data = @{ Nested = 1 } }
                ConvertTo-HashtableInternal $obj
            }
            $result.Foo | Should -Be 'bar'
            $result.Data.Nested | Should -Be 1
        }

        It 'returns scalars without modification' {
            InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/ConvertTo-HashtableInternal.ps1')
                ConvertTo-HashtableInternal 42 | Should -Be 42
            }
        }
    }
}
