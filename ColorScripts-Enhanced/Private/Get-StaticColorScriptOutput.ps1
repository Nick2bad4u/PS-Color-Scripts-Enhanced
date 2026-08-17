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

function Get-StaticExpandedStringVariableExpression {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.Language.VariableExpressionAst])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ExpressionAst]$NestedExpression
    )

    if ($NestedExpression -is [System.Management.Automation.Language.VariableExpressionAst]) {
        return [System.Management.Automation.Language.VariableExpressionAst]$NestedExpression
    }

    if ($NestedExpression -isnot [System.Management.Automation.Language.SubExpressionAst]) {
        return $null
    }

    $statements = @($NestedExpression.SubExpression.Statements)
    if ($statements.Count -ne 1) {
        return $null
    }

    $pipeline = $statements[0] -as [System.Management.Automation.Language.PipelineAst]
    if (-not $pipeline -or $pipeline.PipelineElements.Count -ne 1 -or $pipeline.Background) {
        return $null
    }

    $commandExpression = $pipeline.PipelineElements[0] -as [System.Management.Automation.Language.CommandExpressionAst]
    if (-not $commandExpression -or $commandExpression.Redirections.Count -ne 0) {
        return $null
    }

    return $commandExpression.Expression -as [System.Management.Automation.Language.VariableExpressionAst]
}

function Test-StaticExpandedStringTokenText {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)][string]$TokenText,
        [Parameter(Mandatory)][string]$VariableName,
        [Parameter(Mandatory)][string]$VariableExtentText
    )

    $simpleTokenText = '$' + $VariableName
    $bracedTokenText = '${' + $VariableName + '}'
    $subExpressionTokenText = '$(' + $VariableExtentText + ')'
    return $TokenText -ceq $simpleTokenText -or
    $TokenText -ceq $bracedTokenText -or
    $TokenText -ceq $subExpressionTokenText
}

function ConvertTo-StaticExpandedStringToken {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ExpressionAst]$NestedExpression,

        [Parameter(Mandatory)]
        [System.Collections.Generic.IDictionary[string, object]]$Variables
    )

    $variableExpression = Get-StaticExpandedStringVariableExpression -NestedExpression $NestedExpression
    if (-not $variableExpression -or
        -not $variableExpression.VariablePath.IsUnqualified -or
        $variableExpression.Splatted) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    $variableName = $variableExpression.VariablePath.UserPath
    $tokenText = $NestedExpression.Extent.Text
    $supportedTokenText = Test-StaticExpandedStringTokenText -TokenText $tokenText -VariableName $variableName -VariableExtentText $variableExpression.Extent.Text
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

    $hasExplicitBoundary = $tokenText.StartsWith('$(', [System.StringComparison]::Ordinal) -or
    $tokenText.StartsWith('${', [System.StringComparison]::Ordinal)
    $tokenBoundary = if ($hasExplicitBoundary) { '' } else { '(?![A-Za-z0-9_])' }
    return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value ([pscustomobject]@{
            Text         = $tokenText
            Pattern      = [regex]::Escape($tokenText) + $tokenBoundary
            VariableName = $variableName
        })
}

function Get-StaticExpandedStringTokenPlan {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ExpandableStringExpressionAst]$Expression,

        [Parameter(Mandatory)]
        [System.Collections.Generic.IDictionary[string, object]]$Variables
    )

    $tokenPatterns = [System.Collections.Generic.Dictionary[string, string]]::new(
        [System.StringComparer]::Ordinal)
    $replacementTokens = [System.Collections.Generic.List[string]]::new()
    $replacementVariableNames = [System.Collections.Generic.List[string]]::new()

    foreach ($nestedExpression in $Expression.NestedExpressions) {
        $tokenResult = ConvertTo-StaticExpandedStringToken -NestedExpression $nestedExpression -Variables $Variables
        if (-not $tokenResult.Success) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        $token = $tokenResult.Value
        if (-not $tokenPatterns.ContainsKey($token.Text)) {
            $tokenPatterns.Add($token.Text, $token.Pattern)
        }
        $replacementTokens.Add($token.Text)
        $replacementVariableNames.Add($token.VariableName)
    }

    $orderedTokenTexts = @($tokenPatterns.Keys | Sort-Object -Property { $_.Length } -Descending)
    $orderedTokenPatterns = @($orderedTokenTexts | ForEach-Object { $tokenPatterns[$_] })
    return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value ([pscustomobject]@{
            Pattern       = '(?:' + ($orderedTokenPatterns -join '|') + ')'
            Token         = $replacementTokens
            VariableName  = $replacementVariableNames
        })
}

