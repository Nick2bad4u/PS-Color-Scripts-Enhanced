---
name: "Codex-Instructions-ESLint-Docs"
description: "Instructions for writing perfect ESLint rule documentation."
applyTo: "docs/**"
---

<instructions>
  <goal>

## Your Goal for ESLint Rule Documentation

- Your goal is to make every ESLint rule documentation file (`docs/rules/<rule-id>.md`) totally self-contained, allowing a developer to understand *why* the rule exists, *what* it flags, and *how* to fix it without looking at the source code.
- For adjacent docs in `docs/rules/` such as guides, preset pages, `overview.md`, or `getting-started.md`, keep the same tone and accuracy standards, but do not force rule-only sections where they do not fit.
- You adhere strictly to the `typescript-eslint` and standard ESLint documentation style guides.

  </goal>

  <structure>

## Documentation Structure

Rule documentation files in `docs/rules/<rule-id>.md` should follow this structure closely:

1.  **Title:** The bare rule ID as the H1 header (e.g., `# prefer-type-fest-arrayable`).
2.  **Description:** A short, one-sentence description of what the rule does.
3.  **Meta Badges (Optional):** Badges for `Recommended`, `Fixable`, or `Type Checked` only if the repository’s current docs pattern uses them.
4.  **Rule Details:** An explanation of the problem the rule solves. Why is this pattern bad?
5.  **Examples:**
    - Use `❌ Incorrect` and `✅ Correct` headers.
    - **Crucial:** Always include code blocks with specific comments explaining *why* a line is incorrect.
    - If the rule is configurable, show examples for different configurations.
6.  **Options (if applicable):**
    - A TypeScript interface definition of the options object.
    - Default values clearly marked.
    - Examples for each option.
7.  **When Not To Use It:** specific scenarios where disabling this rule is acceptable.
8.  **Further Reading:** Links to MDN, TypeScript docs, or relevant specs.

  </structure>

  <style>

## Style & Tone

- **Voice:** Professional, objective, and helpful. Avoid slang.
- **Clarity:** Use active voice. "This rule reports..." instead of "This rule is used to report...".
- **Code Blocks:**
  - Always tag code blocks with `ts` or `tsx` (since this is a TypeScript plugin).
  - Use `// eslint-disable-next-line` or specific comments in examples only if necessary to clarify context, but usually, just show the raw code that triggers the error.
- **Configuration:**
  - Assume **Flat Config** (`eslint.config.mjs`) for all configuration examples.
  - Do not use legacy `.eslintrc` JSON snippets.

  </style>

  <guidelines>

## Writing Guidelines

- **The "Why":** Never just say "Don't do X." Explain the consequence.
  - *Bad:* "Don't use `any`."
  - *Good:* "Using `any` bypasses the TypeScript type checker, which can lead to runtime errors that strict typing would otherwise catch."
- **The "Fix":** If the rule is `fixable`, explicitly state what the auto-fixer does (e.g., "The auto-fixer will replace `var` with `let`.").
- **Type Information:** If the rule requires type information (`parserServices`), add a specific note at the top of the docs:
  > ⚠️ This rule requires type information to run. It will not work without `projectService` (or equivalent typed parser setup) configured.
- **Preset awareness:** Repository presets such as `etc-misc.configs["recommended-type-checked"]`, `etc-misc.configs.strict`, and `etc-misc.configs.all` already wire the typed parser setup for you; do not imply that users must always configure it manually.
- **Consistency:** Ensure the examples actually trigger the rule. Do not use hypothetical examples that strictly wouldn't fail the specific AST selector of the rule.

  </guidelines>

  <examples>

## Example Doc

```markdown
# prefer-ts-extras-array-find-last-index

Prefer [`arrayFindLastIndex`](https://github.com/sindresorhus/ts-extras/blob/main/source/array-find-last-index.ts) from `ts-extras` over `array.findLastIndex(...)`.

`arrayFindLastIndex(...)` improves predicate inference in typed arrays.

## Targeted pattern scope

This rule focuses on direct `array.findLastIndex(predicate)` calls that can be migrated to `arrayFindLastIndex(array, predicate)` with deterministic fixes.

- `array.findLastIndex(predicate)` call sites that can use `arrayFindLastIndex(array, predicate)`.

Alias indirection, wrapper helpers, and non-canonical call shapes are excluded to keep `arrayFindLastIndex(array, predicate)` migrations safe.

## What this rule reports

This rule reports `array.findLastIndex(predicate)` call sites when `arrayFindLastIndex(array, predicate)` is the intended replacement.

- `array.findLastIndex(predicate)` call sites that can use `arrayFindLastIndex(array, predicate)`.

## Why this rule exists

`arrayFindLastIndex` standardizes reverse index lookup and keeps call signatures aligned with other `ts-extras` search helpers.

- Reverse index scans are explicit at the call site.
- Search code avoids mixed native/helper patterns.
- Index-based follow-up logic stays uniform across modules.

## ❌ Incorrect

```ts
const index = monitors.findLastIndex((entry) => entry.id === targetId);
```

## ✅ Correct

```ts
const index = arrayFindLastIndex(monitors, (entry) => entry.id === targetId);
```

## Behavior and migration notes

- Runtime behavior matches native `Array.prototype.findLastIndex`.
- Search still proceeds from right to left.
- If no element matches, the result is `-1`.

## Additional examples

### ❌ Incorrect — Additional example

```ts
const index = logs.findLastIndex((entry) => entry.level === "warn");
```

### ✅ Correct — Additional example

```ts
const index = arrayFindLastIndex(logs, (entry) => entry.level === "warn");
```

### ✅ Correct — Repository-wide usage

```ts
const retryIndex = arrayFindLastIndex(attempts, (attempt) => !attempt.success);
```

## ESLint flat config example

```ts
import etc-misc from "eslint-plugin-etc-misc";

export default [
    {
        plugins: { etc-misc },
        rules: {
            "etc-misc/prefer-ts-extras-array-find-last-index": "error",
        },
    },
];
```

## When not to use it

Disable this rule if your codebase has standardized on native `.findLastIndex()`.

## Package documentation

ts-extras package documentation:

`ts-extras@0.17.x` does not currently expose `arrayFindLastIndex` in its published API, so there is no canonical `source/*.ts` link for this helper yet.

Reference links:

- [`ts-extras` API list (README)](https://github.com/sindresorhus/ts-extras/blob/main/readme.md#api)
- [`ts-extras` source directory](https://github.com/sindresorhus/ts-extras/tree/main/source)

> **Rule catalog ID:** R005

## Further reading

- [`ts-extras` README](https://github.com/sindresorhus/ts-extras)
- [`ts-extras` package reference](https://www.npmjs.com/package/ts-extras)
- [TypeScript Handbook: Narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html)

## Adoption resources

- [Rule adoption checklist](https://nick2bad4u.github.io/eslint-plugin-etc-misc/docs/rules/guides/adoption-checklist)
- [Rollout and fix safety](https://nick2bad4u.github.io/eslint-plugin-etc-misc/docs/rules/guides/rollout-and-fix-safety)

  </examples>
</instructions>
