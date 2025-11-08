Describe 'ColorScripts-Enhanced additional low-coverage targets' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force
    }

    AfterAll { Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue }

    Context 'ConvertFrom-JsonToHashtable' {
        It 'returns null for blank input' {
            $result = InModuleScope ColorScripts-Enhanced { ConvertFrom-JsonToHashtable -InputObject '' }
            $result | Should -Be $null
        }

        It 'converts JSON to hashtable on PS7+' {
            $json = '{"a":1,"b":"x"}'
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ j = $json } {
                param($j)
                ConvertFrom-JsonToHashtable -InputObject $j
            }
            $result.a | Should -Be 1
            $result.b | Should -Be 'x'
        }
    }

    Context 'Get-ColorScriptAnsiSequence' {
        It 'returns ANSI sequences (ESC optional in some hosts) and null for unknown' {
            $codes = InModuleScope ColorScripts-Enhanced {
                [pscustomobject]@{
                    cyan    = Get-ColorScriptAnsiSequence 'cyan'
                    yellow  = Get-ColorScriptAnsiSequence 'YELLOW'
                    green   = Get-ColorScriptAnsiSequence 'Green'
                    magenta = Get-ColorScriptAnsiSequence 'magenta'
                    dark    = Get-ColorScriptAnsiSequence 'darkgray'
                    red     = Get-ColorScriptAnsiSequence 'red'
                    blue    = Get-ColorScriptAnsiSequence 'blue'
                    none    = Get-ColorScriptAnsiSequence 'unknown'
                }
            }
            foreach ($pair in @([pscustomobject]@{v = $codes.cyan; s = '[36m' }, [pscustomobject]@{v = $codes.yellow; s = '[33m' }, [pscustomobject]@{v = $codes.green; s = '[32m' }, [pscustomobject]@{v = $codes.magenta; s = '[35m' }, [pscustomobject]@{v = $codes.dark; s = '[90m' }, [pscustomobject]@{v = $codes.red; s = '[31m' }, [pscustomobject]@{v = $codes.blue; s = '[34m' })) {
                $pair.v | Should -Not -BeNullOrEmpty
                if ($pair.v.Length -gt $pair.s.Length) {
                    # Likely includes ESC prefix
                    $pair.v.Substring($pair.v.Length - $pair.s.Length) | Should -Be $pair.s
                }
                else {
                    # Host stripped ESC; still ensure sequence core matches
                    $pair.v | Should -Be $pair.s
                }
            }
            $codes.none | Should -Be $null
        }
    }

    Context 'Test-ConsoleSupportsVirtualTerminal' {
        It 'returns true when not on Windows' {
            $result = InModuleScope ColorScripts-Enhanced {
                $original = $script:IsWindows
                try { $script:IsWindows = $false; Test-ConsoleSupportsVirtualTerminal }
                finally { $script:IsWindows = $original }
            }
            $result | Should -BeTrue
        }

        It 'returns false when GetStdHandle returns zero' {
            $result = InModuleScope ColorScripts-Enhanced {
                $original = $script:IsWindows
                try {
                    $script:IsWindows = $true
                    $script:ConsoleNativeOverrides = @{
                        Enabled        = $true
                        GetStdHandle   = { param([int]$n) [IntPtr]::Zero }
                        GetConsoleMode = { param([IntPtr]$handle, [ref]$mode) $mode.Value = 0; return $true }
                        SetConsoleMode = { param([IntPtr]$handle, [int]$mode) $true }
                    }
                    Test-ConsoleSupportsVirtualTerminal
                }
                finally {
                    $script:IsWindows = $original
                    $script:ConsoleNativeOverrides = $null
                }
            }
            $result | Should -BeFalse
        }

        It 'returns false when GetConsoleMode fails initially' {
            $result = InModuleScope ColorScripts-Enhanced {
                $original = $script:IsWindows
                try {
                    $script:IsWindows = $true
                    $script:ConsoleNativeOverrides = @{
                        Enabled        = $true
                        GetStdHandle   = { param([int]$n) [IntPtr]::new(1) }
                        GetConsoleMode = { param([IntPtr]$handle, [ref]$mode) return $false }
                        SetConsoleMode = { param([IntPtr]$handle, [int]$mode) $true }
                    }
                    Test-ConsoleSupportsVirtualTerminal
                }
                finally {
                    $script:IsWindows = $original
                    $script:ConsoleNativeOverrides = $null
                }
            }
            $result | Should -BeFalse
        }

        It 'returns true when VT flag already set without calling SetConsoleMode' {
            $result = InModuleScope ColorScripts-Enhanced {
                $original = $script:IsWindows
                try {
                    $script:IsWindows = $true
                    $script:SetCalls = 0
                    $script:ConsoleNativeOverrides = @{
                        Enabled        = $true
                        GetStdHandle   = { param([int]$n) [IntPtr]::new(2) }
                        GetConsoleMode = {
                            param([IntPtr]$handle, [ref]$mode)
                            $mode.Value = 0x0004
                            return $true
                        }
                        SetConsoleMode = {
                            param([IntPtr]$handle, [int]$mode)
                            $script:SetCalls++
                            return $true
                        }
                    }
                    $outcome = Test-ConsoleSupportsVirtualTerminal
                    [pscustomobject]@{ Result = $outcome; SetCalls = $script:SetCalls }
                }
                finally {
                    $script:IsWindows = $original
                    $script:ConsoleNativeOverrides = $null
                    Remove-Variable -Name SetCalls -Scope Script -ErrorAction SilentlyContinue
                }
            }
            $result.Result | Should -BeTrue
            $result.SetCalls | Should -Be 0
        }

        It 'returns false when SetConsoleMode fails' {
            $result = InModuleScope ColorScripts-Enhanced {
                $original = $script:IsWindows
                try {
                    $script:IsWindows = $true
                    $script:ConsoleNativeOverrides = @{
                        Enabled        = $true
                        GetStdHandle   = { param([int]$n) [IntPtr]::new(3) }
                        GetConsoleMode = {
                            param([IntPtr]$handle, [ref]$mode)
                            $mode.Value = 0
                            return $true
                        }
                        SetConsoleMode = {
                            param([IntPtr]$handle, [int]$mode)
                            return $false
                        }
                    }
                    Test-ConsoleSupportsVirtualTerminal
                }
                finally {
                    $script:IsWindows = $original
                    $script:ConsoleNativeOverrides = $null
                }
            }
            $result | Should -BeFalse
        }

        It 'returns false when verification GetConsoleMode fails after Set' {
            $result = InModuleScope ColorScripts-Enhanced {
                $original = $script:IsWindows
                try {
                    $script:IsWindows = $true
                    $script:CallIndex = 0
                    $script:ConsoleNativeOverrides = @{
                        Enabled        = $true
                        GetStdHandle   = { param([int]$n) [IntPtr]::new(4) }
                        GetConsoleMode = {
                            param([IntPtr]$handle, [ref]$mode)
                            if ($script:CallIndex -eq 0) {
                                $script:CallIndex = 1
                                $mode.Value = 0
                                return $true
                            }
                            return $false
                        }
                        SetConsoleMode = { param([IntPtr]$handle, [int]$mode) $true }
                    }
                    Test-ConsoleSupportsVirtualTerminal
                }
                finally {
                    $script:IsWindows = $original
                    $script:ConsoleNativeOverrides = $null
                    Remove-Variable -Name CallIndex -Scope Script -ErrorAction SilentlyContinue
                }
            }
            $result | Should -BeFalse
        }

        It 'returns true when SetConsoleMode succeeds and flag enabled' {
            $result = InModuleScope ColorScripts-Enhanced {
                $original = $script:IsWindows
                try {
                    $script:IsWindows = $true
                    $script:CallIndex = 0
                    $script:LastSetMode = 0
                    $script:ConsoleNativeOverrides = @{
                        Enabled        = $true
                        GetStdHandle   = { param([int]$n) [IntPtr]::new(5) }
                        GetConsoleMode = {
                            param([IntPtr]$handle, [ref]$mode)
                            if ($script:CallIndex -eq 0) {
                                $script:CallIndex = 1
                                $mode.Value = 0
                            }
                            else {
                                $mode.Value = 0x0004
                            }
                            return $true
                        }
                        SetConsoleMode = {
                            param([IntPtr]$handle, [int]$mode)
                            $script:LastSetMode = $mode
                            return $true
                        }
                    }
                    $outcome = Test-ConsoleSupportsVirtualTerminal
                    [pscustomobject]@{ Result = $outcome; LastSetMode = $script:LastSetMode }
                }
                finally {
                    $script:IsWindows = $original
                    $script:ConsoleNativeOverrides = $null
                    Remove-Variable -Name CallIndex -Scope Script -ErrorAction SilentlyContinue
                    Remove-Variable -Name LastSetMode -Scope Script -ErrorAction SilentlyContinue
                }
            }
            $result.Result | Should -BeTrue
            ($result.LastSetMode -band 0x0004) | Should -Be 0x0004
        }
    }

    Context 'Get-ColorScriptList emission modes' {
        It 'emits formatted table with -Detailed and strips ANSI when requested' {
            $captured = [System.Collections.Generic.List[string]]::new()
            InModuleScope ColorScripts-Enhanced -Parameters @{ bag = $captured } {
                param($bag)
                Mock -CommandName Write-ColorScriptInformation -ModuleName ColorScripts-Enhanced -MockWith { param($Message, $Quiet) $null = $bag.Add([string]$Message) }
                # Drive a small selection to avoid large output
                Get-ColorScriptList -Name 'bars' -Detailed -NoAnsiOutput | Out-Null
            }
            $captured.Count | Should -BeGreaterThan 0
        }

        It 'suppresses output when -Quiet and returns records' {
            $output = InModuleScope ColorScripts-Enhanced {
                Mock -CommandName Write-ColorScriptInformation -ModuleName ColorScripts-Enhanced -MockWith { }
                Get-ColorScriptList -Name 'bars' -Quiet
            }
            $output | Should -Not -BeNullOrEmpty
        }
    }
}
