---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/es/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

Pre-construir o refrescar archivos de caché de colorescript para una renderización más rápida.

## DESCRIPTION

`New-ColorScriptCache` ejecuta colorescripts en una instancia de PowerShell en segundo plano y guarda la salida renderizada usando codificación UTF-8 (sin BOM). El contenido en caché acelera drásticamente las llamadas subsiguientes a `Show-ColorScript` al eliminar la necesidad de re-ejecutar scripts. También puedes usar el alias `Update-ColorScriptCache` para invocar este cmdlet.

Puedes apuntar a scripts específicos por nombre (se admiten comodines) o almacenar en caché toda la colección. Cuando no se especifican parámetros, el cmdlet por defecto almacena en caché todos los scripts disponibles. También puedes filtrar scripts por categoría o etiqueta para almacenar en caché solo aquellos que coincidan con criterios específicos.

Por defecto, el cmdlet muestra un resumen conciso de la operación de almacenamiento en caché. Usa `-PassThru` para devolver objetos de resultado detallados para cada script, que puedes inspeccionar programáticamente para el estado, salida estándar y flujos de error.

El cmdlet omite inteligentemente los scripts cuyos archivos de caché ya están actualizados a menos que especifiques el parámetro `-Force` para reconstruir todos los cachés independientemente de su estado actual.

## SYNTAX

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Named

```
New-ColorScriptCache [-Name <String[]>] [-Category <String[]>] [-Tag <String[]>] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Calienta el caché para cada script que se incluye con el módulo. Este es el comportamiento por defecto cuando no se especifican parámetros.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name bars, 'aurora-*'
```

Almacena en caché una mezcla de coincidencias exactas y comodines. El cmdlet procesará el script 'bars' y todos los scripts cuyos nombres comiencen con 'aurora-'.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name mandelbrot-zoom -Force -PassThru | Format-List
```

Fuerza una reconstrucción del caché de 'mandelbrot-zoom' incluso si está actualizado, y examina el objeto de resultado detallado.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Animation' -PassThru
```

Almacena en caché todos los scripts en la categoría 'Animation' y devuelve resultados detallados para cada operación.

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Reconstruye cachés para todos los scripts etiquetados con 'geometric' o 'colorful', forzando la regeneración incluso si los cachés están actuales.

### EXAMPLE 6

```powershell
Get-ColorScriptList | Where-Object Category -eq 'Classic' | New-ColorScriptCache -PassThru
```

Ejemplo de pipeline: recupera todos los scripts clásicos y los almacena en caché, devolviendo resultados detallados.

### EXAMPLE 7

```powershell
# Verificar estadísticas de caché después de construir
$before = @(Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter "*.cache").Count
Write-Host "Scripts en caché: $before -> $after"
```

Mide el crecimiento del caché contando archivos de caché antes y después de la operación.

### EXAMPLE 8

```powershell
# Construir caché para scripts usados frecuentemente solo
$frequentScripts = @('bars', 'arch', 'mandelbrot-zoom', 'aurora-waves', 'galaxy-spiral')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

Almacena en caché solo los scripts más accedidos frecuentemente para un rendimiento más rápido en producción.

### EXAMPLE 9

```powershell
# Monitorear construcción de caché con seguimiento de progreso
$scripts = Get-ColorScriptList -AsObject
$total = $scripts.Count
$current = 0
$scripts | ForEach-Object {
    $current++
    Write-Progress -Activity "Building cache" -Status $_.Name -PercentComplete (($current / $total) * 100)
    New-ColorScriptCache -Name $_.Name | Out-Null
}
Write-Progress -Activity "Building cache" -Completed
```

Proporciona retroalimentación visual de progreso mientras construye el caché.

### EXAMPLE 10

```powershell
# Programar reconstrucción de caché al cargar módulo
# Agregar al perfil de PowerShell:
Import-Module ColorScripts-Enhanced
if ((Get-Date).Day % 7 -eq 0) {  # Reconstrucción semanal
    New-ColorScriptCache -Force | Out-Null
}
```

Reconstruye automáticamente el caché semanalmente cuando se carga el módulo.

### EXAMPLE 11

```powershell
# Almacenar en caché categoría específica para despliegue
New-ColorScriptCache -Category 'Recommended' -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

Almacena en caché scripts recomendados y exporta los resultados a un manifiesto de despliegue.

### EXAMPLE 12

```powershell
# Verificar que el caché se construyó exitosamente
New-ColorScriptCache -Name "mandelbrot-zoom" -Force -PassThru |
    Where-Object { $_.ExitCode -ne 0 } |
    Select-Object Name, StdErr
```

