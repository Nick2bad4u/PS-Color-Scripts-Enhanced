function New-ColorScript {
    [CmdletBinding(SupportsShouldProcess = $true, HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript')]
    param(
        [Parameter(ParameterSetName = 'Help')]
        [Parameter(ParameterSetName = 'Scaffold')]
        [Alias('help')]
        [switch]$h,

        [Parameter(ParameterSetName = 'Scaffold', Mandatory)]
        [Parameter(ParameterSetName = 'Help')]
        [ValidateScript({ Test-ColorScriptNameValue $_ })]
        [string]$Name,

        [Parameter(ParameterSetName = 'Scaffold', Mandatory)]
        [Alias('Destination', 'Path')]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$OutputPath,

        [Parameter(ParameterSetName = 'Scaffold')]
        [Alias('Overwrite')]
        [switch]$Force,

        [Parameter(ParameterSetName = 'Scaffold')]
        [switch]$GenerateMetadataSnippet,

        [Parameter(ParameterSetName = 'Scaffold')]
        [string[]]$Category,

        [Parameter(ParameterSetName = 'Scaffold')]
        [string[]]$Tag,

        [Parameter(ParameterSetName = 'Scaffold')]
        [switch]$OpenInEditor
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'New-ColorScript'
        return
    }

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($Name)
    $resolvedOutput = Resolve-CachePath -Path $OutputPath

    if (-not $resolvedOutput) {
        Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveOutputPath -f $OutputPath) -ErrorId 'ColorScriptsEnhanced.InvalidOutputPath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -TargetObject $OutputPath -Cmdlet $PSCmdlet
    }

    if (-not (Test-Path -LiteralPath $resolvedOutput)) {
        New-Item -ItemType Directory -Path $resolvedOutput -Force | Out-Null
    }

    $targetPath = Join-Path -Path $resolvedOutput -ChildPath ("{0}.ps1" -f $scriptName)

    if ((Test-Path -LiteralPath $targetPath) -and -not $Force) {
        Invoke-ColorScriptError -Message ($script:Messages.ScriptAlreadyExists -f $targetPath) -ErrorId 'ColorScriptsEnhanced.ScriptAlreadyExists' -Category ([System.Management.Automation.ErrorCategory]::ResourceExists) -TargetObject $targetPath -Cmdlet $PSCmdlet
    }

    $effectiveCategories = if ($Category) { [string[]]$Category } elseif ($GenerateMetadataSnippet) { @('Custom') } else { @() }
    $effectiveTags = if ($Tag) { [string[]]$Tag } elseif ($GenerateMetadataSnippet) { @('Custom') } else { @() }

    $metadataGuidance = $null
    $guidanceComment = ''
    if ($GenerateMetadataSnippet) {
        $categorySummary = ($effectiveCategories -join ', ')
        $tagSummary = ($effectiveTags -join ', ')

        $quotedTags = if ($effectiveTags.Count -gt 0) { ($effectiveTags | ForEach-Object { "'$_'" }) -join ', ' } else { '' }

        $metadataGuidance = @"
    Add the following entry to ScriptMetadata.psd1:

    Name: $scriptName
    Category: $categorySummary
    Tags: $quotedTags
    "@.Trim()

        $guidanceComment = @"
<#
ScriptMetadata Guidance:
    Name: $scriptName
    Category: $categorySummary
        Tags: $quotedTags
#>

"@
    }

    $scriptTemplate = @"
# ColorScripts-Enhanced colorscript scaffold
[string[]]`$ansiArt = @(
    'Replace this array with your ANSI art'
)

foreach (`$line in `$ansiArt) {
    Write-Host `$line
}
"@.TrimEnd()

    $scriptContent = ($guidanceComment + $scriptTemplate).TrimEnd() + [Environment]::NewLine

    $operation = if (Test-Path -LiteralPath $targetPath) { 'Overwrite colorscript file' } else { 'Create colorscript file' }

    if (-not $PSCmdlet.ShouldProcess($targetPath, $operation)) {
        return
    }

    [System.IO.File]::WriteAllText($targetPath, $scriptContent, $script:Utf8NoBomEncoding)
    Reset-ScriptInventoryCache

    if ($OpenInEditor) {
        try {
            Invoke-Item -LiteralPath $targetPath
        }
        catch {
            Write-Warning "Unable to open editor for ${targetPath}: $($_.Exception.Message)"
        }
    }

    return [pscustomobject]@{
        Name             = $scriptName
        Path             = $targetPath
        MetadataGuidance = $metadataGuidance
        Categories       = $effectiveCategories
        Tags             = $effectiveTags
    }
}
