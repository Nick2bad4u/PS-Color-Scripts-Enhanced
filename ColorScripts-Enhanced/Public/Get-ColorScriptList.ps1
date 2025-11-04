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

            try {
                $records = ColorScripts-Enhanced\Get-ColorScriptList -AsObject -Quiet -ErrorAction Stop -WarningAction SilentlyContinue
            }
            catch {
                return
            }

            $pattern = if ([string]::IsNullOrWhiteSpace($wordToComplete)) {
                '*'
            }
            else {
                $trimmed = $wordToComplete.Trim([char]0x27, [char]0x22)
                if ([string]::IsNullOrWhiteSpace($trimmed)) { '*' }
                elseif ($trimmed -match '[*?]') { $trimmed }
                else { $trimmed + '*' }
            }

            $records |
                Where-Object { $_.Name -and ($_.Name -like $pattern) } |
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
                        $toolTip
                    )
                }
        })]
        [string[]]$Name,
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

            $null = $commandName, $parameterName, $commandAst, $fakeBoundParameters

            try {
                $records = ColorScripts-Enhanced\Get-ColorScriptList -AsObject -Quiet -ErrorAction Stop -WarningAction SilentlyContinue
            }
            catch {
                return
            }

            $pattern = if ([string]::IsNullOrWhiteSpace($wordToComplete)) {
                '*'
            }
            else {
                $trimmed = $wordToComplete.Trim([char]0x27, [char]0x22)
                if ([string]::IsNullOrWhiteSpace($trimmed)) { '*' }
                elseif ($trimmed -match '[*?]') { $trimmed }
                else { $trimmed + '*' }
            }

            $values = foreach ($record in $records) {
                if ($record.Category) { [string]$record.Category }
                if ($record.Categories) {
                    foreach ($entry in @($record.Categories)) {
                        if ($entry) { [string]$entry }
                    }
                }
            }

            $values |
                Where-Object { $_ -and ($_ -like $pattern) } |
                Group-Object |
                Sort-Object -Property Name |
                ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new(
                        $_.Name,
                        $_.Name,
                        [System.Management.Automation.CompletionResultType]::ParameterValue,
                        '{0} script(s)' -f $_.Count
                    )
                }
        })]
        [string[]]$Category,
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

            $null = $commandName, $parameterName, $commandAst, $fakeBoundParameters

            try {
                $records = ColorScripts-Enhanced\Get-ColorScriptList -AsObject -Quiet -ErrorAction Stop -WarningAction SilentlyContinue
            }
            catch {
                return
            }

            $pattern = if ([string]::IsNullOrWhiteSpace($wordToComplete)) {
                '*'
            }
            else {
                $trimmed = $wordToComplete.Trim([char]0x27, [char]0x22)
                if ([string]::IsNullOrWhiteSpace($trimmed)) { '*' }
                elseif ($trimmed -match '[*?]') { $trimmed }
                else { $trimmed + '*' }
            }

            $values = foreach ($record in $records) {
                foreach ($tag in @($record.Tags)) {
                    if ($tag) { [string]$tag }
                }
            }

            $values |
                Where-Object { $_ -and ($_ -like $pattern) } |
                Group-Object |
                Sort-Object -Property Name |
                ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new(
                        $_.Name,
                        $_.Name,
                        [System.Management.Automation.CompletionResultType]::ParameterValue,
                        '{0} reference(s)' -f $_.Count
                    )
                }
        })]
        [string[]]$Tag,
        [switch]$Quiet,
        [switch]$NoAnsiOutput
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Get-ColorScriptList'
        return
    }

    $quietRequested = $Quiet.IsPresent

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
        $table = if ($Detailed) {
            $records | Select-Object Name, Category, @{ Name = 'Tags'; Expression = { $_.Tags -join ', ' } }, Description
        }
        else {
            $records | Select-Object Name, Category
        }

        if (-not $quietRequested) {
            $tableOutput = $table | Format-Table -AutoSize | Out-String
            if ($NoAnsiOutput) {
                $tableOutput = Remove-ColorScriptAnsiSequence -Text $tableOutput
            }
            Write-ColorScriptInformation -Message $tableOutput -Quiet:$false
        }
    }

    return $records
}
