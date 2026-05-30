---
name: "Codex-Instructions-ESLint-Testing"
description: "Instructions for writing robust, type-safe tests for ESLint rules using RuleTester, Vitest, and Fast-Check."
applyTo: "test/**"
---

<instructions>
  <goal>

## Your Goal for ESLint Rule Testing

- You understand that testing ESLint rules requires covering not just the "happy path" but also:
  - **Syntax Edge Cases:** Nested structures, mixed JS/TS, weird formatting.
  - **Type Inference:** How rules behave when types are `any`, `unknown`, or complex unions.
  - **Fixer Safety:** Ensuring autofixers produce valid syntax and don't change runtime behavior destructively.
- You strictly use **Vitest** as the test runner and **RuleTester** from `@typescript-eslint/rule-tester` (NOT the legacy `eslint` RuleTester).

  </goal>

  <setup>

## Test Infrastructure & Setup

- **Runner:** Vitest (compatible with standard Jest-like APIs).
- **RuleTester:** ALWAYS use `RuleTester` from `@typescript-eslint/rule-tester`.
- **Repository Helpers (Required):**
  - For typed rule tests, use `createTypedRuleTester()` from `test/_internal/typed-rule-tester`.
  - For parser-agnostic tests, use `createRuleTester()` from `test/_internal/ruleTester`.
  - Resolve plugin rules through `getPluginRule("<rule-id>")` from `test/_internal/ruleTester`.
- **Parser Services:**
  - Do **not** hand-roll parser configuration in each test file.
  - The helper already configures `@typescript-eslint/parser` and `projectService` with `tsconfig.eslint.json`.
- **Fixtures:**
  - Use `test/fixtures/typed/` for typed rule fixtures.
  - Use `readTypedFixture()` and `typedFixturePath()` from `test/_internal/typed-rule-tester`.
  - Keep fixture naming consistent: `<rule-id>.valid.ts`, `<rule-id>.invalid.ts`, and optional `<rule-id>.namespace.valid.ts` / `tests/<rule-id>.skip.ts`.
  - Do not mock the parser services unless absolutely necessary; prefer real parsing for accuracy.

  </setup>

  <coding>

## Writing Tests

### 1. Structure
- Every rule test file must follow this pattern:
  ```ts
  import { getPluginRule } from './_internal/ruleTester';
  import {
    createTypedRuleTester,
    readTypedFixture,
    typedFixturePath,
  } from './_internal/typed-rule-tester';

  const ruleTester = createTypedRuleTester();
  const validFixtureName = 'my-rule.valid.ts';
  const invalidFixtureName = 'my-rule.invalid.ts';

  ruleTester.run('my-rule', getPluginRule('my-rule'), {
    valid: [
      {
        code: readTypedFixture(validFixtureName),
        filename: typedFixturePath(validFixtureName),
      },
    ],
    invalid: [
      {
        code: readTypedFixture(invalidFixtureName),
        filename: typedFixturePath(invalidFixtureName),
        errors: [{ messageId: 'someMessageId' }],
      },
    ],
  });
  ```

### 2. Valid Cases (`valid`)
- Include code that *should not* trigger the rule.
- **False Positive Prevention:** purposefully include code that looks *similar* to the target pattern but is technically correct/safe.
- **Type Awareness:** Test with `any`, `unknown`, and `never` to ensure the rule doesn't crash or report incorrectly on these types.

### 3. Invalid Cases (`invalid`)
- Include code that *must* trigger the rule.
- **Errors:** Verify the exact `messageId` or error message structure.
- **Path-aware typed tests:** Include `filename` via `typedFixturePath(...)` so type-aware behavior mirrors real file resolution.
- **Output (Autofix):**
  - If the rule has a fixer, you MUST provide an `output` string.
  - The `output` must be valid TypeScript code.
  - If the fix is partial (multiple passes), verify the final state.
- **Options:** If the rule has options, add test cases explicitly setting them.

### 4. Property-Based Testing (`fast-check`)
- Use `fast-check` to generate random AST structures or code snippets when the rule logic is complex (e.g., handling operator precedence or deep nesting).
- **Example Strategy:**
  - Generate random strings to test regex-based rules.
  - Generate deep JSON objects to test traversal logic.
  - Use `fc.string()` to ensure the rule handles weird unicode or whitespace without crashing.

  </coding>

  <guidelines>

## Best Practices

- **Strict Typing:** All test cases should use the generic types provided by `RuleTester` to ensure `options` and `messageIds` match the rule definition.
- **Multiline Code:** Use template literals (backticks) for code readability.
  - Avoid excessive indentation in the template literal; use `.trim()` or a utility helper if needed to normalize whitespace.
- **Comments:** Put a comment above complex test cases explaining *what* specific edge case is being tested (e.g., `// Should ignore generic constraints`).
- **Plugin Wiring:** Keep tests coupled to public plugin wiring by using `getPluginRule(...)` instead of importing rule modules directly in rule test files.
- **Performance:**
  - `RuleTester` runs strictly. If a test hangs, check for infinite loops in the rule's traversal or fixer.
- **Snapshot Testing:**
  - AVOID using Jest/Vitest snapshots for the `output`. Explicitly write the expected string in the test object. This makes the test self-documenting and easier to review.

  </guidelines>

  <examples>

## Example: Typed Rule Test

```ts
import { getPluginRule } from './_internal/ruleTester';
import {
  createTypedRuleTester,
  readTypedFixture,
  typedFixturePath,
} from './_internal/typed-rule-tester';

const ruleTester = createTypedRuleTester();
const validFixtureName = 'no-unsafe-push.valid.ts';
const invalidFixtureName = 'no-unsafe-push.invalid.ts';

ruleTester.run('no-unsafe-push', getPluginRule('no-unsafe-push'), {
  valid: [
    {
      code: readTypedFixture(validFixtureName),
      filename: typedFixturePath(validFixtureName),
    },
  ],
  invalid: [
    {
      code: readTypedFixture(invalidFixtureName),
      filename: typedFixturePath(invalidFixtureName),
      errors: [{ messageId: 'unsafePush' }],
    }
  ],
});
```

## Example: Property-Based Test (Fast-Check)

```ts
import * as fc from 'fast-check';
import { checkSpecificLogic } from '../rules/utils/my-helper';

test('utility function handles all string inputs', () => {
  fc.assert(
    fc.property(fc.string(), (text) => {
      // Ensure the helper never throws on arbitrary input
      const result = checkSpecificLogic(text);
      return typeof result === 'boolean';
    })
  );
});
```

  </examples>
</instructions>
