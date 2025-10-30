# ColorScripts-Enhanced Performance Playbook

This document is an evergreen guide for keeping module startup fast. Update the numbers when they change, but preserve the structure so that future work can be evaluated consistently.

---

## 1. Objectives

- Keep warm PowerShell profile startup under 30 ms.
- Avoid disk and metadata work unless a caller explicitly requests it.
- Ensure optimizations stay maintainable, observable, and simple to verify.

---

## 2. Proven Optimizations (Baseline Expectations)

These behaviours ship with the module today. Treat them as invariants unless a better replacement exists.

1. **Cached script inventory** – `Get-ColorScriptInventory` maintains a timestamp-aware cache of script files and reusable record objects so warm `Show-ColorScript` calls never rescan `Scripts/` or allocate new objects.
2. **Configuration persistence guardrails** – `Save-ColorScriptConfiguration` compares serialized JSON before writing so imports stay read-only in steady state.
3. **Startup gating** – `Invoke-ColorScriptsStartup` skips work for CI, remote hosts, or redirected output, and honours the `COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT` override before loading configuration.
4. **Lazy resource initialization** – Cache directories, configuration, and metadata initialize on demand rather than during module import.
5. **Metadata caching** – The first metadata load populates both in-memory state and a JSON cache for future sessions.

Keep these optimizations lightweight. Extend the helpers above instead of layering new state wherever possible.

---

## 3. Startup Timeline Reference

Think in terms of the following scenarios when evaluating performance:

| Scenario                                         | Expected Cost                                        | Notes                                                                   |
| ------------------------------------------------ | ---------------------------------------------------- | ----------------------------------------------------------------------- |
| Module import (warm)                             | 12–18 ms                                             | Reads manifest and initializes globals; should not write to disk.       |
| First `Show-ColorScript` without filters         | ~120 ms                                              | Builds cache directory (if needed) and the first ANSI cache file.       |
| Warm `Show-ColorScript` without filters          | 12–15 ms (`-ReturnText`), ~13 ms with console render | Pure cache hit: inventory and rendered text already exist.              |
| First filtered `Show-ColorScript` (Category/Tag) | ~570 ms                                              | Parses `ScriptMetadata.psd1`, hydrates metadata cache, applies filters. |
| Warm filtered call                               | ~60 ms                                               | Uses metadata cache plus script inventory.                              |

Update the numbers when fresh measurements demand it, but keep the scenarios intact for historical comparisons.

---

## 4. Measurement Playbook

Run these commands before and after any change that might affect startup:

```powershell
# Warm import timing (skip the cold first run)
Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue
1..6 | ForEach-Object {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    Import-Module ./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1 -Force
    $sw.Elapsed.TotalMilliseconds
    Remove-Module ColorScripts-Enhanced -Force
} | Select-Object -Skip 1 | Measure-Object -Average -Minimum -Maximum
```

```powershell
# Warm Show-ColorScript timing without console output
Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue
Import-Module ./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1 -Force
Show-ColorScript -Name spectrum -ReturnText | Out-Null  # warm-up
$sw = [System.Diagnostics.Stopwatch]::StartNew()
1..10 | ForEach-Object { Show-ColorScript -Name spectrum -ReturnText | Out-Null }
$sw.Elapsed.TotalMilliseconds / 10
Remove-Module ColorScripts-Enhanced -Force
```

Always finish with `./scripts/Lint-Module.ps1` and `./scripts/Test-Module.ps1` to confirm behavioural parity.

---

## 5. Usage Recommendations

- **Profile setup:** place `Show-ColorScript` or `Show-ColorScript -Random` in a profile after importing the module. Warm runs should stay within the 30 ms envelope.
- **Auto-show toggle:** set `COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT=1` to opt into auto-show without touching `config.json`. Values matching `1|true|yes` enable it; anything else disables it.
- **Filtered scenarios:** advise users that the first Category/Tag query is intentionally slower (~570 ms) while subsequent calls are cached (~60 ms).

---

## 6. Maintenance Checklist

Before merging startup-related changes, verify:

1. Warm import and warm `Show-ColorScript` remain within the expected ranges above.
2. Module import performs zero unexpected writes (watch for `Save-ColorScriptConfiguration` being invoked).
3. Script inventory invalidation still occurs when files are added, removed, or regenerated (`New-ColorScript` calls `Reset-ScriptInventoryCache`).
4. This document reflects any behavioural or measurement changes.

---

## 7. Future Opportunities

- Ship a pre-built metadata cache to eliminate the 120 ms cold path.
- Explore binary or incremental metadata formats to shrink the 570 ms filtered cold path.
- Parallelize `New-ColorScriptCache` for bulk operations.
- Pre-populate cache entries for popular scripts during installation.

---

## 8. Quick Summary (Keep Updated)

- Warm import: ~15 ms
- Warm `Show-ColorScript` without filters: ~12 ms (`-ReturnText`), ~13 ms with console output
- Cold filtered call: ~570 ms
- Optimizations are backward compatible and transparent to users
