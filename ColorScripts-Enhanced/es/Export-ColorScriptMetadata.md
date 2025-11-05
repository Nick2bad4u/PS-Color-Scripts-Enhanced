---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/es/Export-ColorScriptMetadata.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exporta metadatos completos para todos los colorescripts a formato JSON o emite objetos estructurados al pipeline.

## SYNTAX

### Default (Default)

```
Export-ColorScriptMetadata [-Path <String>] [-IncludeFileInfo] [-IncludeCacheInfo] [-PassThru]
 [<CommonParameters>]
```

### \_\_AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-IncludeFileInfo] [-IncludeCacheInfo] [-PassThru]
 [<CommonParameters>]
```

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
HelpMessage: ""
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
HelpMessage: ""
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
HelpMessage: ""
```

### -Path

Especifica la ruta del archivo de destino para la exportación JSON. Soporta rutas relativas, absolutas, variables de entorno (ej. `$env:TEMP\metadata.json`) y expansión de tilde (ej. `~/Documents/metadata.json`). Los directorios padre se crean automáticamente si no existen. Cuando se omite este parámetro, el cmdlet genera objetos directamente al pipeline en lugar de escribir en un archivo. La salida JSON se formatea con sangría para legibilidad.

```yaml
Type: System.String
DefaultValue: None
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
HelpMessage: ""
```

### CommonParameters

Este cmdlet soporta los parámetros comunes: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, y -WarningVariable. Para más información, vea
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

## ADVANCED USAGE PATTERNS

### Data Analysis and Reporting

**Comprehensive Inventory Report**

```powershell
# Generate complete inventory with all metadata
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo -PassThru

$report = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    TotalFileSize = ($metadata | Measure-Object -Property FileSize -Sum).Sum
    CachedScripts = ($metadata | Where-Object { $_.CacheExists }).Count
    CacheSize = ($metadata | Where-Object { $_.CacheExists } | Measure-Object -Property CacheFileSize -Sum).Sum
}

$report | ConvertTo-Json | Out-File "./inventory-report.json"
```

**Category Distribution Analysis**

```powershell
# Analyze distribution across categories
$metadata = Export-ColorScriptMetadata -IncludeFileInfo

$categories = $metadata | Group-Object Category | ForEach-Object {
    [PSCustomObject]@{
        Category = $_.Name
        Count = $_.Count
        TotalSize = ($_.Group | Measure-Object FileSize -Sum).Sum
        AverageSize = [math]::Round(($_.Group | Measure-Object FileSize -Average).Average, 0)
    }
}

$categories | Sort-Object Count -Descending | Format-Table
```

**Cache Coverage Analysis**

```powershell
# Identify cache gaps
$metadata = Export-ColorScriptMetadata -IncludeCacheInfo -PassThru

$uncached = $metadata | Where-Object { -not $_.CacheExists }
$cached = $metadata | Where-Object { $_.CacheExists }

Write-Host "Cache coverage: $([math]::Round($cached.Count / $metadata.Count * 100, 1))%"
Write-Host "Scripts without cache: $($uncached.Count)"

$uncached | Select-Object Name, Category | Format-Table
```

### Integration Workflows

**API Response Generation**

```powershell
# Build versioned API response
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object -ExpandProperty Version).ToString()
    timestamp = (Get-Date -Format 'o')
    scriptCount = $metadata.Count
    scripts = $metadata | Select-Object Name, Category, Tags, Description
    cacheStats = @{
        cached = ($metadata | Where-Object CacheExists).Count
        total = $metadata.Count
    }
} | ConvertTo-Json -Depth 5

$apiResponse | Out-File "./api/colorscripts-v1.json" -Encoding UTF8
```

**Web Gallery Generation**

```powershell
# Create interactive HTML gallery
$metadata = Export-ColorScriptMetadata -Detailed

$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>ColorScripts-Enhanced Gallery</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .script { border: 1px solid #ccc; padding: 10px; margin: 10px 0; }
    </style>
</head>
<body>
<h1>ColorScripts-Enhanced - $($metadata.Count) Scripts</h1>
"@

$metadata | ForEach-Object {
    $html += "<div class='script'><strong>$($_.Name)</strong> [$($_.Category)]<br/>Tags: $(($_.Tags -join ', '))</div>`n"
}

$html += "</body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

**Change Tracking**

