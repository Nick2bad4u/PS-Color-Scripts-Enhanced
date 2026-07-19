function ConvertTo-StaticColorScriptEvaluationResult {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [bool]$Success,

        [Parameter()]
        [AllowNull()]
        [object]$Value
    )

    return [pscustomobject]@{
        Success = $Success
        Value   = $Value
    }
}

function Resolve-StaticColorScriptExpandedString {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ExpandableStringExpressionAst]$Expression,

        [Parameter(Mandatory)]
        [System.Collections.Generic.IDictionary[string, object]]$Variables
    )

    if ($Expression.NestedExpressions.Count -eq 0) {
        try {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value ([string]$Expression.SafeGetValue())
        }
        catch {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }
    }

    $tokenPatterns = [System.Collections.Generic.Dictionary[string, string]]::new(
        [System.StringComparer]::Ordinal)
    $replacementTokens = [System.Collections.Generic.List[string]]::new()
    $replacementVariableNames = [System.Collections.Generic.List[string]]::new()

    for ($index = 0; $index -lt $Expression.NestedExpressions.Count; $index++) {
        $nestedExpression = $Expression.NestedExpressions[$index]
        $variableExpression = $nestedExpression -as [System.Management.Automation.Language.VariableExpressionAst]

        if ($nestedExpression -is [System.Management.Automation.Language.SubExpressionAst]) {
            $subStatements = @($nestedExpression.SubExpression.Statements)
            $subPipeline = if ($subStatements.Count -eq 1) {
                $subStatements[0] -as [System.Management.Automation.Language.PipelineAst]
            }
            else {
                $null
            }
            $subCommandExpression = if ($subPipeline -and
                $subPipeline.PipelineElements.Count -eq 1 -and
                -not $subPipeline.Background) {
                $subPipeline.PipelineElements[0] -as [System.Management.Automation.Language.CommandExpressionAst]
            }
            else {
                $null
            }

            if (-not $subCommandExpression -or $subCommandExpression.Redirections.Count -ne 0) {
                return ConvertTo-StaticColorScriptEvaluationResult -Success $false
            }

            $variableExpression = $subCommandExpression.Expression -as [System.Management.Automation.Language.VariableExpressionAst]
        }

        if (-not $variableExpression -or
            -not $variableExpression.VariablePath.IsUnqualified -or
            $variableExpression.Splatted) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        $variableName = $variableExpression.VariablePath.UserPath
        $simpleTokenText = '$' + $variableName
        $bracedTokenText = '${' + $variableName + '}'
        $subExpressionTokenText = '$(' + $variableExpression.Extent.Text + ')'
        $tokenText = $nestedExpression.Extent.Text
        $supportedTokenText = (
            $tokenText -ceq $simpleTokenText -or
            $tokenText -ceq $bracedTokenText -or
            $tokenText -ceq $subExpressionTokenText)
        if ([string]::IsNullOrWhiteSpace($variableName) -or
            $variableName -notmatch '^[A-Za-z_][A-Za-z0-9_]*$' -or
            -not $supportedTokenText -or
            -not $Variables.ContainsKey($variableName)) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        $variableValue = $Variables[$variableName]
        if ($variableValue -isnot [string] -and $variableValue -isnot [char]) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        if (-not $tokenPatterns.ContainsKey($tokenText)) {
            $hasExplicitBoundary = (
                $tokenText.StartsWith('$(', [System.StringComparison]::Ordinal) -or
                $tokenText.StartsWith('${', [System.StringComparison]::Ordinal))
            $tokenBoundary = if ($hasExplicitBoundary) {
                ''
            }
            else {
                '(?![A-Za-z0-9_])'
            }
            $tokenPatterns.Add($tokenText, ([regex]::Escape($tokenText) + $tokenBoundary))
        }

        $replacementTokens.Add($tokenText)
        $replacementVariableNames.Add($variableName)
    }

    $orderedTokenTexts = @($tokenPatterns.Keys | Sort-Object -Property { $_.Length } -Descending)
    $orderedTokenPatterns = @($orderedTokenTexts | ForEach-Object { $tokenPatterns[$_] })
    $tokenRegex = [regex]::new(
        ('(?:' + ($orderedTokenPatterns -join '|') + ')'),
        [System.Text.RegularExpressions.RegexOptions]::CultureInvariant)
    $template = [string]$Expression.Value
    $templateMatches = $tokenRegex.Matches($template)
    if ($templateMatches.Count -ne $replacementTokens.Count) {
        # If the decoded string contains an escaped occurrence of the same variable token,
        # source offsets no longer map to the decoded template. Fail closed instead of
        # guessing which occurrence PowerShell would expand.
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    $builder = New-Object System.Text.StringBuilder
    $templateOffset = 0
    for ($index = 0; $index -lt $templateMatches.Count; $index++) {
        $match = $templateMatches[$index]
        if ($match.Value -cne $replacementTokens[$index]) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        $null = $builder.Append($template.Substring($templateOffset, $match.Index - $templateOffset))
        $null = $builder.Append([string]$Variables[$replacementVariableNames[$index]])
        $templateOffset = $match.Index + $match.Length
    }

    $null = $builder.Append($template.Substring($templateOffset))
    return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value $builder.ToString()
}

