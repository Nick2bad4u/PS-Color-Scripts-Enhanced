---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exporta metadatos completos para todos los colorescripts a formato JSON o emite objetos estructurados al pipeline.

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

El cmdlet `Export-ColorScriptMetadata` compila un inventario completo de todos los colorescripts en el catálogo del módulo y genera un conjunto de datos estructurado que describe cada entrada. Estos metadatos incluyen información esencial como nombres de scripts, categorías, etiquetas y enriquecimientos opcionales.

Por defecto, el cmdlet devuelve objetos de PowerShell al pipeline. Cuando se proporciona el parámetro `-Path`, escribe los metadatos como JSON formateado en el archivo especificado, creando automáticamente los directorios padre si no existen.

El cmdlet ofrece dos indicadores opcionales de enriquecimiento:

- **IncludeFileInfo**: Agrega metadatos del sistema de archivos incluyendo rutas completas, tamaños de archivo (en bytes) y marcas de tiempo de última modificación
- **IncludeCacheInfo**: Agrega información relacionada con la caché incluyendo rutas de archivos de caché, estado de existencia y marcas de tiempo de caché

Este cmdlet es particularmente útil para:

- Crear documentación o dashboards que muestren todos los colorescripts disponibles
- Analizar la cobertura de caché e identificar scripts que necesiten reconstrucción de caché
- Alimentar metadatos a herramientas externas o automatizaciones de pipelines
- Auditar el inventario de colorescripts y el estado del sistema de archivos
- Generar informes sobre el uso y organización de colorescripts

La salida se ordena de manera consistente, lo que la hace adecuada para control de versiones y operaciones de diff cuando se exporta a JSON.

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

Exporta metadatos básicos para todos los colorescripts al pipeline sin información de archivo o caché.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

Devuelve objetos que incluyen detalles del sistema de archivos (ruta completa, tamaño y hora de última escritura) para cada colorscript.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

Genera un archivo JSON que contiene metadatos básicos y lo escribe en el directorio `dist`, creando la carpeta si no existe.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

Genera un archivo JSON completo con metadatos enriquecidos incluyendo tanto información del sistema de archivos como de caché, escribiéndolo en el directorio `dist`.

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -PassThru | Where-Object { -not $_.CacheExists }
```

Escribe el archivo de metadatos y también devuelve los objetos al pipeline, permitiendo consultas que identifiquen scripts sin archivos de caché.

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

Agrupa los colorescripts por categoría y muestra recuentos, útil para analizar la distribución de scripts en categorías.

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property FileSize -Sum).Sum
Write-Host "Total size of all colorscripts: $($totalSize / 1KB) KB"
```

Calcula el espacio total en disco utilizado por todos los archivos de colorscript.

### EXAMPLE 8

```powershell
# Generate statistics and save report
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachedScripts = ($metadata | Where-Object CacheExists).Count
    TotalFileSize = ($metadata | Measure-Object FileSize -Sum).Sum
    TotalCacheSize = ($metadata | Where-Object CacheExists |
        Measure-Object CacheFileSize -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

Genera un informe de estadísticas completo incluyendo cobertura de caché y tamaños.

### EXAMPLE 9

```powershell
# Export and compare with previous backup
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "New scripts: $($new.Count) | Removed scripts: $($removed.Count)"
```

Compara los metadatos actuales con una versión anterior para identificar cambios.

### EXAMPLE 10

```powershell
# Build API response for web dashboard
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

Genera JSON listo para API con información de versionado y marca de tiempo.

### EXAMPLE 11

```powershell
# Find scripts with missing cache for batch rebuild
$metadata = Export-ColorScriptMetadata -IncludeCacheInfo -AsObject
$uncached = $metadata | Where-Object { -not $_.CacheExists } | Select-Object -ExpandProperty Name
if ($uncached.Count -gt 0) {
    Write-Host "Rebuilding cache for $($uncached.Count) scripts..."
    New-ColorScriptCache -Name $uncached
}
```

Identifica y reconstruye la caché para scripts que no tienen archivos de caché.

### EXAMPLE 12

```powershell
# Create HTML gallery from metadata
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

Crea una página de galería HTML que lista todos los colorescripts disponibles.

### EXAMPLE 13

```powershell
# Monitor script sizes over time
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object FileSize -Average).Average) bytes avg" }
```

Realiza un seguimiento de los cambios de tamaño de archivo para scripts individuales en múltiples exportaciones.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

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

Muestra la ayuda detallada de este comando sin realizar la operación.

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

Aumenta cada registro con metadatos de caché, incluyendo la ruta del archivo de caché, si existe un archivo de caché y su marca de tiempo de última modificación. Esto es útil para identificar scripts que pueden necesitar regeneración de caché o analizar la cobertura de caché en la biblioteca de colorescripts.

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

Incluye detalles del sistema de archivos (ruta completa, tamaño en bytes y hora de última escritura) en cada registro. Cuando los metadatos del archivo no se pueden leer (debido a permisos o archivos faltantes), los errores se registran a través de salida detallada y las propiedades afectadas se establecen en valores nulos. Este interruptor es valioso para auditar tamaños de archivos y fechas de modificación.

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

Devuelve los objetos de metadatos al pipeline incluso cuando se especifica el parámetro `-Path`. Esto permite guardar los metadatos en un archivo y realizar procesamiento o filtrado adicional en los objetos en un solo comando. Sin este interruptor, especificar `-Path` suprime la salida del pipeline.

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

Especifica la ruta del archivo de destino para la exportación JSON. Soporta rutas relativas, absolutas, variables de entorno (ej. `$env:TEMP\metadata.json`) y expansión de tilde (ej. `~/Documents/metadata.json`). Los directorios padre se crean automáticamente si no existen. Cuando se omite este parámetro, el cmdlet genera objetos directamente al pipeline en lugar de escribir en un archivo. La salida JSON se formatea con sangría para legibilidad.

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

Runs the command in a mode that only reports what would happen without performing the actions.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet no acepta entrada de pipeline.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Cuando `-Path` no se especifica, o cuando se usa `-PassThru`, el cmdlet devuelve objetos personalizados. Cada objeto representa un solo colorscript con las siguientes propiedades base:

- **Name**: El nombre del archivo del colorscript sin extensión
- **Category**: La categoría organizacional (ej. "nature", "abstract", "geometric")
- **Tags**: Una matriz de etiquetas descriptivas para filtrado y búsqueda

Cuando se especifica `-IncludeFileInfo`, se incluyen estas propiedades adicionales:

- **FilePath**: La ruta completa del sistema de archivos al archivo de script
- **FileSize**: Tamaño en bytes (nulo si el archivo es inaccesible)
- **LastWriteTime**: Marca de tiempo de última modificación (nulo si no está disponible)

Cuando se especifica `-IncludeCacheInfo`, se incluyen estas propiedades adicionales:

- **CachePath**: La ruta completa al archivo de caché correspondiente
- **CacheExists**: Booleano que indica si existe un archivo de caché
- **CacheLastWriteTime**: Marca de tiempo de modificación del archivo de caché (nulo si la caché no existe)

## NOTES

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

