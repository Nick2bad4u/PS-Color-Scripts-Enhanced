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

function script:Get-PowerShellTechnicalSignatureNode {
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.Ast]$Node,

        [Parameter(Mandatory)]
        [string[]]$DisplayCommands
    )

    if ($Node -is [System.Management.Automation.Language.CommandAst]) {
        $commandName = $Node.GetCommandName()
        if (-not [string]::IsNullOrWhiteSpace($commandName)) {
            return "Command:$commandName"
        }
        return $null
    }
    if ($Node -is [System.Management.Automation.Language.CommandParameterAst]) {
        return "Parameter:$($Node.ParameterName)"
    }
    if ($Node -is [System.Management.Automation.Language.VariableExpressionAst]) {
        return "Variable:$($Node.VariablePath.UserPath)"
    }
    if ($Node -is [System.Management.Automation.Language.MemberExpressionAst]) {
        return "Member:$($Node.Member.Extent.Text)"
    }
    if ($Node -is [System.Management.Automation.Language.TypeExpressionAst]) {
        return "Type:$($Node.TypeName.FullName)"
    }

    $parentCommand = $Node.Parent
    while ($parentCommand -and $parentCommand -isnot [System.Management.Automation.Language.CommandAst]) {
        $parentCommand = $parentCommand.Parent
    }
    if ($parentCommand -and $DisplayCommands -contains $parentCommand.GetCommandName()) {
        return $null
    }
    return "String:$($Node.Extent.Text)"
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
        $nodeSignature = Get-PowerShellTechnicalSignatureNode -Node $node -DisplayCommands $displayCommands
        if ($null -ne $nodeSignature) {
            [void]$signature.Add($nodeSignature)
        }
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

function script:Update-MarkdownParsingState {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Trimmed,

        [Parameter(Mandatory)]
        [hashtable]$State
    )

    if ($Trimmed -eq '---' -and $null -eq $State.FenceLanguage) {
        if (-not $State.FrontmatterSeen) {
            $State.FrontmatterSeen = $true
            $State.InFrontmatter = $true
        }
        elseif ($State.InFrontmatter) {
            $State.InFrontmatter = $false
        }
        return $true
    }
    if ($Trimmed -match '^```(?<Language>[A-Za-z0-9_-]*)\s*$') {
        if ($null -eq $State.FenceLanguage) {
            $State.FenceLanguage = $Matches.Language.ToLowerInvariant()
        }
        else {
            $State.FenceLanguage = $null
        }
        return $true
    }
    return $false
}

function script:Get-PowerShellFenceCandidate {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Candidate,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$FenceLanguage
    )

    if ($FenceLanguage -notin @('powershell', 'pwsh')) {
        return $null
    }
    if ($Candidate.StartsWith('#')) {
        $comment = $Candidate.TrimStart('#', ' ')
        if ($comment -match '^(?:\$|[A-Z][A-Za-z]+-[A-Z][A-Za-z-]+(?:\s|$)|-[A-Z][A-Za-z0-9]*(?:\s|$))') {
            return $null
        }
        return $comment
    }
    if ($Candidate -match '#\s*(?<Text>[A-Za-z].+)$') {
        return $Matches.Text
    }
    if ($Candidate -match '^Write-(?:Debug|Error|Host|Information|Output|Verbose|Warning)\s+"(?<Text>.*)"\s*$') {
        return $Matches.Text
    }
    return $null
}

function script:Test-TranslatableLineCandidate {
    param([AllowNull()][string]$Candidate)

    if ([string]::IsNullOrWhiteSpace($Candidate) -or
        $Candidate.StartsWith('#') -or
        $Candidate -match '^(?:-[A-Z][A-Za-z]+,\s*)+-[A-Z][A-Za-z]+,?$' -or
        $Candidate -match '^\[about_CommonParameters\]\(' -or
        $Candidate -match '^- \[[^]]+\]\(https?://' -or
        $Candidate -match '^(?:Type|DefaultValue|SupportsWildcards|Aliases|ParameterSets|Position|IsRequired|ValueFromPipeline|ValueFromPipelineByPropertyName|ValueFromRemainingArguments|DontShow|AcceptedValues|HelpMessage):') {
        return $false
    }
    return $true
}

function script:Get-TranslatableLine {
    param([Parameter(Mandatory)][string]$Content)

    $state = @{
        InFrontmatter  = $false
        FrontmatterSeen = $false
        FenceLanguage = $null
    }
    $lineNumber = 0
    foreach ($line in $Content -split '\r?\n') {
        $lineNumber++
        $trimmed = $line.Trim()
        if (Update-MarkdownParsingState -Trimmed $trimmed -State $state) {
            continue
        }

        if ($state.InFrontmatter) {
            continue
        }

        $candidate = $trimmed
        if ($null -ne $state.FenceLanguage) {
            $candidate = Get-PowerShellFenceCandidate -Candidate $candidate -FenceLanguage $state.FenceLanguage
        }

        if (-not (Test-TranslatableLineCandidate -Candidate $candidate)) {
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
