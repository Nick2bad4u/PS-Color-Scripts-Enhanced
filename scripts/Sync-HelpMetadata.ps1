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
    [string]$PlatyModuleName,

    [Parameter(Mandatory)]
    [version]$PlatyModuleVersion,

    [Parameter(Mandatory)]
    [ValidatePattern('^\d{2}/\d{2}/\d{4}$')]
    [string]$MetadataDate
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

# These English fallbacks are used only for en-US. Non-English topics must provide localized
# prose or an explicit entry in $parameterTranslations; silently copying English text would
# make a generated help package look complete while leaving it partially untranslated.
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
        OutputPath              = 'Specifies the mandatory target directory. The command creates <Name>.ps1 within this directory.'
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

# These culture-specific descriptions encode command contracts that previously drifted across
# translated topics. They intentionally override preserved prose with an accurate translation.
$authoritativeParameterDescriptions = @{
    'en-US' = @{
        'Add-ColorScriptProfile' = @{
            Force = 'Updates recognized ColorScripts-Enhanced profile content while preserving unrelated profile lines. It does not deliberately append duplicate managed blocks.'
        }
        'New-ColorScript' = @{
            OutputPath = 'Specifies the mandatory target directory. The command creates <Name>.ps1 within this directory.'
        }
    }
    de      = @{
        'Add-ColorScriptProfile' = @{
            Force = 'Aktualisiert erkannte ColorScripts-Enhanced-Profilinhalte und behält dabei nicht zugehörige Profilzeilen bei. Es werden nicht absichtlich doppelte verwaltete Blöcke angefügt.'
        }
        'New-ColorScript' = @{
            OutputPath = 'Gibt das obligatorische Zielverzeichnis an. Der Befehl erstellt in diesem Verzeichnis <Name>.ps1.'
        }
    }
    es      = @{
        'Add-ColorScriptProfile' = @{
            Force = 'Actualiza el contenido reconocido de ColorScripts-Enhanced en el perfil y conserva las líneas no relacionadas. No agrega deliberadamente bloques administrados duplicados.'
        }
        'New-ColorScript' = @{
            OutputPath = 'Especifica el directorio de destino obligatorio. El comando crea <Name>.ps1 dentro de este directorio.'
        }
    }
    fr      = @{
        'Add-ColorScriptProfile' = @{
            Force = 'Met à jour le contenu ColorScripts-Enhanced reconnu dans le profil tout en conservant les lignes sans rapport. Il ne crée pas volontairement de blocs gérés en double.'
        }
        'New-ColorScript' = @{
            OutputPath = 'Spécifie le répertoire cible obligatoire. La commande crée <Name>.ps1 dans ce répertoire.'
        }
    }
    it      = @{
        'Add-ColorScriptProfile' = @{
            Force = 'Aggiorna il contenuto ColorScripts-Enhanced riconosciuto nel profilo, conservando le righe non correlate. Non aggiunge intenzionalmente blocchi gestiti duplicati.'
        }
        'New-ColorScript' = @{
            OutputPath = 'Specifica la directory di destinazione obbligatoria. Il comando crea <Name>.ps1 in questa directory.'
        }
    }
    ja      = @{
        'Add-ColorScriptProfile' = @{
            Force = '関連のないプロファイル行を保持しながら、認識された ColorScripts-Enhanced のプロファイル内容を更新します。管理対象ブロックを意図的に重複して追加することはありません。'
        }
        'New-ColorScript' = @{
            OutputPath = '必須の出力先ディレクトリを指定します。このコマンドは、そのディレクトリ内に <Name>.ps1 を作成します。'
        }
    }
    nl      = @{
        'Add-ColorScriptProfile' = @{
            Force = 'Werkt herkende ColorScripts-Enhanced-profielinhoud bij en behoudt niet-gerelateerde profielregels. Er worden niet opzettelijk dubbele beheerde blokken toegevoegd.'
        }
        'New-ColorScript' = @{
            OutputPath = 'Geeft de verplichte doelmap op. De opdracht maakt <Name>.ps1 in deze map.'
        }
    }
    pt      = @{
        'Add-ColorScriptProfile' = @{
            Force = 'Atualiza o conteúdo reconhecido do ColorScripts-Enhanced no perfil, preservando as linhas não relacionadas. Não acrescenta deliberadamente blocos geridos duplicados.'
        }
        'New-ColorScript' = @{
            OutputPath = 'Especifica o diretório de destino obrigatório. O comando cria <Name>.ps1 nesse diretório.'
        }
    }
    ru      = @{
        'Add-ColorScriptProfile' = @{
            Force = 'Обновляет распознанное содержимое ColorScripts-Enhanced в профиле, сохраняя несвязанные строки. Команда намеренно не добавляет повторяющиеся управляемые блоки.'
        }
        'New-ColorScript' = @{
            OutputPath = 'Задает обязательный целевой каталог. Команда создает в нем файл <Name>.ps1.'
        }
    }
    'zh-CN' = @{
        'Add-ColorScriptProfile' = @{
            Force = '更新配置文件中识别出的 ColorScripts-Enhanced 内容，同时保留不相关的行。此参数不会故意追加重复的托管块。'
        }
        'New-ColorScript' = @{
            OutputPath = '指定必需的目标目录。该命令会在此目录中创建 <Name>.ps1。'
        }
    }
}

