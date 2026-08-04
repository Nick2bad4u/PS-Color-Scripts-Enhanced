# npm Scripts Reference

`package.json` is the source of truth for executable definitions. Run these commands from the repository root after `npm ci`.

## Primary Workflows

| Command                   | Purpose                                                                                               |
| ------------------------- | ----------------------------------------------------------------------------------------------------- |
| `npm run build`           | Build the module, generate release notes, run conversion checks, verify lint/README, and run coverage |
| `npm run build:skip-help` | Run `scripts/build.ps1 -SkipHelp`                                                                     |
| `npm run verify`          | Run non-mutating module lint and the gallery README size check                                        |
| `npm run verify:strict`   | Include tests in strict ScriptAnalyzer validation, check gallery README size, then analyze the complete ANSI gallery |
| `npm test`                | Run Node ANSI-conversion tests, the custom module harness, and the Pester suite                       |
| `npm run lint`            | Run the normal PowerShell lint entry point                                                            |
| `npm run lint:strict`     | Analyze module and tests, treating warnings as errors                                                 |

`npm run build` updates generated artifacts. Review the worktree after running it. For quick, non-mutating validation use `npm run verify`; it does not run the test suite.

## Build and Documentation

| Command                                            | Purpose                                                                                 |
| -------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `npm run build:help`                               | Synchronize Markdown help and generate MAML plus deterministic Updatable Help packages  |
| `npm run build:help:check`                         | Rebuild Updatable Help in isolation and fail when checked-in artifacts are stale        |
| `npm run docs:update-counts`                       | Refresh script, cache-policy, dynamic-policy, and module-version markers                |
| `npm run markdown:check`                           | Run the repository Markdown link-check wrapper                                          |
| `npm run readme:check`                             | Check the PowerShell Gallery README size                                                |
| `npm run readme:check:strict`                      | Apply the strict gallery README size limit                                              |
| `npm run package:metadata -- --PackagePath <file>` | Normalize a staged NuGet package's README, license, icon, and metadata                  |

The repository does not define a `docs:validate-links` script. Use `npm run markdown:check`.

Updatable Help always generates and validates HelpInfo and ZIP artifacts. CAB
generation and byte comparison run when `makecab.exe` is available. Other
platforms preserve the expected checked-in CAB files, remove obsolete
culture-named CABs, and exclude CAB bytes from the cross-platform comparison.

## Tests and Coverage

| Command                            | Purpose                                                                         |
| ---------------------------------- | ------------------------------------------------------------------------------- |
| `npm run test:conversion`          | Run ANSI conversion, splitting, and archive-audit tests with Node's test runner |
| `npm run test:custom`              | Run `scripts/Test-Module.ps1`                                                   |
| `npm run test:pester`              | Run Pester through `Test-Coverage.ps1 -SkipCoverage`                            |
| `npm run test:coverage`            | Run Pester with normal coverage output                                          |
| `npm run test:coverage:ci`         | Run the CI coverage configuration                                               |
| `npm run test:coverage:detailed`   | Run coverage with detailed Pester output                                        |
| `npm run test:coverage:diagnostic` | Run coverage with diagnostic output                                             |
| `npm run test:coverage:minimal`    | Run coverage with minimal output                                                |
| `npm run test:coverage:none`       | Suppress Pester console detail while collecting coverage                        |
| `npm run test:coverage:report`     | Run coverage and open/show the report                                           |
| `npm run test:linux`               | Alias for the normal coverage run                                               |

For a focused Pester file, call the pinned runner directly:

```powershell
pwsh -NoProfile -Command "Invoke-Pester -Path ./Tests/RepositoryScripts.Tests.ps1"
```

## Lint and Static Analysis

| Command                     | Purpose                                                                     |
| --------------------------- | --------------------------------------------------------------------------- |
| `npm run lint:fix`          | Apply supported module lint fixes                                           |
| `npm run lint:strict:fix`   | Apply supported fixes while including tests and treating warnings as errors |
| `npm run lint:scripts`      | Analyze repository scripts and treat warnings as errors                     |
| `npm run lint:scripts:fix`  | Apply supported fixes to repository scripts                                 |
| `npm run lint:ps7`          | Run the PowerShell 7-specific analyzer                                      |
| `npm run lint:remark`       | Lint Markdown with remark                                                   |
| `npm run lint:remark:fix`   | Apply remark formatting fixes                                               |
| `npm run lint:gitleaks`     | Scan the repository with the shared gitleaks config                         |
| `npm run lint:jscpd`        | Check copy/paste duplication                                                |
| `npm run lint:lychee`       | Check links with the shared lychee config                                   |
| `npm run lint:lychee:smoke` | Dump/check the README link input set                                        |
| `npm run lint:package-json` | Lint package metadata                                                       |
| `npm run lint:yamllint`     | Lint YAML with `.yamllint`                                                  |

