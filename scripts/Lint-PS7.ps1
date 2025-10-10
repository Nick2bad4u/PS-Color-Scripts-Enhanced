[CmdletBinding()]
param(
    [Parameter()]
    [string]$SettingsPath = './PSScriptAnalyzerSettings.psd1',

    [Parameter()]
    [string]$SourcePath = './ColorScripts-Enhanced'
)

if ($PSVersionTable.PSVersion.Major -lt 7) {
    throw "This helper requires PowerShell 7 or later."
}

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Verbose 'Installing PSScriptAnalyzer because it was not found.'
    Install-Module -Name PSScriptAnalyzer -Force -SkipPublisherCheck
}

Import-Module PSScriptAnalyzer

$files = Get-ChildItem -Path $SourcePath -File -Recurse -Include '*.ps1', '*.psm1', '*.psd1' |
    Where-Object { $_.FullName -notmatch '\\Scripts\\' }

Write-Host "Analyzing $($files.Count) file(s) with ScriptAnalyzer..." -ForegroundColor Cyan

$results = @()
foreach ($file in $files) {
    $analysis = Invoke-ScriptAnalyzer -Path $file.FullName -Settings $SettingsPath -Fix -Severity Error, Warning
    if ($analysis) {
        $results += $analysis
    }
}

if ($results) {
    $results | Format-Table -AutoSize
    throw "ScriptAnalyzer reported issues."
}
else {
    Write-Host 'No ScriptAnalyzer issues detected.' -ForegroundColor Green
}
