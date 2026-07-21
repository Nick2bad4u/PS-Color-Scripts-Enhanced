<#
.SYNOPSIS
    Convert ANSI art through the shared Node.js terminal emulator.

.DESCRIPTION
    Exposes input-encoding and passthrough controls while retaining literal-path,
    overwrite, ShouldProcess, pipeline, and Windows PowerShell 5.1 safeguards.

.PARAMETER AnsiFile
    Literal path to the ANSI art input.

.PARAMETER OutputFile
    Optional output path. Omit for pipeline input to derive one name per source.

.PARAMETER Encoding
    Source encoding: cp437 or utf8.

.PARAMETER Passthrough
    Preserve already-formatted line layout without terminal emulation.

.PARAMETER Force
    Replace an existing output file.
#>

#Requires -Version 5.1

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('FullName', 'Path')]
    [string]$AnsiFile,

    [Parameter()]
    [string]$OutputFile,

    [Parameter()]
    [ValidateSet('cp437', 'utf8')]
    [string]$Encoding = 'cp437',

    [Parameter()]
    [switch]$Passthrough,

    [Parameter()]
    [switch]$Force
)

begin {
    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'
    $processedItemCount = 0
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent
    $defaultOutputDirectory = Join-Path -Path $repoRoot -ChildPath 'ColorScripts-Enhanced/Scripts'
    $converterPath = Join-Path -Path $PSScriptRoot -ChildPath 'Convert-AnsiToColorScript.js'
    if (-not (Test-Path -LiteralPath $converterPath -PathType Leaf)) {
        throw "Converter script not found: $converterPath"
    }
    $nodeCommand = Get-Command -Name node -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if (-not $nodeCommand) {
        throw 'Node.js is required. Install a supported release from https://nodejs.org/.'
    }

    function Invoke-AdvancedAnsiConversion {
        [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
        param(
            [Parameter(Mandatory)]
            [string]$InputPath,

            [Parameter()]
            [string]$RequestedOutputFile
        )

        $resolvedInput = (Resolve-Path -LiteralPath $InputPath -ErrorAction Stop).ProviderPath
        $inputInfo = Get-Item -LiteralPath $resolvedInput -ErrorAction Stop
        if ($inputInfo.PSIsContainer) {
            throw "ANSI input must be a file: $resolvedInput"
        }

        $targetOutput = if ($RequestedOutputFile) {
            if ([System.IO.Path]::IsPathRooted($RequestedOutputFile)) {
                [System.IO.Path]::GetFullPath($RequestedOutputFile)
            }
            else {
                $currentDirectory = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('.')
                [System.IO.Path]::GetFullPath((Join-Path -Path $currentDirectory -ChildPath $RequestedOutputFile))
            }
        }
        else {
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($inputInfo.Name).ToLowerInvariant()
            $baseName = $baseName -replace '[^a-z0-9]', '-' -replace '-+', '-' -replace '^-|-$', ''
            if ([string]::IsNullOrWhiteSpace($baseName)) {
                throw "Input file '$($inputInfo.Name)' does not produce a safe colorscript name."
            }
            Join-Path -Path $defaultOutputDirectory -ChildPath ($baseName + '.ps1')
        }

        if ((Test-Path -LiteralPath $targetOutput -PathType Leaf) -and -not $Force) {
            throw "Output file already exists: $targetOutput. Use -Force to replace it."
        }
        if (-not $PSCmdlet.ShouldProcess($targetOutput, "Convert '$($inputInfo.Name)' to a colorscript")) {
            return
        }

        $nodeArguments = @($converterPath, "--encoding=$Encoding")
        if ($Passthrough) {
            $nodeArguments += '--passthrough'
        }
        if ($Force) {
            $nodeArguments += '--force'
        }
        $nodeArguments += @($inputInfo.FullName, $targetOutput)

        $converterOutput = @(& $nodeCommand.Source @nodeArguments 2>&1)
        if ($LASTEXITCODE -ne 0) {
            throw "ANSI conversion failed for '$($inputInfo.FullName)': $($converterOutput -join [Environment]::NewLine)"
        }
        foreach ($line in $converterOutput) {
            Write-Verbose ([string]$line)
        }

        Get-Item -LiteralPath $targetOutput -ErrorAction Stop
    }
}

process {
    $processedItemCount++
    if ($processedItemCount -gt 1 -and $PSBoundParameters.ContainsKey('OutputFile')) {
        throw 'OutputFile cannot be reused for multiple pipeline inputs. Omit it to derive one output name per input.'
    }
    Invoke-AdvancedAnsiConversion -InputPath $AnsiFile -RequestedOutputFile $OutputFile
}

end {
    if ($processedItemCount -eq 0) {
        Invoke-AdvancedAnsiConversion -InputPath $AnsiFile -RequestedOutputFile $OutputFile
    }
}
