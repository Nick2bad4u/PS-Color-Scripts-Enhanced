function Resolve-LocalizedImportTarget {
    param(
        [Parameter(Mandatory)]
        [string]$ParameterSetName,

        [AllowNull()][string]$FilePath,
        [AllowNull()][string]$BaseDirectory,

        [Parameter(Mandatory)]
        [string]$FileName
    )

    if ($ParameterSetName -eq 'File') {
        $resolvedFilePath = (Resolve-Path -LiteralPath $FilePath -ErrorAction Stop).ProviderPath
        return [pscustomobject]@{
            BaseDirectory   = Split-Path -Path $resolvedFilePath -Parent
            FileName        = Split-Path -Path $resolvedFilePath -Leaf
            ResolvedFilePath = $resolvedFilePath
        }
    }

    return [pscustomobject]@{
        BaseDirectory   = (Resolve-Path -LiteralPath $BaseDirectory -ErrorAction Stop).ProviderPath
        FileName        = $FileName
        ResolvedFilePath = $null
    }
}

function ConvertTo-LocalizedMessageDictionary {
    param(
        [Parameter(Mandatory)]
        [object]$Messages,

        [Parameter(Mandatory)]
        [string]$Context,

        [switch]$ThrowOnFailure
    )

    try {
        $converted = ConvertTo-HashtableInternal $Messages
    }
    catch {
        Write-ModuleTrace ("Conversion of localized data threw for '{0}': {1}" -f $Context, $_.Exception.Message)
        if ($ThrowOnFailure) {
            throw [System.InvalidOperationException]::new("Localized data did not produce a dictionary for '$Context'.", $_.Exception)
        }
        return $null
    }

    if ($converted -and $converted -is [System.Collections.IDictionary]) {
        return $converted
    }

    Write-ModuleTrace ("Conversion of localized data failed for '{0}'." -f $Context)
    if ($ThrowOnFailure) {
        throw [System.InvalidOperationException]::new("Localized data did not produce a dictionary for '$Context'.")
    }
    return $null
}

function Import-LocalizedDataMessage {
    param(
        [Parameter(Mandatory)]
        [string]$BaseDirectory,

        [Parameter(Mandatory)]
        [string]$FileName,

        [AllowNull()]
        [string[]]$FallbackUICulture
    )

    $importParams = @{
        BaseDirectory = $BaseDirectory
        FileName      = $FileName
    }
    if ($FallbackUICulture) {
        # Import-LocalizedData accepts one UICulture and performs parent fallback itself.
        $importParams['UICulture'] = $FallbackUICulture[0]
    }

    try {
        $messages = Import-LocalizedData @importParams
    }
    catch {
        Write-ModuleTrace ("Import-LocalizedData failed for '{0}' (base '{1}'): {2}" -f $FileName, $BaseDirectory, $_.Exception.Message)
        return $null
    }

    if (-not $messages -or $messages -is [System.Collections.IDictionary]) {
        return $messages
    }

    Write-ModuleTrace ("Import-LocalizedData returned unsupported type '{0}' for '{1}' (base '{2}'). Attempting conversion." -f $messages.GetType().FullName, $FileName, $BaseDirectory)
    return ConvertTo-LocalizedMessageDictionary -Messages $messages -Context "$FileName (base '$BaseDirectory')"
}

function Resolve-LocalizedImportFilePath {
    param(
        [Parameter(Mandatory)]
        [object]$Target
    )

    if ($Target.ResolvedFilePath) {
        return $Target.ResolvedFilePath
    }

    $candidate = Join-Path -Path $Target.BaseDirectory -ChildPath $Target.FileName
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        return $null
    }

    try {
        return (Resolve-Path -LiteralPath $candidate -ErrorAction Stop).ProviderPath
    }
    catch {
        return $candidate
    }
}