$localizedMetadataText = @{
    'en-US' = @{
        NoAliases                     = 'This command has no aliases.'
        NoNotes                       = 'None.'
        OnlineVersion                 = 'Online Version'
        CommonParametersIntro         = 'This cmdlet supports the common parameters:'
        CommonParametersMoreInfo      = 'For more information, see'
        CommonParametersLinkSuffix    = '.'
    }
    de      = @{
        NoAliases                     = 'Dieser Befehl hat keine Aliase.'
        NoNotes                       = 'Keine.'
        OnlineVersion                 = 'Onlineversion'
        CommonParametersIntro         = 'Dieses Cmdlet unterstützt die allgemeinen Parameter:'
        CommonParametersMoreInfo      = 'Weitere Informationen finden Sie unter'
        CommonParametersLinkSuffix    = '.'
    }
    es      = @{
        NoAliases                     = 'Este comando no tiene alias.'
        NoNotes                       = 'Ninguna.'
        OnlineVersion                 = 'Versión en línea'
        CommonParametersIntro         = 'Este cmdlet admite los parámetros comunes:'
        CommonParametersMoreInfo      = 'Para obtener más información, consulte'
        CommonParametersLinkSuffix    = '.'
    }
    fr      = @{
        NoAliases                     = 'Cette commande ne possède aucun alias.'
        NoNotes                       = 'Aucune.'
        OnlineVersion                 = 'Version en ligne'
        CommonParametersIntro         = 'Cette applet de commande prend en charge les paramètres communs :'
        CommonParametersMoreInfo      = 'Pour plus d''informations, consultez'
        CommonParametersLinkSuffix    = '.'
    }
    it      = @{
        NoAliases                     = 'Questo comando non ha alias.'
        NoNotes                       = 'Nessuna.'
        OnlineVersion                 = 'Versione online'
        CommonParametersIntro         = 'Questo cmdlet supporta i parametri comuni:'
        CommonParametersMoreInfo      = 'Per ulteriori informazioni, vedere'
        CommonParametersLinkSuffix    = '.'
    }
    ja      = @{
        NoAliases                     = 'このコマンドにはエイリアスがありません。'
        NoNotes                       = 'ありません。'
        OnlineVersion                 = 'オンライン バージョン'
        CommonParametersIntro         = 'このコマンドレットは、次の共通パラメーターをサポートします:'
        CommonParametersMoreInfo      = '詳細については、次を参照してください:'
        CommonParametersLinkSuffix    = '。'
    }
    nl      = @{
        NoAliases                     = 'Deze opdracht heeft geen aliassen.'
        NoNotes                       = 'Geen.'
        OnlineVersion                 = 'Onlineversie'
        CommonParametersIntro         = 'Deze cmdlet ondersteunt de algemene parameters:'
        CommonParametersMoreInfo      = 'Zie voor meer informatie'
        CommonParametersLinkSuffix    = '.'
    }
    pt      = @{
        NoAliases                     = 'Este comando não tem aliases.'
        NoNotes                       = 'Nenhuma.'
        OnlineVersion                 = 'Versão online'
        CommonParametersIntro         = 'Este cmdlet suporta os parâmetros comuns:'
        CommonParametersMoreInfo      = 'Para obter mais informações, consulte'
        CommonParametersLinkSuffix    = '.'
    }
    ru      = @{
        NoAliases                     = 'У этой команды нет псевдонимов.'
        NoNotes                       = 'Нет.'
        OnlineVersion                 = 'Онлайн-версия'
        CommonParametersIntro         = 'Этот командлет поддерживает следующие общие параметры:'
        CommonParametersMoreInfo      = 'Дополнительные сведения см. в разделе'
        CommonParametersLinkSuffix    = '.'
    }
    'zh-CN' = @{
        NoAliases                     = '此命令没有别名。'
        NoNotes                       = '无。'
        OnlineVersion                 = '在线版本'
        CommonParametersIntro         = '此 cmdlet 支持以下常用参数：'
        CommonParametersMoreInfo      = '有关详细信息，请参阅'
        CommonParametersLinkSuffix    = '。'
    }
}

