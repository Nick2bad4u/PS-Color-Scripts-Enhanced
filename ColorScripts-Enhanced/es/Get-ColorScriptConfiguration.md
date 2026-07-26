---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Recupera los ajustes de configuración actuales del módulo ColorScripts-Enhanced.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

Este comando no tiene alias.

## DESCRIPTION

`Get-ColorScriptConfiguration` devuelve una copia de la configuración efectiva del módulo. El esquema actual contiene:

- **Configuración de caché**: la anulación configurada y el directorio de caché efectivo resuelto
- **Comportamiento de inicio**: `AutoShowOnImport`, `ProfileAutoShow` y `DefaultScript`

La configuración se ensambla a partir de múltiples fuentes en orden de prioridad:

1. Valores predeterminados del módulo integrado (prioridad más baja)
2. Anulaciones de usuarios persistentes desde el archivo de configuración
3. `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` para la ruta de caché efectiva devuelta

El archivo de configuración normalmente se encuentra en `%APPDATA%\ColorScripts-Enhanced\config.json` en Windows o `~/.config/ColorScripts-Enhanced/config.json` en sistemas tipo Unix.

La tabla hash devuelta es una instantánea del estado de configuración actual y se puede inspeccionar, clonar o serializar de forma segura sin afectar la configuración activa.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Muestra la configuración actual usando la vista de tabla predeterminada, mostrando todas las configuraciones de inicio y caché.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serializa la configuración al formato JSON para registrar, depurar o exportar a otras herramientas.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.EffectivePath
```

Recupera el directorio de caché resuelto. `Cache.Path` sigue siendo la anulación opcional configurada por el usuario;
`Cache.EffectivePath` muestra el directorio que el módulo realmente usa después de los valores predeterminados de la plataforma y
Se aplican anulaciones de entorno.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.AutoShowOnImport) {
    Write-Host "Los scripts de inicio están habilitados"
}
```

Comprueba si el inicio scripts está habilitado en la configuración actual.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Muestra todas las propiedades de configuración en un formato de lista detallada para una inspección exhaustiva.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Ruta de caché: $($config.Cache.Path)"
Write-Host "Visualización automática del perfil: $($config.Startup.ProfileAutoShow)"
Write-Host "Script predeterminado: $($config.Startup.DefaultScript)"
```

Extrae y muestra propiedades de configuración específicas para fines de auditoría o secuencias de comandos.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Ruta de caché personalizada configurada: $($config.Cache.Path)"
} else {
    Write-Host "Se usa la ruta de caché predeterminada"
}

Write-Host "Ruta de caché efectiva: $($config.Cache.EffectivePath)"
```

Determina si se configura una ruta de caché personalizada o si se utilizan los valores predeterminados del módulo.

### EXAMPLE 8

```powershell
$config = Get-ColorScriptConfiguration
$config | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Realiza una copia de seguridad de la configuración actual en un archivo JSON para archivado o recuperación ante desastres.

### EXAMPLE 9

```powershell
# Comparar la configuración actual con la predeterminada
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Revisar el resultado del -WhatIf para ver qué cambiaría.
```

Compara la configuración actual con los valores predeterminados del módulo para identificar configuraciones personalizadas.

### EXAMPLE 10

```powershell
# Monitorear los cambios de configuración entre sesiones
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Crea instantáneas de configuración con marca de tiempo para realizar un seguimiento de los cambios a lo largo del tiempo.

## PARAMETERS

### -h

Muestra ayuda detallada para este comando sin realizar la operación.

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

Este cmdlet admite los parámetros comunes:
Para obtener más información, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet no acepta entradas de canalización.

## OUTPUTS

### System.Collections.Hashtable

Devuelve una tabla hash anidada que contiene la siguiente estructura:

- **Cache** (Hashtable): configuraciones relacionadas con la caché
  - **Path** (Cadena): Anulación de ruta de caché persistente opcional
  - **EffectivePath** (Cadena): Directorio de caché resuelto actualmente utilizado por el módulo
- **Startup** (Hashtable): configuración de comportamiento de inicio
  - **AutoShowOnImport** (booleano): si la importación invoca el comportamiento de visualización de inicio
  - **ProfileAutoShow** (booleano): opción de presentación automática predeterminada para bloques de perfil administrados
- **DefaultScript** (Cadena): Inicio con nombre opcional script de colores

## NOTES

**Inicialización del módulo**: La configuración se inicializa automáticamente cuando se carga el módulo ColorScripts-Enhanced. Este cmdlet recupera el estado de configuración actual en memoria.

**Sin modificaciones**: la llamada a este cmdlet es de solo lectura y no modifica ninguna configuración persistente ni la configuración activa.

**Seguridad de subprocesos**: la tabla hash devuelta es una copia de la configuración, lo que la hace segura para el acceso y la modificación simultáneos sin afectar el estado interno del módulo.

**Performance**: La recuperación de configuración es liviana y adecuada para llamadas frecuentes, ya que devuelve la configuración en memoria caché en lugar de leerla desde el disco.

**Formato del archivo de configuración**: la configuración persistente utiliza el formato JSON con codificación UTF-8. Se admite la edición manual, pero no se recomienda; utilice `Set-ColorScriptConfiguration` en su lugar.

### Buenas prácticas

- Consultar la configuración una vez y reutilizar el resultado.
- Validar la configuración antes de usar valores.
- Monitorear la configuración para detectar variaciones con el tiempo.
- Mantenga copias de seguridad solo donde no puedan exponer rutas específicas de la máquina o datos privados
- Documentar cualquier personalización realizada en la configuración.
- Pruebe primero los cambios de configuración en situaciones que no sean de producción.
- Utilice registros de auditoría de configuración para el cumplimiento

## RELATED LINKS

- [Versión en línea](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

