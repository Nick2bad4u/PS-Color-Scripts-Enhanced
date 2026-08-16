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
        if (
            !candidate ||
            typeof candidate.file !== "string" ||
            !Array.isArray(candidate.evidence)
        ) {
            throw new Error("Reviewed content candidate is malformed.");
        }
        assertSafeFileName(candidate.file);
        if (result.has(candidate.file)) {
            throw new Error(
                `Reviewed content report repeats ${candidate.file}.`
            );
        }
        const rows = new Map();
        for (const evidence of candidate.evidence) {
            const action = evidence?.action || "blank-text";
            const isBlankColumns = action === "blank-columns";
            if (
                !evidence ||
                !Number.isInteger(evidence.row) ||
                evidence.row < 1 ||
                (typeof evidence.text !== "string" &&
                    (typeof evidence.sha256 !== "string" ||
                        !/^[a-f\d]{64}$/u.test(evidence.sha256))) ||
                (evidence.action != null &&
                    evidence.action !== "blank-columns" &&
                    evidence.action !== "blank-text" &&
                    evidence.action !== "remove-row") ||
                (isBlankColumns &&
                    (typeof evidence.expectedRawSha256 !== "string" ||
                        !/^[a-f\d]{64}$/u.test(evidence.expectedRawSha256) ||
                        typeof evidence.expectedRenderedSha256 !== "string" ||
                        !/^[a-f\d]{64}$/u.test(
                            evidence.expectedRenderedSha256
                        ))) ||
                (!isBlankColumns &&
                    (evidence.columnRanges != null ||
                        evidence.expectedRawSha256 != null ||
                        evidence.expectedRenderedSha256 != null)) ||
                (evidence.allowedRemainingOccurrences != null &&
                    (!Number.isSafeInteger(
                        evidence.allowedRemainingOccurrences
                    ) ||
                        evidence.allowedRemainingOccurrences < 0))
            ) {
                throw new Error(
                    `${candidate.file}: reviewed row evidence is malformed.`
                );
            }
            let columnRanges;
            if (isBlankColumns) {
                try {
                    columnRanges = validateColumnRanges(evidence.columnRanges);
                } catch (error) {
                    throw new Error(
                        `${candidate.file}: reviewed row evidence is malformed.`,
                        { cause: error }
                    );
                }
            }
            const normalized = {
                ...(typeof evidence.action === "string"
                    ? { action: evidence.action }
                    : {}),
                ...(typeof evidence.allowedRemainingOccurrences === "number"
                    ? {
                          allowedRemainingOccurrences:
                              evidence.allowedRemainingOccurrences,
                      }
                    : {}),
                ...(typeof evidence.sha256 === "string"
                    ? { sha256: evidence.sha256 }
                    : {}),
                ...(columnRanges == null ? {} : { columnRanges }),
                ...(typeof evidence.expectedRawSha256 === "string"
                    ? {
                          expectedRawSha256: evidence.expectedRawSha256,
                      }
                    : {}),
                ...(typeof evidence.expectedRenderedSha256 === "string"
                    ? {
                          expectedRenderedSha256:
                              evidence.expectedRenderedSha256,
                      }
                    : {}),
                ...(typeof evidence.text === "string"
                    ? { text: evidence.text }
                    : {}),
            };
            const existing = rows.get(evidence.row);
            if (
                existing != null &&
                JSON.stringify(existing) !== JSON.stringify(normalized)
            ) {
                throw new Error(
                    `${candidate.file}: row ${evidence.row} has conflicting evidence.`
                );
            }
            rows.set(evidence.row, normalized);
        }
        result.set(
            candidate.file,
            [...rows]
                .sort(([left], [right]) => left - right)
                .map(([row, evidence]) => ({ row, ...evidence }))
        );
    }
    return result;
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
 * @param {string[]} arguments_
 *
 * @returns {void}
 */
