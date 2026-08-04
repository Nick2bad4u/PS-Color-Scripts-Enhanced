Set-StrictMode -Version Latest

function script:Read-Utf8TextFile {
    param([Parameter(Mandatory)][string]$LiteralPath)

    $strictUtf8 = [System.Text.UTF8Encoding]::new($false, $true)
    return [System.IO.File]::ReadAllText($LiteralPath, $strictUtf8)
}

function script:Get-MarkdownCodeBlock {
    param([Parameter(Mandatory)][string]$Content)

    foreach ($match in [regex]::Matches($Content, '(?ms)^```(?<Language>[^\r\n]*)\r?\n(?<Code>.*?)^```\s*$')) {
        [pscustomobject]@{
            Language = $match.Groups['Language'].Value.Trim().ToLowerInvariant()
            Code     = $match.Groups['Code'].Value.TrimEnd("`r", "`n")
        }
    }
}

function script:Get-PowerShellTechnicalSignature {
    param([Parameter(Mandatory)][string]$Code)

    $tokens = $null
    $parseErrors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput(
        $Code,
        [ref]$tokens,
        [ref]$parseErrors)
    if ($parseErrors.Count -gt 0) {
        throw "PowerShell example did not parse: $($parseErrors[0].Message)"
    }

    $displayCommands = @('Write-Debug', 'Write-Error', 'Write-Host', 'Write-Information', 'Write-Output', 'Write-Verbose', 'Write-Warning')
    $signatureNodes = @(
        $ast.FindAll({
                param($node)
                $node -is [System.Management.Automation.Language.CommandAst] -or
                $node -is [System.Management.Automation.Language.CommandParameterAst] -or
                $node -is [System.Management.Automation.Language.VariableExpressionAst] -or
                $node -is [System.Management.Automation.Language.MemberExpressionAst] -or
                $node -is [System.Management.Automation.Language.TypeExpressionAst] -or
                $node -is [System.Management.Automation.Language.StringConstantExpressionAst] -or
                $node -is [System.Management.Automation.Language.ExpandableStringExpressionAst]
            }, $true) |
            Sort-Object { $_.Extent.StartOffset }, { $_.Extent.EndOffset }
    )

    $signature = New-Object 'System.Collections.Generic.List[string]'
    foreach ($node in $signatureNodes) {
        if ($node -is [System.Management.Automation.Language.CommandAst]) {
            $commandName = $node.GetCommandName()
            if (-not [string]::IsNullOrWhiteSpace($commandName)) {
                [void]$signature.Add("Command:$commandName")
            }
            continue
        }

        if ($node -is [System.Management.Automation.Language.CommandParameterAst]) {
            [void]$signature.Add("Parameter:$($node.ParameterName)")
            continue
        }

        if ($node -is [System.Management.Automation.Language.VariableExpressionAst]) {
            [void]$signature.Add("Variable:$($node.VariablePath.UserPath)")
            continue
        }

        if ($node -is [System.Management.Automation.Language.MemberExpressionAst]) {
            [void]$signature.Add("Member:$($node.Member.Extent.Text)")
            continue
        }

        if ($node -is [System.Management.Automation.Language.TypeExpressionAst]) {
            [void]$signature.Add("Type:$($node.TypeName.FullName)")
            continue
        }

        $parentCommand = $node.Parent
        while ($parentCommand -and $parentCommand -isnot [System.Management.Automation.Language.CommandAst]) {
            $parentCommand = $parentCommand.Parent
        }
        if ($parentCommand -and $displayCommands -contains $parentCommand.GetCommandName()) {
            continue
        }

        [void]$signature.Add("String:$($node.Extent.Text)")
    }

    return @($signature)
}

