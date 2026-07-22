---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

Crie um novo arquivo colorscript e, opcionalmente, emita orientação de metadados.

## SYNTAX

### Scaffold

```
New-ColorScript -Name <string> -OutputPath <string> [-h] [-Force] [-GenerateMetadataSnippet]
 [-Category <string[]>] [-Tag <string[]>] [-OpenInEditor] [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScript [-h] [-Name <string>] [-WhatIf] [-Confirm]
```

## ALIASES

Este comando não tem aliases.

## DESCRIPTION

O cmdlet `New-ColorScript` cria uma estrutura colorscript mínima contendo uma matriz string e um loop que grava cada linha. O arquivo é codificado como UTF-8 sem uma marca de ordem de bytes (BOM). Orientações opcionais de metadados podem ser incluídas como um comentário no arquivo gerado e retornadas no objeto de resultado.

Tanto `-Name` quanto `-OutputPath` são obrigatórios em andaimes. `-OutputPath` identifica um diretório; o comando cria o diretório quando necessário e grava `<Name>.ps1` nele.

Os nomes dos scripts devem seguir as convenções de nomenclatura PowerShell: devem começar com um caractere alfanumérico e podem incluir sublinhados ou hífens. A extensão `.ps1` é anexada automaticamente se não for fornecida. Os arquivos existentes são protegidos contra substituições acidentais, a menos que a opção `-Force` seja especificada explicitamente.

Quando combinado com `-GenerateMetadataSnippet`, o cmdlet retorna orientações que descrevem a entrada a ser adicionada a `ScriptMetadata.psd1`. Os valores de categoria e tag fornecidos também são retornados como matrizes no objeto de resultado.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -OutputPath ./ColorScripts-Enhanced/Scripts -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Cria `my-spectrum.ps1` no diretório solicitado e retorna um objeto contendo o caminho do arquivo e orientação de metadados.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Gera o scaffold em um diretório customizado (`~/Dev/colorscripts`), criando o diretório se ele não existir. Se um arquivo chamado `holiday-banner.ps1` já existir nesse local, ele será substituído devido à opção `-Force`.

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -OutputPath ./ColorScripts-Enhanced/Scripts -Category 'Artistic' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

Cria um novo colorscript e copia a orientação dos metadados para a área de transferência, facilitando a colagem no `ScriptMetadata.psd1`.

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

Mostra o que aconteceria ao criar um script de padrão de teste no diretório `.\temp` sem realmente criar o arquivo. Útil para validar caminhos e nomes antes da execução.

### EXAMPLE 5

```powershell
# Crie vários colorscripts para um projeto
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "$($scriptNames.Count) modelos de colorscript criados"
```

Cria vários modelos colorscript em lote para um projeto.

### EXAMPLE 6

```powershell
# Crie e abra imediatamente no editor
New-ColorScript -Name "my-art" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -GenerateMetadataSnippet -OpenInEditor
```

Cria um colorscript e pede ao manipulador registrado da plataforma para abri-lo.

### EXAMPLE 7

```powershell
# Crie com automação total do fluxo de trabalho
$newScript = New-ColorScript -Name "interactive-demo" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Custom" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "Criado: $($newScript.Name)"
Write-Host "Caminho: $($newScript.Path)"
Write-Host "Orientações de metadados copiadas para a área de transferência"
$newScript.MetadataGuidance | Set-Clipboard
```

Cria um colorscript com orientação de metadados copiado automaticamente para a área de transferência.

### EXAMPLE 8

```powershell
# Verifique as convenções de nomes de scripts
$validName = "123-start"
$invalidNames = @("-invalid", "_underscore-only", "contains space")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -OutputPath ./temp -WhatIf -ErrorAction Stop
    } catch {
        Write-Warning "Nome inválido '$name': $_"
    }
}
```

Demonstra a validação da convenção de nomenclatura para colorscripts.

### EXAMPLE 9

```powershell
# Crie em local portátil para distribuição
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "Colorscript portátil criado em: $($scaffold.Path)"
```

Cria colorscripts em um local portátil relativo ao script atual.

### EXAMPLE 10

```powershell
# Crie com validação de categoria e tag
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -Tag "Fun","Social"
} else {
    Write-Warning "Categoria Retro não encontrada"
}
```

