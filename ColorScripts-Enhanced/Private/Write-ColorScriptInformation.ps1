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

    $forceAnsiEnv = $env:COLOR_SCRIPTS_ENHANCED_FORCE_ANSI
    $forceAnsi = $PreferConsole.IsPresent
    if (-not $forceAnsi -and -not [string]::IsNullOrWhiteSpace($forceAnsiEnv)) {
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
        $shouldTryConsole = $forceAnsi

        if (-not $shouldTryConsole) {
            try {
                $shouldTryConsole = -not (Test-ConsoleOutputRedirected)
            }
            catch {
                $shouldTryConsole = $false
            }
        }

        if ($shouldTryConsole) {
            try {
                Write-RenderedText -Text $output -NoAnsiOutput:$false
                $wroteToConsole = $true
            }
            catch {
                $wroteToConsole = $false
            }
        }

        if (-not $wroteToConsole -and -not [string]::IsNullOrWhiteSpace($Color)) {
            $consoleColor = $null
            if ([System.Enum]::TryParse([System.ConsoleColor], $Color, $true, [ref]$consoleColor)) {
                try {
                    $originalColor = [Console]::ForegroundColor
                    [Console]::ForegroundColor = $consoleColor
                    & $script:ConsoleWriteDelegate $sanitizedOutput

                    $requiresNewLine = $true
                    if ($sanitizedOutput) {
                        $requiresNewLine = -not $sanitizedOutput.EndsWith("`n")
                    }

                    if ($requiresNewLine) {
                        & $script:ConsoleWriteDelegate ([Environment]::NewLine)
                    }

                    $wroteToConsole = $true
                }
                catch {
                    $wroteToConsole = $false
                }
                finally {
                    try {
                        [Console]::ForegroundColor = $originalColor
                    }
                    catch {
                        Write-ModuleTrace ("Failed to restore console color: {0}" -f $_.Exception.Message)
                    }
                }
            }
        }
    }

    $informationAction = if ($wroteToConsole) { 'SilentlyContinue' } else { 'Continue' }

    Write-Information -MessageData $sanitizedOutput -InformationAction $informationAction -Tags 'ColorScripts'
}
