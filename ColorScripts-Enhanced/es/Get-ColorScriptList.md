---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

Listas scripts de colores disponibles con filtrado opcional y salida de metadatos enriquecidos.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

Este comando no tiene alias.

## DESCRIPTION

El cmdlet `Get-ColorScriptList` recupera y muestra todos los scripts de colores empaquetados con el módulo ColorScripts-Enhanced. Proporciona opciones de filtrado flexibles y múltiples formatos de salida para adaptarse a diferentes casos de uso.

De forma predeterminada, el cmdlet muestra una tabla formateada concisa que muestra los nombres y categorías de script. El conmutador `-Detailed` amplía esta vista para incluir etiquetas y descripciones, lo que proporciona más contexto de un vistazo.

El cmdlet siempre devuelve registros de metadatos a la canalización exitosa. Sin `-AsObject`, también escribe una vista de host formateada; `-AsObject` suprime ese formato de host para una automatización limpia. Los registros incluyen nombre, ruta, categoría, categorías, etiquetas, descripción y la propiedad de metadatos original.

Las capacidades de filtrado le permiten reducir la lista por:

- **Name**: Admite patrones comodín (p. ej., `aurora-*`) para una coincidencia flexible
- **Category**: Filtrar por uno o más nombres de categoría (no distingue entre mayúsculas y minúsculas)
- **Tag**: filtrar por etiquetas de metadatos como "Recommended" o "Animated" (no distingue entre mayúsculas y minúsculas)

El cmdlet valida los patrones de filtro y genera advertencias para cualquier patrón de nombre que no coincida, lo que le ayuda a identificar posibles errores tipográficos o scripts faltantes.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Muestra todos los scripts de colores disponibles en un formato de tabla compacta que muestra el nombre y la categoría de cada script.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

Muestra todos los scripts de colores con columnas adicionales que incluyen etiquetas y descripciones para una descripción general completa.

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

Muestra solo scripts en la categoría "Patterns" con metadatos completos que incluyen etiquetas y descripciones.

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

Devuelve objetos estructurados para cada script cuyo nombre coincida con el patrón comodín y luego selecciona solo las propiedades Name y Tags para su visualización.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

Recupera todos los scripts etiquetados como "Recommended" y los ordena alfabéticamente por nombre. Útil para encontrar scripts seleccionado adecuado para la integración de perfiles.

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

Combina el filtrado de categorías y etiquetas para encontrar scripts que estén en las categorías Geométrica o Abstracta y etiquetados como Colorido.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

Recupera un nombre específico scripts y ejecuta cada uno en secuencia, lo que demuestra la integración de la canalización con `Show-ColorScript`.

### EXAMPLE 8

```powershell
# Cuente scripts por categoría para fines de inventario
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

Proporciona un resumen de cuántos scripts de colores existen en cada categoría.

### EXAMPLE 9

```powershell
# Encuentre scripts con palabras clave específicas en la descripción
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

Busca scripts según el contenido de su descripción mediante la coincidencia de patrones.

### EXAMPLE 10

```powershell
# Exportar a CSV para procesamiento de herramientas externas
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

Exporta el inventario completo de script de colores a formato CSV para usarlo en aplicaciones de hojas de cálculo.

### EXAMPLE 11

```powershell
# Consultar por scripts sin categoría específica
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "Scripts sin categoría: $($uncategorized.Count)"
$uncategorized | Select-Object Name
```

Identifica scripts a los que les faltan metadatos de categoría.

### EXAMPLE 12

```powershell
# Construir caché para scripts filtrado
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

Evalúa scripts etiquetado como `Recommended`; solo se crean renderizadores elegibles para la política de caché y otros registros informan `SkippedNotRequired`.

### EXAMPLE 13

```powershell
# Cree un informe formateado de todos los scripts geométricos.
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

Genera y guarda un informe detallado de la categoría geométrica scripts de colores en un archivo.

### EXAMPLE 14

```powershell
# Encuentre el primer script que coincida con un patrón para una visualización rápida
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

Muestra rápidamente el primer script coincidente según un patrón comodín.

### EXAMPLE 15

```powershell
# Verifique que todos los scripts a los que se hace referencia existan antes de ejecutar la automatización
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "Scripts que faltan: $($missing -join ', ')"
} else {
    Write-Host "Todos los scripts necesarios están disponibles"
}
```

Valida que todos los scripts requeridos existan antes de que se ejecute la automatización.

## PARAMETERS

### -AsObject

