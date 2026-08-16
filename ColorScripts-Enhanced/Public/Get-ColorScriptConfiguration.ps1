function Get-ColorScriptDefaultCachePath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [AllowNull()]
        [AllowEmptyString()]
        [string]$ConfiguredPath
    )

    if (-not [string]::IsNullOrWhiteSpace($env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH)) {
        return $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
    }
    if (-not [string]::IsNullOrWhiteSpace($ConfiguredPath)) {
        return $ConfiguredPath
    }
    if ($script:IsWindows -and $env:APPDATA) {
        return Join-Path -Path (Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced') -ChildPath 'cache'
    }
    if ($script:IsMacOS -and $HOME) {
        $macApplicationSupport = Join-Path -Path (Join-Path -Path $HOME -ChildPath 'Library') -ChildPath 'Application Support'
        return Join-Path -Path (Join-Path -Path $macApplicationSupport -ChildPath 'ColorScripts-Enhanced') -ChildPath 'cache'
    }
    if ($HOME) {
        $xdgCache = if ($env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME } else { Join-Path -Path $HOME -ChildPath '.cache' }
        return Join-Path -Path $xdgCache -ChildPath 'ColorScripts-Enhanced'
    }
    return Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ColorScripts-Enhanced'
}

function Get-ColorScriptConfiguration {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [OutputType([hashtable])]
    [CmdletBinding(HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration')]
    param(
        [Alias('help')]
        [switch]$h
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Get-ColorScriptConfiguration'
        return
    }

    $data = Copy-ColorScriptHashtable (Get-ConfigurationDataInternal)

    if (-not $data.Cache) {
        $data.Cache = @{}
    }

    $effectiveCachePath = $script:CacheDir
    if (-not $effectiveCachePath) {
        $candidatePath = Get-ColorScriptDefaultCachePath -ConfiguredPath $data.Cache.Path
        $effectiveCachePath = Resolve-CachePath -Path $candidatePath
    }

    $data.Cache.EffectivePath = $effectiveCachePath

    return $data
}
