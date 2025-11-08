<#
.SYNOPSIS
    Advanced ANSI to PowerShell ColorScript Converter (Node.js-based)

.DESCRIPTION
    Uses a proper ANSI parser via Node.js to handle complex ANSI art files
    with advanced cursor positioning and escape sequences.

    This converter handles:
    - Cursor positioning (ESC[row;colH, ESC[row;colf)
    - Cursor movement (ESC[nA, ESC[nB, ESC[nC, ESC[nD)
    - Complex color and style codes
    - CP437 extended ASCII characters

.PARAMETER AnsiFile
    Path to the ANSI art file (.ans)

.PARAMETER OutputFile
    Optional path for the output PowerShell script
    If not specified, uses ColorScripts-Enhanced/Scripts/<name>.ps1

.EXAMPLE
    .\Convert-AnsiToColorScript-Advanced.ps1 -AnsiFile "artwork.ans"

.EXAMPLE
    .\Convert-AnsiToColorScript-Advanced.ps1 -AnsiFile "complex.ans" -OutputFile "custom.ps1"

.EXAMPLE
    Get-Item *.ans | .\Convert-AnsiToColorScript-Advanced.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias('FullName', 'Path')]
    [string]$AnsiFile,

    [Parameter(Mandatory = $false)]
    [string]$OutputFile
)

begin {
    # Check if Node.js is installed
    try {
        $nodeVersion = node --version 2>$null
        if (-not $nodeVersion) {
            throw 'Node.js is not installed or not in PATH'
        }
        Write-Verbose "Using Node.js version: $nodeVersion"
    }
    catch {
        Write-Error 'Node.js is required for this converter. Please install Node.js from https://nodejs.org/'
        return
    }

    # Get the converter script path
    $converterScript = Join-Path $PSScriptRoot 'Convert-AnsiToColorScript.js'

    if (-not (Test-Path $converterScript)) {
        Write-Error "Converter script not found: $converterScript"
        return
    }
}

process {
    # Resolve to full path
    $AnsiFile = Resolve-Path $AnsiFile -ErrorAction Stop

    # Validate input file
    if (-not (Test-Path $AnsiFile)) {
        Write-Error "ANSI file not found: $AnsiFile"
        return
    }

    $ansiFileInfo = Get-Item $AnsiFile

    # Build command arguments
    $args = @($converterScript, $ansiFileInfo.FullName)

    if ($OutputFile) {
        $args += $OutputFile
    }

    # Run the Node.js converter
    Write-Verbose 'Running Node.js converter...'
    & node @args
}

end {
    # Nothing to do
}
