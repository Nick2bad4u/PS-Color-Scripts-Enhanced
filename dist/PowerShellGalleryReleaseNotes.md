## ✨ What's Changed in v2026.7.20.2250

- <b>Commit Range: ➡️</b> [`v2026.7...v2026.7`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/v2026.7.20.35...v2026.7.20.2250 "View full commit range on GitHub")



### 🛠️ Bug Fixes


- [`890804b`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/890804b38696953116f2d8af2b495842bf9e44f8 "Diff: 116 files, +1691 | -5251") — 🛠️ [fix] Make localized help builds idempotent <sub><em>(116 files, +1691, -5251)</em></sub>

🛠️ [fix] Replace generated related-link sections with one canonical HelpUri and collapse duplicate or empty MAML navigation links after PlatyPS export.

🧪 [test] Verify every translated Markdown topic and MAML command exposes exactly one online link and prove consecutive help builds are byte-stable.

📝 [docs] Normalize packaged documentation casing so copied cross-platform links resolve on case-sensitive filesystems.



- [`11c9f4c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/11c9f4c3102ef94f25f682aa111135593f3e027e "Diff: 11 files, +1548 | -1918") — 🛠️ [fix] Make ANSI conversion terminal-aware <sub><em>(11 files, +1548, -1918)</em></sub>

🛠️ [fix] Decode legacy art safely, emulate cursor movement, split compound canvases deterministically, and preserve PowerShell-safe output across converters.

🧹 [chore] Remove duplicate source artifacts only after byte-aware comparison and retain the usable Megajoint segment already in the module catalog.

🧪 [test] Add Node coverage for SGR state, cursor controls, CP437 input, Unicode escaping, malformed sequences, and splitter boundaries.



- [`1898573`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1898573e8576b869ffd9ea575e54d5194d9fb75e "Diff: 32 files, +396 | -273") — 🛠️ [fix] Harden module state and process handling <sub><em>(32 files, +396, -273)</em></sub>

🛠️ [fix] Make configuration getters side-effect free, defer approved writes, preserve malformed files, and keep cache and metadata state coherent.

🛠️ [fix] Drain child-process streams without deadlocks, report renderer failures, and keep Windows PowerShell platform detection explicit.

🧪 [test] Cover WhatIf behavior, transient configuration paths, profile ownership, large redirected streams, and updated internal contracts.



### 🛡️ Security


- [`a1682f0`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a1682f0b0d4d847b75320910887d045c1bcb1fc7 "Diff: 6 files, +179 | -534") — 🔒 [security] Remove vulnerable build dependencies <sub><em>(6 files, +179, -534)</em></sub>

Replace the unmaintained frontmatter validator and enforce patched adm-zip and esbuild versions so a clean npm audit reports zero findings.

Scope publish write access to the release job and replace flagged SAUCE padding regexes with bounded linear parsing plus regression coverage.



### 📝 Documentation


- [`8d26887`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8d26887057dabc465a36d8070e6a29a57e1797aa "Diff: 177 files, +43125 | -39030") — 📝 [docs] Synchronize help and collection guidance <sub><em>(177 files, +43125, -39030)</em></sub>

📝 [docs] Regenerate Markdown and MAML help for all ten cultures from corrected command metadata and align translated messages with the current module behavior.

📝 [docs] Replace stale cache, platform, testing, versioning, and publishing claims; fix case-sensitive links; and keep the Gallery README below its strict size threshold.

📝 [docs] Document terminal-aware ANSI conversion, duplicate handling, and additional source collections including 16colo.rs, Textfiles art packs, botany, os-ansi, and hyfetch.



### 🧹 Chores


- [`a0f1e64`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a0f1e6427670b68e081f1cc50868cab4a07d8e43 "Diff: 15 files, +51 | -26") — 🔖 [chore] Prepare version 2026.7.20.2250 <sub><em>(15 files, +51, -26)</em></sub>

Update the module and localized help metadata to the release candidate version.

Make changelog validation tag-aware and document the reproducible versioned release-note workflow.



### 👷 CI/CD


- [`fd19bd8`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/fd19bd84c6df97841616d6dec764e07bc54dbad2 "Diff: 1 file, +22 | -0") — 👷 [ci] Install ANSI runtime dependencies for Pester <sub><em>(1 file, +22, -0)</em></sub>

Install the locked production-only Node.js dependency set in the Windows PowerShell and cross-platform PowerShell jobs. This lets repository-script tests execute the ANSI converter in the same clean environment used by GitHub Actions.



- [`250f6d8`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/250f6d87b75189581a3b03823b4c1f38bd7e80a5 "Diff: 19 files, +1287 | -3595") — 👷 [ci] Make release validation deterministic <sub><em>(19 files, +1287, -3595)</em></sub>

👷 [ci] Normalize versioned builds across release triggers, reuse the repository analyzer entry point, and keep verification non-mutating.

🛠️ [fix] Isolate flaky PSScriptAnalyzer passes with bounded adaptive subdivision while preserving every enabled rule and failing closed on persistent errors.

🧪 [test] Add release-wiring and maintenance-script regressions, strengthen coverage output handling, and remove the obsolete private-function snapshot.








> [!NOTE]
> **Release comparison**: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/v2026.7.20.35...v2026.7.20.2250


## ⭐ Contributors
Thanks to anyone who has 🧑‍💻 [contributed](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors).

*This changelog was automatically generated with ⛰️ [git-cliff](https://github.com/orhun/git-cliff).*
