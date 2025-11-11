#region Localization Helpers

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

    $candidateFiles = New-Object System.Collections.Generic.List[string]

    if ($PSCmdlet.ParameterSetName -eq 'File') {
        if ($resolvedFilePath) {
            [void]$candidateFiles.Add($resolvedFilePath)
        }
        else {
            [void]$candidateFiles.Add($FilePath)
        }
    }
    else {
        [void]$candidateFiles.Add((Join-Path -Path $baseDirectoryToUse -ChildPath $fileNameToUse))

        if ($FallbackUICulture) {
            foreach ($culture in $FallbackUICulture) {
                if ([string]::IsNullOrWhiteSpace($culture)) { continue }
                $culturePath = Join-Path -Path $baseDirectoryToUse -ChildPath $culture
                [void]$candidateFiles.Add((Join-Path -Path $culturePath -ChildPath $fileNameToUse))
            }
        }
    }

    $finalCandidate = $candidateFiles |
        Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Leaf) } |
            Select-Object -First 1

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

function Initialize-ColorScriptsLocalization {
    param(
        [string[]]$CandidateRoots,
        [string[]]$CultureFallbackOverride
    )

    return Invoke-ModuleSynchronized $script:LocalizationSyncRoot {
        if ($script:LocalizationInitialized -and $script:Messages) {
            if (-not $script:LocalizationDetails) {
                $script:LocalizationDetails = [pscustomobject]@{
                    LocalizedDataLoaded = $true
                    ModuleRoot          = $script:ModuleRoot
                    SearchedPaths       = @()
                    Source              = 'Import-LocalizedData'
                    FilePath            = $null
                }
            }

            return $script:LocalizationDetails
        }

        $uniqueCandidates = New-Object System.Collections.Generic.List[string]
        if ($CandidateRoots) {
            foreach ($candidate in $CandidateRoots) {
                if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
                if (-not $uniqueCandidates.Contains($candidate)) {
                    $null = $uniqueCandidates.Add($candidate)
                }
            }
        }

        if (-not $uniqueCandidates.Count) {
            if ($script:ModuleRoot) {
                $null = $uniqueCandidates.Add($script:ModuleRoot)
            }
            elseif ($PSScriptRoot) {
                $null = $uniqueCandidates.Add($PSScriptRoot)
            }
        }

        $searchedPaths = New-Object System.Collections.Generic.List[string]
        $resolvedRoot = $null

        foreach ($candidate in $uniqueCandidates) {
            if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
            Write-ModuleTrace ('Evaluating localization candidate: {0}' -f $candidate)
            $null = $searchedPaths.Add($candidate)

            $candidatePath = $candidate
            try {
                $resolvedCandidate = Resolve-Path -LiteralPath $candidate -ErrorAction Stop
                if ($resolvedCandidate) {
                    $candidatePath = $resolvedCandidate.ProviderPath
                }
            }
            catch {
                Write-ModuleTrace ("Localization candidate resolution failed for '{0}': {1}" -f $candidate, $_.Exception.Message)
            }

            if (Test-Path -LiteralPath $candidatePath -PathType Container) {
                $resolvedRoot = $candidatePath
                break
            }
        }

        if (-not $resolvedRoot) {
            Write-ModuleTrace 'No localization candidate paths resolved; falling back to module root discovery.'
            if ($PSScriptRoot -and (Test-Path -LiteralPath $PSScriptRoot -PathType Container)) {
                try {
                    $resolvedRoot = (Resolve-Path -LiteralPath $PSScriptRoot -ErrorAction Stop).ProviderPath
                }
                catch {
                    $resolvedRoot = $PSScriptRoot
                }
            }
            elseif ($script:ModuleRoot) {
                $resolvedRoot = $script:ModuleRoot
            }
        }

        if (-not $resolvedRoot) {
            throw [System.InvalidOperationException]::new('Unable to resolve a module root for localization resources.')
        }

        $script:ModuleRoot = $resolvedRoot

        $importParams = @{
            BaseDirectory = $resolvedRoot
        }

        if ($CultureFallbackOverride -and $CultureFallbackOverride.Count -gt 0) {
            $importParams['FallbackUICulture'] = $CultureFallbackOverride
        }

        try {
            $importResult = Import-LocalizedMessagesFromFile @importParams
            if (-not $importResult -or -not $importResult.Messages) {
                throw [System.InvalidOperationException]::new('Import-LocalizedData returned no data.')
            }

            $messages = $importResult.Messages
            $source = if ($importResult.Source) { $importResult.Source } else { 'Import-LocalizedData' }
            $filePath = if ($importResult.FilePath) { $importResult.FilePath } else { $null }

            $script:Messages = $messages
            $script:LocalizationInitialized = $true
            $script:LocalizationDetails = [pscustomobject]@{
                LocalizedDataLoaded = $true
                ModuleRoot          = $resolvedRoot
                SearchedPaths       = $searchedPaths.ToArray()
                Source              = $source
                FilePath            = $filePath
            }

            if ($filePath) {
                Write-ModuleTrace ('Localization resolved via {0} from {1} (file {2})' -f $source, $resolvedRoot, $filePath)
            }
            else {
                Write-ModuleTrace ('Localization resolved via {0} from {1}' -f $source, $resolvedRoot)
            }
        }
        catch {
            Write-ModuleTrace ('Localization import failure: {0}' -f $_.Exception.Message)
            $script:Messages = if ($script:EmbeddedDefaultMessages) { $script:EmbeddedDefaultMessages.Clone() } else { @{} }
            $script:LocalizationInitialized = $true
            $script:LocalizationDetails = [pscustomobject]@{
                LocalizedDataLoaded = $false
                ModuleRoot          = $resolvedRoot
                SearchedPaths       = $searchedPaths.ToArray()
                Source              = 'EmbeddedDefaults'
                FilePath            = $null
            }

            Write-Warning 'Localization resources were not found. Falling back to built-in English messages.'
        }

        return $script:LocalizationDetails
    }
}

#endregion

#region Conversion and Text Helpers

function ConvertTo-HashtableInternal {
    param([Parameter(ValueFromPipeline)]$InputObject)

    process {
        if ($null -eq $InputObject) {
            return $null
        }

        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = @()
            foreach ($item in $InputObject) {
                $collection += ConvertTo-HashtableInternal $item
            }
            return $collection
        }

        if ($InputObject -is [PSCustomObject]) {
            $hash = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = ConvertTo-HashtableInternal $property.Value
            }
            return $hash
        }

        return $InputObject
    }
}

function ConvertFrom-JsonToHashtable {
    <#
    .SYNOPSIS
        Converts JSON to a hashtable, compatible with PowerShell 5.1 and 7+
    .DESCRIPTION
        PowerShell 5.1 doesn't support -AsHashtable parameter on ConvertFrom-Json.
        This function provides a compatible conversion method for all PowerShell versions.
    #>
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowEmptyString()]
        [string]$InputObject
    )

    process {
        if ([string]::IsNullOrWhiteSpace($InputObject)) {
            return $null
        }

        # PowerShell 6.0+ supports -AsHashtable natively
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            return ConvertFrom-Json -InputObject $InputObject -AsHashtable
        }

        $obj = ConvertFrom-Json -InputObject $InputObject
        return ConvertTo-HashtableInternal $obj
    }
}

function Get-ColorScriptAnsiSequence {
    param([string]$Color)

    if ([string]::IsNullOrWhiteSpace($Color)) {
        return $null
    }

    switch ($Color.ToLowerInvariant()) {
        'cyan' { return "${([char]27)}[36m" }
        'yellow' { return "${([char]27)}[33m" }
        'green' { return "${([char]27)}[32m" }
        'magenta' { return "${([char]27)}[35m" }
        'darkgray' { return "${([char]27)}[90m" }
        'red' { return "${([char]27)}[31m" }
        'blue' { return "${([char]27)}[34m" }
        default { return $null }
    }
}

function New-ColorScriptAnsiText {
    param(
        [AllowNull()][string]$Text,
        [string]$Color,
        [switch]$NoAnsiOutput
    )

    $resolvedText = if ($null -ne $Text) { [string]$Text } else { '' }

    if ($NoAnsiOutput) {
        return $resolvedText
    }

    $sequence = Get-ColorScriptAnsiSequence -Color $Color
    if (-not $sequence) {
        return $resolvedText
    }

    return "${sequence}${resolvedText}${([char]27)}[0m"
}

function Remove-ColorScriptAnsiSequence {
    param([AllowNull()][string]$Text)

    if ($null -eq $Text) {
        return $Text
    }

    if (-not $script:AnsiStripRegex) {
        $pattern = "${([char]27)}\[[0-9;]*[A-Za-z]"
        $script:AnsiStripRegex = [System.Text.RegularExpressions.Regex]::new(
            $pattern,
            [System.Text.RegularExpressions.RegexOptions]::Compiled
        )
    }

    return $script:AnsiStripRegex.Replace([string]$Text, '')
}

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

