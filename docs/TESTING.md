# Testing Guide

ColorScripts-Enhanced uses Node's test runner for ANSI conversion and Pester 6.0.1 for the PowerShell module, repository tooling, corpus rules, localization, and integration behavior.

## Standard Commands

```powershell
# ANSI conversion + custom module harness + Pester
npm test

# Focused suites
npm run test:conversion
npm run test:custom
npm run test:pester

# Coverage
npm run test:coverage
npm run test:coverage:detailed
npm run test:coverage:report

# Static validation
npm run verify
npm run verify:strict
```

`npm run test:pester` invokes `scripts/Test-Coverage.ps1 -SkipCoverage`; it is the preferred repository entry point for the complete Pester suite without coverage instrumentation.

## Focused Pester Runs

```powershell
Invoke-Pester -Path ./Tests/RepositoryScripts.Tests.ps1
Invoke-Pester -Path ./Tests/Localization.Tests.ps1
Invoke-Pester -Path ./Tests/Show-ColorScript.Tests.ps1
```

Use the actual test filenames returned by `rg --files Tests` rather than copying a guessed path. Keep `-NoProfile` for subprocess-based checks so the developer's profile cannot change module resolution or output.

## Test Isolation

Tests that persist configuration or cache output must use `$TestDrive` and process-scoped environment overrides:

```powershell
BeforeEach {
    $script:oldCachePath = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
    $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = Join-Path $TestDrive 'cache'
}

AfterEach {
    $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $script:oldCachePath
    Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
}
```

Also isolate configuration with `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` where a test writes `config.json`. Never hard-code `$env:APPDATA` in cross-platform tests; query `Get-ColorScriptConfiguration` or set the override explicitly.

Tests that modify profiles must pass a `$TestDrive` profile path and assert unrelated content is preserved. Do not write to a developer's real `$PROFILE`.

## What to Test

### Public Commands

Cover:

- each parameter set and alias;
- exact, wildcard, category, and tag selection;
- empty and unmatched input;
- pipeline/property binding where declared;
- `-WhatIf`, `-Confirm`, force, and no-op paths;
- stable output properties and status values;
- quiet/plain-text information behavior;
- Windows PowerShell 5.1 and PowerShell 7 differences.

### Static, Dynamic, and Cache Routing

A bundled deterministic script must be statically extractable. A name may appear in `DynamicRenderPolicy.psd1` only when repeated isolated renders legitimately differ. A dynamic renderer may appear in `CachePolicy.psd1` only when it is expensive enough to justify persistent output.

Cache tests should assert status and files, not a machine-independent speed multiplier:

```powershell
$result = New-ColorScriptCache -Name Galaxy -Force -PassThru
$result.Status | Should -BeIn @('Updated', 'SkippedUpToDate')
$result.CacheFile | Should -Not -BeNullOrEmpty
```

Static names should report `SkippedNotRequired` and should not leave obsolete cache entries.

### ANSI Corpus

Validate:

- CP437 and other declared encodings;
- cursor-positioned dimensions;
- deterministic converter output;
- no duplicate source/output identities;
- line endings and encoding expected by the renderer;
- metadata and provenance mappings;
- normal-size/split boundaries;
- representative visual rendering.

Node conversion tests live in `Tests/AnsiConversion.Tests.js`. Full collection execution is available through `npm run scripts:test-all`; it is intentionally slower than unit tests.

### Help and Localization

Every culture must contain 10 Markdown topics, a 10-command MAML package, HelpInfo matching `ModuleVersion`, and an about topic. Validate source parameter headings and generated MAML against the live exported commands. Examples must use real parameters and include mandatory arguments.

Runtime `Messages.psd1` files must have exact 72-key parity with English and matching placeholder indices. A structurally complete resource file does not prove that all command-help prose is translated; track remaining English blocks separately.

## CI Matrix

`.github/workflows/test.yml` currently runs:

- ANSI conversion safety on Windows, Ubuntu, and macOS;
- Windows PowerShell 5.1 coverage/tests;
- PowerShell 7 coverage/tests on Windows, Ubuntu, and macOS; and
- additional workflow jobs defined in the checked-in YAML.

The workflow uses the Node version in `.node-version` and Pester 6.0.1. Read the workflow before changing claims about the matrix.

## Coverage and Results

`scripts/Test-Coverage.ps1` owns coverage and JUnit generation. CI variants write `coverage.xml` and `testResults.junit.xml` for artifact and Codecov upload. Do not commit locally generated reports unless a repository workflow explicitly treats them as source.

Coverage is a diagnostic, not permission to add low-value assertions. Prefer behavior and error-path coverage that protects a public contract.

## Troubleshooting

- **Wrong module loaded:** remove existing module instances and import the manifest by explicit repository path.
- **Real user state changed:** add configuration/cache/profile overrides under `$TestDrive`.
- **Help appears stale:** run `npm run build:help`, remove the module, and import it again in a clean process.
- **Only CI fails:** use the workflow's exact PowerShell edition, Node version, Pester version, and command.
- **ANSI snapshot differs:** verify source encoding and terminal-control semantics before updating a baseline.
- **Coverage process is slow:** run `npm run test:pester` or a focused Pester file while iterating, then run coverage before handoff.

## Pre-Handoff Checklist

- [ ] Focused regression tests pass.
- [ ] `npm run test:conversion` passes for converter or collection changes.
- [ ] `npm run test:pester` passes for module/help changes.
- [ ] `npm run verify:strict` passes.
- [ ] Help was regenerated when public metadata changed.
- [ ] No test touched the real cache, configuration, or profile.
- [ ] `git diff --check` is clean.

---

_Last reviewed: July 21, 2026_