Some linters require separately installed CLIs. The Node-backed commands use the versions in `package-lock.json`.

## ANSI Collection Maintenance

| Command                                     | Purpose                                                                                                                                                                |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `npm run ansi:audit -- <args>`              | Run the resumable 16colors and Roy ANSI/ICE archive audit                                                                                                              |
| `npm run ansi:audit:offline -- <args>`      | Rebuild audit reports using only the existing ignored cache                                                                                                            |
| `npm run ansi:checkpoint:check`             | Reconcile final archive reports with provenance and fail if the compact checkpoint is stale                                                                            |
| `npm run ansi:checkpoint:update`            | Reconcile final archive reports and rewrite the compact checkpoint after review                                                                                        |
| `npm run ansi:gallery-analysis`             | Build review queues for split geometry, authentic blank boundaries, decoding damage, sparse or low-complexity output, color variety, and derivative-source attribution |
| `npm run ansi:gallery-analysis:check`       | Fail on unresolved archive-quality findings, stale review exceptions, or malformed analysis state                                                                      |
| `npm run ansi:verify-conversion -- <args>`  | Compare raw ANSI with generated scripts by exact rendered terminal cells and source-coordinate coverage                                                                |
| `npm run artwork:provenance:headers:check`  | Verify compact mapped headers, unchanged migrated payloads, immutable legacy scripts, and complete external fields                                                     |
| `npm run artwork:provenance:headers:update` | Migrate exact verbose mapped headers; this is a controlled repository migration, not a routine formatter                                                               |
| `npm run artwork:provenance:web:check`      | Verify the web provenance index is an exact projection of the authoritative PSD1                                                                                        |
| `npm run artwork:provenance:web:update`     | Regenerate the compact web provenance index                                                                                                                             |
| `npm run convert -- <args>`                 | Convert ANSI with `--strip-space-bg` enabled                                                                                                                           |
| `npm run scripts:convert -- <args>`         | Run the Node ANSI converter                                                                                                                                            |
| `npm run scripts:convert:ps -- <args>`      | Run the PowerShell converter                                                                                                                                           |
| `npm run scripts:convert:ps:skip -- <args>` | Run the PowerShell converter with space-background stripping                                                                                                           |
| `npm run scripts:convert:advanced`          | Launch the advanced PowerShell conversion workflow                                                                                                                     |
| `npm run scripts:split -- <args>`           | Split ANSI or converted PowerShell art                                                                                                                                 |
| `npm run scripts:count`                     | Count bundled `.ps1` colorscripts                                                                                                                                      |
| `npm run scripts:format`                    | Format bundled colorscripts                                                                                                                                            |
| `npm run scripts:test-all`                  | Execute the full colorscript collection harness                                                                                                                        |
| `npm run scripts:check-dupes`               | Report duplicate ANSI inputs without modifying files                                                                                                                   |
| `npm run scripts:remove-dupes`              | Run the duplicate remover with confirmation                                                                                                                            |

Pass script arguments after `--`, for example:

```powershell
npm run scripts:split -- ./art.ans --auto --dry-run
node ./scripts/Audit-AnsiArchives.js --source=16colors --pack=mist0624
node ./scripts/Audit-AnsiArchives.js --offline --cache-dir=./temp/ansi-archive-audit
node ./scripts/Audit-AnsiArchives.js --offline --year=2016 --decisions=./temp/ansi-archive-audit/decisions.json --exclude-existing-manifest=./temp/ansi-archive-audit/import-manifest.json
node ./scripts/Analyze-ColorScripts.mjs --type=tiny-tail-part --json=./temp/gallery-analysis/tiny-tails.json
node ./scripts/Analyze-ColorScripts.mjs --type=mergeable-adjacent-parts --type=avoidable-extra-part
node ./scripts/Analyze-ColorScripts.mjs --type=dense-split-boundary --type=continuous-split-review
node ./scripts/Analyze-ColorScripts.mjs --type=leading-blank-run --type=trailing-blank-run
node ./scripts/Analyze-ColorScripts.mjs --type=mostly-plain-ascii --type=low-structural-complexity
npm run ansi:verify-conversion -- --source=./ZII-UBBS.ANS --prefix=16c-mist-30-zii-ubbs
```