function Invoke-ModuleSynchronized {
    param(
        [Parameter(Mandatory)][object]$SyncRoot,
        [Parameter(Mandatory)][scriptblock]$Action
    )

    if (-not $SyncRoot) {
        return & $Action
    }

    $lockTaken = $false
    try {
        [System.Threading.Monitor]::Enter($SyncRoot, [ref]$lockTaken)
        return & $Action
    }
    finally {
        if ($lockTaken) {
            [System.Threading.Monitor]::Exit($SyncRoot)
        }
    }
}

#endregion

#region Delegate Initialization and File Helpers

function Initialize-SystemDelegateState {
    Invoke-ModuleSynchronized $script:DelegateSyncRoot {
        if (-not $script:GetUserProfilePathDelegate) {
            $script:GetUserProfilePathDelegate = { [System.Environment]::GetFolderPath('UserProfile') }
        }

        if (-not $script:IsPathRootedDelegate) {
            $script:IsPathRootedDelegate = {
                param([string]$Path)
                [System.IO.Path]::IsPathRooted($Path)
            }
        }

        if (-not $script:GetFullPathDelegate) {
            $script:GetFullPathDelegate = {
                param([string]$Path)
                [System.IO.Path]::GetFullPath($Path)
            }
        }

        if (-not $script:GetCurrentDirectoryDelegate) {
            $script:GetCurrentDirectoryDelegate = {
                [System.IO.Directory]::GetCurrentDirectory()
            }
        }

        if (-not $script:GetCurrentProviderPathDelegate) {
            $script:GetCurrentProviderPathDelegate = {
                $ExecutionContext.SessionState.Path.CurrentFileSystemLocation.ProviderPath
            }
        }

        if (-not $script:DirectoryGetLastWriteTimeUtcDelegate) {
            $script:DirectoryGetLastWriteTimeUtcDelegate = {
                param([string]$Path)
                [System.IO.Directory]::GetLastWriteTimeUtc($Path)
            }
        }

        if (-not $script:FileExistsDelegate) {
            $script:FileExistsDelegate = {
                param([string]$Path)
                [System.IO.File]::Exists($Path)
            }
        }

        if (-not $script:FileGetLastWriteTimeUtcDelegate) {
            $script:FileGetLastWriteTimeUtcDelegate = {
                param([string]$Path)
                [System.IO.File]::GetLastWriteTimeUtc($Path)
            }
        }

        if (-not $script:FileReadAllTextDelegate) {
            $script:FileReadAllTextDelegate = {
                param([string]$Path, [System.Text.Encoding]$Encoding)
                [System.IO.File]::ReadAllText($Path, $Encoding)
            }
        }

        if (-not $script:GetCurrentProcessDelegate) {
            $script:GetCurrentProcessDelegate = {
                [System.Diagnostics.Process]::GetCurrentProcess()
            }
        }

        if (-not $script:IsOutputRedirectedDelegate) {
            $script:IsOutputRedirectedDelegate = { [Console]::IsOutputRedirected }
        }

        if (-not $script:GetConsoleOutputEncodingDelegate) {
            $script:GetConsoleOutputEncodingDelegate = { [Console]::OutputEncoding }
        }

        if (-not $script:SetConsoleOutputEncodingDelegate) {
            $script:SetConsoleOutputEncodingDelegate = {
                param([System.Text.Encoding]$Encoding)
                [Console]::OutputEncoding = $Encoding
            }
        }

        if (-not $script:ConsoleWriteDelegate) {
            $script:ConsoleWriteDelegate = {
                param([string]$Text)
                [Console]::Write($Text)
            }
        }

        if (-not $script:CreateDirectoryDelegate) {
            $script:CreateDirectoryDelegate = {
                param([string]$Path)
                [System.IO.Directory]::CreateDirectory($Path)
            }
        }
    }
}

function Invoke-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [System.Management.Automation.PSCmdlet]$Cmdlet,
        [object]$Target,
        [string]$Action
    )

    if ($script:ShouldProcessEvaluator -is [scriptblock]) {
        return & $script:ShouldProcessEvaluator $Cmdlet $Target $Action
    }

    if ($script:ShouldProcessOverride -is [scriptblock]) {
        return & $script:ShouldProcessOverride $Cmdlet $Target $Action
    }

    return $Cmdlet.ShouldProcess($Target, $Action)
}

function Invoke-FileWriteAllText {
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$Path,
        [Parameter(Mandatory)]
        [string]$Content,
        [Parameter(Mandatory)]
        [System.Text.Encoding]$Encoding
    )

    [System.IO.File]::WriteAllText($Path, $Content, $Encoding)
}

function Get-FileLastWriteTimeUtc {
    param([Parameter(Mandatory)][string]$Path)
    [System.IO.File]::GetLastWriteTimeUtc($Path)
}

function Set-FileLastWriteTimeUtc {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][datetime]$Timestamp
    )

    [System.IO.File]::SetLastWriteTimeUtc($Path, $Timestamp)
}

function Get-FileLastWriteTime {
    param([Parameter(Mandatory)][string]$Path)
    [System.IO.File]::GetLastWriteTime($Path)
}

function Set-FileLastWriteTime {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][datetime]$Timestamp
    )

    [System.IO.File]::SetLastWriteTime($Path, $Timestamp)
}

function Copy-ColorScriptHashtable {
    param([System.Collections.IDictionary]$Source)

    if (-not $Source) {
        return @{}
    }

    $clone = @{}
    foreach ($key in $Source.Keys) {
        $value = $Source[$key]
        switch ($true) {
            { $value -is [System.Collections.IDictionary] } {
                $clone[$key] = Copy-ColorScriptHashtable $value
                break
            }
            { $value -is [System.Array] } {
                $clone[$key] = $value.Clone()
                break
            }
            { $value -is [System.ICloneable] -and $value -isnot [string] } {
                $clone[$key] = $value.Clone()
                break
            }
            { $value -is [System.Collections.IEnumerable] -and $value -isnot [string] } {
                $buffer = New-Object System.Collections.Generic.List[object]
                foreach ($item in $value) {
                    $null = $buffer.Add($item)
                }
                $clone[$key] = $buffer.ToArray()
                break
            }
            default {
                $clone[$key] = $value
            }
        }
    }

    return $clone
}

function Merge-ColorScriptConfiguration {
    param(
        [System.Collections.IDictionary]$Base,
        [System.Collections.IDictionary]$Override
    )

    if (-not $Override) {
        return Copy-ColorScriptHashtable $Base
    }

    $result = Copy-ColorScriptHashtable $Base
    foreach ($key in $Override.Keys) {
        $overrideValue = $Override[$key]
        if ($result.ContainsKey($key)) {
            $baseValue = $result[$key]
            if ($baseValue -is [System.Collections.IDictionary] -and $overrideValue -is [System.Collections.IDictionary]) {
                $result[$key] = Merge-ColorScriptConfiguration $baseValue $overrideValue
                continue
            }
        }

        switch ($true) {
            { $overrideValue -is [System.Collections.IDictionary] } {
                $result[$key] = Copy-ColorScriptHashtable $overrideValue
                break
            }
            { $overrideValue -is [System.Array] } {
                $result[$key] = $overrideValue.Clone()
                break
            }
            { $overrideValue -is [System.ICloneable] -and $overrideValue -isnot [string] } {
                $result[$key] = $overrideValue.Clone()
                break
            }
            { $overrideValue -is [System.Collections.IEnumerable] -and $overrideValue -isnot [string] } {
                $buffer = New-Object System.Collections.Generic.List[object]
                foreach ($item in $overrideValue) {
                    $null = $buffer.Add($item)
                }
                $result[$key] = $buffer.ToArray()
                break
            }
            default {
                $result[$key] = $overrideValue
            }
        }
    }

    return $result
}

#endregion

#region Configuration and Error Helpers

function Show-ColorScriptHelp {
    <#
    .SYNOPSIS
    Displays colorized help output for a command.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Write-Host is intentionally used for colored help output to the console.')]
    param(
        [Parameter(Mandatory)]
        [string]$CommandName
    )

    $helpContent = Get-Help $CommandName -Full | Out-String
    $lines = $helpContent -split "`n"

    foreach ($line in $lines) {
        if ($line -match '^NAME$|^SYNOPSIS$|^SYNTAX$|^DESCRIPTION$|^PARAMETERS$|^EXAMPLES$|^INPUTS$|^OUTPUTS$|^NOTES$|^RELATED LINKS$') {
            Write-Host $line -ForegroundColor Cyan
        }
        elseif ($line -match '^\s+-\w+') {
            Write-Host $line -ForegroundColor Yellow
        }
        elseif ($line -match '^\s+--') {
            Write-Host $line -ForegroundColor Green
        }
        elseif ($line -match 'EXAMPLE \d+') {
            Write-Host $line -ForegroundColor Magenta
        }
        elseif ($line -match '^\s+Required\?|^\s+Position\?|^\s+Default value|^\s+Accept pipeline input\?|^\s+Accept wildcard characters\?') {
            Write-Host $line -ForegroundColor DarkGray
        }
        else {
            Write-Host $line
        }
    }
}

