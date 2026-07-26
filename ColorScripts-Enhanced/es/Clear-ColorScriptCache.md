---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Clear-ColorScriptCache
---

# Clear-ColorScriptCache

## SYNOPSIS

Elimine los archivos de salida script de colores almacenados en caché.

## SYNTAX

### Selection (Default)

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

### Help

```
Clear-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-All] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

## ALIASES

Este comando no tiene alias.

## DESCRIPTION

El cmdlet `Clear-ColorScriptCache` elimina los archivos de salida almacenados en caché generados por el módulo ColorScripts-Enhanced. Cada entrada consta de una carga útil `<name>.cache` representada y un sidecar de validación `<name>.cacheinfo` en el directorio de caché efectivo.

Puede eliminar entradas de caché de forma selectiva utilizando el parámetro `-Name` con patrones comodín, o eliminar todas las entradas a la vez con el parámetro `-All`. `-All` también elimina sidecars huérfanos cuya carga útil fue eliminada. El cmdlet admite el filtrado por `-Category` y `-Tag` para apuntar a subconjuntos específicos de scripts almacenados en caché.

Los nombres script no coincidentes informan un estado `Missing` en los resultados. Utilice `-DryRun` para obtener una vista previa de las acciones de eliminación sin modificar el sistema de archivos y `-Path` para apuntar a un directorio de caché alternativo (útil para configuraciones de caché personalizadas o entornos CI/CD).

Las entradas de caché elegibles se regeneran cuando se muestra el representador seleccionado por política correspondiente o se invoca `New-ColorScriptCache`. El paquete determinista scripts se procesa en proceso y no crea entradas de caché.

Para escenarios de automatización, combine `-PassThru` para capturar resultados estructurados, `-Quiet` para suprimir el mensaje de resumen o `-NoAnsiOutput` para emitir resúmenes de texto sin formato sin códigos de color ANSI.

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

Elimina todos los archivos de caché en el directorio de caché predeterminado sin solicitar confirmación. Esto es útil para actualizar completamente el caché después de las actualizaciones del módulo o al solucionar problemas de visualización.

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

Muestra una vista previa de qué archivos de caché con temas de auroras se eliminarían sin eliminarlos realmente. El resultado muestra los archivos de caché que coinciden con el patrón, lo que le permite verificar la selección antes de comprometerse a eliminarlos.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name Galaxy -Path $env:TEMP -Confirm:$false
```

Borra el archivo de caché para el procesador 'Galaxy' elegible de un directorio personalizado en TEMP. Esto resulta útil al probar `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` u otra ubicación de caché aislada.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Category Mathematical -WhatIf
```

Muestra lo que sucedería si se eliminaran los archivos de caché de scripts en la categoría `Mathematical`. El parámetro `-WhatIf` impide la eliminación.

### EXAMPLE 5

```powershell
Get-ColorScriptList -Tag retro | Clear-ColorScriptCache -DryRun
```

Utiliza la entrada de canalización para obtener una vista previa de la eliminación de archivos de caché para todos los scripts etiquetados como 'retro'. Combina el filtrado por etiqueta con una vista previa de prueba antes de comprometerse con la eliminación.

### EXAMPLE 6

```powershell
Clear-ColorScriptCache -Name 'test-*', 'demo-*' -Confirm:$false
```

Elimina los archivos de caché de todos los scripts cuyos nombres comienzan con 'test-' o 'demo-' sin confirmación. Se pueden especificar varios patrones comodín como una matriz.

### EXAMPLE 7

```powershell
# Eliminar los archivos de caché y reconstruir las entradas seleccionadas por la directiva
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -PassThru | Measure-Object
Write-Host "La caché se reconstruyó correctamente"
```

Elimina todas las cargas de caché, reconstruye las entradas seleccionadas por la directiva de caché dinámica y muestra estadísticas de esas entradas reconstruidas.

### EXAMPLE 8

```powershell
# Borrar entradas de caché antiguas de más de 30 días
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$thirtyDaysAgo = (Get-Date).AddDays(-30)
Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $thirtyDaysAgo } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
Write-Host "Se limpiaron los archivos de caché antiguos"
```

Elimina los archivos de caché que no se han actualizado en más de 30 días.

### EXAMPLE 9

```powershell
# Informe de gestión de caché
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$beforeCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Clear-ColorScriptCache -Category Geometric -Confirm:$false
$afterCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Write-Host "Se borraron $($beforeCount - $afterCount) archivos de caché geométricos"
```

Muestra estadísticas sobre las operaciones de borrado de caché.

### EXAMPLE 10

```powershell
# Solución de problemas: borre y reconstruya script específico
$scriptName = "Galaxy"
Clear-ColorScriptCache -Name $scriptName -Confirm:$false
New-ColorScriptCache -Name $scriptName -Force
Show-ColorScript -Name $scriptName
```

Borra y reconstruye la caché de un renderizador elegible según la política y luego lo muestra para verificar el resultado.

### EXAMPLE 11

```powershell
# Filtrar por múltiples categorías
Clear-ColorScriptCache -Category Geometric,Abstract -DryRun -PassThru |
    Select-Object CacheFile |
    Measure-Object
