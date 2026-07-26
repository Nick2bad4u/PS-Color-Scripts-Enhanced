---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Recupera as definições de configuração atuais do módulo ColorScripts-Enhanced.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

Este comando não tem aliases.

## DESCRIPTION

`Get-ColorScriptConfiguration` retorna uma cópia da configuração efetiva do módulo. O esquema atual contém:

- **Configurações de cache**: a substituição configurada e o diretório de cache efetivo resolvido
- **Comportamento de inicialização**: `AutoShowOnImport`, `ProfileAutoShow` e `DefaultScript`

A configuração é montada a partir de diversas fontes em ordem de precedência:

1. Padrões do módulo integrado (prioridade mais baixa)
2. Substituições de usuário persistentes do arquivo de configuração
3. `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` para o caminho de cache efetivo retornado

O arquivo de configuração normalmente está localizado em `%APPDATA%\ColorScripts-Enhanced\config.json` no Windows ou `~/.config/ColorScripts-Enhanced/config.json` em sistemas do tipo Unix.

A hashtable retornada é um instantâneo do estado da configuração atual e pode ser inspecionada, clonada ou serializada com segurança sem afetar a configuração ativa.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Exibe a configuração atual usando a visualização de tabela padrão, mostrando todas as configurações de cache e inicialização.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serializa a configuração no formato JSON para registro, depuração ou exportação para outras ferramentas.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.EffectivePath
```

Recupera o diretório de cache resolvido. `Cache.Path` continua sendo a substituição opcional configurada pelo usuário;
`Cache.EffectivePath` mostra o diretório que o módulo realmente usa após os padrões da plataforma e
substituições de ambiente são aplicadas.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.AutoShowOnImport) {
    Write-Host "Os scripts de inicialização estão habilitados"
}
```

Verifica se os scripts de inicialização estão habilitados na configuração atual.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Exibe todas as propriedades de configuração em um formato de lista detalhada para inspeção abrangente.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Caminho do cache: $($config.Cache.Path)"
Write-Host "Exibição automática do perfil: $($config.Startup.ProfileAutoShow)"
Write-Host "Script padrão: $($config.Startup.DefaultScript)"
```

Extrai e exibe propriedades de configuração específicas para fins de auditoria ou script.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Caminho de cache personalizado configurado: $($config.Cache.Path)"
} else {
    Write-Host "Usando o caminho de cache padrão"
}

Write-Host "Caminho de cache efetivo: $($config.Cache.EffectivePath)"
```

Determina se um caminho de cache personalizado está configurado ou usando padrões de módulo.

### EXAMPLE 8

```powershell
$config = Get-ColorScriptConfiguration
$config | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Faz backup da configuração atual em um arquivo JSON para arquivamento ou recuperação de desastres.

### EXAMPLE 9

```powershell
# Compare a configuração atual com os padrões
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Revise a saída -WhatIf para ver o que mudaria
```

Compara a configuração atual com os padrões do módulo para identificar configurações personalizadas.

### EXAMPLE 10

```powershell
# Monitore alterações de configuração entre sessões
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Cria instantâneos de configuração com carimbo de data e hora para rastrear alterações ao longo do tempo.

## PARAMETERS

### -h

Exibe ajuda detalhada para este comando sem executar a operação.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- help
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
Para obter mais informações, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet não aceita entrada de pipeline.

## OUTPUTS

### System.Collections.Hashtable

Retorna uma tabela hash aninhada contendo a seguinte estrutura:

- **Cache** (Hashtable): configurações relacionadas ao cache
  - **Path** (String): substituição opcional do caminho do cache persistente
  - **EffectivePath** (String): Diretório de cache resolvido atualmente usado pelo módulo
- **Startup** (Hashtable): configurações de comportamento de inicialização
  - **AutoShowOnImport** (Booleano): Se a importação invoca o comportamento de exibição de inicialização
  - **ProfileAutoShow** (Booleano): opção padrão de exibição automática para blocos de perfil gerenciados
  - **DefaultScript** (String): Inicialização nomeada opcional colorscript

## NOTES

**Inicialização do módulo**: A configuração é inicializada automaticamente quando o módulo ColorScripts-Enhanced é carregado. Este cmdlet recupera o estado atual da configuração na memória.

**Sem modificações**: chamar esse cmdlet é somente leitura e não modifica nenhuma configuração persistente ou a configuração ativa.

**Segurança de Thread**: A hashtable retornada é uma cópia da configuração, tornando-a segura para acesso simultâneo e modificação sem afetar o estado interno do módulo.

**Performance**: A recuperação da configuração é leve e adequada para chamadas frequentes, pois retorna a configuração armazenada em cache na memória em vez de lê-la no disco.

**Formato de arquivo de configuração**: a configuração persistente usa o formato JSON com codificação UTF-8. A edição manual é suportada, mas não recomendada; use `Set-ColorScriptConfiguration`.

### Melhores práticas

- Consulte a configuração uma vez e reutilize o resultado
- Valide a configuração antes de usar valores
- Monitore a configuração quanto a desvios ao longo do tempo
- Mantenha backups apenas onde eles não puderem expor caminhos específicos da máquina ou dados privados
- Documente quaisquer personalizações feitas na configuração
- Teste primeiro as alterações de configuração em ambientes de não produção
- Use logs de auditoria de configuração para conformidade

## RELATED LINKS

- [Versão online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

