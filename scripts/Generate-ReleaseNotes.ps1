<#
.SYNOPSIS
    Generate release notes using git-cliff.

.DESCRIPTION
    Invokes the git-cliff CLI with the repository cliff.toml configuration to produce markdown
    release notes. By default the script generates notes for unreleased commits so they can be
    pasted directly into the PowerShell Gallery publish form. Notes can also be generated for
    the latest released tag by specifying -Latest.

.PARAMETER Unreleased
    Generate notes for unreleased commits (default behaviour).

.PARAMETER Latest
    Generate notes for the most recent tagged release.

.PARAMETER OutputPath
    Optional path to write the generated notes. When not supplied the notes are emitted to the pipeline.

.PARAMETER StripHeader
    Remove the top-level heading from the generated notes. Useful for gallery snippets.

.PARAMETER PassThru
    Return the generated notes even when writing to disk.

.EXAMPLE
    pwsh -NoProfile -File ./scripts/Generate-ReleaseNotes.ps1 -Unreleased -OutputPath ./dist/PowerShellGalleryReleaseNotes.md

.EXAMPLE
    pwsh -NoProfile -File ./scripts/Generate-ReleaseNotes.ps1 -Latest -PassThru
#>
[CmdletBinding(DefaultParameterSetName = 'Unreleased')]
param(
    [Parameter(ParameterSetName = 'Unreleased')]
    [switch]$Unreleased,

    [Parameter(ParameterSetName = 'Latest')]
    [switch]$Latest,

    [Parameter()]
    [string]$OutputPath,

    [Parameter()]
    [switch]$StripHeader,

    [Parameter()]
    [switch]$PassThru
)

if (-not $Unreleased -and -not $Latest) {
    $Unreleased = $true
}

