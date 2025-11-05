---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/es/Get-ColorScriptList.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptList

## SYNOPSIS

Lista los colorescripts disponibles con filtrado opcional y salida de metadatos rica.

## SYNTAX

### Default (Default)

```
Get-ColorScriptList [-AsObject] [-Detailed] [-Name <String[]>] [-Category <String[]>]
 [-Tag <String[]>] [<CommonParameters>]
```

### \_\_AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-AsObject]
 [-Detailed] [<CommonParameters>]
```

## DESCRIPTION

El cmdlet `Get-ColorScriptList` recupera y muestra todos los colorescripts empaquetados con el módulo ColorScripts-Enhanced. Proporciona opciones de filtrado flexibles y múltiples formatos de salida para adaptarse a diferentes casos de uso.

Por defecto, el cmdlet muestra una tabla formateada concisa que muestra los nombres de los scripts y las categorías. El interruptor `-Detailed` expande esta vista para incluir etiquetas y descripciones, proporcionando más contexto de un vistazo.

Para escenarios de automatización y programáticos, el parámetro `-AsObject` devuelve los registros de metadatos sin procesar como objetos PowerShell, permitiendo un procesamiento adicional a través de la canalización. Estos registros incluyen información completa como nombre, categoría, categorías, etiquetas, descripción y la propiedad de metadatos original.

Las capacidades de filtrado le permiten reducir la lista por:

- **Name**: Soporta patrones de comodín (ej., `aurora-*`) para coincidencia flexible
- **Category**: Filtrar por uno o más nombres de categoría (sin distinción de mayúsculas y minúsculas)
- **Tag**: Filtrar por etiquetas de metadatos como "Recommended" o "Animated" (sin distinción de mayúsculas y minúsculas)

El cmdlet valida los patrones de filtro y genera advertencias para cualquier patrón de nombre no coincidente, ayudándole a identificar posibles errores tipográficos o scripts faltantes.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Muestra todos los colorescripts disponibles en un formato de tabla compacta mostrando el nombre y la categoría de cada script.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

Muestra todos los colorescripts con columnas adicionales incluyendo etiquetas y descripciones para una visión general completa.

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

Muestra solo los scripts en la categoría "Patterns" con metadatos completos incluyendo etiquetas y descripciones.

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

Devuelve objetos estructurados para cada script cuyo nombre coincide con el patrón de comodín, luego selecciona solo las propiedades Name y Tags para mostrar.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

Recupera todos los scripts etiquetados como "Recommended" y los ordena alfabéticamente por nombre. Útil para encontrar scripts curados adecuados para la integración de perfil.

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

Combina el filtrado de categoría y etiqueta para encontrar scripts que están tanto en las categorías Geometric o Abstract como etiquetados como Colorful.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

Recupera scripts nombrados específicos y ejecuta cada uno en secuencia, demostrando la integración de canalización con `Show-ColorScript`.

### EXAMPLE 8

```powershell
# Count scripts by category for inventory purposes
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

Proporciona un resumen de cuántos colorescripts existen en cada categoría.

### EXAMPLE 9

```powershell
# Find scripts with specific keywords in description
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

Busca scripts basados en el contenido de su descripción usando coincidencia de patrones.

### EXAMPLE 10

```powershell
# Export to CSV for external tool processing
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

Exporta el inventario completo de colorescripts a formato CSV para uso en aplicaciones de hoja de cálculo.

### EXAMPLE 11

```powershell
# Check for scripts without specific category
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "Uncategorized scripts: $($uncategorized.Count)"
$uncategorized | Select-Object Name
```

Identifica scripts que carecen de metadatos de categoría.

### EXAMPLE 12

```powershell
# Build cache for filtered scripts
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

Almacena en caché solo los scripts recomendados y muestra los resultados de la operación de almacenamiento en caché.

### EXAMPLE 13

```powershell
# Create a formatted report of all geometric scripts
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

Genera y guarda un informe detallado de colorescripts de categoría geométrica en un archivo.

### EXAMPLE 14

