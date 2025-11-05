function Write-ColorScriptInformation {
    param(
        [AllowNull()][string]$Message,
        [switch]$Quiet
    )

    if ($Quiet) {
        return
    }

    $output = if ($null -ne $Message) { [string]$Message } else { '' }
    Write-Information -MessageData $output -InformationAction Continue -Tags 'ColorScripts'
}
