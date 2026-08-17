function ConvertTo-ColorScriptProfileResult {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter()][AllowNull()][object]$Path,
        [Parameter(Mandatory)][bool]$Changed,
        [Parameter(Mandatory)][string]$Message,
        [Parameter(Mandatory)][bool]$CacheBuilt
    )

    return [pscustomobject]@{
        Path           = $Path
        Changed        = $Changed
        Message        = $Message
        IncludePokemon = $true
        CacheBuilt     = $CacheBuilt
    }
}

function Test-ColorScriptProfileRemoteSession {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    try {
        return $null -ne (Get-Variable -Name PSSenderInfo -Scope Global -ValueOnly -ErrorAction Stop)
    }
    catch {
        return $false
    }
}

function Get-DefaultColorScriptProfileSpecification {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $profileSpec = $null
    $profileScope = 'CurrentUserAllHosts'
    $profileValue = $PROFILE
    if ($profileValue -is [System.Management.Automation.PSObject]) {
        $allHostsProperty = $profileValue.PSObject.Properties['CurrentUserAllHosts']
        if ($allHostsProperty -and -not [string]::IsNullOrWhiteSpace([string]$profileValue.CurrentUserAllHosts)) {
            $profileSpec = [string]$profileValue.CurrentUserAllHosts
        }
        else {
            $firstDefinedProfile = $profileValue.PSObject.Properties | Where-Object { $_.Value } | Select-Object -First 1
            if ($firstDefinedProfile) {
                $profileSpec = [string]$firstDefinedProfile.Value
                $profileScope = [string]$firstDefinedProfile.Name
            }
        }
    }
    elseif (-not [string]::IsNullOrWhiteSpace([string]$profileValue)) {
        $profileSpec = [string]$profileValue
    }

    return [pscustomobject]@{ Path = $profileSpec; Scope = $profileScope }
}

function Get-ColorScriptProfileBasePath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $basePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('.')
    }
    catch {
        $basePath = $null
    }

    if ($basePath) {
        return $basePath
    }

    try {
        return (Get-Location -PSProvider FileSystem).Path
    }
    catch {
        return $null
    }
}

function Resolve-ColorScriptProfilePath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][System.Management.Automation.PSCmdlet]$Cmdlet
    )

    try {
        $resolvedPath = Resolve-CachePath -Path $Path
    }
    catch {
        $resolvedPath = $null
    }
    if ($resolvedPath) {
        return $resolvedPath
    }

    $invalidForeignDrive = -not $script:IsWindows -and $Path -match '^[A-Za-z]:'
    if ($invalidForeignDrive -or [System.IO.Path]::IsPathRooted($Path)) {
        Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveProfilePath -f $Path) -ErrorId 'ColorScriptsEnhanced.InvalidProfilePath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -Cmdlet $Cmdlet
    }

    try {
        $basePath = Get-ColorScriptProfileBasePath
        return [System.IO.Path]::GetFullPath((Join-Path -Path $basePath -ChildPath $Path))
    }
    catch {
        Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveProfilePath -f $Path) -ErrorId 'ColorScriptsEnhanced.InvalidProfilePath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -Exception $_.Exception -Cmdlet $Cmdlet
    }
}

function Get-ColorScriptProfileContext {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter()][AllowNull()][AllowEmptyString()][string]$ProfilePath,
        [Parameter(Mandatory)][System.Management.Automation.PSCmdlet]$Cmdlet
    )

    $profileScope = 'CurrentUserAllHosts'
    $profileSpec = $ProfilePath
    if (-not $profileSpec) {
        $defaultProfile = Get-DefaultColorScriptProfileSpecification
        $profileSpec = $defaultProfile.Path
        $profileScope = $defaultProfile.Scope
    }

    if ([string]::IsNullOrWhiteSpace($profileSpec)) {
        Invoke-ColorScriptError -Message ($script:Messages.ProfilePathNotDefinedForScope -f $profileScope) -ErrorId 'ColorScriptsEnhanced.ProfilePathUndefined' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -Cmdlet $Cmdlet
    }

    $resolvedPath = Resolve-ColorScriptProfilePath -Path $profileSpec -Cmdlet $Cmdlet
    $content = if (Test-Path -LiteralPath $resolvedPath) {
        # Profiles written by the module are UTF-8 without a BOM. Read explicitly so Windows
        # PowerShell 5.1 does not reinterpret them through the active ANSI code page.
        Get-Content -LiteralPath $resolvedPath -Raw -Encoding UTF8 -ErrorAction Stop
    }
    else {
        ''
    }
    $newline = if ($content -match "`r`n") { "`r`n" } elseif ($content -match "`n") { "`n" } else { [Environment]::NewLine }

    return [pscustomobject]@{
        Path      = $resolvedPath
        Directory = [System.IO.Path]::GetDirectoryName($resolvedPath)
        Content   = $content
        Newline   = $newline
    }
}

