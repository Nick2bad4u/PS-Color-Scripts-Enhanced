#Requires -Version 5.1

Describe 'Update-DocumentationCounts' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:UpdaterPath = Join-Path -Path $script:RepoRoot -ChildPath 'scripts/Update-DocumentationCounts.ps1'
        $script:CachePolicyPath = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced/CachePolicy.psd1'
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

    It 'derives the default cache count from both policy lists' {
        $policy = Import-PowerShellDataFile -LiteralPath $script:CachePolicyPath
        $expectedCacheCount = @(
            @($policy.CacheableScripts) + @($policy.CacheablePokemonScripts) |
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
    }

    It 'keeps verification non-mutating' {
        $packageJson = Get-Content -LiteralPath $script:PackageJsonPath -Raw | ConvertFrom-Json

        $packageJson.scripts.verify | Should -Be 'npm run lint && npm run readme:check'
        $packageJson.scripts.'verify:strict' | Should -Be 'npm run lint:strict && npm run readme:check'
        $packageJson.scripts.verify | Should -Not -Match ':fix'
        $packageJson.scripts.'verify:strict' | Should -Not -Match ':fix'
    }

    It 'uses the repository lint entry point in the publish workflow' {
        $workflow = Get-Content -LiteralPath $script:PublishWorkflowPath -Raw

        $workflow | Should -Match 'pwsh -NoProfile -File \./scripts/Lint-Module\.ps1 -TreatWarningsAsErrors'
        $workflow | Should -Not -Match 'Invoke-ScriptAnalyzer'
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
            foreach ($markdownPath in Get-ChildItem -LiteralPath $culturePath -Filter '*.md' -File) {
                $content = Get-Content -LiteralPath $markdownPath.FullName -Raw
                @([regex]::Matches($content, '(?m)^- \[Online Version\]\(')).Count | Should -Be 1 -Because $markdownPath.FullName
                $content | Should -Not -Match '(?m)^- \[\]\(' -Because $markdownPath.FullName
            }

            $mamlPath = Join-Path -Path $culturePath -ChildPath 'ColorScripts-Enhanced-help.xml'
            [xml]$maml = Get-Content -LiteralPath $mamlPath -Raw
            $commandNodes = @($maml.SelectNodes("//*[local-name()='command' and namespace-uri()='http://schemas.microsoft.com/maml/dev/command/2004/10']"))
            $commandNodes.Count | Should -Be 10 -Because $mamlPath
            foreach ($commandNode in $commandNodes) {
                $links = @($commandNode.SelectNodes("./*[local-name()='relatedLinks']/*[local-name()='navigationLink']"))
                $links.Count | Should -Be 1 -Because $mamlPath
                $links[0].SelectSingleNode("./*[local-name()='linkText']").InnerText | Should -Be 'Online Version' -Because $mamlPath
            }
        }
    }
}
