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

$gitCliff = Get-Command git-cliff -ErrorAction SilentlyContinue
if (-not $gitCliff) {
    throw "git-cliff CLI is required. Install via 'cargo install git-cliff' or download from https://github.com/orhun/git-cliff/releases."
}

if (-not (Test-Path -LiteralPath $cliffConfig)) {
    throw "Unable to locate cliff configuration at '$cliffConfig'."
}

$arguments = @('--config', $cliffConfig)
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

Write-Verbose ("Running git-cliff {0}" -f ($arguments -join ' '))
$notesOutput = & $gitCliff.Source $arguments
$exitCode = $LASTEXITCODE
if ($exitCode -ne 0) {
    $combined = ($notesOutput | Out-String)
    throw "git-cliff exited with code $exitCode.`n$combined"
}

$notes = ($notesOutput | Where-Object { $_ -ne $null }) -join [Environment]::NewLine
$notes = $notes.TrimEnd()

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