function script:Get-PowerShellCommentTechnicalSignature {
    param([Parameter(Mandatory)][string]$Code)

    $tokens = $null
    $parseErrors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseInput(
        $Code,
        [ref]$tokens,
        [ref]$parseErrors)
    if ($parseErrors.Count -gt 0) {
        throw "PowerShell example did not parse: $($parseErrors[0].Message)"
    }

    return @(
        foreach ($comment in $tokens | Where-Object Kind -eq 'Comment') {
            foreach ($match in [regex]::Matches(
                    $comment.Text,
                    '(?:\$[A-Za-z_][A-Za-z0-9_:.-]*|\b(?:Add|Clear|Convert|Export|ForEach|Get|Import|Join|Measure|New|Out|Reset|Select|Set|Show|Sort|Where|Write)-[A-Z][A-Za-z0-9-]+\b|(?<![\w-])-[A-Z][A-Za-z0-9]*\b|\.[A-Z][A-Za-z0-9]*\b)')) {
                $match.Value
            }
        }
    )
}

function script:Get-InlineCodeToken {
    param([Parameter(Mandatory)][string]$Content)

    $withoutFences = [regex]::Replace($Content, '(?ms)^```.*?^```\s*$', '')
    return @(
        [regex]::Matches($withoutFences, '`(?<Token>[^`\r\n]+)`') |
            ForEach-Object { $_.Groups['Token'].Value }
    )
}

function script:Get-MarkdownHeading {
    param([Parameter(Mandatory)][string]$Content)

    $inFence = $false
    foreach ($line in $Content -split '\r?\n') {
        if ($line.Trim() -match '^```') {
            $inFence = -not $inFence
            continue
        }
        if (-not $inFence -and $line -match '^#{1,3} ') {
            $heading = $line.TrimEnd("`r")
            $heading
        }
    }
}

function script:Get-TranslatableLine {
    param([Parameter(Mandatory)][string]$Content)

    $inFrontmatter = $false
    $frontmatterSeen = $false
    $fenceLanguage = $null
    $lineNumber = 0
    foreach ($line in $Content -split '\r?\n') {
        $lineNumber++
        $trimmed = $line.Trim()
        if ($trimmed -eq '---' -and $null -eq $fenceLanguage) {
            if (-not $frontmatterSeen) {
                $frontmatterSeen = $true
                $inFrontmatter = $true
            }
            elseif ($inFrontmatter) {
                $inFrontmatter = $false
            }
            continue
        }

        if ($trimmed -match '^```(?<Language>[A-Za-z0-9_-]*)\s*$') {
            if ($null -eq $fenceLanguage) {
                $fenceLanguage = $Matches.Language.ToLowerInvariant()
            }
            else {
                $fenceLanguage = $null
            }
            continue
        }

        if ($inFrontmatter) {
            continue
        }

        $candidate = $trimmed
        if ($null -ne $fenceLanguage) {
            if ($fenceLanguage -notin @('powershell', 'pwsh')) {
                continue
            }
            if ($candidate.StartsWith('#')) {
                $candidate = $candidate.TrimStart('#', ' ')
                if ($candidate -match '^(?:\$|[A-Z][A-Za-z]+-[A-Z][A-Za-z-]+(?:\s|$)|-[A-Z][A-Za-z0-9]*(?:\s|$))') {
                    continue
                }
            }
            elseif ($candidate -match '#\s*(?<Text>[A-Za-z].+)$') {
                $candidate = $Matches.Text
            }
            elseif ($candidate -match '^Write-(?:Debug|Error|Host|Information|Output|Verbose|Warning)\s+"(?<Text>.*)"\s*$') {
                $candidate = $Matches.Text
            }
            else {
                continue
            }
        }

        if ([string]::IsNullOrWhiteSpace($candidate) -or
            $candidate.StartsWith('#') -or
            $candidate -match '^(?:-[A-Z][A-Za-z]+,\s*)+-[A-Z][A-Za-z]+,?$' -or
            $candidate -match '^\[about_CommonParameters\]\(' -or
            $candidate -match '^- \[[^]]+\]\(https?://' -or
            $candidate -match '^(?:Type|DefaultValue|SupportsWildcards|Aliases|ParameterSets|Position|IsRequired|ValueFromPipeline|ValueFromPipelineByPropertyName|ValueFromRemainingArguments|DontShow|AcceptedValues|HelpMessage):') {
            continue
        }

        $wordCandidate = [regex]::Replace($candidate, '`[^`]+`', '')
        $wordCount = @([regex]::Matches($wordCandidate, '[A-Za-z]{2,}')).Count
        if ($wordCandidate.Length -ge 20 -and $wordCount -ge 4) {
            [pscustomobject]@{ LineNumber = $lineNumber; Text = $candidate }
        }
    }
}

