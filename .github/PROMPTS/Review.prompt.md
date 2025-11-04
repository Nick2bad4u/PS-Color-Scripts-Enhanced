---
agent: "BeastMode"
model: GPT-5-Codex (Preview) (copilot)
argument-hint: "This task involves reviewing the entire TODO list for completion, finishing any unfinished items, ensuring all linters, tests, and checks pass, and conducting a final review of all work."
description: "Review TODO List Completion, Run Quality Checks, and Review Work"
name: "Review"
---

- Begin by reviewing the entire TODO list in the designated todo.md file at the repository root. Assess each item for completion status, implementation details, and any outstanding issues.
- For any unfinished or partially completed TODO items, implement the necessary changes, fixes, or features using available tools. Ensure thorough testing and validation to resolve issues without introducing new problems. Update the TODO list to reflect progress or completion.
- Once all TODO items are confirmed complete, run comprehensive quality checks: execute PSScriptAnalyzer (e.g., via `npm run lint` task), run the full Pester test suite (e.g., via `npm run test` and `npm run test:coverage` tasks). Capture and summarize outputs, fixing any failures before proceeding.
- Conduct a final review of all work: verify adherence to PowerShell module best practices, code quality standards (e.g., comment-based help, parameter validation, proper error handling with Pester tests), and established patterns. Document any findings, update TODOs if needed, and ensure no stale items remain.
- Iterate as necessary until all reviews and checks are fully satisfied, maintaining clear documentation throughout the process.
- Be on the lookout for any potential improvements or optimizations that can be made to the codebase, including:
  - Refactoring code for improved readability and maintainability.
  - Identifying and addressing performance bottlenecks.
  - Enhancing test coverage and reliability.
  - Improving localization and configuration management.
  - Streamlining module initialization and caching.
