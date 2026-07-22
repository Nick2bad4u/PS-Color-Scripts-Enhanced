---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

Cree previamente o actualice los archivos de caché script de colores para una renderización más rápida.

## SYNTAX

### Selection (Default)

```
New-ColorScriptCache [-Name <string[]>] [-Force] [-PassThru] [-Category <string[]>]
 [-Tag <string[]>] [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon]
 [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Category <string[]>] [-Tag <string[]>]
 [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon] [-WhatIf] [-Confirm]
```

## ALIASES

- `Build-ColorScriptCache`
- `Update-ColorScriptCache`

## DESCRIPTION

`New-ColorScriptCache` renderiza los scripts de colores computacionales seleccionados por la política y guarda su salida como UTF-8 sin marca de orden de bytes (BOM). Los renderizadores incluidos elegibles utilizan la ruta de ejecución aislada del módulo; los trabajadores paralelos están disponibles en PowerShell 7 y versiones posteriores. Los scripts empaquetados deterministas se renderizan dentro del proceso y nunca crean archivos de caché. Los alias son `Update-ColorScriptCache` y `Build-ColorScriptCache`.

Puede orientar sus anuncios a scripts por nombre (se admiten comodines), categoría o etiqueta. Cuando no se especifica ningún parámetro, el cmdlet resuelve los nombres en `CachePolicy.psd1` directamente en lugar de enumerar la colección completa. Los nombres de paquetes exactos también utilizan una búsqueda directa de archivos. Las solicitudes de comodines, categorías y etiquetas se enumeran solo cuando su semántica coincidente lo requiere. Los scripts explícitos no listados se devuelven con el estado `SkippedNotRequired` cuando se utiliza `-PassThru` y se eliminan los archivos de caché obsoletos para esos scripts.

De forma predeterminada, el cmdlet muestra el progreso además de un resumen conciso de la operación de almacenamiento en caché y el directorio de caché efectivo. Utilice `-PassThru` para devolver objetos de resultados detallados para cada script, que puede inspeccionar mediante programación para determinar el estado, la salida estándar y los flujos de errores. Combine `-Quiet` para suprimir el progreso y el resumen por completo, o `-NoAnsiOutput` para emitir resúmenes de texto sin formato sin códigos de color ANSI para entornos que no los admiten.

El cmdlet omite los scripts cuyos archivos de caché ya están actualizados, a menos que especifique `-Force`. Las compilaciones repetidas validan el pequeño archivo auxiliar de metadatos `<name>.cacheinfo` sin cargar la carga útil `<name>.cache` renderizada. `-Force` reconstruye las entradas de caché elegibles, pero nunca anula la política de caché.

Ambos archivos se encuentran en `(Get-ColorScriptConfiguration).Cache.EffectivePath`. El archivo `.cache` contiene la salida del terminal renderizada; `.cacheinfo` contiene solo metadatos de validación. Un archivo auxiliar sin su carga útil no es una entrada de caché utilizable y se repara en la siguiente compilación. `Clear-ColorScriptCache -All` elimina entradas completas y archivos auxiliares huérfanos.

Para reconstrucciones más rápidas en sistemas multinúcleo, utilice el conmutador `-Parallel` junto con el parámetro `-ThrottleLimit` (o `-Threads`) para controlar el recuento de trabajadores. El cmdlet vuelve automáticamente a la ejecución secuencial cuando no se pueden crear espacios de ejecución paralelos en el host actual.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Resuelva y caliente solo los renderizadores computacionales seleccionados por políticas sin enumerar cada script que se envía con el módulo. Este es el comportamiento predeterminado cuando no se especifica ningún parámetro.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name Galaxy, 'rose-*'
```

Almacene en caché una combinación de coincidencias exactas y comodín. Sólo se crean coincidencias incluidas en `CachePolicy.psd1`; otros partidos reportan `SkippedNotRequired` con `-PassThru`.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name Galaxy -Force -PassThru | Format-List
```

Fuerce una reconstrucción de la caché 'Galaxy' elegible incluso si está actualizada y examine el objeto de resultado detallado.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Mathematical' -PassThru
```

Evalúe scripts en la categoría `Mathematical`, almacene en caché los renderizadores elegibles y obtenga resultados detallados para cada coincidencia.

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Reconstruya los cachés elegibles para scripts etiquetados con 'geometric' o 'colorful', forzando la regeneración incluso si los cachés están actualizados.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Mathematical -AsObject | New-ColorScriptCache -PassThru
```

