Describe 'Write-ColorScriptInformation coverage' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleManifest = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force
    }

    AfterAll { Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue }

    It 'returns immediately when -Quiet is specified' {
        InModuleScope ColorScripts-Enhanced {
            Mock -CommandName Remove-ColorScriptAnsiSequence -ModuleName ColorScripts-Enhanced
            Mock -CommandName Write-Information -ModuleName ColorScripts-Enhanced
            Write-ColorScriptInformation -Message 'Hello' -Quiet
            Assert-MockCalled Remove-ColorScriptAnsiSequence -Times 0 -Exactly
            Assert-MockCalled Write-Information -Times 0 -Exactly
        }
    }

    It 'writes to console with ANSI when supported' {
        InModuleScope ColorScripts-Enhanced {
            $previousEnv = $env:COLOR_SCRIPTS_ENHANCED_FORCE_ANSI
            $env:COLOR_SCRIPTS_ENHANCED_FORCE_ANSI = 'true'
            try {
                Mock -CommandName Remove-ColorScriptAnsiSequence -ModuleName ColorScripts-Enhanced -MockWith { param($Text) 'sanitized' }
                Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                Mock -CommandName Test-ConsoleSupportsVirtualTerminal -ModuleName ColorScripts-Enhanced -MockWith { $true }
                $renderCalls = New-Object System.Collections.Generic.List[hashtable]
                Mock -CommandName Write-RenderedText -ModuleName ColorScripts-Enhanced -MockWith { param($Text, $NoAnsiOutput) $null = $renderCalls.Add(@{ Text = $Text; NoAnsiOutput = $NoAnsiOutput }) }
                Mock -CommandName Write-Information -ModuleName ColorScripts-Enhanced -MockWith { param($MessageData, $InformationAction, $Tags) $script:LastInfo = @{ Message = $MessageData; Action = $InformationAction; Tags = $Tags } }

                Write-ColorScriptInformation -Message "`e[31mRed`e[0m" -PreferConsole -Color 'Red'

                $renderCalls.Count | Should -Be 1
                $renderCalls[0].NoAnsiOutput | Should -BeFalse
                $renderCalls[0].Text | Should -Match 'Red'
                $script:LastInfo.Action | Should -Be 'SilentlyContinue'
                $script:LastInfo.Message | Should -Be 'sanitized'
            }
            finally {
                $env:COLOR_SCRIPTS_ENHANCED_FORCE_ANSI = $previousEnv
                Remove-Variable -Name LastInfo -Scope Script -ErrorAction SilentlyContinue
            }
        }
    }

    It 'bypasses console rendering when -NoAnsiOutput is requested' {
        InModuleScope ColorScripts-Enhanced {
            Mock -CommandName Remove-ColorScriptAnsiSequence -ModuleName ColorScripts-Enhanced -MockWith { param($Text) 'sanitized' }
            Mock -CommandName Write-RenderedText -ModuleName ColorScripts-Enhanced
            Mock -CommandName Write-Information -ModuleName ColorScripts-Enhanced -MockWith { param($MessageData, $InformationAction) $script:NI = @{ Message = $MessageData; Action = $InformationAction } }

            Write-ColorScriptInformation -Message "`e[32mGreen`e[0m" -NoAnsiOutput

            Assert-MockCalled Write-RenderedText -Times 0 -Exactly
            $script:NI.Message | Should -Be "`e[32mGreen`e[0m"
            $script:NI.Action | Should -Be 'Continue'
            Remove-Variable -Name NI -Scope Script -ErrorAction SilentlyContinue
        }
    }

    It 'falls back to colored console output when primary render fails' {
        InModuleScope ColorScripts-Enhanced {
            $previousEnv = $env:COLOR_SCRIPTS_ENHANCED_FORCE_ANSI
            $env:COLOR_SCRIPTS_ENHANCED_FORCE_ANSI = $null
            try {
                Mock -CommandName Remove-ColorScriptAnsiSequence -ModuleName ColorScripts-Enhanced -MockWith { param($Text) $Text }
                Mock -CommandName Test-ConsoleOutputRedirected -ModuleName ColorScripts-Enhanced -MockWith { $false }
                Mock -CommandName Test-ConsoleSupportsVirtualTerminal -ModuleName ColorScripts-Enhanced -MockWith { $false }
                $renderAttempts = New-Object System.Collections.Generic.List[bool]
                Mock -CommandName Write-RenderedText -ModuleName ColorScripts-Enhanced -MockWith {
                    param($Text, $NoAnsiOutput)
                    $null = $renderAttempts.Add($NoAnsiOutput)
                    if ($renderAttempts.Count -eq 1) {
                        throw 'console write failed'
                    }
                }
                Mock -CommandName Write-Information -ModuleName ColorScripts-Enhanced -MockWith { param($MessageData, $InformationAction) $script:FallbackInfo = $InformationAction }

                Write-ColorScriptInformation -Message 'Hello world' -PreferConsole -Color 'Yellow'

                $renderAttempts.Count | Should -Be 2
                $script:FallbackInfo | Should -Be 'SilentlyContinue'
            }
            finally {
                $env:COLOR_SCRIPTS_ENHANCED_FORCE_ANSI = $previousEnv
                Remove-Variable -Name FallbackInfo -Scope Script -ErrorAction SilentlyContinue
            }
        }
    }
}
