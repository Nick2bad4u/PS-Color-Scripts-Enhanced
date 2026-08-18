#Requires -Version 5.1

Describe 'Update-DocumentationCounts' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:UpdaterPath = Join-Path -Path $script:RepoRoot -ChildPath 'scripts/Update-DocumentationCounts.ps1'
        $script:CachePolicyPath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/CachePolicy.psd1'
        $script:DynamicPolicyPath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/DynamicRenderPolicy.psd1'
        $script:ManifestPath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
    }

    It 'keeps the cache marker independent from the total script count' {
        $target = Join-Path -Path $TestDrive -ChildPath 'counts.md'
        [System.IO.File]::WriteAllText(
            $target,
            '<!-- COLOR_SCRIPT_COUNT -->old<!-- /COLOR_SCRIPT_COUNT --> <!-- COLOR_CACHE_TOTAL -->old<!-- /COLOR_CACHE_TOTAL -->',
            (New-Object System.Text.UTF8Encoding($false)))

        & $script:UpdaterPath -ScriptCount 3156 -CacheCount 15 -Files $target

        $content = Get-Content -LiteralPath $target -Raw
        $content | Should -Match '<!-- COLOR_SCRIPT_COUNT -->3156<!-- /COLOR_SCRIPT_COUNT -->'
        $content | Should -Match '<!-- COLOR_CACHE_TOTAL -->15<!-- /COLOR_CACHE_TOTAL -->'
        $content | Should -Not -Match '<!-- COLOR_CACHE_TOTAL -->3156'
    }

    It 'derives the default cache count from the active policy list' {
        $policy = Import-PowerShellDataFile -LiteralPath $script:CachePolicyPath
        $expectedCacheCount = @(
            @($policy.CacheableScripts) |
                Where-Object { $_ -is [string] -and -not [string]::IsNullOrWhiteSpace($_) } |
                    Sort-Object -Unique
        ).Count
        $target = Join-Path -Path $TestDrive -ChildPath 'policy-count.md'
        [System.IO.File]::WriteAllText(
            $target,
            '<!-- COLOR_CACHE_TOTAL -->old<!-- /COLOR_CACHE_TOTAL -->',
            (New-Object System.Text.UTF8Encoding($false)))

        & $script:UpdaterPath -ScriptCount 1 -Files $target

        (Get-Content -LiteralPath $target -Raw) |
            Should -Match "<!-- COLOR_CACHE_TOTAL -->$expectedCacheCount<!-- /COLOR_CACHE_TOTAL -->"
    }

    It 'derives the dynamic count from the dynamic-render policy' {
        $policy = Import-PowerShellDataFile -LiteralPath $script:DynamicPolicyPath
        $expectedDynamicCount = @(
            $policy.DynamicScripts |
                Where-Object { $_ -is [string] -and -not [string]::IsNullOrWhiteSpace($_) } |
                    Sort-Object -Unique
        ).Count
        $target = Join-Path -Path $TestDrive -ChildPath 'dynamic-count.md'
        [System.IO.File]::WriteAllText(
            $target,
            '<!-- COLOR_DYNAMIC_TOTAL -->old<!-- /COLOR_DYNAMIC_TOTAL -->',
            (New-Object System.Text.UTF8Encoding($false)))

        & $script:UpdaterPath -ScriptCount 1 -Files $target

        (Get-Content -LiteralPath $target -Raw) |
            Should -Match "<!-- COLOR_DYNAMIC_TOTAL -->$expectedDynamicCount<!-- /COLOR_DYNAMIC_TOTAL -->"
    }

    It 'derives and formats the module version from the manifest' {
        $manifest = Import-PowerShellDataFile -LiteralPath $script:ManifestPath
        $expectedModuleVersion = [string]$manifest.ModuleVersion
        $target = Join-Path -Path $TestDrive -ChildPath 'module-version.md'
        [System.IO.File]::WriteAllText(
            $target,
            '<!-- COLOR_MODULE_VERSION -->`old`<!-- /COLOR_MODULE_VERSION -->',
            (New-Object System.Text.UTF8Encoding($false)))

        & $script:UpdaterPath -ScriptCount 1 -Files $target

        (Get-Content -LiteralPath $target -Raw) |
            Should -Match "<!-- COLOR_MODULE_VERSION -->``$([regex]::Escape($expectedModuleVersion))``<!-- /COLOR_MODULE_VERSION -->"
    }
}