function Resolve-StaticColorScriptExpression {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ExpressionAst]$Expression,

        [Parameter(Mandatory)]
        [System.Collections.Generic.IDictionary[string, object]]$Variables
    )

    if ($Expression -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value ([string]$Expression.Value)
    }

    if ($Expression -is [System.Management.Automation.Language.ExpandableStringExpressionAst]) {
        return Resolve-StaticColorScriptExpandedString -Expression $Expression -Variables $Variables
    }

    if ($Expression -is [System.Management.Automation.Language.VariableExpressionAst]) {
        $variableName = $Expression.VariablePath.UserPath
        if (-not $Expression.VariablePath.IsUnqualified -or
            $Expression.Splatted -or
            [string]::IsNullOrWhiteSpace($variableName) -or
            $variableName -notmatch '^[A-Za-z_][A-Za-z0-9_]*$' -or
            -not $Variables.ContainsKey($variableName)) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value $Variables[$variableName]
    }

    if ($Expression -is [System.Management.Automation.Language.ConvertExpressionAst]) {
        $typeName = $Expression.Type.TypeName.FullName
        $allowedCharType = (
            [string]::Equals($typeName, 'char', [System.StringComparison]::OrdinalIgnoreCase) -or
            [string]::Equals($typeName, 'System.Char', [System.StringComparison]::OrdinalIgnoreCase))
        $constant = $Expression.Child -as [System.Management.Automation.Language.ConstantExpressionAst]
        if (-not $allowedCharType -or -not $constant) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        $numericTypes = @(
            [byte], [sbyte], [int16], [uint16], [int32], [uint32], [int64], [uint64])
        if ($null -eq $constant.Value -or $constant.Value.GetType() -notin $numericTypes) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        try {
            $codePoint = [System.Convert]::ToInt64($constant.Value, [System.Globalization.CultureInfo]::InvariantCulture)
            if ($codePoint -lt [char]::MinValue -or $codePoint -gt [char]::MaxValue) {
                return ConvertTo-StaticColorScriptEvaluationResult -Success $false
            }

            return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value ([char]$codePoint)
        }
        catch {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }
    }

    if ($Expression -is [System.Management.Automation.Language.BinaryExpressionAst] -and
        $Expression.Operator -eq [System.Management.Automation.Language.TokenKind]::Plus) {
        $left = Resolve-StaticColorScriptExpression -Expression $Expression.Left -Variables $Variables
        if (-not $left.Success -or $left.Value -isnot [string]) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        $right = Resolve-StaticColorScriptExpression -Expression $Expression.Right -Variables $Variables
        if (-not $right.Success -or $right.Value -isnot [string]) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value ($left.Value + $right.Value)
    }

    return ConvertTo-StaticColorScriptEvaluationResult -Success $false
}

