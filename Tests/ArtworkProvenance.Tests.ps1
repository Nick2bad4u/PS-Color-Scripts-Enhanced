Describe 'Curated ANSI artwork provenance' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ScriptsRoot = Join-Path -Path $script:ModuleRoot -ChildPath 'Scripts'
        $script:ProvenancePath = Join-Path -Path $script:ModuleRoot -ChildPath 'ArtworkProvenance.psd1'
        # The trusted, checked-in provenance map intentionally exceeds
        # Import-PowerShellDataFile's conservative default AST-size limit.
        $script:Provenance = Import-PowerShellDataFile -Path $script:ProvenancePath -SkipLimitCheck
        $script:ImportedPrefixes = @('16c-', 'asciiville-', 'botany-', 'durdraw-', 'os-ansi-', 'roy-sac-')
        $script:ImportedScriptFiles = @(Get-ChildItem -LiteralPath $script:ScriptsRoot -File -Filter '*.ps1' | Where-Object {
                $name = $_.BaseName
                @($script:ImportedPrefixes | Where-Object { $name.StartsWith($_, [System.StringComparison]::OrdinalIgnoreCase) }).Count -gt 0
            })
        Import-Module -Name (Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1') -Force
    }

    AfterAll {
        Remove-Module -Name ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
    }

    It 'declares a valid collection for every imported script without orphan mappings' {
        $script:Provenance.SchemaVersion | Should -Be 2
        @($script:Provenance.Collections.Keys) | Should -HaveCount 6
        @($script:Provenance.Scripts.Keys) | Should -HaveCount $script:ImportedScriptFiles.Count

        $mappedNames = @($script:Provenance.Scripts.Keys | Sort-Object)
        $checkedInNames = @($script:ImportedScriptFiles.BaseName | Sort-Object)
        Compare-Object -ReferenceObject $mappedNames -DifferenceObject $checkedInNames | Should -BeNullOrEmpty

        foreach ($scriptName in $mappedNames) {
            $entry = $script:Provenance.Scripts[$scriptName]
            $script:Provenance.Collections.ContainsKey($entry.Collection) | Should -BeTrue -Because "the '$scriptName' collection must exist"
            $entry.SourceFile | Should -Not -BeNullOrEmpty
            $entry.SourceUrl | Should -Match '^https://[^\s]+$'
            $entry.SourceSha256 | Should -Match '^[0-9a-f]{64}$'
            $entry.InputEncoding | Should -BeIn @('cp437', 'cp860', 'utf8')
            $entry.ConversionMode | Should -BeIn @('Passthrough', 'TerminalEmulation')

            if ($entry.Collection -eq '16colors-permitted') {
                $entry.OriginalFilename | Should -Not -BeNullOrEmpty
                $entry.Format | Should -BeIn @('ANS', 'ICE')
                $entry.ArchiveUrl | Should -Match '^https://16colo\.rs/archive/'
                if ($entry.MetadataSource -eq '16colors-archive-recovery') {
                    $entry.SourceUrl | Should -Be $entry.ArchiveUrl
                    $entry.GalleryUrl | Should -Be $entry.ArchiveUrl
                    $entry.PreviewUrl | Should -BeNullOrEmpty
                    $entry.PreviewAvailability | Should -Match '^Unavailable from 16colors;'
                }
                else {
                    $entry.SourceUrl | Should -Match '^https://16colo\.rs/pack/[^/]+/raw/'
                    $entry.GalleryUrl | Should -Match '^https://16colo\.rs/pack/'
                    $entry.PreviewUrl | Should -Match '^https://16colo\.rs/pack/[^/]+/x1/'
                }
                if ($entry.MetadataSource -eq '16colors-api-raw-fallback') {
                    $entry.ArchiveSha256 | Should -BeNullOrEmpty
                    $entry.ArchiveAvailability | Should -Match '^The official 16colors archive was unavailable'
                    $entry.SourceRevision | Should -Be "raw-sha256:$($entry.SourceSha256)"
                }
                else {
                    $entry.ArchiveSha256 | Should -Match '^[0-9a-f]{64}$'
                    $entry.ArchiveAvailability | Should -BeNullOrEmpty
                    $entry.SourceRevision | Should -Be "archive-sha256:$($entry.ArchiveSha256)"
                }
                $entry.SourceRevision | Should -Not -BeNullOrEmpty
                $entry.RenderSha256 | Should -Match '^[0-9a-f]{64}$'
                $entry.SourceRows | Should -Match '^\d+-\d+$'
                $entry.SourceColumns | Should -Match '^\d+-\d+$'
                $entry.Artist | Should -Not -BeNullOrEmpty
                $entry.Group | Should -Not -BeNullOrEmpty
                $entry.Pack | Should -Not -BeNullOrEmpty
                $hasKnownDate =
                ($null -ne $entry.ArtworkDate -and $entry.ArtworkDate -match '^\d{4}-\d{2}-\d{2}$') -or
                ($null -ne $entry.ArtworkYear -and $entry.ArtworkYear -match '^\d{4}$')
                $hasKnownDate | Should -BeTrue -Because "'$scriptName' needs the most precise available archive date"
                if ($null -ne $entry.ArtworkDate) {
                    $parsedArtworkDate = [datetime]::MinValue
                    [datetime]::TryParseExact(
                        $entry.ArtworkDate,
                        'yyyy-MM-dd',
                        [cultureinfo]::InvariantCulture,
                        [Globalization.DateTimeStyles]::None,
                        [ref]$parsedArtworkDate
                    ) | Should -BeTrue -Because "'$scriptName' must have a real calendar date"
                }
                $entry.HasSauce | Should -BeOfType ([bool])
                $entry.IceColors | Should -BeOfType ([bool])
                if ($entry.HasSauce) {
                    $entry.SauceDimensions | Should -Match '^\d+x\d+$'
                    $entry.SauceFlags | Should -BeOfType ([int])
                    $entry.SauceFont | Should -Not -BeNullOrEmpty
                }
                else {
                    $entry.SauceDimensions | Should -BeNullOrEmpty
                    $entry.SauceFlags | Should -BeNullOrEmpty
                    $entry.SauceFont | Should -BeNullOrEmpty
                }
            }
        }
    }

    It 'keeps each imported script header synchronized with the provenance manifest' {
        foreach ($scriptName in $script:Provenance.Scripts.Keys) {
            $entry = $script:Provenance.Scripts[$scriptName]
            $collection = $script:Provenance.Collections[$entry.Collection]
            $scriptPath = Join-Path -Path $script:ScriptsRoot -ChildPath "$scriptName.ps1"
            $contents = [System.IO.File]::ReadAllText($scriptPath)
            $revision = if ($null -ne $entry.SourceRevision) {
                $entry.SourceRevision
            }
            elseif ($null -ne $collection.Revision) {
                $collection.Revision
            }
            else {
                "archive-sha256:$($collection.ArchiveSha256)"
            }

            $contents | Should -Match ([regex]::Escape("# Source URL: $($entry.SourceUrl)"))
            $contents | Should -Match ([regex]::Escape("# Source Revision: $revision"))
            $contents | Should -Match ([regex]::Escape("# Source SHA-256: $($entry.SourceSha256)"))
            $contents | Should -Match ([regex]::Escape("# Source License: $($collection.License)"))
            $attribution = if ($null -ne $entry.Attribution) {
                $entry.Attribution
            }
            else {
                $collection.Attribution
            }
            $contents | Should -Match ([regex]::Escape("# Source Attribution: $attribution"))
            if ($null -ne $entry.SourceRows) {
                $contents | Should -Match ([regex]::Escape("# Lines: $($entry.SourceRows)"))
            }
            if ($null -ne $entry.SourceColumns) {
                $contents | Should -Match ([regex]::Escape("# Columns: $($entry.SourceColumns)"))
            }
            $contents | Should -Not -Match '# Conversion date:'
        }
    }

    It 'ships every referenced license or public-domain notice' {
        foreach ($collectionName in $script:Provenance.Collections.Keys) {
            $collection = $script:Provenance.Collections[$collectionName]
            $noticePath = Join-Path -Path $script:ModuleRoot -ChildPath $collection.LicenseEvidence
            Test-Path -LiteralPath $noticePath -PathType Leaf | Should -BeTrue -Because "the '$collectionName' notice must be packaged"
            (Get-Item -LiteralPath $noticePath).Length | Should -BeGreaterThan 0
        }
    }

    It 'keeps every Roy derivative under an explicit file-scoped FAL-1.3 boundary' {
        $royCollection = $script:Provenance.Collections['roy-sac']
        $royCollection.License | Should -Be 'FAL-1.3'
        $royCollection.LicenseEvidence | Should -Be 'ThirdPartyNotices/roy-sac-FAL-1.3.txt'

        $rootLicense = [System.IO.File]::ReadAllText((Join-Path -Path $script:RepoRoot -ChildPath 'LICENSE'))
        $rootLicense | Should -Match ([regex]::Escape('ColorScripts-Enhanced/Scripts/roy-sac-*.ps1'))
        $rootLicense | Should -Match 'Free Art License 1\.3'

        foreach ($scriptName in @($script:Provenance.Scripts.Keys | Where-Object { $_.StartsWith('roy-sac-', [System.StringComparison]::Ordinal) })) {
            $scriptPath = Join-Path -Path $script:ScriptsRoot -ChildPath "$scriptName.ps1"
            $contents = [System.IO.File]::ReadAllText($scriptPath)
            $contents | Should -Match '# Source License: FAL-1\.3'
            $contents | Should -Match '# Source Attribution: .*Roy/SAC aka Carsten Cumbrowski'
            $contents | Should -Match '# Source Modification: '
        }
    }

    It 'keeps every 16colors permission import outside the repository Unlicense' {
        $collection = $script:Provenance.Collections['16colors-permitted']
        $collection.License | Should -Be 'LicenseRef-16colors-discord-permission'
        $collection.LicenseEvidence | Should -Be 'ThirdPartyNotices/16colors-discord-permission.txt'
        $collection.PermissionDate | Should -Be '2026-07-22'

        $rootLicense = [System.IO.File]::ReadAllText((Join-Path -Path $script:RepoRoot -ChildPath 'LICENSE'))
        $rootLicense | Should -Match ([regex]::Escape('ColorScripts-Enhanced/Scripts/16c-*.ps1'))
        $rootLicense | Should -Match 'project-specific artist-authorized grant'

        foreach ($scriptName in @($script:Provenance.Scripts.Keys | Where-Object { $_.StartsWith('16c-', [System.StringComparison]::Ordinal) })) {
            $scriptPath = Join-Path -Path $script:ScriptsRoot -ChildPath "$scriptName.ps1"
            $contents = [System.IO.File]::ReadAllText($scriptPath)
            $contents | Should -Match '# Source License: LicenseRef-16colors-discord-permission'
            $contents | Should -Match '# Source Attribution: '
            $contents | Should -Match '# Source Modification: '
        }
    }

    It 'keeps deterministic imports outside dynamic and cache policy' {
        $dynamic = Import-PowerShellDataFile -Path (Join-Path -Path $script:ModuleRoot -ChildPath 'DynamicRenderPolicy.psd1')
        $cache = Import-PowerShellDataFile -Path (Join-Path -Path $script:ModuleRoot -ChildPath 'CachePolicy.psd1')
        $policyNames = @($dynamic.DynamicScripts) + @($cache.CacheableScripts) + @($cache.CacheablePokemonScripts)

        foreach ($scriptName in $script:Provenance.Scripts.Keys) {
            $policyNames | Should -Not -Contain $scriptName
        }
    }

    It 'preserves every passthrough ANSI source byte-for-byte as one safe PowerShell literal' {
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        try {
            $passthroughNames = @($script:Provenance.Scripts.Keys | Where-Object {
                    $script:Provenance.Scripts[$_].ConversionMode -eq 'Passthrough'
                })
            $passthroughNames | Should -Not -BeNullOrEmpty

            foreach ($scriptName in $passthroughNames) {
                $entry = $script:Provenance.Scripts[$scriptName]

                $scriptPath = Join-Path -Path $script:ScriptsRoot -ChildPath "$scriptName.ps1"
                $source = [System.IO.File]::ReadAllText($scriptPath, [System.Text.Encoding]::UTF8)
                $tokens = $null
                $errors = $null
                $ast = [System.Management.Automation.Language.Parser]::ParseInput(
                    $source,
                    [ref]$tokens,
                    [ref]$errors
                )
                $errors | Should -BeNullOrEmpty

                $commands = @($ast.FindAll({
                            param($node)
                            $node -is [System.Management.Automation.Language.CommandAst] -and
                            $node.GetCommandName() -eq 'Write-Host'
                        }, $true))
                $commands | Should -HaveCount 1
                $commands[0].CommandElements.Count | Should -BeIn @(2, 3) -Because "'$scriptName' must contain exactly one artwork literal and may use -NoNewline when the source has no final line break"

                $payload = $commands[0].CommandElements[1]
                $payload | Should -BeOfType ([System.Management.Automation.Language.StringConstantExpressionAst])
                if ($commands[0].CommandElements.Count -eq 3) {
                    $noNewline = $commands[0].CommandElements[2]
                    $noNewline | Should -BeOfType ([System.Management.Automation.Language.CommandParameterAst])
                    $noNewline.ParameterName | Should -Be 'NoNewline'
                    $noNewline.Argument | Should -BeNullOrEmpty
                }
                $payloadBytes = [System.Text.Encoding]::UTF8.GetBytes($payload.Value)
                $payloadHash = [System.BitConverter]::ToString(
                    $sha256.ComputeHash($payloadBytes)
                ).Replace('-', '').ToLowerInvariant()
                $payloadHash | Should -Be $entry.SourceSha256 -Because "'$scriptName' must preserve the original ANSI colors and geometry"
            }
        }
        finally {
            $sha256.Dispose()
        }
    }

    It 'assigns explicit categories, collection tags, and descriptions to every import' {
        $metadata = InModuleScope ColorScripts-Enhanced {
            Get-ColorScriptMetadataTableInternal
        }

        foreach ($scriptName in $script:Provenance.Scripts.Keys) {
            $entry = $metadata[$scriptName]
            $entry | Should -Not -BeNullOrEmpty
            @($entry.Categories) | Should -Not -Contain 'Abstract'
            @($entry.Categories) | Should -Contain 'ASCIIArt'
            @($entry.Tags) | Should -Contain 'ANSI'
            $entry.Description | Should -Not -BeNullOrEmpty
        }
    }

    It 'parses and statically extracts every imported script' {
        $parseErrors = [System.Collections.Generic.List[object]]::new()
        foreach ($scriptFile in $script:ImportedScriptFiles) {
            $tokens = $null
            $errors = $null
            [void][System.Management.Automation.Language.Parser]::ParseFile($scriptFile.FullName, [ref]$tokens, [ref]$errors)
            foreach ($errorRecord in $errors) {
                $parseErrors.Add([pscustomobject]@{
                        Script = $scriptFile.Name
                        Error  = $errorRecord.Message
                    })
            }
        }
        $parseErrors | Should -BeNullOrEmpty

        $results = InModuleScope ColorScripts-Enhanced -Parameters @{
            paths = @($script:ImportedScriptFiles.FullName)
        } {
            param($paths)

            foreach ($path in $paths) {
                $result = Get-StaticColorScriptOutput -ScriptPath $path
                [pscustomobject]@{
                    Name      = [System.IO.Path]::GetFileNameWithoutExtension($path)
                    Available = $result.Available
                    Length    = if ($null -eq $result.Content) { 0 } else { $result.Content.Length }
                    HasEscape = $null -ne $result.Content -and $result.Content.Contains([char]27)
                    UnsafeC0  = $null -ne $result.Content -and [regex]::IsMatch(
                        $result.Content,
                        '[\x00-\x08\x0B\x0C\x0E-\x1A\x1C-\x1F\x7F]'
                    )
                }
            }
        }

        @($results) | Should -HaveCount $script:ImportedScriptFiles.Count
        @($results | Where-Object { -not $_.Available -or $_.Length -eq 0 -or -not $_.HasEscape -or $_.UnsafeC0 }) | Should -BeNullOrEmpty
    }

    It 'keeps the os-ansi import limited to the audited multicolor sources' {
        $osAnsiNames = @($script:Provenance.Scripts.Keys | Where-Object {
                $script:Provenance.Scripts[$_].Collection -eq 'os-ansi'
            } | Sort-Object)

        $osAnsiNames | Should -HaveCount 2
        $osAnsiNames | Should -Be @('os-ansi-centos', 'os-ansi-macos')
    }

    It 'keeps every curated import within reviewed terminal-friendly geometry' {
        $dimensions = InModuleScope ColorScripts-Enhanced -Parameters @{
            paths = @($script:ImportedScriptFiles.FullName)
        } {
            param($paths)

            foreach ($path in $paths) {
                $result = Get-StaticColorScriptOutput -ScriptPath $path
                $plainText = $result.Content -replace ([char]27 + '\[[0-?]*[ -/]*[@-~]'), ''
                # Ignore blank display margins when measuring the artwork itself.
                $normalizedPlainText = $plainText.Trim([char[]]"`r`n") -replace "`r`n?", "`n"
                $lines = @($normalizedPlainText -split "`n")
                [pscustomobject]@{
                    Name   = [System.IO.Path]::GetFileNameWithoutExtension($path)
                    Width  = [int]($lines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
                    Height = $lines.Count
                }
            }
        }

        @($dimensions | Where-Object { $_.Width -gt 120 -or $_.Height -gt 50 }) |
            Should -BeNullOrEmpty -Because 'oversized artwork must be split without reflowing or squishing it'
    }

    It 'does not duplicate a whole work or two parts from the same source' {
        $duplicates = InModuleScope ColorScripts-Enhanced -Parameters @{
            paths = @($script:ImportedScriptFiles.FullName)
        } {
            param($paths)

            $hashes = @{}
            $sha256 = [System.Security.Cryptography.SHA256]::Create()
            try {
                foreach ($path in $paths) {
                    $result = Get-StaticColorScriptOutput -ScriptPath $path
                    $bytes = [System.Text.Encoding]::UTF8.GetBytes($result.Content)
                    $hash = [System.BitConverter]::ToString(
                        $sha256.ComputeHash($bytes)
                    ).Replace('-', '').ToLowerInvariant()
                    if ($hashes.ContainsKey($hash)) {
                        [pscustomobject]@{
                            First  = $hashes[$hash]
                            Second = [System.IO.Path]::GetFileNameWithoutExtension($path)
                        }
                    }
                    else {
                        $hashes[$hash] = [System.IO.Path]::GetFileNameWithoutExtension($path)
                    }
                }
            }
            finally {
                $sha256.Dispose()
            }
        }

        $sourcePartCounts = @{}
        foreach ($scriptName in $script:Provenance.Scripts.Keys) {
            $sourceHash = $script:Provenance.Scripts[$scriptName].SourceSha256
            $sourcePartCounts[$sourceHash] = 1 + [int]$sourcePartCounts[$sourceHash]
        }
        $invalidDuplicates = foreach ($duplicate in @($duplicates)) {
            $firstEntry = $script:Provenance.Scripts[$duplicate.First]
            $secondEntry = $script:Provenance.Scripts[$duplicate.Second]
            $sameSource = $firstEntry.SourceSha256 -eq $secondEntry.SourceSha256
            $bothWholeWorks =
            $sourcePartCounts[$firstEntry.SourceSha256] -eq 1 -and
            $sourcePartCounts[$secondEntry.SourceSha256] -eq 1
            if ($sameSource -or $bothWholeWorks) {
                $duplicate
            }
        }

        @($invalidDuplicates) | Should -BeNullOrEmpty -Because 'source-level normalized render hashes must be unique; identical shared panels may recur across otherwise distinct split originals'
    }
}
