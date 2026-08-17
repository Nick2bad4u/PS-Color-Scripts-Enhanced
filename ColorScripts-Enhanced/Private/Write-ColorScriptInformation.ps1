function Test-ColorScriptForcedAnsi {
    $forceAnsiValue = $env:COLOR_SCRIPTS_ENHANCED_FORCE_ANSI
    if ([string]::IsNullOrWhiteSpace($forceAnsiValue)) {
        return $false
    }

    return $forceAnsiValue -match '^(?i)(1|true|yes|force|ansi|color)$'
}

function ConvertTo-ColorScriptConsoleColor {
    param(
        [AllowNull()]
        [string]$Color
    )

    if ([string]::IsNullOrWhiteSpace($Color)) {
        return $null
    }

    try {
        return [System.ConsoleColor][System.Enum]::Parse([System.ConsoleColor], $Color, $true)
    }
    catch {
        return $null
    }
}

function Test-ColorScriptConsoleOutputAvailable {
    param(
        [switch]$PreferConsole,
        [switch]$ForceAnsi
    )

    if ($PreferConsole -or $ForceAnsi) {
        return $true
    }

    try {
        return -not (Test-ConsoleOutputRedirected)
    }
    catch {
        return $false
    }
}

function Test-ColorScriptVirtualTerminalAvailable {
    try {
        return Test-ConsoleSupportsVirtualTerminal
    }
    catch {
        return $false
    }
}

function Write-ColorScriptConsoleOutput {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Text,

        [AllowNull()]
        [object]$ConsoleColor,

        [switch]$NoAnsiOutput,
        [switch]$ApplyConsoleColor
    )

    $colorSet = $false
    $originalColor = $null

    try {
        if ($ApplyConsoleColor -and $null -ne $ConsoleColor) {
            $originalColor = [Console]::ForegroundColor
            [Console]::ForegroundColor = $ConsoleColor
            $colorSet = $true
        }

        Write-RenderedText -Text $Text -NoAnsiOutput:$NoAnsiOutput
        return $true
    }
    catch {
        return $false
    }
    finally {
        if ($colorSet -and $null -ne $originalColor) {
            [Console]::ForegroundColor = $originalColor
        }
    }
}

function Write-ColorScriptInformation {
    param(
        [AllowNull()][string]$Message,
        [switch]$Quiet,
        [switch]$NoAnsiOutput,
        [switch]$PreferConsole,
        [string]$Color
    )

    if ($Quiet) {
        return
    }

    $output = if ($null -ne $Message) { [string]$Message } else { '' }
    $sanitizedOutput = Remove-ColorScriptAnsiSequence -Text $output
    $consoleColor = ConvertTo-ColorScriptConsoleColor -Color $Color
    $wroteToConsole = $false

    if (-not $NoAnsiOutput.IsPresent) {
        $forceAnsi = Test-ColorScriptForcedAnsi
        $shouldUseConsole = Test-ColorScriptConsoleOutputAvailable -PreferConsole:$PreferConsole -ForceAnsi:$forceAnsi
        $supportsVirtualTerminal = Test-ColorScriptVirtualTerminalAvailable
        $shouldRenderWithAnsi = $shouldUseConsole -and ($forceAnsi -or $supportsVirtualTerminal)

        if ($shouldUseConsole) {
            $wroteToConsole = Write-ColorScriptConsoleOutput -Text $output -ConsoleColor $consoleColor -NoAnsiOutput:(-not $shouldRenderWithAnsi) -ApplyConsoleColor:(-not $shouldRenderWithAnsi)
        }

        if (-not $wroteToConsole -and $null -ne $consoleColor) {
            $wroteToConsole = Write-ColorScriptConsoleOutput -Text $output -ConsoleColor $consoleColor -NoAnsiOutput -ApplyConsoleColor
        }
    }

    $informationAction = if ($wroteToConsole) { 'SilentlyContinue' } else { 'Continue' }
    Write-Information -MessageData $sanitizedOutput -InformationAction $informationAction -Tags 'ColorScripts'
}

function Write-ColorScriptSelectionInfo {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Path,

        [switch]$Quiet,

        [switch]$NoAnsiOutput,

        [switch]$PreferConsole
    )

    if ($Quiet) {
        return
    }

    $nameSegment = New-ColorScriptAnsiText -Text ("[{0}]" -f $Name) -Color 'Cyan' -NoAnsiOutput:$NoAnsiOutput
    $pathSegment = New-ColorScriptAnsiText -Text $Path -Color 'DarkGray' -NoAnsiOutput:$NoAnsiOutput

    $writeParameters = @{
        Message       = "{0} {1}" -f $nameSegment, $pathSegment
        NoAnsiOutput  = $NoAnsiOutput
        PreferConsole = $PreferConsole
    }
    Write-ColorScriptInformation @writeParameters
}
