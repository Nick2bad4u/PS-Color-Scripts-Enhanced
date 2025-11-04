function Add-ColorScriptProfile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function already implements explicit ShouldProcess semantics.')]
    [CmdletBinding(SupportsShouldProcess = $true, HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile')]
    param(
        [Alias('help')]
        [switch]$h,

        [Parameter()]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$ProfilePath,

        [Parameter()]
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowEmpty })]
        [string]$DefaultStartupScript,

        [Parameter()]
        [switch]$AutoShow,

        [Parameter()]
        [switch]$Force
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Add-ColorScriptProfile'
        return
    }

    Initialize-Configuration

    $profilePath = if ($ProfilePath) { $ProfilePath } else { $PROFILE }
    $profilePath = [string]$profilePath

    if ([string]::IsNullOrWhiteSpace($profilePath)) {
        Invoke-ColorScriptError -Message $script:Messages.ProfilePathNotSpecified -ErrorId 'ColorScriptsEnhanced.ProfilePathMissing' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -Cmdlet $PSCmdlet
    }

    $resolvedProfile = Resolve-CachePath -Path $profilePath
    if ($resolvedProfile) {
        $profilePath = $resolvedProfile
    }
    else {
        if (-not [System.IO.Path]::IsPathRooted($profilePath)) {
            $profilePath = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $profilePath))
        }
    }

    $profileDirectory = Split-Path -Parent $profilePath
    if (-not (Test-Path $profileDirectory)) {
        New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
    }

    $existingContent = ''
    if (Test-Path -LiteralPath $profilePath) {
        $existingContent = Get-Content -LiteralPath $profilePath -Raw
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
    $snippetLines = @(
        "# Added by ColorScripts-Enhanced on $timestamp",
        'Import-Module ColorScripts-Enhanced'
    )

    if ($AutoShow) {
        if (-not [string]::IsNullOrWhiteSpace($DefaultStartupScript)) {
            $safeName = $DefaultStartupScript -replace "'", "''"
            $snippetLines += "Show-ColorScript -Name '$safeName'"
        }
        else {
            $snippetLines += 'Show-ColorScript'
        }
    }

    $snippet = ($snippetLines -join $newline)
    $updatedContent = $existingContent

    $pattern = '(?ms)^# Added by ColorScripts-Enhanced.*?(?:\r?\n){2}'
    if ($updatedContent -match $pattern) {
        if (-not $Force) {
            Write-Verbose $script:Messages.ProfileAlreadyContainsSnippet
            return [pscustomobject]@{
                Path    = $profilePath
                Changed = $false
                Message = $script:Messages.ProfileAlreadyConfigured
            }
        }

        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $pattern, '', 'MultiLine')
    }

    $importPattern = '(?mi)^\s*Import-Module\s+ColorScripts-Enhanced\b.*$'

    if (-not $Force -and $existingContent -match $importPattern) {
        Write-Verbose $script:Messages.ProfileAlreadyImportsModule
        return [pscustomobject]@{
            Path    = $profilePath
            Changed = $false
            Message = $script:Messages.ProfileAlreadyConfigured
        }
    }

    if ($Force) {
        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $importPattern + '(?:\r?\n)?', '', 'Multiline')
        $showPattern = '(?mi)^\s*(Show-ColorScript|scs)\b.*(?:\r?\n)?'
        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $showPattern, '', 'Multiline')
    }

    if ($PSCmdlet.ShouldProcess($profilePath, 'Add ColorScripts-Enhanced profile snippet')) {
        $trimmedExisting = $updatedContent.TrimEnd()
        if ($trimmedExisting) {
            $updatedContent = $trimmedExisting + $newline + $newline + $snippet
        }
        else {
            $updatedContent = $snippet
        }

        [System.IO.File]::WriteAllText($profilePath, $updatedContent + $newline, $script:Utf8NoBomEncoding)

        Write-Host ($script:Messages.ProfileSnippetAdded -f $profilePath) -ForegroundColor Green

        return [pscustomobject]@{
            Path    = $profilePath
            Changed = $true
            Message = $script:Messages.ProfileSnippetAddedMessage
        }
    }
}
