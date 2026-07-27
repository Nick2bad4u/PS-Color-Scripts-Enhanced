---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Aggiunge o aggiorna un blocco di avvio gestito ColorScripts-Enhanced in un file di profilo PowerShell.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

Questo comando non ha alias.

## DESCRIPTION

Aggiunge un blocco di avvio gestito al profilo PowerShell selezionato. Il blocco importa ColorScripts-Enhanced e può richiamare `Show-ColorScript` dopo l'importazione. `-SkipStartupScript` scrive un blocco di sola importazione.

Quando `-ProfilePath` viene omesso, il comando preferisce `$PROFILE.CurrentUserAllHosts` e altrimenti utilizza il primo percorso del profilo definito. Il file del profilo e le directory principali mancanti vengono create quando necessario.

I blocchi ColorScripts-Enhanced gestiti o legacy esistenti vengono sostituiti anziché duplicati. Se il profilo importa già il modulo all'esterno di un blocco gestito, il comando lo lascia invariato a meno che non venga specificato `-Force`. `-Force` consente di sostituire il contenuto del modulo riconosciuto preservando il contenuto del profilo non correlato.

Il comportamento di avvio generato viene risolto da parametri espliciti e configurazione persistente. `-AutoShow` abilita esplicitamente la visualizzazione e `-DefaultStartupScript` seleziona uno script con nome. Gli script Pokémon partecipano normalmente; i nuovi profili gestiti non chiedono mai informazioni sui Pokémon e non emettono `-IncludePokemon`. A meno che non venga utilizzato `-SkipCacheBuild`, il comando può preriscaldare le voci della cache selezionate dai criteri dopo l'aggiornamento del profilo.

## EXAMPLES

### EXAMPLE 1

Aggiungi al profilo dell'utente corrente per tutti gli host (comportamento predefinito).

```powershell
Add-ColorScriptProfile
```

Ciò aggiunge sia l'importazione del modulo che la chiamata `Show-ColorScript` a `$PROFILE.CurrentUserAllHosts`.

### EXAMPLE 2

Aggiungi al profilo dell'utente corrente solo per l'host corrente, senza lo script di avvio.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost -SkipStartupScript
```

Ciò aggiunge un blocco gestito di sola importazione al profilo dell'host corrente.

### EXAMPLE 3

Aggiungi a un percorso di profilo personalizzato con espansione della variabile di ambiente.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

Questo ha come target un file di profilo specifico al di fuori delle posizioni dei profili PowerShell standard.

### EXAMPLE 4

Forza la riaggiunta dello snippet anche se esiste già.

```powershell
Add-ColorScriptProfile -Force
```

Questo aggiornamento riconosce il contenuto del profilo ColorScripts-Enhanced preservando le linee del profilo non correlate.

### EXAMPLE 5

Configurazione su una nuova macchina: crea un profilo se necessario e aggiungi ColorScript a tutti gli host.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts -Confirm:$false
Write-Host "Profilo configurato. Riavvia il terminale per visualizzare i colorscript all'avvio."
```

### EXAMPLE 6

Aggiungi con un colorscript specifico per la visualizzazione all'avvio:

```powershell
Add-ColorScriptProfile -DefaultStartupScript mandelbrot-zoom -AutoShow
```

### EXAMPLE 7

Verifica che il profilo sia stato aggiunto correttamente:

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Scegli come target esplicitamente il profilo current-host o all-hosts:

```powershell
# Solo per terminale Windows o ConEmu
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost

# Per tutti gli host PowerShell (ISE, VSCode, Console)
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts
```

### EXAMPLE 9

Utilizzando percorsi relativi ed espansione della tilde:

```powershell
# Utilizzo dell'espansione tilde per la directory home
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Utilizzando il percorso relativo della directory corrente
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Visualizza colorscript diversi ogni giorno aggiungendo logica personalizzata:

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Quindi aggiungi manualmente quanto segue a $PROFILE
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

### EXAMPLE 11

Usa l'opzione di compatibilità deprecata in una chiamata di automazione esistente:

```powershell
Add-ColorScriptProfile -IncludePokemon
```

L'opzione viene accettata silenziosamente senza effetto per una versione di compatibilità. Gli script Pokémon partecipano già normalmente e il profilo generato richiama semplicemente `Show-ColorScript`.

## PARAMETERS

### -AutoShow

Controlla se il blocco del profilo gestito visualizza uno script color dopo l'importazione del modulo.

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

### -Confirm

Richiede conferma prima di eseguire il cmdlet.

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

### -DefaultStartupScript

Specifica il nome colorscript scritto nel blocco del profilo gestito per la visualizzazione all'avvio.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Force

Aggiorna il contenuto ColorScripts-Enhanced riconosciuto nel profilo, conservando le righe non correlate. Non aggiunge intenzionalmente blocchi gestiti duplicati.

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

### -h

Visualizza le informazioni della guida per questo cmdlet. Equivalente all'utilizzo di `Get-Help Add-ColorScriptProfile`.

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

### -IncludePokemon

Opzione di compatibilità deprecata. Viene accettata silenziosamente senza effetto per una versione; gli script di colori Pokémon partecipano già normalmente e i profili generati non emettono mai questa opzione.

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

### -PokemonPromptResponse

Parametro di compatibilità deprecato. Viene accettato silenziosamente senza effetto per una versione perché la generazione del profilo non richiede più informazioni sui Pokémon.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProfilePath

Specifica il file di profilo PowerShell da aggiornare. È accettato anche l'alias Path.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Path
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

### -SkipCacheBuild

Elimina il preriscaldamento della cache opzionale. Viene tentato un preriscaldamento solo quando il `ProfileAutoShow` è stato risolto
l'impostazione è abilitata, la creazione della cache non è stata altrimenti disabilitata, il profilo di destinazione è esterno a
directory temporanea del sistema e l'operazione è approvata da `ShouldProcess`. Il comando rispetta anche il
variabile d'ambiente `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` e la variabile globale
`$Global:ColorScriptsEnhancedSkipCacheBuild`.

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

### -SkipPokemonPrompt

Opzione di compatibilità deprecata. Viene accettata silenziosamente senza effetto per una versione perché la generazione del profilo non richiede più informazioni sui Pokémon.

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

### -SkipStartupScript

Salta l'aggiunta di `Show-ColorScript` al profilo. Viene aggiunta solo la riga `Import-Module ColorScripts-Enhanced`. Utilizzare questo se si desidera controllare manualmente quando vengono visualizzati colorscripts.

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

Mostra cosa accadrebbe se il cmdlet venisse eseguito. Il cmdlet non viene eseguito.

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

Questo cmdlet supporta i parametri comuni:
Per ulteriori informazioni, vedere
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### System.Object

Restituisce un oggetto personalizzato con le seguenti proprietà:

- **Path** (string): il percorso completo del file del profilo selezionato
- **Changed** (bool): se il profilo è stato effettivamente modificato
- **Message** (string): un messaggio di stato che descrive il risultato dell'operazione
- **IncludePokemon** (bool): sempre `$true`; mantenuto temporaneamente per la compatibilità dell'oggetto risultato
- **CacheBuilt** (bool): se il riscaldamento della cache opzionale è stato completato

## NOTES

**Autore:** Nick

**Modulo:** ColorScripts-Enhanced

**Richiede:** PowerShell 5.1 o versione successiva

Il file del profilo viene creato automaticamente se non esiste, comprese le directory principali necessarie. Il comando gestisce i percorsi dei file forniti dall'utente; non espone un selettore di ambito separato.

## RELATED LINKS

- [Versione online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)

