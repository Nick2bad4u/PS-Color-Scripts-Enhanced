function Show-ColorScriptHelp {
    <#
    .SYNOPSIS
    Displays colorized help output for a command.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Write-Host is intentionally used for colored help output to the console.')]
    param(
        [Parameter(Mandatory)]
        [string]$CommandName
    )

    $helpContent = Get-Help $CommandName -Full | Out-String
    $lines = $helpContent -split "`n"

    foreach ($line in $lines) {
        if ($line -match '^NAME$|^SYNOPSIS$|^SYNTAX$|^DESCRIPTION$|^PARAMETERS$|^EXAMPLES$|^INPUTS$|^OUTPUTS$|^NOTES$|^RELATED LINKS$') {
            Write-Host $line -ForegroundColor Cyan
        }
        elseif ($line -match '^\s+-\w+') {
            Write-Host $line -ForegroundColor Yellow
        }
        elseif ($line -match '^\s+--') {
            Write-Host $line -ForegroundColor Green
        }
        elseif ($line -match 'EXAMPLE \d+') {
            Write-Host $line -ForegroundColor Magenta
        }
        elseif ($line -match '^\s+Required\?|^\s+Position\?|^\s+Default value|^\s+Accept pipeline input\?|^\s+Accept wildcard characters\?') {
            Write-Host $line -ForegroundColor DarkGray
        }
        else {
            Write-Host $line
        }
    }
}