function main(arguments_ = process.argv.slice(2)) {
    const options = parseArguments(arguments_);
    const review = options.reviewPath
        ? loadReview(options.reviewPath)
        : new Map();
    const files = new Set(review.keys());
    if (options.baselineDirectory) {
        for (const entry of fs.readdirSync(options.scriptsDirectory, {
            withFileTypes: true,
        })) {
            if (
                entry.isFile() &&
                entry.name.toLocaleLowerCase("en-US").endsWith(".ps1") &&
                fs.existsSync(path.join(options.baselineDirectory, entry.name))
            ) {
                files.add(entry.name);
            }
        }
    }

    const records = [];
    const failures = [];
    let blankedRows = 0;
    let compactedRows = 0;
    let leadingRows = 0;
    let reviewRemovedRows = 0;
    let reviewedFiles = 0;
    let trailingRows = 0;
    for (const fileName of [...files].sort((left, right) =>
        left.localeCompare(right, "en-US")
    )) {
        assertSafeFileName(fileName);
        const filePath = path.join(options.scriptsDirectory, fileName);
        if (!fs.existsSync(filePath)) {
            throw new Error(`${fileName}: reviewed target is missing.`);
        }
        const originalSource = readBoundedSource(filePath);
        if (isSourceFidelityLocked(originalSource)) {
            if (review.has(fileName)) {
                throw new Error(
                    `${fileName}: source-fidelity-locked payload cannot be curated.`
                );
            }
            continue;
        }
        let source = originalSource;
        let fileBlankedRows = 0;
        let fileCompactedRows = 0;
        let fileLeadingRows = 0;
        let fileReviewRemovedRows = 0;
        let fileTrailingRows = 0;
        let payloadChanged = false;

        const evidence = review.get(fileName);
        if (evidence) {
            let result;
            try {
                result = applyReviewedRows(source, evidence);
            } catch (error) {
                const message =
                    error instanceof Error ? error.message : String(error);
                throw new Error(`${fileName}: ${message}`, {
                    cause: error,
                });
            }
            source = result.source;
            fileBlankedRows += result.blankedRows;
            fileReviewRemovedRows += result.removedRows;
            payloadChanged ||= result.changed;
            reviewedFiles += 1;
        }

        if (options.baselineDirectory) {
            const baselinePath = path.join(options.baselineDirectory, fileName);
            if (fs.existsSync(baselinePath)) {
                const baselineSource = readBoundedSource(baselinePath);
                try {
                    if (options.leadingOnly) {
                        const result = trimExpandedLeadingBlankRows(
                            source,
                            baselineSource
                        );
                        source = result.source;
                        fileLeadingRows += result.removedRows;
                        payloadChanged ||= result.changed;
                    } else if (mayContainNewBlankRows(source, baselineSource)) {
                        const result = compactBlankRowsIntroducedSince(
                            source,
                            baselineSource
                        );
                        source = result.source;
                        fileCompactedRows += result.removedRows;
                        payloadChanged ||= result.changed;
                    }
                } catch (error) {
                    failures.push({
                        error:
                            error instanceof Error
                                ? error.message
                                : String(error),
                        file: fileName,
                        operation: "compact-baseline",
                    });
                }
            }
        }

        if (!options.leadingOnly) {
            try {
                const trailingResult = removeTrailingBlankRows(source);
                source = trailingResult.source;
                fileTrailingRows += trailingResult.removedRows;
                payloadChanged ||= trailingResult.changed;
            } catch (error) {
                failures.push({
                    error:
                        error instanceof Error ? error.message : String(error),
                    file: fileName,
                    operation: "trim-trailing",
                });
            }
        }

        if (payloadChanged) {
            source = documentCuration(source);
        }
        if (source !== originalSource) {
            if (options.write) {
                writeFileAtomic(filePath, source);
            }
            blankedRows += fileBlankedRows;
            compactedRows += fileCompactedRows;
            leadingRows += fileLeadingRows;
            reviewRemovedRows += fileReviewRemovedRows;
            trailingRows += fileTrailingRows;
            records.push({
                blankedRows: fileBlankedRows,
                compactedRows: fileCompactedRows,
                file: fileName,
                leadingRows: fileLeadingRows,
                reviewRemovedRows: fileReviewRemovedRows,
                trailingRows: fileTrailingRows,
            });
        }
    }

    const report = {
        failures,
        generatedAt: new Date().toISOString(),
        records,
        summary: {
            blankedRows,
            changedFiles: records.length,
            compactedRows,
            failures: failures.length,
            leadingRows,
            reviewRemovedRows,
            reviewedFiles,
            trailingRows,
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
