---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exporta metadatos completos para todos los formatos scripts de colores a JSON o emite objetos estructurados a la canalización.

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Este comando no tiene alias.

## DESCRIPTION

El cmdlet `Export-ColorScriptMetadata` compila un inventario completo de todos los scripts de colores en el catálogo del módulo y genera un conjunto de datos estructurados que describe cada entrada. Estos metadatos incluyen información esencial, como nombres, categorías, etiquetas y enriquecimientos opcionales de script.

De forma predeterminada, el cmdlet devuelve objetos PowerShell a la canalización. Cuando se proporciona el parámetro `-Path`, escribe los metadatos con el formato JSON en el archivo especificado, creando automáticamente directorios principales si no existen.

El cmdlet ofrece dos indicadores de enriquecimiento opcionales:

- **IncludeFileInfo**: agrega metadatos del sistema de archivos, incluidas rutas completas, tamaños de archivos (en bytes) y marcas de tiempo de la última modificación.
- **IncludeCacheInfo**: agrega información relacionada con la caché, incluidas rutas de archivos de caché, estado de existencia y marcas de tiempo de caché

Este cmdlet es particularmente útil para:

- Creación de documentación o paneles que muestren todos los scripts de colores disponibles.
- Informar la presencia de archivos de carga útil de caché sin procesar y marcas de tiempo
- Alimentar metadatos a herramientas externas o canales de automatización.
- Auditoría del inventario del script de colores y del estado del sistema de archivos.
- Generación de informes sobre el uso y organización del script de colores.

La salida se ordena de manera consistente, lo que la hace adecuada para control de versiones y operaciones de diferenciación cuando se exporta a JSON.

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

Exporta metadatos básicos para todos los scripts de colores a la canalización sin información de archivo o caché.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

Devuelve objetos que incluyen detalles del sistema de archivos (ruta completa, tamaño y hora de la última escritura) para cada script de colores.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

Genera un archivo JSON que contiene metadatos básicos y lo escribe en el directorio `dist`, creando la carpeta si no existe.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

Genera un archivo JSON completo con metadatos enriquecidos que incluye información del sistema de archivos y de la caché, y lo escribe en el directorio `dist`.

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeCacheInfo -PassThru | Where-Object { -not $_.CacheExists }
```

Escribe el archivo de metadatos y devuelve registros cuya carga útil `.cache` sin procesar está ausente. Esto informa solo la ocupación del archivo, no la elegibilidad, validez o actualidad de la caché.

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

Agrupa scripts de colores por categoría y muestra recuentos, lo que resulta útil para analizar la distribución de scripts entre categorías.

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property ScriptSizeBytes -Sum).Sum
Write-Host "Tamaño total de todos los scripts de colores: $($totalSize / 1KB) KB"
```

Calcula el espacio total en disco utilizado por todos los archivos script de colores.

### EXAMPLE 8

```powershell
# Generar estadísticas y guardar informe.
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachePayloadFiles = ($metadata | Where-Object CacheExists).Count
    TotalScriptSizeBytes = ($metadata | Measure-Object ScriptSizeBytes -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

Genera estadísticas de inventario y cuenta archivos de carga útil `.cache` sin procesar. La presencia de carga útil no es una verificación de elegibilidad, validez o actualidad de la caché.

### EXAMPLE 9

```powershell
# Exportar y comparar con la copia de seguridad anterior
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "Scripts nuevos: $($new.Count) | Scripts eliminados: $($removed.Count)"
```

Compara los metadatos actuales con una versión anterior para identificar cambios.

### EXAMPLE 10

```powershell
# Crear una respuesta API para el panel web
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

Genera JSON listo para API con información de versiones y marcas de tiempo.

### EXAMPLE 11

```powershell
# Cree o valide cada entrada de caché seleccionada por política y revise los estados.
$results = New-ColorScriptCache -All -PassThru
$results | Group-Object Status | Select-Object Name, Count
```

Utiliza la política de caché como fuente de verdad e informa si las entradas elegibles se actualizaron, ya están actuales, se omitieron o fallaron.