function ConvertFrom-StaticExpandedStringTemplate {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$Template,
        [Parameter(Mandatory)][object]$TokenPlan,
        [Parameter(Mandatory)]
        [System.Collections.Generic.IDictionary[string, object]]$Variables
    )

    $tokenRegex = [regex]::new(
        $TokenPlan.Pattern,
        [System.Text.RegularExpressions.RegexOptions]::CultureInvariant)
    $templateMatches = $tokenRegex.Matches($Template)
    if ($templateMatches.Count -ne $TokenPlan.Token.Count) {
        # If the decoded string contains an escaped occurrence of the same variable token,
        # source offsets no longer map to the decoded template. Fail closed instead of
        # guessing which occurrence PowerShell would expand.
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    $builder = New-Object System.Text.StringBuilder
    $templateOffset = 0
    for ($index = 0; $index -lt $templateMatches.Count; $index++) {
        $match = $templateMatches[$index]
        if ($match.Value -cne $TokenPlan.Token[$index]) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        $null = $builder.Append($Template.Substring($templateOffset, $match.Index - $templateOffset))
        $null = $builder.Append([string]$Variables[$TokenPlan.VariableName[$index]])
        $templateOffset = $match.Index + $match.Length
    }

    $null = $builder.Append($Template.Substring($templateOffset))
    return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value $builder.ToString()
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

    $tokenPlan = Get-StaticExpandedStringTokenPlan -Expression $Expression -Variables $Variables
    if (-not $tokenPlan.Success) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    return ConvertFrom-StaticExpandedStringTemplate -Template ([string]$Expression.Value) -TokenPlan $tokenPlan.Value -Variables $Variables
}

function Resolve-StaticColorScriptVariableExpression {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.VariableExpressionAst]$Expression,

        [Parameter(Mandatory)]
        [System.Collections.Generic.IDictionary[string, object]]$Variables
    )

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

function Resolve-StaticColorScriptCharacterExpression {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ConvertExpressionAst]$Expression
    )

    $typeName = $Expression.Type.TypeName.FullName
    $allowedCharType = [string]::Equals($typeName, 'char', [System.StringComparison]::OrdinalIgnoreCase) -or
    [string]::Equals($typeName, 'System.Char', [System.StringComparison]::OrdinalIgnoreCase)
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

function Resolve-StaticColorScriptConcatenationExpression {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.BinaryExpressionAst]$Expression,

        [Parameter(Mandatory)]
        [System.Collections.Generic.IDictionary[string, object]]$Variables
    )

    if ($Expression.Operator -ne [System.Management.Automation.Language.TokenKind]::Plus) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

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
        return Resolve-StaticColorScriptVariableExpression -Expression $Expression -Variables $Variables
    }

    if ($Expression -is [System.Management.Automation.Language.ConvertExpressionAst]) {
        return Resolve-StaticColorScriptCharacterExpression -Expression $Expression
    }

    if ($Expression -is [System.Management.Automation.Language.BinaryExpressionAst]) {
        return Resolve-StaticColorScriptConcatenationExpression -Expression $Expression -Variables $Variables
    }

    return ConvertTo-StaticColorScriptEvaluationResult -Success $false
}

function Test-StaticColorScriptAst {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ScriptBlockAst]$Ast
    )

    return -not (
        $Ast.ParamBlock -or
        $Ast.BeginBlock -or
        $Ast.ProcessBlock -or
        $Ast.DynamicParamBlock -or
        ($Ast.PSObject.Properties['CleanBlock'] -and $Ast.CleanBlock) -or
        $Ast.UsingStatements.Count -gt 0 -or
        $Ast.Attributes.Count -gt 0)
}

function Read-StaticColorScriptAst {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

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

    if ($parseErrors.Count -gt 0 -or -not (Test-StaticColorScriptAst -Ast $ast)) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    $statements = @($ast.EndBlock.Statements)
    if ($statements.Count -eq 0) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value $statements
}

function Resolve-StaticColorScriptAssignment {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.AssignmentStatementAst]$Statement,

        [Parameter(Mandatory)]
        [System.Collections.Generic.IDictionary[string, object]]$Variables
    )

    $variableExpression = $Statement.Left -as [System.Management.Automation.Language.VariableExpressionAst]
    if ($Statement.Operator -ne [System.Management.Automation.Language.TokenKind]::Equals -or
        -not $variableExpression -or
        -not $variableExpression.VariablePath.IsUnqualified -or
        $variableExpression.Splatted) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    $variableName = $variableExpression.VariablePath.UserPath
    $right = $Statement.Right -as [System.Management.Automation.Language.CommandExpressionAst]
    if ([string]::IsNullOrWhiteSpace($variableName) -or
        $variableName -notmatch '^[A-Za-z_][A-Za-z0-9_]*$' -or
        $Variables.ContainsKey($variableName) -or
        -not $right -or
        $right.Redirections.Count -ne 0) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    $evaluation = Resolve-StaticColorScriptExpression -Expression $right.Expression -Variables $Variables
    if (-not $evaluation.Success -or
        ($evaluation.Value -isnot [string] -and $evaluation.Value -isnot [char])) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value ([pscustomobject]@{
            Name  = $variableName
            Value = $evaluation.Value
        })
}

