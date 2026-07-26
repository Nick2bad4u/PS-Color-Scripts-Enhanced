---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Restaure la configuración ColorScripts-Enhanced a sus valores predeterminados.

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Este comando no tiene alias.

## DESCRIPTION

`Reset-ColorScriptConfiguration` reemplaza la configuración persistente con los valores predeterminados integrados y restablece el estado de caché en memoria del módulo. Cuando se ejecuta, este cmdlet:

- Borra la anulación de la ruta de caché configurada para que se utilice el valor predeterminado efectivo de la plataforma.
- Restaura `AutoShowOnImport`, `ProfileAutoShow` y `DefaultScript`.
- Escribe la configuración predeterminada en `config.json`.
- Borra el estado de configuración/caché en memoria para que las operaciones posteriores utilicen los valores de reinicio

Este cmdlet admite los parámetros `-WhatIf` y `-Confirm` porque realiza una operación destructiva al sobrescribir el archivo de configuración. La operación de reinicio no se puede deshacer automáticamente, por lo que los usuarios deberían considerar hacer una copia de seguridad de su configuración actual usando `Get-ColorScriptConfiguration` antes de continuar.

Utilice el parámetro `-PassThru` para inspeccionar inmediatamente la configuración predeterminada recién restaurada después de que se complete el restablecimiento.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Restablece la configuración sin pedir confirmación. Esto es útil en scripts automatizado o cuando está seguro de restablecer los valores predeterminados.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Restablece la configuración y devuelve la tabla hash resultante para su inspección, lo que le permite verificar los valores predeterminados.

### EXAMPLE 3

```powershell
# Copia de seguridad de la configuración actual antes de restablecer
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

Utiliza `-WhatIf` para obtener una vista previa de la operación de reinicio sin ejecutarla realmente, después de hacer una copia de seguridad de la configuración actual.

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

Restablece la configuración con salida detallada para ver información detallada sobre la operación.

### EXAMPLE 5

```powershell
# Restablecer la configuración y borrar el caché para un restablecimiento completo de fábrica
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "¡El módulo se restableció a los valores de fábrica!"
```

Realiza un restablecimiento completo de fábrica que incluye configuración, caché y reconstrucción del caché.

### EXAMPLE 6

```powershell
# Verificar que el reinicio fue exitoso
$config = Reset-ColorScriptConfiguration -PassThru
if ($null -eq $config.Cache.Path -and $config.Cache.EffectivePath) {
    Write-Host "La configuración se restableció al valor predeterminado de la plataforma"
} else {
    Write-Host "Configuración restablecida, pero se usa una ruta personalizada: $($config.Cache.Path)"
}
```

Restablece y verifica que la anulación de caché persistente esté vacía y que haya una ruta de plataforma efectiva disponible.

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

### -PassThru

Devuelve el objeto de configuración actualizado una vez que se completa el restablecimiento.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -WhatIf

Muestra lo que sucedería si el cmdlet se ejecuta sin ejecutar realmente la operación de restablecimiento.

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

### None

Este cmdlet no acepta entradas de canalización.

## OUTPUTS

### System.Collections.Hashtable

Se devuelve cuando se especifica `-PassThru`.

## NOTES

El archivo de configuración se almacena en el directorio resuelto por `Get-ColorScriptConfiguration`. De forma predeterminada, esta ubicación es específica de la plataforma:

- **Windows**: `$env:APPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `$HOME/.config/ColorScripts-Enhanced`

La variable de entorno `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` puede anular la ubicación predeterminada si se configura antes de la importación del módulo.

## RELATED LINKS

- [Versión en línea](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