function Get-StaticColorScriptOutput {
    <#
    .SYNOPSIS
        Extracts output from a colorscript that uses a provably static subset of PowerShell.

    .DESCRIPTION
        Parses the script without executing it and interprets only a deliberately narrow AST
        subset used by bundled static colorscripts: simple variable assignments, literal strings,
        [char] constants, previously assigned variable interpolation, string concatenation, and
        one or more Write-Host statements. Any command execution, member access, subexpression,
        control flow, redirection, scoped or unknown variable, nontrivial subexpression,
        unsupported cast, or other syntax fails closed so the caller retains isolated process
        execution.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    $notAvailable = [pscustomobject]@{
        Available = $false
        Content   = ''
    }

    if ([string]::IsNullOrWhiteSpace($ScriptPath) -or -not (Test-Path -LiteralPath $ScriptPath -PathType Leaf)) {
        return $notAvailable
    }

    try {
        # Windows PowerShell 5.1 treats UTF-8 files without a BOM as the active ANSI code page
        # when ParseFile is used. Read as UTF-8 explicitly so adjacent Unicode artwork cannot be
        # misparsed as part of a variable name.
        $source = [System.IO.File]::ReadAllText($ScriptPath, [System.Text.Encoding]::UTF8)
        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseInput(
            $source,
            $ScriptPath,
            [ref]$tokens,
            [ref]$parseErrors)

        if ($parseErrors.Count -gt 0 -or
            $ast.ParamBlock -or
            $ast.BeginBlock -or
            $ast.ProcessBlock -or
            $ast.DynamicParamBlock -or
            ($ast.PSObject.Properties['CleanBlock'] -and $ast.CleanBlock) -or
            $ast.UsingStatements.Count -gt 0 -or
            $ast.Attributes.Count -gt 0) {
            return $notAvailable
        }

        $statements = @($ast.EndBlock.Statements)
        if ($statements.Count -eq 0) {
            return $notAvailable
        }

        $variables = [System.Collections.Generic.Dictionary[string, object]]::new(
            [System.StringComparer]::OrdinalIgnoreCase)
        $output = New-Object System.Text.StringBuilder
        $outputStatementSeen = $false

        foreach ($statement in $statements) {
            if ($statement -is [System.Management.Automation.Language.AssignmentStatementAst]) {
                if ($outputStatementSeen -or
                    $statement.Operator -ne [System.Management.Automation.Language.TokenKind]::Equals -or
                    $statement.Left -isnot [System.Management.Automation.Language.VariableExpressionAst] -or
                    -not $statement.Left.VariablePath.IsUnqualified -or
                    $statement.Left.Splatted) {
                    return $notAvailable
                }

                $variableName = $statement.Left.VariablePath.UserPath
                $right = $statement.Right -as [System.Management.Automation.Language.CommandExpressionAst]
                if ([string]::IsNullOrWhiteSpace($variableName) -or
                    $variableName -notmatch '^[A-Za-z_][A-Za-z0-9_]*$' -or
                    $variables.ContainsKey($variableName) -or
                    -not $right -or
                    $right.Redirections.Count -ne 0) {
                    return $notAvailable
                }

                $evaluation = Resolve-StaticColorScriptExpression -Expression $right.Expression -Variables $variables
                if (-not $evaluation.Success -or
                    ($evaluation.Value -isnot [string] -and $evaluation.Value -isnot [char])) {
                    return $notAvailable
                }

                $variables.Add($variableName, $evaluation.Value)
                continue
            }

            $pipeline = $statement -as [System.Management.Automation.Language.PipelineAst]
            if (-not $pipeline -or
                $pipeline.PipelineElements.Count -ne 1 -or
                $pipeline.Background) {
                return $notAvailable
            }

            $command = $pipeline.PipelineElements[0] -as [System.Management.Automation.Language.CommandAst]
            if (-not $command -or
                $command.InvocationOperator -ne [System.Management.Automation.Language.TokenKind]::Unknown -or
                -not [string]::Equals($command.GetCommandName(), 'Write-Host', [System.StringComparison]::OrdinalIgnoreCase) -or
                $command.Redirections.Count -ne 0 -or
                $command.CommandElements.Count -gt 2) {
                return $notAvailable
            }

            $outputStatementSeen = $true
            if ($command.CommandElements.Count -eq 2) {
                $argument = $command.CommandElements[1] -as [System.Management.Automation.Language.ExpressionAst]
                if (-not $argument) {
                    return $notAvailable
                }

                $evaluation = Resolve-StaticColorScriptExpression -Expression $argument -Variables $variables
                if (-not $evaluation.Success -or
                    ($evaluation.Value -isnot [string] -and $evaluation.Value -isnot [char])) {
                    return $notAvailable
                }

                $null = $output.Append([string]$evaluation.Value)
            }

            $null = $output.Append([Environment]::NewLine)
        }

        if (-not $outputStatementSeen) {
            return $notAvailable
        }

        # Preserve the literal ANSI payload. The public rendering boundary is responsible for
        # removing it only when the caller explicitly requests -NoAnsiOutput.
        return [pscustomobject]@{
            Available = $true
            Content   = $output.ToString()
        }
    }
    catch {
        Write-Verbose ("Static colorscript extraction failed for {0}: {1}" -f $ScriptPath, $_.Exception.Message)
        return $notAvailable
    }
}
