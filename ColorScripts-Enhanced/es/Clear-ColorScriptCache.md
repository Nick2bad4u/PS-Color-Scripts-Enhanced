---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/es/Clear-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 11/14/2025
PlatyPS schema version: 2024-05-01
---

# Clear-ColorScriptCache

## SYNOPSIS

Eliminar archivos de salida de colorescript en caché.

## SYNTAX

### All

```
Clear-ColorScriptCache [-All] [-Path <String>] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Named

```
Clear-ColorScriptCache [-Name <String[]>] [-Category <String[]>] [-Tag <String[]>] [-Path <String>] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### \_\_AllParameterSets

```
Clear-ColorScriptCache [[-Name] <string[]>] [[-Path] <string>] [[-Category] <string[]>]
 [[-Tag] <string[]>] [-All] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

El cmdlet `Clear-ColorScriptCache` elimina archivos de salida en caché generados por el módulo ColorScripts-Enhanced. Los archivos de caché almacenan la salida de script pre-renderizada para mejorar el rendimiento durante invocaciones posteriores.

Puede eliminar archivos de caché de forma selectiva utilizando el parámetro `-Name` con patrones de comodín, o eliminar todos los archivos de caché a la vez con el parámetro `-All`. El cmdlet también admite el filtrado por `-Category` y `-Tag` para apuntar a subconjuntos específicos de scripts en caché.

Los nombres de script no coincidentes reportan un estado `Missing` en los resultados. Use `-DryRun` para previsualizar acciones de eliminación sin modificar el sistema de archivos, y `-Path` para apuntar a un directorio de caché alternativo (útil para configuraciones de caché personalizadas o entornos CI/CD).

Los archivos de caché se regeneran automáticamente la próxima vez que `Show-ColorScript` ejecute el script correspondiente.

Para escenarios de automatización, combine `-PassThru` para capturar resultados detallados, `-Quiet` para silenciar el resumen final o `-NoAnsiOutput` para emitir texto sin secuencias ANSI en consolas que no admiten color.

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

Elimina todos los archivos de caché en el directorio de caché predeterminado sin solicitar confirmación. Esto es útil para refrescar completamente el caché después de actualizaciones del módulo o al solucionar problemas de visualización.

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

Previsualiza qué archivos de caché con tema aurora se eliminarían sin eliminarlos realmente. La salida muestra los archivos de caché que coinciden con el patrón, permitiendo verificar la selección antes de confirmar la eliminación.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name bars -Path $env:TEMP -Confirm:$false
```

Borra el archivo de caché para el script 'bars' desde un directorio de caché personalizado ubicado en la carpeta TEMP. Esto es útil cuando se trabaja con la variable de entorno `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` o probando ubicaciones de caché alternativas.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Category Animation -WhatIf
```

Muestra qué sucedería si se eliminaran todos los archivos de caché para scripts en la categoría Animation. El parámetro `-WhatIf` evita la eliminación real y muestra las acciones previstas.

### EXAMPLE 5

```powershell
Get-ColorScriptList -Tag retro | Clear-ColorScriptCache -DryRun
```

Utiliza entrada de canalización para previsualizar la eliminación de archivos de caché para todos los scripts etiquetados como 'retro'. Combina el filtrado por etiqueta con una previsualización de ejecución en seco antes de confirmar la eliminación.

### EXAMPLE 6

```powershell
Clear-ColorScriptCache -Name 'test-*', 'demo-*' -Confirm:$false
```

Elimina archivos de caché para todos los scripts cuyos nombres comiencen con 'test-' o 'demo-' sin confirmación. Se pueden especificar múltiples patrones de comodín como una matriz.

### EXAMPLE 7

```powershell
# Limpiar caché y reconstruir para optimización
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -PassThru | Measure-Object
Write-Host "Caché reconstruido exitosamente"
```

Realiza un refresco completo del caché eliminando todo y reconstruyendo, luego muestra estadísticas.

### EXAMPLE 8

```powershell
# Borrar entradas de caché antiguas de más de 30 días
$cacheDir = "$env:APPDATA\ColorScripts-Enhanced\cache"
$thirtyDaysAgo = (Get-Date).AddDays(-30)
Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $thirtyDaysAgo } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
Write-Host "Archivos de caché antiguos limpiados"
```

Elimina archivos de caché que no se han actualizado en más de 30 días.

### EXAMPLE 9

```powershell
# Informe de gestión de caché
$cacheDir = "$env:APPDATA\ColorScripts-Enhanced\cache"
$beforeCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Clear-ColorScriptCache -Category Geometric -Confirm:$false
$afterCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Write-Host "Borrados $($beforeCount - $afterCount) archivos de caché geométricos"
```

Muestra estadísticas sobre operaciones de borrado de caché.

### EXAMPLE 10

```powershell
# Solución de problemas - borrar y reconstruir script específico
$scriptName = "mandelbrot-zoom"
Clear-ColorScriptCache -Name $scriptName -Confirm:$false
New-ColorScriptCache -Name $scriptName -Force
Show-ColorScript -Name $scriptName
```

Borra y reconstruye el caché para un script único, luego lo muestra para verificación.

### EXAMPLE 11

```powershell
# Filtrar por múltiples categorías
Clear-ColorScriptCache -Category Geometric,Abstract -DryRun |
    Select-Object CacheFile |
    Measure-Object
