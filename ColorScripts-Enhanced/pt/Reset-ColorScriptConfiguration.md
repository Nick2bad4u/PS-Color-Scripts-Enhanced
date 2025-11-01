---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/pt/Reset-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Redefine a configuração do ColorScripts-Enhanced para os valores padrão.

## SYNTAX

```
Reset-ColorScriptConfiguration [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Restaura as configurações do ColorScripts-Enhanced para seus valores padrão. Este cmdlet remove todas as personalizações do usuário e retorna o módulo ao seu estado de configuração original.

As operações de redefinição incluem:
- Configurações do caminho do cache
- Preferências de desempenho
- Opções de exibição
- Configurações de comportamento do módulo

Este cmdlet é útil quando:
- A configuração se torna corrompida
- Você deseja começar do zero com configurações padrão
- Solução de problemas relacionados à configuração
- Preparação para testes limpos do módulo

A operação de redefinição requer confirmação por padrão para evitar perda acidental de dados.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration
```

Redefine todas as configurações para os padrões com prompt de confirmação.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Redefine a configuração sem prompt de confirmação.

### EXAMPLE 3

```powershell
Reset-ColorScriptConfiguration -WhatIf
```

Mostra quais alterações de configuração seriam feitas sem aplicá-las.

### EXAMPLE 4

```powershell
# Reset and verify
Reset-ColorScriptConfiguration
Get-ColorScriptConfiguration
```

Redefine a configuração e exibe as novas configurações padrão.

## PARAMETERS

### -Confirm

Solicita confirmação antes de executar o cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: true
SupportsWildcards: false
Aliases: cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Mostra o que aconteceria se o cmdlet fosse executado. O cmdlet não é executado.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: false
SupportsWildcards: false
Aliases: wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

Este cmdlet suporta os parâmetros comuns: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction e -WarningVariable. Para mais informações, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet não aceita entrada do pipeline.

## OUTPUTS

### None

Este cmdlet não retorna saída para o pipeline.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

**Escopo da Redefinição:**
Redefine todas as configurações configuráveis pelo usuário para os padrões do módulo. Isso inclui caminhos de cache, configurações de desempenho e preferências de exibição.

**Segurança de Dados:**
A redefinição da configuração não afeta a saída do script em cache ou colorscripts criados pelo usuário. Apenas as configurações são afetadas.

**Recuperação:**
Após a redefinição, use Set-ColorScriptConfiguration para reaplicar configurações personalizadas, se necessário.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