Describe 'Analyze-UnusedAnsiFiles' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:AnalyzerPath = Join-Path -Path $script:RepoRoot -ChildPath 'scripts/Analyze-UnusedAnsiFiles.ps1'
    }

    It 'uses terminal emulation for cursor-positioned dimensions' {
        $sourceDirectory = Join-Path -Path $TestDrive -ChildPath 'positioned'
        $csvPath = Join-Path -Path $TestDrive -ChildPath 'positioned.csv'
        $null = New-Item -ItemType Directory -Path $sourceDirectory
        [System.IO.File]::WriteAllBytes(
            (Join-Path -Path $sourceDirectory -ChildPath 'positioned.ans'),
            [System.Text.Encoding]::ASCII.GetBytes("$([char]27)[1;10HHELLO"))

        & $script:AnalyzerPath -UnusedAnsiPath $sourceDirectory -OutputCsv $csvPath -MaxWidth 13 -MaxHeight 1 -Confirm:$false

        $result = Import-Csv -LiteralPath $csvPath
        $result.Width | Should -Be '14'
        $result.Height | Should -Be '1'
        $result.Source | Should -Be 'Terminal emulation'
        $result.IsNormalSize | Should -Be 'False'
    }

    It 'counts CP437 box and block glyphs as art after Unicode decoding' {
        $sourceDirectory = Join-Path -Path $TestDrive -ChildPath 'cp437'
        $csvPath = Join-Path -Path $TestDrive -ChildPath 'cp437.csv'
        $null = New-Item -ItemType Directory -Path $sourceDirectory
        $bytes = [byte[]](@(0xB0) * 60 + @(0x41) * 51)
        [System.IO.File]::WriteAllBytes((Join-Path -Path $sourceDirectory -ChildPath 'blocks.ans'), $bytes)

        & $script:AnalyzerPath -UnusedAnsiPath $sourceDirectory -OutputCsv $csvPath -MaxWidth 120 -MaxHeight 5 -ExcludeRegularAscii -AsciiCharLimit 0 -Confirm:$false

        $result = Import-Csv -LiteralPath $csvPath
        $result.Error | Should -BeNullOrEmpty
        $result.IsNormalSize | Should -Be 'True'
    }
}