function Get-ColorScriptsConfigurationRoot {
    if ($script:ConfigurationRoot) {
        return $script:ConfigurationRoot
    }

    $candidates = @()

    $overrideRoot = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
    if (-not [string]::IsNullOrWhiteSpace($overrideRoot)) {
        $candidates += $overrideRoot
    }

    if ($script:IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
        if ($env:APPDATA) {
            $candidates += (Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced')
        }
    }
    elseif ($script:IsMacOS) {
        $macBase = Join-Path -Path $HOME -ChildPath 'Library'
        $macBase = Join-Path -Path $macBase -ChildPath 'Application Support'
        $candidates += (Join-Path -Path $macBase -ChildPath 'ColorScripts-Enhanced')
    }
    else {
        $xdgConfig = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path -Path $HOME -ChildPath '.config' }
        if (-not [string]::IsNullOrWhiteSpace($xdgConfig)) {
            $candidates += (Join-Path -Path $xdgConfig -ChildPath 'ColorScripts-Enhanced')
        }
    }

    if ($candidates.Count -eq 0) {
        $candidates = @([System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), 'ColorScripts-Enhanced'))
    }

    foreach ($candidate in $candidates) {
        if ([string]::IsNullOrWhiteSpace($candidate)) {
            continue
        }

        $resolved = Resolve-CachePath -Path $candidate
        if (-not $resolved) {
            continue
        }

        try {
            if (-not (Test-Path -LiteralPath $resolved)) {
                (& $script:CreateDirectoryDelegate $resolved) | Out-Null
            }

            $script:ConfigurationRoot = $resolved
            return $script:ConfigurationRoot
        }
        catch {
            Write-Verbose "Unable to prepare configuration directory '$resolved': $($_.Exception.Message)"
        }
    }

    Invoke-ColorScriptError -Message $script:Messages.UnableToDetermineConfigurationDirectory -ErrorId 'ColorScriptsEnhanced.ConfigurationRootUnavailable' -Category ([System.Management.Automation.ErrorCategory]::ResourceUnavailable)
}

function Save-ColorScriptConfiguration {
    param(
        [hashtable]$Configuration,
        [string]$ExistingContent,
        [switch]$Force
    )

    $configRoot = Get-ColorScriptsConfigurationRoot
    if (-not $configRoot) {
        Invoke-ColorScriptError -Message $script:Messages.ConfigurationRootCouldNotBeResolved -ErrorId 'ColorScriptsEnhanced.ConfigurationRootNotResolved' -Category ([System.Management.Automation.ErrorCategory]::ResourceUnavailable)
    }

    $script:ConfigurationPath = Join-Path -Path $configRoot -ChildPath 'config.json'
    $json = $Configuration | ConvertTo-Json -Depth 6
    $normalizedNew = $json.TrimEnd("`r", "`n")

    if (-not $Force) {
        if (-not $ExistingContent -and (Test-Path -LiteralPath $script:ConfigurationPath)) {
            try {
                $ExistingContent = Get-Content -LiteralPath $script:ConfigurationPath -Raw -ErrorAction Stop
            }
            catch {
                $ExistingContent = $null
            }
        }

        if ($ExistingContent) {
            $normalizedExisting = $ExistingContent.TrimEnd("`r", "`n")
            if ($normalizedExisting -eq $normalizedNew) {
                return
            }
        }
        elseif (-not (Test-Path -LiteralPath $script:ConfigurationPath)) {
        }
        else {
        }
    }

    Set-Content -Path $script:ConfigurationPath -Value ($json + [Environment]::NewLine) -Encoding UTF8
}

function Initialize-Configuration {
    if ($script:ConfigurationInitialized -and $script:ConfigurationData) {
        return
    }

    Invoke-ModuleSynchronized $script:ConfigurationSyncRoot {
        if ($script:ConfigurationInitialized -and $script:ConfigurationData) {
            return
        }

        $configRoot = Get-ColorScriptsConfigurationRoot
        $script:ConfigurationPath = Join-Path -Path $configRoot -ChildPath 'config.json'

        $existing = $null
        $raw = $null
        $forceSave = $false
        $configExists = Test-Path -LiteralPath $script:ConfigurationPath

        if ($configExists) {
            try {
                $raw = Get-Content -LiteralPath $script:ConfigurationPath -Raw -ErrorAction Stop
                if (-not [string]::IsNullOrWhiteSpace($raw)) {
                    $existing = ConvertFrom-JsonToHashtable -InputObject $raw
                }
                else {
                    $raw = $null
                }
            }
            catch {
                Write-Warning ($script:Messages.FailedToParseConfigurationFile -f $script:ConfigurationPath, $_.Exception.Message)
                $forceSave = $true
                $raw = $null
            }
        }

        $script:ConfigurationData = Merge-ColorScriptConfiguration $script:DefaultConfiguration $existing

        if ($forceSave -or -not $configExists) {
            Save-ColorScriptConfiguration -Configuration $script:ConfigurationData -ExistingContent $raw -Force:$forceSave
        }

        $script:ConfigurationInitialized = $true
    }
}

function Get-ConfigurationDataInternal {
    Initialize-Configuration
    return $script:ConfigurationData
}

#endregion

#region Validation and Error Handling

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

function New-ColorScriptErrorRecord {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [Parameter()]
        [string]$ErrorId = 'ColorScriptsEnhanced.RuntimeError',

        [Parameter()]
        [System.Management.Automation.ErrorCategory]$Category = [System.Management.Automation.ErrorCategory]::InvalidOperation,

        [Parameter()]
        [object]$TargetObject,

        [Parameter()]
        [System.Exception]$Exception,

        [Parameter()]
        [string]$RecommendedAction
    )

    if (-not [string]::IsNullOrWhiteSpace($Message)) {
        $effectiveMessage = $Message
    }
    elseif ($Exception) {
        $effectiveMessage = $Exception.Message
    }
    else {
        $effectiveMessage = 'An error occurred within ColorScripts-Enhanced.'
    }

    if (-not $Exception) {
        $Exception = [System.Management.Automation.RuntimeException]::new($effectiveMessage)
    }
    elseif ($effectiveMessage -and $Exception.Message -ne $effectiveMessage) {
        $Exception = [System.Management.Automation.RuntimeException]::new($effectiveMessage, $Exception)
    }

    $errorRecord = [System.Management.Automation.ErrorRecord]::new($Exception, $ErrorId, $Category, $TargetObject)

    if (-not $errorRecord.ErrorDetails) {
        $errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($effectiveMessage)
    }
    elseif ($effectiveMessage -and [string]::IsNullOrWhiteSpace($errorRecord.ErrorDetails.Message)) {
        $errorRecord.ErrorDetails.Message = $effectiveMessage
    }

    if ($RecommendedAction) {
        if (-not $errorRecord.ErrorDetails) {
            $errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($effectiveMessage)
        }
        $errorRecord.ErrorDetails.RecommendedAction = $RecommendedAction
    }

    return $errorRecord
}

function Invoke-ColorScriptError {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [Parameter()]
        [string]$ErrorId = 'ColorScriptsEnhanced.RuntimeError',

        [Parameter()]
        [System.Management.Automation.ErrorCategory]$Category = [System.Management.Automation.ErrorCategory]::InvalidOperation,

        [Parameter()]
        [object]$TargetObject,

        [Parameter()]
        [System.Exception]$Exception,

        [Parameter()]
        [string]$RecommendedAction,

        [Parameter()]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    $errorRecord = New-ColorScriptErrorRecord -Message $Message -ErrorId $ErrorId -Category $Category -TargetObject $TargetObject -Exception $Exception -RecommendedAction $RecommendedAction

    if ($Cmdlet) {
        $Cmdlet.ThrowTerminatingError($errorRecord)
    }
    else {
        throw $errorRecord
    }
}

#endregion

#region Cache and Inventory Helpers