```

Muestra cuántos archivos de caché se eliminarían si se filtraran por varias categorías.

## PARAMETERS

### -All

Seleccione cada entrada de caché en el directorio de destino. `-Category` y `-Tag` pueden restringir aún más el conjunto de parámetros de selección total; `-Name` pertenece al conjunto de parámetros de selección.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

Filtre el scripts de destino por categoría antes de evaluar las entradas de la caché. Solo se considerarán para su eliminación los archivos de caché de scripts que coincidan con las categorías especificadas. Acepta una variedad de nombres de categorías y se puede combinar con `-Tag` para un filtrado más preciso.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Le solicita confirmación antes de ejecutar el cmdlet. De forma predeterminada, esto está habilitado para evitar la eliminación accidental de archivos de caché. Utilice `-Confirm:$false` para omitir el mensaje de confirmación.

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

### -DryRun

Obtenga una vista previa de las acciones de eliminación sin eliminar ningún archivo. El cmdlet mostrará qué archivos de caché se eliminarán pero no modificará el sistema de archivos. Esto es útil para verificar sus criterios de selección antes de comprometerse con la eliminación.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Nombres o patrones de comodines que identifican los archivos de caché que se eliminarán. Acepta entradas de canalización y enlaces de propiedades de objetos con una propiedad `Name`. Se admiten caracteres comodín (`*`, `?`) para la coincidencia de patrones. Mutuamente excluyentes con `-All`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

Deshabilite las secuencias de colores ANSI en la salida de resumen. Esto es útil para consolas o procesadores de registros que no interpretan el estilo ANSI, asegurando que el texto del resumen permanezca legible en texto plano.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- NoColor
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Devuelve objetos de resultados detallados para cada entrada de caché procesada. Sin este modificador, el cmdlet solo escribe un mensaje de resumen. Cada registro de paso incluye el nombre script, la ruta del archivo de caché, el estado y cualquier texto de error asociado para su posterior inspección o generación de informes.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Path

Directorio de caché alternativo para operar. El valor predeterminado es la ruta de caché estándar del módulo si no se especifica. Utilice este parámetro cuando trabaje con ubicaciones de caché personalizadas configuradas a través de la variable de entorno `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`, o cuando administre archivos de caché en directorios alternativos para fines de prueba o CI/CD.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Suprime el mensaje de resumen emitido una vez completada la eliminación de la caché. Utilice este modificador cuando se ejecute en contextos de automatización silenciosos donde solo se deben producir resultados estructurados (como registros, advertencias o errores `-PassThru`).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Filtre el scripts de destino por etiqueta de metadatos antes de evaluar las entradas de la caché. Solo se considerarán para su eliminación los archivos de caché de scripts con etiquetas coincidentes. Acepta una variedad de nombres de etiquetas y se puede combinar con `-Category` para obtener un control más detallado sobre a qué archivos de caché se dirigen.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Muestra lo que sucedería si el cmdlet se ejecuta sin ejecutar realmente la operación. El cmdlet muestra las acciones que realizaría pero no modifica el sistema de archivos. Este es un parámetro común estándar del PowerShell que funciona de manera similar al `-DryRun` pero sigue las convenciones integradas del PowerShell.

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

Este cmdlet admite los parámetros comunes:
Para obtener más información, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Puede canalizar nombres script a este cmdlet. Cada nombre será evaluado para eliminar el archivo de caché según los parámetros especificados.

### System.String[]

Puede canalizar una serie de nombres script a este cmdlet. Esto es particularmente útil cuando se combina con `Get-ColorScriptList` para filtrar scripts según varios criterios antes de borrar sus cachés.

### System.Management.Automation.PSObject

Puede canalizar objetos con una propiedad `Name` a este cmdlet. El cmdlet extraerá el valor de la propiedad `Name` y lo utilizará para identificar los archivos de caché que se van a eliminar.

## OUTPUTS

### System.Object

Con `-PassThru`, devuelve un registro de estado por cada archivo de caché procesado. Cada objeto de salida contiene las siguientes propiedades:

- **Status**: El resultado de la operación (`Removed`, `Missing`, `DryRun`, `SkippedByUser` o `Error`)
- **CacheFile**: la ruta completa al archivo de caché que se procesó
- **Message**: Texto descriptivo explicando el resultado de la operación.
- **Name**: El nombre del script asociado con el archivo de caché.

## NOTES

**Autor**: Nick
**Módulo**: ColorScripts-Enhanced

Los archivos de caché se almacenan con una extensión `.cache` en el directorio de caché del módulo. Cada archivo de caché corresponde a un único script de colores y contiene la salida ANSI pre-renderizada.

Las entradas de caché elegibles se regeneran cuando se muestra el representador seleccionado por política correspondiente o se invoca `New-ColorScriptCache`. El paquete determinista scripts se procesa en proceso y no crea entradas de caché.

Consulte `(Get-ColorScriptConfiguration).Cache.EffectivePath` para conocer la ruta efectiva predeterminada. Se puede anular con configuración persistente o `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`; `-Path` apunta a un directorio diferente para una invocación.

Cuando se utiliza `-DryRun` o `-WhatIf`, el cmdlet seguirá validando que el directorio de caché existe e informará cualquier problema, pero no realizará ninguna eliminación.

El filtrado por `-Category` o `-Tag` requiere que el scripts tenga metadatos asociados. Scripts sin metadatos no coincidirá con estos filtros.

### Buenas prácticas

- Utilice siempre `-DryRun` o `-WhatIf` antes de operaciones destructivas.
- Utilice `-Confirm:$false` sólo cuando esté seguro del funcionamiento
- Archivar caché antes de operaciones importantes de limpieza para recuperación
- Supervise el espacio en disco con regularidad para ver el crecimiento de la caché
- Utilice limpieza selectiva en lugar de limpieza completa cuando sea posible
- Realice un seguimiento de los scripts críticos que no deben borrarse
- Programe limpiezas automatizadas durante las ventanas de mantenimiento
- Probar primero las operaciones de limpieza en áreas no productivas.

### Solución de problemas (2)

- **"No se encontraron archivos de caché"**: Inspeccione `(Get-ColorScriptConfiguration).Cache.EffectivePath` y use `Export-ColorScriptMetadata -IncludeCacheInfo` para verificar el estado del caché
- **"Permiso denegado"**: verifique el acceso de escritura al directorio de caché
- **"La caché no se regenera"**: los scripts pueden tener problemas de renderizado; pruebe con `-NoCache`

## RELATED LINKS

- [Versión en línea](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache)

