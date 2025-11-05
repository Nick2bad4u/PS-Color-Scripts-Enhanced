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

    $wildcardCharacters = @([char]'*', [char]'?')
    $invalidCharacterList = New-Object 'System.Collections.Generic.List[char]'
    foreach ($character in [System.IO.Path]::GetInvalidFileNameChars()) {
        $null = $invalidCharacterList.Add($character)
    }

    $throwInvalidCharacter = {
        param([string]$Name)

        $characterMessage = if ($script:Messages -and $script:Messages.ContainsKey('InvalidScriptNameCharacters')) {
            $script:Messages.InvalidScriptNameCharacters -f $Name
        }
        else {
            "Color script name '$Name' contains invalid characters."
        }

        throw [System.Management.Automation.ValidationMetadataException]::new($characterMessage)
    }

    if ($AllowWildcard) {
        foreach ($wc in $wildcardCharacters) {
            $null = $invalidCharacterList.Remove($wc)
        }
    }
    elseif ($stringValue.IndexOfAny([char[]]$wildcardCharacters) -ge 0) {
        & $throwInvalidCharacter $stringValue
    }

    $invalidCharacters = $invalidCharacterList.ToArray()

    if ($invalidCharacters -and $stringValue.IndexOfAny($invalidCharacters) -ge 0) {
        & $throwInvalidCharacter $stringValue
    }

    return $true
}