$script:DefaultAutoCategoryRules = @(
    [pscustomobject]@{
        Category = 'System'
        Tags     = @('System', 'Utility')
        Patterns = @(
            '^(00default|alpha)$',
            '^ansi-palette$',
            '^awk-rgb-test$',
            '^colortest(-slim)?$',
            '^colorbars$',
            '^colorview$',
            '^colorwheel$',
            '^(A{6}|O{6})$',
            '^nerd-font-(glyphs|test)$',
            '^rgb-spectrum$',
            '^RGB-Wave(-Shifted)?$',
            '^spectrum(-flames)?$',
            '^terminal-benchmark$',
            '^text-styles$',
            '^unicode-showcase$',
            '^gradient-test$'
        )
    }
    [pscustomobject]@{
        Category = 'TerminalThemes'
        Tags     = @('Terminal', 'Theme')
        Patterns = @('^terminal($|-.*)')
    }
    [pscustomobject]@{
        Category = 'Logos'
        Tags     = @('Logo')
        Patterns = @('arch', 'debian', 'manjaro', 'kaisen', 'tux', 'xmonad', 'suckless', 'android', 'apple', 'windows', 'ubuntu', 'pinguco', 'crunchbang', 'amiga')
    }
    [pscustomobject]@{
        Category = 'Gaming'
        Tags     = @('Gaming', 'PopCulture')
        Patterns = @('doom', 'pacman', 'space-invaders', 'tiefighter', 'rally-x', 'tanks', 'guns', 'pukeskull', 'rupees', 'unowns', 'jangofett', 'darthvader')
    }
    [pscustomobject]@{
        Category = 'ASCIIArt'
        Tags     = @('ASCIIArt')
        Patterns = @('cats', 'crabs', 'crowns', 'elfman', 'faces', '^hearts[0-9]*$', 'kevin-woods', 'monster', '^mouseface', 'pinguco', '^thebat', 'thisisfine', '^welcome-', 'ghosts', 'bears', 'hedgehogs', '^tvs$', 'pukeskull')
    }
    [pscustomobject]@{
        Category = 'Physics'
        Tags     = @('Physics')
        Patterns = @('boids', 'cyclone', 'domain', '\bdla\b', '\bdna\b', 'lightning', 'nbody', 'particle', 'perlin', 'plasma', 'sandpile', '\bsdf\b', 'solar-system', 'verlet', 'waveform', 'wavelet', 'wave-interference', 'wave-pattern', 'vector-streams', 'vortex', 'orbit', 'field', 'life', 'langton', 'electrostatic')
    }
    [pscustomobject]@{
        Category = 'Nature'
        Tags     = @('Nature')
        Patterns = @('aurora', 'nebula', 'galaxy', 'forest', 'crystal', 'fern', 'dunes', 'twilight', 'starlit', 'cloud', 'horizon', 'cosmic', 'enchanted')
    }
    [pscustomobject]@{
        Category = 'Mathematical'
        Tags     = @('Mathematical')
        Patterns = @('apollonian', 'barnsley', 'binary-tree', 'clifford', 'fourier', 'fractal', 'hilbert', 'koch', 'lissajous', 'mandelbrot', 'newton', 'penrose', 'pythagorean', 'quasicrystal', 'rossler', 'sierpinski', 'circle-packing', 'lorenz', 'julia', 'lsystem', 'voronoi', 'iso-cubes')
    }
    [pscustomobject]@{
        Category = 'Artistic'
        Tags     = @('Artistic')
        Patterns = @('braid', 'chromatic', 'chrono', 'city', 'ember', 'kaleidoscope', 'mandala', 'mosaic', 'prismatic', 'midnight', 'illumina', 'inkblot', 'pixel', 'sunburst', 'fade', 'starlit', 'twilight', 'rainbow', 'matrix')
    }
    [pscustomobject]@{
        Category = 'Patterns'
        Tags     = @('Pattern')
        Patterns = @('bars?', 'block', 'blok', 'grid', 'maze', 'spiral', 'wave', 'zigzag', 'tile', 'lattice', 'hex', 'ring', 'polygon', 'prism', 'tessell', 'iso', 'quasicrystal', 'rail', 'pane', 'truchet', 'pattern', 'panes', 'rails', 'circle', 'square', 'triangles', 'gradient', 'voronoi', 'radial', '^six$')
    }
)

