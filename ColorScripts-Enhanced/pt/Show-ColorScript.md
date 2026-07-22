---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Exibe um colorscript com cache seletivo para renderizadores caros.

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Help

```
Show-ColorScript [-h] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Named

```
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### List

```
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### All

```
Show-ColorScript [-All] [-WaitForInput] [-NoClear] [-NoCache] [-Category <string[]>]
 [-Tag <string[]>] [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

## ALIASES

- `scs`

## DESCRIPTION

Renderiza lindos ANSI colorscripts em seu terminal com otimização de desempenho inteligente. O cmdlet fornece quatro modos principais de operação:

**Modo aleatório (padrão):** Exibe um colorscript selecionado aleatoriamente da coleção disponível. Este é o comportamento padrão quando nenhum parâmetro é especificado.

**Modo Nomeado:** Exibe um colorscript específico por nome. Suporta padrões curinga para correspondência flexível. Quando vários scripts correspondem a um padrão, a primeira correspondência em ordem alfabética é selecionada.

**Modo de lista:** Exibe uma tabela compacta contendo nomes colorscript e categorias primárias. Use `Get-ColorScriptList -AsObject` para registros completos de metadados.

**Todos os modos:** Percorre todos os colorscripts disponíveis em ordem alfabética. Particularmente útil para mostrar toda a coleção ou descobrir novos roteiros.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Exibe um colorscript aleatório. Scripts agrupados determinísticos são renderizados em processo; renderizadores computacionais qualificados podem reutilizar a saída em cache validada.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Exibe o colorscript especificado pelo nome exato. A extensão .ps1 não é necessária.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Exibe o primeiro colorscript (em ordem alfabética) que corresponde ao padrão curinga "aurora-\*". Útil quando você lembra parte do nome de um script.

### EXAMPLE 4

```powershell
scs hearts
```

Usa o alias do módulo 'scs' para acesso rápido aos corações colorscript. Os aliases fornecem atalhos convenientes para uso frequente.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Lista colorscripts disponível por nome e categoria primária. Útil para descoberta rápida.

### EXAMPLE 6

```powershell
Show-ColorScript -Name Galaxy -NoCache
```

Exibe o renderizador Galaxy elegível sem ler a saída em cache, forçando uma nova renderização isolada. Útil ao testar alterações no renderizador ou investigar corrupção de cache.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Exibe um script aleatório com tema natural e captura seu objeto de metadados para inspeção ou processamento adicional.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Renderiza o colorscript e salva a saída em um arquivo de texto. Os códigos ANSI renderizados são preservados, permitindo que o arquivo seja exibido posteriormente com a coloração adequada.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Exibe todos os colorscripts em ordem alfabética com um breve atraso automático entre cada um. Perfeito para uma vitrine visual de toda a coleção.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Exibe todos os colorscripts, um de cada vez, pausando após cada um. Pressione a barra de espaço para avançar para o próximo script ou pressione 'q' para encerrar a sequência antecipadamente.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Percorre todos os colorscripts com tema natural com progressão manual. Combina filtragem com navegação interativa para uma experiência selecionada.

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

Exibe um colorscript aleatório que possui a tag "retro" ou "geometric". Vários valores de tag usam semântica de qualquer correspondência.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Artistic,Abstract
```

Lista apenas colorscripts categorizados como "Art" ou "Abstract", ajudando você a descobrir scripts dentro de temas específicos.

### EXAMPLE 14

```powershell
# Inspecione a elegibilidade do cache e o status de build de um renderizador selecionado por política.
New-ColorScriptCache -Name Galaxy -Force -PassThru |
    Select-Object Name, Status, CacheFile
Show-ColorScript -Name Galaxy
```

Constrói e inspeciona uma entrada de cache para um renderizador qualificado sem reivindicar um multiplicador de desempenho independente da máquina.

### EXAMPLE 15

```powershell
# Configure a rotação diária de diferentes colorscripts
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

Exibe um colorscript consistente, mas diferente a cada dia com base na data.

### EXAMPLE 16

```powershell
# Exporte colorscript renderizado para arquivo para compartilhamento
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Mais tarde, exiba o arquivo salvo
Get-Content "./aurora.ansi" -Raw | Write-Host
```

Salva um colorscript renderizado em um arquivo que pode ser exibido posteriormente ou compartilhado com outras pessoas.

### EXAMPLE 17

```powershell
# Crie uma apresentação de slides de colorscripts geométrico
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Exibe automaticamente uma sequência de colorscripts geométricos com atrasos de 3 segundos entre cada um.

### EXAMPLE 18

```powershell
# Exemplo de tratamento de erros
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Script não encontrado: $_"
    Show-ColorScript  # Fallback para aleatório
}
```

Demonstra tratamento de erros ao solicitar um script que não existe.

### EXAMPLE 19

```powershell
# Construir integração de automação
if ($env:CI) {
    Show-ColorScript -Name "Galaxy" -NoCache
} else {
    Show-ColorScript  # Exibição aleatória para uso interativo
}
```

Mostra como exibir condicionalmente diferentes colorscripts em ambientes CI/CD versus sessões interativas.

### EXAMPLE 20

```powershell
# Tarefa agendada para saudação do terminal
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Demonstra a execução de um colorscript específico como parte de uma tarefa agendada ou automação de inicialização.