`--exclude-existing-manifest=<path>` is repeatable and is intended for
rebuilding an already imported tranche. The audit validates every named
script and hash against checked-in provenance, excludes only those scripts
from the gallery baseline, and continues to detect unrelated duplicates. Empty,
repeated, malformed, stale, or hash-mismatched manifests terminate the audit.

Gallery-analysis findings are review signals, not automatic deletion
decisions. The analyzer reconstructs terminal cells, counts background-colored
spaces as visible, groups split parts by source family, reports adjacent parts
that fit within the row limit, detects dense cuts with a safer nearby blank
boundary, separately queues continuous dense cuts that need standalone-panel
review, and distinguishes genuine source blank rows from the serializer's
presentation newline. Tail-part detection uses both row count and visible-cell
ratios; sparse density, low structural complexity, and low color variety remain
separate review signals because none is an artistic verdict by itself.
SAUCE height is retained as metadata but is not treated as an expected row
count because unused `tInfo2` padding is common; only rows rendered by the ANSI
stream or cursor operations belong in the generated scripts.
Reviewed intentional findings are declared in
`scripts/ColorScriptAnalysisExceptions.json`; every entry must match exactly
one current finding or analysis fails, preventing stale suppressions. Use
the exact script name as `family` for per-script blank, size, density, ASCII,
or decoding findings. Use
`--no-exceptions` to include those findings or `--exceptions=<path>` to validate
another ledger. Use `--type=<issue-name>` more than once to select multiple
queues. Run `node ./scripts/Analyze-ColorScripts.mjs --help` for threshold and
exit-code options. Direct Node invocation avoids npm-version-specific
differences in forwarding flag-like script arguments.
Use the direct Node form for conversion verification for the same reason.

`Verify-AnsiConversion.mjs` is the authoritative fidelity check when the original
ANSI/ICE file is available. It compares rendered cell characters, coordinates,
foreground/background colors, intensity, colored spaces, blank canvas rows,
and full source-coordinate coverage. A high ratio of Unicode block or
box-drawing characters is normal for correctly decoded CP437 and is therefore
not treated as corruption. Use `--allow-partial` only when deliberately checking
selected parts instead of the complete source canvas.

## Changelog and Release Notes

| Command                           | Purpose                                                              |
| --------------------------------- | -------------------------------------------------------------------- |
| `npm run changelog:generate`      | Regenerate `CHANGELOG.md` with git-cliff                             |
| `npm run changelog:preview`       | Preview unreleased changes                                           |
| `npm run changelog:release-notes` | Print the current tagged release range                               |
| `npm run release:notes`           | Write unreleased PowerShell Gallery notes to `dist/`                 |
| `npm run release:notes:latest`    | Write the latest tagged release notes to `dist/`                     |
| `npm run release:verify`          | Validate changelog/release-note alignment with the manifest and tags |

Release-note commands depend on local tags. Fetch tags before investigating stale output.

## Repository Maintenance

| Command                    | Purpose                                                                         |
| -------------------------- | ------------------------------------------------------------------------------- |
| `npm run sort-package`     | Sort `package.json`                                                             |
| `npm run update-actions`   | Update pinned GitHub Actions SHAs                                               |
| `npm run update-deps`      | Run the shared npm-check-updates config, sync Node version files, and reinstall |
| `npm run contrib`          | Run all-contributors                                                            |
| `npm run contrib:add`      | Add a contributor                                                               |
| `npm run contrib:check`    | Validate contributor metadata                                                   |
| `npm run contrib:generate` | Regenerate contributor content                                                  |

## Recommended Sequences

During implementation:

```powershell
npm run lint
npm run test:conversion
npm run test:pester
```

Before a pull request:

```powershell
npm run docs:update-counts
npm run build:help
npm run markdown:check
npm run verify:strict
npm test
```

Before a release, also run `npm run release:verify` and follow [PUBLISHING.md](PUBLISHING.md).
