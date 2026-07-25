# MegaLinter Configuration

The repository retains `.mega-linter.yml` for optional broad repository scans. MegaLinter is not the primary PowerShell quality gate and there is currently no dedicated MegaLinter workflow under `.github/workflows/`.

## Current Quality Gates

Use the repository-owned commands for normal development and CI parity:

```powershell
npm run verify
npm run verify:strict
npm test
npm run markdown:check
npm run lint:gitleaks
npm run lint:yamllint
```

`scripts/Lint-Module.ps1` and `PSScriptAnalyzerSettings.psd1` own PowerShell analysis. Bundled colorscripts are treated as art/data and are validated by the corpus and conversion tests rather than applying the full module analyzer rules to all <!-- COLOR_SCRIPT_COUNT_PLUS -->12578+<!-- /COLOR_SCRIPT_COUNT_PLUS --> files.

## Optional MegaLinter Use

If running MegaLinter locally or adding it to a workflow, use the checked-in `.mega-linter.yml` and review its output as an additional signal. Do not replace the repository's Pester, conversion, ScriptAnalyzer, link, provenance, or package checks with one aggregate linter result.

Before enabling a workflow:

1. pin the MegaLinter action to a full commit SHA;
2. grant only the permissions required by the selected reporters;
3. keep generated reports out of source control unless intentionally published;
4. confirm the exclusions still match the current repository layout; and
5. run the existing quality gates independently.

## Git-Cliff

Git-cliff configuration comes from the installed `gitcliff-config-nick2bad4u` package, not a root `cliff.toml`.

```powershell
npm run changelog:preview
npm run release:notes
npm run release:verify
```

Release-note generation depends on local tags. Fetch tags before diagnosing a stale range, and preserve the established `--current` contract used by release verification and the publish workflow.

## Maintenance

Treat this document as configuration guidance, not a record of previously “fixed” issues. When `.mega-linter.yml`, package scripts, or CI workflows change, update the claims here from those files rather than retaining historical checklist entries.

---

_Last reviewed: July 21, 2026_