```powershell
# Find the first script matching a pattern for quick display
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

Muestra rápidamente el primer script coincidente basado en un patrón de comodín.

### EXAMPLE 15

```powershell
# Verify all referenced scripts exist before running automation
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "Missing scripts: $($missing -join ', ')"
} else {
    Write-Host "All required scripts are available"
}
```

Valida que todos los scripts requeridos existan antes de ejecutar la automatización.

## PARAMETERS

### -AsObject

Devuelve objetos de registro de metadatos sin procesar en lugar de renderizar una tabla formateada al host. Esto permite el procesamiento de canalización y la manipulación programática de los metadatos de colorescript.

Cuando se especifica este interruptor, puede usar cmdlets estándar de PowerShell como `Where-Object`, `Select-Object`, `Sort-Object` y `ForEach-Object` para procesar aún más los resultados.

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
HelpMessage: ""
```

### -Category

Filtra la lista para incluir solo scripts pertenecientes a una o más categorías especificadas. La coincidencia de categoría no distingue mayúsculas y minúsculas.

Las categorías comunes incluyen: Patterns, Geometric, Abstract, Nature, Animated, Text, Retro, y más. Puede especificar múltiples categorías para ampliar su búsqueda.

```yaml
Type: System.String[]
DefaultValue: None
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
HelpMessage: ""
```

### -Detailed

Incluye columnas adicionales (etiquetas y descripción) al renderizar la vista de tabla formateada. Esto proporciona información más completa sobre cada script de un vistazo.

Sin este interruptor, solo se muestran el nombre y la categoría primaria en la salida de tabla.

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
HelpMessage: ""
```

### -Name

Filtra la lista de colorescripts por uno o más nombres de script. Soporta caracteres comodín (`*` y `?`) para coincidencia de patrones flexible.

Si un patrón especificado no coincide con ningún script, se genera una advertencia para ayudar a identificar posibles problemas. La coincidencia de nombre no distingue mayúsculas y minúsculas.

Puede especificar nombres exactos o usar patrones como `aurora-*` para coincidir con múltiples scripts relacionados.

```yaml
Type: System.String[]
DefaultValue: None
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
HelpMessage: ""
```

### -Tag

Filtra la lista para incluir solo scripts que contengan una o más etiquetas de metadatos especificadas. La coincidencia de etiqueta no distingue mayúsculas y minúsculas.

Las etiquetas comunes incluyen: Recommended, Animated, Colorful, Minimal, Retro, Complex, Simple, y más. Las etiquetas ayudan a categorizar scripts por estilo visual, complejidad o caso de uso.

```yaml
Type: System.String[]
DefaultValue: None
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
HelpMessage: ""
```

### CommonParameters

Este cmdlet soporta los parámetros comunes: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, y -WarningVariable. Para más información, vea
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet no acepta entrada de canalización.

## OUTPUTS

### System.Object

Cuando se especifica `-AsObject`, devuelve objetos de registro de metadatos de colorescript con las siguientes propiedades:

- **Name**: El identificador de script usado con `Show-ColorScript`
- **Category**: La categoría primaria del script
- **Categories**: Una matriz de todas las categorías a las que pertenece el script
- **Tags**: Una matriz de etiquetas de metadatos que describen el script
- **Description**: Una descripción legible por humanos de la salida visual del script
- **Metadata**: El objeto de metadatos original que contiene toda la información sin procesar del script

Sin `-AsObject`, el cmdlet escribe una tabla formateada al host mientras aún devuelve los objetos de registro para procesamiento potencial de canalización.

## ADVANCED USAGE PATTERNS

### Dynamic Filtering

**Multi-Criteria Filtering**

```powershell
# Find animated scripts that are colorful
Get-ColorScriptList -AsObject |
    Where-Object {
        $_.Tags -contains 'Animated' -and
        $_.Tags -contains 'Colorful'
    }

# Find scripts in Nature category but exclude simple ones
Get-ColorScriptList -Category Nature -AsObject |
    Where-Object { $_.Tags -notcontains 'Simple' }
```

**Fuzzy Matching**

```powershell
# Find scripts similar to a name pattern
$search = "wave"
Get-ColorScriptList -AsObject |
    Where-Object { $_.Name -like "*$search*" } |
    Select-Object Name, Category
