---
agent: "BeastMode"
model: GPT-5-Codex (Preview) (copilot)
description: "Generate As much Pester Test Coverage for PowerShell Module as possible"
argument-hint: "This task involves generating Pester tests for the PowerShell module to achieve 94%+ coverage. Analyze existing coverage reports to identify untested code paths, edge cases, and parameter scenarios. Create comprehensive Pester tests that cover all functions, cmdlets, and critical logic branches, ensuring robust validation of expected behavior, error handling, and edge cases. Focus on clarity, maintainability, and adherence to established Pester testing patterns."
name: "Generate-Test-Coverage"
---

# Review All Coverage and Pester Test Files

---

## Workflow

1. **Fix all broken tests first.**
2. Run and check current test/analyzer errors and warnings:
   - `npm run test`
   - `npm run lint`
     _Do not move onto the next step until all tests pass with no errors or warnings._
3. Ensure all tests pass with no errors or warnings.
4. Check coverage and create tests for module lines below 94% coverage:
   - `npm run test:coverage -- -CI`
5. Scan PowerShell module code to create intelligent Pester tests for all branches and edge cases.
6. Ensure comprehensive tests for all edge cases including:
   - Parameter validation scenarios
   - Pipeline input handling
   - ShouldProcess/WhatIf support
   - Error conditions and exception handling
   - Configuration and cache state variations
   - Cross-platform behavior (Windows/Linux/macOS)
7. Use unlimited requests and time as needed.
8. **Do not skip any functions**, regardless of size or perceived triviality.
9. Continue until module coverage reaches at least 94% for all analyzed commands.
10. Do not stop, even if the process is lengthy.
11. Always start with the functions with the lowest coverage first, and work your way up.
12. Some code may have low coverage due to being debug/trace only, Write-Host output, or initialization. Focus on functional code coverage.

---

## Test Creation

### General Guidelines

1. **Aim for clarity and simplicity** in your Pester tests. They should be easy to read and understand.
2. **Test one thing at a time**. If a test is failing, you should be able to pinpoint the exact cause.
3. **Use descriptive names** for your Describe/Context/It blocks. This will make it easier to understand what is being tested and why.
4. **Pester Features are essential** for creating effective PowerShell tests. Use:
   - `Describe` for grouping related tests (typically per function)
   - `Context` for grouping related scenarios within a function
   - `It` for individual test cases
   - `BeforeAll`/`AfterAll` for test suite setup/teardown
   - `BeforeEach`/`AfterEach` for per-test setup/teardown
   - `InModuleScope` for testing private module functions
   - `Mock` for mocking cmdlets and functions
   - `Should` assertions for validation
5. Always structure tests in the pattern:
   ```powershell
   Describe "Function-Name" {
       Context "Scenario description" {
           It "should behave in expected way" {
               # Arrange
               # Act
               # Assert
           }
       }
   }
   ```
6. You can use Pester's `-Tag` parameter to filter tests:
   - Example: `Invoke-Pester -Tag "Unit"` will only execute tests tagged with "Unit"

---

### Pester API Reference

- [Pester Documentation](https://pester.dev/docs/quick-start)
- [Pester Assertions](https://pester.dev/docs/assertions/)

#### Test Structure

- `Describe`: Group related tests (typically per function or feature)
- `Context`: Group related scenarios within a Describe block
- `It`: Individual test case
- `BeforeAll`/`AfterAll`: Setup/teardown for entire Describe block
- `BeforeEach`/`AfterEach`: Setup/teardown for each It block
- [Pester Test Structure](https://pester.dev/docs/usage/test-file-structure)

#### Test Scoping

- `InModuleScope`: Execute tests within module scope to access private functions and variables
- Essential for testing internal module functions not exported
- [InModuleScope Documentation](https://pester.dev/docs/usage/inmodulescope)

#### Test Mocking

- Use `Mock` to replace cmdlets/functions with test doubles
- Use `Assert-MockCalled` to verify mock invocations
- Mocks are automatically cleaned up after each test
- [Pester Mocking](https://pester.dev/docs/usage/mocking)

#### Test Assertions (Should)

- `Should -Be`: Equality comparison
- `Should -BeExactly`: Case-sensitive string comparison
- `Should -Match`: Regex pattern matching
- `Should -Contain`: Collection membership
- `Should -BeNullOrEmpty`: Null or empty validation
- `Should -Throw`: Exception validation
- `Should -BeOfType`: Type validation
- Many more available - see [Pester Assertions](https://pester.dev/docs/assertions/)

## Common Pester Patterns

- **Core Testing:** `Describe`, `Context`, `It`, `Should`
- **Setup/Teardown:** `BeforeAll`, `AfterAll`, `BeforeEach`, `AfterEach`
- **Mocking:** `Mock`, `Assert-MockCalled`
- **Conditional Testing:** `It -Skip`, `-Tag` filtering
- **Module Testing:** `InModuleScope`, `Import-Module -Force`
- **Parameter Testing:** Test all parameter sets, pipeline support, validation attributes
- **Error Testing:** `-ErrorAction`, `-ErrorVariable`, `Should -Throw`

---

## Special Instructions

- **Ignore coverage for Write-Host statements, debug/trace logging, and module initialization boilerplate.**
- Focus on functional code and logic in cmdlets and helper functions.
- Cover all edge cases where applicable, including:
  - Empty/null parameter values
  - Invalid parameter combinations
  - Pipeline input scenarios
  - Cross-platform path handling
  - Configuration and cache state variations
- If something is too hard to test or mock:
  - Create a documentation file explaining why it is not covered.
  - Document edge cases and suggest improvements for testability.
- **If you discover a legitimate bug or issue while writing tests:**
  - Document it in a separate file.
  - Fix the codebase as appropriate (only if 100% sure).
  - Always be on the lookout for potential bugs.

---

## Requirements

- 94%+ coverage of analyzed commands in the module.
- Create tests for all functions and code paths below 94% coverage.
- Existing coverage is already at 94%+, maintain or improve it.

### Important AI Note

- **Time constraint setting:** `unlimited`
- **Compute Resource setting:** `unlimited`
- **Thinking Mode setting:** `Ultrathink`

---

## Success Criteria

You cannot stop until you achieve full completion of ALL of these criteria:

- Zero failing Pester tests across all test suites
- Zero PSScriptAnalyzer warnings or errors
- 94%+ coverage of analyzed commands in the PowerShell module
- All new tests follow established Pester patterns and conventions
- All tests properly use InModuleScope for testing private functions
- All tests properly clean up state (variables, mocks) in AfterEach blocks

---
