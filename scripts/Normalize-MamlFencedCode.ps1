<#
.SYNOPSIS
    Normalizes fenced PowerShell examples emitted into MAML paragraph nodes.

.DESCRIPTION
    Microsoft.PowerShell.PlatyPS 1.0.x can serialize Markdown example fences into
    maml:introduction paragraphs while leaving dev:code and dev:remarks empty.
    This script moves one complete PowerShell fence into dev:code, moves prose
    following that fence into dev:remarks, and removes PlatyPS separator
    paragraphs. It fails closed on partial, unsupported, or ambiguous fences.
#>
#Requires -Version 5.1

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('FullName')]
    [string[]]$LiteralPath
)

begin {
    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'

    function Remove-XmlNodeWithWhitespace {
        param([Parameter(Mandatory)][System.Xml.XmlNode]$Node)

        $precedingWhitespace = $Node.PreviousSibling
        [void]$Node.ParentNode.RemoveChild($Node)
        if ($precedingWhitespace -and
            $precedingWhitespace.NodeType -in @(
                [System.Xml.XmlNodeType]::Whitespace,
                [System.Xml.XmlNodeType]::SignificantWhitespace
            ) -and
            [string]::IsNullOrWhiteSpace($precedingWhitespace.Value)) {
            [void]$precedingWhitespace.ParentNode.RemoveChild($precedingWhitespace)
        }
    }

    function Save-MamlDocument {
        param(
            [Parameter(Mandatory)][System.Xml.XmlDocument]$Document,
            [Parameter(Mandatory)][string]$Path
        )

        # Reparse without insignificant whitespace before pretty-printing.
        # The PlatyPS document carries indentation nodes whose parents were
        # removed or moved during normalization; preserving those nodes emits
        # whitespace-only lines that fail git diff --check.
        $normalizedDocument = New-Object System.Xml.XmlDocument
        $normalizedDocument.PreserveWhitespace = $false
        $normalizedDocument.LoadXml($Document.OuterXml)

        $settings = New-Object System.Xml.XmlWriterSettings
        $settings.Encoding = New-Object System.Text.UTF8Encoding($false)
        $settings.Indent = $true
        $settings.IndentChars = '  '
        $settings.NewLineChars = "`r`n"
        $settings.NewLineHandling = [System.Xml.NewLineHandling]::Replace
        $writer = [System.Xml.XmlWriter]::Create($Path, $settings)
        try {
            $normalizedDocument.Save($writer)
        }
        finally {
            $writer.Dispose()
        }
    }
}

