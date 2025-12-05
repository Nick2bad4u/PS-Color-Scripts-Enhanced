---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/es/Reset-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Restaurar la configuración de ColorScripts-Enhanced a sus valores predeterminados.

## SYNTAX

### Default (Default)

```text
Reset-ColorScriptConfiguration [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### \_\_AllParameterSets

```text
Reset-ColorScriptConfiguration [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

`Reset-ColorScriptConfiguration` borra todas las anulaciones de configuración persistidas y restaura el módulo a sus valores predeterminados de fábrica. Cuando se ejecuta, este cmdlet:

- Elimina todas las configuraciones personalizadas del archivo de configuración
- Restablece la ruta de caché a la ubicación predeterminada específica de la plataforma
- Restaura todas las banderas de inicio (RunOnStartup, RandomOnStartup, etc.) a sus valores originales
- Preserva la estructura del archivo de configuración mientras borra las personalizaciones del usuario

Este cmdlet admite los parámetros `-WhatIf` y `-Confirm` porque realiza una operación destructiva al sobrescribir el archivo de configuración. La operación de restablecimiento no se puede deshacer automáticamente, por lo que los usuarios deben considerar hacer una copia de seguridad de su configuración actual usando `Get-ColorScriptConfiguration` antes de proceder.

Use el parámetro `-PassThru` para inspeccionar inmediatamente las configuraciones predeterminadas recién restauradas después de que se complete el restablecimiento.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Restablece la configuración sin pedir confirmación. Esto es útil en scripts automatizados o cuando estás seguro de restablecer a los valores predeterminados.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Restablece la configuración y devuelve la tabla hash resultante para inspección, permitiendo verificar los valores predeterminados.

### EXAMPLE 3

```powershell
# Backup current configuration before resetting
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

Usa `-WhatIf` para previsualizar la operación de restablecimiento sin ejecutarla realmente, después de hacer una copia de seguridad de la configuración actual.

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

Restablece la configuración con salida detallada para ver información detallada sobre la operación.

### EXAMPLE 5

```powershell
# Reset configuration and clear cache for complete factory reset
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "Module reset to factory defaults!"
```

Realiza un restablecimiento completo de fábrica incluyendo configuración, caché y reconstrucción del caché.

### EXAMPLE 6

```powershell
# Verify reset was successful
$config = Reset-ColorScriptConfiguration -PassThru
if ($config.Cache.Path -match "AppData|\.config") {
    Write-Host "Configuration successfully reset to platform default"
} else {
    Write-Host "Configuration reset but using custom path: $($config.Cache.Path)"
}
```

Restablece y verifica que la configuración se haya restaurado a los valores predeterminados comprobando la ruta de caché.

## PARAMETERS

### -Confirm

Pide confirmación antes de ejecutar el cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -PassThru

Devuelve el objeto de configuración actualizado después de que se complete el restablecimiento.

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

### -WhatIf

Muestra qué sucedería si el cmdlet se ejecuta sin ejecutar realmente la operación de restablecimiento.

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
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Para más información, vea
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet no acepta entrada de pipeline.

## OUTPUTS

### System.Collections.Hashtable

Devuelto cuando se especifica `-PassThru`.

## NOTES

El archivo de configuración se almacena en el directorio resuelto por `Get-ColorScriptConfiguration`. Por defecto, esta ubicación es específica de la plataforma:

- **Windows**: `$env:LOCALAPPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `$HOME/.config/ColorScripts-Enhanced`

La variable de entorno `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` puede anular la ubicación predeterminada si se establece antes de la importación del módulo.

## Consideraciones importantes

- La operación de restablecimiento es inmediata y no se puede deshacer automáticamente
- Se perderán todas las rutas de script de color personalizadas, ubicaciones de caché o comportamientos de inicio
- Considera usar `Get-ColorScriptConfiguration` para exportar tus configuraciones actuales antes de restablecer
- El módulo debe tener permisos de escritura en el directorio de configuración
- Otras sesiones de PowerShell que usan el módulo verán los cambios después de su próxima recarga de configuración

## Valores predeterminados restaurados

- CachePath: Directorio de caché predeterminado específico de la plataforma
- RunOnStartup: `$false`
- RandomOnStartup: `$false`
- ScriptOnStartup: Cadena vacía
- CustomScriptPaths: Matriz vacía

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
