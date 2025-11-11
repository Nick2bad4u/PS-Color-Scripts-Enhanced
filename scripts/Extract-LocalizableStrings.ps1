<#
.SYNOPSIS
    Extracts user-facing strings from PowerShell module for localization
    Analyzes Write-Warning, Write-Error, throw statements, and other user messages

.PARAMETER ModulePath
    Path to the PowerShell module file (.psm1)

.PARAMETER OutputPath
    Path where to save the extracted messages PSD1 file

.EXAMPLE
    .\Extract-LocalizableStrings.ps1 -ModulePath "ColorScripts-Enhanced.psm1" -OutputPath "Messages.psd1"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$ModulePath,

    [Parameter(Mandatory)]
    [string]$OutputPath
)

$content = Get-Content -Path $ModulePath -Raw -Encoding UTF8

# Patterns to find user-facing strings
$patterns = @(
    # Write-Warning "message"
    '(?m)Write-Warning\s+["'']([^"'']+)["'']',

    # Write-Error "message"
    '(?m)Write-Error\s+["'']([^"'']+)["'']',

    # throw "message"
    '(?m)throw\s+["'']([^"'']+)["'']',

    # Write-Host "message" (excluding colored help)
    '(?m)Write-Host\s+["'']([^"'']+)["'']\s*(?!-ForegroundColor)',

    # Write-Output "message"
    '(?m)Write-Output\s+["'']([^"'']+)["'']'
)

$messages = @{}
$messageCount = 0

foreach ($pattern in $patterns) {
    $regexMatches = [regex]::Matches($content, $pattern)

    foreach ($match in $regexMatches) {
        if ($match.Groups.Count -gt 1) {
            $message = $match.Groups[1].Value

            # Skip if already processed or empty
            if ([string]::IsNullOrWhiteSpace($message) -or $messages.ContainsKey($message)) {
                continue
            }

            # Create semantic key from message
            $key = $message -replace '[^a-zA-Z0-9]', '' -replace '(.{30}).*', '$1'
            if ($key.Length -lt 3) {
                $key = "Msg$messageCount"
            }

            $messages[$message] = $key
            $messageCount++
        }
    }
}

# Generate PSD1 content
$psd1Content = @"
ConvertFrom-StringData @'
# Auto-generated from $ModulePath
# Generated on $(Get-Date -Format 'yyyy-MM-dd')
# Found $messageCount user-facing messages

"@

foreach ($message in $messages.Keys) {
    $key = $messages[$message]
    # Escape single quotes in the message
    $escapedMessage = $message -replace "'", "''"
    $psd1Content += "$key = '$escapedMessage'`n"
}

$psd1Content += "'@`n"

# Save the file
$psd1Content | Out-File -FilePath $OutputPath -Encoding UTF8 -Force

Write-Host "Extracted $messageCount messages to $OutputPath" -ForegroundColor Green
Write-Host 'Next steps:' -ForegroundColor Cyan
Write-Host '1. Review and rename keys to be semantic (e.g., ScriptNotFound instead of Msg1)' -ForegroundColor White
Write-Host '2. Add Import-LocalizedData to your module' -ForegroundColor White
Write-Host '3. Replace hardcoded strings with localized versions' -ForegroundColor White
Write-Host '4. Create translations in other language folders' -ForegroundColor White
