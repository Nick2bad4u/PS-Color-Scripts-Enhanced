#Requires -Version 7.0

<#
.SYNOPSIS
    Replaces deterministic bundled colorscripts with verified static ANSI output.

.DESCRIPTION
    Renders each selected script twice in an isolated temporary directory, rejects unstable or
    failing output, converts the stable ANSI payload to the repository's static Write-Host form,
    and verifies that the generated source reproduces the normalized payload before any tracked
    file is changed. Dynamic scripts listed in DynamicRenderPolicy.psd1 are never converted.

    Without -Apply, the command performs the complete audit and reports what it would change.

.PARAMETER Name
    Optional bundled colorscript names. When omitted, every currently non-static, non-dynamic
    bundled script is considered, except scripts reserved for manual repair.

.PARAMETER VerificationRuns
    Number of isolated renders used to prove stability. Must be at least two.

.PARAMETER BaselinePath
    Destination for normalized output hashes written when -Apply succeeds.

.PARAMETER Apply
    Writes the verified static sources and baseline manifest.

.EXAMPLE
    ./scripts/Convert-DeterministicColorScripts.ps1
    Audits all eligible bundled scripts without modifying the repository.

.EXAMPLE
    ./scripts/Convert-DeterministicColorScripts.ps1 -Name crabs, colortest -Apply
    Verifies and flattens the two named scripts.
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]$Name,

    [Parameter()]
    [ValidateRange(2, 10)]
    [int]$VerificationRuns = 2,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$BaselinePath,

    [Parameter()]
    [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function ConvertTo-NormalizedRenderText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Text
    )

    return $Text.Replace("`r`n", "`n").Replace("`r", "`n")
}

function Get-RenderHash {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Text
    )

    $encoding = [System.Text.UTF8Encoding]::new($false)
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    try {
        return [Convert]::ToHexString($sha256.ComputeHash($encoding.GetBytes($Text)))
    }
    finally {
        $sha256.Dispose()
    }
}

function ConvertTo-StaticColorScriptSource {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ScriptName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$NormalizedOutput
    )

    if (-not $NormalizedOutput.EndsWith("`n", [System.StringComparison]::Ordinal)) {
        throw "Colorscript '$ScriptName' does not end with a newline; automatic conversion would change its output contract."
    }

    $payload = $NormalizedOutput.Substring(0, $NormalizedOutput.Length - 1)
    $trailingSpaceToken = '__CSE_TRAILING_SPACE_' + [guid]::NewGuid().ToString('N') + '__'
    $payload = [regex]::Replace($payload, '(?m) +$', {
            param($match)
            return $trailingSpaceToken * $match.Length
        })
    $payload = $payload.Replace('`', '``')
    $payload = $payload.Replace('$', '`$')
    $payload = $payload.Replace('"', '`"')
    $payload = $payload.Replace([string][char]27, '$esc')
    $payload = $payload.Replace($trailingSpaceToken, '$sp')

    return @"
# Generated from verified deterministic output by scripts/Convert-DeterministicColorScripts.ps1.
`$esc = [char]27
`$sp = ' '

Write-Host @`"
$payload
`"@
"@
}

function ConvertTo-BaselineDataSource {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [object[]]$Records
    )

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('@{')
    $lines.Add('    SchemaVersion = 1')
    $lines.Add("    LineEndings = 'LF'")
    $lines.Add('    Scripts = @{')

    foreach ($record in @($Records | Sort-Object -Property Name)) {
        $escapedName = ([string]$record.Name).Replace("'", "''")
        $lines.Add("        '$escapedName' = @{")
        $lines.Add("            Sha256 = '$($record.Sha256)'")
        $lines.Add("            Utf8Bytes = $($record.Utf8Bytes)")
        $lines.Add('        }')
    }

    $lines.Add('    }')
    $lines.Add('}')
    return ($lines -join "`n") + "`n"
}

$repoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
$moduleRoot = Join-Path -Path $repoRoot -ChildPath 'ColorScripts-Enhanced'
$scriptsRoot = Join-Path -Path $moduleRoot -ChildPath 'Scripts'
$moduleManifest = Join-Path -Path $moduleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
$dynamicPolicyPath = Join-Path -Path $moduleRoot -ChildPath 'DynamicRenderPolicy.psd1'