```

Muestra cuántos archivos de caché se eliminarían si se filtra por múltiples categorías.

## PARAMETERS

### -All

Eliminar todos los archivos de caché en el directorio de destino. Este parámetro es mutuamente exclusivo con `-Name`, `-Category` y `-Tag`. Cuando se especifica, todos los parámetros de filtrado se ignoran y se borra todo el caché.

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

### -PassThru

Devuelve objetos de resultado detallados para cada archivo de caché procesado. Sin este modificador, solo se emite un mensaje de resumen. Cada registro incluye el nombre del script, la ruta del archivo de caché, el estado y cualquier mensaje asociado.

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

### -Quiet

Suprime el mensaje de resumen emitido después de completar la limpieza de caché. Resulta útil en automatizaciones donde solo se deben mostrar advertencias, errores u objetos retornados por `-PassThru`.

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

### -NoAnsiOutput

Desactiva las secuencias de color ANSI en el mensaje de resumen, de modo que la salida sea texto plano. Ideal para consolas o registradores que no admiten coloreado.

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
HelpMessage: ""
```

### -Category

Filtrar los scripts de destino por categoría antes de evaluar las entradas de caché. Solo se considerarán para eliminación los archivos de caché de scripts que coincidan con las categorías especificadas. Acepta una matriz de nombres de categoría y se puede combinar con `-Tag` para un filtrado más preciso.

```yaml
Type: System.String[]
DefaultValue: ""
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

### -Confirm

Solicita confirmación antes de ejecutar el cmdlet. De forma predeterminada, esto está habilitado para evitar la eliminación accidental de archivos de caché. Use `-Confirm:$false` para omitir la solicitud de confirmación.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: True
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
HelpMessage: ""
```

### -DryRun

Previsualizar acciones de eliminación sin eliminar ningún archivo. El cmdlet mostrará qué archivos de caché se eliminarían pero no modificará el sistema de archivos. Esto es útil para verificar sus criterios de selección antes de confirmar la eliminación.

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

Nombres o patrones de comodín que identifican archivos de caché para eliminar. Acepta entrada de canalización y enlace de propiedad de objetos con una propiedad `Name`. Los caracteres comodín (`*`, `?`) son compatibles para la coincidencia de patrones. Mutuamente exclusivo con `-All`.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
 - Name: (All)
   Position: 0
   IsRequired: false
   ValueFromPipeline: true
   ValueFromPipelineByPropertyName: true
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Path

Directorio de caché alternativo para operar. Por defecto, la ruta de caché estándar del módulo si no se especifica. Use este parámetro cuando trabaje con ubicaciones de caché personalizadas configuradas mediante la variable de entorno `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`, o al gestionar archivos de caché en directorios alternativos para pruebas o propósitos CI/CD.

