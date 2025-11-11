Describe 'Gap-filler coverage for cache and output helpers' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleManifest = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force

        # Safe temp cache root
        $script:TempRoot = Join-Path (Resolve-Path 'TestDrive:\').ProviderPath ([guid]::NewGuid().ToString())
        New-Item -ItemType Directory -Path $script:TempRoot -Force | Out-Null
        $script:CacheRoot = Join-Path $script:TempRoot 'Cache'
        New-Item -ItemType Directory -Path $script:CacheRoot -Force | Out-Null

        # Redirect module cache/config to TestDrive
        InModuleScope ColorScripts-Enhanced -Parameters @{ r = $script:CacheRoot } {
            param($r)
            $script:CacheDir = $r
            $script:CacheInitialized = $true
        }
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context 'Remove-ColorScriptAnsiSequence' {
        It 'returns same value when null (empty string) and strips ANSI when present' {
            InModuleScope ColorScripts-Enhanced {
                # Parameter binding may coerce null to empty string for [string] parameters; accept null or empty
                $nullResult = Remove-ColorScriptAnsiSequence -Text $null
                $nullResult | Should -BeNullOrEmpty
                $esc = [char]27
                $text = "${esc}[31mRed${esc}[0m plain"
                $stripped = Remove-ColorScriptAnsiSequence -Text $text
                $stripped | Should -Be 'Red plain'
            }
        }
    }

    Context 'Get-CachedOutput branch coverage' {
        It 'returns unavailable for whitespace path and for unset cache dir' {
            InModuleScope ColorScripts-Enhanced {
                (Get-CachedOutput -ScriptPath '   ').Available | Should -BeFalse
                $old = $script:CacheDir; $script:CacheDir = $null
                try { (Get-CachedOutput -ScriptPath 'X:\fake\script.ps1').Available | Should -BeFalse }
                finally { $script:CacheDir = $old }
            }
        }

        It 'returns unavailable when script missing or cache missing' {
            InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:CacheRoot } {
                param($root)
                $scriptName = 'demo'
                $scriptPath = Join-Path $root 'demo.ps1'
                if (Test-Path $scriptPath) { Remove-Item $scriptPath -Force }
                (Get-CachedOutput -ScriptPath $scriptPath).Available | Should -BeFalse

                New-Item -ItemType File -Path $scriptPath -Force | Out-Null
                $result = Get-CachedOutput -ScriptPath $scriptPath
                $result.Available | Should -BeFalse
                $result.CacheFile | Should -Not -BeNullOrEmpty
            }
        }

        It 'returns stale when script newer than cache and available when fresh' {
            InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:CacheRoot } {
                param($root)
                $scriptPath = Join-Path $root 'fresh.ps1'
                $cachePath = Join-Path $root 'fresh.cache'
                Set-Content -Path $scriptPath -Value 'Write-Host ok' -Encoding utf8
                Set-Content -Path $cachePath -Value 'cached' -Encoding utf8
                # Make cache older
                (Get-Item $cachePath).LastWriteTimeUtc = (Get-Date).ToUniversalTime().AddMinutes(-5)
                (Get-Item $scriptPath).LastWriteTimeUtc = (Get-Date).ToUniversalTime()

                $stale = Get-CachedOutput -ScriptPath $scriptPath
                $stale.Available | Should -BeFalse

                # Make cache newer
                (Get-Item $cachePath).LastWriteTimeUtc = (Get-Date).ToUniversalTime().AddMinutes(5)
                $content = Get-CachedOutput -ScriptPath $scriptPath
                $content.Available | Should -BeTrue
                $content.Content.Trim() | Should -Be 'cached'
            }
        }

        It 'handles file delegates throwing (verbose path) and read error' {
            InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:CacheRoot } {
                param($root)
                $scriptPath = Join-Path $root 'throwing.ps1'
                Set-Content -Path $scriptPath -Value 'noop' -Encoding utf8
                $cachePath = Join-Path $root 'throwing.cache'
                Set-Content -Path $cachePath -Value 'data' -Encoding utf8

                $oldExists = $script:FileExistsDelegate
                $oldRead = $script:FileReadAllTextDelegate
                try {
                    $script:FileExistsDelegate = { param($p) $null = $p; throw 'boom' }
                    (Get-CachedOutput -ScriptPath $scriptPath).Available | Should -BeFalse

                    $script:FileExistsDelegate = { param($p) Test-Path -LiteralPath $p }
                    $script:FileReadAllTextDelegate = { param($p, $enc) $null = $p; $null = $enc; throw 'readfail' }
                    $result = Get-CachedOutput -ScriptPath $scriptPath
                    $result.Available | Should -BeFalse
                    $result.CacheFile | Should -Be $cachePath
                }
                finally {
                    $script:FileExistsDelegate = $oldExists
                    $script:FileReadAllTextDelegate = $oldRead
                }
            }
        }
    }

    Context 'Invoke-ColorScriptCacheOperation failure and success' {
        It 'captures thrown Build-ScriptCache and formats failure record' {
            InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:CacheRoot } {
                param($root)
                $scriptPath = Join-Path $root 'op.ps1'
                Set-Content -Path $scriptPath -Value 'noop' -Encoding utf8
                Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith { throw 'compile fail' }
                $op = Invoke-ColorScriptCacheOperation -ScriptName 'op' -ScriptPath $scriptPath
                $op.Failed | Should -Be 1
                $op.Result.Status | Should -Be 'Failed'
                $op.Result.CacheExists | Should -BeFalse
                $op.Warning | Should -Match 'Failed to cache'
            }
        }

        It 'captures success from Build-ScriptCache' {
            InModuleScope ColorScripts-Enhanced -Parameters @{ root = $script:CacheRoot } {
                param($root)
                $scriptPath = Join-Path $root 'ok.ps1'
                $cachePath = Join-Path $root 'ok.cache'
                Set-Content -Path $scriptPath -Value 'noop' -Encoding utf8
                Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{ ScriptName = 'ok'; CacheFile = $cachePath; Success = $true; ExitCode = 0; StdOut = 'X'; StdErr = '' }
                }
                $op = Invoke-ColorScriptCacheOperation -ScriptName 'ok' -ScriptPath $scriptPath
                $op.Updated | Should -Be 1
                $op.Result.Status | Should -Be 'Updated'
                $op.Result.CacheExists | Should -BeTrue
            }
        }
    }
}
