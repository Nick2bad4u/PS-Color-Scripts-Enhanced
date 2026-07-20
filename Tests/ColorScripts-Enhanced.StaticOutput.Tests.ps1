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
            $unicodeMarker = [string][char]0x25AC
            $source = @(
                '$esc = [char]27'
                '$red = "$esc[31m"'
                '$reset = "$esc[0m"'
                '$line = "${RED}red$($reset)"'
                '$copy = $line'
                '$tail = ''done'' + ''?'''
                ('Write-Host "$copy{0}"' -f $unicodeMarker)
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
                "$escape[31mred$escape[0m$unicodeMarker"
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
        BeforeAll {
            $baselinePath = Join-Path -Path $script:RepoRoot -ChildPath 'Tests/Fixtures/FlattenedColorScriptBaselines.psd1'
            $baseline = Import-PowerShellDataFile -Path $baselinePath
            $encoding = [System.Text.UTF8Encoding]::new($false)
            $script:BundledCorpusAudit = InModuleScope ColorScripts-Enhanced -Parameters @{
                root     = $script:ModuleRoot
                baseline = $baseline
                encoding = $encoding
            } {
                param($root, $baseline, $encoding)

                $scriptFiles = @(Get-ChildItem -LiteralPath (Join-Path -Path $root -ChildPath 'Scripts') -Filter '*.ps1' -File)
                $availableCount = 0
                $unavailableNames = [System.Collections.Generic.List[string]]::new()
                $baselineFailures = [System.Collections.Generic.List[object]]::new()
                $baselineChecked = 0

                foreach ($scriptFile in $scriptFiles) {
                    $static = Get-StaticColorScriptOutput -ScriptPath $scriptFile.FullName
                    if ($static.Available) {
                        $availableCount++
                    }
                    else {
                        $unavailableNames.Add($scriptFile.BaseName)
                    }

                    if (-not $baseline.Scripts.ContainsKey($scriptFile.BaseName)) {
                        continue
                    }

                    $baselineChecked++
                    $normalized = $static.Content.Replace("`r`n", "`n").Replace("`r", "`n")
                    $sha256 = [System.Security.Cryptography.SHA256]::Create()
                    try {
                        $hash = ([System.BitConverter]::ToString(
                                $sha256.ComputeHash($encoding.GetBytes($normalized))
                            )).Replace('-', '')
                    }
                    finally {
                        $sha256.Dispose()
                    }

                    $expected = $baseline.Scripts[$scriptFile.BaseName]
                    if (-not $static.Available -or
                        $hash -cne $expected.Sha256 -or
                        $encoding.GetByteCount($normalized) -ne $expected.Utf8Bytes) {
                        $baselineFailures.Add([pscustomobject]@{
                                Name      = $scriptFile.BaseName
                                Available = $static.Available
                                Sha256    = $hash
                                Utf8Bytes = $encoding.GetByteCount($normalized)
                            })
                    }
                }

                $dynamicPolicy = Import-PowerShellDataFile -Path (Join-Path -Path $root -ChildPath 'DynamicRenderPolicy.psd1')
                [pscustomobject]@{
                    Total              = $scriptFiles.Count
                    Available          = $availableCount
                    Unavailable        = $scriptFiles.Count - $availableCount
                    UnavailableNames   = @($unavailableNames | Sort-Object)
                    DynamicPolicyNames = @($dynamicPolicy.DynamicScripts | Sort-Object)
                    BaselineSchema     = $baseline.SchemaVersion
                    BaselineLineEndings = $baseline.LineEndings
                    BaselineCount      = $baseline.Scripts.Count
                    BaselineChecked    = $baselineChecked
                    BaselineFailures   = $baselineFailures.ToArray()
                }
            }
        }

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

        It 'matches every generated deterministic-output baseline' {
            $script:BundledCorpusAudit.BaselineSchema | Should -Be 1
            $script:BundledCorpusAudit.BaselineLineEndings | Should -BeExactly 'LF'
            $script:BundledCorpusAudit.BaselineCount | Should -Be 134
            $script:BundledCorpusAudit.BaselineChecked | Should -Be 134
            @($script:BundledCorpusAudit.BaselineFailures) | Should -BeNullOrEmpty
        }

        It 'locks the corpus to static output plus the explicit dynamic policy' {
            $script:BundledCorpusAudit.Total | Should -Be 3156
            $script:BundledCorpusAudit.Available | Should -Be 3139
            $script:BundledCorpusAudit.Unavailable | Should -Be 17
            Compare-Object $script:BundledCorpusAudit.DynamicPolicyNames $script:BundledCorpusAudit.UnavailableNames | Should -BeNullOrEmpty
        }

        It 'preserves repaired special-script output without executable side effects' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:ModuleRoot } {
                param($root)

                $sylResults = foreach ($path in Get-ChildItem -LiteralPath (Join-Path $root 'Scripts') -Filter 'syl-*.ps1') {
                    Get-StaticColorScriptOutput -ScriptPath $path.FullName
                }
                $kevinPath = Join-Path $root 'Scripts/kevin-woods.ps1'
                $kevinSource = [System.IO.File]::ReadAllText($kevinPath)
                $kevin = Get-StaticColorScriptOutput -ScriptPath $kevinPath
                $rainbow = Get-StaticColorScriptOutput -ScriptPath (Join-Path $root 'Scripts/pukeskull-rainbow.ps1')

                [pscustomobject]@{
                    SylAvailable       = @($sylResults | Where-Object Available).Count
                    SylWithAnsi        = @($sylResults | Where-Object { $_.Content.Contains([string][char]27) }).Count
                    SylWithSignatures  = @($sylResults | Where-Object { $_.Content -cmatch '\$[yY][lL]' }).Count
                    KevinAvailable     = $kevin.Available
                    KevinOccurrences   = ([regex]::Matches($kevin.Content, 'Kevin Woods:')).Count
                    KevinHasAnsi       = $kevin.Content.Contains([string][char]27)
                    KevinHasStateCalls = $kevinSource -match 'Add-Type|Kernel32|SetConsoleMode|GetConsoleMode'
                    RainbowAvailable   = $rainbow.Available
                    RainbowColors      = ([regex]::Matches($rainbow.Content, [regex]::Escape([string][char]27) + '\[[^m]*m')).Count
                }
            }

            $result.SylAvailable | Should -Be 8
            $result.SylWithAnsi | Should -Be 8
            $result.SylWithSignatures | Should -Be 8
            $result.KevinAvailable | Should -BeTrue
            $result.KevinOccurrences | Should -Be 1
            $result.KevinHasAnsi | Should -BeTrue
            $result.KevinHasStateCalls | Should -BeFalse
            $result.RainbowAvailable | Should -BeTrue
            $result.RainbowColors | Should -BeGreaterThan 20
        }
    }
}