Identifica cualquier fallo de almacenamiento en caché filtrando por códigos de salida no cero.

### EXAMPLE 13

```powershell
# Almacenar en caché todos los scripts animados
New-ColorScriptCache -Tag Animated -PassThru |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Almacena en caché todos los scripts etiquetados como animados y muestra el conteo de scripts en caché.

## PARAMETERS

### -All

Almacena en caché cada script disponible. Cuando se omite y no se proporcionan nombres, todos los scripts se almacenan en caché por defecto. Este parámetro es útil cuando quieres ser explícito sobre almacenar en caché todos los scripts.

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

Limita la selección a scripts que pertenecen a la categoría especificada (sin distinción de mayúsculas). Los valores múltiples se tratan como un filtro OR, lo que significa que se almacenarán en caché los scripts que coincidan con cualquiera de las categorías especificadas.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Named
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Pide confirmación antes de ejecutar el cmdlet. Útil cuando se almacenan en caché un gran número de scripts o cuando se usa `-Force` para prevenir regeneración accidental de caché.

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

Reconstruye archivos de caché incluso cuando el caché existente es más nuevo que la fuente del script. Esto es útil cuando quieres asegurar que todos los cachés se regeneren, como después de actualizaciones del módulo o cuando se solucionan problemas de renderización.

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

### -Name

Uno o más nombres de colorescript para almacenar en caché. Admite patrones de comodines (ej. 'aurora-*', '*-wave'). Cuando este parámetro se omite y no se especifican parámetros de filtrado, el cmdlet almacena en caché todos los scripts disponibles por defecto.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Named
  Position: 0
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PassThru

Devuelve objetos de resultado detallados para cada operación de caché. Por defecto, solo se muestra un resumen. Los objetos de resultado incluyen propiedades como Name, Status, CacheFile, ExitCode, StdOut y StdErr, permitiendo inspección programática del proceso de almacenamiento en caché.

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

### -Tag

Limita la selección a scripts que contienen las etiquetas de metadatos especificadas (sin distinción de mayúsculas). Los valores múltiples se tratan como un filtro OR, almacenando en caché scripts que coincidan con cualquiera de las etiquetas especificadas.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Named
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Muestra qué sucedería si el cmdlet se ejecuta sin realizar realmente las operaciones de almacenamiento en caché. Útil para previsualizar qué scripts se almacenarían en caché antes de comprometerse con la operación.

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

Este cmdlet admite los parámetros comunes: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction y -WarningVariable. Para más información, vea
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Puedes canalizar nombres de script a este cmdlet. Cada cadena se trata como un nombre de script potencial y admite coincidencia de comodines.

### System.String[]

Puedes canalizar una matriz de nombres de script o registros de metadatos con una propiedad `Name` a este cmdlet para procesamiento por lotes.

## OUTPUTS

### System.Object

Cuando se especifica `-PassThru`, devuelve un objeto personalizado para cada script procesado que contiene las siguientes propiedades:

- **Name**: El nombre del colorescript
- **Status**: Éxito, Omitido o Fallido
- **CacheFile**: Ruta completa al archivo de caché generado
- **ExitCode**: El código de salida de la ejecución del script (0 indica éxito)
- **StdOut**: Salida estándar capturada durante la ejecución del script
- **StdErr**: Salida de error estándar capturada durante la ejecución del script

Sin `-PassThru`, muestra una tabla de resumen concisa en la consola mostrando el número de scripts almacenados en caché, omitidos y fallidos.

## ADVANCED USAGE PATTERNS

### Estrategias de Construcción de Caché

**Caché de Producción Completo**
```powershell
# Construir todos los cachés para entorno de producción
New-ColorScriptCache -Force | Measure-Object
Write-Host "Caché construido exitosamente"

# Verificar que los archivos de caché existen
Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter "*.cache" | Measure-Object
```

**Caché de Producción Mínimo**
```powershell
# Almacenar en caché solo scripts recomendados para huella mínima
New-ColorScriptCache -Tag Recommended -PassThru |
    Select-Object Name, Status, CacheFile
```

**Almacenamiento en Caché de Categoría Selectiva**
```powershell
# Almacenar en caché categorías específicas basadas en entorno
$categories = if ($env:CI) { @("Simple", "Fast") } else { @("*") }

Get-ColorScriptList -Category $categories -AsObject |
    ForEach-Object { New-ColorScriptCache -Name $_.Name }
