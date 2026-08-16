function Get-InvalidColorScriptNameMessage {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateSet('Empty', 'Characters')]
        [string]$Reason
    )

    $messageKey = "InvalidScriptName$Reason"
    if ($script:Messages -and $script:Messages.ContainsKey($messageKey)) {
        return $script:Messages[$messageKey] -f $Name
    }
    if ($Reason -eq 'Empty') {
        return 'Color script name cannot be empty or whitespace.'
    }
    return "Color script name '$Name' contains invalid characters."
}

function Invoke-InvalidColorScriptNameError {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $message = Get-InvalidColorScriptNameMessage -Name $Name -Reason Characters
    throw [System.Management.Automation.ValidationMetadataException]::new($message)
}

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

        $message = Get-InvalidColorScriptNameMessage -Name $stringValue -Reason Empty
        throw [System.Management.Automation.ValidationMetadataException]::new($message)
    }

    $wildcardCharacters = @([char]'*', [char]'?')
    $invalidCharacterList = New-Object 'System.Collections.Generic.List[char]'
    foreach ($character in [System.IO.Path]::GetInvalidFileNameChars()) {
        $null = $invalidCharacterList.Add($character)
    }

    if ($AllowWildcard) {
        foreach ($wc in $wildcardCharacters) {
            $null = $invalidCharacterList.Remove($wc)
        }
    }
    elseif ($stringValue.IndexOfAny([char[]]$wildcardCharacters) -ge 0) {
        Invoke-InvalidColorScriptNameError -Name $stringValue
    }

    $invalidCharacters = $invalidCharacterList.ToArray()

    if ($invalidCharacters -and $stringValue.IndexOfAny($invalidCharacters) -ge 0) {
        Invoke-InvalidColorScriptNameError -Name $stringValue
    }

    return $true
}