```yaml
Type: System.String
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

### -Tag

Filtrar los scripts de destino por etiqueta de metadatos antes de evaluar las entradas de caché. Solo se considerarán para eliminación los archivos de caché de scripts con etiquetas coincidentes. Acepta una matriz de nombres de etiqueta y se puede combinar con `-Category` para un control más granular sobre qué archivos de caché se apuntan.

```yaml
Type: System.String[]
DefaultValue: ""
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: (All)
   Position: 3
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -WhatIf

Muestra qué sucedería si se ejecuta el cmdlet sin ejecutar realmente la operación. El cmdlet muestra las acciones que realizaría pero no modifica el sistema de archivos. Este es un parámetro común estándar de PowerShell que funciona de manera similar a `-DryRun` pero sigue las convenciones integradas de PowerShell.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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
HelpMessage: ""
```

### CommonParameters

Este cmdlet admite los parámetros comunes: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, y -WarningVariable. Para más información, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Puede canalizar nombres de script a este cmdlet. Cada nombre se evaluará para la eliminación de archivos de caché según los parámetros especificados.

### System.String[]

Puede canalizar una matriz de nombres de script a este cmdlet. Esto es particularmente útil cuando se combina con `Get-ColorScriptList` para filtrar scripts por varios criterios antes de borrar sus cachés.

### System.Management.Automation.PSObject

Puede canalizar objetos con una propiedad `Name` a este cmdlet. El cmdlet extraerá el valor de la propiedad `Name` y lo usará para identificar archivos de caché para eliminación.

## OUTPUTS

### System.Object

Devuelve registros de estado para cada archivo de caché procesado. Cada objeto de salida contiene las siguientes propiedades:

- **Status**: El resultado de la operación (`Removed`, `Missing`, `DryRun` o `Error`)
- **CacheFile**: La ruta completa al archivo de caché que se procesó
- **Message**: Texto descriptivo que explica el resultado de la operación
- **ScriptName**: El nombre del script asociado con el archivo de caché

## ADVANCED USAGE PATTERNS

### Cache Maintenance Strategies

**Full Cache Rebuild**

```powershell
# Refresco completo del caché
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -Force
Write-Host "Caché reconstruido exitosamente"
```

**Targeted Cache Cleaning**

```powershell
# Borrar solo entradas obsoletas
Clear-ColorScriptCache -Name "deprecated-*", "test-*" -Confirm:$false

# Verificar qué se eliminaría primero
Clear-ColorScriptCache -Name "draft-*" -DryRun
```

**Age-Based Cleanup**

```powershell
# Borrar archivos de caché de más de 60 días
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
$cutoffDate = (Get-Date).AddDays(-60)

Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $cutoffDate } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
```

### Category and Tag Based Cleaning

**Clear by Metadata**

```powershell
# Eliminar cachés para categoría experimental
Clear-ColorScriptCache -Category Experimental -Confirm:$false

# Borrar etiqueta obsoleta
Clear-ColorScriptCache -Tag deprecated -Confirm:$false

# Borrar múltiples categorías a la vez
Clear-ColorScriptCache -Category @("Demo", "Test", "Draft") -Confirm:$false
```

**Selective Preservation**

```powershell
# Mantener solo scripts recomendados, borrar todo lo demás
$keep = Get-ColorScriptList -Tag Recommended -AsObject | Select-Object -ExpandProperty Name
$all = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$remove = $all | Where-Object { $_ -notin $keep }

$remove | ForEach-Object { Clear-ColorScriptCache -Name $_ -Confirm:$false }
```

### Performance and Reporting

**Cache Usage Analysis**

```powershell
# Analizar caché antes de limpieza
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
$before = (Get-ChildItem $cacheDir -Filter "*.cache" | Measure-Object -Property Length -Sum).Sum