Valida a existência de uma categoria antes de criar um novo colorscript.

## PARAMETERS

### -Category

Especifica uma ou mais categorias retornadas com o scaffold e incluídas na orientação de metadados. Os valores devem estar alinhados com as categorias já utilizadas em `ScriptMetadata.psd1`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Solicita confirmação antes de executar o cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Force

Substitui o arquivo de destino se ele já existir. Sem essa opção, o cmdlet terminará com um erro se um arquivo com o mesmo nome for encontrado no local de destino. Use com cuidado para evitar perda de dados.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Overwrite
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GenerateMetadataSnippet

Inclui um trecho de orientação na saída que demonstra como registrar o novo script em `ScriptMetadata.psd1`. O snippet usa os valores dos parâmetros `-Category` e `-Tag`, se fornecidos. Isso é particularmente útil para manter metadados consistentes em todos os colorscripts do módulo.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -h

Exibe ajuda detalhada para este comando sem executar a operação.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- help
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Especifica o nome do novo colorscript. O nome deve começar com um caractere alfanumérico e pode incluir sublinhados ou hifens. A extensão `.ps1` é anexada automaticamente se não for incluída. Este nome será usado como nome do arquivo e deve ser descritivo do conteúdo ou tema do script.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OpenInEditor

Abre o colorscript gerado com o comando configurado pelo ambiente quando a criação é bem-sucedida.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputPath

Especifica o diretório de destino obrigatório. O comando cria <Name>.ps1 nesse diretório.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Destination
- Path
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

Especifica uma ou mais tags de metadados para colorscript. Tags fornecem classificação adicional além da categoria primária e são úteis para filtragem e pesquisa. Tags comuns incluem descritores de tema como 'Minimal', 'Colorful', 'Animated', referências de tecnologia como 'Matrix', 'ASCII' ou marcadores contextuais como 'Holiday', 'Season'. Várias tags podem ser especificadas como uma matriz separada por vírgula.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Mostra o que aconteceria se o cmdlet fosse executado sem realmente executar nenhuma ação. Exibe o caminho do arquivo que seria criado e quaisquer verificações de validação que seriam executadas. O cmdlet não cria arquivos ou diretórios quando essa opção é especificada.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

Este cmdlet suporta os parâmetros comuns:
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Para obter mais informações, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Você não pode canalizar objetos para esse cmdlet.

## OUTPUTS

### System.Management.Automation.PSCustomObject

O cmdlet retorna um objeto personalizado com as seguintes propriedades:

- **Name**: O nome colorscript sem a extensão `.ps1`
- **Path**: O caminho completo para o arquivo gerado
- **Categories**: a matriz de valores de categoria que foi especificada (se houver)
- **Tags**: A matriz de valores de tag que foram especificados (se houver)
- **MetadataGuidance**: o texto do snippet de metadados (somente quando -GenerateMetadataSnippet é usado)

## NOTES

**Codificação**: O andaime é escrito com codificação UTF-8 sem marca de ordem de byte (BOM), garantindo compatibilidade entre diferentes plataformas e editores.

**Estrutura do modelo**: o modelo gerado inclui:

- Um comentário de andaime
- Um espaço reservado para matriz string para a arte
- Um loop que escreve cada linha com `Write-Host`

**Integração de metadados**: embora o cmdlet possa gerar orientação de metadados, você deve adicionar manualmente o snippet ao `ScriptMetadata.psd1` para integrar totalmente o script ao sistema de descoberta e categorização do módulo.

**Fluxo de trabalho de desenvolvimento**:

1. Use `New-ColorScript` para criar o andaime
2. Edite o arquivo .ps1 gerado para adicionar sua arte ANSI
3. Se a orientação de metadados foi gerada, copie-a para `ScriptMetadata.psd1`
4. Teste seu script com `Show-ColorScript -Name <your-script-name>`

**Práticas recomendadas**:

- Escolha nomes descritivos e hifenizados que indiquem claramente o tema do roteiro
- Use valores de categoria consistentes que se alinhem com scripts existentes
- Aplique várias tags para melhorar a descoberta
- Teste scripts em diferentes ambientes de terminal para garantir compatibilidade

## RELATED LINKS

- [Versão online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)