function Resolve-CachePath {
    param(
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    $expanded = [System.Environment]::ExpandEnvironmentVariables($Path)

    if ($expanded -and $expanded.StartsWith('~')) {
        $homeDirectory = & $script:GetUserProfilePathDelegate
        if (-not $homeDirectory) {
            $homeDirectory = $HOME
        }

        if ($homeDirectory) {
            if ($expanded.Length -eq 1) {
                $expanded = $homeDirectory
            }
            elseif ($expanded.Length -gt 1 -and ($expanded[1] -eq '/' -or $expanded[1] -eq '\\')) {
                $relativeSegment = $expanded.Substring(2)
                $expanded = if ($relativeSegment) {
                    Join-Path -Path $homeDirectory -ChildPath $relativeSegment
                }
                else {
                    $homeDirectory
                }
            }
        }
    }

    $candidate = $expanded

    $qualifier = $null
    try {
        $qualifier = Split-Path -Path $expanded -Qualifier -ErrorAction Stop
    }
    catch {
        $qualifier = $null
    }

    if ($qualifier -and $qualifier -notlike '\\*') {
        $driveName = $qualifier.TrimEnd(':', '\')
        if (-not (Get-PSDrive -Name $driveName -ErrorAction SilentlyContinue)) {
            return $null
        }
    }

    $isRooted = $false
    try {
        $isRooted = & $script:IsPathRootedDelegate $expanded
    }
    catch {
        Write-Verbose "Unable to evaluate rooted state for cache path '$expanded': $($_.Exception.Message)"
        return $null
    }

    if (-not $isRooted) {
        $basePath = $null

        try {
            $basePath = & $script:GetCurrentProviderPathDelegate
        }
        catch {
            $basePath = $null
        }

        if (-not $basePath) {
            try {
                $basePath = & $script:GetCurrentDirectoryDelegate
            }
            catch {
                $basePath = $null
            }
        }

        if (-not $basePath) {
            return $null
        }

        $candidate = Join-Path -Path $basePath -ChildPath $expanded
    }

    try {
        return & $script:GetFullPathDelegate $candidate
    }
    catch {
        Write-Verbose "Unable to resolve cache path '$Path': $($_.Exception.Message)"
        return $null
    }
}

function Reset-ScriptInventoryCache {
    Invoke-ModuleSynchronized $script:InventorySyncRoot {
        $script:ScriptInventory = $null
        $script:ScriptInventoryStamp = $null
        $script:ScriptInventoryInitialized = $false
        $script:ScriptInventoryRecords = $null
    }
}

function Get-ColorScriptInventory {
    param(
        [switch]$Raw
    )

    if ($script:ScriptInventoryInitialized -and $script:ScriptInventory) {
        if ($Raw) {
            return $script:ScriptInventory
        }

        if (-not $script:ScriptInventoryRecords) {
            $script:ScriptInventoryRecords = @(
                foreach ($file in $script:ScriptInventory) {
                    [pscustomobject]@{
                        Name        = $file.BaseName
                        Path        = $file.FullName
                        Category    = $null
                        Categories  = @()
                        Tags        = @()
                        Description = $null
                        Metadata    = $null
                    }
                }
            )
        }

        return $script:ScriptInventoryRecords
    }

    $result = Invoke-ModuleSynchronized $script:InventorySyncRoot {
        if ($script:ScriptInventoryInitialized -and $script:ScriptInventory) {
            if ($Raw) {
                return $script:ScriptInventory
            }

            if (-not $script:ScriptInventoryRecords) {
                $script:ScriptInventoryRecords = @(
                    foreach ($file in $script:ScriptInventory) {
                        [pscustomobject]@{
                            Name        = $file.BaseName
                            Path        = $file.FullName
                            Category    = $null
                            Categories  = @()
                            Tags        = @()
                            Description = $null
                            Metadata    = $null
                        }
                    }
                )
            }

            if ($Raw) {
                return $script:ScriptInventory
            }

            return $script:ScriptInventoryRecords
        }

        $currentStamp = $null
        try {
            $currentStamp = & $script:DirectoryGetLastWriteTimeUtcDelegate $script:ScriptsPath
            if ($currentStamp -eq [datetime]::MinValue) {
                $currentStamp = $null
            }
        }
        catch {
            $currentStamp = $null
        }

        $shouldRefresh = -not $script:ScriptInventoryInitialized
        if (-not $shouldRefresh -and $null -ne $script:ScriptInventoryStamp) {
            if ($currentStamp -ne $script:ScriptInventoryStamp) {
                $shouldRefresh = $true
            }
        }
        elseif (-not $shouldRefresh -and $null -eq $script:ScriptInventoryStamp -and $currentStamp) {
            $shouldRefresh = $true
        }

        if ($shouldRefresh) {
            $scriptFiles = @()
            try {
                $scriptFiles = Get-ChildItem -Path $script:ScriptsPath -Filter '*.ps1' -File -ErrorAction Stop
            }
            catch {
                $scriptFiles = @()
            }

            $script:ScriptInventory = @($scriptFiles)
            $script:ScriptInventoryRecords = @(
                foreach ($file in $scriptFiles) {
                    [pscustomobject]@{
                        Name        = $file.BaseName
                        Path        = $file.FullName
                        Category    = $null
                        Categories  = @()
                        Tags        = @()
                        Description = $null
                        Metadata    = $null
                    }
                }
            )
            $script:ScriptInventoryStamp = $currentStamp
            $script:ScriptInventoryInitialized = $true
        }

        if ($Raw) {
            return $script:ScriptInventory
        }

        if (-not $script:ScriptInventoryRecords) {
            $script:ScriptInventoryRecords = @(
                foreach ($file in $script:ScriptInventory) {
                    [pscustomobject]@{
                        Name        = $file.BaseName
                        Path        = $file.FullName
                        Category    = $null
                        Categories  = @()
                        Tags        = @()
                        Description = $null
                        Metadata    = $null
                    }
                }
            )
        }

        return $script:ScriptInventoryRecords
    }

    return $result
}

function Test-ColorScriptTextEmission {
    param(
        [bool]$ReturnText,
        [bool]$PassThru,
        [int]$PipelineLength,
        [System.Collections.IDictionary]$BoundParameters
    )

    $isRedirected = $false
    try {
        if ($script:IsOutputRedirectedDelegate) {
            $isRedirected = & $script:IsOutputRedirectedDelegate
        }
        else {
            $isRedirected = [Console]::IsOutputRedirected
        }
    }
    catch {
        $isRedirected = $false
    }

    if ($ReturnText) {
        return $true
    }

    if ($PassThru) {
        return $isRedirected
    }

    if ($PipelineLength -gt 1) {
        return $true
    }

    if ($BoundParameters -and ($BoundParameters.ContainsKey('OutVariable') -or $BoundParameters.ContainsKey('PipelineVariable'))) {
        return $true
    }

    if ($PipelineLength -gt 0) {
        return $isRedirected
    }

    return $isRedirected
}

function Get-PowerShellExecutable {
    if (-not $script:PowerShellExecutable) {
        $candidate = Get-Command -Name pwsh -ErrorAction SilentlyContinue
        if ($candidate -and $candidate.Path) {
            $script:PowerShellExecutable = $candidate.Path
        }
        else {
            try {
                $process = & $script:GetCurrentProcessDelegate
                $module = if ($process) { $process.MainModule } else { $null }
                if ($module -and $module.FileName) {
                    $script:PowerShellExecutable = $module.FileName
                }
                else {
                    throw [System.InvalidOperationException]::new('Process module unavailable.')
                }
            }
            catch {
                $script:PowerShellExecutable = [System.Environment]::GetCommandLineArgs()[0]
            }
        }
    }

    return $script:PowerShellExecutable
}

function Invoke-WithUtf8Encoding {
    param(
        [scriptblock]$ScriptBlock,
        [object[]]$Arguments
    )

    $originalEncoding = $null
    $encodingChanged = $false

    if (-not (& $script:IsOutputRedirectedDelegate)) {
        try {
            $originalEncoding = & $script:GetConsoleOutputEncodingDelegate
            if ($originalEncoding -and $originalEncoding.WebName -ne 'utf-8') {
                & $script:SetConsoleOutputEncodingDelegate ([System.Text.Encoding]::UTF8)
                $encodingChanged = $true
            }
        }
        catch [System.IO.IOException] {
            $originalEncoding = $null
            $encodingChanged = $false
            Write-Verbose 'Console handle unavailable; skipping OutputEncoding change.'
        }
    }

    try {
        if ($Arguments) {
            return & $ScriptBlock @Arguments
        }

        return & $ScriptBlock
    }
    finally {
        if ($encodingChanged -and $originalEncoding) {
            try {
                & $script:SetConsoleOutputEncodingDelegate $originalEncoding
            }
            catch [System.IO.IOException] {
                Write-Verbose 'Console handle unavailable; unable to restore OutputEncoding.'
            }
        }
    }
}

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

function Initialize-CacheDirectory {
    if ($script:CacheInitialized -and $script:CacheDir) {
        return
    }

    Invoke-ModuleSynchronized $script:CacheSyncRoot {
        if ($script:CacheInitialized -and $script:CacheDir) {
            return
        }

        Initialize-Configuration

        $overrideCacheRoot = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
        $resolvedOverride = $null

        if ($overrideCacheRoot) {
            $resolvedOverride = Resolve-CachePath -Path $overrideCacheRoot
            if (-not $resolvedOverride) {
                Write-Verbose "Ignoring COLOR_SCRIPTS_ENHANCED_CACHE_PATH override '$overrideCacheRoot' because the path could not be resolved."
            }
        }

        $candidatePaths = @()

        if ($resolvedOverride) {
            $candidatePaths += $resolvedOverride
        }

        $configData = $script:ConfigurationData
        if ($configData -and $configData.Cache -and $configData.Cache.Path) {
            $configuredPath = Resolve-CachePath -Path $configData.Cache.Path
            if ($configuredPath) {
                $candidatePaths += $configuredPath
            }
            else {
                Write-Warning ($script:Messages.ConfiguredCachePathInvalid -f $configData.Cache.Path)
            }
        }

        if ($script:IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
            if ($env:APPDATA) {
                $windowsBase = Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced'
                $candidatePaths += (Join-Path -Path $windowsBase -ChildPath 'cache')
            }
        }
        elseif ($script:IsMacOS) {
            $macBase = Join-Path -Path $HOME -ChildPath 'Library'
            $macBase = Join-Path -Path $macBase -ChildPath 'Application Support'
            $macBase = Join-Path -Path $macBase -ChildPath 'ColorScripts-Enhanced'
            $candidatePaths += (Join-Path -Path $macBase -ChildPath 'cache')
        }
        else {
            $xdgCache = if ($env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME } else { Join-Path -Path $HOME -ChildPath '.cache' }
            if ($xdgCache) {
                $candidatePaths += (Join-Path -Path $xdgCache -ChildPath 'ColorScripts-Enhanced')
            }
        }

        $candidatePaths = $candidatePaths | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

        foreach ($candidate in $candidatePaths) {
            $target = Resolve-CachePath -Path $candidate
            if (-not $target) {
                Write-Verbose "Skipping cache candidate '$candidate' because it could not be resolved."
                continue
            }

            try {
                if (-not (Test-Path -LiteralPath $target)) {
                    New-Item -ItemType Directory -Path $target -Force -ErrorAction Stop | Out-Null
                }

                try {
                    $resolvedPhysicalPath = (Resolve-Path -LiteralPath $target -ErrorAction Stop).ProviderPath
                }
                catch {
                    $resolvedPhysicalPath = $target
                }

                $script:CacheDir = $resolvedPhysicalPath
                $script:CacheInitialized = $true
                return
            }
            catch {
                Write-Warning ($script:Messages.UnableToPrepareCacheDirectory -f $target, $_.Exception.Message)
            }
        }

        $fallback = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ColorScripts-Enhanced'
        if (-not (Test-Path -LiteralPath $fallback)) {
            New-Item -ItemType Directory -Path $fallback -Force -ErrorAction Stop | Out-Null
        }

        try {
            $resolvedFallback = (Resolve-Path -LiteralPath $fallback -ErrorAction Stop).ProviderPath
        }
        catch {
            $resolvedFallback = $fallback
        }

        $script:CacheDir = $resolvedFallback
        $script:CacheInitialized = $true
    }
}

function New-NameMatcherSet {
    param(
        [string[]]$Patterns
    )

    $matchers = New-Object 'System.Collections.Generic.List[object]'

    if (-not $Patterns) {
        return $matchers.ToArray()
    }

    foreach ($pattern in $Patterns) {
        if ([string]::IsNullOrWhiteSpace($pattern)) {
            continue
        }

        $hasWildcard = [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($pattern)
        if ($hasWildcard) {
            $wildcard = New-Object System.Management.Automation.WildcardPattern ($pattern, [System.Management.Automation.WildcardOptions]::IgnoreCase)
            $null = $matchers.Add(
                [pscustomobject]@{
                    Pattern    = $pattern
                    Matcher    = $wildcard
                    IsWildcard = $true
                    Matched    = $false
                    Matches    = New-Object 'System.Collections.Generic.List[string]'
                }
            )
        }
        else {
            $null = $matchers.Add(
                [pscustomobject]@{
                    Pattern    = $pattern
                    Matcher    = $pattern
                    IsWildcard = $false
                    Matched    = $false
                    Matches    = New-Object 'System.Collections.Generic.List[string]'
                }
            )
        }
    }

    return $matchers.ToArray()
}

function Select-RecordsByName {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IEnumerable]$Records,

        [string[]]$Name
    )

    $recordList = New-Object 'System.Collections.Generic.List[object]'
    foreach ($record in $Records) {
        $null = $recordList.Add($record)
    }

    $selectedNames = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

    if (-not $Name -or $Name.Count -eq 0) {
        return [pscustomobject]@{
            Records         = $recordList.ToArray()
            MissingPatterns = @()
        }
    }

    $matchers = New-NameMatcherSet -Patterns $Name
    if (-not $matchers -or $matchers.Count -eq 0) {
        return [pscustomobject]@{
            Records         = @()
            MissingPatterns = @()
        }
    }

    $selected = New-Object 'System.Collections.Generic.List[object]'

    foreach ($record in $recordList) {
        if (-not ($record.PSObject.Properties.Name -contains 'Name')) {
            continue
        }

        $candidateName = [string]$record.Name
        $recordMatched = $false

        foreach ($matcher in $matchers) {
            $isMatch = if ($matcher.IsWildcard) {
                $matcher.Matcher.IsMatch($candidateName)
            }
            else {
                [System.String]::Equals($candidateName, [string]$matcher.Matcher, [System.StringComparison]::OrdinalIgnoreCase)
            }

            if ($isMatch) {
                $matcher.Matched = $true
                if (-not $matcher.Matches.Contains($candidateName)) {
                    $null = $matcher.Matches.Add($candidateName)
                }
                $recordMatched = $true
            }
        }

        if ($recordMatched) {
            if ($selectedNames.Add($candidateName)) {
                $null = $selected.Add($record)
            }
        }
    }

    $missing = $matchers | Where-Object { -not $_.Matched } | ForEach-Object { $_.Pattern }

    $matchMap = $matchers | ForEach-Object {
        [pscustomobject]@{
            Pattern    = $_.Pattern
            IsWildcard = $_.IsWildcard
            Matched    = $_.Matched
            Matches    = $_.Matches.ToArray()
        }
    }

    return [pscustomobject]@{
        Records         = $selected.ToArray()
        MissingPatterns = [string[]]$missing
        MatchMap        = $matchMap
    }
}

function Get-ColorScriptMetadataTableInternal {
    $currentTimestamp = $null
    if (Test-Path $script:MetadataPath) {
        try {
            $currentTimestamp = (Get-Item -LiteralPath $script:MetadataPath).LastWriteTimeUtc
        }
        catch {
            Write-Verbose "Unable to determine metadata timestamp: $($_.Exception.Message)"
        }
    }

    if ($script:MetadataCache -and $script:MetadataLastWriteTime -and $currentTimestamp -eq $script:MetadataLastWriteTime) {
        return $script:MetadataCache
    }

    $binaryCachePath = $null
    if ($script:CacheInitialized -and $script:CacheDir) {
        $binaryCachePath = Join-Path -Path $script:CacheDir -ChildPath 'metadata.cache.json'

        if ($binaryCachePath -and (Test-Path -LiteralPath $binaryCachePath)) {
            try {
                $cacheFileInfo = Get-Item -LiteralPath $binaryCachePath -ErrorAction Stop
                if ($cacheFileInfo.LastWriteTimeUtc -ge $currentTimestamp) {
                    $jsonData = Get-Content -LiteralPath $binaryCachePath -Raw -ErrorAction Stop
                    $cachedHash = ConvertFrom-JsonToHashtable -InputObject $jsonData

                    $loadedStore = New-Object 'System.Collections.Generic.Dictionary[string, object]' ([System.StringComparer]::OrdinalIgnoreCase)
                    foreach ($key in $cachedHash.Keys) {
                        $loadedStore[$key] = $cachedHash[$key]
                    }

                    $script:MetadataCache = $loadedStore
                    $script:MetadataLastWriteTime = $currentTimestamp
                    Write-Verbose 'Loaded metadata from JSON cache (fast path)'
                    return $script:MetadataCache
                }
            }
            catch {
                Write-Verbose "JSON metadata cache load failed, will rebuild: $($_.Exception.Message)"
            }
        }
    }

    $store = New-Object 'System.Collections.Generic.Dictionary[string, object]' ([System.StringComparer]::OrdinalIgnoreCase)

    $mergeUnique = {
        param(
            [string[]]$existing,
            [string[]]$additional
        )

        $set = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
        $list = New-Object 'System.Collections.Generic.List[string]'

        if ($existing) {
            foreach ($value in $existing) {
                if ([string]::IsNullOrWhiteSpace($value)) { continue }
                if ($set.Add($value)) { $null = $list.Add($value) }
            }
        }

        if ($additional) {
            foreach ($value in $additional) {
                if ([string]::IsNullOrWhiteSpace($value)) { continue }
                if ($set.Add($value)) { $null = $list.Add($value) }
            }
        }

        return $list.ToArray()
    }

    $data = $null

    if (Test-Path $script:MetadataPath) {
        $data = Import-PowerShellDataFile -Path $script:MetadataPath

        if ($data -is [hashtable]) {
            $internal = New-Object 'System.Collections.Generic.Dictionary[string, hashtable]' ([System.StringComparer]::OrdinalIgnoreCase)

            $ensureEntry = {
                param($map, $name)

                if (-not $map.ContainsKey($name)) {
                    $map[$name] = @{
                        Category    = $null
                        Categories  = New-Object 'System.Collections.Generic.List[string]'
                        Tags        = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
                        Description = $null
                    }
                }

                return $map[$name]
            }

            if ($data.Categories -is [hashtable]) {
                foreach ($categoryName in $data.Categories.Keys) {
                    $scriptsForCategory = $data.Categories[$categoryName]
                    foreach ($scriptName in $scriptsForCategory) {
                        $entry = & $ensureEntry $internal $scriptName
                        if (-not $entry.Categories.Contains($categoryName)) {
                            $null = $entry.Categories.Add($categoryName)
                        }
                        if (-not $entry.Tags.Contains("Category:$categoryName")) {
                            $null = $entry.Tags.Add("Category:$categoryName")
                        }
                        if (-not $entry.Category) {
                            $entry.Category = $categoryName
                        }
                    }
                }
            }

            if ($data.Difficulty -is [hashtable]) {
                foreach ($difficultyLevel in $data.Difficulty.Keys) {
                    foreach ($scriptName in $data.Difficulty[$difficultyLevel]) {
                        $entry = & $ensureEntry $internal $scriptName
                        $tag = "Difficulty:$difficultyLevel"
                        if (-not $entry.Tags.Contains($tag)) {
                            $null = $entry.Tags.Add($tag)
                        }
                    }
                }
            }

            if ($data.Complexity -is [hashtable]) {
                foreach ($complexityLevel in $data.Complexity.Keys) {
                    foreach ($scriptName in $data.Complexity[$complexityLevel]) {
                        $entry = & $ensureEntry $internal $scriptName
                        $tag = "Complexity:$complexityLevel"
                        if (-not $entry.Tags.Contains($tag)) {
                            $null = $entry.Tags.Add($tag)
                        }
                    }
                }
            }

            if ($data.Recommended -is [System.Collections.IEnumerable]) {
                foreach ($scriptName in $data.Recommended) {
                    $entry = & $ensureEntry $internal $scriptName
                    if (-not $entry.Tags.Contains('Recommended')) {
                        $null = $entry.Tags.Add('Recommended')
                    }
                }
            }

            if ($data.Tags -is [hashtable]) {
                foreach ($taggedScript in $data.Tags.Keys) {
                    $entry = & $ensureEntry $internal $taggedScript
                    $tagsForScript = $data.Tags[$taggedScript]

                    if ($tagsForScript -is [System.Collections.IEnumerable] -and $tagsForScript -isnot [string]) {
                        foreach ($tagValue in $tagsForScript) {
                            $tagText = [string]$tagValue
                            if (-not [string]::IsNullOrWhiteSpace($tagText) -and -not $entry.Tags.Contains($tagText)) {
                                $null = $entry.Tags.Add($tagText)
                            }
                        }
                    }
                    elseif ($tagsForScript) {
                        $tagText = [string]$tagsForScript
                        if (-not [string]::IsNullOrWhiteSpace($tagText) -and -not $entry.Tags.Contains($tagText)) {
                            $null = $entry.Tags.Add($tagText)
                        }
                    }
                }
            }

            if ($data.Descriptions -is [hashtable]) {
                foreach ($describedScript in $data.Descriptions.Keys) {
                    $entry = & $ensureEntry $internal $describedScript
                    $descriptionText = $data.Descriptions[$describedScript]
                    if ($null -ne $descriptionText -and -not [string]::IsNullOrWhiteSpace([string]$descriptionText)) {
                        $entry.Description = [string]$descriptionText
                    }
                }
            }

            foreach ($key in $internal.Keys) {
                $value = $internal[$key]
                $categoryValue = if ($value.Category) { $value.Category } else { 'Uncategorized' }

                $categoriesValue = @()
                if ($value.Categories -is [System.Collections.IEnumerable] -and $value.Categories -isnot [string]) {
                    $categoriesValue = @($value.Categories | ForEach-Object { [string]$_ })
                }
                elseif ($value.Categories) {
                    $categoriesValue = @([string]$value.Categories)
                }

                $tagsValue = @()
                if ($value.Tags -is [System.Collections.IEnumerable] -and $value.Tags -isnot [string]) {
                    $tagsValue = @($value.Tags | ForEach-Object { [string]$_ })
                }
                elseif ($value.Tags) {
                    $tagsValue = @([string]$value.Tags)
                }

                $store[$key] = [pscustomobject]@{
                    Category    = $categoryValue
                    Categories  = $categoriesValue
                    Tags        = $tagsValue
                    Description = $value.Description
                }
            }
        }
    }

    $autoRules = @()

    if ($data -is [hashtable] -and $data.ContainsKey('AutoCategories') -and $data.AutoCategories -is [System.Collections.IEnumerable]) {
        foreach ($rule in $data.AutoCategories) {
            $categoryName = $rule.Category
            if ([string]::IsNullOrWhiteSpace($categoryName)) {
                continue
            }

            $patterns = @()
            if ($rule.Patterns -is [System.Collections.IEnumerable]) {
                foreach ($pattern in $rule.Patterns) {
                    $patternValue = [string]$pattern
                    if (-not [string]::IsNullOrWhiteSpace($patternValue)) {
                        $patterns += $patternValue
                    }
                }
            }
            elseif ($rule.Patterns) {
                $patternValue = [string]$rule.Patterns
                if (-not [string]::IsNullOrWhiteSpace($patternValue)) {
                    $patterns += $patternValue
                }
            }

            if ($patterns.Count -eq 0) {
                continue
            }

            $tags = @()
            if ($rule.Tags -is [System.Collections.IEnumerable]) {
                foreach ($tag in $rule.Tags) {
                    $tagValue = [string]$tag
                    if (-not [string]::IsNullOrWhiteSpace($tagValue)) {
                        $tags += $tagValue
                    }
                }
            }
            elseif ($rule.Tags) {
                $tagValue = [string]$rule.Tags
                if (-not [string]::IsNullOrWhiteSpace($tagValue)) {
                    $tags += $tagValue
                }
            }

            $autoRules += [pscustomobject]@{
                Category = [string]$categoryName
                Patterns = $patterns
                Tags     = $tags
            }
        }
    }

    if ($autoRules.Count -eq 0) {
        $autoRules = $script:DefaultAutoCategoryRules
    }

    $resolveAutoCategory = {
        param([string]$Name)

        $matchedCategories = New-Object 'System.Collections.Generic.List[string]'
        $matchedTags = New-Object 'System.Collections.Generic.List[string]'

        foreach ($rule in $autoRules) {
            $patterns = @()
            if ($rule.Patterns -is [System.Collections.IEnumerable]) {
                $patterns = $rule.Patterns
            }
            elseif ($rule.Patterns) {
                $patterns = @($rule.Patterns)
            }

            foreach ($pattern in $patterns) {
                $patternValue = [string]$pattern
                if ([string]::IsNullOrWhiteSpace($patternValue)) { continue }
                if ([System.Text.RegularExpressions.Regex]::IsMatch($Name, $patternValue, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
                    if (-not $matchedCategories.Contains($rule.Category)) {
                        $null = $matchedCategories.Add([string]$rule.Category)
                    }

                    if ($rule.Tags -is [System.Collections.IEnumerable]) {
                        foreach ($tag in $rule.Tags) {
                            $tagValue = [string]$tag
                            if (-not [string]::IsNullOrWhiteSpace($tagValue) -and -not $matchedTags.Contains($tagValue)) {
                                $null = $matchedTags.Add($tagValue)
                            }
                        }
                    }
                    elseif ($rule.Tags) {
                        $tagValue = [string]$rule.Tags
                        if (-not [string]::IsNullOrWhiteSpace($tagValue) -and -not $matchedTags.Contains($tagValue)) {
                            $null = $matchedTags.Add($tagValue)
                        }
                    }

                    break
                }
            }
        }

        if ($matchedCategories.Count -eq 0) {
            $null = $matchedCategories.Add('Abstract')
        }

        [pscustomobject]@{
            Categories = [string[]]$matchedCategories.ToArray()
            Tags       = [string[]]$matchedTags.ToArray()
        }
    }

    $scripts = Get-ColorScriptInventory -Raw

    foreach ($scriptFile in $scripts) {
        $name = $scriptFile.BaseName
        $entryExists = $store.ContainsKey($name)
        $existingEntry = if ($entryExists) {
            $store[$name]
        }
        else {
            [pscustomobject]@{
                Category    = 'Uncategorized'
                Categories  = @()
                Tags        = @()
                Description = $null
            }
        }

        $needsAuto = -not $entryExists -or [string]::IsNullOrWhiteSpace($existingEntry.Category) -or $existingEntry.Category -eq 'Uncategorized'

        if ($needsAuto) {
            $autoInfo = & $resolveAutoCategory $name
            $autoCategories = if ($autoInfo.Categories) { [string[]]$autoInfo.Categories } else { @('Abstract') }
            $autoTags = if ($autoInfo.Tags) { [string[]]$autoInfo.Tags } else { @() }

            $baseCategories = @()
            if ($existingEntry.Category -and $existingEntry.Category -ne 'Uncategorized') {
                $baseCategories += [string]$existingEntry.Category
            }
            if ($existingEntry.Categories) {
                foreach ($cat in [string[]]$existingEntry.Categories) {
                    if (-not [string]::IsNullOrWhiteSpace($cat) -and $cat -ne 'Uncategorized') {
                        $baseCategories += $cat
                    }
                }
            }

            $categories = [string[]](& $mergeUnique $baseCategories $autoCategories)
            if (-not $categories -or $categories.Length -eq 0) {
                $categories = @('Abstract')
            }

            $newCategory = if ($existingEntry.Category -and $existingEntry.Category -ne 'Uncategorized') { [string]$existingEntry.Category } else { $categories[0] }

            $existingTags = @()
            if ($existingEntry.Tags) {
                $existingTags = [string[]]$existingEntry.Tags
            }

            $autoTagList = @()
            if ($autoTags) { $autoTagList += $autoTags }
            $autoTagList += ($categories | ForEach-Object { "Category:$($_)" })
            $autoTagList += 'AutoCategorized'

            $tags = [string[]](& $mergeUnique $existingTags $autoTagList)

            $store[$name] = [pscustomobject]@{
                Category    = $newCategory
                Categories  = $categories
                Tags        = $tags
                Description = $existingEntry.Description
            }
        }
    }

    foreach ($key in @($store.Keys)) {
        $entry = $store[$key]

        $baseCategories = @()
        if ($entry.Category -and $entry.Category -ne 'Uncategorized') {
            $baseCategories += [string]$entry.Category
        }
        if ($entry.Categories) {
            foreach ($cat in [string[]]$entry.Categories) {
                if (-not [string]::IsNullOrWhiteSpace($cat)) {
                    $baseCategories += $cat
                }
            }
        }

        if (-not $baseCategories -or $baseCategories.Count -eq 0) {
            $baseCategories = @('Abstract')
        }

        $categories = [string[]](& $mergeUnique @() $baseCategories)
        if (-not $categories -or $categories.Length -eq 0) {
            $categories = @('Abstract')
        }

        $existingTags = @()
        if ($entry.Tags) {
            $existingTags = [string[]]$entry.Tags
        }

        $categoryTags = $categories | ForEach-Object { "Category:$($_)" }
        $tags = [string[]](& $mergeUnique $existingTags $categoryTags)

        $store[$key] = [pscustomobject]@{
            Category    = $categories[0]
            Categories  = $categories
            Tags        = $tags
            Description = $entry.Description
        }
    }

    $script:MetadataCache = $store
    $script:MetadataLastWriteTime = $currentTimestamp

    if ($binaryCachePath) {
        try {
            $jsonData = $store | ConvertTo-Json -Depth 10 -Compress
            Set-Content -Path $binaryCachePath -Value $jsonData -Encoding UTF8 -ErrorAction Stop
            Write-Verbose 'Saved metadata to JSON cache for faster future loads'
        }
        catch {
            Write-Verbose "Failed to save JSON metadata cache: $($_.Exception.Message)"
        }
    }

    return $script:MetadataCache
}

function Get-ColorScriptMetadataTable {
    Invoke-ModuleSynchronized $script:MetadataSyncRoot {
        Get-ColorScriptMetadataTableInternal
    }
}

function Get-ColorScriptEntry {
    param(
        [SupportsWildcards()]
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowWildcard })]
        [string[]]$Name,
        [string[]]$Category,
        [string[]]$Tag
    )

    $metadata = Get-ColorScriptMetadataTable
    $scripts = Get-ColorScriptInventory -Raw

    $records = foreach ($script in $scripts) {
        $entry = if ($metadata.ContainsKey($script.BaseName)) { $metadata[$script.BaseName] } else { $null }

        if (-not $entry) {
            $entry = [pscustomobject]@{
                Category    = 'Abstract'
                Categories  = @('Abstract')
                Tags        = @('Category:Abstract', 'AutoCategorized')
                Description = $null
            }
        }

        $categoryValue = if ($entry.PSObject.Properties.Name -contains 'Category' -and $entry.Category) { [string]$entry.Category } else { 'Abstract' }
        $categoriesValue = if ($entry.PSObject.Properties.Name -contains 'Categories') { [string[]]$entry.Categories } else { @() }
        if (-not $categoriesValue -or $categoriesValue.Count -eq 0) {
            $categoriesValue = @($categoryValue)
        }

        $tagsValue = if ($entry.PSObject.Properties.Name -contains 'Tags') { [string[]]$entry.Tags } else { @() }
        if (-not $tagsValue -or $tagsValue.Count -eq 0) {
            $tagsValue = @("Category:$categoryValue")
        }
        $descriptionValue = if ($entry.PSObject.Properties.Name -contains 'Description') { [string]$entry.Description } else { $null }

        [pscustomobject]@{
            Name        = $script.BaseName
            Path        = $script.FullName
            Category    = $categoryValue
            Categories  = $categoriesValue
            Tags        = $tagsValue
            Description = $descriptionValue
            Metadata    = $entry
        }
    }

    if ($Name) {
        $selection = Select-RecordsByName -Records $records -Name $Name
        $records = $selection.Records
    }

    if ($Category) {
        $categorySet = $Category | ForEach-Object { $_.ToLowerInvariant() }
        $records = $records | Where-Object {
            $recordCategories = @($_.Category) + $_.Categories
            $recordCategories = $recordCategories | Where-Object { $_ } | ForEach-Object { $_.ToLowerInvariant() }
            $match = $false
            foreach ($categoryValue in $recordCategories) {
                if ($categorySet -contains $categoryValue) {
                    $match = $true
                    break
                }
            }
            $match
        }
    }

    if ($Tag) {
        $tagSet = $Tag | ForEach-Object { $_.ToLowerInvariant() }
        $records = $records | Where-Object {
            $recordTags = $_.Tags | ForEach-Object { $_.ToLowerInvariant() }
            $match = $false
            foreach ($tagValue in $recordTags) {
                if ($tagSet -contains $tagValue) {
                    $match = $true
                    break
                }
            }
            $match
        }
    }

    return [pscustomobject[]]$records
}

