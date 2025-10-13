# ANSI Conversion Examples

This folder provides turnkey scripts that demonstrate how to use the repository utilities for converting ANSI art into PowerShell colorscripts and for slicing tall ANSI files into manageable chunks. Each script runs entirely in PowerShell so you can adapt it for build automation or ad-hoc conversions.

## Prerequisites

- Node.js 18+ (required for the JavaScript conversion utilities)
- PowerShell 7+ (recommended for faster execution)
- `npm install` in the repository root so `node_modules` is available

## Scripts

### `Convert-SampleAnsi.ps1`

- Converts `ansi-files/DEL-FLAG.ANS` into a new PowerShell script under `dist/examples/` (safe scratch location).
- Demonstrates how to call `Convert-AnsiToColorScript.js` with explicit input/output arguments.
- Produces a UTF-8 (no BOM) PowerShell script ready for testing with `Test-AllColorScripts.ps1`.

Run it from the repository root:

```powershell
pwsh -NoProfile -File ./examples/ansi-conversion/Convert-SampleAnsi.ps1
```

### `Split-SampleAnsi.ps1`

- Splits the tall `ansi-files/we-ACiDTrip.ANS` artwork into 160-line slices.
- Shows how to use the `scripts/Split-AnsiFile.js` helper with automatic break detection and custom heights.
- Writes results to `./dist/examples/we-ACiDTrip/` so you can convert each slice individually.

Execute with:

```powershell
pwsh -NoProfile -File ./examples/ansi-conversion/Split-SampleAnsi.ps1
```

Feel free to duplicate these scripts when building your own workflows—they are intentionally verbose with comments that explain each step.
