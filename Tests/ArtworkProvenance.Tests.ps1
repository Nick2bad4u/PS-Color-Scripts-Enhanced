Describe 'Curated ANSI artwork provenance' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:ScriptsRoot = Join-Path -Path $script:ModuleRoot -ChildPath 'Scripts'
        $script:ProvenancePath = Join-Path -Path $script:ModuleRoot -ChildPath 'ArtworkProvenance.psd1'
        $script:Provenance = Import-PowerShellDataFile -Path $script:ProvenancePath
        $script:ImportedPrefixes = @('botany-', 'os-ansi-', 'roy-sac-')
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
        $script:Provenance.SchemaVersion | Should -Be 1
        @($script:Provenance.Collections.Keys) | Should -HaveCount 3
        @($script:Provenance.Scripts.Keys) | Should -HaveCount 30
        $script:ImportedScriptFiles | Should -HaveCount 30

        $mappedNames = @($script:Provenance.Scripts.Keys | Sort-Object)
        $checkedInNames = @($script:ImportedScriptFiles.BaseName | Sort-Object)
        Compare-Object -ReferenceObject $mappedNames -DifferenceObject $checkedInNames | Should -BeNullOrEmpty

        foreach ($scriptName in $mappedNames) {
            $entry = $script:Provenance.Scripts[$scriptName]
            $script:Provenance.Collections.ContainsKey($entry.Collection) | Should -BeTrue -Because "the '$scriptName' collection must exist"
            $entry.SourceFile | Should -Not -BeNullOrEmpty
            $entry.SourceUrl | Should -Match '^https://[^\s]+$'
            $entry.SourceSha256 | Should -Match '^[0-9a-f]{64}$'
            $entry.InputEncoding | Should -BeIn @('cp437', 'utf8')
            $entry.ConversionMode | Should -BeIn @('Passthrough', 'TerminalEmulation')
        }
    }

    It 'keeps each imported script header synchronized with the provenance manifest' {
        foreach ($scriptName in $script:Provenance.Scripts.Keys) {
            $entry = $script:Provenance.Scripts[$scriptName]
            $collection = $script:Provenance.Collections[$entry.Collection]
            $scriptPath = Join-Path -Path $script:ScriptsRoot -ChildPath "$scriptName.ps1"
            $contents = [System.IO.File]::ReadAllText($scriptPath)
            $revision = if ($null -ne $collection.Revision) {
                $collection.Revision
            }
            else {
                "archive-sha256:$($collection.ArchiveSha256)"
            }

            $contents | Should -Match ([regex]::Escape("# Source URL: $($entry.SourceUrl)"))
            $contents | Should -Match ([regex]::Escape("# Source Revision: $revision"))
            $contents | Should -Match ([regex]::Escape("# Source SHA-256: $($entry.SourceSha256)"))
            $contents | Should -Match ([regex]::Escape("# Source License: $($collection.License)"))
            $contents | Should -Match ([regex]::Escape("# Source Attribution: $($collection.Attribution)"))
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

    It 'keeps deterministic imports outside dynamic and cache policy' {
        $dynamic = Import-PowerShellDataFile -Path (Join-Path -Path $script:ModuleRoot -ChildPath 'DynamicRenderPolicy.psd1')
        $cache = Import-PowerShellDataFile -Path (Join-Path -Path $script:ModuleRoot -ChildPath 'CachePolicy.psd1')
        $policyNames = @($dynamic.DynamicScripts) + @($cache.CacheableScripts) + @($cache.CacheablePokemonScripts)

        foreach ($scriptName in $script:Provenance.Scripts.Keys) {
            $policyNames | Should -Not -Contain $scriptName
        }
    }

    It 'preserves each botany ANSI source byte-for-byte as one safe PowerShell literal' {
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        try {
            foreach ($scriptName in @($script:Provenance.Scripts.Keys | Where-Object { $_.StartsWith('botany-', [System.StringComparison]::Ordinal) })) {
                $entry = $script:Provenance.Scripts[$scriptName]
                $entry.ConversionMode | Should -Be 'Passthrough'

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
                $commands[0].CommandElements | Should -HaveCount 3 -Because "'$scriptName' must contain one artwork literal and the required -NoNewline switch"

                $payload = $commands[0].CommandElements[1]
                $payload | Should -BeOfType ([System.Management.Automation.Language.StringConstantExpressionAst])
                $noNewline = $commands[0].CommandElements[2]
                $noNewline | Should -BeOfType ([System.Management.Automation.Language.CommandParameterAst])
                $noNewline.ParameterName | Should -Be 'NoNewline'
                $noNewline.Argument | Should -BeNullOrEmpty
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
                }
            }
        }

        @($results) | Should -HaveCount 30
        @($results | Where-Object { -not $_.Available -or $_.Length -eq 0 -or -not $_.HasEscape }) | Should -BeNullOrEmpty
    }

    It 'does not contain duplicate rendered output within the imported set' {
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

        @($duplicates) | Should -BeNullOrEmpty
    }
}
