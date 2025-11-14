function Add-ColorScriptProfile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function already implements explicit ShouldProcess semantics.')]
    [CmdletBinding(SupportsShouldProcess = $true, HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile')]
    param(
        [Alias('help')]
        [switch]$h,

        [Alias('Path')]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$ProfilePath,

        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowEmpty })]
        [string]$DefaultStartupScript,

        [switch]$AutoShow,

        [switch]$SkipStartupScript,

        [switch]$Force
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Add-ColorScriptProfile'
        return
    }

    $remoteInfo = $null
    try {
        $remoteInfo = Get-Variable -Name PSSenderInfo -Scope Global -ValueOnly -ErrorAction Stop
    }
    catch {
        $remoteInfo = $null
    }

    if ($remoteInfo) {
        return [pscustomobject]@{
            Path    = $null
            Changed = $false
            Message = $script:Messages.ProfileUpdatesNotSupportedInRemote
        }
    }

    $profileScope = 'CurrentUserAllHosts'
    $profileSpec = $ProfilePath

    if (-not $profileSpec) {
        $profileValue = $PROFILE

        if ($profileValue -is [System.Management.Automation.PSObject]) {
            if ($profileValue.PSObject.Properties['CurrentUserAllHosts'] -and -not [string]::IsNullOrWhiteSpace([string]$profileValue.CurrentUserAllHosts)) {
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
    }

    if ([string]::IsNullOrWhiteSpace($profileSpec)) {
        Invoke-ColorScriptError -Message ($script:Messages.ProfilePathNotDefinedForScope -f $profileScope) -ErrorId 'ColorScriptsEnhanced.ProfilePathUndefined' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -Cmdlet $PSCmdlet
    }

    $profilePathResolved = $null
    try {
        $profilePathResolved = Resolve-CachePath -Path $profileSpec
    }
    catch {
        $profilePathResolved = $null
    }

    if ($profilePathResolved) {
        $profileSpec = $profilePathResolved
    }
    else {
        if (-not $script:IsWindows -and $profileSpec -match '^[A-Za-z]:') {
            Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveProfilePath -f $profileSpec) -ErrorId 'ColorScriptsEnhanced.InvalidProfilePath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -Cmdlet $PSCmdlet
        }

        if ([System.IO.Path]::IsPathRooted($profileSpec)) {
            Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveProfilePath -f $profileSpec) -ErrorId 'ColorScriptsEnhanced.InvalidProfilePath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -Cmdlet $PSCmdlet
        }

        try {
            $basePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('.')
        }
        catch {
            $basePath = $null
        }

        if (-not $basePath) {
            try {
                $basePath = (Get-Location -PSProvider FileSystem).Path
            }
            catch {
                $basePath = $null
            }
        }

        try {
            $profileSpec = [System.IO.Path]::GetFullPath((Join-Path -Path $basePath -ChildPath $profileSpec))
        }
        catch {
            Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveProfilePath -f $profileSpec) -ErrorId 'ColorScriptsEnhanced.InvalidProfilePath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -Exception $_.Exception -Cmdlet $PSCmdlet
        }
    }

    $profileDirectory = [System.IO.Path]::GetDirectoryName($profileSpec)
    if (-not [string]::IsNullOrWhiteSpace($profileDirectory) -and -not (Test-Path -LiteralPath $profileDirectory)) {
        New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
    }

    $existingContent = ''
    if (Test-Path -LiteralPath $profileSpec) {
        $existingContent = Get-Content -LiteralPath $profileSpec -Raw
    }

    $newline = if ($existingContent -match "`r`n") {
        "`r`n"
    }
    elseif ($existingContent -match "`n") {
        "`n"
    }
    else {
        [Environment]::NewLine
    }

    $timestamp = (Get-Date).ToString('u')

    $configuration = $null
    try {
        $configuration = Get-ColorScriptConfiguration
    }
    catch {
        Write-Verbose ("Get-ColorScriptConfiguration failed: {0}" -f $_.Exception.Message)
        $configuration = $null
    }

    $startupConfig = $null
    if ($configuration -and $configuration.Startup) {
        $startupConfig = $configuration.Startup
    }
    elseif ($script:ConfigurationData -and $script:ConfigurationData.Startup) {
        $startupConfig = $script:ConfigurationData.Startup
    }
    else {
        $startupConfig = $script:DefaultConfiguration.Startup
    }

    $profileAutoShow = $false
    $defaultScriptName = $null

    if ($startupConfig -is [System.Collections.IDictionary]) {
        if ($startupConfig.Contains('ProfileAutoShow')) {
            $profileAutoShow = [bool]$startupConfig['ProfileAutoShow']
        }

        if ($startupConfig.Contains('DefaultScript')) {
            $defaultScriptName = [string]$startupConfig['DefaultScript']
        }
    }
    else {
        if ($startupConfig -and ($startupConfig.PSObject.Properties.Name -contains 'ProfileAutoShow')) {
            $profileAutoShow = [bool]$startupConfig.ProfileAutoShow
        }

        if ($startupConfig -and ($startupConfig.PSObject.Properties.Name -contains 'DefaultScript')) {
            $defaultScriptName = [string]$startupConfig.DefaultScript
        }
    }

    if ($PSBoundParameters.ContainsKey('AutoShow')) {
        $profileAutoShow = [bool]$AutoShow
    }

    if ($SkipStartupScript) {
        $profileAutoShow = $false
    }

    if ($PSBoundParameters.ContainsKey('DefaultStartupScript')) {
        $defaultScriptName = $DefaultStartupScript
        if (-not $SkipStartupScript) {
            $profileAutoShow = $true
        }
    }

    $snippetLines = [System.Collections.Generic.List[string]]::new()
    [void]$snippetLines.Add("# Added by ColorScripts-Enhanced on $timestamp")
    [void]$snippetLines.Add('Import-Module ColorScripts-Enhanced')

    if ($profileAutoShow) {
        if (-not [string]::IsNullOrWhiteSpace($defaultScriptName)) {
            $safeName = $defaultScriptName -replace "'", "''"
            [void]$snippetLines.Add("Show-ColorScript -Name '$safeName'")
        }
        else {
            [void]$snippetLines.Add('Show-ColorScript')
        }
    }

    $snippet = ($snippetLines.ToArray() -join $newline)
    $updatedContent = $existingContent

    $snippetPattern = '(?ms)^# Added by ColorScripts-Enhanced.*?(?:\r?\n){2}'
    if ($updatedContent -match $snippetPattern) {
        if (-not $Force) {
            Write-Verbose $script:Messages.ProfileAlreadyContainsSnippet
            return [pscustomobject]@{
                Path    = $profileSpec
                Changed = $false
                Message = $script:Messages.ProfileAlreadyConfigured
            }
        }

        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $snippetPattern, '', 'MultiLine')
    }

    $importPattern = '(?mi)^\s*Import-Module\s+ColorScripts-Enhanced\b.*$'

    if (-not $Force -and $existingContent -match $importPattern) {
        Write-Verbose $script:Messages.ProfileAlreadyImportsModule
        return [pscustomobject]@{
            Path    = $profileSpec
            Changed = $false
            Message = $script:Messages.ProfileAlreadyConfigured
        }
    }

    if ($Force) {
        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $importPattern + '(?:\r?\n)?', '', 'Multiline')
        $showPattern = '(?mi)^\s*(Show-ColorScript|scs)\b.*(?:\r?\n)?'
        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $showPattern, '', 'Multiline')
    }

    if ($PSCmdlet.ShouldProcess($profileSpec, 'Add ColorScripts-Enhanced profile snippet')) {
        $trimmedExisting = $updatedContent.TrimEnd()
        if ($trimmedExisting) {
            $updatedContent = $trimmedExisting + $newline + $newline + $snippet
        }
        else {
            $updatedContent = $snippet
        }

        try {
            Invoke-FileWriteAllText -Path $profileSpec -Content ($updatedContent + $newline) -Encoding $script:Utf8NoBomEncoding
        }
        catch {
            $errorTemplate = if ($script:Messages -and $script:Messages.ContainsKey('ProfileSnippetWriteFailed')) {
                $script:Messages.ProfileSnippetWriteFailed
            }
            else {
                "Unable to write ColorScripts-Enhanced profile snippet to '{0}': {1}"
            }

            $errorMessage = $errorTemplate -f $profileSpec, $_.Exception.Message
            Invoke-ColorScriptError -Message $errorMessage -ErrorId 'ColorScriptsEnhanced.ProfileWriteFailed' -Category ([System.Management.Automation.ErrorCategory]::WriteError) -TargetObject $profileSpec -Exception $_.Exception -Cmdlet $PSCmdlet
        }

        $infoTemplate = if ($script:Messages -and $script:Messages.ContainsKey('ProfileSnippetAdded')) {
            $script:Messages.ProfileSnippetAdded
        }
        else {
            '[OK] Added ColorScripts-Enhanced startup snippet to {0}'
        }

        $infoMessage = $infoTemplate -f $profileSpec
        Write-ColorScriptInformation -Message $infoMessage -PreferConsole -Color 'Green'

        return [pscustomobject]@{
            Path    = $profileSpec
            Changed = $true
            Message = $script:Messages.ProfileSnippetAddedMessage
        }
    }
}
