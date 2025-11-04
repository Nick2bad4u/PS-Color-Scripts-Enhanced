function New-ColorScript {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function implements ShouldProcess manually for enhanced messaging.')]
    [CmdletBinding(SupportsShouldProcess = $true, HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript')]
    param(
        [Alias('help')]
        [switch]$h,

        [Parameter(Mandatory)]
        [ValidateScript({ Test-ColorScriptNameValue $_ })]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$Destination,

        [Parameter()]
        [switch]$Overwrite,

        [Parameter()]
        [switch]$OpenInEditor
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'New-ColorScript'
        return
    }

    Initialize-Configuration

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($Name)
    $targetDirectory = Resolve-CachePath -Path $Destination
    if (-not $targetDirectory) {
        Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveDestination -f $Destination) -ErrorId 'ColorScriptsEnhanced.InvalidDestination' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -TargetObject $Destination -Cmdlet $PSCmdlet
    }

    if (-not (Test-Path -LiteralPath $targetDirectory)) {
        New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
    }

    $targetPath = Join-Path -Path $targetDirectory -ChildPath "$scriptName.ps1"

    if ((Test-Path -LiteralPath $targetPath) -and -not $Overwrite) {
        Invoke-ColorScriptError -Message ($script:Messages.ScriptAlreadyExists -f $targetPath) -ErrorId 'ColorScriptsEnhanced.ScriptExists' -Category ([System.Management.Automation.ErrorCategory]::ResourceExists) -TargetObject $targetPath -Cmdlet $PSCmdlet
    }

    $template = @(
        "#!/usr/bin/env pwsh",
        '',
        'Write-Output "Hello from your new colorscript!"'
    )

    $content = $template -join [Environment]::NewLine

    if ($PSCmdlet.ShouldProcess($targetPath, 'Create new colorscript')) {
        [System.IO.File]::WriteAllText($targetPath, $content + [Environment]::NewLine, $script:Utf8NoBomEncoding)
        Write-Host ($script:Messages.NewColorScriptCreated -f $targetPath) -ForegroundColor Green

        if ($OpenInEditor) {
            try {
                Invoke-Item -LiteralPath $targetPath
            }
            catch {
                Write-Warning ($script:Messages.UnableToOpenEditor -f $targetPath, $_.Exception.Message)
            }
        }

        return Get-Item -LiteralPath $targetPath
    }
}