function Resolve-ReleasePath {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    $expanded = [System.Environment]::ExpandEnvironmentVariables($Path)
    if ($expanded.StartsWith('~')) {
        $userHome = [System.Environment]::GetFolderPath('UserProfile')
        if (-not $userHome) {
            $userHome = $HOME
        }

        if ($expanded.Length -eq 1) {
            $expanded = $userHome
        }
        elseif ($expanded.Length -gt 1 -and ($expanded[1] -eq '/' -or $expanded[1] -eq '\')) {
            $expanded = Join-Path -Path $userHome -ChildPath $expanded.Substring(2)
        }
    }

    if (-not [System.IO.Path]::IsPathRooted($expanded)) {
        $expanded = Join-Path -Path (Get-Location).ProviderPath -ChildPath $expanded
    }

    return [System.IO.Path]::GetFullPath($expanded)
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path -LiteralPath (Join-Path -Path $scriptRoot -ChildPath '..')
$cliffConfig = Join-Path -Path $repoRoot -ChildPath 'cliff.toml'

# Try to find git-cliff executable
$gitCliffExe = $null
$candidateBins = @()
$gitCliffCmd = Get-Command git-cliff -ErrorAction SilentlyContinue

if (-not $gitCliffCmd) {
    # Augment PATH with common npm global locations when running in NoProfile contexts (e.g., npm scripts)
    if ($env:APPDATA) { $candidateBins += (Join-Path $env:APPDATA 'npm') }
    if ($env:LOCALAPPDATA) { $candidateBins += (Join-Path $env:LOCALAPPDATA 'npm') }
    if ($env:ProgramFiles) { $candidateBins += (Join-Path $env:ProgramFiles 'nodejs') }

    foreach ($bin in $candidateBins | Where-Object { $_ -and (Test-Path $_) }) {
        if (-not ($env:PATH -split ';' | Where-Object { $_ -ieq $bin })) {
            $env:PATH = "$bin;$($env:PATH)"
        }
    }

    $gitCliffCmd = Get-Command git-cliff -ErrorAction SilentlyContinue
}

if ($gitCliffCmd) {
    if ($gitCliffCmd.Source -match '\.exe$') {
        # Direct executable
        $gitCliffExe = $gitCliffCmd.Source
    }
    elseif ($gitCliffCmd.Source -match '\.ps1$' -or $gitCliffCmd.Source -match '\.cmd$') {
        # npm wrapper - look for actual exe
        $npmBinPath = Split-Path $gitCliffCmd.Source -Parent
        $possibleExe = Join-Path $npmBinPath 'git-cliff.exe'

        if (Test-Path $possibleExe) {
            $gitCliffExe = $possibleExe
        }
        else {
            # Try node_modules path
            $nodeModulesRoot = Join-Path $npmBinPath 'node_modules'
            $nodeModulesPath = Join-Path $nodeModulesRoot 'git-cliff-windows-x64\bin\git-cliff.exe'
            if (Test-Path $nodeModulesPath) {
                $gitCliffExe = $nodeModulesPath
            }
            else {
                # npm global layout with nested git-cliff\node_modules\git-cliff-windows-x64
                $nestedPath = Join-Path $nodeModulesRoot 'git-cliff\node_modules\git-cliff-windows-x64\bin\git-cliff.exe'
                if (Test-Path $nestedPath) {
                    $gitCliffExe = $nestedPath
                }
                elseif (-not $gitCliffExe) {
                    # Last-resort: search a few levels under the npm bin directory for git-cliff.exe
                    $found = Get-ChildItem -Path $npmBinPath -Recurse -Filter 'git-cliff.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
                    if ($found) {
                        $gitCliffExe = $found.FullName
                    }
                }
            }
        }
    }
}

# Fallback: search common locations for git-cliff shims if still unresolved
if (-not $gitCliffExe -or -not (Test-Path $gitCliffExe)) {
    $searchFiles = @('git-cliff.exe', 'git-cliff.cmd', 'git-cliff.ps1')
    $searchDirs = @($npmBinPath, $nodeModulesRoot)
    $searchDirs += $candidateBins
    $searchDirs += ($env:PATH -split ';' | Where-Object { $_ })
    $searchDirs = $searchDirs | Where-Object { $_ } | Select-Object -Unique

    foreach ($dir in $searchDirs) {
        foreach ($file in $searchFiles) {
            $candidate = Join-Path $dir $file
            if (Test-Path -LiteralPath $candidate) {
                $gitCliffExe = $candidate
                break
            }
        }
        if ($gitCliffExe) { break }
    }
}

if (-not $gitCliffExe -or -not (Test-Path $gitCliffExe)) {
    throw "git-cliff CLI is required. Install via 'npm install -g git-cliff', 'cargo install git-cliff', or download from https://github.com/orhun/git-cliff/releases."
}

if (-not (Test-Path -LiteralPath $cliffConfig)) {
    throw "Unable to locate cliff configuration at '$cliffConfig'."
}

$arguments = @()
$arguments += '--config'
$arguments += $cliffConfig

if ($Unreleased) {
    $arguments += '--unreleased'
}
else {
    $arguments += '--latest'
}

if ($StripHeader) {
    $arguments += '--strip'
    $arguments += 'header'
}

Write-Verbose ('Running git-cliff with arguments: {0}' -f ($arguments -join ' '))

    $gitCliffCommand = $gitCliffExe
$gitCliffBootstrapArgs = @()
if ($gitCliffExe -like '*.ps1') {
    $pwshCmd = (Get-Command pwsh -ErrorAction SilentlyContinue)
    if ($pwshCmd -and (Test-Path -LiteralPath $pwshCmd.Source)) {
        $gitCliffCommand = $pwshCmd.Source
    }
    else {
        $gitCliffCommand = 'pwsh'
    }
        $gitCliffBootstrapArgs = @('-NoProfile', '-File', $gitCliffExe)
}

# Use Start-Process with proper argument handling for paths with spaces
try {
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
        $processInfo.FileName = $gitCliffCommand
    $processInfo.RedirectStandardOutput = $true
    $processInfo.RedirectStandardError = $true
        $processInfo.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
        $processInfo.StandardErrorEncoding = [System.Text.UTF8Encoding]::new($false)
    $processInfo.UseShellExecute = $false
    $processInfo.CreateNoWindow = $true

    # Add arguments one by one to avoid quoting issues
        foreach ($arg in @($gitCliffBootstrapArgs + $arguments)) {
        $processInfo.ArgumentList.Add($arg)
    }

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo
    $process.Start() | Out-Null

    $notesOutput = $process.StandardOutput.ReadToEnd()
    $errorOutput = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    $exitCode = $process.ExitCode

    if ($exitCode -ne 0) {
        $combined = $notesOutput + "`n" + $errorOutput
        throw "git-cliff exited with code $exitCode.`n$combined"
    }
}
catch {
    throw "Failed to execute git-cliff: $_"
}

$notes = $notesOutput.Trim()

if (-not $notes) {
    throw 'git-cliff returned no release notes.'
}

if ($OutputPath) {
    $resolvedOutput = Resolve-ReleasePath -Path $OutputPath
    if (-not $resolvedOutput) {
        throw "Unable to resolve output path '$OutputPath'."
    }

    $outputDirectory = Split-Path -Path $resolvedOutput -Parent
    if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }

    Set-Content -Path $resolvedOutput -Value ($notes + [Environment]::NewLine) -Encoding UTF8
    Write-Verbose "Release notes written to $resolvedOutput"

    if ($PassThru) {
        return $notes
    }

    return
}

return $notes