function Get-StaticWriteHostCommand {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.StatementAst]$Statement
    )

    $pipeline = $Statement -as [System.Management.Automation.Language.PipelineAst]
    if (-not $pipeline -or $pipeline.PipelineElements.Count -ne 1 -or $pipeline.Background) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    $command = $pipeline.PipelineElements[0] -as [System.Management.Automation.Language.CommandAst]
    if (-not $command -or
        $command.InvocationOperator -ne [System.Management.Automation.Language.TokenKind]::Unknown -or
        -not [string]::Equals($command.GetCommandName(), 'Write-Host', [System.StringComparison]::OrdinalIgnoreCase) -or
        $command.Redirections.Count -ne 0) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value $command
}

function Resolve-StaticWriteHostArgument {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.CommandAst]$Command
    )

    $argument = $null
    $noNewline = $false
    foreach ($element in @($Command.CommandElements | Select-Object -Skip 1)) {
        $parameter = $element -as [System.Management.Automation.Language.CommandParameterAst]
        if ($parameter) {
            if ($noNewline -or
                $parameter.Argument -or
                -not [string]::Equals($parameter.ParameterName, 'NoNewline', [System.StringComparison]::OrdinalIgnoreCase)) {
                return ConvertTo-StaticColorScriptEvaluationResult -Success $false
            }

            $noNewline = $true
            continue
        }

        $expression = $element -as [System.Management.Automation.Language.ExpressionAst]
        if (-not $expression -or $argument) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }

        $argument = $expression
    }

    return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value ([pscustomobject]@{
            Argument  = $argument
            NoNewline = $noNewline
        })
}

function Add-StaticWriteHostOutput {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)][object]$WriteHostArgument,
        [Parameter(Mandatory)]
        [System.Collections.Generic.IDictionary[string, object]]$Variables,
        [Parameter(Mandatory)]
        [System.Text.StringBuilder]$Output
    )

    if ($WriteHostArgument.Argument) {
        $evaluation = Resolve-StaticColorScriptExpression -Expression $WriteHostArgument.Argument -Variables $Variables
        if (-not $evaluation.Success -or
            ($evaluation.Value -isnot [string] -and $evaluation.Value -isnot [char])) {
            return $false
        }

        $null = $Output.Append([string]$evaluation.Value)
    }

    if (-not $WriteHostArgument.NoNewline) {
        $null = $Output.Append([Environment]::NewLine)
    }

    return $true
}

function Invoke-StaticColorScriptStatement {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.StatementAst]$Statement,
        [Parameter(Mandatory)][object]$State
    )

    if ($Statement -is [System.Management.Automation.Language.AssignmentStatementAst]) {
        if ($State.OutputStatementSeen) {
            return $false
        }

        $assignment = Resolve-StaticColorScriptAssignment -Statement $Statement -Variables $State.Variables
        if (-not $assignment.Success) {
            return $false
        }

        $State.Variables.Add($assignment.Value.Name, $assignment.Value.Value)
        return $true
    }

    $commandResult = Get-StaticWriteHostCommand -Statement $Statement
    if (-not $commandResult.Success) {
        return $false
    }

    $argumentResult = Resolve-StaticWriteHostArgument -Command $commandResult.Value
    if (-not $argumentResult.Success -or
        -not (Add-StaticWriteHostOutput -WriteHostArgument $argumentResult.Value -Variables $State.Variables -Output $State.Output)) {
        return $false
    }

    $State.OutputStatementSeen = $true
    return $true
}

function Invoke-StaticColorScriptStatementList {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.StatementAst[]]$Statement
    )

    $state = [pscustomobject]@{
        Variables           = [System.Collections.Generic.Dictionary[string, object]]::new(
            [System.StringComparer]::OrdinalIgnoreCase)
        Output              = New-Object System.Text.StringBuilder
        OutputStatementSeen = $false
    }

    foreach ($currentStatement in $Statement) {
        if (-not (Invoke-StaticColorScriptStatement -Statement $currentStatement -State $state)) {
            return ConvertTo-StaticColorScriptEvaluationResult -Success $false
        }
    }

    if (-not $state.OutputStatementSeen) {
        return ConvertTo-StaticColorScriptEvaluationResult -Success $false
    }

    return ConvertTo-StaticColorScriptEvaluationResult -Success $true -Value $state.Output.ToString()
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
        $astResult = Read-StaticColorScriptAst -ScriptPath $ScriptPath
        if (-not $astResult.Success) {
            return $notAvailable
        }

        $interpretation = Invoke-StaticColorScriptStatementList -Statement @($astResult.Value)
        if (-not $interpretation.Success) {
            return $notAvailable
        }

        # Preserve the literal ANSI payload. The public rendering boundary is responsible for
        # removing it only when the caller explicitly requests -NoAnsiOutput.
        return [pscustomobject]@{
            Available = $true
            Content   = $interpretation.Value
        }
    }
    catch {
        Write-Verbose ("Static colorscript extraction failed for {0}: {1}" -f $ScriptPath, $_.Exception.Message)
        return $notAvailable
    }
}
