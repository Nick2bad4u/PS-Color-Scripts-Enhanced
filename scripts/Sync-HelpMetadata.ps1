<#
.SYNOPSIS
    Synchronizes PlatyPS command metadata while preserving translated prose.

.DESCRIPTION
    Generates authoritative command-help metadata from the imported module, then merges the
    existing synopsis, description, examples, notes, and parameter descriptions into that
    metadata. This keeps syntax, parameter sets, aliases, types, inputs, and outputs current
    without replacing localized narrative text with English comment-based help.
#>
#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$ModuleManifestPath,

    [Parameter(Mandatory)]
    [string]$CulturePath,

    [Parameter(Mandatory)]
    [string]$Culture,

    [Parameter(Mandatory)]
    [string]$PlatyModuleName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$parameterTranslations = @{
    'en-US' = @{
        h            = 'Displays detailed help for this command without performing the operation.'
        Quiet        = 'Suppresses informational messages while preserving command output and errors.'
        NoAnsiOutput = 'Disables ANSI styling in informational messages and rendered output for plain-text environments.'
    }
    de      = @{
        h            = 'Zeigt die ausführliche Hilfe für diesen Befehl an, ohne den Vorgang auszuführen.'
        Quiet        = 'Unterdrückt Informationsmeldungen, ohne Befehlsausgaben und Fehler zu unterdrücken.'
        NoAnsiOutput = 'Deaktiviert ANSI-Formatierung in Informationsmeldungen und gerenderter Ausgabe für reine Textumgebungen.'
    }
    es      = @{
        h            = 'Muestra la ayuda detallada de este comando sin realizar la operación.'
        Quiet        = 'Suprime los mensajes informativos sin ocultar la salida del comando ni los errores.'
        NoAnsiOutput = 'Desactiva el formato ANSI en los mensajes informativos y la salida renderizada para entornos de texto sin formato.'
    }
    fr      = @{
        h            = "Affiche l'aide détaillée de cette commande sans effectuer l'opération."
        Quiet        = "Supprime les messages d'information sans masquer la sortie de la commande ni les erreurs."
        NoAnsiOutput = "Désactive la mise en forme ANSI dans les messages d'information et la sortie rendue pour les environnements en texte brut."
    }
    it      = @{
        h            = "Visualizza la guida dettagliata del comando senza eseguire l'operazione."
        Quiet        = "Nasconde i messaggi informativi senza sopprimere l'output del comando o gli errori."
        NoAnsiOutput = "Disabilita la formattazione ANSI nei messaggi informativi e nell'output renderizzato per gli ambienti di solo testo."
    }
    ja      = @{
        h            = '操作を実行せずに、このコマンドの詳細なヘルプを表示します。'
        Quiet        = 'コマンドの出力やエラーを維持したまま、情報メッセージを抑制します。'
        NoAnsiOutput = 'プレーンテキスト環境向けに、情報メッセージと描画出力の ANSI 装飾を無効にします。'
    }
    nl      = @{
        h            = 'Toont gedetailleerde hulp voor deze opdracht zonder de bewerking uit te voeren.'
        Quiet        = 'Onderdrukt informatieve berichten zonder opdrachtuitvoer en fouten te verbergen.'
        NoAnsiOutput = 'Schakelt ANSI-opmaak uit in informatieve berichten en gerenderde uitvoer voor platte-tekstomgevingen.'
    }
    pt      = @{
        h            = 'Exibe a ajuda detalhada deste comando sem executar a operação.'
        Quiet        = 'Suprime mensagens informativas sem ocultar a saída do comando nem os erros.'
        NoAnsiOutput = 'Desativa a formatação ANSI nas mensagens informativas e na saída renderizada para ambientes de texto simples.'
    }
    ru      = @{
        h            = 'Показывает подробную справку по команде, не выполняя операцию.'
        Quiet        = 'Подавляет информационные сообщения, сохраняя вывод команды и ошибки.'
        NoAnsiOutput = 'Отключает оформление ANSI в информационных сообщениях и отображаемом выводе для текстовых сред.'
    }
    'zh-CN' = @{
        h            = '显示此命令的详细帮助，而不执行操作。'
        Quiet        = '禁止显示信息性消息，但保留命令输出和错误。'
        NoAnsiOutput = '为纯文本环境禁用信息性消息和渲染输出中的 ANSI 样式。'
    }
}

