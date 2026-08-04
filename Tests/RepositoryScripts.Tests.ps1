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

    It 'keeps web-only provenance artifacts out of the module documentation copy' {
        $buildScript = Get-Content -LiteralPath $script:BuildScriptPath -Raw
        $moduleDocs = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/docs'

        $buildScript | Should -Match "'artwork\.html'"
        $buildScript | Should -Match "'assets/artwork-provenance\.json'"
        $buildScript | Should -Match "'ColorScripts-Enhanced/'"
        Test-Path -LiteralPath (Join-Path -Path $moduleDocs -ChildPath 'artwork.html') | Should -BeFalse
        Test-Path -LiteralPath (Join-Path -Path $moduleDocs -ChildPath 'assets/artwork-provenance.json') | Should -BeFalse
        Test-Path -LiteralPath (Join-Path -Path $moduleDocs -ChildPath 'ColorScripts-Enhanced') | Should -BeFalse
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