if (-not $parameterTranslations.ContainsKey($Culture) -or
    -not $authoritativeParameterDescriptions.ContainsKey($Culture) -or
    -not $localizedMetadataText.ContainsKey($Culture)) {
    throw "Culture '$Culture' does not have complete help synchronization metadata."
}

$cultureAuthoritativeDescriptions = $authoritativeParameterDescriptions[$Culture]
$cultureMetadataText = $localizedMetadataText[$Culture]

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

function Set-MarkdownCommonParametersDescription {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Description
    )

    $pattern = '(?ms)(^### CommonParameters\s*\r?\n).*?(?=^## |\z)'
    if (-not [regex]::IsMatch($Content, $pattern)) {
        throw 'Generated help does not contain the expected CommonParameters subsection.'
    }

    $replacementDescription = $Description.Trim()
    return [regex]::Replace($Content, $pattern, [System.Text.RegularExpressions.MatchEvaluator] {
            param($match)
            return $match.Groups[1].Value.TrimEnd() + "`r`n`r`n$replacementDescription`r`n`r`n"
        }, 1)
}

Import-Module -Name $ModuleManifestPath -Force -ErrorAction Stop
Import-Module `
    -Name $PlatyModuleName `
    -RequiredVersion $PlatyModuleVersion `
    -Force `
    -ErrorAction Stop