# English fallback text is intentional: a correct description is preferable to shipping a
# translated package with a PlatyPS template marker. Existing localized prose still wins.
$parameterFallbacks = @{
    'Add-ColorScriptProfile' = @{
        AutoShow             = 'Controls whether the managed profile block displays a colorscript after importing the module.'
        DefaultStartupScript = 'Specifies the colorscript name written to the managed profile block for startup display.'
        Force                = 'Updates the managed profile block without removing unrelated profile content.'
        IncludePokemon       = 'Allows Pokemon-themed scripts when the managed profile block displays a random colorscript.'
        ProfilePath          = 'Specifies the PowerShell profile file to update. The Path alias is also accepted.'
        SkipStartupScript    = 'Adds the module import but omits the startup Show-ColorScript invocation.'
    }
    'Get-ColorScriptList' = @{
        Detailed = 'Displays an expanded formatted view that includes descriptions and additional metadata.'
    }
    'New-ColorScriptCache' = @{
        All           = 'Processes every renderer selected by CachePolicy.psd1 without enumerating the full static script inventory.'
        Parallel      = 'Builds eligible cache entries concurrently. Unsupported hosts fall back to sequential execution.'
        ThrottleLimit = 'Sets the maximum number of concurrent cache workers. Threads is an alias for this parameter.'
    }
    'New-ColorScript' = @{
        Force                   = 'Overwrites an existing colorscript file at the resolved output path.'
        GenerateMetadataSnippet = 'Includes metadata guidance for adding the new script to ScriptMetadata.psd1.'
        OpenInEditor            = 'Opens the generated colorscript with the command configured by the environment when creation succeeds.'
        OutputPath              = 'Specifies the target directory or .ps1 file path for the generated colorscript.'
        Tag                     = 'Specifies metadata tags to include in the generated metadata guidance.'
    }
    'Reset-ColorScriptConfiguration' = @{
        PassThru = 'Returns the effective default configuration after the reset succeeds.'
    }
    'Set-ColorScriptConfiguration' = @{
        AutoShowOnImport = 'Controls whether importing the module automatically displays a colorscript.'
        DefaultScript    = 'Specifies the default colorscript used by startup and profile integration.'
        PassThru         = 'Returns the effective configuration after the requested changes succeed.'
        ProfileAutoShow  = 'Controls whether profile integration displays a colorscript after importing the module.'
    }
}

$commonParameterFallbacks = @{
    WhatIf = 'Shows what would happen if the command ran. No files or persistent configuration are changed.'
}

function Get-MarkdownParameterDescriptionTable {
    param([Parameter(Mandatory)][string]$Path)

    $descriptions = @{}
    $content = Get-Content -LiteralPath $Path -Raw
    $parameterMatches = [regex]::Matches(
        $content,
        '(?ms)^### -(?<Name>[^\r\n]+)\r?\n\r?\n(?<Description>.*?)(?=\r?\n```yaml)'
    )

    foreach ($match in $parameterMatches) {
        $name = $match.Groups['Name'].Value.Trim()
        $description = $match.Groups['Description'].Value.Trim()
        if ($name -and $description) {
            $descriptions[$name] = $description
        }
    }

    return $descriptions
}

function Get-MarkdownSection {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Heading
    )

    $pattern = '(?ms)^## {0}\s*\r?\n(?<Body>.*?)(?=^## |\z)' -f [regex]::Escape($Heading)
    $match = [regex]::Match($Content, $pattern)
    if (-not $match.Success) {
        return $null
    }

    return $match.Groups['Body'].Value.Trim()
}

function Set-MarkdownSection {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Heading,
        [Parameter(Mandatory)][string]$Body
    )

    $pattern = '(?ms)^## {0}\s*\r?\n.*?(?=^## |\z)' -f [regex]::Escape($Heading)
    if (-not [regex]::IsMatch($Content, $pattern)) {
        return $Content
    }

    $replacement = "## $Heading`r`n`r`n$($Body.Trim())`r`n`r`n"
    return [regex]::Replace($Content, $pattern, [System.Text.RegularExpressions.MatchEvaluator] {
            param($match)
            $null = $match
            return $replacement
        }, 1)
}

function Set-MarkdownParameterDescription {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$ParameterName,
        [Parameter(Mandatory)][string]$Description
    )

    $pattern = '(?ms)(^### -{0}\s*\r?\n\r?\n).*?(?=\r?\n```yaml)' -f [regex]::Escape($ParameterName)
    if (-not [regex]::IsMatch($Content, $pattern)) {
        return $Content
    }

    $replacementDescription = $Description.Trim()
    return [regex]::Replace($Content, $pattern, [System.Text.RegularExpressions.MatchEvaluator] {
            param($match)
            return $match.Groups[1].Value + $replacementDescription + "`r`n"
        }, 1)
}

Import-Module -Name $ModuleManifestPath -Force -ErrorAction Stop
Import-Module -Name $PlatyModuleName -Force -ErrorAction Stop

# PlatyPS 1.0.2 reads optional CommandInfo properties dynamically and is not compatible with
# a caller-scoped StrictMode. Keep strict validation for this script's setup, then disable it
# only for the PlatyPS object-model operations below.
Set-StrictMode -Off

$module = Get-Module -Name ColorScripts-Enhanced -ErrorAction Stop
$commands = @(Get-Command -Module $module.Name -CommandType Function | Sort-Object -Property Name)
if ($commands.Count -eq 0) {
    throw "No exported functions were found for module '$($module.Name)'."
}

$tempRoot = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ("colorscripts-help-{0}" -f [guid]::NewGuid())
$sourceRoot = Join-Path -Path $tempRoot -ChildPath 'source'

