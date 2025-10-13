#Requires -Version 5.1

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter()]
    [string]$Path = (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath 'ColorScripts-Enhanced\Scripts')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$resolvedPath = Resolve-Path -LiteralPath $Path -ErrorAction Stop
$files = Get-ChildItem -Path $resolvedPath -Filter '*.ps1' -File -Recurse | Sort-Object FullName

if (-not $files) {
    Write-Host "No PowerShell scripts found under $resolvedPath." -ForegroundColor Yellow
    return
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$formattedCount = 0
$skippedCount = 0

foreach ($file in $files) {
    $original = Get-Content -LiteralPath $file.FullName -Raw
    if ([string]::IsNullOrWhiteSpace($original)) {
        $skippedCount++
        continue
    }
    $formatted = Invoke-Formatter -ScriptDefinition $original

    if ($formatted -ne $original) {
        if ($PSCmdlet.ShouldProcess($file.FullName, 'Apply Invoke-Formatter output')) {
            [System.IO.File]::WriteAllText($file.FullName, $formatted, $utf8NoBom)
            $formattedCount++
        }
    }
    else {
        $skippedCount++
    }
}

Write-Host "Formatted $formattedCount file(s); $skippedCount already compliant." -ForegroundColor Green
