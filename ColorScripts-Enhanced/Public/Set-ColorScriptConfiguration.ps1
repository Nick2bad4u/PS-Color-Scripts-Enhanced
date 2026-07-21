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
    $cacheDirectoryToCreate = $null
    $cachePathChanged = $false

    if ($PSBoundParameters.ContainsKey('AutoShowOnImport')) {
        $data.Startup.AutoShowOnImport = [bool]$AutoShowOnImport
    }

    if ($PSBoundParameters.ContainsKey('ProfileAutoShow')) {
        $data.Startup.ProfileAutoShow = [bool]$ProfileAutoShow
    }

    if ($PSBoundParameters.ContainsKey('CachePath')) {
        if ([string]::IsNullOrWhiteSpace($CachePath)) {
            $data.Cache.Path = $null
        }
        else {
            $resolvedCache = Resolve-CachePath -Path $CachePath
            if (-not $resolvedCache) {
                Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveCachePath -f $CachePath) -ErrorId 'ColorScriptsEnhanced.InvalidCachePath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -TargetObject $CachePath -Cmdlet $PSCmdlet
            }

            if (-not (Test-Path -LiteralPath $resolvedCache)) {
                $cacheDirectoryToCreate = $resolvedCache
            }

            $data.Cache.Path = $resolvedCache
        }

        $cachePathChanged = $true
    }

    if ($PSBoundParameters.ContainsKey('DefaultScript')) {
        if ([string]::IsNullOrWhiteSpace($DefaultScript)) {
            $data.Startup.DefaultScript = $null
        }
        else {
            $data.Startup.DefaultScript = [string]$DefaultScript
        }
    }

    $configRoot = Get-ColorScriptsConfigurationRoot -NoCreate
    $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'

    if ($PSCmdlet.ShouldProcess($configPath, 'Update ColorScripts-Enhanced configuration')) {
        if ($cacheDirectoryToCreate) {
            New-Item -ItemType Directory -Path $cacheDirectoryToCreate -Force -ErrorAction Stop | Out-Null
        }

        Save-ColorScriptConfiguration -Configuration $data -Force
        $script:ConfigurationData = $data

        if ($cachePathChanged) {
            $script:CacheInitialized = $false
            $script:CacheDir = $null
            $script:CacheValidationPerformed = $false
            $script:CacheValidationManualOverride = $false
            Reset-CachedOutputMemory
        }
    }

    if ($PassThru) {
        return Get-ColorScriptConfiguration
    }
}