process {
    foreach ($path in $LiteralPath) {
        $resolvedPath = (Get-Item -LiteralPath $path -ErrorAction Stop).FullName
        $document = New-Object System.Xml.XmlDocument
        $document.PreserveWhitespace = $true
        $document.Load($resolvedPath)

        $examples = @($document.SelectNodes(
                "//*[local-name()='example' and namespace-uri()='http://schemas.microsoft.com/maml/dev/command/2004/10']"
            ))
        if ($examples.Count -eq 0) {
            throw "MAML file '$resolvedPath' does not contain any command examples."
        }

        $normalizedCount = 0
        foreach ($example in $examples) {
            $introduction = $example.SelectSingleNode(
                "./*[local-name()='introduction' and namespace-uri()='http://schemas.microsoft.com/maml/2004/10']"
            )
            $codeNode = $example.SelectSingleNode(
                "./*[local-name()='code' and namespace-uri()='http://schemas.microsoft.com/maml/dev/2004/10']"
            )
            $remarksNode = $example.SelectSingleNode(
                "./*[local-name()='remarks' and namespace-uri()='http://schemas.microsoft.com/maml/dev/2004/10']"
            )
            if (-not $introduction -or -not $codeNode -or -not $remarksNode) {
                throw "MAML example in '$resolvedPath' is missing introduction, code, or remarks nodes."
            }

            $paragraphs = @(
                $introduction.SelectNodes(
                    "./*[local-name()='para' and namespace-uri()='http://schemas.microsoft.com/maml/2004/10']"
                )
            )
            $fenceMarkerCount = 0
            foreach ($paragraph in $paragraphs) {
                $fenceMarkerCount += [regex]::Matches($paragraph.InnerText, '```').Count
            }
            if ($fenceMarkerCount -eq 0) {
                if ([string]::IsNullOrWhiteSpace($codeNode.InnerText)) {
                    throw "MAML example in '$resolvedPath' has neither a fenced paragraph nor dev:code."
                }
                continue
            }
            if ($fenceMarkerCount -ne 2) {
                throw "MAML example in '$resolvedPath' contains $fenceMarkerCount fence markers; expected exactly two."
            }
            if (-not [string]::IsNullOrWhiteSpace($codeNode.InnerText) -or $remarksNode.HasChildNodes) {
                throw "MAML example in '$resolvedPath' has ambiguous fenced and structured example content."
            }

            $openingIndex = -1
            $closingIndex = -1
            for ($paragraphIndex = 0; $paragraphIndex -lt $paragraphs.Count; $paragraphIndex++) {
                if ($openingIndex -eq -1 -and
                    $paragraphs[$paragraphIndex].InnerText -match '\A```(?:powershell|pwsh)\r?\n') {
                    $openingIndex = $paragraphIndex
                }
                if ($paragraphs[$paragraphIndex].InnerText -match '\r?\n```\z') {
                    $closingIndex = $paragraphIndex
                }
            }
            if ($openingIndex -lt 0 -or $closingIndex -lt $openingIndex) {
                throw "MAML example in '$resolvedPath' contains a malformed or unsupported fenced code block."
            }

            $codeParts = New-Object 'System.Collections.Generic.List[string]'
            for ($paragraphIndex = $openingIndex; $paragraphIndex -le $closingIndex; $paragraphIndex++) {
                $paragraphText = $paragraphs[$paragraphIndex].InnerText
                if ($paragraphText -eq [string][char]0x80) {
                    [void]$codeParts.Add('')
                    continue
                }
                if ($paragraphIndex -eq $openingIndex) {
                    $paragraphText = [regex]::Replace(
                        $paragraphText,
                        '\A```(?:powershell|pwsh)\r?\n',
                        ''
                    )
                }
                if ($paragraphIndex -eq $closingIndex) {
                    $paragraphText = [regex]::Replace($paragraphText, '\r?\n```\z', '')
                }
                if ($paragraphText.Contains('```')) {
                    throw "MAML example in '$resolvedPath' contains an unsupported nested fence."
                }
                [void]$codeParts.Add(($paragraphText -replace "`r?`n", "`r`n"))
            }
            $normalizedCode = $codeParts -join "`r`n"
            if ([string]::IsNullOrWhiteSpace($normalizedCode)) {
                throw "MAML example in '$resolvedPath' contains an empty fenced code block."
            }

            $followingParagraphs = New-Object 'System.Collections.Generic.List[System.Xml.XmlNode]'
            for ($paragraphIndex = $closingIndex + 1; $paragraphIndex -lt $paragraphs.Count; $paragraphIndex++) {
                if ($paragraphs[$paragraphIndex].InnerText -ne [string][char]0x80) {
                    [void]$followingParagraphs.Add($paragraphs[$paragraphIndex])
                }
            }

            $codeNode.InnerText = $normalizedCode
            foreach ($paragraph in $followingParagraphs) {
                [void]$remarksNode.AppendChild($paragraph)
            }

            for ($paragraphIndex = $closingIndex; $paragraphIndex -ge $openingIndex; $paragraphIndex--) {
                Remove-XmlNodeWithWhitespace -Node $paragraphs[$paragraphIndex]
            }
            foreach ($separator in @($introduction.SelectNodes(
                        "./*[local-name()='para' and namespace-uri()='http://schemas.microsoft.com/maml/2004/10']"
                    ) | Where-Object { $_.InnerText -eq [string][char]0x80 })) {
                Remove-XmlNodeWithWhitespace -Node $separator
            }
            $normalizedCount++
        }

        $residualFences = @(
            $document.SelectNodes('//*') |
                Where-Object {
                    $_.ChildNodes.Count -eq 1 -and
                    $_.InnerText.Contains(([string][char]96) * 3)
                }
        )
        $residualSeparators = @(
            $document.SelectNodes('//*') |
                Where-Object { $_.ChildNodes.Count -eq 1 -and $_.InnerText.Contains([char]0x80) }
        )
        if ($residualFences.Count -gt 0 -or $residualSeparators.Count -gt 0) {
            $firstResidualFence = if ($residualFences.Count -gt 0) {
                $residualFences[0].OuterXml
            }
            else {
                ''
            }
            throw "MAML normalization left $($residualFences.Count) code fence node(s) and $($residualSeparators.Count) U+0080 separator node(s) in '$resolvedPath'. First fence node: $firstResidualFence"
        }

        if ($normalizedCount -gt 0 -and $PSCmdlet.ShouldProcess($resolvedPath, "Normalize $normalizedCount fenced MAML examples")) {
            Save-MamlDocument -Document $document -Path $resolvedPath
        }

        [pscustomobject]@{
            Path            = $resolvedPath
            ExampleCount    = $examples.Count
            NormalizedCount = $normalizedCount
        }
    }
}
