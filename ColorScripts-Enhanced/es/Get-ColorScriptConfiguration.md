---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Recupera la configuración actual del módulo ColorScripts-Enhanced.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

This command has no aliases.

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

### -h

Muestra la ayuda detallada de este comando sin realizar la operación.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
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

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