### EXAMPLE 21

```powershell
Show-ColorScript -IncludePokemon
```

Exibe um colorscript aleatório incluindo scripts na categoria `Pokemon`. Útil quando você deseja incluir arte de Pokémon em sua seleção aleatória.

### EXAMPLE 22

```powershell
Show-ColorScript -Random -ExcludeCategory Pokemon,Gaming
```

Exibe um colorscript aleatório, excluindo as categorias `Pokemon` e `Gaming`. Combine com `-Category` ou `-Tag` para refinar ainda mais a seleção.

## PARAMETERS

### -All

Percorra todos os colorscripts disponíveis em ordem alfabética. Quando especificados sozinhos, os scripts são exibidos continuamente com um pequeno atraso automático. Combine com `-WaitForInput` para controlar manualmente a progressão na coleção. Este modo é ideal para exibir a biblioteca completa ou descobrir novos favoritos.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Category

Filtre a coleção de scripts disponíveis por uma ou mais categorias antes de ocorrer qualquer seleção ou exibição. As categorias são normalmente temas amplos como "Natureza", "Abstrato", "Arte", "Retrô" etc. Múltiplas categorias podem ser especificadas como uma matriz. Este parâmetro funciona em conjunto com todos os modos (Aleatório, Nomeado, Lista, Todos) para restringir o conjunto de trabalho.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -ExcludeCategory

Exclua scripts de uma ou mais categorias antes que a seleção ocorra. Por exemplo, use `-ExcludeCategory Pokemon` para evitar todos os scripts Pokémon ou especifique várias categorias, como `-ExcludeCategory Pokemon,Gaming`. Funciona em todos os modos (Aleatório, Nomeado, Lista, Todos) e combina com os filtros `-Category` e `-Tag`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -h

Exibe ajuda detalhada para este comando sem executar a operação.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- help
ParameterSets:
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

### -IncludePokemon

Sinalizador de ativação para incluir Pokémon colorscripts na seleção. Quando omitido, os scripts Pokémon são filtrados automaticamente (padrão). Observação: isso substitui o parâmetro `-ExcludePokemon` mais antigo — a refatoração inverteu a semântica, então agora você pode optar por mostrar scripts Pokémon em vez de cancelar.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
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

### -List

Exiba uma lista formatada de todos os colorscripts disponíveis com seus metadados associados. A saída inclui nome do script, categoria, tags e descrição. Isto é útil para explorar as opções disponíveis e compreender a organização da coleção. Pode ser combinado com `-Category` ou `-Tag` para listar apenas subconjuntos filtrados.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: List
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

O nome do colorscript a ser exibido (sem a extensão .ps1). Suporta padrões curinga (\* e?) para correspondência flexível. Quando vários scripts correspondem a um padrão curinga, a primeira correspondência em ordem alfabética é selecionada e exibida. Use `-PassThru` para verificar qual script foi escolhido ao usar curingas.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Named
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

