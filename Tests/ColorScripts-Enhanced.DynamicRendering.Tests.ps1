Describe 'Dynamic colorscript rendering' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context 'Explicit policy boundary' {
        It 'contains exactly the unique, resolvable scripts that are not statically extractable' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:ModuleRoot } {
                param($root)

                $policy = Import-PowerShellDataFile -Path (Join-Path $root 'DynamicRenderPolicy.psd1')
                $uniqueNames = @($policy.DynamicScripts | Sort-Object -Unique)
                $missing = @($policy.DynamicScripts | Where-Object {
                        -not (Test-Path -LiteralPath (Join-Path $root ("Scripts/{0}.ps1" -f $_)) -PathType Leaf)
                    })
                $unexpectedStatic = @($policy.DynamicScripts | Where-Object {
                        $path = Join-Path $root ("Scripts/{0}.ps1" -f $_)
                        (Get-StaticColorScriptOutput -ScriptPath $path).Available
                    })

                [pscustomobject]@{
                    Names            = @($policy.DynamicScripts)
                    UniqueNames      = $uniqueNames
                    Missing          = $missing
                    UnexpectedStatic = $unexpectedStatic
                }
            }

            $result.Names | Should -HaveCount 17
            $result.UniqueNames | Should -HaveCount 17
            $result.Missing | Should -BeNullOrEmpty
            $result.UnexpectedStatic | Should -BeNullOrEmpty
        }

        It 'routes all trusted dynamic scripts in-process without a child process' {
            $results = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:ModuleRoot } {
                param($root)

                Mock -CommandName Invoke-ColorScriptInProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
                        StdOut     = 'in-process'
                        StdErr     = ''
                        ExitCode   = 0
                        Success    = $true
                    }
                }
                Mock -CommandName Invoke-ColorScriptChildProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'A trusted bundled dynamic script must not launch a child process.'
                }

                $policy = Import-PowerShellDataFile -Path (Join-Path $root 'DynamicRenderPolicy.psd1')
                $invocations = foreach ($name in $policy.DynamicScripts) {
                    $path = Join-Path $root ("Scripts/{0}.ps1" -f $name)
                    Invoke-ColorScriptProcess -ScriptPath $path -ForCache
                }

                Should-Invoke -CommandName Invoke-ColorScriptInProcess -ModuleName ColorScripts-Enhanced -Times 17 -Exactly
                Should-Invoke -CommandName Invoke-ColorScriptChildProcess -ModuleName ColorScripts-Enhanced -Times 0 -Exactly
                @($invocations)
            }

            $results | Should -HaveCount 17
            @($results | Where-Object { -not $_.Success -or $_.StdOut -cne 'in-process' }) | Should -BeNullOrEmpty
        }

        It 'does not trust an allowlisted filename copied outside the bundled Scripts directory' {
            $copiedPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'Galaxy.ps1'
            Copy-Item -LiteralPath (Join-Path $script:ModuleRoot 'Scripts/Galaxy.ps1') -Destination $copiedPath

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $copiedPath } {
                param($path)

                Mock -CommandName Invoke-ColorScriptInProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'A copied script must not be trusted for in-process execution.'
                }
                Mock -CommandName Invoke-ColorScriptChildProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        ScriptName = 'Galaxy'
                        StdOut     = 'child fallback'
                        StdErr     = ''
                        ExitCode   = 0
                        Success    = $true
                    }
                }

                $invocation = Invoke-ColorScriptProcess -ScriptPath $path -ForCache
                Should-Invoke -CommandName Invoke-ColorScriptInProcess -ModuleName ColorScripts-Enhanced -Times 0 -Exactly
                Should-Invoke -CommandName Invoke-ColorScriptChildProcess -ModuleName ColorScripts-Enhanced -Times 1 -Exactly
                $invocation
            }

            $result.StdOut | Should -BeExactly 'child fallback'
        }

        It 'retains the child-process fallback for unknown executable scripts' {
            $customPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'custom-live.ps1'
            [System.IO.File]::WriteAllText(
                $customPath,
                'Write-Host (Get-Date)',
                [System.Text.UTF8Encoding]::new($false)
            )

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $customPath } {
                param($path)

                Mock -CommandName Invoke-ColorScriptInProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    throw 'Unknown script code must not execute in-process.'
                }
                Mock -CommandName Invoke-ColorScriptChildProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        ScriptName = 'custom-live'
                        StdOut     = 'safe child fallback'
                        StdErr     = ''
                        ExitCode   = 0
                        Success    = $true
                    }
                }

                $invocation = Invoke-ColorScriptProcess -ScriptPath $path
                Should-Invoke -CommandName Invoke-ColorScriptInProcess -ModuleName ColorScripts-Enhanced -Times 0 -Exactly
                Should-Invoke -CommandName Invoke-ColorScriptChildProcess -ModuleName ColorScripts-Enhanced -Times 1 -Exactly
                $invocation
            }

            $result.StdOut | Should -BeExactly 'safe child fallback'
        }

        It 'fails closed when the dynamic policy uses a scalar instead of an array' {
            $count = InModuleScope ColorScripts-Enhanced {
                $script:DynamicColorScriptNameSet = $null
                $script:DynamicRenderPolicyLastWriteTime = $null
                try {
                    Mock -CommandName Import-PowerShellDataFile -ModuleName ColorScripts-Enhanced -MockWith {
                        @{ DynamicScripts = 'Galaxy' }
                    }

                    (Get-ColorScriptDynamicNameSet).Count
                }
                finally {
                    $script:DynamicColorScriptNameSet = $null
                    $script:DynamicRenderPolicyLastWriteTime = $null
                }
            }

            $count | Should -Be 0
        }
    }

    Context 'In-process capture fidelity and isolation' {
        It 'captures host colors, no-newline output, pipeline output, and working directory exactly' {
            $testRoot = (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath
            $scriptPath = Join-Path -Path $testRoot -ChildPath 'capture.ps1'
            $source = @(
                '$global:CseRunspaceLeak = ''inside'''
                'Write-Host A,B -Separator '':'' -NoNewline -ForegroundColor Red -BackgroundColor DarkBlue'
                'Write-Host ''!'''
                '''cwd='' + (Get-Location).Path'
            ) -join [Environment]::NewLine
            [System.IO.File]::WriteAllText($scriptPath, $source, [System.Text.UTF8Encoding]::new($false))
            Remove-Variable -Name CseRunspaceLeak -Scope Global -ErrorAction SilentlyContinue

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $scriptPath } {
                param($path)
                Invoke-ColorScriptInProcess -ScriptPath $path
            }

            $escape = [string][char]27
            $expectedWorkingDirectory = $testRoot.TrimEnd(
                [System.IO.Path]::DirectorySeparatorChar,
                [System.IO.Path]::AltDirectorySeparatorChar
            )
            $expected = @(
                $escape + '[91;44mA:B' + $escape + '[0m!'
                'cwd=' + $expectedWorkingDirectory
                ''
            ) -join [Environment]::NewLine
            $result.Success | Should -BeTrue
            $result.ExitCode | Should -Be 0
            $result.StdErr | Should -BeExactly ''
            $result.StdOut | Should -BeExactly $expected
            Get-Variable -Name CseRunspaceLeak -Scope Global -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }

        It 'returns a failed result for errors raised inside the isolated runspace' {
            $scriptPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'failure.ps1'
            [System.IO.File]::WriteAllText(
                $scriptPath,
                "Write-Error 'render failed'",
                [System.Text.UTF8Encoding]::new($false)
            )

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $scriptPath } {
                param($path)
                Invoke-ColorScriptInProcess -ScriptPath $path
            }

            $result.Success | Should -BeFalse
            $result.ExitCode | Should -Be 1
            $result.StdErr | Should -Match 'render failed'
        }
    }
}
