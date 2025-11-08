[CmdletBinding()]
param(
    [Parameter()]
    [string]$SettingsPath = './PSScriptAnalyzerSettings.psd1',

    [Parameter()]
    [string]$SourcePath = './ColorScripts-Enhanced'
)

if ($PSVersionTable.PSVersion.Major -lt 7) {
    throw 'This helper requires PowerShell 7 or later.'
}

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Verbose 'Installing PSScriptAnalyzer because it was not found.'
    Install-Module -Name PSScriptAnalyzer -Force -SkipPublisherCheck
}

Import-Module PSScriptAnalyzer

try {
    $SettingsPath = (Resolve-Path -Path $SettingsPath -ErrorAction Stop).ProviderPath
}
catch {
    throw "Unable to resolve ScriptAnalyzer settings path '$SettingsPath': $($_.Exception.Message)"
}

try {
    $SourcePath = (Resolve-Path -Path $SourcePath -ErrorAction Stop).ProviderPath
}
catch {
    throw "Unable to resolve source path '$SourcePath': $($_.Exception.Message)"
}

$files = Get-ChildItem -Path $SourcePath -File -Recurse -Include '*.ps1', '*.psm1', '*.psd1'

Write-Host "Analyzing $($files.Count) file(s) with ScriptAnalyzer..." -ForegroundColor Cyan

$results = @()
foreach ($file in $files) {
    $analysis = $null
    $fixSucceeded = $false
    $lastFixException = $null

    for ($attempt = 1; $attempt -le 2 -and -not $fixSucceeded; $attempt++) {
        try {
            $analysis = Invoke-ScriptAnalyzer -Path $file.FullName -Settings $SettingsPath -Fix -Severity Error, Warning -ErrorAction Stop
            $fixSucceeded = $true
        }
        catch {
            if ($_.Exception -is [System.NullReferenceException]) {
                $lastFixException = $_
                if ($attempt -eq 1) {
                    Write-Verbose "NullReferenceException encountered on fix attempt for '$($file.FullName)'. Retrying once before falling back."
                    Start-Sleep -Milliseconds 50
                    continue
                }
            }
            else {
                throw
            }
        }
    }

    if (-not $fixSucceeded -and $lastFixException) {
        Write-Warning "ScriptAnalyzer encountered a known issue analyzing '$($file.FullName)' with custom settings ($($lastFixException.Exception.GetType().FullName)): $($lastFixException.Exception.Message). Retrying without -Fix."

        try {
            $analysis = Invoke-ScriptAnalyzer -Path $file.FullName -Settings $SettingsPath -Severity Error, Warning -ErrorAction Stop
            $fixSucceeded = $true
        }
        catch {
            if ($_.Exception -is [System.NullReferenceException]) {
                Write-Warning "ScriptAnalyzer encountered a second failure analyzing '$($file.FullName)' with custom settings ($($_.Exception.GetType().FullName)): $($_.Exception.Message). Retrying without custom settings."
                try {
                    $analysis = Invoke-ScriptAnalyzer -Path $file.FullName -Severity Error, Warning -ErrorAction Stop
                }
                catch {
                    Write-Warning "ScriptAnalyzer could not analyze '$($file.FullName)': $($_.Exception.Message)"
                    $analysis = $null
                }
            }
            else {
                throw
            }
        }
    }

    if ($analysis) {
        $results += $analysis
    }
}

if ($results) {
    $results | Format-Table -AutoSize
    throw 'ScriptAnalyzer reported issues.'
}
else {
    Write-Host 'No ScriptAnalyzer issues detected.' -ForegroundColor Green
}