if (-not $BaselinePath) {
    $BaselinePath = Join-Path -Path $repoRoot -ChildPath 'Tests/Fixtures/FlattenedColorScriptBaselines.psd1'
}
elseif (-not [System.IO.Path]::IsPathRooted($BaselinePath)) {
    $BaselinePath = Join-Path -Path $repoRoot -ChildPath $BaselinePath
}

$dynamicPolicy = Import-PowerShellDataFile -Path $dynamicPolicyPath
$dynamicNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($dynamicName in @($dynamicPolicy.DynamicScripts)) {
    $null = $dynamicNames.Add([string]$dynamicName)
}

$manualNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($manualName in @(
        'kevin-woods',
        'pukeskull-rainbow',
        'syl-k7',
        'syl-mega',
        'syl-noel',
        'syl-nyan',
        'syl-sntx',
        'syl-strt',
        'syl-trck',
        'syl-undd'
    )) {
    $null = $manualNames.Add($manualName)
}

$previousSkipCacheBuild = $env:COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD
$env:COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD = '1'
try {
    Import-Module -Name $moduleManifest -Force
    $module = Get-Module -Name ColorScripts-Enhanced -ErrorAction Stop

    $candidateFiles = if ($Name) {
        foreach ($scriptName in $Name) {
            if ($dynamicNames.Contains($scriptName)) {
                throw "Colorscript '$scriptName' is explicitly dynamic and cannot be flattened automatically."
            }
            if ($manualNames.Contains($scriptName)) {
                throw "Colorscript '$scriptName' is reserved for manual repair and cannot be flattened automatically."
            }

            $candidatePath = Join-Path -Path $scriptsRoot -ChildPath ($scriptName + '.ps1')
            Get-Item -LiteralPath $candidatePath -ErrorAction Stop
        }
    }
    else {
        foreach ($candidate in Get-ChildItem -LiteralPath $scriptsRoot -Filter '*.ps1' -File) {
            if ($dynamicNames.Contains($candidate.BaseName) -or $manualNames.Contains($candidate.BaseName)) {
                continue
            }

            $staticResult = & $module {
                param($path)
                Get-StaticColorScriptOutput -ScriptPath $path
            } $candidate.FullName
            if (-not $staticResult.Available) {
                $candidate
            }
        }
    }

    $candidateFiles = @($candidateFiles | Sort-Object -Property Name -Unique)
    if ($candidateFiles.Count -eq 0) {
        Write-Host 'No eligible non-static colorscripts were found.'
        return
    }

    $tempBase = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
    $tempRoot = Join-Path -Path $tempBase -ChildPath ('ColorScripts-Enhanced-StaticConversion-' + [guid]::NewGuid().ToString('N'))
    $null = New-Item -Path $tempRoot -ItemType Directory -ErrorAction Stop

    try {
        $records = [System.Collections.Generic.List[object]]::new()
        foreach ($candidateFile in $candidateFiles) {
            $isolatedPath = Join-Path -Path $tempRoot -ChildPath $candidateFile.Name
            Copy-Item -LiteralPath $candidateFile.FullName -Destination $isolatedPath -ErrorAction Stop

            $renders = [System.Collections.Generic.List[string]]::new()
            for ($run = 1; $run -le $VerificationRuns; $run++) {
                $execution = & $module {
                    param($path)
                    Invoke-ColorScriptProcess -ScriptPath $path -ForCache
                } $isolatedPath

                if (-not $execution.Success -or -not [string]::IsNullOrEmpty($execution.StdErr)) {
                    throw "Colorscript '$($candidateFile.BaseName)' failed isolated render $run`: $($execution.StdErr)"
                }

                $renders.Add((ConvertTo-NormalizedRenderText -Text $execution.StdOut))
            }

            $baseline = $renders[0]
            for ($run = 1; $run -lt $renders.Count; $run++) {
                if ($renders[$run] -cne $baseline) {
                    throw "Colorscript '$($candidateFile.BaseName)' produced different output on isolated render $($run + 1)."
                }
            }
            if ([string]::IsNullOrEmpty($baseline)) {
                throw "Colorscript '$($candidateFile.BaseName)' produced no output."
            }

            $generatedSource = ConvertTo-StaticColorScriptSource -ScriptName $candidateFile.BaseName -NormalizedOutput $baseline
            [System.IO.File]::WriteAllText($isolatedPath, $generatedSource, [System.Text.UTF8Encoding]::new($false))
            $generatedResult = & $module {
                param($path)
                Get-StaticColorScriptOutput -ScriptPath $path
            } $isolatedPath
            $normalizedGeneratedOutput = ConvertTo-NormalizedRenderText -Text $generatedResult.Content
            if (-not $generatedResult.Available -or $normalizedGeneratedOutput -cne $baseline) {
                throw "Generated static source for '$($candidateFile.BaseName)' did not reproduce its verified output."
            }

            $encoding = [System.Text.UTF8Encoding]::new($false)
            $records.Add([pscustomobject]@{
                    Name            = $candidateFile.BaseName
                    Path            = $candidateFile.FullName
                    Source          = $generatedSource
                    Sha256          = Get-RenderHash -Text $baseline
                    Utf8Bytes       = $encoding.GetByteCount($baseline)
                    OriginalBytes   = $candidateFile.Length
                    GeneratedBytes  = $encoding.GetByteCount($generatedSource)
                })
        }

        if ($Apply) {
            $baselineRecordsByName = @{}
            if (Test-Path -LiteralPath $BaselinePath -PathType Leaf) {
                $existingBaseline = Import-PowerShellDataFile -Path $BaselinePath
                if ($existingBaseline.SchemaVersion -ne 1 -or
                    $existingBaseline.LineEndings -cne 'LF' -or
                    $existingBaseline.Scripts -isnot [hashtable]) {
                    throw "Baseline manifest '$BaselinePath' has an unsupported format."
                }

                foreach ($entry in $existingBaseline.Scripts.GetEnumerator()) {
                    $baselineRecordsByName[[string]$entry.Key] = [pscustomobject]@{
                        Name      = [string]$entry.Key
                        Sha256    = [string]$entry.Value.Sha256
                        Utf8Bytes = [long]$entry.Value.Utf8Bytes
                    }
                }
            }

            $appliedRecords = [System.Collections.Generic.List[object]]::new()
            foreach ($record in $records) {
                if ($PSCmdlet.ShouldProcess($record.Path, 'Replace deterministic renderer with verified static output')) {
                    [System.IO.File]::WriteAllText($record.Path, $record.Source, [System.Text.UTF8Encoding]::new($false))
                    $appliedRecords.Add($record)
                }
            }

            if ($appliedRecords.Count -gt 0) {
                foreach ($record in $appliedRecords) {
                    $baselineRecordsByName[[string]$record.Name] = $record
                }

                $baselineSource = ConvertTo-BaselineDataSource -Records @($baselineRecordsByName.Values)
                if ($PSCmdlet.ShouldProcess($BaselinePath, 'Write deterministic render baseline hashes')) {
                    $baselineDirectory = Split-Path -Path $BaselinePath -Parent
                    if (-not (Test-Path -LiteralPath $baselineDirectory -PathType Container)) {
                        $null = New-Item -Path $baselineDirectory -ItemType Directory -Force
                    }
                    [System.IO.File]::WriteAllText($BaselinePath, $baselineSource, [System.Text.UTF8Encoding]::new($false))
                }
            }
        }

        $records |
            Select-Object Name, OriginalBytes, GeneratedBytes, Sha256, Utf8Bytes
    }
    finally {
        $resolvedTempRoot = [System.IO.Path]::GetFullPath($tempRoot)
        $expectedPrefix = $tempBase.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
        $safeLeaf = [System.IO.Path]::GetFileName($resolvedTempRoot).StartsWith(
            'ColorScripts-Enhanced-StaticConversion-',
            [System.StringComparison]::Ordinal)
        $safeParent = $resolvedTempRoot.StartsWith($expectedPrefix, [System.StringComparison]::OrdinalIgnoreCase)
        if (-not $safeLeaf -or -not $safeParent) {
            throw "Refusing to remove unexpected temporary directory '$resolvedTempRoot'."
        }
        if (Test-Path -LiteralPath $resolvedTempRoot) {
            Remove-Item -LiteralPath $resolvedTempRoot -Recurse -Force
        }
    }
}
finally {
    if ($null -eq $previousSkipCacheBuild) {
        Remove-Item Env:COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD -ErrorAction SilentlyContinue
    }
    else {
        $env:COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD = $previousSkipCacheBuild
    }
    Remove-Module -Name ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
}
