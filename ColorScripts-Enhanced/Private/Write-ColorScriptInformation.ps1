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

    $preferConsoleOutput = $PreferConsole.IsPresent
    $forceAnsiEnv = $env:COLOR_SCRIPTS_ENHANCED_FORCE_ANSI
    $forceAnsi = $false
    if (-not [string]::IsNullOrWhiteSpace($forceAnsiEnv)) {
        if ($forceAnsiEnv -match '^(?i)(1|true|yes|force|ansi|color)$') {
            $forceAnsi = $true
        }
    }

    $sanitizedOutput = Remove-ColorScriptAnsiSequence -Text $output
    if ($NoAnsiOutput.IsPresent) {
        $sanitizedOutput = $output
    }

    $wroteToConsole = $false

    if (-not $NoAnsiOutput.IsPresent) {
        $shouldUseConsole = $preferConsoleOutput -or $forceAnsi

        if (-not $shouldUseConsole) {
            try {
                $shouldUseConsole = -not (Test-ConsoleOutputRedirected)
            }
            catch {
                $shouldUseConsole = $false
            }
        }

        $supportsVirtualTerminal = $true
        try {
            $supportsVirtualTerminal = Test-ConsoleSupportsVirtualTerminal
        }
        catch {
            $supportsVirtualTerminal = $false
        }

        $shouldRenderWithAnsi = $shouldUseConsole -and ($forceAnsi -or $supportsVirtualTerminal)

        if ($shouldUseConsole) {
            $colorSet = $false
            $originalColor = $null

            try {
                if (-not $shouldRenderWithAnsi -and -not [string]::IsNullOrWhiteSpace($Color)) {
                    $consoleColor = $null
                    if ([System.Enum]::TryParse([System.ConsoleColor], $Color, $true, [ref]$consoleColor)) {
                        $originalColor = [Console]::ForegroundColor
                        [Console]::ForegroundColor = $consoleColor
                        $colorSet = $true
                    }
                }

                Write-RenderedText -Text $output -NoAnsiOutput:(!$shouldRenderWithAnsi)
                $wroteToConsole = $true
            }
            catch {
                $wroteToConsole = $false
            }
            finally {
                if ($colorSet -and $null -ne $originalColor) {
                    [Console]::ForegroundColor = $originalColor
                }
            }
        }

        if (-not $wroteToConsole -and -not [string]::IsNullOrWhiteSpace($Color)) {
            $consoleColor = $null
            if ([System.Enum]::TryParse([System.ConsoleColor], $Color, $true, [ref]$consoleColor)) {
                $originalColor = $null
                try {
                    $originalColor = [Console]::ForegroundColor
                    [Console]::ForegroundColor = $consoleColor
                    Write-RenderedText -Text $output -NoAnsiOutput
                    $wroteToConsole = $true
                }
                catch {
                    $wroteToConsole = $false
                }
                finally {
                    if ($null -ne $originalColor) {
                        [Console]::ForegroundColor = $originalColor
                    }
                }
            }
        }
    }

    $informationAction = if ($wroteToConsole) { 'SilentlyContinue' } else { 'Continue' }
    Write-Information -MessageData $sanitizedOutput -InformationAction $informationAction -Tags 'ColorScripts'
}
