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
    - UTF-8 encoded files (e.g., Pokemon colorscripts)

.PARAMETER AnsiFile
    Path to the ANSI art file (.ans)

.PARAMETER OutputFile
    Optional path for the output PowerShell script
    If not specified, uses ColorScripts-Enhanced/Scripts/<name>.ps1

.PARAMETER Encoding
    Input file encoding. Use 'cp437' (default) for traditional ANSI art,
    or 'utf8' for Unicode files like Pokemon colorscripts.
    Valid values: cp437, utf8

.PARAMETER Passthrough
    Skip terminal emulation and wrap content directly. Use this for
    pre-formatted files that already have proper line breaks (like Pokemon colorscripts).

.EXAMPLE
    .\Convert-AnsiToColorScript-Advanced.ps1 -AnsiFile "artwork.ans"

.EXAMPLE
    .\Convert-AnsiToColorScript-Advanced.ps1 -AnsiFile "complex.ans" -OutputFile "custom.ps1"

.EXAMPLE
    .\Convert-AnsiToColorScript-Advanced.ps1 -AnsiFile "pikachu" -Encoding utf8 -Passthrough

.EXAMPLE
    Get-ChildItem .\assets\pokemon-colorscripts\* | .\Convert-AnsiToColorScript-Advanced.ps1 -Encoding utf8 -Passthrough
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias('FullName', 'Path')]
    [string]$AnsiFile,

    [Parameter(Mandatory = $false)]
    [string]$OutputFile,

    [Parameter(Mandatory = $false)]
    [ValidateSet('cp437', 'utf8')]
    [string]$Encoding = 'cp437',

    [Parameter(Mandatory = $false)]
    [switch]$Passthrough
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
    $args = @($converterScript, "--encoding=$Encoding")

    if ($Passthrough) {
        $args += '--passthrough'
    }

    $args += $ansiFileInfo.FullName

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