```

### Monitoreo de Rendimiento

**Progreso de Construcción de Caché**
```powershell
# Monitorear construcción de caché con progreso
$scripts = Get-ColorScriptList -AsObject
$total = $scripts.Count
$counter = 0

$scripts | ForEach-Object {
    $counter++
    Write-Progress -Activity "Building Cache" `
                   -Status $_.Name `
                   -PercentComplete (($counter / $total) * 100)
    New-ColorScriptCache -Name $_.Name | Out-Null
}
Write-Progress -Activity "Building Cache" -Completed
```

**Informe de Comparación de Rendimiento**
```powershell
# Comparar tiempos de construcción de caché
$results = @()
Get-ColorScriptList -Category Geometric -AsObject | ForEach-Object {
    $time = Measure-Command { New-ColorScriptCache -Name $_.Name -Force } | Select-Object -ExpandProperty TotalMilliseconds
    $results += [PSCustomObject]@{
        Script = $_.Name
        BuildTime = [math]::Round($time, 2)
    }
}
$results | Sort-Object BuildTime -Descending | Format-Table
```

### Mantenimiento y Limpieza

**Reconstrucción de Caché Programada**
```powershell
# Reconstruir caché semanalmente
$lastRun = Get-Item "$env:APPDATA\ColorScripts-Enhanced\cache" | Select-Object -ExpandProperty LastWriteTime
$daysSince = ((Get-Date) - $lastRun).Days

if ($daysSince -ge 7) {
    Write-Host "Reconstruyendo caché..."
    New-ColorScriptCache -Force
}
```

**Actualizaciones Selectivas de Caché**
```powershell
# Actualizar solo cachés obsoletos
$scripts = Get-ColorScriptList -AsObject
$scripts | ForEach-Object {
    $cacheFile = "$env:APPDATA\ColorScripts-Enhanced\cache\$($_.Name).cache"
    if (-not (Test-Path $cacheFile) -or (Get-Item $cacheFile).LastWriteTime -lt (Get-Date).AddDays(-30)) {
        New-ColorScriptCache -Name $_.Name -PassThru
    }
}
```

### Integración CI/CD

**Construir Caché en Docker**
```powershell
# En Dockerfile o script de construcción
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Force | Out-Null
Write-Host "✓ Caché de ColorScripts construido"
```

**Archivo de Caché para Despliegue**
```powershell
# Archivar caché para despliegue
$cacheDir = "$env:APPDATA\ColorScripts-Enhanced\cache"
$archive = "./colorscripts-cache.zip"

Compress-Archive -Path "$cacheDir\*" -DestinationPath $archive -Force
Write-Host "Caché archivado: $archive"
```

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced

**Aliases:** Este cmdlet también se puede llamar usando el alias `Update-ColorScriptCache`, que es útil para scripts que refrescan cachés existentes.

Los archivos de caché se almacenan en el directorio expuesto por la variable `CacheDir` del módulo (típicamente dentro del directorio de datos del módulo). Una construcción exitosa establece la marca de tiempo del archivo de caché para que coincida con la hora de escritura del script, permitiendo que ejecuciones subsiguientes omitan scripts sin cambios de manera eficiente.

El cmdlet ejecuta cada script en un proceso de PowerShell en segundo plano aislado para capturar su salida sin afectar la sesión actual. Esto asegura el almacenamiento en caché preciso de la salida exacta de la consola que se mostraría al ejecutar el script directamente.

**Mejores Prácticas:**
- Ejecutar una vez después de la instalación del módulo para pre-almacenar en caché todos los scripts
- Usar `-Force` solo cuando necesites reconstruir todos los cachés
- Filtrar por categoría o etiqueta para construcciones de caché dirigidas más rápidas
- Monitorear tiempos de construcción para identificar scripts de renderización lenta
- Programar reconstrucciones periódicas para mantener el caché actual
- Usar `-PassThru` en automatización para reportes de estado detallados
- Considerar usar `-WhatIf` antes de operaciones de caché grandes

**Consejo de Rendimiento:** Ejecuta este cmdlet una vez después de instalar o actualizar el módulo para pre-almacenar en caché todos los scripts para un rendimiento óptimo.

**Solución de Problemas:**
- Si la construcción de caché falla, verifica la sintaxis del script con `Show-ColorScript -Name scriptname -NoCache`
- Monitorea el espacio en disco para el crecimiento del directorio de caché
- Usa `-PassThru` para identificar qué scripts fallaron en la construcción
- Limpia y reconstruye si el caché se corrompe: `Clear-ColorScriptCache -All; New-ColorScriptCache`

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
