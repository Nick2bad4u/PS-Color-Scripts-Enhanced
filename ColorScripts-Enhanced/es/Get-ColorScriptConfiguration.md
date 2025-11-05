---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/es/Get-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Recupera la configuración actual del módulo ColorScripts-Enhanced.

## SYNTAX

```
Get-ColorScriptConfiguration [<CommonParameters>]
```

## DESCRIPTION

`Get-ColorScriptConfiguration` recupera la configuración efectiva del módulo, que controla varios aspectos del comportamiento de ColorScripts-Enhanced. Esto incluye:

- **Cache Settings**: Ubicación donde se almacenan metadatos de scripts e índices para optimización del rendimiento
- **Startup Behavior**: Indicadores que controlan si los scripts se ejecutan automáticamente al iniciar sesiones de PowerShell
- **Path Configuration**: Directorios de scripts personalizados y rutas de búsqueda
- **Display Preferences**: Opciones de formato y salida predeterminadas

La configuración se ensambla desde múltiples fuentes en orden de precedencia:

1. Valores predeterminados integrados del módulo (prioridad más baja)
2. Anulaciones de usuario persistidas desde el archivo de configuración
3. Modificaciones específicas de sesión (prioridad más alta)

El archivo de configuración se encuentra típicamente en `%APPDATA%\ColorScripts-Enhanced\config.json` en Windows o `~/.config/ColorScripts-Enhanced/config.json` en sistemas similares a Unix.

La tabla hash devuelta es una instantánea del estado actual de la configuración y puede inspeccionarse, clonarse o serializarse de forma segura sin afectar la configuración activa.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Muestra la configuración actual utilizando la vista de tabla predeterminada, mostrando todas las configuraciones de caché y inicio.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serializa la configuración a formato JSON para registro, depuración o exportación a otras herramientas.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.Location
```

Recupera la configuración y accede a la ruta de ubicación del caché directamente desde la tabla hash.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.Enabled) {
    Write-Host "Startup scripts are enabled"
}
```

Verifica si los scripts de inicio están habilitados en la configuración actual.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Muestra todas las propiedades de configuración en un formato de lista detallada para inspección completa.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Cache Path: $($config.Cache.Path)"
Write-Host "Profile Auto-Show: $($config.Startup.ProfileAutoShow)"
Write-Host "Default Script: $($config.Startup.DefaultScript)"
```

Extrae y muestra propiedades específicas de configuración para auditoría o scripting.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Custom cache path configured: $($config.Cache.Path)"
} else {
    Write-Host "Using default cache path"
}
```

Determina si se configura una ruta de caché personalizada versus usar valores predeterminados del módulo.

### EXAMPLE 8

```powershell
Export-ColorScriptMetadata | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Hace una copia de seguridad de la configuración actual a un archivo JSON para archivado o recuperación de desastres.

### EXAMPLE 9

```powershell
# Compare current config with defaults
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Review the -WhatIf output to see what would change
```

Compara la configuración actual con los valores predeterminados del módulo para identificar configuraciones personalizadas.

### EXAMPLE 10

```powershell
# Monitor configuration changes across sessions
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Crea instantáneas con marca de tiempo de la configuración para rastrear cambios a lo largo del tiempo.

## PARAMETERS

### CommonParameters

Este cmdlet admite los parámetros comunes: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Para más información, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet no acepta entrada de pipeline.

## OUTPUTS

### System.Collections.Hashtable

Devuelve una tabla hash anidada que contiene la siguiente estructura:

- **Cache** (Hashtable): Configuraciones relacionadas con el caché
  - **Location** (String): Ruta al directorio de caché
  - **Enabled** (Boolean): Si el caché está activo
- **Startup** (Hashtable): Configuraciones de comportamiento de inicio
  - **Enabled** (Boolean): Si los scripts se ejecutan al inicio de sesión
  - **ScriptName** (String): Nombre del script de inicio predeterminado
- **Paths** (Array): Rutas de búsqueda de scripts adicionales
- **Display** (Hashtable): Preferencias de formato de salida

## ADVANCED USAGE PATTERNS

### Configuration Analysis and Auditing

**Full Configuration Audit**

```powershell
# Comprehensive configuration review
$config = Get-ColorScriptConfiguration

[PSCustomObject]@{
    CachePath = $config.Cache.Path
    CacheEnabled = $config.Cache.Enabled
    CacheSize = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    StartupEnabled = $config.Startup.ProfileAutoShow
    DefaultScript = $config.DefaultScript
} | Format-List
```

**Comparison with Defaults**

```powershell
# Identify customizations from defaults
$current = Get-ColorScriptConfiguration | ConvertTo-Json

# Export for comparison
$current | Out-File "./current-config.json"

# Check for customizations
if ($current -ne (Get-Content "./default-config.json")) {
    Write-Host "✓ Custom configuration detected"
}
```

### Environment-Specific Configuration

**Environment Detection**

```powershell
# Detect environment and report appropriate config
$config = Get-ColorScriptConfiguration

$environment = switch ($true) {
    ($env:CI) { "CI/CD" }
    ($env:SSH_CONNECTION) { "SSH Session" }
    ($env:WT_SESSION) { "Windows Terminal" }
    ($env:TERM_PROGRAM) { "$env:TERM_PROGRAM" }
    default { "Local" }
}

Write-Host "Environment: $environment"
Write-Host "Cache: $($config.Cache.Path)"
Write-Host "Startup: $($config.Startup.ProfileAutoShow)"
```

**Multi-Environment Management**