# PlatyPS 1.0.x reads optional CommandInfo properties dynamically and is not compatible with
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
        $mergedContent = [regex]::Replace(
            $mergedContent,
            '(?im)^ms\.date:\s*.*$',
            "ms.date: $MetadataDate"
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
                    $englishSection = if ($englishContent) {
                        Get-MarkdownSection -Content $englishContent -Heading $heading
                    }
                    else {
                        $null
                    }

                    if ($heading -eq 'NOTES' -and
                        [string]::IsNullOrWhiteSpace($localizedSection) -and
                        [string]::IsNullOrWhiteSpace($englishSection)) {
                        $mergedContent = Set-MarkdownSection `
                            -Content $mergedContent `
                            -Heading $heading `
                            -Body $cultureMetadataText.NoNotes
                    }
                    elseif (-not [string]::IsNullOrWhiteSpace($localizedSection) -and
                        $localizedSection -notmatch '\{\{') {
                        $mergedContent = Set-MarkdownSection -Content $mergedContent -Heading $heading -Body $localizedSection
                    }
                    elseif ($Culture -eq 'en-US' -and $englishContent) {
                        if (-not [string]::IsNullOrWhiteSpace($englishSection) -and
                            $englishSection -notmatch '\{\{') {
                            $mergedContent = Set-MarkdownSection -Content $mergedContent -Heading $heading -Body $englishSection
                        }
                    }
                    elseif ($Culture -ne 'en-US' -and
                        (-not [string]::IsNullOrWhiteSpace($englishSection) -or
                        -not [string]::IsNullOrWhiteSpace($localizedSection))) {
                        throw "Localized section '$heading' is missing or incomplete in '$existingPath'."
                    }
                }
            }
            catch {
                if ($Culture -ne 'en-US') {
                    throw
                }

                Write-Warning "Reconstructed incomplete help topic '$existingPath' from module metadata."
            }

            $parameterDescriptions = Get-MarkdownParameterDescriptionTable -Path $existingPath
        }

        $translations = $parameterTranslations[$Culture]
        foreach ($parameter in $command.Parameters.Values) {
            $description = $null
            if ($cultureAuthoritativeDescriptions.ContainsKey($command.Name) -and
                $cultureAuthoritativeDescriptions[$command.Name].ContainsKey($parameter.Name)) {
                $description = $cultureAuthoritativeDescriptions[$command.Name][$parameter.Name]
            }
            elseif ($parameterDescriptions.ContainsKey($parameter.Name) -and
                -not [string]::IsNullOrWhiteSpace($parameterDescriptions[$parameter.Name]) -and
                $parameterDescriptions[$parameter.Name] -notmatch '\{\{') {
                $description = $parameterDescriptions[$parameter.Name]
            }
            elseif ($translations -and $translations.ContainsKey($parameter.Name)) {
                $description = $translations[$parameter.Name]
            }
            elseif ($Culture -eq 'en-US' -and
                $parameterFallbacks.ContainsKey($command.Name) -and
                $parameterFallbacks[$command.Name].ContainsKey($parameter.Name)) {
                $description = $parameterFallbacks[$command.Name][$parameter.Name]
            }
            elseif ($Culture -eq 'en-US' -and $commonParameterFallbacks.ContainsKey($parameter.Name)) {
                $description = $commonParameterFallbacks[$parameter.Name]
            }
            elseif ($Culture -eq 'en-US' -and
                $englishParameterDescriptions.ContainsKey($parameter.Name) -and
                $englishParameterDescriptions[$parameter.Name] -notmatch '\{\{') {
                $description = $englishParameterDescriptions[$parameter.Name]
            }

            if (-not [string]::IsNullOrWhiteSpace($description)) {
                $mergedContent = Set-MarkdownParameterDescription `
                    -Content $mergedContent `
                    -ParameterName $parameter.Name `
                    -Description $description
            }
            elseif ($Culture -ne 'en-US' -and
                $mergedContent -match ('(?m)^### -{0}\s*$' -f [regex]::Escape($parameter.Name))) {
                throw "Localized description for parameter '$($parameter.Name)' is missing in '$existingPath'."
            }
        }

        $commonParametersDescription = @(
            $cultureMetadataText.CommonParametersIntro
            $cultureMetadataText.CommonParametersMoreInfo
            ('[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216){0}' -f
            $cultureMetadataText.CommonParametersLinkSuffix)
        ) -join "`r`n"
        $mergedContent = Set-MarkdownCommonParametersDescription `
            -Content $mergedContent `
            -Description $commonParametersDescription

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
            $cultureMetadataText.NoAliases
        }
        $mergedContent = Set-MarkdownSection -Content $mergedContent -Heading 'ALIASES' -Body $aliasDescription

        $helpUri = [string]$command.HelpUri
        if (-not [string]::IsNullOrWhiteSpace($helpUri)) {
            # PlatyPS can import related links from the existing external-help XML and then
            # append CommandInfo.HelpUri again. Replacing this generated section makes help
            # builds idempotent and prevents another duplicate on every regeneration.
            $relatedLinks = '- [{0}]({1})' -f $cultureMetadataText.OnlineVersion, $helpUri
            $mergedContent = Set-MarkdownSection `
                -Content $mergedContent `
                -Heading 'RELATED LINKS' `
                -Body $relatedLinks
        }

        [System.IO.File]::WriteAllText($existingPath, $mergedContent, $utf8NoBom)
    }
}
finally {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
