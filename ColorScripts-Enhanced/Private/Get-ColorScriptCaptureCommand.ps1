function Get-ColorScriptCaptureCommand {
    <#
    .SYNOPSIS
        Returns the isolated renderer used by both in-process and child-process execution.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    return @'
param(
    [Parameter(Mandatory)]
    [string]$__cseScriptPath,

    [string]$__cseScriptDirectory
)

if (-not [string]::IsNullOrWhiteSpace($__cseScriptDirectory)) {
    Set-Location -LiteralPath $__cseScriptDirectory
}

$__cseOutputBuilder = [System.Text.StringBuilder]::new()
$__cseEscape = [string][char]27
$__cseForegroundCodes = @{
    Black = 30; DarkBlue = 34; DarkGreen = 32; DarkCyan = 36
    DarkRed = 31; DarkMagenta = 35; DarkYellow = 33; Gray = 37
    DarkGray = 90; Blue = 94; Green = 92; Cyan = 96
    Red = 91; Magenta = 95; Yellow = 93; White = 97
}
$__cseBackgroundCodes = @{
    Black = 40; DarkBlue = 44; DarkGreen = 42; DarkCyan = 46
    DarkRed = 41; DarkMagenta = 45; DarkYellow = 43; Gray = 47
    DarkGray = 100; Blue = 104; Green = 102; Cyan = 106
    Red = 101; Magenta = 105; Yellow = 103; White = 107
}

function Write-Host {
    param(
        [Parameter(Position = 0, ValueFromPipeline, ValueFromRemainingArguments)]
        [object[]]$Object,

        [object]$Separator = ' ',

        [switch]$NoNewline,

        [System.ConsoleColor]$ForegroundColor,

        [System.ConsoleColor]$BackgroundColor
    )

    process {
        $__cseColorCodes = @()
        if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
            $__cseColorCodes += $__cseForegroundCodes[[string]$ForegroundColor]
        }
        if ($PSBoundParameters.ContainsKey('BackgroundColor')) {
            $__cseColorCodes += $__cseBackgroundCodes[[string]$BackgroundColor]
        }
        if ($__cseColorCodes.Count -gt 0) {
            $null = $__cseOutputBuilder.Append($__cseEscape).Append('[').Append(
                [string]::Join(';', $__cseColorCodes)
            ).Append('m')
        }

        $__cseText = if ($null -eq $Object) {
            ''
        }
        else {
            # Windows PowerShell 5.1 binds comma-separated remaining arguments as one nested
            # Object[]; PowerShell 7 binds the same call as individual objects. Enumerating once
            # normalizes both shapes to the native Write-Host result before applying -Separator.
            $__cseHostObjects = @($Object | ForEach-Object { $_ })
            [string]::Join([string]$Separator, [object[]]$__cseHostObjects)
        }
        $null = $__cseOutputBuilder.Append($__cseText)

        if ($__cseColorCodes.Count -gt 0) {
            $null = $__cseOutputBuilder.Append($__cseEscape).Append('[0m')
        }
        if (-not $NoNewline) {
            $null = $__cseOutputBuilder.Append([Environment]::NewLine)
        }
    }
}

$__csePipelineOutput = & ([ScriptBlock]::Create(
        [System.IO.File]::ReadAllText($__cseScriptPath, [System.Text.Encoding]::UTF8)
    ))
foreach ($__cseItem in $__csePipelineOutput) {
    $null = $__cseOutputBuilder.AppendLine([string]$__cseItem)
}

return $__cseOutputBuilder.ToString()
'@
}
