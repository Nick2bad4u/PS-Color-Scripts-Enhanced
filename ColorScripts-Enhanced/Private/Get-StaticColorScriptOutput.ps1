function Get-StaticColorScriptOutput {
    <#
    .SYNOPSIS
        Extracts output from a colorscript that is a single literal Write-Host statement.

    .DESCRIPTION
        Parses the script without executing it and only accepts a deliberately narrow AST shape:
        one Write-Host command with one non-interpolated string argument and no redirections.
        Any other syntax fails closed so the caller can retain isolated process execution.
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
        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $ScriptPath,
            [ref]$tokens,
            [ref]$parseErrors)

        if ($parseErrors.Count -gt 0) {
            return $notAvailable
        }

        $statements = @($ast.EndBlock.Statements)
        if ($statements.Count -ne 1) {
            return $notAvailable
        }

        $pipeline = $statements[0] -as [System.Management.Automation.Language.PipelineAst]
        if (-not $pipeline -or $pipeline.PipelineElements.Count -ne 1) {
            return $notAvailable
        }

        $command = $pipeline.PipelineElements[0] -as [System.Management.Automation.Language.CommandAst]
        if (-not $command -or
            $command.GetCommandName() -ne 'Write-Host' -or
            $command.CommandElements.Count -ne 2 -or
            $command.Redirections.Count -ne 0) {
            return $notAvailable
        }

        $argument = $command.CommandElements[1]
        $isStringConstant = $argument -is [System.Management.Automation.Language.StringConstantExpressionAst]
        $isStaticExpandableString = (
            $argument -is [System.Management.Automation.Language.ExpandableStringExpressionAst] -and
            $argument.NestedExpressions.Count -eq 0)
        $isStaticString = $isStringConstant -or $isStaticExpandableString

        if (-not $isStaticString) {
            return $notAvailable
        }

        # Preserve the literal ANSI payload. The public rendering boundary is responsible for
        # removing it only when the caller explicitly requests -NoAnsiOutput.
        $content = [string]$argument.SafeGetValue()
        return [pscustomobject]@{
            Available = $true
            Content   = $content + [Environment]::NewLine
        }
    }
    catch {
        Write-Verbose ("Static colorscript extraction failed for {0}: {1}" -f $ScriptPath, $_.Exception.Message)
        return $notAvailable
    }
}