function script:Get-AboutTranslatableLine {
    param([Parameter(Mandatory)][string]$Content)

    $lineNumber = 0
    foreach ($line in $Content -split '\r?\n') {
        $lineNumber++
        $candidate = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($candidate) -or
            $candidate -match '^[A-Z][A-Z ]+$' -or
            $candidate -match '^https?://' -or
            $candidate -match '^(?:Add|Clear|Export|Get|Import|New|Reset|Set|Show)-[A-Za-z-]+' -or
            $candidate -match '^-{1,2}[A-Za-z][A-Za-z0-9-]*(?:\s|$)') {
            continue
        }

        $wordCandidate = [regex]::Replace($candidate, '`[^`]+`', '')
        $wordCount = @([regex]::Matches($wordCandidate, '[A-Za-z]{2,}')).Count
        if ($wordCandidate.Length -ge 20 -and $wordCount -ge 4) {
            [pscustomobject]@{ LineNumber = $lineNumber; Text = $candidate }
        }
    }
}

function script:Get-AboutTechnicalToken {
    param([Parameter(Mandatory)][string]$Content)

    return @(
        [regex]::Matches(
            $Content,
            '(?:https?://\S+|COLOR_SCRIPTS_ENHANCED_[A-Z0-9_]+|\b(?:Add|Clear|Convert|Export|ForEach|Get|Import|Join|Measure|New|Out|Reset|Select|Set|Show|Sort|Where|Write)-[A-Z][A-Za-z0-9-]+\b|(?<![\w-])-[A-Z][A-Za-z0-9]*\b|\b[A-Za-z0-9_.-]+\.(?:ans|ps1|psd1|psm1)\b)') |
            ForEach-Object { $_.Value.TrimEnd('.', ',', ';') }
    )
}