try {
    New-Item -ItemType Directory -Path $sourceRoot -Force | Out-Null

    New-MarkdownCommandHelp `
        -CommandInfo $commands `
        -OutputFolder $sourceRoot `
        -Locale $Culture `
        -HelpVersion $module.Version `
        -Force | Out-Null

    $generatedRoot = Join-Path -Path $sourceRoot -ChildPath $module.Name
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)

    foreach ($command in $commands) {
        $sourcePath = Join-Path -Path $generatedRoot -ChildPath ("{0}.md" -f $command.Name)
        $existingPath = Join-Path -Path $CulturePath -ChildPath ("{0}.md" -f $command.Name)
        $mergedContent = Get-Content -LiteralPath $sourcePath -Raw -ErrorAction Stop
        $mergedContent = [regex]::Replace(
            $mergedContent,
            '(?im)^external help file:\s*.*$',
            'external help file: ColorScripts-Enhanced-help.xml'
        )
        $parameterDescriptions = @{}
        $englishParameterDescriptions = @{}
        $englishPath = Join-Path `
            -Path (Join-Path -Path (Split-Path -Path $CulturePath -Parent) -ChildPath 'en-US') `
            -ChildPath ("{0}.md" -f $command.Name)
        $englishContent = if (Test-Path -LiteralPath $englishPath -PathType Leaf) {
            Get-Content -LiteralPath $englishPath -Raw -ErrorAction Stop
        }
        else {
            $null
        }

        if ($englishContent) {
            $englishParameterDescriptions = Get-MarkdownParameterDescriptionTable -Path $englishPath
        }

        if (Test-Path -LiteralPath $existingPath -PathType Leaf) {
            $existingContent = Get-Content -LiteralPath $existingPath -Raw -ErrorAction Stop
            try {
                $null = Import-MarkdownCommandHelp -LiteralPath $existingPath -ErrorAction Stop

                foreach ($heading in @('SYNOPSIS', 'DESCRIPTION', 'EXAMPLES', 'INPUTS', 'OUTPUTS', 'NOTES')) {
                    $localizedSection = Get-MarkdownSection -Content $existingContent -Heading $heading
                    if (-not [string]::IsNullOrWhiteSpace($localizedSection) -and
                        $localizedSection -notmatch '\{\{') {
                        $mergedContent = Set-MarkdownSection -Content $mergedContent -Heading $heading -Body $localizedSection
                    }
                    elseif ($englishContent) {
                        $englishSection = Get-MarkdownSection -Content $englishContent -Heading $heading
                        if (-not [string]::IsNullOrWhiteSpace($englishSection) -and
                            $englishSection -notmatch '\{\{') {
                            $mergedContent = Set-MarkdownSection -Content $mergedContent -Heading $heading -Body $englishSection
                        }
                    }
                }
            }
            catch {
                Write-Warning "Reconstructed incomplete help topic '$existingPath' from module metadata."
            }

            $parameterDescriptions = Get-MarkdownParameterDescriptionTable -Path $existingPath
        }

        $translations = $parameterTranslations[$Culture]
        foreach ($parameter in $command.Parameters.Values) {
            $description = $null
            if ($parameterDescriptions.ContainsKey($parameter.Name) -and
                -not [string]::IsNullOrWhiteSpace($parameterDescriptions[$parameter.Name]) -and
                $parameterDescriptions[$parameter.Name] -notmatch '\{\{') {
                $description = $parameterDescriptions[$parameter.Name]
            }
            elseif ($translations -and $translations.ContainsKey($parameter.Name)) {
                $description = $translations[$parameter.Name]
            }
            elseif ($parameterFallbacks.ContainsKey($command.Name) -and
                $parameterFallbacks[$command.Name].ContainsKey($parameter.Name)) {
                $description = $parameterFallbacks[$command.Name][$parameter.Name]
            }
            elseif ($commonParameterFallbacks.ContainsKey($parameter.Name)) {
                $description = $commonParameterFallbacks[$parameter.Name]
            }
            elseif ($englishParameterDescriptions.ContainsKey($parameter.Name) -and
                $englishParameterDescriptions[$parameter.Name] -notmatch '\{\{') {
                $description = $englishParameterDescriptions[$parameter.Name]
            }

            if (-not [string]::IsNullOrWhiteSpace($description)) {
                $mergedContent = Set-MarkdownParameterDescription `
                    -Content $mergedContent `
                    -ParameterName $parameter.Name `
                    -Description $description
            }
        }

        $commandAliases = New-Object 'System.Collections.Generic.List[string]'
        foreach ($alias in Get-Alias -ErrorAction SilentlyContinue) {
            if ($alias.ResolvedCommand -and $alias.ResolvedCommand.Name -eq $command.Name) {
                [void]$commandAliases.Add($alias.Name)
            }
        }
        $commandAliases = @($commandAliases | Sort-Object -Unique)
        $aliasDescription = if ($commandAliases.Count -gt 0) {
            ($commandAliases | ForEach-Object { '- `{0}`' -f $_ }) -join "`r`n"
        }
        else {
            'This command has no aliases.'
        }
        $mergedContent = Set-MarkdownSection -Content $mergedContent -Heading 'ALIASES' -Body $aliasDescription

        [System.IO.File]::WriteAllText($existingPath, $mergedContent, $utf8NoBom)
    }
}
finally {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
