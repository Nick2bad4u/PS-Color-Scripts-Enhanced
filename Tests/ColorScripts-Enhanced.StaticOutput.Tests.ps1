Describe 'Static colorscript output extraction' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context 'Supported static subset' {
        It 'evaluates assigned ANSI values, interpolation, concatenation, and sequential output exactly' {
            $scriptPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'static-subset.ps1'
            $source = @(
                '$esc = [char]27'
                '$red = "$esc[31m"'
                '$reset = "$esc[0m"'
                '$line = "${RED}red$($reset)"'
                '$copy = $line'
                '$tail = ''done'' + ''?'''
                'Write-Host "$copy▬"'
                'Write-Host'
                'Write-Host $tail'
            ) -join [Environment]::NewLine
            [System.IO.File]::WriteAllText($scriptPath, $source, [System.Text.UTF8Encoding]::new($false))

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $scriptPath } {
                param($path)
                Get-StaticColorScriptOutput -ScriptPath $path
            }

            $escape = [char]27
            $expected = @(
                "$escape[31mred$escape[0m▬"
                [Environment]::NewLine
                [Environment]::NewLine
                'done?'
                [Environment]::NewLine
            ) -join ''
            $result.Available | Should -BeTrue
            $result.Content | Should -BeExactly $expected
        }

        It 'accepts System.Char and the full UTF-16 character range' {
            $scriptPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'system-char.ps1'
            $source = '$value = [System.Char]65535; Write-Host $value'
            [System.IO.File]::WriteAllText($scriptPath, $source, [System.Text.UTF8Encoding]::new($false))

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $scriptPath } {
                param($path)
                Get-StaticColorScriptOutput -ScriptPath $path
            }

            $result.Available | Should -BeTrue
            $result.Content | Should -BeExactly ([string][char]65535 + [Environment]::NewLine)
        }
    }

    Context 'Fail-closed boundary' {
        It 'rejects <Name>' -ForEach @(
            @{ Name = 'an undefined variable'; FileName = 'undefined.ps1'; Source = 'Write-Host "$missing"' }
            @{ Name = 'a scoped variable'; FileName = 'scoped.ps1'; Source = '$value = "$env:PATH"; Write-Host $value' }
            @{ Name = 'a command subexpression'; FileName = 'command-subexpression.ps1'; Source = 'Write-Host "$(& Get-Date)"' }
            @{ Name = 'a computed subexpression'; FileName = 'computed-subexpression.ps1'; Source = '$value = ''x''; Write-Host "$($value + ''!'')"' }
            @{ Name = 'member access'; FileName = 'member.ps1'; Source = '$value = ''x''; $length = $value.Length; Write-Host $length' }
            @{ Name = 'a command assignment'; FileName = 'command-assignment.ps1'; Source = '$value = Get-Date; Write-Host $value' }
            @{ Name = 'control flow'; FileName = 'control-flow.ps1'; Source = 'if ($true) { Write-Host ''x'' }' }
            @{ Name = 'a compound assignment'; FileName = 'compound-assignment.ps1'; Source = '$value = ''x''; $value += ''y''; Write-Host $value' }
            @{ Name = 'a repeated assignment'; FileName = 'repeated-assignment.ps1'; Source = '$value = ''x''; $value = ''y''; Write-Host $value' }
            @{ Name = 'an array expression'; FileName = 'array.ps1'; Source = '$value = @(''x''); Write-Host $value' }
            @{ Name = 'an unsupported cast'; FileName = 'cast.ps1'; Source = '$value = [int]27; Write-Host $value' }
            @{ Name = 'output redirection'; FileName = 'redirection.ps1'; Source = 'Write-Host ''x'' > output.txt' }
            @{ Name = 'Write-Host parameters'; FileName = 'parameters.ps1'; Source = 'Write-Host -ForegroundColor Red ''x''' }
            @{ Name = 'an invocation operator'; FileName = 'invocation.ps1'; Source = '& Write-Host ''x''' }
            @{ Name = 'a param block'; FileName = 'param.ps1'; Source = 'param([string]$value); Write-Host ''x''' }
            @{ Name = 'a pipeline'; FileName = 'pipeline.ps1'; Source = '''x'' | Write-Host' }
            @{ Name = 'assignment after output starts'; FileName = 'late-assignment.ps1'; Source = 'Write-Host ''x''; $value = ''y''' }
            @{ Name = 'ambiguous escaped interpolation'; FileName = 'escaped-interpolation.ps1'; Source = '$value = ''x''; Write-Host "`$value $value"' }
        ) {
            $scriptPath = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath $FileName
            [System.IO.File]::WriteAllText($scriptPath, $Source, [System.Text.UTF8Encoding]::new($false))

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $scriptPath } {
                param($path)
                Get-StaticColorScriptOutput -ScriptPath $path
            }

            $result.Available | Should -BeFalse
            $result.Content | Should -BeExactly ''
        }
    }

    Context 'Bundled-script regressions' {
        It 'matches isolated PowerShell execution byte-for-byte for <Name>' -ForEach @(
            @{ Name = 'debian' }
            @{ Name = 'bars' }
            @{ Name = 'pacman' }
            @{ Name = 'bloks' }
            @{ Name = 'tiefighter1' }
        ) {
            $scriptPath = Join-Path -Path $script:ModuleRoot -ChildPath ("Scripts/{0}.ps1" -f $Name)

            $comparison = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $scriptPath } {
                param($path)

                [pscustomobject]@{
                    Static = Get-StaticColorScriptOutput -ScriptPath $path
                    Child  = Invoke-ColorScriptProcess -ScriptPath $path -ForCache
                }
            }

            $comparison.Static.Available | Should -BeTrue
            $comparison.Child.Success | Should -BeTrue
            $comparison.Child.StdErr | Should -BeExactly ''
            $comparison.Static.Content | Should -BeExactly $comparison.Child.StdOut
        }

        It 'locks the current corpus classification and known unsafe exceptions' {
            $classification = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:ModuleRoot } {
                param($root)

                $scriptFiles = @(Get-ChildItem -LiteralPath (Join-Path -Path $root -ChildPath 'Scripts') -Filter '*.ps1' -File)
                $available = @($scriptFiles | Where-Object {
                        (Get-StaticColorScriptOutput -ScriptPath $_.FullName).Available
                    })
                $exceptions = foreach ($name in @('elfman', 'panes', 'syl-k7')) {
                    $path = Join-Path -Path $root -ChildPath ("Scripts/{0}.ps1" -f $name)
                    [pscustomobject]@{
                        Name      = $name
                        Available = (Get-StaticColorScriptOutput -ScriptPath $path).Available
                    }
                }

                [pscustomobject]@{
                    Total       = $scriptFiles.Count
                    Available   = $available.Count
                    Unavailable = $scriptFiles.Count - $available.Count
                    Exceptions  = @($exceptions)
                }
            }

            $classification.Total | Should -Be 3156
            $classification.Available | Should -Be 2995
            $classification.Unavailable | Should -Be 161
            @($classification.Exceptions | Where-Object Available).Count | Should -Be 0
        }
    }
}
