function Get-ColorScriptCompletionPattern {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter()][AllowNull()][AllowEmptyString()][string]$WordToComplete
    )

    if ([string]::IsNullOrWhiteSpace($WordToComplete)) {
        return '*'
    }

    $trimmed = $WordToComplete.Trim([char]0x27, [char]0x22)
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        return '*'
    }
    if ($trimmed -match '[*?]') {
        return $trimmed
    }
    return $trimmed + '*'
}

function Get-ColorScriptListCompletionRecord {
    [CmdletBinding()]
    [OutputType([pscustomobject[]])]
    param()

    try {
        return [pscustomobject[]]@(ColorScripts-Enhanced\Get-ColorScriptList -AsObject -Quiet -ErrorAction Stop -WarningAction SilentlyContinue)
    }
    catch {
        return [pscustomobject[]]@()
    }
}

function Get-ColorScriptNameCompletion {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.CompletionResult[]])]
    param(
        [Parameter()][AllowNull()][AllowEmptyString()][string]$WordToComplete
    )

    $pattern = Get-ColorScriptCompletionPattern -WordToComplete $WordToComplete
    $records = Get-ColorScriptListCompletionRecord
    return [System.Management.Automation.CompletionResult[]]@($records |
            Where-Object { $_.Name -and $_.Name -like $pattern } |
                Group-Object -Property Name |
                    Sort-Object -Property Name |
                        ForEach-Object {
                            $first = $_.Group | Select-Object -First 1
                            $toolTip = if ($first.Description) {
                                $first.Description
                            }
                            elseif ($first.Category) {
                                "Category: $($first.Category)"
                            }
                            else {
                                $first.Name
                            }

                            [System.Management.Automation.CompletionResult]::new(
                                $first.Name,
                                $first.Name,
                                [System.Management.Automation.CompletionResultType]::ParameterValue,
                                $toolTip)
                        })
}

function Get-ColorScriptCategoryCompletion {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.CompletionResult[]])]
    param(
        [Parameter()][AllowNull()][AllowEmptyString()][string]$WordToComplete
    )

    $pattern = Get-ColorScriptCompletionPattern -WordToComplete $WordToComplete
    $values = foreach ($record in Get-ColorScriptListCompletionRecord) {
        if ($record.Category) {
            [string]$record.Category
        }
        foreach ($category in @($record.Categories)) {
            if ($category) {
                [string]$category
            }
        }
    }

    return [System.Management.Automation.CompletionResult[]]@($values |
            Where-Object { $_ -and $_ -like $pattern } |
                Group-Object |
                    Sort-Object -Property Name |
                        ForEach-Object {
                            [System.Management.Automation.CompletionResult]::new(
                                $_.Name,
                                $_.Name,
                                [System.Management.Automation.CompletionResultType]::ParameterValue,
                                '{0} script(s)' -f $_.Count)
                        })
}

function Get-ColorScriptTagCompletion {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.CompletionResult[]])]
    param(
        [Parameter()][AllowNull()][AllowEmptyString()][string]$WordToComplete
    )

    $pattern = Get-ColorScriptCompletionPattern -WordToComplete $WordToComplete
    $values = foreach ($record in Get-ColorScriptListCompletionRecord) {
        foreach ($tag in @($record.Tags)) {
            if ($tag) {
                [string]$tag
            }
        }
    }

    return [System.Management.Automation.CompletionResult[]]@($values |
            Where-Object { $_ -and $_ -like $pattern } |
                Group-Object |
                    Sort-Object -Property Name |
                        ForEach-Object {
                            [System.Management.Automation.CompletionResult]::new(
                                $_.Name,
                                $_.Name,
                                [System.Management.Automation.CompletionResultType]::ParameterValue,
                                '{0} reference(s)' -f $_.Count)
                        })
}

function Write-ColorScriptListTable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Record,
        [switch]$Detailed,
        [switch]$NoAnsiOutput,
        [switch]$Quiet
    )

    if ($Quiet) {
        return
    }

    $table = if ($Detailed) {
        $Record | Select-Object Name, Category, @{ Name = 'Tags'; Expression = { $_.Tags -join ', ' } }, Description
    }
    else {
        $Record | Select-Object Name, Category
    }
    $tableOutput = $table | Format-Table -AutoSize | Out-String
    if ($NoAnsiOutput) {
        $tableOutput = Remove-ColorScriptAnsiSequence -Text $tableOutput
    }
    Write-ColorScriptInformation -Message $tableOutput -Quiet:$false
}

function Get-ColorScriptList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Structured list is emitted for pipeline consumption.')]
    [OutputType([pscustomobject])]
    [CmdletBinding(HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList')]
    param(
        [Alias('help')]
        [switch]$h,

        [switch]$AsObject,
        [switch]$Detailed,
        [SupportsWildcards()]
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowWildcard })]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                $null = $commandName, $parameterName, $commandAst, $fakeBoundParameters
                Get-ColorScriptNameCompletion -WordToComplete $wordToComplete
            })]
        [string[]]$Name,
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                $null = $commandName, $parameterName, $commandAst, $fakeBoundParameters
                Get-ColorScriptCategoryCompletion -WordToComplete $wordToComplete
            })]
        [string[]]$Category,
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                $null = $commandName, $parameterName, $commandAst, $fakeBoundParameters
                Get-ColorScriptTagCompletion -WordToComplete $wordToComplete
            })]
        [string[]]$Tag,
        [switch]$Quiet,
        [switch]$NoAnsiOutput
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Get-ColorScriptList'
        return
    }

    $records = Get-ColorScriptEntry -Category $Category -Tag $Tag | Sort-Object Name
    if ($Name) {
        $selection = Select-RecordsByName -Records $records -Name $Name
        foreach ($pattern in $selection.MissingPatterns) {
            Write-Warning ($script:Messages.ScriptNotFound -f $pattern)
        }
        $records = $selection.Records
    }

    if (-not $records) {
        Write-Warning $script:Messages.NoColorscriptsAvailableWithFilters
        return [System.Object[]]@()
    }

    if (-not $AsObject) {
        Write-ColorScriptListTable -Record @($records) -Detailed:$Detailed -NoAnsiOutput:$NoAnsiOutput -Quiet:$Quiet
    }

    return $records
}