function Get-CachedOutput {
    <#
    .SYNOPSIS
        Retrieves cached output for a colorscript if available and valid.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path -Path $script:CacheDir -ChildPath ('{0}.cache' -f $scriptName)

    try {
        $scriptFileExists = $false
        try {
            $scriptFileExists = & $script:FileExistsDelegate $ScriptPath
        }
        catch {
            Write-Verbose "Unable to verify script existence for ${ScriptPath}: $($_.Exception.Message)"
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $null
                Content       = ''
                LastWriteTime = $null
            }
        }

        if (-not $scriptFileExists) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $null
                Content       = ''
                LastWriteTime = $null
            }
        }

        if (-not (Test-Path -LiteralPath $cacheFile)) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $null
            }
        }

        $scriptLastWrite = & $script:FileGetLastWriteTimeUtcDelegate $ScriptPath
        $cacheLastWrite = & $script:FileGetLastWriteTimeUtcDelegate $cacheFile

        if ($scriptLastWrite -gt $cacheLastWrite) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $cacheLastWrite
            }
        }

        $content = & $script:FileReadAllTextDelegate $cacheFile $script:Utf8NoBomEncoding

        return [pscustomobject]@{
            Available     = $true
            CacheFile     = $cacheFile
            Content       = $content
            LastWriteTime = $cacheLastWrite
        }
    }
    catch {
        Write-Verbose "Cache read error for $ScriptPath : $($_.Exception.Message)"
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $cacheFile
            Content       = ''
            LastWriteTime = $null
        }
    }
}