Ejemplo de canalización: evalúe scripts en la categoría `Mathematical`, almacene en caché los renderizadores seleccionados por políticas y devuelva un resultado para cada coincidencia.

### EXAMPLE 7

```powershell
# Verificar las estadísticas de la caché después de la compilación
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
$before = @(Get-ChildItem $cachePath -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem $cachePath -Filter "*.cache").Count
Write-Host "Scripts almacenados en caché: $before -> $after"
```

Mide el crecimiento de la caché contando los archivos de caché seleccionados por políticas antes y después de la operación.

### EXAMPLE 8

```powershell
# Construir caché para renderizadores computacionales usados frecuentemente
$frequentScripts = @('Galaxy', 'rose-curves', 'wave-interference')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

Crea cachés para los scripts listados que son elegibles bajo `CachePolicy.psd1`; Se omiten los nombres no listados.

### EXAMPLE 9

```powershell
# Utilice la pantalla de progreso integrada con ámbito de política
New-ColorScriptCache -All
```

Muestra el progreso integrado para los renderizadores seleccionados por políticas sin iterar manualmente todos los scripts disponibles.

### EXAMPLE 10

```powershell
# Opcionalmente, prepara entradas de políticas faltantes o obsoletas de un perfil PowerShell.
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Quiet
```

Comprueba las entradas seleccionadas por políticas cuando se carga el perfil y crea solo las entradas faltantes o obsoletas. Omita este paso del perfil cuando no desee realizar el trabajo de caché de inicio.

### EXAMPLE 11

```powershell
# Reconstruir cada entrada seleccionada por política para su implementación
New-ColorScriptCache -All -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

Reconstruye cada entrada de caché seleccionada por políticas y exporta los estados a un manifiesto de implementación.

### EXAMPLE 12

```powershell
# Encuentra fallas en la compilación de caché
New-ColorScriptCache -Name "Galaxy" -Force -PassThru |
    Where-Object Status -eq 'Failed' |
    Select-Object Name, StdErr
```

Identifica errores de almacenamiento en caché sin tratar los saltos de políticas como errores.

### EXAMPLE 13

