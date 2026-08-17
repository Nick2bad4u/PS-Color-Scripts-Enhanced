function Set-ColorScriptCacheConfigurationValue {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary]$Configuration,

        [AllowNull()]
        [string]$CachePath,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    if ([string]::IsNullOrWhiteSpace($CachePath)) {
        $Configuration.Cache.Path = $null
        return $null
    }

    $resolvedCache = Resolve-CachePath -Path $CachePath
    if (-not $resolvedCache) {
        Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveCachePath -f $CachePath) -ErrorId 'ColorScriptsEnhanced.InvalidCachePath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -TargetObject $CachePath -Cmdlet $Cmdlet
    }

    if (Test-Path -LiteralPath $resolvedCache -PathType Leaf) {
        Invoke-ColorScriptError -Message ($script:Messages.ConfiguredCachePathInvalid -f $CachePath) -ErrorId 'ColorScriptsEnhanced.InvalidCachePath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -TargetObject $CachePath -Cmdlet $Cmdlet
    }

    $Configuration.Cache.Path = $resolvedCache
    if (-not (Test-Path -LiteralPath $resolvedCache -PathType Container)) {
        return $resolvedCache
    }

    return $null
}

function Update-ColorScriptConfigurationValueSet {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary]$Configuration,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary]$BoundParameters,

        [Nullable[bool]]$AutoShowOnImport,
        [Nullable[bool]]$ProfileAutoShow,
        [AllowNull()][string]$CachePath,
        [AllowNull()][string]$DefaultScript,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    if ($BoundParameters.ContainsKey('AutoShowOnImport')) {
        $Configuration.Startup.AutoShowOnImport = [bool]$AutoShowOnImport
    }

    if ($BoundParameters.ContainsKey('ProfileAutoShow')) {
        $Configuration.Startup.ProfileAutoShow = [bool]$ProfileAutoShow
    }

    $cacheDirectoryToCreate = $null
    $cachePathChanged = $BoundParameters.ContainsKey('CachePath')
    if ($cachePathChanged) {
        $cacheDirectoryToCreate = Set-ColorScriptCacheConfigurationValue -Configuration $Configuration -CachePath $CachePath -Cmdlet $Cmdlet
    }

    if ($BoundParameters.ContainsKey('DefaultScript')) {
        $Configuration.Startup.DefaultScript = if ([string]::IsNullOrWhiteSpace($DefaultScript)) {
            $null
        }
        else {
            [string]$DefaultScript
        }
    }

    return [pscustomobject]@{
        CacheDirectoryToCreate = $cacheDirectoryToCreate
        CachePathChanged       = $cachePathChanged
    }
}

function Reset-ColorScriptCacheConfigurationState {
    $script:CacheInitialized = $false
    $script:CacheDir = $null
    $script:CacheValidationPerformed = $false
    $script:CacheValidationManualOverride = $false
    Reset-CachedOutputMemory
}

function Set-ColorScriptConfiguration {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [OutputType([hashtable])]
    [CmdletBinding(SupportsShouldProcess = $true, HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration')]
    param(
        [Alias('help')]
        [switch]$h,

        [Nullable[bool]]$AutoShowOnImport,
        [Nullable[bool]]$ProfileAutoShow,
        [ValidateScript({ Test-ColorScriptPathValue $_ -AllowEmpty })]
        [string]$CachePath,
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowEmpty })]
        [string]$DefaultScript,
        [switch]$PassThru
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Set-ColorScriptConfiguration'
        return
    }

    $data = Copy-ColorScriptHashtable (Get-ConfigurationDataInternal)
    $update = Update-ColorScriptConfigurationValueSet -Configuration $data -BoundParameters $PSBoundParameters -AutoShowOnImport $AutoShowOnImport -ProfileAutoShow $ProfileAutoShow -CachePath $CachePath -DefaultScript $DefaultScript -Cmdlet $PSCmdlet

    $configRoot = Get-ColorScriptsConfigurationRoot -NoCreate
    $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'

    if ($PSCmdlet.ShouldProcess($configPath, 'Update ColorScripts-Enhanced configuration')) {
        if ($update.CacheDirectoryToCreate) {
            New-Item -ItemType Directory -Path $update.CacheDirectoryToCreate -Force -ErrorAction Stop | Out-Null
        }

        Save-ColorScriptConfiguration -Configuration $data -Force
        $script:ConfigurationData = $data

        if ($update.CachePathChanged) {
            Reset-ColorScriptCacheConfigurationState
        }
    }

    if ($PassThru) {
        return Get-ColorScriptConfiguration
    }
}