Desativa o estilo ANSI em mensagens informativas e saída renderizada para ambientes de texto simples.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- NoColor
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

### -NoCache

Ignora leituras de cache validadas para renderizadores selecionados por política e força uma nova renderização isolada. Isso é útil ao testar alterações no renderizador ou investigar corrupção de cache. Scripts agrupados determinísticos e scripts não listados ou personalizados já ignoram o cache; o conteúdo determinístico agrupado ainda é renderizado em processo.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
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

### -NoClear

Quando usado com `-All`, ignore a chamada automática `Clear-Host` entre colorscripts para que cada script renderizado permaneça visível acima do próximo. Isso é particularmente útil quando você deseja comparar scripts lado a lado ou capturar todo o mostruário em transcrições de sessões.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PassThru

Retorne o objeto de metadados do colorscript selecionado para o pipeline, além de exibir o colorscript. O objeto de metadados contém propriedades como Nome, Path, Categoria, Tags e Descrição. Isso permite acesso programático às informações do script para filtragem, registro ou processamento adicional enquanto ainda renderiza a saída visual.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Named
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Quiet

Suprime mensagens informativas enquanto preserva a saída de comandos e erros.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
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

### -Random

Solicite explicitamente uma seleção aleatória de colorscript. Este é o comportamento padrão quando nenhum nome é especificado, portanto, essa opção é útil principalmente para maior clareza em scripts ou quando você deseja ser explícito sobre o modo de seleção. Pode ser combinado com `-Category` ou `-Tag` para randomizar dentro de um subconjunto filtrado.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ReturnText

Emita o colorscript renderizado como string para o pipeline PowerShell em vez de gravar diretamente no host do console. Isso permite que a saída seja capturada em uma variável, redirecionada para um arquivo ou canalizada para outros comandos. A saída retém todas as sequências de escape ANSI, portanto, será exibida com as cores adequadas quando for gravada posteriormente em um terminal compatível.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- AsString
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

### -Tag

Filtre a coleção de scripts disponíveis por tags de metadados (sem distinção entre maiúsculas e minúsculas). Tags são descritores mais específicos do que categorias, como "geométrico", "retro", "animado", "mínimo", etc. Várias tags podem ser especificadas como uma matriz. Os scripts que correspondam a qualquer uma das tags especificadas serão incluídos no conjunto de trabalho antes que a seleção ocorra.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -ValidateCache

Atualiza o marcador de metadados do cache no nível do módulo antes da renderização, inclusive quando o diretório de cache já foi inicializado na sessão atual do módulo. Ele não reconstrói entradas do cache de saída nem substitui a validação normal por entrada. Definir `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE` como `1`, `true` ou `yes` solicita a mesma atualização durante a inicialização do cache.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
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

### -WaitForInput

Quando usado com `-All`, faça uma pausa após exibir cada colorscript e aguarde a entrada do usuário antes de continuar. Pressione a barra de espaço para avançar para o próximo script na sequência. Pressione 'q' para sair da sequência mais cedo e retornar ao prompt. Isso proporciona uma experiência de navegação interativa por toda a coleção.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

Este cmdlet não aceita entrada de pipeline. Canalize registros de inventário para `ForEach-Object` e chame `Show-ColorScript -Name $_.Name` ao compor um pipeline.

## OUTPUTS

### System.Object

Quando `-PassThru` é especificado, retorna o objeto de metadados do colorscript selecionado contendo propriedades como Nome, Path, Categoria, Tags e Descrição.

### System.String (2)

Quando `-ReturnText` é especificado, emite o colorscript renderizado como string para o pipeline. Este string contém todas as sequências de escape ANSI para renderização de cores adequada quando exibido em um terminal compatível.

### None

Na operação padrão (sem `-PassThru` ou `-ReturnText`), a saída é gravada diretamente no host do console e nada é retornado ao pipeline.

## NOTES

**Autor:** Nick
**Módulo:** ColorScripts-Enhanced
**Requer:** PowerShell 5.1 ou posterior

## RELATED LINKS

- [Versão online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

