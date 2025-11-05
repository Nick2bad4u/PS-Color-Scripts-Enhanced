function Test-ColorScriptNameValue {
    param(
        [Parameter(Mandatory, Position = 0)]
        [object]$Value,
        [switch]$AllowWildcard,
        [switch]$AllowEmpty
    )

    $stringValue = [string]$Value

    if ([string]::IsNullOrWhiteSpace($stringValue)) {
        if ($AllowEmpty) {
            return $true
        }

        $message = if ($script:Messages -and $script:Messages.ContainsKey('InvalidScriptNameEmpty')) {
            $script:Messages.InvalidScriptNameEmpty
        }
        else {
            'Color script name cannot be empty or whitespace.'
        }

        throw [System.Management.Automation.ValidationMetadataException]::new($message)
    }

    $invalidCharacters = [System.IO.Path]::GetInvalidFileNameChars()
    if ($AllowWildcard) {
        $invalidCharacters = [char[]]($invalidCharacters | Where-Object { $_ -ne '*' -and $_ -ne '?' })
    }

    if ($stringValue.IndexOfAny([char[]]$invalidCharacters) -ge 0) {
        $characterMessage = if ($script:Messages -and $script:Messages.ContainsKey('InvalidScriptNameCharacters')) {
            $script:Messages.InvalidScriptNameCharacters -f $stringValue
        }
        else {
            "Color script name '$stringValue' contains invalid characters."
        }

        throw [System.Management.Automation.ValidationMetadataException]::new($characterMessage)
    }

    return $true
}
