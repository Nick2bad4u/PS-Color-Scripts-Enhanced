# Project Roadmap

ColorScripts-Enhanced is a mature module and a large, curated ANSI-art collection. The roadmap is intentionally maintenance-oriented: repository issues and release plans determine sequencing, and this document does not promise dates.

## Current Baseline

- <!-- COLOR_SCRIPT_COUNT -->24822<!-- /COLOR_SCRIPT_COUNT --> bundled colorscripts with metadata-backed discovery
- 10 public commands and three aliases
- Windows PowerShell 5.1 and PowerShell 7+ support on Windows, macOS, and Linux
- Static extraction for deterministic bundled art
- Explicit dynamic-render and selective-cache policies
- Parallel cache building on PowerShell 7+
- User-scoped configuration and managed profile integration
- 10 runtime-message and external-help cultures
- ANSI conversion, splitting, duplicate detection, corpus validation, and release automation
- Resumable 16colors and Roy archive inventory with rendered-cell deduplication and interactive visual review
- Hash-locked content, contact, geometry, and adult-policy review ledgers for the retained gallery
- Repository-only authoritative artwork provenance with compact per-script links and a generated web details index

## Active Maintenance Priorities

### Collection Quality

- Periodically refresh the completed 1990-2026 16colors and Roy checkpoints, preserving the same fail-closed review policy.
- Preserve source attribution and record provenance for imported art.
- Reject duplicate, corrupted, unsafe, or terminal-hostile files before conversion.
- Split oversized art only when the visual composition remains useful.
- Expand useful metadata and descriptions without inventing authorship or licensing claims.

### PowerShell Quality

- Keep public commands idiomatic across PowerShell 5.1 and 7+.
- Maintain exact parameter-set, pipeline, `ShouldProcess`, output-object, and external-help contracts.
- Keep deterministic bundled scripts on the static extraction path.
- Add a renderer to `DynamicRenderPolicy.psd1` only when its output genuinely changes.
- Add a dynamic renderer to `CachePolicy.psd1` only when its render cost justifies cache I/O.

### Help and Localization

- Keep all 10 culture packages structurally synchronized with the exported command surface.
- Replace remaining inherited English prose with reviewed translations.
- Keep Markdown help as the editable source and regenerate MAML with the pinned PlatyPS workflow.
- Prevent examples, output properties, aliases, and environment-variable names from drifting.

### Testing and Release Reliability

- Preserve Windows PowerShell 5.1 and cross-platform PowerShell 7 coverage.
- Expand behavior-focused tests around profile editing, configuration, static extraction, dynamic execution, and cache invalidation.
- Keep generated documentation, package metadata, changelog ranges, and manifest versions reproducible.
- Continue dependency, supply-chain, secret, and static-analysis maintenance without weakening gates.

## Candidate Enhancements

These are candidates, not commitments:

- richer gallery/search tooling over exported metadata;
- better preview and visual-QA tooling for converted ANSI art;
- additional terminal and font compatibility fixtures;
- schema-backed provenance-template validation and editor assistance;
- clearer reporting for partial translations;
- performance benchmarks that measure real renderer/cache paths without claiming universal multipliers.

## Contribution Guidance

Before implementing a roadmap item, open or locate a repository issue so scope and ownership are clear. Changes should include focused tests, accurate help/docs, and evidence that the behavior works on its supported PowerShell editions.

Useful starting points:

- [Contributing Guide](../CONTRIBUTING.md)
- [Development Guide](DEVELOPMENT.md)
- [Testing Guide](TESTING.md)
- [ANSI Conversion Guide](ANSI-CONVERSION-GUIDE.md)
- [Release Checklist](RELEASE_CHECKLIST.md)
- [Issue tracker](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues)

---

_Last reviewed: August 4, 2026_
