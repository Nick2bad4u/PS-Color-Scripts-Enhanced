#!/usr/bin/env node
"use strict";
// @ts-check

const childProcess = require("node:child_process");
const crypto = require("node:crypto");
const fs = require("node:fs");
const path = require("node:path");
const {
    extractPowerShellPayload,
    getRenderedBlankRows,
    isSourceFidelityLocked,
    replacePayloadRows,
    stripAnsiControls,
} = require("./Audit-ColorScriptContent.js");
const { assertSafeFileName } = require("./Apply-ColorScriptContentReview.js");
const {
    DEFAULT_PROVENANCE_PATH,
    parseLeadingCommentHeader,
    readArtworkProvenance,
    sha256,
    updateArtworkProvenanceScriptProperties,
} = require("./ArtworkProvenance.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const DEFAULT_SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);
const HEADER_MIGRATION_PATH = path.join(
    REPOSITORY_ROOT,
    "audit",
    "ArtworkHeaderMigration.json"
);
const DEFAULT_BASELINE_COMMIT = "0cac422b";
const DEFAULT_MAXIMUM_ROWS = 50;
const MAX_SCRIPT_BYTES = 16 * 1024 * 1024;
const HASH_PATTERN = /^[a-f\d]{64}$/u;
const COMMIT_PATTERN = /^[a-f\d]{7,40}$/u;
const PART_NAME_PATTERN = /^(?<family>.+)-part(?<part>\d+)\.ps1$/u;
const SOURCE_ROWS_PATTERN = /^# Lines:\s*(\d+)-(\d+)\s*$/gmu;
const SGR_PATTERN = /\u001b\[([\d;]*)m/gu;
const REBALANCE_ACTIONS = new Set([
    "merge-negligible-part-with-adjacent-part",
    "re-split-family-at-source-row-boundaries",
    "re-split-family-preserving-tail-cells",
]);

/**
 * @typedef {{ end: number; start: number }} SourceRange
 */

/**
 * @typedef {{
 *     baselineEnd: number;
 *     baselineStart: number;
 *     exactRows: number;
 *     normalizedRows: number;
 *     renderedBlankRows: number;
 * }} BaselineAlignment
 */

/**
 * @typedef {{
 *     action: string;
 *     script: string;
 *     signal: string;
 * }} ReviewFinding
 */

/**
 * @typedef {{
 *     alignment: BaselineAlignment;
 *     baselinePayloadRows: number;
 *     currentPayloadRows: number;
 *     expectedBaselineFileSha256: string;
 *     expectedCurrentFileSha256: string;
 *     expectedCurrentPayloadSha256: string;
 *     expectedCurrentRowsSha256: string;
 *     excludedPresentationRows: number;
 *     file: string;
 *     relativePath: string;
 *     sourceRows: SourceRange;
 * }} ManifestInput
 */

/**
 * @typedef {{
 *     endRowExclusive: number;
 *     expectedRawRowsSha256: string;
 *     file: string;
 *     rowCount: number;
 *     sourceRows: SourceRange;
 *     startRow: number;
 *     visibleRowCount: number;
 * }} ManifestOutput
 */

/**
 * @typedef {{
 *     expectedFamilyRowsSha256: string;
 *     expectedMappedFamilyRowsSha256: string;
 *     family: string;
 *     fixedPartCount: number;
 *     inputs: ManifestInput[];
 *     mappedRowCount: number;
 *     maximumRows: number;
 *     outputs: ManifestOutput[];
 *     outerTrim: {
 *         expectedLeadingRowsSha256: string;
 *         expectedTrailingRowsSha256: string;
 *         leadingRows: number;
 *         trailingRows: number;
 *     };
 *     retainedRowCount: number;
 *     reviewFindings: ReviewFinding[];
 *     sourceRows: SourceRange;
 * }} ManifestFamily
 */

/**
 * @typedef {{
 *     baselineCommit: string;
 *     classificationSha256: string | null;
 *     families: ManifestFamily[];
 *     generatedAt: string;
 *     invariants: {
 *         exactlyOneOutputPresentationRow: boolean;
 *         excludeGeneratedPresentationRows: boolean;
 *         fixedPartCount: boolean;
 *         maximumRowsDefault: number;
 *         preserveNonblankRows: boolean;
 *         preserveRetainedRawRows: boolean;
 *         sourceFidelityLocksFailClosed: boolean;
 *         trimRenderedBlankOuterRowsOnly: boolean;
 *         visibleRowsPerOutput: boolean;
 *     };
 *     schemaVersion: number;
 *     summary: {
 *         excludedPresentationRows: number;
 *         families: number;
 *         inputs: number;
 *         outputs: number;
 *         retainedRows: number;
 *         reviewFindings: number;
 *         trimmedLeadingRows: number;
 *         trimmedTrailingRows: number;
 *     };
 * }} RebalanceManifest
 */

/**
 * @typedef {{
 *     disposition?: unknown;
 *     passthrough?: unknown;
 *     recommendedAction?: unknown;
 *     script?: unknown;
 *     type?: unknown;
 * }} ClassificationFinding
 */

/**
 * @typedef {{ findings: ClassificationFinding[] }} ClassificationDocument
 */

/**
 * @typedef {{
 *     file: string;
 *     internalResetIndexes: number[];
 *     prefix: string;
 *     presentationRows: 1;
 *     rawRowsSha256: string;
 *     source: string;
 *     sourceRows: SourceRange;
 *     suffix: string;
 * }} PlannedFile
 */

/**
 * @typedef {{
 *     changedFiles: number;
 *     families: { family: string; files: PlannedFile[] }[];
 *     retainedRows: number;
 * }} RebalancePlan
 */

/**
 * @typedef {{
 *     baselineCommit: string;
 *     classificationPath: string | null;
 *     manifestPath: string | null;
 *     outputPath: string | null;
 *     scriptsDirectory: string;
 *     write: boolean;
 * }} CommandLineOptions
 */

/**
 * @param {Buffer | string} value
 *
 * @returns {string}
 */
function getSha256(value) {
    return crypto.createHash("sha256").update(value).digest("hex");
}

/**
 * Hash logical rows without relying on a separator that could appear in ANSI
 * art itself.
 *
 * @param {string[]} rows
 *
 * @returns {string}
 */
function getRowsSha256(rows) {
    return getSha256(JSON.stringify(rows));
}

/**
 * @param {string} value
 *
 * @returns {string[]}
 */
function getPayloadRows(value) {
    return value.replace(/\r\n?/gu, "\n").split("\n");
}

/**
 * @param {string} filePath
 *
 * @returns {Buffer}
 */
function readRegularFile(filePath) {
    const stat = fs.lstatSync(filePath);
    if (
        !stat.isFile() ||
        stat.isSymbolicLink() ||
        stat.size > MAX_SCRIPT_BYTES
    ) {
        throw new Error(
            `${path.basename(filePath)}: expected a regular colorscript no larger than ${MAX_SCRIPT_BYTES} bytes.`
        );
    }
    return fs.readFileSync(filePath);
}

/**
 * @param {string} source
 *
 * @returns {SourceRange}
 */
function parseSourceRows(source) {
    const matches = [...source.matchAll(SOURCE_ROWS_PATTERN)];
    if (matches.length !== 1) {
        throw new Error(
            "A split colorscript must contain exactly one '# Lines: start-end' header."
        );
    }
    const start = Number.parseInt(matches[0][1], 10);
    const end = Number.parseInt(matches[0][2], 10);
    if (
        !Number.isSafeInteger(start) ||
        !Number.isSafeInteger(end) ||
        start < 1 ||
        end < start
    ) {
        throw new Error("The colorscript source-row range is invalid.");
    }
    return { end, start };
}

/**
 * @param {string} source
 * @param {SourceRange} range
 *
 * @returns {string}
 */
function replaceSourceRows(source, range) {
    const matches = [...source.matchAll(SOURCE_ROWS_PATTERN)];
    if (matches.length === 0 && /^\uFEFF?# Artwork: /u.test(source)) {
        return source;
    }
    if (matches.length !== 1) {
        throw new Error(
            "A split colorscript must contain exactly one '# Lines: start-end' header."
        );
    }
    return source.replace(
        SOURCE_ROWS_PATTERN,
        `# Lines: ${range.start}-${range.end}`
    );
}

/**
 * @param {string} value
 *
 * @returns {string}
 */
function escapeRegExp(value) {
    return value.replace(/[.*+?^${}()|[\]\\]/gu, String.raw`\$&`);
}

/**
 * @param {string} fileName
 *
 * @returns {{ family: string; part: number }}
 */
function parsePartName(fileName) {
    assertSafeFileName(fileName);
    const match = PART_NAME_PATTERN.exec(fileName);
    if (!match?.groups) {
        throw new Error(
            `${fileName}: expected a '-partNN.ps1' split-script filename.`
        );
    }
    const part = Number.parseInt(match.groups.part, 10);
    if (!Number.isSafeInteger(part) || part < 1) {
        throw new Error(`${fileName}: invalid part number.`);
    }
    return { family: match.groups.family, part };
}

/**
 * @param {string[]} fileNames
 * @param {string} family
 *
 * @returns {string[]}
 */
function sortAndValidatePartNames(fileNames, family) {
    const records = fileNames
        .map((fileName) => ({
            fileName,
            ...parsePartName(fileName),
        }))
        .sort((left, right) => left.part - right.part);
    for (const [index, record] of records.entries()) {
        if (record.family !== family || record.part !== index + 1) {
            throw new Error(
                `${family}: parts must be a complete, contiguous part01-partNN family.`
            );
        }
    }
    return records.map((record) => record.fileName);
}

/**
 * @param {string[]} baselineRows
 * @param {string[]} currentRows
 * @param {boolean[]} baselineBlank
 * @param {boolean[]} currentBlank
 * @param {number} start
 *
 * @returns {{ candidate: BaselineAlignment; score: number }}
 */
function scoreBaselineWindow(
    baselineRows,
    currentRows,
    baselineBlank,
    currentBlank,
    start
) {
    let exactRows = 0;
    let normalizedRows = 0;
    let renderedBlankRows = 0;
    for (const [index, currentRow] of currentRows.entries()) {
        const baselineIndex = start + index;
        const baselineRow = baselineRows[baselineIndex];
        if (baselineRow === currentRow) {
            exactRows += 1;
        } else if (
            stripAnsiControls(baselineRow) === stripAnsiControls(currentRow)
        ) {
            normalizedRows += 1;
        } else if (baselineBlank[baselineIndex] && currentBlank[index]) {
            renderedBlankRows += 1;
        }
    }
    return {
        candidate: {
            baselineEnd: start + currentRows.length,
            baselineStart: start,
            exactRows,
            normalizedRows,
            renderedBlankRows,
        },
        score: exactRows * 16 + normalizedRows * 4 + renderedBlankRows,
    };
}

/**
 * Find the unique contiguous baseline window that best explains the current
 * curated payload. Exact rows outrank control-normalized rows, which outrank
 * rows that remain rendered blank after curation.
 *
 * @param {string[]} baselineRows
 * @param {string[]} currentRows
 *
 * @returns {BaselineAlignment}
 */
function alignCurrentRowsToBaseline(baselineRows, currentRows) {
    if (currentRows.length < 1 || currentRows.length > baselineRows.length) {
        throw new Error(
            "The current payload is not a non-empty contiguous baseline subsequence."
        );
    }
    const baselineBlank = getRenderedBlankRows(baselineRows);
    const currentBlank = getRenderedBlankRows(currentRows);
    /** @type {BaselineAlignment[]} */
    const candidates = [];
    let bestScore = Number.NEGATIVE_INFINITY;

    for (
        let start = 0;
        start <= baselineRows.length - currentRows.length;
        start += 1
    ) {
        const { candidate, score } = scoreBaselineWindow(
            baselineRows,
            currentRows,
            baselineBlank,
            currentBlank,
            start
        );
        if (score > bestScore) {
            bestScore = score;
            candidates.length = 0;
            candidates.push(candidate);
        } else if (score === bestScore) {
            candidates.push(candidate);
        }
    }

    if (candidates.length !== 1) {
        throw new Error(
            "The current payload has an ambiguous baseline alignment."
        );
    }
    const result = candidates[0];
    const explainedRows =
        result.exactRows + result.normalizedRows + result.renderedBlankRows;
    if (baselineRows.length !== currentRows.length && explainedRows === 0) {
        throw new Error(
            "The current payload cannot be aligned confidently to the baseline."
        );
    }
    return result;
}

/**
 * Map baseline payload indexes onto the source coordinates documented by the
 * pre-curation script. A payload may contain one presentation-only leading row
 * added by buildPowerShellOutput when the source itself began visibly.
 *
 * @param {string[]} baselineRows
 * @param {SourceRange} range
 *
 * @returns {(number | null)[]}
 */
function mapBaselineSourceCoordinates(baselineRows, range) {
    const declaredRows = range.end - range.start + 1;
    let presentationRows = 0;
    if (baselineRows.length === declaredRows + 1) {
        if (!getRenderedBlankRows([baselineRows[0]])[0]) {
            throw new Error(
                "A baseline payload longer than its source range must begin with one rendered-blank presentation row."
            );
        }
        presentationRows = 1;
    } else if (baselineRows.length > declaredRows + 1) {
        throw new Error(
            "The baseline payload exceeds its declared source-row range."
        );
    }
    return baselineRows.map((unusedRow, index) => {
        if (index < presentationRows) {
            return null;
        }
        const coordinate = range.start + index - presentationRows;
        return coordinate <= range.end ? coordinate : null;
    });
}

/**
 * Remove only the generated, source-unmapped presentation row. A null source
 * coordinate is not permission to discard arbitrary content: it must be the
 * single rendered-blank row at the start of an input.
 *
 * @param {string[]} rows
 * @param {(number | null)[]} coordinates
 *
 * @returns {{
 *     coordinates: number[];
 *     excludedRows: number;
 *     originalIndexes: number[];
 *     rows: string[];
 * }}
 */
function excludeGeneratedPresentationRows(rows, coordinates) {
    if (rows.length !== coordinates.length || rows.length < 1) {
        throw new Error(
            "Presentation-row exclusion requires aligned, non-empty rows and coordinates."
        );
    }
    const nullIndexes = coordinates
        .map((coordinate, index) => (coordinate === null ? index : -1))
        .filter((index) => index !== -1);
    if (
        nullIndexes.length > 1 ||
        (nullIndexes.length === 1 && nullIndexes[0] !== 0) ||
        (nullIndexes.length === 1 && !getRenderedBlankRows([rows[0]])[0])
    ) {
        throw new Error(
            "A generated presentation row must be the single rendered-blank, source-unmapped first row."
        );
    }
    const excludedRows = nullIndexes.length;
    const mappedRows = rows.slice(excludedRows);
    const mappedCoordinates = coordinates.slice(excludedRows);
    if (mappedRows.length < 1 || mappedCoordinates.includes(null)) {
        throw new Error(
            "Presentation-row exclusion must retain source-mapped rows."
        );
    }
    return {
        coordinates: /** @type {number[]} */ (mappedCoordinates),
        excludedRows,
        originalIndexes: mappedRows.map(
            (unusedRow, index) => index + excludedRows
        ),
        rows: mappedRows,
    };
}

/**
 * Trim only rendered-blank rows at the two outer family edges. Internal blank
 * runs remain part of the artwork and are handled only as split preferences.
 *
 * @param {string[]} rows
 * @param {number[]} coordinates
 *
 * @returns {{
 *     coordinates: number[];
 *     leadingRows: string[];
 *     rows: string[];
 *     trailingRows: string[];
 * }}
 */
function trimRenderedBlankOuterRows(rows, coordinates) {
    if (rows.length !== coordinates.length || rows.length < 1) {
        throw new Error(
            "Outer trimming requires aligned, non-empty rows and coordinates."
        );
    }
    const blankRows = getRenderedBlankRows(rows);
    const firstVisible = blankRows.findIndex((isBlank) => !isBlank);
    if (firstVisible === -1) {
        throw new Error(
            "A rebalanced family must contain at least one rendered-visible row."
        );
    }
    let lastVisible = blankRows.length - 1;
    while (lastVisible >= firstVisible && blankRows[lastVisible]) {
        lastVisible -= 1;
    }
    return {
        coordinates: coordinates.slice(firstVisible, lastVisible + 1),
        leadingRows: rows.slice(0, firstVisible),
        rows: rows.slice(firstVisible, lastVisible + 1),
        trailingRows: rows.slice(lastVisible + 1),
    };
}

/**
 * @param {string[]} rows
 *
 * @returns {string[]}
 */
function getSgrReplayBeforeRows(rows) {
    const replayBefore = [];
    let replay = "";
    for (const row of rows) {
        replayBefore.push(replay);
        const controls = [...row.matchAll(SGR_PATTERN)];
        const withoutSgr = row.replace(SGR_PATTERN, "");
        const containsUnsupportedControl = Array.from(withoutSgr).some(
            (character) => {
                const codePoint = character.codePointAt(0);
                return codePoint === 0x1b || codePoint === 0x9b;
            }
        );
        if (containsUnsupportedControl) {
            throw new Error(
                "Rebalancing supports serialized terminal rows containing SGR controls only."
            );
        }
        for (const control of controls) {
            const parameters =
                control[1].length === 0
                    ? [0]
                    : control[1]
                          .split(";")
                          .map((value) =>
                              value.length === 0
                                  ? 0
                                  : Number.parseInt(value, 10)
                          );
            if (
                parameters.some(
                    (value) =>
                        !Number.isSafeInteger(value) || value < 0 || value > 255
                )
            ) {
                throw new Error("Unsupported SGR parameter.");
            }
            if (parameters.includes(0)) {
                replay = control[0];
            } else {
                replay += control[0];
            }
        }
    }
    return replayBefore;
}

/**
 * Add synthetic boundary controls without changing any retained raw row. The
 * caller retains the prefix/suffix lengths so conservation can be audited.
 *
 * @param {string[]} rows
 * @param {string} replayBeforeFirstRow
 * @param {number[]} [resetBeforeIndexes] Zero-based indexes within rows.
 *
 * @returns {{
 *     internalResetIndexes: number[];
 *     prefix: string;
 *     rows: string[];
 *     suffix: string;
 * }}
 */
function applyBoundaryControls(
    rows,
    replayBeforeFirstRow,
    resetBeforeIndexes = []
) {
    if (rows.length < 1) {
        throw new Error("Cannot serialize an empty output part.");
    }
    const uniqueResetIndexes = [...new Set(resetBeforeIndexes)].sort(
        (left, right) => left - right
    );
    if (
        uniqueResetIndexes.length !== resetBeforeIndexes.length ||
        uniqueResetIndexes.some(
            (index) =>
                !Number.isSafeInteger(index) ||
                index < 1 ||
                index >= rows.length
        )
    ) {
        throw new Error(
            "Internal reset indexes must be unique rows after the output start."
        );
    }
    const prefix = `\u001b[0m${replayBeforeFirstRow}`;
    const suffix = "\u001b[0m";
    const outputRows = [...rows];
    outputRows[0] = prefix + outputRows[0];
    for (const index of uniqueResetIndexes) {
        outputRows[index] = `\u001b[0m${outputRows[index]}`;
    }
    outputRows[outputRows.length - 1] += suffix;
    return {
        internalResetIndexes: uniqueResetIndexes,
        prefix,
        rows: outputRows,
        suffix,
    };
}

/**
 * @typedef {{
 *     balanceCost: number;
 *     boundaryPenalty: number;
 *     breaks: number[];
 *     leadingBlankRows: number;
 *     severeLeadingBlankRows: number;
 *     severeLeadingSegments: number;
 *     visibleBalanceCost: number;
 * }} BreakCandidate
 */

/**
 * @param {BreakCandidate} left
 * @param {BreakCandidate} right
 *
 * @returns {number}
 */
function compareBreakCandidates(left, right) {
    const costs = [
        left.severeLeadingSegments - right.severeLeadingSegments,
        left.severeLeadingBlankRows - right.severeLeadingBlankRows,
        left.visibleBalanceCost - right.visibleBalanceCost,
        left.balanceCost - right.balanceCost,
        left.boundaryPenalty - right.boundaryPenalty,
        left.leadingBlankRows - right.leadingBlankRows,
    ];
    const costDifference = costs.find((difference) => difference !== 0);
    if (costDifference !== undefined) return costDifference;
    for (let index = 0; index < left.breaks.length; index += 1) {
        const difference = left.breaks[index] - right.breaks[index];
        if (difference !== 0) return difference;
    }
    return 0;
}

/**
 * @param {boolean[]} blankRows
 *
 * @returns {number[]}
 */
function buildVisibleRowPrefix(blankRows) {
    const prefix = [0];
    for (const isBlank of blankRows) {
        prefix.push(/** @type {number} */ (prefix.at(-1)) + (isBlank ? 0 : 1));
    }
    return prefix;
}

/**
 * @param {boolean[]} blankRows
 * @param {number} start
 * @param {number} end
 *
 * @returns {number}
 */
function countLeadingBlankRows(blankRows, start, end) {
    let count = 0;
    while (start + count < end && blankRows[start + count]) count += 1;
    return count;
}

/**
 * @param {boolean[]} blankRows
 * @param {number} end
 * @param {boolean} isFinal
 *
 * @returns {number}
 */
function getSplitBoundaryPenalty(blankRows, end, isFinal) {
    if (isFinal || blankRows[end - 1]) return 0;
    return blankRows[end] ? 2 : 1;
}

/**
 * @param {BreakCandidate} state
 * @param {number} start
 * @param {number} end
 * @param {{
 *     blankRows: boolean[];
 *     partCount: number;
 *     rowCount: number;
 *     totalVisibleRows: number;
 *     visiblePrefix: number[];
 *     isFinal: boolean;
 * }} context
 *
 * @returns {BreakCandidate | null}
 */
function createFixedBreakCandidate(state, start, end, context) {
    const visibleRows =
        context.visiblePrefix[end] - context.visiblePrefix[start];
    if (visibleRows < 1) return null;
    const length = end - start;
    const leadingBlankRows = countLeadingBlankRows(
        context.blankRows,
        start,
        end
    );
    const severe =
        leadingBlankRows >= 15 ||
        (leadingBlankRows >= 3 && leadingBlankRows / length >= 0.5);
    return {
        balanceCost:
            state.balanceCost +
            (length * context.partCount - context.rowCount) ** 2,
        boundaryPenalty:
            state.boundaryPenalty +
            getSplitBoundaryPenalty(context.blankRows, end, context.isFinal),
        breaks: [...state.breaks, end],
        leadingBlankRows: state.leadingBlankRows + leadingBlankRows,
        severeLeadingBlankRows:
            state.severeLeadingBlankRows + (severe ? leadingBlankRows : 0),
        severeLeadingSegments: state.severeLeadingSegments + (severe ? 1 : 0),
        visibleBalanceCost:
            state.visibleBalanceCost +
            (visibleRows * context.partCount - context.totalVisibleRows) ** 2,
    };
}

/**
 * @param {Map<number, BreakCandidate>} nextStates
 * @param {number} start
 * @param {BreakCandidate} state
 * @param {number} remainingParts
 * @param {number} maximumRows
 * @param {Parameters<typeof createFixedBreakCandidate>[3]} context
 */
function addFixedBreakTransitions(
    nextStates,
    start,
    state,
    remainingParts,
    maximumRows,
    context
) {
    const maximumEnd = Math.min(
        start + maximumRows,
        context.rowCount - remainingParts
    );
    for (let end = start + 1; end <= maximumEnd; end += 1) {
        if (context.rowCount - end > remainingParts * maximumRows) continue;
        const candidate = createFixedBreakCandidate(state, start, end, context);
        if (!candidate) continue;
        const existing = nextStates.get(end);
        if (!existing || compareBreakCandidates(candidate, existing) < 0) {
            nextStates.set(end, candidate);
        }
    }
}

/**
 * @param {Map<number, BreakCandidate>} states
 * @param {number} remainingParts
 * @param {number} maximumRows
 * @param {Parameters<typeof createFixedBreakCandidate>[3]} context
 *
 * @returns {Map<number, BreakCandidate>}
 */
function advanceFixedBreakStates(states, remainingParts, maximumRows, context) {
    const nextStates = new Map();
    for (const [start, state] of states) {
        addFixedBreakTransitions(
            nextStates,
            start,
            state,
            remainingParts,
            maximumRows,
            context
        );
    }
    return nextStates;
}

/**
 * Choose exactly the requested number of bounded, rendered-visible parts.
 * Candidate plans are compared lexicographically: reject severe leading blank
 * runs first, balance visible rows and total rows next, then prefer cuts at the
 * end of blank runs. A generic "no leading blanks" objective is intentionally
 * not dominant: it can otherwise manufacture tiny, low-content parts merely to
 * make the following part start on a visible row.
 *
 * @param {string[]} rows
 * @param {number} partCount
 * @param {number} maximumRows
 *
 * @returns {number[]} Exclusive break indexes, including the final row count.
 */
function chooseFixedPartBreaks(rows, partCount, maximumRows) {
    if (
        !Array.isArray(rows) ||
        !Number.isSafeInteger(partCount) ||
        !Number.isSafeInteger(maximumRows) ||
        rows.length < partCount ||
        partCount < 1 ||
        maximumRows < 1 ||
        rows.length > partCount * maximumRows
    ) {
        throw new RangeError(
            "Fixed rebalancing requires enough capacity for non-empty parts."
        );
    }
    if (partCount === 1) {
        return [rows.length];
    }
    const blankRows = getRenderedBlankRows(rows);
    if (blankRows.filter((isBlank) => !isBlank).length < partCount) {
        throw new RangeError(
            "Fixed rebalancing requires at least one rendered-visible row per part."
        );
    }
    const visiblePrefix = buildVisibleRowPrefix(blankRows);
    /** @type {Map<number, BreakCandidate>} */
    let states = new Map([
        [
            0,
            {
                balanceCost: 0,
                boundaryPenalty: 0,
                breaks: [],
                leadingBlankRows: 0,
                severeLeadingBlankRows: 0,
                severeLeadingSegments: 0,
                visibleBalanceCost: 0,
            },
        ],
    ]);
    const totalVisibleRows = /** @type {number} */ (visiblePrefix.at(-1));
    for (let part = 1; part <= partCount; part += 1) {
        states = advanceFixedBreakStates(
            states,
            partCount - part,
            maximumRows,
            {
                blankRows,
                partCount,
                rowCount: rows.length,
                totalVisibleRows,
                visiblePrefix,
                isFinal: part === partCount,
            }
        );
    }
    const result = states.get(rows.length);
    if (result?.breaks.length !== partCount) {
        throw new Error("Unable to produce a fixed-count balanced split.");
    }
    return result.breaks;
}

/**
 * @param {(number | null)[]} coordinates
 * @param {SourceRange} familyRange
 */
function validateRetainedSourceCoordinates(coordinates, familyRange) {
    let previousCoordinate = null;
    for (const coordinate of coordinates) {
        if (coordinate === null) continue;
        if (
            !Number.isSafeInteger(coordinate) ||
            coordinate < familyRange.start ||
            coordinate > familyRange.end ||
            (previousCoordinate !== null && coordinate <= previousCoordinate)
        ) {
            throw new Error(
                "Retained source coordinates must be strictly increasing within the family range."
            );
        }
        previousCoordinate = coordinate;
    }
}

/**
 * @param {(number | null)[]} coordinates
 * @param {number} endIndex
 * @param {boolean} isFinal
 * @param {SourceRange} familyRange
 *
 * @returns {number}
 */
function getOutputRangeEnd(coordinates, endIndex, isFinal, familyRange) {
    if (isFinal) return familyRange.end;
    const nextCoordinate = coordinates
        .slice(endIndex)
        .find((coordinate) => coordinate !== null);
    if (nextCoordinate === undefined) {
        throw new Error(
            "A non-final output part has no following source coordinate."
        );
    }
    return nextCoordinate - 1;
}

/**
 * @param {(number | null)[]} coordinates
 * @param {number[]} breaks
 * @param {SourceRange} familyRange
 *
 * @returns {SourceRange[]}
 */
function deriveOutputSourceRanges(coordinates, breaks, familyRange) {
    validateRetainedSourceCoordinates(coordinates, familyRange);
    const ranges = [];
    let startIndex = 0;
    let rangeStart = familyRange.start;
    for (const [partIndex, endIndex] of breaks.entries()) {
        const isFinal = partIndex === breaks.length - 1;
        const slice = coordinates.slice(startIndex, endIndex);
        const actualCoordinates = slice.filter(
            (coordinate) => coordinate !== null
        );
        if (actualCoordinates.length === 0) {
            throw new Error(
                "Every output part must contain at least one source-mapped row."
            );
        }
        const rangeEnd = getOutputRangeEnd(
            coordinates,
            endIndex,
            isFinal,
            familyRange
        );
        if (
            rangeEnd < rangeStart ||
            actualCoordinates.some(
                (coordinate) => coordinate < rangeStart || coordinate > rangeEnd
            )
        ) {
            throw new Error(
                "Output rows cannot be represented by contiguous source-row ranges."
            );
        }
        ranges.push({ end: rangeEnd, start: rangeStart });
        rangeStart = rangeEnd + 1;
        startIndex = endIndex;
    }
    if (rangeStart !== familyRange.end + 1) {
        throw new Error(
            "Output source-row ranges do not conserve the family span."
        );
    }
    return ranges;
}

/**
 * @param {string} commit
 * @param {string} relativePath
 * @param {string} repositoryRoot
 *
 * @returns {Buffer}
 */
function readGitFile(commit, relativePath, repositoryRoot) {
    if (!COMMIT_PATTERN.test(commit)) {
        throw new Error("Baseline commit must be a hexadecimal Git object ID.");
    }
    return childProcess.execFileSync(
        "git",
        [
            "--no-pager",
            "show",
            `${commit}:${relativePath}`,
        ],
        {
            cwd: repositoryRoot,
            encoding: "buffer",
            maxBuffer: 32 * 1024 * 1024,
            windowsHide: true,
        }
    );
}

/**
 * @param {string} family
 * @param {string} scriptsDirectory
 *
 * @returns {string[]}
 */
function discoverFamilyParts(family, scriptsDirectory) {
    const pattern = new RegExp(
        String.raw`^${escapeRegExp(family)}-part\d+\.ps1$`,
        "u"
    );
    const fileNames = fs
        .readdirSync(scriptsDirectory)
        .filter((fileName) => pattern.test(fileName));
    if (fileNames.length < 2) {
        throw new Error(`${family}: expected at least two current parts.`);
    }
    return sortAndValidatePartNames(fileNames, family);
}

/**
 * @param {ClassificationDocument} classification
 *
 * @returns {{
 *     selected: ReviewFinding[];
 *     grouped: Map<string, ReviewFinding[]>;
 * }}
 */
function selectRebalanceFindings(classification) {
    if (
        !classification ||
        typeof classification !== "object" ||
        !Array.isArray(classification?.findings)
    ) {
        throw new Error("Classification input must contain a findings array.");
    }
    const selected = classification.findings.filter(
        (finding) =>
            finding &&
            typeof finding === "object" &&
            typeof finding.recommendedAction === "string" &&
            REBALANCE_ACTIONS.has(finding.recommendedAction)
    );
    if (selected.length === 0) {
        throw new Error("Classification contains no rebalancing findings.");
    }
    const grouped = new Map();
    for (const finding of selected) {
        if (
            typeof finding.script !== "string" ||
            typeof finding.recommendedAction !== "string" ||
            typeof finding.type !== "string" ||
            finding.passthrough === true ||
            finding.disposition !== "high-confidence-change"
        ) {
            throw new Error(
                "Every selected rebalancing finding must be a high-confidence, non-passthrough script."
            );
        }
        const parsed = parsePartName(`${finding.script}.ps1`);
        const records = grouped.get(parsed.family) ?? [];
        records.push({
            action: finding.recommendedAction,
            script: finding.script,
            signal: finding.type,
        });
        grouped.set(parsed.family, records);
    }
    return { selected, grouped };
}

/**
 * @param {string} fileName
 * @param {{
 *     baselineCommit: string;
 *     family: string;
 *     precedingRange: SourceRange | null;
 *     readBaselineFile: (commit: string, relativePath: string) => Buffer;
 *     repositoryRoot: string;
 *     scriptsDirectory: string;
 * }} context
 */
function buildManifestInput(fileName, context) {
    const filePath = path.join(context.scriptsDirectory, fileName);
    const currentBuffer = readRegularFile(filePath);
    const currentSource = currentBuffer.toString("utf8");
    if (isSourceFidelityLocked(currentSource)) {
        throw new Error(
            `${fileName}: source-fidelity-locked payload cannot be rebalanced.`
        );
    }
    const relativePath = path
        .relative(context.repositoryRoot, filePath)
        .replaceAll(path.sep, "/");
    if (relativePath.startsWith("../") || path.isAbsolute(relativePath)) {
        throw new Error(
            `${fileName}: scripts directory must be inside the repository.`
        );
    }
    const baselineBuffer = context.readBaselineFile(
        context.baselineCommit,
        relativePath
    );
    if (baselineBuffer.length > MAX_SCRIPT_BYTES) {
        throw new Error(
            `${fileName}: baseline colorscript exceeds the size limit.`
        );
    }
    const baselineSource = baselineBuffer.toString("utf8");
    if (isSourceFidelityLocked(baselineSource)) {
        throw new Error(
            `${fileName}: baseline source-fidelity lock forbids rebalancing.`
        );
    }
    const currentPayload = extractPowerShellPayload(currentSource);
    const baselinePayload = extractPowerShellPayload(baselineSource);
    const currentRows = getPayloadRows(currentPayload.value);
    const baselineRows = getPayloadRows(baselinePayload.value);
    const sourceRows = parseSourceRows(baselineSource);
    if (
        context.precedingRange &&
        sourceRows.start !== context.precedingRange.end + 1
    ) {
        throw new Error(
            `${context.family}: baseline source-row ranges are not contiguous.`
        );
    }
    const alignment = alignCurrentRowsToBaseline(baselineRows, currentRows);
    const baselineCoordinates = mapBaselineSourceCoordinates(
        baselineRows,
        sourceRows
    );
    const currentCoordinates = baselineCoordinates.slice(
        alignment.baselineStart,
        alignment.baselineEnd
    );
    if (currentCoordinates.length !== currentRows.length) {
        throw new Error(`${fileName}: source-coordinate mapping drifted.`);
    }
    const mapped = excludeGeneratedPresentationRows(
        currentRows,
        currentCoordinates
    );
    return {
        input: {
            alignment,
            baselinePayloadRows: baselineRows.length,
            currentPayloadRows: currentRows.length,
            expectedBaselineFileSha256: getSha256(baselineBuffer),
            expectedCurrentFileSha256: getSha256(currentBuffer),
            expectedCurrentPayloadSha256: getSha256(
                currentPayload.value.replace(/\r\n?/gu, "\n")
            ),
            expectedCurrentRowsSha256: getRowsSha256(currentRows),
            excludedPresentationRows: mapped.excludedRows,
            file: fileName,
            relativePath,
            sourceRows,
        },
        mapped,
        sourceRows,
    };
}

/**
 * @param {string[]} familyRows
 * @param {string[]} fileNames
 * @param {number[]} breaks
 * @param {SourceRange[]} outputRanges
 * @param {string} family
 *
 * @returns {ManifestOutput[]}
 */
function buildManifestOutputs(
    familyRows,
    fileNames,
    breaks,
    outputRanges,
    family
) {
    const outputs = [];
    let start = 0;
    for (const [index, end] of breaks.entries()) {
        const outputRows = familyRows.slice(start, end);
        const outputFile = fileNames[index];
        if (!outputFile) {
            throw new Error(
                `${family}: output part count exceeded current files.`
            );
        }
        outputs.push({
            endRowExclusive: end,
            expectedRawRowsSha256: getRowsSha256(outputRows),
            file: outputFile,
            rowCount: outputRows.length,
            sourceRows: outputRanges[index],
            startRow: start,
            visibleRowCount: getRenderedBlankRows(outputRows).filter(
                (isBlank) => !isBlank
            ).length,
        });
        start = end;
    }
    return outputs;
}

/**
 * @param {string} family
 * @param {ReviewFinding[]} findings
 * @param {{
 *     baselineCommit: string;
 *     readBaselineFile: (commit: string, relativePath: string) => Buffer;
 *     repositoryRoot: string;
 *     scriptsDirectory: string;
 * }} context
 *
 * @returns {ManifestFamily}
 */
function buildManifestFamily(family, findings, context) {
    const fileNames = discoverFamilyParts(family, context.scriptsDirectory);
    const flaggedNames = new Set(
        findings.map((finding) => `${finding.script}.ps1`)
    );
    if ([...flaggedNames].some((fileName) => !fileNames.includes(fileName))) {
        throw new Error(
            `${family}: a reviewed finding is not part of the discovered family.`
        );
    }
    const inputs = [];
    const mappedFamilyRows = [];
    const mappedFamilyCoordinates = [];
    let precedingRange = null;
    for (const fileName of fileNames) {
        const result = buildManifestInput(fileName, {
            ...context,
            family,
            precedingRange,
        });
        inputs.push(result.input);
        mappedFamilyRows.push(...result.mapped.rows);
        mappedFamilyCoordinates.push(...result.mapped.coordinates);
        precedingRange = result.sourceRows;
    }
    const firstInput = inputs[0];
    const lastInput = inputs.at(-1);
    if (!firstInput || !lastInput) {
        throw new Error(`${family}: no family inputs were generated.`);
    }
    const familyRange = {
        start: firstInput.sourceRows.start,
        end: lastInput.sourceRows.end,
    };
    const outerTrim = trimRenderedBlankOuterRows(
        mappedFamilyRows,
        mappedFamilyCoordinates
    );
    const maximumRows = Math.max(
        DEFAULT_MAXIMUM_ROWS,
        Math.ceil(outerTrim.rows.length / fileNames.length)
    );
    const breaks = chooseFixedPartBreaks(
        outerTrim.rows,
        fileNames.length,
        maximumRows
    );
    const outputRanges = deriveOutputSourceRanges(
        outerTrim.coordinates,
        breaks,
        familyRange
    );
    return {
        expectedFamilyRowsSha256: getRowsSha256(outerTrim.rows),
        expectedMappedFamilyRowsSha256: getRowsSha256(mappedFamilyRows),
        family,
        fixedPartCount: fileNames.length,
        inputs,
        mappedRowCount: mappedFamilyRows.length,
        maximumRows,
        outputs: buildManifestOutputs(
            outerTrim.rows,
            fileNames,
            breaks,
            outputRanges,
            family
        ),
        outerTrim: {
            expectedLeadingRowsSha256: getRowsSha256(outerTrim.leadingRows),
            expectedTrailingRowsSha256: getRowsSha256(outerTrim.trailingRows),
            leadingRows: outerTrim.leadingRows.length,
            trailingRows: outerTrim.trailingRows.length,
        },
        retainedRowCount: outerTrim.rows.length,
        reviewFindings: findings,
        sourceRows: familyRange,
    };
}

/**
 * @param {{
 *     baselineCommit?: string;
 *     classification: ClassificationDocument;
 *     classificationSha256?: string;
 *     readBaselineFile?: (commit: string, relativePath: string) => Buffer;
 *     repositoryRoot?: string;
 *     scriptsDirectory?: string;
 * }} options
 *
 * @returns {RebalanceManifest}
 */
function buildManifest(options) {
    const repositoryRoot = options.repositoryRoot ?? REPOSITORY_ROOT;
    const scriptsDirectory =
        options.scriptsDirectory ?? DEFAULT_SCRIPTS_DIRECTORY;
    const baselineCommit = options.baselineCommit ?? DEFAULT_BASELINE_COMMIT;
    if (!COMMIT_PATTERN.test(baselineCommit)) {
        throw new Error("Baseline commit must be a hexadecimal Git object ID.");
    }
    const { grouped } = selectRebalanceFindings(options.classification);

    const readBaselineFile =
        options.readBaselineFile ??
        ((commit, relativePath) =>
            readGitFile(commit, relativePath, repositoryRoot));
    /** @type {ManifestFamily[]} */
    const families = [];
    for (const family of [...grouped.keys()].sort((left, right) =>
        left.localeCompare(right, "en-US")
    )) {
        const groupedFindings = grouped.get(family);
        if (!groupedFindings) {
            throw new Error(`${family}: review findings are missing.`);
        }
        const findings = groupedFindings.toSorted((left, right) =>
            left.script.localeCompare(right.script)
        );
        families.push(
            buildManifestFamily(family, findings, {
                baselineCommit,
                readBaselineFile,
                repositoryRoot,
                scriptsDirectory,
            })
        );
    }

    return {
        baselineCommit,
        classificationSha256: options.classificationSha256 ?? null,
        families,
        generatedAt: new Date().toISOString(),
        invariants: {
            exactlyOneOutputPresentationRow: true,
            excludeGeneratedPresentationRows: true,
            fixedPartCount: true,
            maximumRowsDefault: DEFAULT_MAXIMUM_ROWS,
            preserveNonblankRows: true,
            preserveRetainedRawRows: true,
            sourceFidelityLocksFailClosed: true,
            trimRenderedBlankOuterRowsOnly: true,
            visibleRowsPerOutput: true,
        },
        schemaVersion: 2,
        summary: getManifestSummary(families),
    };
}

/**
 * @param {RebalanceManifest} document
 *
 * @returns {RebalanceManifest}
 */
function assertManifestHeader(document) {
    if (typeof document !== "object" || document === null) {
        throw new Error(
            "Rebalance manifest must use schemaVersion 2, a baseline commit, and a non-empty families array."
        );
    }

    const { invariants } = document;
    if (
        document.schemaVersion !== 2 ||
        !COMMIT_PATTERN.test(document.baselineCommit) ||
        (document.classificationSha256 !== null &&
            !HASH_PATTERN.test(document.classificationSha256)) ||
        !Array.isArray(document.families) ||
        document.families.length < 1 ||
        !invariants ||
        invariants.exactlyOneOutputPresentationRow !== true ||
        invariants.excludeGeneratedPresentationRows !== true ||
        invariants.fixedPartCount !== true ||
        invariants.preserveNonblankRows !== true ||
        invariants.preserveRetainedRawRows !== true ||
        invariants.sourceFidelityLocksFailClosed !== true ||
        invariants.trimRenderedBlankOuterRowsOnly !== true ||
        invariants.visibleRowsPerOutput !== true ||
        invariants.maximumRowsDefault !== DEFAULT_MAXIMUM_ROWS
    ) {
        throw new Error(
            "Rebalance manifest must use schemaVersion 2, a baseline commit, and a non-empty families array."
        );
    }
}

/**
 * @param {ManifestFamily} family
 * @param {Set<string>} familyNames
 */
function assertManifestFamilyShape(family, familyNames) {
    if (
        !family ||
        typeof family !== "object" ||
        typeof family.family !== "string" ||
        familyNames.has(family.family) ||
        !Number.isSafeInteger(family.fixedPartCount) ||
        family.fixedPartCount < 2 ||
        !Number.isSafeInteger(family.maximumRows) ||
        family.maximumRows < 1 ||
        !HASH_PATTERN.test(family.expectedFamilyRowsSha256) ||
        !HASH_PATTERN.test(family.expectedMappedFamilyRowsSha256) ||
        !Number.isSafeInteger(family.mappedRowCount) ||
        family.mappedRowCount < 1 ||
        !Number.isSafeInteger(family.retainedRowCount) ||
        family.retainedRowCount < family.fixedPartCount ||
        !family.outerTrim ||
        typeof family.outerTrim !== "object" ||
        !Number.isSafeInteger(family.outerTrim.leadingRows) ||
        family.outerTrim.leadingRows < 0 ||
        !Number.isSafeInteger(family.outerTrim.trailingRows) ||
        family.outerTrim.trailingRows < 0 ||
        !HASH_PATTERN.test(family.outerTrim.expectedLeadingRowsSha256) ||
        !HASH_PATTERN.test(family.outerTrim.expectedTrailingRowsSha256) ||
        family.retainedRowCount +
            family.outerTrim.leadingRows +
            family.outerTrim.trailingRows !==
            family.mappedRowCount ||
        !Array.isArray(family.inputs) ||
        !Array.isArray(family.outputs) ||
        family.inputs.length !== family.fixedPartCount ||
        family.outputs.length !== family.fixedPartCount ||
        !Array.isArray(family.reviewFindings) ||
        family.reviewFindings.length < 1 ||
        !isValidRange(family.sourceRows)
    ) {
        throw new Error("Rebalance family record is malformed.");
    }
    familyNames.add(family.family);
}

/**
 * @param {ManifestFamily} family
 * @param {string[]} orderedFiles
 */
function validateManifestReviewFindings(family, orderedFiles) {
    const reviewedScripts = new Set();
    for (const finding of family.reviewFindings) {
        if (
            !finding ||
            typeof finding !== "object" ||
            typeof finding.script !== "string" ||
            typeof finding.signal !== "string" ||
            !REBALANCE_ACTIONS.has(finding.action) ||
            reviewedScripts.has(finding.script) ||
            parsePartName(`${finding.script}.ps1`).family !== family.family ||
            !orderedFiles.includes(`${finding.script}.ps1`)
        ) {
            throw new Error(`${family.family}: review finding is malformed.`);
        }
        reviewedScripts.add(finding.script);
    }
}

/**
 * @param {ManifestFamily} family
 * @param {string[]} orderedFiles
 * @param {Set<string>} allFiles
 */
function validateManifestInputs(family, orderedFiles, allFiles) {
    let totalCurrentRows = 0;
    let totalExcludedPresentationRows = 0;
    let baselineRangeStart = family.sourceRows.start;
    for (const [index, input] of family.inputs.entries()) {
        if (
            !input ||
            typeof input !== "object" ||
            input.file !== orderedFiles[index] ||
            allFiles.has(input.file) ||
            typeof input.relativePath !== "string" ||
            input.relativePath.includes("\\") ||
            input.relativePath.startsWith("../") ||
            !input.relativePath.endsWith(`/${input.file}`) ||
            !HASH_PATTERN.test(input.expectedBaselineFileSha256) ||
            !HASH_PATTERN.test(input.expectedCurrentFileSha256) ||
            !HASH_PATTERN.test(input.expectedCurrentPayloadSha256) ||
            !HASH_PATTERN.test(input.expectedCurrentRowsSha256) ||
            !Number.isSafeInteger(input.baselinePayloadRows) ||
            !Number.isSafeInteger(input.currentPayloadRows) ||
            input.baselinePayloadRows < 1 ||
            input.currentPayloadRows < 1 ||
            !Number.isSafeInteger(input.excludedPresentationRows) ||
            input.excludedPresentationRows < 0 ||
            input.excludedPresentationRows > 1 ||
            input.currentPayloadRows <= input.excludedPresentationRows ||
            !isValidRange(input.sourceRows) ||
            input.sourceRows.start !== baselineRangeStart ||
            !isValidAlignment(
                input.alignment,
                input.baselinePayloadRows,
                input.currentPayloadRows
            )
        ) {
            throw new Error(`${family.family}: input record is malformed.`);
        }
        allFiles.add(input.file);
        totalCurrentRows += input.currentPayloadRows;
        totalExcludedPresentationRows += input.excludedPresentationRows;
        baselineRangeStart = input.sourceRows.end + 1;
    }
    const totalRows = totalCurrentRows - totalExcludedPresentationRows;
    if (
        baselineRangeStart !== family.sourceRows.end + 1 ||
        totalRows !== family.mappedRowCount ||
        family.retainedRowCount > family.fixedPartCount * family.maximumRows
    ) {
        throw new Error(
            `${family.family}: input conservation geometry is invalid.`
        );
    }
}

/**
 * @param {ManifestFamily} family
 * @param {string[]} orderedFiles
 */
function validateManifestOutputs(family, orderedFiles) {
    let startRow = 0;
    let sourceStart = family.sourceRows.start;
    for (const [index, output] of family.outputs.entries()) {
        if (
            !output ||
            typeof output !== "object" ||
            output.file !== orderedFiles[index] ||
            !Number.isSafeInteger(output.startRow) ||
            !Number.isSafeInteger(output.endRowExclusive) ||
            !Number.isSafeInteger(output.rowCount) ||
            output.startRow !== startRow ||
            output.endRowExclusive <= output.startRow ||
            output.rowCount !== output.endRowExclusive - output.startRow ||
            output.rowCount > family.maximumRows ||
            !Number.isSafeInteger(output.visibleRowCount) ||
            output.visibleRowCount < 1 ||
            output.visibleRowCount > output.rowCount ||
            !HASH_PATTERN.test(output.expectedRawRowsSha256) ||
            !isValidRange(output.sourceRows) ||
            output.sourceRows.start !== sourceStart
        ) {
            throw new Error(`${family.family}: output record is malformed.`);
        }
        startRow = output.endRowExclusive;
        sourceStart = output.sourceRows.end + 1;
    }
    if (
        startRow !== family.retainedRowCount ||
        sourceStart !== family.sourceRows.end + 1
    ) {
        throw new Error(
            `${family.family}: outputs do not conserve rows and source coordinates.`
        );
    }
}

/**
 * @param {ManifestFamily[]} families
 */
function getManifestSummary(families) {
    return {
        excludedPresentationRows: families.reduce(
            (total, family) =>
                total +
                family.inputs.reduce(
                    (familyTotal, input) =>
                        familyTotal + input.excludedPresentationRows,
                    0
                ),
            0
        ),
        families: families.length,
        inputs: families.reduce(
            (total, family) => total + family.inputs.length,
            0
        ),
        outputs: families.reduce(
            (total, family) => total + family.outputs.length,
            0
        ),
        retainedRows: families.reduce(
            (total, family) => total + family.retainedRowCount,
            0
        ),
        reviewFindings: families.reduce(
            (total, family) => total + family.reviewFindings.length,
            0
        ),
        trimmedLeadingRows: families.reduce(
            (total, family) => total + family.outerTrim.leadingRows,
            0
        ),
        trimmedTrailingRows: families.reduce(
            (total, family) => total + family.outerTrim.trailingRows,
            0
        ),
    };
}

/**
 * @param {RebalanceManifest} document
 *
 * @returns {RebalanceManifest}
 */
function validateManifest(document) {
    assertManifestHeader(document);
    const familyNames = new Set();
    const allFiles = new Set();
    for (const family of document.families) {
        assertManifestFamilyShape(family, familyNames);
        const orderedFiles = sortAndValidatePartNames(
            family.inputs.map((input) => input.file),
            family.family
        );
        validateManifestReviewFindings(family, orderedFiles);
        validateManifestInputs(family, orderedFiles, allFiles);
        validateManifestOutputs(family, orderedFiles);
    }
    const expectedSummary = getManifestSummary(document.families);
    if (JSON.stringify(document.summary) !== JSON.stringify(expectedSummary)) {
        throw new Error("Rebalance manifest summary is inconsistent.");
    }
    return document;
}

/**
 * @param {unknown} value
 *
 * @returns {value is SourceRange}
 */
function isValidRange(value) {
    if (!value || typeof value !== "object") {
        return false;
    }
    const candidate = /** @type {{ end?: unknown; start?: unknown }} */ (value);
    return (
        Number.isSafeInteger(candidate.start) &&
        Number.isSafeInteger(candidate.end) &&
        /** @type {number} */ (candidate.start) >= 1 &&
        /** @type {number} */ (candidate.end) >=
            /** @type {number} */ (candidate.start)
    );
}

/**
 * @param {unknown} value
 * @param {number} baselineRows
 * @param {number} currentRows
 *
 * @returns {boolean}
 */
function isValidAlignment(value, baselineRows, currentRows) {
    if (!value || typeof value !== "object") {
        return false;
    }
    const candidate =
        /**
         * @type {{
         *     baselineEnd?: unknown;
         *     baselineStart?: unknown;
         *     exactRows?: unknown;
         *     normalizedRows?: unknown;
         *     renderedBlankRows?: unknown;
         * }}
         */ (value);
    return (
        Number.isSafeInteger(candidate.baselineStart) &&
        Number.isSafeInteger(candidate.baselineEnd) &&
        /** @type {number} */ (candidate.baselineStart) >= 0 &&
        candidate.baselineEnd ===
            /** @type {number} */ (candidate.baselineStart) + currentRows &&
        /** @type {number} */ (candidate.baselineEnd) <= baselineRows &&
        Number.isSafeInteger(candidate.exactRows) &&
        Number.isSafeInteger(candidate.normalizedRows) &&
        Number.isSafeInteger(candidate.renderedBlankRows) &&
        /** @type {number} */ (candidate.exactRows) >= 0 &&
        /** @type {number} */ (candidate.normalizedRows) >= 0 &&
        /** @type {number} */ (candidate.renderedBlankRows) >= 0
    );
}

/**
 * @param {ManifestInput} input
 * @param {{
 *     baselineCommit: string;
 *     readBaselineFile: (commit: string, relativePath: string) => Buffer;
 *     scriptsDirectory: string;
 * }} context
 */
function recomputeManifestInput(input, context) {
    const filePath = path.join(context.scriptsDirectory, input.file);
    if (!fs.existsSync(filePath)) {
        throw new Error(`${input.file}: current input is missing.`);
    }
    const currentBuffer = readRegularFile(filePath);
    const currentSource = currentBuffer.toString("utf8");
    if (isSourceFidelityLocked(currentSource)) {
        throw new Error(
            `${input.file}: source-fidelity-locked payload cannot be rebalanced.`
        );
    }
    if (getSha256(currentBuffer) !== input.expectedCurrentFileSha256) {
        throw new Error(`${input.file}: current file hash has drifted.`);
    }
    const currentPayload = extractPowerShellPayload(currentSource);
    const currentRows = getPayloadRows(currentPayload.value);
    if (
        getSha256(currentPayload.value.replace(/\r\n?/gu, "\n")) !==
            input.expectedCurrentPayloadSha256 ||
        getRowsSha256(currentRows) !== input.expectedCurrentRowsSha256 ||
        currentRows.length !== input.currentPayloadRows
    ) {
        throw new Error(`${input.file}: current payload has drifted.`);
    }
    const baselineBuffer = context.readBaselineFile(
        context.baselineCommit,
        input.relativePath
    );
    if (baselineBuffer.length > MAX_SCRIPT_BYTES) {
        throw new Error(
            `${input.file}: baseline colorscript exceeds the size limit.`
        );
    }
    if (getSha256(baselineBuffer) !== input.expectedBaselineFileSha256) {
        throw new Error(`${input.file}: baseline file hash has drifted.`);
    }
    const baselineSource = baselineBuffer.toString("utf8");
    if (isSourceFidelityLocked(baselineSource)) {
        throw new Error(
            `${input.file}: baseline source-fidelity lock forbids rebalancing.`
        );
    }
    const baselineRows = getPayloadRows(
        extractPowerShellPayload(baselineSource).value
    );
    const sourceRows = parseSourceRows(baselineSource);
    const alignment = alignCurrentRowsToBaseline(baselineRows, currentRows);
    if (
        JSON.stringify(alignment) !== JSON.stringify(input.alignment) ||
        JSON.stringify(sourceRows) !== JSON.stringify(input.sourceRows)
    ) {
        throw new Error(
            `${input.file}: baseline alignment or source coordinates have drifted.`
        );
    }
    const baselineCoordinates = mapBaselineSourceCoordinates(
        baselineRows,
        sourceRows
    );
    const currentCoordinates = baselineCoordinates.slice(
        alignment.baselineStart,
        alignment.baselineEnd
    );
    const mapped = excludeGeneratedPresentationRows(
        currentRows,
        currentCoordinates
    );
    if (mapped.excludedRows !== input.excludedPresentationRows) {
        throw new Error(
            `${input.file}: generated presentation-row count has drifted.`
        );
    }
    const replayBefore = getSgrReplayBeforeRows(currentRows);
    return {
        mapped,
        replayBefore: mapped.originalIndexes.map(
            (index) => replayBefore[index] ?? ""
        ),
    };
}

/**
 * @param {ManifestFamily} family
 * @param {Parameters<typeof recomputeManifestInput>[1]} context
 */
function recomputeManifestFamilyRows(family, context) {
    const mappedRows = [];
    const mappedCoordinates = [];
    const mappedInputStartRows = [];
    const mappedReplayBefore = [];
    for (const input of family.inputs) {
        const result = recomputeManifestInput(input, context);
        mappedInputStartRows.push(mappedRows.length);
        mappedReplayBefore.push(...result.replayBefore);
        mappedCoordinates.push(...result.mapped.coordinates);
        mappedRows.push(...result.mapped.rows);
    }
    if (
        mappedRows.length !== family.mappedRowCount ||
        getRowsSha256(mappedRows) !== family.expectedMappedFamilyRowsSha256
    ) {
        throw new Error(
            `${family.family}: concatenated mapped rows have drifted.`
        );
    }
    const outerTrim = trimRenderedBlankOuterRows(mappedRows, mappedCoordinates);
    if (
        outerTrim.leadingRows.length !== family.outerTrim.leadingRows ||
        outerTrim.trailingRows.length !== family.outerTrim.trailingRows ||
        getRowsSha256(outerTrim.leadingRows) !==
            family.outerTrim.expectedLeadingRowsSha256 ||
        getRowsSha256(outerTrim.trailingRows) !==
            family.outerTrim.expectedTrailingRowsSha256
    ) {
        throw new Error(
            `${family.family}: reviewed outer blank-row trim has drifted.`
        );
    }
    if (
        outerTrim.rows.length !== family.retainedRowCount ||
        getRowsSha256(outerTrim.rows) !== family.expectedFamilyRowsSha256
    ) {
        throw new Error(`${family.family}: retained raw rows have drifted.`);
    }
    return {
        coordinates: outerTrim.coordinates,
        inputStartRows: mappedInputStartRows
            .map((row) => row - outerTrim.leadingRows.length)
            .filter((row) => row >= 0 && row < outerTrim.rows.length),
        replayBefore: mappedReplayBefore.slice(
            outerTrim.leadingRows.length,
            mappedReplayBefore.length - outerTrim.trailingRows.length
        ),
        rows: outerTrim.rows,
    };
}

/**
 * @param {ManifestFamily} family
 * @param {string[]} familyRows
 *
 * @returns {number[]}
 */
function getReviewedBreaks(family, familyRows) {
    const reviewed = family.outputs.map((output) => output.endRowExclusive);
    const deterministic = chooseFixedPartBreaks(
        familyRows,
        family.fixedPartCount,
        family.maximumRows
    );
    if (JSON.stringify(reviewed) !== JSON.stringify(deterministic)) {
        throw new Error(
            `${family.family}: reviewed output boundaries are not the deterministic visible-balanced split.`
        );
    }
    return reviewed;
}

/**
 * @param {ManifestOutput} output
 * @param {number} index
 * @param {{
 *     familyRows: string[];
 *     inputStartRows: number[];
 *     outputRanges: SourceRange[];
 *     replayBefore: string[];
 *     scriptsDirectory: string;
 * }} context
 *
 * @returns {PlannedFile}
 */
function planRebalancedOutput(output, index, context) {
    const rawRows = context.familyRows.slice(
        output.startRow,
        output.endRowExclusive
    );
    if (
        getRowsSha256(rawRows) !== output.expectedRawRowsSha256 ||
        getRenderedBlankRows(rawRows).filter((isBlank) => !isBlank).length !==
            output.visibleRowCount ||
        JSON.stringify(context.outputRanges[index]) !==
            JSON.stringify(output.sourceRows)
    ) {
        throw new Error(
            `${output.file}: reviewed output rows or coordinates have drifted.`
        );
    }
    const boundary = applyBoundaryControls(
        rawRows,
        context.replayBefore[output.startRow] ?? "",
        context.inputStartRows
            .filter(
                (row) => row > output.startRow && row < output.endRowExclusive
            )
            .map((row) => row - output.startRow)
    );
    const templatePath = path.join(context.scriptsDirectory, output.file);
    const templateSource = readRegularFile(templatePath).toString("utf8");
    const payload = extractPowerShellPayload(templateSource);
    const updatedPayload = replacePayloadRows(templateSource, payload, [
        "",
        ...boundary.rows,
    ]);
    return {
        file: output.file,
        internalResetIndexes: boundary.internalResetIndexes,
        prefix: boundary.prefix,
        presentationRows: 1,
        rawRowsSha256: output.expectedRawRowsSha256,
        source: replaceSourceRows(updatedPayload, output.sourceRows),
        sourceRows: output.sourceRows,
        suffix: boundary.suffix,
    };
}

/**
 * @param {ManifestFamily} family
 * @param {Parameters<typeof recomputeManifestInput>[1]} context
 */
function planRebalanceFamily(family, context) {
    const recomputed = recomputeManifestFamilyRows(family, context);
    const reviewedBreaks = getReviewedBreaks(family, recomputed.rows);
    const outputRanges = deriveOutputSourceRanges(
        recomputed.coordinates,
        reviewedBreaks,
        family.sourceRows
    );
    return {
        family: family.family,
        files: family.outputs.map((output, index) =>
            planRebalancedOutput(output, index, {
                familyRows: recomputed.rows,
                inputStartRows: recomputed.inputStartRows,
                outputRanges,
                replayBefore: recomputed.replayBefore,
                scriptsDirectory: context.scriptsDirectory,
            })
        ),
        retainedRows: recomputed.rows.length,
    };
}

/**
 * Recompute all locked inputs and output slices. No writes happen until every
 * family passes.
 *
 * @param {RebalanceManifest} manifest
 * @param {{
 *     readBaselineFile?: (commit: string, relativePath: string) => Buffer;
 *     repositoryRoot?: string;
 *     scriptsDirectory?: string;
 * }} [options]
 *
 * @returns {RebalancePlan}
 */
function planRebalance(manifest, options = {}) {
    validateManifest(manifest);
    const repositoryRoot = options.repositoryRoot ?? REPOSITORY_ROOT;
    const scriptsDirectory =
        options.scriptsDirectory ?? DEFAULT_SCRIPTS_DIRECTORY;
    const readBaselineFile =
        options.readBaselineFile ??
        ((commit, relativePath) =>
            readGitFile(commit, relativePath, repositoryRoot));
    /** @type {{ family: string; files: PlannedFile[] }[]} */
    const plannedFamilies = [];
    let retainedRows = 0;

    for (const family of manifest.families) {
        const planned = planRebalanceFamily(family, {
            baselineCommit: manifest.baselineCommit,
            readBaselineFile,
            scriptsDirectory,
        });
        retainedRows += planned.retainedRows;
        plannedFamilies.push({
            family: planned.family,
            files: planned.files,
        });
    }
    return {
        changedFiles: plannedFamilies.reduce(
            (total, family) => total + family.files.length,
            0
        ),
        families: plannedFamilies,
        retainedRows,
    };
}

/**
 * @param {string} targetPath
 * @param {string} source
 *
 * @returns {void}
 */
function writeFileAtomic(targetPath, source) {
    const temporaryPath = `${targetPath}.${process.pid}.tmp`;
    try {
        fs.writeFileSync(temporaryPath, source, "utf8");
        fs.renameSync(temporaryPath, targetPath);
    } finally {
        if (fs.existsSync(temporaryPath)) {
            fs.rmSync(temporaryPath);
        }
    }
}

/**
 * @param {RebalancePlan} plan
 *
 * @returns {string}
 */
function prepareRebalancedProvenance(plan) {
    const provenance = readArtworkProvenance(DEFAULT_PROVENANCE_PATH);
    const updates = new Map();
    for (const family of plan.families) {
        for (const output of family.files) {
            const name = path.basename(output.file, ".ps1");
            if (!provenance.scripts.has(name)) {
                throw new Error(`${name}: artwork provenance is missing.`);
            }
            updates.set(name, {
                SourceRows: `${output.sourceRows.start}-${output.sourceRows.end}`,
            });
        }
    }
    return updateArtworkProvenanceScriptProperties(provenance.source, updates);
}

/**
 * @param {RebalancePlan} plan
 *
 * @returns {string | null}
 */
function prepareRebalancedMigrationManifest(plan) {
    if (!fs.existsSync(HEADER_MIGRATION_PATH)) return null;
    const migration = JSON.parse(
        fs.readFileSync(HEADER_MIGRATION_PATH, "utf8")
    );
    for (const family of plan.families) {
        for (const output of family.files) {
            const name = path.basename(output.file, ".ps1");
            const record = migration.records?.[name];
            if (!record) continue;
            const parsed = parseLeadingCommentHeader(output.source);
            if (!parsed) throw new Error(`${name}: compact header is missing.`);
            record.currentCompactFileSha256 = sha256(
                Buffer.from(output.source, "utf8")
            );
            record.currentPayloadSha256 = sha256(parsed.body);
            record.payloadModifiedAfterMigration =
                record.currentPayloadSha256 !== record.payloadSha256;
        }
    }
    return `${JSON.stringify(migration, null, 2)}\n`;
}

/**
 * @param {RebalancePlan} plan
 * @param {string} scriptsDirectory
 * @param {string | null} updatedProvenance
 * @param {string | null} updatedMigrationManifest
 *
 * @returns {{ targetPath: string; source: string; isScript: boolean }[]}
 */
function buildRebalanceWriteSet(
    plan,
    scriptsDirectory,
    updatedProvenance,
    updatedMigrationManifest
) {
    const writes = plan.families.flatMap((family) =>
        family.files.map((output) => ({
            targetPath: path.join(scriptsDirectory, output.file),
            source: output.source,
            isScript: true,
        }))
    );
    if (updatedProvenance !== null) {
        writes.push({
            targetPath: DEFAULT_PROVENANCE_PATH,
            source: updatedProvenance,
            isScript: false,
        });
    }
    if (updatedMigrationManifest !== null) {
        writes.push({
            targetPath: HEADER_MIGRATION_PATH,
            source: updatedMigrationManifest,
            isScript: false,
        });
    }
    return writes;
}

/**
 * @param {{ targetPath: string; source: string; isScript: boolean }[]} writes
 */
function applyRebalanceWriteSet(writes) {
    const originals = new Map();
    try {
        for (const { targetPath, source, isScript } of writes) {
            originals.set(
                targetPath,
                isScript
                    ? readRegularFile(targetPath)
                    : fs.readFileSync(targetPath)
            );
            writeFileAtomic(targetPath, source);
        }
    } catch (error) {
        for (const [targetPath, buffer] of originals) {
            fs.writeFileSync(targetPath, buffer);
        }
        throw error;
    }
}

/**
 * @param {RebalancePlan} plan
 * @param {string} scriptsDirectory
 *
 * @returns {void}
 */
function writePlan(plan, scriptsDirectory) {
    const usesCheckedInScripts =
        path.resolve(scriptsDirectory).toLowerCase() ===
        path.resolve(DEFAULT_SCRIPTS_DIRECTORY).toLowerCase();
    const updatedProvenance = usesCheckedInScripts
        ? prepareRebalancedProvenance(plan)
        : null;
    const updatedMigrationManifest = usesCheckedInScripts
        ? prepareRebalancedMigrationManifest(plan)
        : null;
    const writes = buildRebalanceWriteSet(
        plan,
        scriptsDirectory,
        updatedProvenance,
        updatedMigrationManifest
    );
    applyRebalanceWriteSet(writes);
}

/**
 * @param {CommandLineOptions} options
 * @param {string} argument
 */
function applyCommandLineOption(options, argument) {
    if (argument === "--write") {
        options.write = true;
        return;
    }
    if (argument === "--help") {
        console.log(`Usage:
  node scripts/Rebalance-ColorScriptParts.js --classification=<path> --output=<path>
  node scripts/Rebalance-ColorScriptParts.js --manifest=<path> [--write]

Options:
  --baseline=<commit>       Pre-curation baseline (default: ${DEFAULT_BASELINE_COMMIT})
  --classification=<path>   Geometry classification JSON used to generate a manifest
  --manifest=<path>         Reviewed, hash-locked manifest to validate or apply
  --output=<path>           Generated manifest path
  --scripts-dir=<path>      Colorscript directory
  --write                   Apply a validated manifest (default is dry-run)
  --help                    Show this help`);
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
        case "baseline":
            options.baselineCommit = optionValue;
            return;
        case "classification":
            options.classificationPath = path.resolve(
                REPOSITORY_ROOT,
                optionValue
            );
            return;
        case "manifest":
            options.manifestPath = path.resolve(REPOSITORY_ROOT, optionValue);
            return;
        case "output":
            options.outputPath = path.resolve(REPOSITORY_ROOT, optionValue);
            return;
        case "scripts-dir":
            options.scriptsDirectory = path.resolve(
                REPOSITORY_ROOT,
                optionValue
            );
            return;
        default:
            throw new Error(`Unknown option: ${argument}`);
    }
}

/**
 * @param {string[]} arguments_
 *
 * @returns {CommandLineOptions}
 */
function parseArguments(arguments_) {
    /** @type {CommandLineOptions} */
    const options = {
        baselineCommit: DEFAULT_BASELINE_COMMIT,
        classificationPath: null,
        manifestPath: null,
        outputPath: null,
        scriptsDirectory: DEFAULT_SCRIPTS_DIRECTORY,
        write: false,
    };
    for (const argument of arguments_) {
        applyCommandLineOption(options, argument);
    }
    if (
        options.classificationPath &&
        (!options.outputPath || options.manifestPath)
    ) {
        throw new Error(
            "Manifest generation requires --classification and --output only."
        );
    }
    if (
        options.manifestPath &&
        (options.classificationPath || options.outputPath)
    ) {
        throw new Error(
            "Manifest validation accepts --manifest without generation options."
        );
    }
    if (!options.classificationPath && !options.manifestPath) {
        throw new Error(
            "Provide either --classification=<path> or --manifest=<path>."
        );
    }
    if (options.write && !options.manifestPath) {
        throw new Error("--write requires --manifest=<path>.");
    }
    return options;
}

/**
 * @param {string[]} [arguments_]
 *
 * @returns {object}
 */
function main(arguments_ = process.argv.slice(2)) {
    const options = parseArguments(arguments_);
    if (options.classificationPath) {
        const classificationPath = options.classificationPath;
        const outputPath = options.outputPath;
        if (!outputPath) {
            throw new Error("Manifest generation requires --output=<path>.");
        }
        const classificationBuffer = fs.readFileSync(classificationPath);
        const classification = /** @type {ClassificationDocument} */ (
            JSON.parse(classificationBuffer.toString("utf8"))
        );
        const manifest = buildManifest({
            baselineCommit: options.baselineCommit,
            classification,
            classificationSha256: getSha256(classificationBuffer),
            scriptsDirectory: options.scriptsDirectory,
        });
        fs.mkdirSync(path.dirname(outputPath), {
            recursive: true,
        });
        fs.writeFileSync(
            outputPath,
            `${JSON.stringify(manifest, null, 2)}\n`,
            "utf8"
        );
        console.log(JSON.stringify(manifest.summary, null, 2));
        console.log(`Manifest: ${outputPath}`);
        return manifest.summary;
    }
    const manifestPath = options.manifestPath;
    if (!manifestPath) {
        throw new Error("Manifest validation requires --manifest=<path>.");
    }
    const manifest = /** @type {RebalanceManifest} */ (
        JSON.parse(fs.readFileSync(manifestPath, "utf8"))
    );
    const plan = planRebalance(manifest, {
        scriptsDirectory: options.scriptsDirectory,
    });
    if (options.write) {
        writePlan(plan, options.scriptsDirectory);
    }
    const summary = {
        changedFiles: plan.changedFiles,
        families: plan.families.length,
        retainedRows: plan.retainedRows,
        write: options.write,
    };
    console.log(JSON.stringify(summary, null, 2));
    return summary;
}

if (require.main === module) {
    main();
}

module.exports = {
    alignCurrentRowsToBaseline,
    applyBoundaryControls,
    buildManifest,
    chooseFixedPartBreaks,
    deriveOutputSourceRanges,
    excludeGeneratedPresentationRows,
    getPayloadRows,
    getRowsSha256,
    getSgrReplayBeforeRows,
    getSha256,
    main,
    mapBaselineSourceCoordinates,
    parseArguments,
    parsePartName,
    parseSourceRows,
    planRebalance,
    replaceSourceRows,
    trimRenderedBlankOuterRows,
    validateManifest,
    writePlan,
};
