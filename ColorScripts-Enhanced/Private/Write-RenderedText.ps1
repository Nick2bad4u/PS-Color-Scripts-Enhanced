function Write-RenderedText {
    param(
        [AllowNull()]
        [string]$Text,
        [switch]$NoAnsiOutput
    )

    $outputText = if ($null -ne $Text) { [string]$Text } else { '' }

    if ($NoAnsiOutput) {
        $outputText = Remove-ColorScriptAnsiSequence -Text $outputText
    }

    try {
        & $script:ConsoleWriteDelegate $outputText

        $requiresNewLine = $true
        if ($outputText) {
            $requiresNewLine = -not $outputText.EndsWith("`n")
        }

        if ($requiresNewLine) {
            & $script:ConsoleWriteDelegate ([Environment]::NewLine)
        }
    }
    catch [System.IO.IOException] {
        Write-Verbose 'Console handle unavailable during cached render; writing rendered text to the pipeline.'
        Write-Output $outputText
    }
}