function Invoke-ColorScriptProcess {
    <#
    .SYNOPSIS
        Executes a colorscript and captures its output.
        For cache building, uses fast in-process execution.
        For display, can use isolated process if needed.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath,

        [switch]$ForCache
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)

    $result = [pscustomobject]@{
        ScriptName = $scriptName
        StdOut     = ''
        StdErr     = ''
        ExitCode   = $null
        Success    = $false
    }

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        $result.StdErr = $script:Messages.ScriptPathNotFound
        return $result
    }

    # Fast in-process execution for cache building
    if ($ForCache) {
        try {
            $oldLocation = Get-Location
            $scriptDirectory = [System.IO.Path]::GetDirectoryName($ScriptPath)
            if ($scriptDirectory) {
                Set-Location -LiteralPath $scriptDirectory -ErrorAction SilentlyContinue
            }

            $scriptContent = & $script:FileReadAllTextDelegate $ScriptPath $script:Utf8NoBomEncoding
            $scriptBlock = [ScriptBlock]::Create($scriptContent)

            $output = & $scriptBlock 2>&1 | Out-String

            $result.StdOut = $output
            $result.ExitCode = 0
            $result.Success = $true
        }
        catch {
            $result.StdErr = $_.Exception.Message
            $result.ExitCode = 1
            $result.Success = $false
        }
        finally {
            if ($oldLocation) {
                Set-Location -LiteralPath $oldLocation -ErrorAction SilentlyContinue
            }
        }

        return $result
    }

    # Original isolated process execution for display
    $executable = Get-PowerShellExecutable
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($ScriptPath)
    $process = $null

    try {
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = $executable

        $escapedScriptPath = $ScriptPath.Replace("'", "''")
        $escapedScriptDir = if ($scriptDirectory) { $scriptDirectory.Replace("'", "''") } else { $null }
        $commandBuilder = New-Object System.Text.StringBuilder
        $null = $commandBuilder.Append('[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; ')
        if ($escapedScriptDir) {
            $null = $commandBuilder.Append("Set-Location -LiteralPath '$escapedScriptDir'; ")
        }
        $null = $commandBuilder.Append("& ([ScriptBlock]::Create([System.IO.File]::ReadAllText('$escapedScriptPath', [System.Text.Encoding]::UTF8)))")

        $encodedCommand = $commandBuilder.ToString()
        $startInfo.Arguments = "-NoProfile -NonInteractive -Command `"$encodedCommand`""
        $startInfo.UseShellExecute = $false
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
        $startInfo.StandardErrorEncoding = [System.Text.Encoding]::UTF8

        if ($scriptDirectory) {
            $startInfo.WorkingDirectory = $scriptDirectory
        }

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $null = $process.Start()

        $output = $process.StandardOutput.ReadToEnd()
        $errorOutput = $process.StandardError.ReadToEnd()
        $process.WaitForExit()

        $result.ExitCode = $process.ExitCode
        $result.StdOut = $output
        $result.StdErr = $errorOutput
        $result.Success = ($process.ExitCode -eq 0)
    }
    catch {
        $result.StdErr = $_.Exception.Message
    }
    finally {
        if ($process) {
            $process.Dispose()
        }
    }

    return $result
}

function Build-ScriptCache {
    <#
    .SYNOPSIS
        Builds cache for a specific colorscript.

        The full path to the colorscript file.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"

    $result = [pscustomobject]@{
        ScriptName = $scriptName
        CacheFile  = $cacheFile
        Success    = $false
        ExitCode   = $null
        StdOut     = ''
        StdErr     = ''
    }

    if (-not [System.IO.File]::Exists($ScriptPath)) {
        $result.StdErr = $script:Messages.ScriptPathNotFound
        return $result
    }

    $execution = Invoke-ColorScriptProcess -ScriptPath $ScriptPath -ForCache
    $result.ExitCode = $execution.ExitCode
    $result.StdOut = $execution.StdOut
    $result.StdErr = $execution.StdErr

    if ($execution.Success) {
        try {
            Invoke-FileWriteAllText -Path $cacheFile -Content $execution.StdOut -Encoding $script:Utf8NoBomEncoding

            try {
                $scriptLastWrite = Get-FileLastWriteTimeUtc -Path $ScriptPath
                Set-FileLastWriteTimeUtc -Path $cacheFile -Timestamp $scriptLastWrite
            }
            catch {
                $scriptLastWrite = Get-FileLastWriteTime -Path $ScriptPath
                Set-FileLastWriteTime -Path $cacheFile -Timestamp $scriptLastWrite
            }
            $result.Success = $true
        }
        catch {
            $result.StdErr = $_.Exception.Message
        }
    }
    elseif (-not $result.StdErr) {
        $result.StdErr = ($script:Messages.ScriptExitedWithCode -f $execution.ExitCode)
    }

    return $result
}

function Test-ConsoleOutputRedirected {
    try {
        return (& $script:IsOutputRedirectedDelegate)
    }
    catch {
        return $false
    }
}

function Invoke-ColorScriptsStartup {
    try {
        $autoShowOverride = $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT
        $overrideEnabled = $false
        if ($autoShowOverride) {
            $overrideEnabled = $autoShowOverride -match '^(1|true|yes)$'
            if (-not $overrideEnabled) {
                return
            }
        }

        $outputRedirected = $false
        try {
            $outputRedirected = Test-ConsoleOutputRedirected
        }
        catch {
            $outputRedirected = $false
        }

        if (-not $overrideEnabled) {
            if ($env:CI -eq 'true' -or $env:GITHUB_ACTIONS -eq 'true') {
                return
            }

            if ($Host.Name -eq 'ServerRemoteHost') {
                return
            }

            if ($outputRedirected) {
                return
            }
        }
        elseif ($outputRedirected) {
            Write-Verbose 'Console output is redirected; skipping auto-show despite override.'
            return
        }

        $configRoot = $null
        try {
            $configRoot = Get-ColorScriptsConfigurationRoot
        }
        catch {
            Write-Verbose "Unable to locate configuration root: $($_.Exception.Message)"
            if (-not $overrideEnabled) {
                return
            }
        }

        $configPath = if ($configRoot) { Join-Path -Path $configRoot -ChildPath 'config.json' } else { $null }
        if (-not $overrideEnabled -and $configPath -and -not (Test-Path -LiteralPath $configPath)) {
            return
        }

        $configuration = Get-ConfigurationDataInternal
        if (-not $configuration.Startup.AutoShowOnImport -and -not $overrideEnabled) {
            return
        }

        $defaultScript = if ($configuration.Startup.ContainsKey('DefaultScript')) { $configuration.Startup.DefaultScript } else { $null }

        if (-not [string]::IsNullOrWhiteSpace($defaultScript)) {
            Show-ColorScript -Name $defaultScript -ErrorAction SilentlyContinue | Out-Null
        }
        else {
            Show-ColorScript -ErrorAction SilentlyContinue | Out-Null
        }
    }
    catch {
        Write-Verbose "Auto-show on import skipped: $($_.Exception.Message)"
    }
}

#endregion
