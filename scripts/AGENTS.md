---
name: "Scripts-Folder-Guidelines"
description: "Guidance for repository maintenance and automation scripts under scripts/."
applyTo: "scripts/**"
---

# Scripts (`scripts/`) Guidelines

Treat `scripts/` as the repository's automation and maintenance toolbox, not as application runtime code.

## Purpose

Scripts in this folder commonly handle tasks like:

- generating or syncing docs/readme sections
- validating links or metadata
- syncing version or peer-dependency constraints
- compatibility smoke tests
- repo bootstrapping and scaffolding
- TypeDoc / Docusaurus support tasks

Keep them deterministic, reviewable, and safe to run repeatedly.

## Authoring expectations

- Prefer Node.js ESM scripts (`.mjs`) for cross-platform repo automation unless there is a strong reason to use another language.
- Use PowerShell only when the task is intentionally Windows-specific or shell-native.
- Resolve paths from the repository root explicitly; avoid assuming the current working directory unless the script contract guarantees it.
- Use `node:` built-ins where possible.
- Prefer small, composable helpers over giant monolithic scripts.
- Print actionable diagnostics and exit with a non-zero code on failure.

## Safety and determinism

- Scripts that rewrite files should be:
  - idempotent
  - deterministic
  - explicit about what they change
- Prefer a `--check`, `--write`, or similarly clear mode split when a script can either validate or mutate.
- Never silently rewrite unrelated files.
- Write temporary outputs to `temp/` or another designated generated folder rather than cluttering the repo root.

## Cross-platform discipline

- Avoid Bash-only syntax in Node-driven scripts.
- Avoid absolute machine-specific paths.
- If a script depends on platform behavior, document that clearly in comments or the README.
- Prefer repository scripts in `package.json` as the public entrypoint instead of telling users to invoke implementation files directly.

## Source of truth

- If a script exists to keep generated docs, readme tables, preset matrices, or config mirrors in sync, treat the upstream source as canonical and the generated output as derived.
- Do not fork the same logic into multiple scripts.
- If the repo already has a sync script for a task, update that script instead of adding a second competing generator.

## Quality bar

- Scripts should be easy to audit in diffs.
- Keep inputs and outputs obvious.
- Validate assumptions early.
- Prefer readable transformations over clever one-liners.
- If a script consumes built output, document why that is necessary; prefer source metadata when feasible.
