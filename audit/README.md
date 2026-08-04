# ANSI Audit and Provenance Records

This directory contains repository-only evidence used to curate and verify the bundled ANSI artwork. It is intentionally outside `ColorScripts-Enhanced/` so PowerShell Gallery packages do not ship tens of megabytes of developer audit data.

- [ArtworkProvenance.psd1](ArtworkProvenance.psd1) is the complete per-script provenance map, including source URLs, hashes, attribution, encoding, conversion mode, and source coordinates.
- [ArtworkHeaderMigration.json](ArtworkHeaderMigration.json) proves that detailed mapped-script headers were replaced without changing their executable payloads and hash-locks unmapped legacy scripts.
- [AnsiArchiveCurationCheckpoint.json](AnsiArchiveCurationCheckpoint.json) records the canonical archive inventory and accepted-source checkpoint.
- [AnsiContentCurationCheckpoint.json](AnsiContentCurationCheckpoint.json) summarizes post-import content and geometry curation.
- `Ansi*ReviewLedger*.json` and `Ansi*Manifest.json` are hash-locked review evidence consumed by repository tooling and tests.

These files are development and compliance records, not runtime data. The publishable module keeps the required script metadata and third-party notices under `ColorScripts-Enhanced/`.

`npm run artwork:provenance:headers:check` rejects payload drift, missing offline attribution, incorrect details URLs, and the return of verbose mapped headers. `npm run artwork:provenance:web:check` verifies that `docs/assets/artwork-provenance.json` is an exact generated projection of the authoritative PSD1.