function Resolve-LocalizedFallbackImport {
    param(
        [Parameter(Mandatory)]
        [string]$ParameterSetName,

        [Parameter(Mandatory)]
        [object]$Target,

        [AllowNull()]
        [string]$FilePath,

        [AllowNull()]
        [string[]]$FallbackUICulture
    )

    if ($ParameterSetName -eq 'File') {
        $candidate = if ($Target.ResolvedFilePath) { $Target.ResolvedFilePath } else { $FilePath }
        return [pscustomobject]@{
            FilePath = $candidate
            Source   = 'Import-PowerShellDataFile'
        }
    }

    $resolutionParams = @{
        BaseDirectory = $Target.BaseDirectory
        FileName      = $Target.FileName
    }
    if ($FallbackUICulture) {
        $resolutionParams['CultureFallback'] = $FallbackUICulture
    }

    $resolution = Resolve-LocalizedMessagesFile @resolutionParams
    $source = 'Import-PowerShellDataFile'
    if ($resolution -and $resolution.CultureName) {
        $source = '{0}:{1}' -f $source, $resolution.CultureName
    }

    return [pscustomobject]@{
        FilePath = if ($resolution) { $resolution.FilePath } else { $null }
        Source   = $source
    }
}

function Import-PowerShellLocalizedMessage {
    param(
        [Parameter(Mandatory)]
        [string]$FilePath
    )

    try {
        $messages = Import-PowerShellDataFile -LiteralPath $FilePath -ErrorAction Stop
    }
    catch {
        Write-ModuleTrace ("Import-PowerShellDataFile failed for '{0}': {1}" -f $FilePath, $_.Exception.Message)
        throw
    }

    if ($messages -and $messages -isnot [System.Collections.IDictionary]) {
        Write-ModuleTrace ("Import-PowerShellDataFile returned unsupported type '{0}' for '{1}'. Attempting conversion." -f $messages.GetType().FullName, $FilePath)
        $messages = ConvertTo-LocalizedMessageDictionary -Messages $messages -Context $FilePath -ThrowOnFailure
    }

    if (-not $messages) {
        throw [System.InvalidOperationException]::new("Import-PowerShellDataFile returned no data for '$FilePath'.")
    }

    return $messages
}

function Resolve-LocalizedReturnPath {
    param(
        [Parameter(Mandatory)]
        [string]$FilePath
    )

    try {
        return (Resolve-Path -LiteralPath $FilePath -ErrorAction Stop).ProviderPath
    }
    catch {
        return $FilePath
    }
}

function New-LocalizedMessageImportResult {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary]$Messages,

        [Parameter(Mandatory)]
        [string]$Source,

        [AllowNull()]
        [string]$FilePath
    )

    $script:Messages = $Messages
    return [pscustomobject]@{
        Messages = $Messages
        Source   = $Source
        FilePath = $FilePath
    }
}

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

    $target = Resolve-LocalizedImportTarget -ParameterSetName $PSCmdlet.ParameterSetName -FilePath $FilePath -BaseDirectory $BaseDirectory -FileName $FileName
    $messages = Import-LocalizedDataMessage -BaseDirectory $target.BaseDirectory -FileName $target.FileName -FallbackUICulture $FallbackUICulture
    if ($messages) {
        $resolvedPath = Resolve-LocalizedImportFilePath -Target $target
        return New-LocalizedMessageImportResult -Messages $messages -Source 'Import-LocalizedData' -FilePath $resolvedPath
    }

    $fallback = Resolve-LocalizedFallbackImport -ParameterSetName $PSCmdlet.ParameterSetName -Target $target -FilePath $FilePath -FallbackUICulture $FallbackUICulture
    if (-not $fallback.FilePath) {
        throw [System.IO.FileNotFoundException]::new("Localized messages file '$($target.FileName)' could not be located.")
    }

    $messages = Import-PowerShellLocalizedMessage -FilePath $fallback.FilePath
    $resolvedPath = Resolve-LocalizedReturnPath -FilePath $fallback.FilePath
    return New-LocalizedMessageImportResult -Messages $messages -Source $fallback.Source -FilePath $resolvedPath
}