function Get-ColorScriptProfileStartupConfiguration {
    [CmdletBinding()]
    [OutputType([object])]
    param()

    try {
        $configuration = Get-ColorScriptConfiguration
    }
    catch {
        Write-Verbose ("Get-ColorScriptConfiguration failed: {0}" -f $_.Exception.Message)
        $configuration = $null
    }

    if ($configuration -and $configuration.Startup) {
        return $configuration.Startup
    }
    if ($script:ConfigurationData -and $script:ConfigurationData.Startup) {
        return $script:ConfigurationData.Startup
    }
    return $script:DefaultConfiguration.Startup
}

function ConvertTo-ColorScriptProfileStartupPreference {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter()][AllowNull()][object]$StartupConfiguration
    )

    $autoShow = $false
    $defaultScript = $null
    if ($StartupConfiguration -is [System.Collections.IDictionary]) {
        if ($StartupConfiguration.Contains('ProfileAutoShow')) {
            $autoShow = [bool]$StartupConfiguration['ProfileAutoShow']
        }
        if ($StartupConfiguration.Contains('DefaultScript')) {
            $defaultScript = [string]$StartupConfiguration['DefaultScript']
        }
    }
    elseif ($StartupConfiguration) {
        if ($StartupConfiguration.PSObject.Properties.Name -contains 'ProfileAutoShow') {
            $autoShow = [bool]$StartupConfiguration.ProfileAutoShow
        }
        if ($StartupConfiguration.PSObject.Properties.Name -contains 'DefaultScript') {
            $defaultScript = [string]$StartupConfiguration.DefaultScript
        }
    }

    return [pscustomobject]@{ AutoShow = $autoShow; DefaultScript = $defaultScript }
}

function Resolve-ColorScriptProfileStartupPreference {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][bool]$AutoShowSpecified,
        [switch]$AutoShow,
        [switch]$SkipStartupScript,
        [Parameter(Mandatory)][bool]$DefaultScriptSpecified,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$DefaultStartupScript
    )

    $preference = ConvertTo-ColorScriptProfileStartupPreference -StartupConfiguration (Get-ColorScriptProfileStartupConfiguration)
    if ($AutoShowSpecified) {
        $preference.AutoShow = [bool]$AutoShow
    }
    if ($SkipStartupScript) {
        $preference.AutoShow = $false
    }
    if ($DefaultScriptSpecified) {
        $preference.DefaultScript = $DefaultStartupScript
        if (-not $SkipStartupScript) {
            $preference.AutoShow = $true
        }
    }

    return $preference
}

function Test-ColorScriptTruthyValue {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter()][AllowNull()][AllowEmptyString()][string]$Value
    )

    return -not [string]::IsNullOrWhiteSpace($Value) -and
        $Value.ToLowerInvariant() -in @('1', 'true', 'yes', 'y')
}

function Test-ColorScriptProfileUnderTempPath {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)][string]$ProfilePath
    )

    try {
        $providerPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProfilePath)
    }
    catch {
        $providerPath = $ProfilePath
    }
    try {
        $profileFullPath = [System.IO.Path]::GetFullPath($providerPath)
    }
    catch {
        $profileFullPath = $providerPath
    }
    try {
        $tempRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
    }
    catch {
        $tempRoot = [System.IO.Path]::GetTempPath()
    }
    if (-not $profileFullPath -or -not $tempRoot) {
        return $false
    }

    try {
        $relative = [System.IO.Path]::GetRelativePath($tempRoot, $profileFullPath)
        return -not [string]::IsNullOrWhiteSpace($relative) -and
            -not $relative.StartsWith('..', [System.StringComparison]::Ordinal)
    }
    catch {
        $normalizedTempRoot = $tempRoot.TrimEnd(
            [System.IO.Path]::DirectorySeparatorChar,
            [System.IO.Path]::AltDirectorySeparatorChar)
        $tempPrefix = $normalizedTempRoot + [System.IO.Path]::DirectorySeparatorChar
        return [string]::Equals($profileFullPath, $normalizedTempRoot, [System.StringComparison]::OrdinalIgnoreCase) -or
            $profileFullPath.StartsWith($tempPrefix, [System.StringComparison]::OrdinalIgnoreCase)
    }
}

function Test-ColorScriptProfileCacheBuildSkipped {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [switch]$SkipCacheBuild,
        [Parameter(Mandatory)][string]$ProfilePath
    )

    if ($SkipCacheBuild -or
        (Test-ColorScriptTruthyValue -Value ([Environment]::GetEnvironmentVariable('COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD')))) {
        return $true
    }

    try {
        if (Get-Variable -Name ColorScriptsEnhancedSkipCacheBuild -Scope Global -ValueOnly -ErrorAction Stop) {
            return $true
        }
    }
    catch {
        Write-Verbose 'Global cache skip override not defined.'
    }

    return Test-ColorScriptProfileUnderTempPath -ProfilePath $ProfilePath
}

