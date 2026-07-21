<#
.SYNOPSIS
    Convert ANSI art files to safe PowerShell colorscripts.

.DESCRIPTION
    Provides a PowerShell pipeline wrapper around the repository's shared Node.js
    ANSI terminal emulator. Generated scripts treat artwork strictly as data,
    retain source/SAUCE provenance in comments, and are encoded for Windows
    PowerShell 5.1 compatibility.

.PARAMETER AnsiFile
    Literal path to an ANSI art file.

.PARAMETER OutputFile
    Optional output filename or absolute output path. Omit this parameter for
    pipeline input so each source receives its own derived output name.

.PARAMETER OutputDirectory
    Directory for derived output names. Defaults to ColorScripts-Enhanced/Scripts.

.PARAMETER AddComment
    Retained for compatibility. Provenance comments are always included.

.PARAMETER StripSpaceBackground
    Remove background colors from plain spaces during terminal emulation.

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
    [string]$OutputDirectory,

    [Parameter()]
    [switch]$AddComment,

    [Parameter()]
    [switch]$StripSpaceBackground,

    [Parameter()]
    [switch]$Force
)

begin {
    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'
    $processedItemCount = 0
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent
    if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
        $OutputDirectory = Join-Path -Path $repoRoot -ChildPath 'ColorScripts-Enhanced/Scripts'
    }

    $converterPath = Join-Path -Path $PSScriptRoot -ChildPath 'Convert-AnsiToColorScript.js'
    if (-not (Test-Path -LiteralPath $converterPath -PathType Leaf)) {
        throw "Converter script not found: $converterPath"
    }
    $nodeCommand = Get-Command -Name node -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if (-not $nodeCommand) {
        throw 'Node.js is required. Install a supported release from https://nodejs.org/.'
    }
    if ($AddComment) {
        Write-Verbose 'AddComment is retained for compatibility; generated scripts always include provenance comments.'
    }

    function Invoke-AnsiConversion {
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

        $currentOutputFile = $RequestedOutputFile
        if ([string]::IsNullOrWhiteSpace($currentOutputFile)) {
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($inputInfo.Name).ToLowerInvariant()
            $baseName = $baseName -replace '[^a-z0-9]', '-' -replace '-+', '-' -replace '^-|-$', ''
            if ([string]::IsNullOrWhiteSpace($baseName)) {
                throw "Input file '$($inputInfo.Name)' does not produce a safe colorscript name."
            }
            $currentOutputFile = $baseName + '.ps1'
        }

        $outputPath = if ([System.IO.Path]::IsPathRooted($currentOutputFile)) {
            [System.IO.Path]::GetFullPath($currentOutputFile)
        }
        else {
            [System.IO.Path]::GetFullPath((Join-Path -Path $OutputDirectory -ChildPath $currentOutputFile))
        }

        if ((Test-Path -LiteralPath $outputPath -PathType Leaf) -and -not $Force) {
            throw "Output file already exists: $outputPath. Use -Force to replace it."
        }
        if (-not $PSCmdlet.ShouldProcess($outputPath, "Convert '$($inputInfo.Name)' to a colorscript")) {
            return
        }

        $nodeArguments = @($converterPath, '--encoding=cp437')
        if ($StripSpaceBackground) {
            $nodeArguments += '--strip-space-bg'
        }
        if ($Force) {
            $nodeArguments += '--force'
        }
        $nodeArguments += @($inputInfo.FullName, $outputPath)

        $converterOutput = @(& $nodeCommand.Source @nodeArguments 2>&1)
        if ($LASTEXITCODE -ne 0) {
            throw "ANSI conversion failed for '$($inputInfo.FullName)': $($converterOutput -join [Environment]::NewLine)"
        }
        foreach ($line in $converterOutput) {
            Write-Verbose ([string]$line)
        }

        $outputInfo = Get-Item -LiteralPath $outputPath -ErrorAction Stop
        [pscustomobject]@{
            SourceFile = $inputInfo.FullName
            OutputFile = $outputInfo.FullName
            Size       = $outputInfo.Length
        }
    }
}

process {
    $processedItemCount++
    if ($processedItemCount -gt 1 -and $PSBoundParameters.ContainsKey('OutputFile')) {
        throw 'OutputFile cannot be reused for multiple pipeline inputs. Omit it to derive one output name per input.'
    }
    Invoke-AnsiConversion -InputPath $AnsiFile -RequestedOutputFile $OutputFile
}

end {
    # Windows PowerShell 5.1 does not invoke a script-level process block for a
    # direct -File invocation, even when the parameter was supplied explicitly.
    if ($processedItemCount -eq 0) {
        Invoke-AnsiConversion -InputPath $AnsiFile -RequestedOutputFile $OutputFile
    }
}
