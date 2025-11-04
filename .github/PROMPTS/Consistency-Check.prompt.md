---
agent: "BeastMode"
model: GPT-5-Codex (Preview) (copilot)
description: "Run a consistency audit tailored for the ColorScripts-Enhanced PowerShell module."
argument-hint: "This task involves reviewing the implementation code across the ColorScripts-Enhanced PowerShell module to ensure consistency with PowerShell module best practices and conventions. Identify inconsistencies in structure, data flow, logic, and interfaces, and provide a prioritized report of findings with actionable recommendations for alignment."
name: "ConsistencyCheck"
---

# ColorScripts-Enhanced Consistency Audit Prompt

## Objective

Review implementation code across the ColorScripts-Enhanced PowerShell module to confirm the project continues to follow PowerShell module best practices and conventions. Cover foundational functions, caching mechanisms, configuration management, localization, and public cmdlets without dwelling on test-only files.

Go in detail to identify inconsistencies in structure, data flow, logic, and interfaces that could lead to maintenance challenges or bugs. Provide a prioritized report of findings with actionable recommendations for alignment.

Be super thorough and precise, as this will guide future refactoring and standardization efforts.

We want architectural perfection before adding new features.

If you find documentation gaps add them. If you find out-of-date documentation add a task to update it to the todo list.

## Analysis Requirements

### 1. Structural Alignment

- Ensure common PowerShell module patterns for parameter binding, pipeline support, error handling, and configuration management are applied uniformly across all public and private functions.
- Call out notable deviations from PowerShell best practices or from the helper abstractions that already exist in the codebase.

### 2. Data Flow Health

- Trace representative flows from colorscript execution through caching, metadata loading, configuration access, and output rendering to confirm validations, transformations, and error handling behave consistently.
- Note any mismatched logging, warning, or verbose messaging approaches that could hinder troubleshooting.

### 3. Logic Uniformity

- Look for domain rules or business logic implemented in multiple places with conflicting behaviour.
- Check that script-scope variables, lazy initialization patterns, and helper functions follow established conventions for naming, scope management, and cleanup.

### 4. Interface Cohesion

- Compare cmdlet parameters, configuration schemas, and metadata structures to ensure consistency across all public commands.
- Highlight ad-hoc parameter sets or return types that should instead follow established patterns.

### 5. Inconsistency Sweep

- Identify special-case paths or shortcuts that bypass shared utilities, caching mechanisms, or configuration helpers.
- Surface direct script-scope variable access or other anti-patterns that erode maintainability.

## Output Requirements

### 1. Categorized Report

For each inconsistency provide:
- Relevant file path(s) with concise excerpts.
- A short description of the issue, including the layer or pattern it affects.
- A recommended alignment approach grounded in an existing best practice within the repository.

### 2. Prioritization

Rank findings by their risk to stability, potential to introduce bugs, and overall impact on maintainability or onboarding.

### 3. Improvement Suggestions

Group related findings and outline:
- The preferred approach or exemplar to follow.
- Ordered steps to realign the affected code.
- Expected impact across modules, IPC contracts, schemas, or docs.

### 4. Roadmap

Suggest a staged plan:
- **Quick Wins** – light standardisations with meaningful payoff.
- **Medium-Term** – coordinated refactors requiring moderate coordination.
- **Long-Term** – deeper architectural work worth tracking separately.

## Additional Guidance

- Focus on implementation files; Pester tests are out of scope for consistency checks.
- Prioritise function boundaries (public cmdlets ↔ private helpers, configuration ↔ caching, metadata ↔ inventory).
- Treat formatting as secondary; address consistency first and run PSScriptAnalyzer afterwards if needed.
- Refer to existing documentation (e.g., `docs/`, `README.md`, help XML) before proposing parameter or output adjustments.
- Leverage available tooling (Get-Errors, PSScriptAnalyzer, Pester coverage reports) when additional context is required.

## Fixing Inconsistencies

When addressing identified inconsistencies, follow these steps:
1. **Understand the Context**: Review the relevant code sections to fully grasp the intended functionality and how it fits within the overall architecture.
2. **Consult Documentation**: Refer to any existing documentation or architectural guidelines to ensure your changes align with established best practices.
3. **Refactor Thoughtfully**: Make changes that enhance consistency without introducing new issues. Ensure that your refactoring maintains the original functionality.
4. **Test Thoroughly**: After making changes, run existing tests and add new ones if necessary to verify that the changes do not break any functionality.
5. **Document Changes**: Update any relevant documentation to reflect the changes made, ensuring that future developers can understand the rationale behind the adjustments.
6. **No Backwards Compatibility**: Do NOT create backwards compatibility layers; instead, refactor all affected code to use the updated patterns or interfaces directly.
7. **Add to Todo List**: Add all identified inconsistencies to a detailed todo list with descriptions and work through the entire list.

## Examples of Inconsistencies to Look For

Examples of inconsistencies include:
- Different naming conventions for similar functions or variables (e.g., verb-noun patterns, parameter names).
- Varied approaches to error handling in public cmdlets versus private helpers.
- Divergent data transformation logic for the same data structure in different functions.
- Inconsistent use of shared utilities or helper functions across the module.
- Mismatched parameter validation attributes across similar cmdlets.
- Ad-hoc implementations of features that should leverage existing caching or configuration patterns.
- Uneven application of pipeline support (ValueFromPipeline, ValueFromPipelineByPropertyName) across cmdlets.
- Discrepancies in Write-Verbose, Write-Warning, or Write-Debug usage patterns.
- Direct script-scope variable manipulation that bypasses initialization helpers.
- Lack of uniformity in ShouldProcess usage for state-changing operations.
- Inconsistent structuring of public versus private functions.
- Varied approaches to input validation (ValidateSet, ValidatePattern, ValidateScript).
- Different strategies for managing script-scope state and lazy initialization.
- Inconsistent documentation styles in comment-based help and XML help files.
- Special-case code paths that deviate from standard caching or metadata flows without clear justification.
- Divergent implementations of similar features (e.g., multiple ways to resolve paths or filter scripts).
- Inconsistent OutputType declarations across cmdlets that return structured objects.
- Varied approaches to configuration management and environment variable usage.
- Different testing strategies or coverage levels for similar functionalities.
- Inconsistent handling of user configuration and preferences across the module.
- Varied approaches to localization and message string management.
- Discrepancies in performance optimization techniques (e.g., .NET direct calls vs cmdlets).
- Inconsistent use of Write-Host versus Write-Information for informational output.
- Divergent strategies for caching and invalidation across different features.
- Varied methods for progress reporting (Write-Progress) across long-running operations.
- Different patterns for managing module-scope variables and initialization state.
- Inconsistent use of parameter sets across related cmdlets.
- Varied approaches to handling WhatIf and Confirm preferences.
- Inconsistent error message formatting and localization key usage.
- Divergent implementations of filtering logic (by name, category, tag) across cmdlets.

## Final Note and Summary

The goal is to achieve a consistent, maintainable PowerShell module that adheres to established PowerShell best practices and conventions. Address all inconsistencies methodically, prioritize impactful changes, and ensure thorough testing with Pester and documentation updates throughout the process. Consistency means fewer bugs and easier maintenance in the long run. Add all identified inconsistencies to a detailed todo list with descriptions and work through the entire list.
