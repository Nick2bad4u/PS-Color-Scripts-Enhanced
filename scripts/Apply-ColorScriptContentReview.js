#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");
const {
    applyReviewedRows,
    compactBlankRowsIntroducedSince,
    documentCuration,
    extractPowerShellPayload,
    isSourceFidelityLocked,
    removeTrailingBlankRows,
    stripAnsiControls,
    trimExpandedLeadingBlankRows,
    validateColumnRanges,
} = require("./Audit-ColorScriptContent.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const DEFAULT_SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);
const MAX_SOURCE_BYTES = 16 * 1024 * 1024;

/**
 * @param {string} fileName
 *
 * @returns {void}
 */
function assertSafeFileName(fileName) {
    if (
        path.basename(fileName) !== fileName ||
        !/^[\w().!+&[\]#%@,' -]+\.ps1$/iu.test(fileName)
    ) {
        throw new Error(`Unsafe reviewed script filename: ${fileName}`);
    }
}

/**
 * @param {string} targetPath
 * @param {string} content
 *
 * @returns {void}
 */
function writeFileAtomic(targetPath, content) {
    const temporaryPath = `${targetPath}.${process.pid}.tmp`;
    fs.writeFileSync(temporaryPath, content, "utf8");
    fs.renameSync(temporaryPath, targetPath);
}

/**
 * @param {string} filePath
 *
 * @returns {string}
 */
function readBoundedSource(filePath) {
    const stat = fs.statSync(filePath);
    if (stat.size > MAX_SOURCE_BYTES) {
        throw new RangeError(
            `${filePath}: source exceeds the ${MAX_SOURCE_BYTES}-byte limit.`
        );
    }
    return fs.readFileSync(filePath, "utf8");
}

/**
 * @param {string} source
 * @param {string} baselineSource
 *
 * @returns {boolean}
 */
function mayContainNewBlankRows(source, baselineSource) {
    const currentRows = extractPowerShellPayload(source)
        .value.replace(/\r\n?/gu, "\n")
        .split("\n");
    const baselineRows = extractPowerShellPayload(baselineSource)
        .value.replace(/\r\n?/gu, "\n")
        .split("\n");
    const limit = Math.min(currentRows.length, baselineRows.length);
    for (let index = 0; index < limit; index += 1) {
        if (
            stripAnsiControls(currentRows[index]).trim().length === 0 &&
            stripAnsiControls(baselineRows[index]).trim().length > 0
        ) {
            return true;
        }
    }
    return false;
}

/**
 * @param {string} reviewPath
 *
 * @returns {Map<
 *     string,
 *     {
 *         action?: "blank-columns" | "blank-text" | "remove-row";
 *         allowedRemainingOccurrences?: number;
 *         columnRanges?: { end: number; start: number }[];
 *         expectedRawSha256?: string;
 *         expectedRenderedSha256?: string;
 *         row: number;
 *         sha256?: string;
 *         text?: string;
 *     }[]
 * >}
 */
function loadReview(reviewPath) {
    const document = JSON.parse(fs.readFileSync(reviewPath, "utf8"));
    if (!Array.isArray(document.candidates)) {
        throw new TypeError(
            "Reviewed content report lacks a candidates array."
        );
    }
    const result = new Map();
    for (const candidate of document.candidates) {
        const { file, evidence } = validateReviewCandidate(candidate, result);
        result.set(file, normalizeCandidateEvidence(file, evidence));
    }
    return result;
}

/**
 * @param {unknown} candidate
 * @param {ReadonlyMap<string, unknown>} existing
 */
function validateReviewCandidate(candidate, existing) {
    if (
        !candidate ||
        typeof candidate !== "object" ||
        !("file" in candidate) ||
        typeof candidate.file !== "string" ||
        !("evidence" in candidate) ||
        !Array.isArray(candidate.evidence)
    ) {
        throw new Error("Reviewed content candidate is malformed.");
    }
    assertSafeFileName(candidate.file);
    if (existing.has(candidate.file)) {
        throw new Error(`Reviewed content report repeats ${candidate.file}.`);
    }
    return { file: candidate.file, evidence: candidate.evidence };
}

/**
 * @param {unknown} value
 */
function isSha256(value) {
    return typeof value === "string" && /^[a-f\d]{64}$/u.test(value);
}

/**
 * @param {Record<string, unknown>} evidence
 * @param {boolean} isBlankColumns
 */
function isValidReviewedEvidence(evidence, isBlankColumns) {
    const action = evidence.action;
    const validAction =
        action == null ||
        action === "blank-columns" ||
        action === "blank-text" ||
        action === "remove-row";
    const hasIdentity =
        typeof evidence.text === "string" || isSha256(evidence.sha256);
    const validAllowedOccurrences =
        evidence.allowedRemainingOccurrences == null ||
        (Number.isSafeInteger(evidence.allowedRemainingOccurrences) &&
            Number(evidence.allowedRemainingOccurrences) >= 0);
    const validColumnEvidence = isBlankColumns
        ? isSha256(evidence.expectedRawSha256) &&
          isSha256(evidence.expectedRenderedSha256)
        : evidence.columnRanges == null &&
          evidence.expectedRawSha256 == null &&
          evidence.expectedRenderedSha256 == null;
    return (
        Number.isInteger(evidence.row) &&
        Number(evidence.row) >= 1 &&
        hasIdentity &&
        validAction &&
        validAllowedOccurrences &&
        validColumnEvidence
    );
}

/**
 * @param {string} file
 * @param {Record<string, unknown>} evidence
 */
function normalizeReviewedEvidence(file, evidence) {
    const isBlankColumns =
        (evidence.action || "blank-text") === "blank-columns";
    if (!isValidReviewedEvidence(evidence, isBlankColumns)) {
        throw new Error(`${file}: reviewed row evidence is malformed.`);
    }
    let columnRanges;
    if (isBlankColumns) {
        try {
            columnRanges = validateColumnRanges(evidence.columnRanges);
        } catch (error) {
            throw new Error(`${file}: reviewed row evidence is malformed.`, {
                cause: error,
            });
        }
    }
    /** @type {Record<string, unknown>} */
    const normalized = {};
    for (const property of [
        "action",
        "allowedRemainingOccurrences",
        "expectedRawSha256",
        "expectedRenderedSha256",
        "sha256",
        "text",
    ]) {
        if (evidence[property] != null)
            normalized[property] = evidence[property];
    }
    if (columnRanges != null) normalized.columnRanges = columnRanges;
    return { row: Number(evidence.row), normalized };
}

/**
 * @param {string} file
 * @param {unknown[]} evidenceItems
 */
function normalizeCandidateEvidence(file, evidenceItems) {
    const rows = new Map();
    for (const evidence of evidenceItems) {
        if (!evidence || typeof evidence !== "object") {
            throw new Error(`${file}: reviewed row evidence is malformed.`);
        }
        const evidenceRecord = /** @type {Record<string, unknown>} */ (
            evidence
        );
        const { row, normalized } = normalizeReviewedEvidence(
            file,
            evidenceRecord
        );
        const existing = rows.get(row);
        if (
            existing != null &&
            JSON.stringify(existing) !== JSON.stringify(normalized)
        ) {
            throw new Error(`${file}: row ${row} has conflicting evidence.`);
        }
        rows.set(row, normalized);
    }
    return [...rows]
        .sort(([left], [right]) => left - right)
        .map(([row, evidence]) => ({ row, ...evidence }));
}

function createDefaultOptions() {
    return {
        baselineDirectory: null,
        leadingOnly: false,
        output: path.join(
            REPOSITORY_ROOT,
            "temp",
            "ansi-content-audit",
            "content-review-application.json"
        ),
        reviewPath: null,
        scriptsDirectory: DEFAULT_SCRIPTS_DIRECTORY,
        write: false,
    };
}

/**
 * @param {ReturnType<typeof createDefaultOptions>} options
 * @param {string} argument
 */
function applyCommandLineOption(options, argument) {
    if (argument === "--write") {
        options.write = true;
        return;
    }
    if (argument === "--leading-only") {
        options.leadingOnly = true;
        return;
    }
    if (argument === "--help") {
        console.log(`Usage: node scripts/Apply-ColorScriptContentReview.js [options]

Options:
  --review=<path>        Reviewed row-evidence report to apply
  --baseline-dir=<path>  Pre-curation Scripts directory for blank-hole repair
  --scripts-dir=<path>   Target Scripts directory
  --output=<path>        JSON application report
  --leading-only         Trim only extreme leading runs expanded by curation
  --write                Apply validated changes (default is a dry run)
  --help                 Show this help`);
        process.exit(0);
    }
    const optionMatch = /^--([^=]+)=(.*)$/u.exec(argument);
    if (!optionMatch) throw new Error(`Unknown option: ${argument}`);
    const [
        ,
        optionName,
        optionValue,
    ] = optionMatch;
    switch (optionName) {
        case "baseline-dir":
            options.baselineDirectory = path.resolve(
                REPOSITORY_ROOT,
                optionValue
            );
            return;
        case "review":
            options.reviewPath = path.resolve(REPOSITORY_ROOT, optionValue);
            return;
        case "scripts-dir":
            options.scriptsDirectory = path.resolve(
                REPOSITORY_ROOT,
                optionValue
            );
            return;
        case "output":
            options.output = path.resolve(REPOSITORY_ROOT, optionValue);
            return;
        default:
            throw new Error(`Unknown option: ${argument}`);
    }
}

/**
 * @param {string[]} arguments_
 *
 * @returns {ReturnType<typeof createDefaultOptions>}
 */
function parseArguments(arguments_) {
    const options = createDefaultOptions();
    for (const argument of arguments_) {
        applyCommandLineOption(options, argument);
    }
    if (!options.reviewPath && !options.baselineDirectory) {
        throw new Error("Provide --review, --baseline-dir, or both.");
    }
    if (options.leadingOnly && !options.baselineDirectory) {
        throw new Error("--leading-only requires --baseline-dir.");
    }
    if (options.leadingOnly && options.reviewPath) {
        throw new Error("--leading-only cannot be combined with --review.");
    }
    return options;
}

/**
 * @param {ReturnType<typeof parseArguments>} options
 * @param {ReturnType<typeof loadReview>} review
 *
 * @returns {Set<string>}
 */
function collectTargetFiles(options, review) {
    const files = new Set(review.keys());
    if (!options.baselineDirectory) return files;
    for (const entry of fs.readdirSync(options.scriptsDirectory, {
        withFileTypes: true,
    })) {
        const hasBaseline = fs.existsSync(
            path.join(options.baselineDirectory, entry.name)
        );
        if (
            entry.isFile() &&
            entry.name.toLocaleLowerCase("en-US").endsWith(".ps1") &&
            hasBaseline
        ) {
            files.add(entry.name);
        }
    }
    return files;
}

/**
 * @param {string} source
 */
function createCurationState(source) {
    return {
        source,
        payloadChanged: false,
        blankedRows: 0,
        compactedRows: 0,
        leadingRows: 0,
        reviewRemovedRows: 0,
        trailingRows: 0,
    };
}

/**
 * @param {ReturnType<typeof createCurationState>} state
 * @param {string} fileName
 * @param {ReturnType<typeof loadReview> extends Map<string, infer T> ? T : never} evidence
 */
function applyFileReview(state, fileName, evidence) {
    try {
        const result = applyReviewedRows(state.source, evidence);
        state.source = result.source;
        state.blankedRows += result.blankedRows;
        state.reviewRemovedRows += result.removedRows;
        state.payloadChanged ||= result.changed;
    } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        throw new Error(`${fileName}: ${message}`, { cause: error });
    }
}

/**
 * @param {ReturnType<typeof createCurationState>} state
 * @param {string} fileName
 * @param {ReturnType<typeof parseArguments>} options
 * @param {object[]} failures
 */
function applyBaselineCuration(state, fileName, options, failures) {
    if (!options.baselineDirectory) return;
    const baselinePath = path.join(options.baselineDirectory, fileName);
    if (!fs.existsSync(baselinePath)) return;
    const baselineSource = readBoundedSource(baselinePath);
    try {
        if (options.leadingOnly) {
            const result = trimExpandedLeadingBlankRows(
                state.source,
                baselineSource
            );
            state.source = result.source;
            state.leadingRows += result.removedRows;
            state.payloadChanged ||= result.changed;
            return;
        }
        if (!mayContainNewBlankRows(state.source, baselineSource)) return;
        const result = compactBlankRowsIntroducedSince(
            state.source,
            baselineSource
        );
        state.source = result.source;
        state.compactedRows += result.removedRows;
        state.payloadChanged ||= result.changed;
    } catch (error) {
        failures.push({
            error: error instanceof Error ? error.message : String(error),
            file: fileName,
            operation: "compact-baseline",
        });
    }
}

/**
 * @param {ReturnType<typeof createCurationState>} state
 * @param {string} fileName
 * @param {boolean} leadingOnly
 * @param {object[]} failures
 */
function applyTrailingCuration(state, fileName, leadingOnly, failures) {
    if (leadingOnly) return;
    try {
        const result = removeTrailingBlankRows(state.source);
        state.source = result.source;
        state.trailingRows += result.removedRows;
        state.payloadChanged ||= result.changed;
    } catch (error) {
        failures.push({
            error: error instanceof Error ? error.message : String(error),
            file: fileName,
            operation: "trim-trailing",
        });
    }
}

/**
 * @param {string} fileName
 * @param {ReturnType<typeof parseArguments>} options
 * @param {ReturnType<typeof loadReview>} review
 * @param {object[]} failures
 */
function curateFile(fileName, options, review, failures) {
    assertSafeFileName(fileName);
    const filePath = path.join(options.scriptsDirectory, fileName);
    if (!fs.existsSync(filePath)) {
        throw new Error(`${fileName}: reviewed target is missing.`);
    }
    const originalSource = readBoundedSource(filePath);
    const evidence = review.get(fileName);
    if (isSourceFidelityLocked(originalSource)) {
        if (evidence) {
            throw new Error(
                `${fileName}: source-fidelity-locked payload cannot be curated.`
            );
        }
        return { record: null, reviewed: false };
    }
    const state = createCurationState(originalSource);
    if (evidence) applyFileReview(state, fileName, evidence);
    applyBaselineCuration(state, fileName, options, failures);
    applyTrailingCuration(state, fileName, options.leadingOnly, failures);
    if (state.payloadChanged) state.source = documentCuration(state.source);
    if (state.source === originalSource) {
        return { record: null, reviewed: Boolean(evidence) };
    }
    if (options.write) writeFileAtomic(filePath, state.source);
    return {
        record: {
            blankedRows: state.blankedRows,
            compactedRows: state.compactedRows,
            file: fileName,
            leadingRows: state.leadingRows,
            reviewRemovedRows: state.reviewRemovedRows,
            trailingRows: state.trailingRows,
        },
        reviewed: Boolean(evidence),
    };
}

/**
 * @param {string[]} arguments_
 *
 * @returns {void}
 */
function main(arguments_ = process.argv.slice(2)) {
    const options = parseArguments(arguments_);
    /** @type {ReturnType<typeof loadReview>} */
    const review = options.reviewPath
        ? loadReview(options.reviewPath)
        : new Map();
    const files = collectTargetFiles(options, review);
    const records = [];
    /** @type {{ error: string; file: string; operation: string }[]} */
    const failures = [];
    const totals = createCurationState("");
    let reviewedFiles = 0;
    for (const fileName of [...files].sort((left, right) =>
        left.localeCompare(right, "en-US")
    )) {
        const result = curateFile(fileName, options, review, failures);
        if (result.reviewed) reviewedFiles += 1;
        if (!result.record) continue;
        records.push(result.record);
        totals.blankedRows += result.record.blankedRows;
        totals.compactedRows += result.record.compactedRows;
        totals.leadingRows += result.record.leadingRows;
        totals.reviewRemovedRows += result.record.reviewRemovedRows;
        totals.trailingRows += result.record.trailingRows;
    }

    const report = {
        failures,
        generatedAt: new Date().toISOString(),
        records,
        summary: {
            blankedRows: totals.blankedRows,
            changedFiles: records.length,
            compactedRows: totals.compactedRows,
            failures: failures.length,
            leadingRows: totals.leadingRows,
            reviewRemovedRows: totals.reviewRemovedRows,
            reviewedFiles,
            trailingRows: totals.trailingRows,
            write: options.write,
        },
    };
    fs.mkdirSync(path.dirname(options.output), { recursive: true });
    writeFileAtomic(options.output, `${JSON.stringify(report, null, 2)}\n`);
    console.log(JSON.stringify(report.summary, null, 2));
    console.log(`Report: ${options.output}`);
}

if (require.main === module) {
    main();
}

module.exports = {
    assertSafeFileName,
    loadReview,
    main,
    mayContainNewBlankRows,
    parseArguments,
};