### EXAMPLE 12

```powershell
# Crear galería HTML a partir de metadatos
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$html = @"
<html>
<head><title>ColorScripts-Enhanced Gallery</title></head>
<body>
<h1>ColorScripts-Enhanced</h1>
<ul>
"@
foreach ($script in $metadata) {
    $html += "<li><strong>$($script.Name)</strong> [$($script.Category)]</li>`n"
}
$html += "</ul></body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

Crea una página de galería HTML que enumera todos los scripts de colores disponibles.

### EXAMPLE 13

```powershell
# Monitorear los tamaños de script a lo largo del tiempo
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object ScriptSizeBytes -Average).Average) bytes avg" }
```

Realiza un seguimiento de los cambios de tamaño de archivo para scripts individuales a través de múltiples exportaciones.

## PARAMETERS

### -Confirm

Le solicita confirmación antes de ejecutar el cmdlet.

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

### -h

Muestra ayuda detallada para este comando sin realizar la operación.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -IncludeCacheInfo

Agrega la ruta de carga útil `.cache` sin procesar, el indicador de presencia de archivos y la marca de tiempo de la última escritura a cada registro. Estos campos no informan sobre la elegibilidad de la política de caché, la presencia, validez o actualidad del sidecar `.cacheinfo`.

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

### -IncludeFileInfo

Incluye detalles del sistema de archivos (ruta completa, tamaño en bytes y hora de la última escritura) en cada registro. Cuando los metadatos del archivo no se pueden leer (debido a permisos o archivos faltantes), los errores se registran mediante una salida detallada y las propiedades afectadas se establecen en valores nulos. Este modificador es valioso para auditar tamaños de archivos y fechas de modificación.

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

### -PassThru

Devuelve los objetos de metadatos a la canalización incluso cuando se especifica el parámetro `-Path`. Esto le permite guardar los metadatos en un archivo y realizar procesamiento o filtrado adicional en los objetos con un solo comando. Sin este interruptor, al especificar `-Path` se suprime la salida de la canalización.

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

### -Path

Especifica la ruta del archivo de destino para la exportación JSON. Admite rutas relativas, rutas absolutas, variables de entorno (por ejemplo, `$env:TEMP\metadata.json`) y expansión de tilde (por ejemplo, `~/Documents/metadata.json`). Los directorios principales se crean automáticamente si no existen. Cuando se omite este parámetro, el cmdlet genera objetos directamente en la canalización en lugar de escribirlos en un archivo. La salida JSON está formateada con sangría para facilitar la lectura.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
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

### -WhatIf

Ejecuta el comando en un modo que solo informa lo que sucedería sin realizar las acciones.

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

### None

Este cmdlet no acepta entradas de canalización.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Cuando no se especifica `-Path` o cuando se usa `-PassThru`, el cmdlet devuelve objetos personalizados. Cada objeto representa un único script de colores con las siguientes propiedades base:

- **Name**: nombre de archivo del script de colores sin extensión
- **Category**: La categoría organizacional principal
- **Categories**: Todas las categorías asignadas
- **Tags**: una serie de etiquetas descriptivas para filtrar y buscar
- **Description**: La descripción de metadatos

Cuando se especifica `-IncludeFileInfo`, se incluyen estas propiedades adicionales:

- **ScriptPath**: la ruta completa del sistema de archivos al archivo script
- **ScriptSizeBytes**: Tamaño en bytes (nulo si el archivo es inaccesible)
- **ScriptLastWriteTimeUtc**: marca de tiempo UTC de la última modificación (nula si no está disponible)

Cuando se especifica `-IncludeCacheInfo`, se incluyen estas propiedades adicionales:

- **CachePath**: la ruta completa al archivo de caché correspondiente
- **CacheExists**: Booleano que indica si existe un archivo de caché
- **CacheLastWriteTimeUtc**: marca de tiempo UTC de la modificación del archivo de caché (nulo si el caché no existe)

## NOTES

## RELATED LINKS

- [Versión en línea](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

