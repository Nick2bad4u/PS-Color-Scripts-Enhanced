---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/nl/Get-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Haalt de huidige ColorScripts-Enhanced module configuratie-instellingen op.

## SYNTAX

```
Get-ColorScriptConfiguration [<CommonParameters>]
```

## DESCRIPTION

`Get-ColorScriptConfiguration` haalt de effectieve moduleconfiguratie op, die verschillende aspecten van ColorScripts-Enhanced gedrag controleert. Dit omvat:

- **Cache-instellingen**: Locatie waar scriptmetadata en indexen worden opgeslagen voor prestatie-optimalisatie
- **Opstartgedrag**: Vlaggen die controleren of scripts automatisch worden uitgevoerd wanneer PowerShell-sessies starten
- **Padconfiguratie**: Aangepaste scriptmappen en zoekpaden
- **Weergavevoorkeuren**: Standaard opmaak- en uitvoeropties

De configuratie wordt samengesteld uit meerdere bronnen in volgorde van prioriteit:
1. Ingebouwde module-standaardwaarden (laagste prioriteit)
2. Aanhoudende gebruikersoverschrijvingen uit het configuratiebestand
3. Sessiespecifieke wijzigingen (hoogste prioriteit)

Het configuratiebestand bevindt zich doorgaans op `%APPDATA%\ColorScripts-Enhanced\config.json` op Windows of `~/.config/ColorScripts-Enhanced/config.json` op Unix-achtige systemen.

De geretourneerde hashtable is een momentopname van de huidige configuratiestatus en kan veilig worden geïnspecteerd, gekloond of geserialiseerd zonder de actieve configuratie te beïnvloeden.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Toont de huidige configuratie met behulp van de standaard tabelweergave, met alle cache- en opstartinstellingen.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serialiseert de configuratie naar JSON-formaat voor logging, debugging of exporteren naar andere tools.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.Location
```

Haalt de configuratie op en opent het cachelocatiepad direct vanuit de hashtable.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.Enabled) {
    Write-Host "Startup scripts are enabled"
}
```

Controleert of opstartscripts zijn ingeschakeld in de huidige configuratie.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Toont alle configuratie-eigenschappen in een gedetailleerde lijstindeling voor uitgebreide inspectie.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Cache Path: $($config.Cache.Path)"
Write-Host "Profile Auto-Show: $($config.Startup.ProfileAutoShow)"
Write-Host "Default Script: $($config.Startup.DefaultScript)"
```

Extraheert en toont specifieke configuratie-eigenschappen voor audit- of scriptingdoeleinden.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Custom cache path configured: $($config.Cache.Path)"
} else {
    Write-Host "Using default cache path"
}
```

Bepaalt of een aangepast cachepad is geconfigureerd versus het gebruik van module-standaardwaarden.

### EXAMPLE 8

```powershell
Export-ColorScriptMetadata | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Maakt een back-up van de huidige configuratie naar een JSON-bestand voor archivering of disaster recovery.

### EXAMPLE 9

```powershell
# Compare current config with defaults
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Review the -WhatIf output to see what would change
```

Vergelijkt huidige configuratie met module-standaardwaarden om aangepaste instellingen te identificeren.

### EXAMPLE 10

```powershell
# Monitor configuration changes across sessions
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Creëert tijdstempel-momentopnamen van configuratie voor het volgen van veranderingen in de tijd.

## PARAMETERS

### CommonParameters

Deze cmdlet ondersteunt de algemene parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Voor meer informatie, zie
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Deze cmdlet accepteert geen pipeline-invoer.

## OUTPUTS

### System.Collections.Hashtable

Retourneert een geneste hashtable met de volgende structuur:

- **Cache** (Hashtable): Cache-gerelateerde instellingen
  - **Location** (String): Pad naar de cachemap
  - **Enabled** (Boolean): Of caching actief is
- **Startup** (Hashtable): Opstartgedrag-instellingen
  - **Enabled** (Boolean): Of scripts worden uitgevoerd bij sessiestart
  - **ScriptName** (String): Naam van het standaard opstartscript
- **Paths** (Array): Extra scriptzoekpaden
- **Display** (Hashtable): Uitvoervormgevingsvoorkeuren

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

**Module Initialisatie**: De configuratie wordt automatisch geïnitialiseerd wanneer de ColorScripts-Enhanced module wordt geladen. Deze cmdlet haalt de huidige in-memory configuratiestatus op.

**Geen Wijzigingen**: Het aanroepen van deze cmdlet is alleen-lezen en wijzigt geen aangehouden instellingen of de actieve configuratie.

**Thread Veiligheid**: De geretourneerde hashtable is een kopie van de configuratie, waardoor het veilig is voor gelijktijdige toegang en wijziging zonder de interne status van de module te beïnvloeden.

**Prestaties**: Configuratie-opvraging is lichtgewicht en geschikt voor frequente aanroepen, aangezien het de gecachte in-memory configuratie retourneert in plaats van van schijf te lezen.

**Configuratiebestand Formaat**: De aangehouden configuratie gebruikt JSON-formaat met UTF-8 codering. Handmatig bewerken wordt ondersteund maar niet aanbevolen; gebruik `Set-ColorScriptConfiguration` in plaats daarvan.

### Beste Praktijken

- Query configuratie eenmaal en hergebruik het resultaat
- Valideer configuratie voordat u waarden gebruikt
- Monitor configuratie voor drift in de tijd
- Houd configuratieback-ups in versiebeheer
- Documenteer eventuele aanpassingen aan configuratie
- Test configuratiewijzigingen eerst in niet-productie
- Gebruik configuratie-auditlogs voor compliance

## RELATED LINKS

- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