```powershell
# Track configuration across environments
@(
    [PSCustomObject]@{ Environment = "Local"; Config = Get-ColorScriptConfiguration }
    [PSCustomObject]@{ Environment = "CI"; Config = Invoke-Command -ComputerName ci-server { Get-ColorScriptConfiguration } }
) | ForEach-Object {
    Write-Host "=== $($_.Environment) ==="
    $_.Config | Select-Object -ExpandProperty Cache | Format-Table
}
```

### Configuration Validation

**Health Check**

```powershell
# Validate configuration integrity
$config = Get-ColorScriptConfiguration

$checks = @{
    CachePathExists = Test-Path $config.Cache.Path
    CachePathWritable = Test-Path $config.Cache.Path -PathType Container
    CacheFilesPresent = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue).Count -gt 0
}

$checks | ConvertTo-Json | Write-Host
```

**Configuration Consistency**

```powershell
# Verify configuration settings are consistent
$config = Get-ColorScriptConfiguration

$validSettings = @{
    CacheEnabled = $config.Cache.Enabled -is [bool]
    PathIsString = $config.Cache.Path -is [string]
    CachePathNotEmpty = -not [string]::IsNullOrEmpty($config.Cache.Path)
}

if ($validSettings.Values -notcontains $false) {
    Write-Host "✓ Configuration is valid"
}
```

### Configuration Backup and Recovery

**Backup Current Configuration**

```powershell
# Create configuration backup
$config = Get-ColorScriptConfiguration
$backup = @{
    Timestamp = Get-Date
    Configuration = $config
    ModuleVersion = (Get-Module ColorScripts-Enhanced | Select-Object -ExpandProperty Version)
}

$backup | ConvertTo-Json | Out-File "./config-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
```

**Configuration Migration**

```powershell
# Export configuration for migration to new system
$config = Get-ColorScriptConfiguration

$exportConfig = @{
    CachePath = $config.Cache.Path
    Startup = $config.Startup
    Customizations = @{
        # Add any custom settings
    }
}

$exportConfig | ConvertTo-Json | Out-File "./export-config.json" -Encoding UTF8
```

### Configuration Reporting

**Configuration Report**

```powershell
# Generate comprehensive configuration report
$config = Get-ColorScriptConfiguration

$report = @"
# ColorScripts-Enhanced Configuration Report
Generated: $(Get-Date)

## Cache Settings
- Path: $($config.Cache.Path)
- Enabled: $($config.Cache.Enabled)
- Size: $([math]::Round((Get-ChildItem $($config.Cache.Path) -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB
- Files: $(Get-ChildItem $($config.Cache.Path) -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object | Select-Object -ExpandProperty Count)

## Startup Settings
- Profile Auto-Show: $($config.Startup.ProfileAutoShow)
- Default Script: $($config.DefaultScript)

## Environment
- Module Version: $(Get-Module ColorScripts-Enhanced | Select-Object -ExpandProperty Version)
- PowerShell Version: $($PSVersionTable.PSVersion)
- OS: $(if ($PSVersionTable.Platform) { $PSVersionTable.Platform } else { "Windows" })
"@

$report | Out-File "./config-report.md" -Encoding UTF8
```

### Monitoring and Drift Detection

**Configuration Drift Detection**

```powershell
# Monitor for unexpected configuration changes
$configFile = "$env:APPDATA\ColorScripts-Enhanced\config.json"
$current = Get-ColorScriptConfiguration
$lastKnown = Get-Content $configFile -ErrorAction SilentlyContinue | ConvertFrom-Json

if ($current.Cache.Path -ne $lastKnown.Cache.Path) {
    Write-Warning "Cache path has changed: $($lastKnown.Cache.Path) -> $($current.Cache.Path)"
}
```

**Scheduled Configuration Audit**

```powershell
# Create periodic audit log
$config = Get-ColorScriptConfiguration
$snapshot = @{
    Timestamp = Get-Date -Format 'o'
    CachePath = $config.Cache.Path
    CacheSize = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    ScriptCount = (Get-ColorScriptList -AsObject).Count
}

$snapshot | ConvertTo-Json | Out-File "./audit-log-$(Get-Date -Format 'yyyyMMdd').json" -Append -Encoding UTF8
```

## NOTES

**Module Initialization**: La configuración se inicializa automáticamente cuando se carga el módulo ColorScripts-Enhanced. Este cmdlet recupera el estado actual de la configuración en memoria.

**No Modifications**: Llamar a este cmdlet es de solo lectura y no modifica ninguna configuración persistida o activa.

**Thread Safety**: La tabla hash devuelta es una copia de la configuración, lo que la hace segura para acceso concurrente y modificación sin afectar el estado interno del módulo.

**Performance**: La recuperación de configuración es ligera y adecuada para llamadas frecuentes, ya que devuelve la configuración en memoria cacheada en lugar de leer desde disco.

**Configuration File Format**: La configuración persistida utiliza formato JSON con codificación UTF-8. La edición manual es compatible pero no recomendada; use `Set-ColorScriptConfiguration` en su lugar.

### Best Practices

- Consulta la configuración una vez y reutiliza el resultado
- Valida la configuración antes de usar valores
- Monitorea la configuración para detectar desviaciones a lo largo del tiempo
- Mantén copias de seguridad de configuración en control de versiones
- Documenta cualquier personalización realizada a la configuración
- Prueba cambios de configuración en entornos no productivos primero
- Usa registros de auditoría de configuración para cumplimiento

## RELATED LINKS

- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