Describe 'Release lint wiring' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:PackageJsonPath = Join-Path -Path $script:RepoRoot -ChildPath 'package.json'
        $script:PublishWorkflowPath = Join-Path -Path $script:RepoRoot -ChildPath '.github/workflows/publish.yml'
        $script:LintScriptPath = Join-Path -Path $script:RepoRoot -ChildPath 'scripts/Lint-Module.ps1'
        $script:BuildScriptPath = Join-Path -Path $script:RepoRoot -ChildPath 'scripts/build.ps1'
        $script:ChangelogValidatorPath = Join-Path -Path $script:RepoRoot -ChildPath 'scripts/Validate-Changelog.ps1'
        $script:ReleaseNotesLimiterPath = Join-Path -Path $script:RepoRoot -ChildPath 'scripts/Limit-GitHubReleaseNotes.mjs'
    }

    It 'keeps verification non-mutating' {
        $packageJson = Get-Content -LiteralPath $script:PackageJsonPath -Raw | ConvertFrom-Json

        $packageJson.scripts.verify | Should -Be 'npm run lint && npm run readme:check && npm run artwork:provenance:headers:check && npm run artwork:provenance:web:check'
        $packageJson.scripts.'verify:strict' | Should -Be 'npm run lint:strict && npm run readme:check && npm run artwork:provenance:headers:check && npm run artwork:provenance:web:check && npm run ansi:gallery-analysis:check'
        $packageJson.scripts.verify | Should -Not -Match ':fix'
        $packageJson.scripts.'verify:strict' | Should -Not -Match ':fix'
    }

    It 'uses the repository lint entry point in the publish workflow' {
        $workflow = Get-Content -LiteralPath $script:PublishWorkflowPath -Raw

        $workflow | Should -Match 'pwsh -NoProfile -File \./scripts/Lint-Module\.ps1 -TreatWarningsAsErrors'
        $workflow | Should -Not -Match 'Invoke-ScriptAnalyzer'
    }

    It 'bounds GitHub release bodies before creating a release' {
        $workflow = Get-Content -LiteralPath $script:PublishWorkflowPath -Raw
        $limiter = Get-Content -LiteralPath $script:ReleaseNotesLimiterPath -Raw

        $workflow | Should -Match ([regex]::Escape('node ./scripts/Limit-GitHubReleaseNotes.mjs'))
        $workflow | Should -Match ([regex]::Escape('$boundedNotesFile = Join-Path $env:RUNNER_TEMP "release-notes-bounded.md"'))
        $workflow | Should -Match ([regex]::Escape('"--output=$boundedNotesFile"'))
        $workflow | Should -Match ([regex]::Escape('"--maximum-characters=120000"'))
        $workflow | Should -Match ([regex]::Escape('$notes.Substring(0, $previewLength)'))
        $workflow | Should -Not -Match '(?m)^\s*Write-Host \$notes\s*$'
        $limiter | Should -Match 'GITHUB_RELEASE_BODY_LIMIT = 125_000'
        $limiter | Should -Match 'complete changelog for v\$\{version\}'
    }

    It 'uploads every release asset before publishing an immutable release' {
        $workflow = Get-Content -LiteralPath $script:PublishWorkflowPath -Raw

        $workflow | Should -Match '(?m)^\s+artifactErrorsFailBuild:\s+true\s*$'
        $workflow | Should -Match '(?m)^\s+immutableCreate:\s+true\s*$'
        $workflow | Should -Match '(?m)^\s+allowUpdates:\s+false\s*$'
        $workflow | Should -Not -Match '(?m)^\s+updateOnlyUnreleased:'
    }

    It 'reuses only an exact existing release tag after a partial release failure' {
        $workflow = Get-Content -LiteralPath $script:PublishWorkflowPath -Raw

        $workflow | Should -Match ([regex]::Escape('Reusing expected release tag $expectedTag at $headCommit.'))
        $workflow | Should -Match ([regex]::Escape('Existing release tag $expectedTag points to $tagCommit, but HEAD is $headCommit; refusing to replace it.'))
        $workflow | Should -Not -Match ([regex]::Escape('already exists; refusing to replace it during this release'))
    }

    It 'keeps web-only provenance artifacts out of the module documentation copy' {
        $buildScript = Get-Content -LiteralPath $script:BuildScriptPath -Raw
        $moduleDocs = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/docs'

        $buildScript | Should -Match "'artwork\.html'"
        $buildScript | Should -Match "'assets/artwork-provenance\.json'"
        $buildScript | Should -Match "'ColorScripts-Enhanced/'"
        Test-Path -LiteralPath (Join-Path -Path $moduleDocs -ChildPath 'artwork.html') | Should -BeFalse
        Test-Path -LiteralPath (Join-Path -Path $moduleDocs -ChildPath 'assets/artwork-provenance.json') | Should -BeFalse
        Test-Path -LiteralPath (Join-Path -Path $moduleDocs -ChildPath 'ColorScripts-Enhanced') | Should -BeFalse

        $packagedArtworkSources = Get-Content -LiteralPath (Join-Path -Path $moduleDocs -ChildPath 'ARTWORK_SOURCES.md') -Raw
        $hostedArtworkIndex = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/artwork.html'
        $packagedArtworkSources | Should -Match ([regex]::Escape("]($hostedArtworkIndex)"))
        $packagedArtworkSources | Should -Not -Match ([regex]::Escape('](artwork.html)'))
    }

    It 'links packaged README references to repository-only release evidence' {
        $buildScript = Get-Content -LiteralPath $script:BuildScriptPath -Raw
        $packagedReadmePath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/README.md'
        $packagedReadme = Get-Content -LiteralPath $packagedReadmePath -Raw
        $repositoryBlobBase = 'https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/'
        $repositoryTreeBase = 'https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/tree/main/'

        foreach ($repositoryPath in @(
                'audit/ArtworkProvenance.psd1',
                'audit/AnsiArchiveCurationCheckpoint.json',
                'audit/AnsiContentCurationCheckpoint.json')) {
            $buildScript | Should -Match ([regex]::Escape("'$repositoryPath'"))
            $packagedReadme | Should -Match ([regex]::Escape("]($repositoryBlobBase$repositoryPath)"))
            $packagedReadme | Should -Not -Match ([regex]::Escape("]($repositoryPath)"))
        }

        $noticesPath = 'ColorScripts-Enhanced/ThirdPartyNotices/'
        $buildScript | Should -Match ([regex]::Escape("'$noticesPath'"))
        $packagedReadme | Should -Match ([regex]::Escape("]($repositoryTreeBase$noticesPath)"))
        $packagedReadme | Should -Not -Match ([regex]::Escape("]($noticesPath)"))
    }

    It 'keeps compliant release-preparation commits out of generated changelog content' {
        $validator = Get-Content -LiteralPath $script:ChangelogValidatorPath -Raw

        $validator | Should -Match ([regex]::Escape('^🧹 \[chore\] Prepare release \d+(?:\.\d+){1,3}$'))
        $validator | Should -Match ([regex]::Escape('$gitCliffArguments += ''--skip-commit'', $parts[0]'))
        $validator | Should -Match ([regex]::Escape('$parts[0] -notmatch ''^[0-9a-f]{40}$'''))
    }

    It 'keeps compliant release-preparation commits out of published GitHub release notes' {
        $workflow = Get-Content -LiteralPath $script:PublishWorkflowPath -Raw

        $workflow | Should -Match ([regex]::Escape('$releasePreparationPattern = ''^🧹 \[chore\] Prepare release \d+(?:\.\d+){1,3}$'''))
        $workflow | Should -Match ([regex]::Escape('$gitCliffArguments += ''--skip-commit'', $parts[0]'))
        $workflow | Should -Match ([regex]::Escape('$parts[0] -notmatch ''^[0-9a-f]{40}$'''))
        $workflow | Should -Match ([regex]::Escape('npx git-cliff @gitCliffArguments'))
    }

    It 'keeps analyzer isolation bounded and fail-closed' {
        $lintScript = Get-Content -LiteralPath $script:LintScriptPath -Raw

        $lintScript | Should -Match 'Start-Job -ScriptBlock'
        $lintScript | Should -Match '\[ValidateRange\(30, 600\)\]'
        $lintScript | Should -Match 'splitting that rule set into smaller isolated passes'
        $lintScript | Should -Match 'PSScriptAnalyzer could not analyze'
        $lintScript | Should -Not -Match 'Skipping this file'
    }

    It 'analyzes a valid file through the isolated runner' {
        $validScript = Join-Path -Path $TestDrive -ChildPath 'valid.ps1'
        [System.IO.File]::WriteAllText(
            $validScript,
            "Set-StrictMode -Version Latest`n",
            (New-Object System.Text.UTF8Encoding($false)))

        {
            & $script:LintScriptPath `
                -Path $validScript `
                -TreatWarningsAsErrors `
                -AnalyzerThrottleLimit 1 `
                -AnalyzerTimeoutSeconds 60
        } | Should -Not -Throw
    }

    It 'keeps one canonical online link in every localized help topic' {
        $cultureNames = @('de', 'en-US', 'es', 'fr', 'it', 'ja', 'nl', 'pt', 'ru', 'zh-CN')

        foreach ($cultureName in $cultureNames) {
            $culturePath = Join-Path -Path $script:RepoRoot -ChildPath "ColorScripts-Enhanced/$cultureName"
            $linkLabels = New-Object 'System.Collections.Generic.HashSet[string]'
            foreach ($markdownPath in Get-ChildItem -LiteralPath $culturePath -Filter '*.md' -File) {
                $content = Get-Content -LiteralPath $markdownPath.FullName -Raw
                $linkMatches = @([regex]::Matches($content, '(?m)^- \[(?<Label>[^]]+)\]\('))
                $linkMatches.Count | Should -Be 1 -Because $markdownPath.FullName
                [void]$linkLabels.Add($linkMatches[0].Groups['Label'].Value)
                $content | Should -Not -Match '(?m)^- \[\]\(' -Because $markdownPath.FullName
            }
            $linkLabels.Count | Should -Be 1 -Because "all $cultureName topics should use one localized link label"
            $expectedLinkLabel = @($linkLabels)[0]
            if ($cultureName -eq 'en-US') {
                $expectedLinkLabel | Should -BeExactly 'Online Version'
            }

            $mamlPath = Join-Path -Path $culturePath -ChildPath 'ColorScripts-Enhanced-help.xml'
            [xml]$maml = Get-Content -LiteralPath $mamlPath -Raw
            $commandNodes = @($maml.SelectNodes("//*[local-name()='command' and namespace-uri()='http://schemas.microsoft.com/maml/dev/command/2004/10']"))
            $commandNodes.Count | Should -Be 10 -Because $mamlPath
            foreach ($commandNode in $commandNodes) {
                $links = @($commandNode.SelectNodes("./*[local-name()='relatedLinks']/*[local-name()='navigationLink']"))
                $links.Count | Should -Be 1 -Because $mamlPath
                $links[0].SelectSingleNode("./*[local-name()='linkText']").InnerText |
                    Should -BeExactly $expectedLinkLabel -Because $mamlPath
            }
        }
    }
}