Describe 'Localized command help integrity' {
    BeforeAll {
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:HelpRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:CultureNames = @('de', 'es', 'fr', 'it', 'ja', 'nl', 'pt', 'ru', 'zh-CN')
        $script:EnglishRoot = Join-Path -Path $script:HelpRoot -ChildPath 'en-US'
    }

    It 'preserves headings, inline technical tokens, and executable example structure' {
        foreach ($cultureName in $script:CultureNames) {
            foreach ($englishPath in Get-ChildItem -LiteralPath $script:EnglishRoot -Filter '*.md' -File) {
                $localizedPath = Join-Path -Path (Join-Path -Path $script:HelpRoot -ChildPath $cultureName) -ChildPath $englishPath.Name
                $englishContent = Read-Utf8TextFile -LiteralPath $englishPath.FullName
                $localizedContent = Read-Utf8TextFile -LiteralPath $localizedPath

                $localizedHeadings = @(Get-MarkdownHeading -Content $localizedContent)
                $englishHeadings = @(Get-MarkdownHeading -Content $englishContent)
                $localizedHeadings.Count | Should -Be $englishHeadings.Count -Because $localizedPath
                for ($headingIndex = 0; $headingIndex -lt $englishHeadings.Count; $headingIndex++) {
                    if ($englishHeadings[$headingIndex] -match '^### (?:Best Practices|Troubleshooting)') {
                        $localizedHeadings[$headingIndex] | Should -Match '^### .+' -Because $localizedPath
                        $localizedHeadings[$headingIndex] | Should -Not -BeExactly $englishHeadings[$headingIndex] -Because $localizedPath
                        $localizedHeadings[$headingIndex] = $englishHeadings[$headingIndex]
                    }
                }
                $localizedHeadings | Should -BeExactly $englishHeadings -Because $localizedPath
                @(Get-InlineCodeToken -Content $localizedContent) |
                    Should -BeExactly @(Get-InlineCodeToken -Content $englishContent) -Because $localizedPath

                $englishBlocks = @(Get-MarkdownCodeBlock -Content $englishContent)
                $localizedBlocks = @(Get-MarkdownCodeBlock -Content $localizedContent)
                $localizedBlocks.Count | Should -Be $englishBlocks.Count -Because $localizedPath
                for ($index = 0; $index -lt $englishBlocks.Count; $index++) {
                    $localizedBlocks[$index].Language | Should -BeExactly $englishBlocks[$index].Language -Because $localizedPath
                    if ($englishBlocks[$index].Language -in @('powershell', 'pwsh')) {
                        @(Get-PowerShellTechnicalSignature -Code $localizedBlocks[$index].Code) |
                            Should -BeExactly @(Get-PowerShellTechnicalSignature -Code $englishBlocks[$index].Code) -Because "$localizedPath block $index"
                        @(Get-PowerShellCommentTechnicalSignature -Code $localizedBlocks[$index].Code) |
                            Should -BeExactly @(Get-PowerShellCommentTechnicalSignature -Code $englishBlocks[$index].Code) -Because "$localizedPath block $index comments"
                    }
                    else {
                        ($localizedBlocks[$index].Code -replace "`r`n", "`n") |
                            Should -BeExactly ($englishBlocks[$index].Code -replace "`r`n", "`n") -Because "$localizedPath block $index"
                    }
                }
            }

            $englishAboutPath = Join-Path -Path $script:EnglishRoot -ChildPath 'about_ColorScripts-Enhanced.help.txt'
            $localizedAboutPath = Join-Path -Path (Join-Path -Path $script:HelpRoot -ChildPath $cultureName) -ChildPath 'about_ColorScripts-Enhanced.help.txt'
            @(Get-AboutTechnicalToken -Content (Read-Utf8TextFile -LiteralPath $localizedAboutPath)) |
                Should -BeExactly @(Get-AboutTechnicalToken -Content (Read-Utf8TextFile -LiteralPath $englishAboutPath)) -Because $localizedAboutPath
        }
    }

    It 'does not copy English narrative lines into translated topics' {
        $failures = New-Object 'System.Collections.Generic.List[string]'
        foreach ($englishPath in Get-ChildItem -LiteralPath $script:EnglishRoot -Filter '*.md' -File) {
            $englishLines = @{}
            foreach ($entry in Get-TranslatableLine -Content (Read-Utf8TextFile -LiteralPath $englishPath.FullName)) {
                $englishLines[$entry.Text] = $true
            }

            foreach ($cultureName in $script:CultureNames) {
                $localizedPath = Join-Path -Path (Join-Path -Path $script:HelpRoot -ChildPath $cultureName) -ChildPath $englishPath.Name
                $localizedContent = Read-Utf8TextFile -LiteralPath $localizedPath
                foreach ($entry in Get-TranslatableLine -Content $localizedContent) {
                    if ($englishLines.ContainsKey($entry.Text)) {
                        [void]$failures.Add("$localizedPath`:$($entry.LineNumber): $($entry.Text)")
                    }
                }
                foreach ($match in [regex]::Matches(
                        $localizedContent,
                        '(?m)^(?:### (?:Best Practices|Troubleshooting).*|\*\*(?:Author|Encoding|Best Practices)\*\*.*)$')) {
                    [void]$failures.Add("$localizedPath`: untranslated label: $($match.Value)")
                }
            }
        }

        $englishAboutPath = Join-Path -Path $script:EnglishRoot -ChildPath 'about_ColorScripts-Enhanced.help.txt'
        $englishAboutLines = @{}
        foreach ($entry in Get-AboutTranslatableLine -Content (Read-Utf8TextFile -LiteralPath $englishAboutPath)) {
            $englishAboutLines[$entry.Text] = $true
        }
        foreach ($cultureName in $script:CultureNames) {
            $localizedAboutPath = Join-Path -Path (Join-Path -Path $script:HelpRoot -ChildPath $cultureName) -ChildPath 'about_ColorScripts-Enhanced.help.txt'
            foreach ($entry in Get-AboutTranslatableLine -Content (Read-Utf8TextFile -LiteralPath $localizedAboutPath)) {
                if ($englishAboutLines.ContainsKey($entry.Text)) {
                    [void]$failures.Add("$localizedAboutPath`:$($entry.LineNumber): $($entry.Text)")
                }
            }
        }

        @($failures) | Should -BeNullOrEmpty
    }
}
