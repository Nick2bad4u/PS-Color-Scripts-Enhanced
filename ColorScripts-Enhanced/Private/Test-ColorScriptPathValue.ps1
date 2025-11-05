function Test-ColorScriptPathValue {
    param(
        [Parameter(Mandatory, Position = 0)]
        [object]$Value,
        [switch]$AllowEmpty
    )

    $stringValue = [string]$Value

    if ([string]::IsNullOrWhiteSpace($stringValue)) {
        if ($AllowEmpty) {
            return $true
        }

        $emptyMessage = if ($script:Messages -and $script:Messages.ContainsKey('InvalidPathValueEmpty')) {
            $script:Messages.InvalidPathValueEmpty
        }
        else {
            'Path value cannot be empty or whitespace.'
        }

        throw [System.Management.Automation.ValidationMetadataException]::new($emptyMessage)
    }

    $invalidCharacters = [char[]][System.IO.Path]::GetInvalidPathChars()

    if ($stringValue.IndexOfAny($invalidCharacters) -ge 0) {
        $characterMessage = if ($script:Messages -and $script:Messages.ContainsKey('InvalidPathValueCharacters')) {
            $script:Messages.InvalidPathValueCharacters -f $stringValue
        }
        else {
            "Path '$stringValue' contains invalid characters."
        }

        throw [System.Management.Automation.ValidationMetadataException]::new($characterMessage)
    }

    return $true
}