```powershell
# Contar las entradas seleccionadas por políticas actualizadas por esta ejecución
New-ColorScriptCache -All -PassThru |
    Where-Object Status -eq 'Updated' |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Comprueba cada entrada seleccionada por la política y muestra cuántas cargas útiles de caché se actualizaron mediante esta ejecución.

### EXAMPLE 14

```powershell
New-ColorScriptCache -All -Parallel -Threads 8
```

Cree todas las cachés seleccionadas por políticas utilizando ocho subprocesos de trabajo. El cmdlet vuelve automáticamente a la ejecución secuencial cuando los trabajos paralelos no están disponibles en el host actual.

## PARAMETERS

### -All

Resuelva cada entrada de la política de caché directamente. Solo se procesan los scripts seleccionados por política; el inventario completo de script de colores no está enumerado.

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

Los filtros evaluaron scripts por categoría de metadatos (no distingue entre mayúsculas y minúsculas). Los valores múltiples se tratan como un filtro OR. Sólo se almacenan en caché las coincidencias permitidas por `CachePolicy.psd1`; otros partidos reportan `SkippedNotRequired` con `-PassThru`.

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

Le solicita confirmación antes de ejecutar el cmdlet. Útil cuando se almacena en caché una gran cantidad de scripts o cuando se utiliza `-Force` para evitar la regeneración accidental de la caché.

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

Reconstruya las entradas de caché elegibles incluso cuando sus metadatos de validación `.cacheinfo` indiquen que están actualizados. Esto no anula `CachePolicy.psd1`.

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

### -IncludePokemon

Amplía la selección elegible para evaluar Pokémon scripts. No anula `CachePolicy.psd1`; sólo se pueden almacenar en caché los nombres de Pokémon que figuran en `CacheablePokemonScripts`, y esa lista está actualmente vacía.

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

### -Name

Uno o más nombres script de colores para evaluar para el almacenamiento en caché. Admite patrones comodín (por ejemplo, `aurora-*` y `*-wave`). Los scripts coincidentes se almacenan en caché solo cuando figuran en `CachePolicy.psd1`. Cuando se omiten este parámetro y todos los filtros, solo se resuelven y evalúan las entradas de políticas.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
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

Desactive las secuencias de colores ANSI en la salida informativa. Esto es útil en entornos que no representan códigos de escape ANSI (como algunos registros CI/CD) y al mismo tiempo conservan la salida en color cuando se desea.

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

### -Parallel

Habilite la creación de caché de subprocesos múltiples. Cuando se especifica, el cmdlet ejecuta trabajos de caché en un grupo de espacio de ejecución para una finalización más rápida en sistemas compatibles. Úselo en combinación con `-ThrottleLimit` (o el alias `-Threads`) para controlar la cantidad de trabajadores simultáneos. Si no se pueden inicializar los subprocesos múltiples, el cmdlet vuelve automáticamente a la ejecución secuencial.

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

### -PassThru

Devuelve objetos de resultados detallados para cada operación de caché. De forma predeterminada, solo se muestra un resumen. Los objetos de resultado incluyen propiedades como Name, Estado, CacheFile, ExitCode, StdOut y StdErr, lo que permite la inspección programática del proceso de almacenamiento en caché.

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

### -Quiet

Suprime el progreso per-script y la salida de resumen informativo. Utilice este interruptor cuando solo desee una salida estructurada (a través de `-PassThru`) o cuando los escenarios de automatización deban silenciar los mensajes informativos y al mismo tiempo mostrar advertencias y errores.

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

Los filtros evaluaron scripts por etiqueta de metadatos (no distingue entre mayúsculas y minúsculas). Los valores múltiples se tratan como un filtro OR. Sólo se almacenan en caché las coincidencias permitidas por `CachePolicy.psd1`; otros partidos reportan `SkippedNotRequired` con `-PassThru`.

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

### -ThrottleLimit

Especifica el número máximo de trabajadores de caché simultáneos cuando se solicita `-Parallel`. Acepta valores del 1 al 256. El valor predeterminado (cuando se omite) es el número de procesadores lógicos en la máquina actual. El alias `-Threads` se proporciona por conveniencia. Los valores menores o iguales a uno vuelven automáticamente a la ejecución secuencial.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Threads
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

Muestra lo que sucedería si el cmdlet se ejecuta sin realizar realmente las operaciones de almacenamiento en caché. Útil para obtener una vista previa de qué scripts se almacenará en caché antes de comprometerse con la operación.

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Para obtener más información, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Puede canalizar nombres script a este cmdlet. Cada string se trata como un nombre potencial de script y admite coincidencias con comodines.

### System.String[]

Puede canalizar una matriz de nombres script o registros de metadatos con una propiedad `Name` a este cmdlet para el procesamiento por lotes.

## OUTPUTS

### System.Object

Cuando se especifica `-PassThru`, devuelve un objeto personalizado para cada script procesado que contiene las siguientes propiedades:

- **Name**: El nombre script de colores
- **ScriptPath**: Ruta completa al origen script de colores
- **CacheFile**: ruta completa al archivo de caché generado
- **Status**: `Updated`, `SkippedUpToDate`, `SkippedNotRequired`, `SkippedByUser` o `Failed`.
- **Message**: Detalle de estado localizado
- **CacheExists**: si existe una caché de salida después de la operación
- **ExitCode**: El código de salida de la ejecución de script (0 indica éxito)
- **StdOut**: salida estándar capturada durante la ejecución de script
- **StdErr**: Salida de error estándar capturada durante la ejecución de script

Sin `-PassThru`, escribe un resumen informativo conciso que contiene recuentos procesados, actualizados, omitidos y fallidos, además del directorio de caché efectivo.

## NOTES

**Autor:** Nick
**Módulo:** ColorScripts-Enhanced

**Alias:** `Update-ColorScriptCache` y `Build-ColorScriptCache`.

Los archivos de caché se almacenan en `(Get-ColorScriptConfiguration).Cache.EffectivePath`. Las firmas de origen y política en los metadatos complementarios se utilizan para determinar si una entrada permanece actual.

El cmdlet almacena en caché solo los representadores que requieren ejecución y están permitidos por la política de caché. Los scripts explícitos estáticos o no listados se informan como `SkippedNotRequired` y las entradas obsoletas se eliminan.

## RELATED LINKS

- [Versión en línea](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)

