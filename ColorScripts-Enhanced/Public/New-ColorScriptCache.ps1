function New-ColorScriptCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns structured pipeline records for each cache operation.')]
    [OutputType([pscustomobject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache')]
    [Alias('Update-ColorScriptCache')]
    param(
        [Parameter(ParameterSetName = 'Help')]
        [Alias('help')]
        [switch]$h,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
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

        [Parameter(ParameterSetName = 'All')]
        [switch]$All,

        [Parameter()]
        [switch]$Force,

        [Parameter()]
        [switch]$PassThru,

        [Parameter()]
        [string[]]$Category,

        [Parameter()]
        [string[]]$Tag
    )

    begin {
        if ($h) {
            Show-ColorScriptHelp -CommandName 'New-ColorScriptCache'
            return
        }

        Initialize-CacheDirectory
        $script:CacheDirReady = $true
        $script:CacheSummary = [pscustomobject]@{
            Processed = 0
            Updated   = 0
            Skipped   = 0
            Failed    = 0
        }

        $script:CacheResults = New-Object System.Collections.Generic.List[pscustomobject]
    }

    process {
        if ($h) {
            return
        }

        $filterCategory = $Category
        $filterTag = $Tag

        $records = Get-ColorScriptEntry -Category $filterCategory -Tag $filterTag

        if ($Name) {
            $selection = Select-RecordsByName -Records $records -Name $Name
            foreach ($pattern in $selection.MissingPatterns) {
                Write-Warning ($script:Messages.ScriptNotFoundForCache -f $pattern)
            }

            $records = $selection.Records
        }

        if (-not $All -and -not $Name -and -not $filterCategory -and -not $filterTag) {
            $records = Get-ColorScriptEntry
        }

        if (-not $records -or $records.Count -eq 0) {
            Write-Warning $script:Messages.NoColorscriptsAvailableForCaching
            return
        }

        foreach ($record in $records) {
            $script:CacheSummary.Processed++

            if (-not $Force) {
                $cacheEntry = Get-CachedOutput -ScriptPath $record.Path
                if ($cacheEntry.Available) {
                    $result = [pscustomobject]@{
                        Name        = $record.Name
                        ScriptPath  = $record.Path
                        CacheFile   = $cacheEntry.CacheFile
                        Status      = 'Skipped'
                        Message     = $script:Messages.CacheAlreadyUpToDate
                        CacheExists = $true
                    }
                    $script:CacheSummary.Skipped++
                    $null = $script:CacheResults.Add($result)
                    continue
                }
            }

            if (-not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $record.Name -Action 'Build colorscript cache')) {
                continue
            }

            $cacheResult = Build-ScriptCache -ScriptPath $record.Path

            if ($cacheResult.Success) {
                $script:CacheSummary.Updated++
                $status = 'Updated'
                $message = $script:Messages.CacheUpdated
            }
            else {
                $script:CacheSummary.Failed++
                $status = 'Failed'
                $message = if ($cacheResult.StdErr) { $cacheResult.StdErr } else { $script:Messages.CacheUpdateFailed }
            }

            $resultRecord = [pscustomobject]@{
                Name        = $cacheResult.ScriptName
                ScriptPath  = $record.Path
                CacheFile   = $cacheResult.CacheFile
                Status      = $status
                Message     = $message
                CacheExists = $cacheResult.Success
                ExitCode    = $cacheResult.ExitCode
                StdOut      = $cacheResult.StdOut
                StdErr      = $cacheResult.StdErr
            }

            $null = $script:CacheResults.Add($resultRecord)
        }
    }

    end {
        if ($h) {
            return
        }

        if (-not $PassThru -and $script:CacheSummary.Processed -gt 0) {
            $summaryMessage = $script:Messages.CacheSummaryTemplate -f $script:CacheSummary.Processed, $script:CacheSummary.Updated, $script:CacheSummary.Skipped, $script:CacheSummary.Failed
            Write-ColorScriptInformation -Message $summaryMessage -Quiet:$false
        }

        if ($PassThru) {
            return $script:CacheResults.ToArray()
        }
    }
}