Clear-ColorScriptCache -Category Demo -DryRun
Write-Host "Tamaño actual del caché: $([math]::Round($before / 1MB, 2)) MB"
```

**Cleanup Report**

```powershell
# Generar informe de operaciones de limpieza
$report = Clear-ColorScriptCache -Name "test-*", "debug-*" -Confirm:$false
$report | Group-Object Status | ForEach-Object {
    Write-Host "$($_.Name): $($_.Count) elementos"
}
```

**Space Recovery**

```powershell
# Calcular espacio en disco liberado
$before = (Get-ChildItem (Get-ColorScriptConfiguration).Cache.Path -Filter "*.cache" | Measure-Object -Property Length -Sum).Sum
Clear-ColorScriptCache -All -Confirm:$false
$after = (Get-ChildItem (Get-ColorScriptConfiguration).Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum

Write-Host "Liberado: $([math]::Round(($before - $after) / 1MB, 2)) MB"
```

### CI/CD and Deployment

**Pre-Build Cache Cleanup**

```powershell
# Construcción limpia: borrar todo el caché antes de reconstruir
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -Tag Recommended -Force
Write-Host "Caché listo para despliegue"
```

**Selective Cache Persistence**

```powershell
# Mantener scripts de producción, borrar desarrollo
Clear-ColorScriptCache -Tag "development,experimental" -Confirm:$false

# Preservar caché para scripts críticos
$critical = @("bars", "arch", "mandelbrot-zoom")
$scripts = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$toRemove = $scripts | Where-Object { $_ -notin $critical }
$toRemove | ForEach-Object { Clear-ColorScriptCache -Name $_ -Confirm:$false }
```

### Troubleshooting

**Verification Workflow**

```powershell
# Verificar problemas de caché y corregir
$problemScripts = Get-ColorScriptList -AsObject |
    Where-Object {
        -not (Test-Path "$env:APPDATA\ColorScripts-Enhanced\cache\$($_.Name).cache")
    }

Write-Host "Scripts sin caché: $($problemScripts.Count)"
$problemScripts | ForEach-Object {
    Write-Host "Reconstruyendo: $($_.Name)"
    New-ColorScriptCache -Name $_.Name -Force
}
```

## NOTES

**Author**: Nick
**Module**: ColorScripts-Enhanced

Los archivos de caché se almacenan con una extensión `.cache` en el directorio de caché del módulo. Cada archivo de caché corresponde a un solo colorescript y contiene la salida ANSI pre-renderizada.

Los archivos de caché se regeneran automáticamente la próxima vez que `Show-ColorScript` ejecute el script correspondiente. Esta regeneración ocurre de manera transparente y no requiere intervención manual.

La ruta de caché predeterminada se expone a través de la variable `$CacheDir` del módulo y se puede anular usando la variable de entorno `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`.

Cuando se usa `-DryRun` o `-WhatIf`, el cmdlet aún validará que el directorio de caché exista y reportará cualquier problema, pero no realizará eliminaciones.

El filtrado por `-Category` o `-Tag` requiere que los scripts tengan metadatos asociados. Los scripts sin metadatos no coincidirán con estos filtros.

### Best Practices

- Siempre use `-DryRun` o `-WhatIf` antes de operaciones destructivas
- Use `-Confirm:$false` solo cuando esté seguro de la operación
- Archive el caché antes de operaciones de limpieza importantes para recuperación
- Monitoree el espacio en disco regularmente para el crecimiento del caché
- Use limpieza selectiva en lugar de borrado completo cuando sea posible
- Mantenga un registro de scripts críticos que no deberían borrarse
- Programe limpiezas automatizadas durante ventanas de mantenimiento
- Pruebe operaciones de limpieza en no producción primero

### Troubleshooting

- **"No cache files found"**: Use `-AsObject` para verificar qué scripts tienen cachés
- **"Permission denied"**: Verifique el acceso de escritura al directorio de caché
- **"Cache not regenerating"**: Los scripts pueden tener problemas de renderizado; pruebe con `-NoCache`

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