```powershell
# Compare current state with previous export
Export-ColorScriptMetadata -Path "./metadata-current.json" -IncludeFileInfo

$current = Get-Content "./metadata-current.json" | ConvertFrom-Json
$previous = Get-Content "./metadata-previous.json" -ErrorAction SilentlyContinue | ConvertFrom-Json

if ($previous) {
    $added = $current | Where-Object { $_.Name -notin $previous.Name }
    $removed = $previous | Where-Object { $_.Name -notin $current.Name }

    Write-Host "Added: $($added.Count) scripts"
    Write-Host "Removed: $($removed.Count) scripts"
}
```

### Maintenance and Validation

**Health Check Automation**

```powershell
# Validate all scripts and cache status
$metadata = Export-ColorScriptMetadata -IncludeCacheInfo -IncludeFileInfo -PassThru

$health = $metadata | ForEach-Object {
    @{
        Name = $_.Name
        FileExists = Test-Path $_.FilePath
        Cached = $_.CacheExists
        FileAge = if (Test-Path $_.FilePath) { (Get-Date) - (Get-Item $_.FilePath).LastWriteTime } else { $null }
    }
}

$health | Where-Object { -not $_.FileExists -or -not $_.Cached } | Format-Table
```

**Performance Metrics**

```powershell
# Export with performance data
$startTime = Get-Date
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo

$metrics = @{
    ExportTime = ((Get-Date) - $startTime).TotalMilliseconds
    ScriptCount = $metadata.Count
    TotalFileSize = ($metadata | Measure-Object FileSize -Sum).Sum
    CacheHitRate = ($metadata | Where-Object CacheExists).Count / $metadata.Count
}

$metrics | ConvertTo-Json | Out-File "./performance.json"
```

### Backup and Disaster Recovery

**Metadata Backup**

```powershell
# Create timestamped metadata backup
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
Export-ColorScriptMetadata -Path "./backups/metadata-$timestamp.json" -IncludeFileInfo -IncludeCacheInfo

# Keep only last 5 backups
Get-ChildItem "./backups/metadata-*.json" | Sort-Object Name -Descending | Select-Object -Skip 5 | Remove-Item
```

**Recovery Validation**

```powershell
# Validate backed-up metadata against current state
$backup = Get-Content "./backups/metadata-latest.json" | ConvertFrom-Json
$current = Export-ColorScriptMetadata -PassThru

$missing = $backup | Where-Object { $_.Name -notin $current.Name }
if ($missing.Count -gt 0) {
    Write-Warning "Missing from current: $($missing.Count) scripts"
}
```

## NOTES

**Performance Considerations:**

- Agregar `-IncludeFileInfo` o `-IncludeCacheInfo` requiere operaciones de I/O del sistema de archivos y puede impactar el rendimiento al procesar bibliotecas grandes de colorescripts.
- Para exportaciones grandes, considere usar `-PassThru` con filtrado de pipeline en lugar de cargar todo en memoria
- Las operaciones de exportación escalan linealmente con el conteo de scripts

**Cache Directory Management:**

- La recopilación de metadatos de caché asegura que el directorio de caché exista antes de intentar leer archivos de caché.
- Cuando los archivos de caché faltan o no están disponibles, la propiedad `CacheExists` se establece en `false` y `CacheLastWriteTime` se establece en null.

**Error Handling:**

- Los errores de lectura de metadatos de archivo se reportan a través de salida detallada (`-Verbose`) en lugar de terminar el cmdlet.
- Los errores de archivos individuales resultan en valores nulos para las propiedades afectadas mientras permiten que el cmdlet continúe procesando los colorescripts restantes.

**JSON Output Format:**

- Los archivos JSON se escriben con sangría (profundidad 2) para legibilidad humana.
- La codificación de salida es UTF-8 para máxima compatibilidad.
- Los archivos existentes en la ruta de destino se sobrescriben sin preguntar.

**Best Practices:**

- Programe exportaciones regulares de metadatos para auditoría
- Versione sus exportaciones de metadatos con marcas de tiempo
- Use `-PassThru` para exportación de archivos y procesamiento de pipeline
- Almacene copias de seguridad en sistemas de control de versiones o respaldo
- Monitoree el crecimiento del tamaño de archivo de exportación con el tiempo

**Use Cases:**

- Integración con pipelines de CI/CD para generación de documentación
- Construcción de dashboards web o endpoints de API que sirvan metadatos de colorescripts
- Creación de informes de inventario para colecciones grandes de colorescripts
- Identificación de scripts que requieren regeneración de caché
- Seguimiento de cambios y mantenimiento de registros de auditoría

## RELATED LINKS

- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
