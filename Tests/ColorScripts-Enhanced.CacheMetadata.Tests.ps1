Describe 'Cache metadata coverage' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRootPath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ModuleManifest = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
        Import-Module -Name $script:ModuleManifest -Force
    }

    AfterAll {
        Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    Context 'Get-FileContentSignature' {
        It 'returns metadata with hash when IncludeHash is requested' {
            $testFile = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'signature.txt'
            Set-Content -LiteralPath $testFile -Value 'hash-me' -Encoding utf8

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ path = $testFile } {
                param($path)
                Get-FileContentSignature -Path $path -IncludeHash
            }

            $result.Path | Should -Be (Resolve-Path -LiteralPath $testFile).ProviderPath
            $result.Length | Should -Be ([System.IO.File]::ReadAllBytes($testFile).Length)
            $result.Hash | Should -Match '^[0-9a-f]{64}$'
            $result.HashAlgorithm | Should -Be 'SHA256'
        }

        It 'throws when the file does not exist' {
            $missing = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'missing.bin'
            InModuleScope ColorScripts-Enhanced -Parameters @{ path = $missing } {
                param($path)
                { Get-FileContentSignature -Path $path } | Should -Throw -ExceptionType ([System.IO.FileNotFoundException])
            }
        }
    }

    Context 'Cache entry metadata helpers' {
        It 'resolves metadata path using cache root and override' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'Cache'
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null

            $paths = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot } {
                param($root)
                $script:CacheDir = $root
                [pscustomobject]@{
                    Default = Get-CacheEntryMetadataPath -ScriptName 'alpha'
                    Override = Get-CacheEntryMetadataPath -ScriptName 'beta' -CacheRoot (Join-Path $root 'nested')
                }
            }

            $paths.Default | Should -Be (Join-Path -Path $cacheRoot -ChildPath 'alpha.cacheinfo')
            $paths.Override | Should -Be (Join-Path -Path (Join-Path $cacheRoot 'nested') -ChildPath 'beta.cacheinfo')
        }

        It 'removes existing metadata files' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'CacheRemove'
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
            $metadataPath = Join-Path -Path $cacheRoot -ChildPath 'gamma.cacheinfo'
            Set-Content -LiteralPath $metadataPath -Value '{ }'

            InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot } {
                param($root)
                Remove-CacheEntryMetadataFile -ScriptName 'gamma' -CacheRoot $root
            }

            Test-Path -LiteralPath $metadataPath | Should -BeFalse
        }

        It 'writes metadata payload that mirrors the signature' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'CacheWrite'
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
            $signature = [pscustomobject]@{
                Path             = Join-Path -Path $cacheRoot -ChildPath 'delta.ps1'
                Length           = 42
                LastWriteTime    = (Get-Date)
                LastWriteTimeUtc = (Get-Date).ToUniversalTime()
                Hash             = 'abc123'
                HashAlgorithm    = 'SHA256'
            }

            InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot; sig = $signature } {
                param($root, $sig)
                $script:CacheDir = $root
                Write-CacheEntryMetadataFile -ScriptName 'delta' -Signature $sig -CacheFile (Join-Path $root 'delta.cache') -ModuleVersionOverride '9.9.9'
            }

            $metadataPath = Join-Path -Path $cacheRoot -ChildPath 'delta.cacheinfo'
            $metadata = Get-Content -LiteralPath $metadataPath -Raw | ConvertFrom-Json -Depth 5
            $metadata.ScriptHash | Should -Be 'abc123'
            $metadata.ScriptLength | Should -Be 42
            $metadata.ModuleVersion | Should -Be '9.9.9'

            $rawTimestamp = $metadata.ScriptLastWriteTimeUtc
            $parsedTimestamp = if ($rawTimestamp -is [datetime]) {
                $rawTimestamp.ToUniversalTime()
            }
            elseif (-not [string]::IsNullOrWhiteSpace($rawTimestamp)) {
                [datetime]::ParseExact([string]$rawTimestamp, 'o', [System.Globalization.CultureInfo]::InvariantCulture)
            }
            else {
                $null
            }

            $parsedTimestamp | Should -Be ($signature.LastWriteTimeUtc.ToUniversalTime())
        }
    }

    Context 'Build-ScriptCache metadata integration' {
        It 'writes cache metadata when build succeeds' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'CacheBuildSuccess'
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
            $scriptPath = Join-Path -Path $cacheRoot -ChildPath 'success.ps1'
            Set-Content -LiteralPath $scriptPath -Value 'Write-Host "ok"'

            $outcome = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot; scriptPath = $scriptPath } {
                param($root, $scriptPath)
                $script:CacheDir = $root
                $script:CacheInitialized = $true
                Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{ ScriptName = 'success'; StdOut = 'cached'; StdErr = ''; ExitCode = 0; Success = $true }
                }

                $result = Build-ScriptCache -ScriptPath $scriptPath
                $metadataPath = Join-Path -Path $root -ChildPath 'success.cacheinfo'
                [pscustomobject]@{
                    Result = $result
                    MetadataExists = Test-Path -LiteralPath $metadataPath
                    Metadata = if (Test-Path -LiteralPath $metadataPath) { Get-Content -LiteralPath $metadataPath -Raw | ConvertFrom-Json -Depth 5 } else { $null }
                }
            }

            $outcome.Result.Success | Should -BeTrue
            $outcome.MetadataExists | Should -BeTrue
            $outcome.Metadata.ScriptHash | Should -Not -BeNullOrEmpty
            $outcome.Metadata.CacheFile | Should -Be 'success.cache'
        }

        It 'handles write failures and cleans up metadata' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'CacheBuildFailure'
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
            $scriptPath = Join-Path -Path $cacheRoot -ChildPath 'fail.ps1'
            Set-Content -LiteralPath $scriptPath -Value 'Write-Host "oops"'

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot; scriptPath = $scriptPath } {
                param($root, $scriptPath)
                $script:CacheDir = $root
                $script:CacheInitialized = $true
                Mock -CommandName Invoke-ColorScriptProcess -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{ ScriptName = 'fail'; StdOut = 'cached'; StdErr = ''; ExitCode = 0; Success = $true }
                }
                Mock -CommandName Invoke-FileWriteAllText -ModuleName ColorScripts-Enhanced -MockWith { throw 'write failed' }

                Build-ScriptCache -ScriptPath $scriptPath
            }

            $result.Success | Should -BeFalse
            $result.StdErr | Should -Be 'write failed'
            Test-Path -LiteralPath (Join-Path -Path $cacheRoot -ChildPath 'fail.cacheinfo') | Should -BeFalse
        }
    }

    Context 'Invoke-ColorScriptCacheOperation behaviors' {
        BeforeEach {
            InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/Invoke-ColorScriptCacheOperation.ps1')
                $script:CacheDir = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
                $script:CacheInitialized = $true
                $script:OriginalMessages = $script:Messages
                $script:Messages = @{
                    CacheOperationInitializationFailed = 'Unable to initialize the cache directory: {0}'
                    StatusCached                      = 'Cached'
                    ScriptExitedWithCode              = 'Script exited with code {0}.'
                    CacheBuildGenericFailure          = 'Cache build failed.'
                    CacheBuildFailedForScript         = 'Cache build failed for {0}: {1}'
                    CacheOperationWarning             = "Failed to cache '{0}': {1}"
                }
            }
        }

        AfterEach {
            InModuleScope ColorScripts-Enhanced {
                $script:Messages = $script:OriginalMessages
                Remove-Variable -Name OriginalMessages -Scope Script -ErrorAction SilentlyContinue
            }
        }

        It 'returns failure result when cache initialization fails' {
            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/Invoke-ColorScriptCacheOperation.ps1')
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { throw 'init failed' }
                $script:CacheDir = $null
                Invoke-ColorScriptCacheOperation -ScriptName 'alpha' -ScriptPath 'TestDrive:\alpha.ps1'
            }

            $result.Failed | Should -Be 1
            $result.Result.Status | Should -Be 'Failed'
            $result.Warning | Should -Match 'init failed'
        }

        It 'returns success when Build-ScriptCache succeeds' {
            $info = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/Invoke-ColorScriptCacheOperation.ps1')
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced
                Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        ScriptName = 'beta'
                        CacheFile  = Join-Path $script:CacheDir 'beta.cache'
                        Success    = $true
                        ExitCode   = 0
                        StdOut     = 'cached beta'
                        StdErr     = ''
                    }
                }

                Invoke-ColorScriptCacheOperation -ScriptName 'beta' -ScriptPath 'TestDrive:\beta.ps1'
            }

            $info.Updated | Should -Be 1
            $info.Result.Status | Should -Be 'Updated'
            $info.Result.CacheExists | Should -BeTrue
        }

        It 'captures exceptions from Build-ScriptCache and reports failure' {
            $info = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/Invoke-ColorScriptCacheOperation.ps1')
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced
                Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith { throw 'boom' }

                Invoke-ColorScriptCacheOperation -ScriptName 'gamma' -ScriptPath 'TestDrive:\gamma.ps1'
            }

            $info.Failed | Should -Be 1
            $info.Result.Status | Should -Be 'Failed'
            $info.Result.StdErr | Should -Be 'boom'
        }

        It 'surfaces exit code failures when StdErr is empty and emits warnings' {
            $info = InModuleScope ColorScripts-Enhanced -Parameters @{ moduleRoot = $script:ModuleRootPath } {
                param($moduleRoot)
                . (Join-Path -Path $moduleRoot -ChildPath 'Private/Invoke-ColorScriptCacheOperation.ps1')
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced
                Mock -CommandName Build-ScriptCache -ModuleName ColorScripts-Enhanced -MockWith {
                    [pscustomobject]@{
                        ScriptName = 'delta'
                        CacheFile  = Join-Path $script:CacheDir 'delta.cache'
                        Success    = $false
                        ExitCode   = 42
                        StdOut     = ''
                        StdErr     = ''
                    }
                }

                Invoke-ColorScriptCacheOperation -ScriptName 'delta' -ScriptPath 'TestDrive:\delta.ps1'
            }

            $info.Failed | Should -Be 1
            $info.Result.Status | Should -Be 'Failed'
            $info.Warning | Should -Match '42'
            $info.Result.StdErr | Should -Be ''
        }
    }

    Context 'Get-CachedOutput metadata validation' {
        It 'returns cached output when metadata is current' {
            $result = InModuleScope ColorScripts-Enhanced {
                $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
                $scriptPath = Join-Path -Path $cacheRoot -ChildPath 'current.ps1'
                Set-Content -LiteralPath $scriptPath -Value "Write-Host 'ok'" -Encoding UTF8
                $cacheFile = Join-Path -Path $cacheRoot -ChildPath 'current.cache'
                Set-Content -LiteralPath $cacheFile -Value 'cached ok' -Encoding UTF8
                $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($scriptPath)
                $script:CacheDir = $cacheRoot
                $script:CacheInitialized = $true
                $signature = Get-FileContentSignature -Path $scriptPath -IncludeHash
                Write-CacheEntryMetadataFile -ScriptName $scriptName -Signature $signature -CacheFile $cacheFile

                Get-CachedOutput -ScriptPath $scriptPath
            }

            $result.Available | Should -BeTrue
            $result.Content.Trim() | Should -Be 'cached ok'
        }

        It 'returns unavailable when cache directory initialization fails' {
            $state = InModuleScope ColorScripts-Enhanced {
                $script:CacheDir = $null
                Mock -CommandName Initialize-CacheDirectory -ModuleName ColorScripts-Enhanced -MockWith { throw 'init failed' }
                Get-CachedOutput -ScriptPath 'TestDrive:\missing.ps1'
            }

            $state.Available | Should -BeFalse
            $state.CacheFile | Should -BeNullOrEmpty
        }

        It 'rejects metadata with mismatched version' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'CacheMetaVersion'
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
            $scriptPath = Join-Path -Path $cacheRoot -ChildPath 'version.ps1'
            Set-Content -LiteralPath $scriptPath -Value 'Write-Host "version"'
            $cachePath = Join-Path -Path $cacheRoot -ChildPath 'version.cache'
            Set-Content -LiteralPath $cachePath -Value 'cached version'
            $metadataPath = Join-Path -Path $cacheRoot -ChildPath 'version.cacheinfo'
            $metadata = [pscustomobject]@{
                Version               = 99
                CacheFile             = 'version.cache'
                ModuleVersion         = '1.0'
                CacheGeneratedUtc     = (Get-Date).ToUniversalTime().ToString('o')
                LastValidatedUtc      = (Get-Date).ToUniversalTime().ToString('o')
                ScriptLength          = (Get-Item -LiteralPath $scriptPath).Length
                ScriptHash            = 'deadbeef'
                ScriptHashAlgorithm   = 'SHA256'
                ScriptLastWriteTimeUtc = (Get-Item -LiteralPath $scriptPath).LastWriteTimeUtc.ToString('o')
            }
            $metadata | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $metadataPath

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot; scriptPath = $scriptPath } {
                param($root, $scriptPath)
                $script:CacheDir = $root
                $script:CacheInitialized = $true
                Get-CachedOutput -ScriptPath $scriptPath
            }

            $result.Available | Should -BeFalse
        }

        It 'rejects metadata when hash algorithm differs' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'CacheMetaAlgo'
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
            $scriptPath = Join-Path -Path $cacheRoot -ChildPath 'algo.ps1'
            Set-Content -LiteralPath $scriptPath -Value 'Write-Host "algo"'
            $cachePath = Join-Path -Path $cacheRoot -ChildPath 'algo.cache'
            Set-Content -LiteralPath $cachePath -Value 'cached algo'
            $metadataPath = Join-Path -Path $cacheRoot -ChildPath 'algo.cacheinfo'
            $metadata = [pscustomobject]@{
                Version               = 1
                CacheFile             = 'algo.cache'
                ModuleVersion         = '1.0'
                CacheGeneratedUtc     = (Get-Date).ToUniversalTime().ToString('o')
                LastValidatedUtc      = (Get-Date).ToUniversalTime().ToString('o')
                ScriptLength          = (Get-Item -LiteralPath $scriptPath).Length
                ScriptHash            = 'cafebabe'
                ScriptHashAlgorithm   = 'SHA1'
                ScriptLastWriteTimeUtc = (Get-Item -LiteralPath $scriptPath).LastWriteTimeUtc.ToString('o')
            }
            $metadata | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $metadataPath

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot; scriptPath = $scriptPath } {
                param($root, $scriptPath)
                $script:CacheDir = $root
                $script:CacheInitialized = $true
                Get-CachedOutput -ScriptPath $scriptPath
            }

            $result.Available | Should -BeFalse
        }

        It 'rejects metadata when computed hash differs' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'CacheMetaHash'
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
            $scriptPath = Join-Path -Path $cacheRoot -ChildPath 'hash.ps1'
            Set-Content -LiteralPath $scriptPath -Value 'Write-Host "hash"'
            $cachePath = Join-Path -Path $cacheRoot -ChildPath 'hash.cache'
            Set-Content -LiteralPath $cachePath -Value 'cached hash'
            $metadataPath = Join-Path -Path $cacheRoot -ChildPath 'hash.cacheinfo'
            $metadata = [pscustomobject]@{
                Version               = 1
                CacheFile             = 'hash.cache'
                ModuleVersion         = '1.0'
                CacheGeneratedUtc     = (Get-Date).ToUniversalTime().ToString('o')
                LastValidatedUtc      = (Get-Date).ToUniversalTime().ToString('o')
                ScriptLength          = 999 # mismatch
                ScriptHash            = 'ffffffff'
                ScriptHashAlgorithm   = 'SHA256'
                ScriptLastWriteTimeUtc = (Get-Item -LiteralPath $scriptPath).LastWriteTimeUtc.ToString('o')
            }
            $metadata | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $metadataPath

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot; scriptPath = $scriptPath } {
                param($root, $scriptPath)
                $script:CacheDir = $root
                $script:CacheInitialized = $true
                Get-CachedOutput -ScriptPath $scriptPath
            }

            $result.Available | Should -BeFalse
        }

        It 'invalidates metadata when script length changes' {
            $result = InModuleScope ColorScripts-Enhanced {
                $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath ([guid]::NewGuid().ToString())
                New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
                $scriptPath = Join-Path -Path $cacheRoot -ChildPath 'length.ps1'
                Set-Content -LiteralPath $scriptPath -Value "Write-Host 'length'" -Encoding UTF8
                $cacheFile = Join-Path -Path $cacheRoot -ChildPath 'length.cache'
                Set-Content -LiteralPath $cacheFile -Value 'cached length'
                $signature = Get-FileContentSignature -Path $scriptPath -IncludeHash
                $script:CacheDir = $cacheRoot
                $script:CacheInitialized = $true
                Write-CacheEntryMetadataFile -ScriptName 'length' -Signature $signature -CacheFile $cacheFile
                Add-Content -LiteralPath $scriptPath -Value '#changed'
                Get-CachedOutput -ScriptPath $scriptPath
            }

            $result.Available | Should -BeFalse
        }

        It 'refreshes metadata when only last write time changes' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'CacheMetaTimestamp'
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
            $scriptPath = Join-Path -Path $cacheRoot -ChildPath 'ts.ps1'
            Set-Content -LiteralPath $scriptPath -Value "Write-Host 'ts'" -Encoding UTF8
            $cachePath = Join-Path -Path $cacheRoot -ChildPath 'ts.cache'
            Set-Content -LiteralPath $cachePath -Value 'cached ts'
            $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($scriptPath)

            $result = InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot; scriptPath = $scriptPath; cacheFile = $cachePath; scriptName = $scriptName } {
                param($root, $scriptPath, $cacheFile, $scriptName)
                $script:CacheDir = $root
                $script:CacheInitialized = $true
                $signature = Get-FileContentSignature -Path $scriptPath -IncludeHash
                Write-CacheEntryMetadataFile -ScriptName $scriptName -Signature $signature -CacheFile $cacheFile
                $newTimestamp = (Get-Date).AddMinutes(10)
                [System.IO.File]::SetLastWriteTimeUtc($scriptPath, $newTimestamp)
                Get-CachedOutput -ScriptPath $scriptPath
            }

            $result.Available | Should -BeTrue
        }
    }

    Context 'Ensure-CacheFormatVersion cleanup' {
        It 'removes cache and metadata files when updating format version' {
            $cacheRoot = Join-Path -Path (Resolve-Path -LiteralPath 'TestDrive:\').ProviderPath -ChildPath 'CacheFormat'
            New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null
            $cachePath = Join-Path -Path $cacheRoot -ChildPath 'theta.cache'
            Set-Content -LiteralPath $cachePath -Value 'orphan cache'
            $metadataPath = Join-Path -Path $cacheRoot -ChildPath 'theta.cacheinfo'
            Set-Content -LiteralPath $metadataPath -Value '{ }'

            InModuleScope ColorScripts-Enhanced -Parameters @{ root = $cacheRoot } {
                param($root)
                Update-CacheFormatVersion -CacheDirectory $root -MetadataFileName 'cache-metadata-v1.json'
            }

            Test-Path -LiteralPath $cachePath | Should -BeFalse
            Test-Path -LiteralPath $metadataPath | Should -BeFalse
            Test-Path -LiteralPath (Join-Path -Path $cacheRoot -ChildPath 'cache-metadata-v1.json') | Should -BeTrue
        }
    }
}