```

### Data Analysis

**Category Distribution**

```powershell
# Analyze how scripts are distributed across categories
$analysis = Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object @{N='Category'; E={$_.Name}}, @{N='Count'; E={$_.Count}}, @{N='Percentage'; E={[math]::Round($_.Count / (Get-ColorScriptList -AsObject).Count * 100)}}

$analysis | Sort-Object Count -Descending | Format-Table
```

**Tag Frequency Analysis**

```powershell
# Determine most common tags
Get-ColorScriptList -AsObject |
    ForEach-Object { $_.Tags } |
    Group-Object |
    Sort-Object Count -Descending |
    Format-Table Name, Count
```

### Integration Workflows

**Playlist Creation**

```powershell
# Create a "favorite" playlist
$playlist = Get-ColorScriptList -AsObject |
    Where-Object { $_.Tags -contains 'Recommended' } |
    Select-Object -ExpandProperty Name

# Display playlist
$playlist | ForEach-Object {
    Write-Host "Showing: $_"
    Show-ColorScript -Name $_
    Start-Sleep -Seconds 2
}
```

**Metadata Export for Web**

```powershell
# Export detailed metadata
$web = Get-ColorScriptList -AsObject |
    Select-Object Name, Category, Tags, Description |
    ConvertTo-Json

$web | Out-File "./scripts.json" -Encoding UTF8
```

**Validation and Health Check**

```powershell
# Health check on all scripts
$health = Get-ColorScriptList -AsObject |
    ForEach-Object {
        $cached = Test-Path "$env:APPDATA\ColorScripts-Enhanced\cache\$($_.Name).cache"
        [PSCustomObject]@{
            Name = $_.Name
            Category = $_.Category
            Cached = $cached
            TagCount = $_.Tags.Count
        }
    }

$uncached = @($health | Where-Object { -not $_.Cached })
Write-Host "Scripts without cache: $($uncached.Count)"
$uncached | Format-Table Name, Category
```

## PERFORMANCE CONSIDERATIONS

### Query Optimization

**Filter Early**

```powershell
# Faster: Filter by category first
Get-ColorScriptList -Category Geometric -AsObject |
    Where-Object { $_.Name -like "*spiral*" }

# Slower: Get all then filter
Get-ColorScriptList -AsObject |
    Where-Object { $_.Category -eq "Geometric" -and $_.Name -like "*spiral*" }
```

**Use Appropriate Output Format**

```powershell
# For exploration: Detailed display
Get-ColorScriptList -Detailed

# For automation: Object format
Get-ColorScriptList -AsObject

# For piping: AsObject to pipeline
Get-ColorScriptList -AsObject | ForEach-Object { ... }
```

## NOTES

**Author**: Nick
**Module**: ColorScripts-Enhanced
**Version**: 1.0

Los registros de metadatos devueltos proporcionan información completa para fines de visualización y automatización. La propiedad `Name` se puede usar directamente con el cmdlet `Show-ColorScript` para ejecutar scripts específicos.

Todas las operaciones de filtrado (Name, Category, Tag) no distinguen mayúsculas y minúsculas y se pueden combinar para crear consultas poderosas. Al usar comodines en el parámetro `-Name`, los patrones no coincidentes generan advertencias para ayudar con la resolución de problemas.

Para mejores resultados al integrar colorescripts en su perfil de PowerShell, use el filtro `-Tag Recommended` para identificar scripts curados adecuados para la visualización de inicio.

### Best Practices

- Siempre use `-AsObject` cuando necesite filtrar o manipular resultados programáticamente
- Use `-Detailed` cuando explore interactivamente para ver etiquetas y descripciones
- Combine múltiples filtros para consultas precisas
- Exporte metadatos periódicamente para rastrear cambios con el tiempo
- Use objetos de resultado para automatización en lugar de analizar salida de texto
- Considere el rendimiento al ejecutar consultas repetidamente (almacene en caché resultados si es posible)
- Aproveche Group-Object para análisis y reportes
- Use Where-Object para lógica de filtrado compleja

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
- [Module Repository](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
