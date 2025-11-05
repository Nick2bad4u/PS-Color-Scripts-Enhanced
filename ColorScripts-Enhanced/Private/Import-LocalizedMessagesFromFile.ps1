function Import-LocalizedMessagesFromFile {
    [CmdletBinding(DefaultParameterSetName = 'File')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'File')]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [string]$FilePath,

        [Parameter(Mandatory, ParameterSetName = 'BaseDirectory')]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
        [string]$BaseDirectory,

        [Parameter(ParameterSetName = 'BaseDirectory')]
        [string]$FileName = 'Messages.psd1',

        [Parameter()]
        [string[]]$FallbackUICulture
    )

    $source = 'Import-LocalizedData'
    $baseDirectoryToUse = $null
    $fileNameToUse = $null
    $resolvedFilePath = $null

    if ($PSCmdlet.ParameterSetName -eq 'File') {
        $resolvedFilePath = (Resolve-Path -LiteralPath $FilePath -ErrorAction Stop).ProviderPath
        $baseDirectoryToUse = Split-Path -Path $resolvedFilePath -Parent
        $fileNameToUse = Split-Path -Path $resolvedFilePath -Leaf
    }
    else {
        $baseDirectoryToUse = (Resolve-Path -LiteralPath $BaseDirectory -ErrorAction Stop).ProviderPath
        $fileNameToUse = if ($PSBoundParameters.ContainsKey('FileName')) { $FileName } else { 'Messages.psd1' }
    }

    $importParams = @{
        BaseDirectory = $baseDirectoryToUse
        FileName      = $fileNameToUse
    }

    if ($FallbackUICulture) {
        $importParams['FallbackUICulture'] = $FallbackUICulture
    }

    $messages = $null
    try {
        $messages = Import-LocalizedData @importParams
        if ($messages -and $messages -isnot [System.Collections.IDictionary]) {
            Write-ModuleTrace ("Import-LocalizedData returned unsupported type '{0}' for '{1}' (base '{2}')." -f $messages.GetType().FullName, $fileNameToUse, $baseDirectoryToUse)
            $messages = $null
        }
    }
    catch {
        Write-ModuleTrace ("Import-LocalizedData failed for '{0}' (base '{1}'): {2}" -f $fileNameToUse, $baseDirectoryToUse, $_.Exception.Message)
        $messages = $null
    }

    if ($messages) {
        if (-not $resolvedFilePath) {
            $candidate = Join-Path -Path $baseDirectoryToUse -ChildPath $fileNameToUse
            if (Test-Path -LiteralPath $candidate -PathType Leaf) {
                try {
                    $resolvedFilePath = (Resolve-Path -LiteralPath $candidate -ErrorAction Stop).ProviderPath
                }
                catch {
                    $resolvedFilePath = $candidate
                }
            }
        }

        $script:Messages = $messages
        return [pscustomobject]@{
            Messages = $messages
            Source   = $source
            FilePath = $resolvedFilePath
        }
    }

    $source = 'Import-PowerShellDataFile'

    $finalCandidate = $null

    if ($PSCmdlet.ParameterSetName -eq 'File') {
        if ($resolvedFilePath) {
            $finalCandidate = $resolvedFilePath
        }
        elseif ($FilePath) {
            $finalCandidate = $FilePath
        }
    }
    else {
        $resolutionParams = @{
            BaseDirectory    = $baseDirectoryToUse
            FileName         = $fileNameToUse
            CultureFallback  = $FallbackUICulture
        }

        if (-not $resolutionParams.CultureFallback) {
            $resolutionParams.Remove('CultureFallback') | Out-Null
        }

        $resolution = Resolve-LocalizedMessagesFile @resolutionParams
        if ($resolution) {
            $finalCandidate = $resolution.FilePath
            if ($resolution.CultureName) {
                $source = '{0}:{1}' -f $source, $resolution.CultureName
            }
        }
    }

    if (-not $finalCandidate) {
        throw [System.IO.FileNotFoundException]::new("Localized messages file '$fileNameToUse' could not be located.")
    }

    try {
        $messages = Import-PowerShellDataFile -LiteralPath $finalCandidate -ErrorAction Stop
    }
    catch {
        Write-ModuleTrace ("Import-PowerShellDataFile failed for '{0}': {1}" -f $finalCandidate, $_.Exception.Message)
        throw
    }

    if ($messages -isnot [System.Collections.IDictionary]) {
        $messageType = if ($messages) { $messages.GetType().FullName } else { 'null' }
        Write-ModuleTrace ("Import-PowerShellDataFile returned unsupported type '{0}' for '{1}'." -f $messageType, $finalCandidate)
        throw [System.InvalidOperationException]::new("Import-PowerShellDataFile did not produce a dictionary for '$finalCandidate'.")
    }

    if (-not $messages) {
        throw [System.InvalidOperationException]::new("Import-PowerShellDataFile returned no data for '$finalCandidate'.")
    }

    $script:Messages = $messages

    $resolvedReturnPath = $finalCandidate
    try {
        $resolvedReturnPath = (Resolve-Path -LiteralPath $finalCandidate -ErrorAction Stop).ProviderPath
    }
    catch {
        $resolvedReturnPath = $finalCandidate
    }

    return [pscustomobject]@{
        Messages = $messages
        Source   = $source
        FilePath = $resolvedReturnPath
    }
}