Devuelve objetos de registro de metadatos sin procesar en lugar de representar una tabla formateada al host. Esto permite el procesamiento de canalizaciones y la manipulación programática de los metadatos script de colores.

Cuando se especifica este modificador, puede usar cmdlets PowerShell estándar como `Where-Object`, `Select-Object`, `Sort-Object` y `ForEach-Object` para procesar aún más los resultados.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -Category

Filtra la lista para incluir solo scripts que pertenece a una o más categorías especificadas. La coincidencia Category no distingue entre mayúsculas y minúsculas.

Las categorías comunes incluyen: Patrones, Geométrico, Abstracto, Naturaleza, Animado, Texto, Retro y más. Puede especificar varias categorías para ampliar su búsqueda.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Detailed

Incluye columnas adicionales (etiquetas y descripción) al representar la vista de tabla formateada. Esto proporciona información más completa sobre cada script de un vistazo.

Sin este modificador, solo se muestran el nombre y la categoría principal en el resultado de la tabla.

```yaml
Type: System.Management.Automation.SwitchParameter
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

Muestra ayuda detallada para este comando sin realizar la operación.

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

### -Name

Filtra la lista script de colores por uno o más nombres script. Admite caracteres comodín (`*` y `?`) para una coincidencia de patrones flexible.

Si un patrón especificado no coincide con ningún scripts, se genera una advertencia para ayudar a identificar problemas potenciales. La coincidencia Name no distingue entre mayúsculas y minúsculas.

Puede especificar nombres exactos o utilizar patrones como `aurora-*` para hacer coincidir varios scripts relacionados.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: (All)
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

Deshabilita el estilo ANSI en mensajes informativos y resultados renderizados para entornos de texto sin formato.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -Quiet

Suprime los mensajes informativos y al mismo tiempo preserva los resultados y los errores de los comandos.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -Tag

Filtra la lista para incluir solo scripts que contiene una o más etiquetas de metadatos especificadas. La coincidencia de etiquetas no distingue entre mayúsculas y minúsculas.

Las etiquetas comunes incluyen: Recomendado, Animado, Colorido, Mínimo, Retro, Complejo, Simple y más. Tags ayuda a categorizar scripts por estilo visual, complejidad o caso de uso.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

Este cmdlet admite los parámetros comunes:
Para obtener más información, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet no acepta entradas de canalización.

## OUTPUTS

### System.Object

Devuelve objetos de registro de metadatos script de colores con las siguientes propiedades:

- **Name**: El identificador script utilizado con `Show-ColorScript`
- **Path**: la ruta de origen completa
- **Category**: La categoría principal del script
- **Categories**: una variedad de todas las categorías a las que pertenece el script
- **Tags**: una serie de etiquetas de metadatos que describen el script
- **Description**: una descripción legible por humanos de la salida visual del script.
- **Metadata**: el objeto de metadatos original que contiene toda la información sin procesar de script.

Sin `-AsObject`, el cmdlet escribe una tabla formateada en el host y al mismo tiempo devuelve los objetos de registro para un posible procesamiento de canalización.

## NOTES

**Autor**: Nick
**Módulo**: ColorScripts-Enhanced

Los registros de metadatos devueltos proporcionan información completa tanto para fines de visualización como de automatización. La propiedad `Name` se puede usar directamente con el cmdlet `Show-ColorScript` para ejecutar scripts específico.

Todas las operaciones de filtrado (Name, Category, Etiqueta) no distinguen entre mayúsculas y minúsculas y se pueden combinar para crear consultas potentes. Cuando se utilizan comodines en el parámetro `-Name`, los patrones no coincidentes generan advertencias para ayudar con la resolución de problemas.

Para obtener mejores resultados al integrar scripts de colores en su perfil PowerShell, utilice el filtro `-Tag Recommended` para identificar el scripts seleccionado adecuado para la visualización de inicio.

### Buenas prácticas

- Utilice siempre `-AsObject` cuando necesite filtrar o manipular resultados mediante programación
- Utilice `-Detailed` cuando explore de forma interactiva para ver etiquetas y descripciones.
- Combine múltiples filtros para consultas precisas
- Exportar metadatos periódicamente para realizar un seguimiento de los cambios a lo largo del tiempo.
- Utilice objetos de resultados para la automatización en lugar de analizar la salida de texto
- Considere el rendimiento al ejecutar consultas repetidamente (guarde los resultados en caché si es posible)
- Aproveche Group-Object para análisis e informes
- Utilice Where-Object para lógica de filtrado compleja

## RELATED LINKS

- [Versión en línea](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)