function ConvertTo-ColorScriptProfileSnippet {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)][string]$Newline,
        [Parameter(Mandatory)][bool]$AutoShow,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$DefaultScript
    )

    $snippetLines = [System.Collections.Generic.List[string]]::new()
    [void]$snippetLines.Add('# BEGIN ColorScripts-Enhanced managed block')
    [void]$snippetLines.Add("# Added by ColorScripts-Enhanced on $((Get-Date).ToString('u'))")
    [void]$snippetLines.Add('Import-Module ColorScripts-Enhanced')
    if ($AutoShow) {
        $showCommand = if ([string]::IsNullOrWhiteSpace($DefaultScript)) {
            'Show-ColorScript'
        }
        else {
            $safeName = $DefaultScript -replace "'", "''"
            "Show-ColorScript -Name '$safeName'"
        }
        [void]$snippetLines.Add('try {')
        [void]$snippetLines.Add("    $showCommand")
        [void]$snippetLines.Add('}')
        [void]$snippetLines.Add('catch {')
        [void]$snippetLines.Add('    Write-Warning "ColorScripts-Enhanced startup snippet failed: $($_.Exception.Message)"')
        [void]$snippetLines.Add('}')
    }
    [void]$snippetLines.Add('# END ColorScripts-Enhanced managed block')
    return $snippetLines.ToArray() -join $Newline
}

function ConvertTo-ColorScriptProfileSnippetUpdate {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][AllowEmptyString()][string]$ExistingContent,
        [Parameter(Mandatory)][string]$Snippet,
        [switch]$Force
    )

    $managedPattern = '(?ms)^# BEGIN ColorScripts-Enhanced managed block\s*\r?\n.*?^# END ColorScripts-Enhanced managed block\s*(?:\r?\n)?'
    $legacyPattern = '(?ms)^# Added by ColorScripts-Enhanced[^\r\n]*(?:\r?\n)Import-Module\s+ColorScripts-Enhanced\b[^\r\n]*(?:(?:\r?\n)(?:Show-ColorScript|scs)\b[^\r\n]*|(?:\r?\n)try\s*\{(?:\r?\n)[ \t]+[^\r\n]*(?:\r?\n)\}(?:\r?\n)catch\s*\{(?:\r?\n)[ \t]+[^\r\n]*(?:\r?\n)\})?(?:\r?\n){0,2}'
    $existingPattern = if ($ExistingContent -match $managedPattern) {
        $managedPattern
    }
    elseif ($ExistingContent -match $legacyPattern) {
        $legacyPattern
    }
    else {
        $null
    }

    if ($existingPattern -and -not $Force) {
        Write-Verbose $script:Messages.ProfileAlreadyContainsSnippet
        return [pscustomobject]@{ AlreadyConfigured = $true; Content = $ExistingContent; Snippet = $Snippet }
    }
    $updatedContent = if ($existingPattern) {
        [System.Text.RegularExpressions.Regex]::Replace($ExistingContent, $existingPattern, '')
    }
    else {
        $ExistingContent
    }

    $importPattern = '(?mi)^\s*Import-Module\s+ColorScripts-Enhanced\b.*$'
    if (-not $Force -and $ExistingContent -match $importPattern) {
        Write-Verbose $script:Messages.ProfileAlreadyImportsModule
        return [pscustomobject]@{ AlreadyConfigured = $true; Content = $ExistingContent; Snippet = $Snippet }
    }
    if ($Force -and $updatedContent -match $importPattern) {
        $Snippet = [System.Text.RegularExpressions.Regex]::Replace(
            $Snippet,
            '(?mi)^Import-Module\s+ColorScripts-Enhanced\b[^\r\n]*(?:\r?\n)?',
            '')
    }

    return [pscustomobject]@{ AlreadyConfigured = $false; Content = $updatedContent; Snippet = $Snippet }
}

function Write-ColorScriptProfileFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$Directory,
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][System.Management.Automation.PSCmdlet]$Cmdlet
    )

    try {
        if (-not [string]::IsNullOrWhiteSpace($Directory) -and
            -not (Test-Path -LiteralPath $Directory -PathType Container)) {
            New-Item -ItemType Directory -Path $Directory -Force -ErrorAction Stop | Out-Null
        }
        Invoke-FileWriteAllText -Path $Path -Content $Content -Encoding $script:Utf8NoBomEncoding
    }
    catch {
        $template = if ($script:Messages -and $script:Messages.ContainsKey('ProfileSnippetWriteFailed')) {
            $script:Messages.ProfileSnippetWriteFailed
        }
        else {
            "Unable to write ColorScripts-Enhanced profile snippet to '{0}': {1}"
        }
        $message = $template -f $Path, $_.Exception.Message
        Invoke-ColorScriptError -Message $message -ErrorId 'ColorScriptsEnhanced.ProfileWriteFailed' -Category ([System.Management.Automation.ErrorCategory]::WriteError) -TargetObject $Path -Exception $_.Exception -Cmdlet $Cmdlet
    }
}

function Write-ColorScriptProfileSuccessMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path
    )

    $template = if ($script:Messages -and $script:Messages.ContainsKey('ProfileSnippetAdded')) {
        $script:Messages.ProfileSnippetAdded
    }
    else {
        '[OK] Added ColorScripts-Enhanced startup snippet to {0}'
    }
    Write-ColorScriptInformation -Message ($template -f $Path) -PreferConsole -Color 'Green'
}

function Invoke-ColorScriptProfileCacheWarmup {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)][bool]$ShouldBuild
    )

    if (-not $ShouldBuild) {
        return $false
    }

    try {
        ColorScripts-Enhanced\New-ColorScriptCache -All | Out-Null
        return $true
    }
    catch {
        Write-Verbose ("New-ColorScriptCache warm-up failed: {0}" -f $_.Exception.Message)
        return $false
    }
}

function Add-ColorScriptProfile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function already implements explicit ShouldProcess semantics.')]
    [CmdletBinding(SupportsShouldProcess = $true, HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile')]
    param(
        [Alias('help')][switch]$h,
        [Alias('Path')][ValidateScript({ Test-ColorScriptPathValue $_ })][string]$ProfilePath,
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowEmpty })][string]$DefaultStartupScript,
        [switch]$AutoShow,
        [switch]$SkipStartupScript,
        [switch]$IncludePokemon,
        [switch]$SkipPokemonPrompt,
        [ValidateSet('Y', 'N', 'Yes', 'No')][string]$PokemonPromptResponse,
        [switch]$SkipCacheBuild,
        [switch]$Force
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Add-ColorScriptProfile'
        return
    }

    # Retained for command-line compatibility. Pokemon scripts are always eligible now.
    $null = $IncludePokemon, $SkipPokemonPrompt, $PokemonPromptResponse
    if (Test-ColorScriptProfileRemoteSession) {
        return ConvertTo-ColorScriptProfileResult -Path $null -Changed $false -Message $script:Messages.ProfileUpdatesNotSupportedInRemote -CacheBuilt $false
    }

    $context = Get-ColorScriptProfileContext -ProfilePath $ProfilePath -Cmdlet $PSCmdlet
    $startup = Resolve-ColorScriptProfileStartupPreference -AutoShowSpecified $PSBoundParameters.ContainsKey('AutoShow') -AutoShow:$AutoShow -SkipStartupScript:$SkipStartupScript -DefaultScriptSpecified $PSBoundParameters.ContainsKey('DefaultStartupScript') -DefaultStartupScript $DefaultStartupScript
    $skipCache = Test-ColorScriptProfileCacheBuildSkipped -SkipCacheBuild:$SkipCacheBuild -ProfilePath $context.Path
    $snippet = ConvertTo-ColorScriptProfileSnippet -Newline $context.Newline -AutoShow $startup.AutoShow -DefaultScript $startup.DefaultScript
    $update = ConvertTo-ColorScriptProfileSnippetUpdate -ExistingContent $context.Content -Snippet $snippet -Force:$Force
    if ($update.AlreadyConfigured) {
        return ConvertTo-ColorScriptProfileResult -Path $context.Path -Changed $false -Message $script:Messages.ProfileAlreadyConfigured -CacheBuilt $false
    }

    if ($PSCmdlet.ShouldProcess($context.Path, 'Add ColorScripts-Enhanced profile snippet')) {
        $trimmedExisting = $update.Content.TrimEnd()
        $updatedContent = if ($trimmedExisting) {
            $trimmedExisting + $context.Newline + $context.Newline + $update.Snippet
        }
        else {
            $update.Snippet
        }
        Write-ColorScriptProfileFile -Path $context.Path -Directory $context.Directory -Content ($updatedContent + $context.Newline) -Cmdlet $PSCmdlet
        Write-ColorScriptProfileSuccessMessage -Path $context.Path
        $shouldBuildCache = $startup.AutoShow -and -not $skipCache
        if ($shouldBuildCache) {
            $shouldBuildCache = $PSCmdlet.ShouldProcess('ColorScripts cache', 'Build Colorscript cache for startup snippet')
        }
        $cacheBuilt = Invoke-ColorScriptProfileCacheWarmup -ShouldBuild $shouldBuildCache
        return ConvertTo-ColorScriptProfileResult -Path $context.Path -Changed $true -Message $script:Messages.ProfileSnippetAddedMessage -CacheBuilt $cacheBuilt
    }
}
