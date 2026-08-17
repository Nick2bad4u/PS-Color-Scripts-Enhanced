function Get-ColorScriptScaffoldMetadataValue {
    param(
        [AllowNull()]
        [string[]]$Value,

        [switch]$GenerateMetadataSnippet
    )

    if ($Value) {
        return [string[]]$Value
    }

    if ($GenerateMetadataSnippet) {
        return [string[]]@('Custom')
    }

    return [string[]]@()
}

function New-ColorScriptScaffoldMetadataRecord {
    param(
        [Parameter(Mandatory)]
        [string]$ScriptName,

        [AllowNull()]
        [string[]]$Category,

        [AllowNull()]
        [string[]]$Tag,

        [switch]$GenerateMetadataSnippet
    )

    $categories = Get-ColorScriptScaffoldMetadataValue -Value $Category -GenerateMetadataSnippet:$GenerateMetadataSnippet
    $tags = Get-ColorScriptScaffoldMetadataValue -Value $Tag -GenerateMetadataSnippet:$GenerateMetadataSnippet

    if (-not $GenerateMetadataSnippet) {
        return [pscustomobject]@{
            Categories = $categories
            Tags       = $tags
            Guidance   = $null
            Comment    = ''
        }
    }

    $categorySummary = $categories -join ', '
    $quotedTags = ($tags | ForEach-Object { "'$_'" }) -join ', '
    $guidance = @"
    Add the following entry to ScriptMetadata.psd1:

    Name: $ScriptName
    Category: $categorySummary
    Tags: $quotedTags
    "@.Trim()

    $comment = @"
<#
ScriptMetadata Guidance:
    Name: $ScriptName
    Category: $categorySummary
        Tags: $quotedTags
#>

"@

    return [pscustomobject]@{
        Categories = $categories
        Tags       = $tags
        Guidance   = $guidance
        Comment    = $comment
    }
}

function New-ColorScriptScaffoldContent {
    param(
        [AllowEmptyString()]
        [string]$GuidanceComment
    )

    $scriptTemplate = @"
# ColorScripts-Enhanced colorscript scaffold
[string[]]`$ansiArt = @(
    'Replace this array with your ANSI art'
)

foreach (`$line in `$ansiArt) {
    Write-Host `$line
}
"@.TrimEnd()

    return ($GuidanceComment + $scriptTemplate).TrimEnd() + [Environment]::NewLine
}

function Write-ColorScriptScaffoldFile {
    param(
        [Parameter(Mandatory)]
        [string]$TargetPath,

        [Parameter(Mandatory)]
        [string]$OutputDirectory,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Content,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    try {
        if (-not (Test-Path -LiteralPath $OutputDirectory -PathType Container)) {
            New-Item -ItemType Directory -Path $OutputDirectory -Force -ErrorAction Stop | Out-Null
        }

        Invoke-FileWriteAllText -Path $TargetPath -Content $Content -Encoding $script:Utf8NoBomEncoding
    }
    catch {
        $errorTemplate = if ($script:Messages -and $script:Messages.ContainsKey('UnableToWriteColorScriptFile')) {
            $script:Messages.UnableToWriteColorScriptFile
        }
        else {
            "Unable to write colorscript file '{0}': {1}"
        }

        $errorMessage = $errorTemplate -f $TargetPath, $_.Exception.Message
        Invoke-ColorScriptError -Message $errorMessage -ErrorId 'ColorScriptsEnhanced.ScriptWriteFailed' -Category ([System.Management.Automation.ErrorCategory]::WriteError) -TargetObject $TargetPath -Exception $_.Exception -Cmdlet $Cmdlet
    }
}

function Open-ColorScriptScaffoldFile {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    try {
        Invoke-Item -LiteralPath $Path
    }
    catch {
        $warningTemplate = if ($script:Messages -and $script:Messages.ContainsKey('UnableToOpenEditorForPath')) {
            $script:Messages.UnableToOpenEditorForPath
        }
        else {
            "Unable to open editor for '{0}': {1}"
        }

        Write-Warning ($warningTemplate -f $Path, $_.Exception.Message)
    }
}

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

    $targetPath = Join-Path -Path $resolvedOutput -ChildPath ("{0}.ps1" -f $scriptName)
    if ((Test-Path -LiteralPath $targetPath) -and -not $Force) {
        Invoke-ColorScriptError -Message ($script:Messages.ScriptAlreadyExists -f $targetPath) -ErrorId 'ColorScriptsEnhanced.ScriptAlreadyExists' -Category ([System.Management.Automation.ErrorCategory]::ResourceExists) -TargetObject $targetPath -Cmdlet $PSCmdlet
    }

    $metadata = New-ColorScriptScaffoldMetadataRecord -ScriptName $scriptName -Category $Category -Tag $Tag -GenerateMetadataSnippet:$GenerateMetadataSnippet
    $scriptContent = New-ColorScriptScaffoldContent -GuidanceComment $metadata.Comment
    $operation = if (Test-Path -LiteralPath $targetPath) { 'Overwrite colorscript file' } else { 'Create colorscript file' }

    if (-not $PSCmdlet.ShouldProcess($targetPath, $operation)) {
        return
    }

    Write-ColorScriptScaffoldFile -TargetPath $targetPath -OutputDirectory $resolvedOutput -Content $scriptContent -Cmdlet $PSCmdlet
    Reset-ScriptInventoryCache

    if ($OpenInEditor) {
        Open-ColorScriptScaffoldFile -Path $targetPath
    }

    return [pscustomobject]@{
        Name             = $scriptName
        Path             = $targetPath
        MetadataGuidance = $metadata.Guidance
        Categories       = $metadata.Categories
        Tags             = $metadata.Tags
    }
}
