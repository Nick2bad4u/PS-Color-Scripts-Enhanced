#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import process from "node:process";
import { createRequire } from "node:module";
import { fileURLToPath } from "node:url";

const require = createRequire(import.meta.url);
const { convertAnsiToPs1 } = require("./Convert-AnsiToColorScript.js");
const { extractLinesFromPs1 } = require("./Split-AnsiFile.js");

const ESCAPE_SEQUENCE = /\u001b\[[0-?]*[ -/]*[@-~]/gu;
const SPLIT_NAME =
    /^(?<base>.+?)(?:-panel(?<panel>\d{2}))?-part(?<part>\d{2})$/u;
const SOURCE_ROW_RANGE = /^# Lines:\s*(\d+)-(\d+)\s*$/mu;
const SOURCE_COLUMN_RANGE = /^# Columns:\s*(\d+)-(\d+)\s*$/mu;
const HEADER_FIELD = /^# ([^:\r\n]+):\s*(.*)$/gmu;
const DERIVATIVE_SIGNAL =
    /\b(?:after|based on|fan art|original (?:art|artwork|image)|ripped|well[- ]known .{0,30} character)\b/iu;
const BLOCK_GLYPH = /[\u2580-\u259f]/u;
const BOX_GLYPH = /[\u2500-\u257f]/u;
const ASCII_GLYPH = /[\u0021-\u007e]/u;
const KNOWN_ISSUE_TYPES = new Set([
    "analysis-error",
    "avoidable-extra-part",
    "blank-part",
    "derivative-attribution-review",
    "leading-blank-run",
    "low-cell-variety",
    "low-structural-complexity",
    "missing-source-coordinates",
    "mostly-plain-ascii",
    "source-row-gap-or-overlap",
    "tiny-tail-part",
    "trailing-blank-run",
    "very-small-output",
]);

const scriptDirectory = path.dirname(fileURLToPath(import.meta.url));
const repositoryRoot = path.resolve(scriptDirectory, "..");
const defaultScriptsDirectory = path.join(
    repositoryRoot,
    "ColorScripts-Enhanced",
    "Scripts"
);
const defaultExceptionsPath = path.join(
    scriptDirectory,
    "ColorScriptAnalysisExceptions.json"
);

/**
 * @typedef {Object} AnalysisOptions
 *
 * @property {number} blankRun
 * @property {number} maxRows
 * @property {number} tinyTailRows
 */

/**
 * @typedef {Object} ScriptRecord
 *
 * @property {string} name
 * @property {string} filePath
 * @property {string[]} lines
 * @property {Record<string, string>} header
 * @property {number | null} sourceRowStart
 * @property {number | null} sourceRowEnd
 * @property {number | null} sourceColumnStart
 * @property {number | null} sourceColumnEnd
 * @property {string | null} splitBase
 * @property {number | null} panel
 * @property {number | null} part
 * @property {ReturnType<typeof analyzeAnsiLines> | null} metrics
 * @property {string | null} analysisError
 * @property {boolean} reviewEligible
 */

/**
 * @param {string[]} argv
 *
 * @returns {{
 *     scriptsDirectory: string;
 *     jsonPath: string | null;
 *     check: boolean;
 *     help: boolean;
 *     issueTypes: string[];
 *     exceptionsPath: string | null;
 *     disableExceptions: boolean;
 *     options: AnalysisOptions;
 * }}
 */
function parseArguments(argv) {
    const result = {
        scriptsDirectory: defaultScriptsDirectory,
        jsonPath: null,
        check: false,
        help: false,
        issueTypes: [],
        exceptionsPath: null,
        disableExceptions: false,
        options: {
            blankRun: 3,
            maxRows: 50,
            tinyTailRows: 10,
        },
    };
    const valueOptions = new Set([
        "--blank-run",
        "--exceptions",
        "--json",
        "--max-rows",
        "--scripts-dir",
        "--tiny-tail-rows",
        "--type",
    ]);
    const normalizedArguments = [];
    for (let index = 0; index < argv.length; index += 1) {
        const argument = argv[index];
        if (!valueOptions.has(argument)) {
            normalizedArguments.push(argument);
            continue;
        }
        const value = argv[index + 1];
        if (value === undefined) {
            throw new Error(`${argument} requires a value.`);
        }
        normalizedArguments.push(`${argument}=${value}`);
        index += 1;
    }
    for (const argument of normalizedArguments) {
        if (argument === "--check") {
            result.check = true;
        } else if (argument === "--no-exceptions") {
            result.disableExceptions = true;
        } else if (argument === "--help" || argument === "-h") {
            result.help = true;
        } else if (argument.startsWith("--scripts-dir=")) {
            result.scriptsDirectory = path.resolve(
                argument.slice("--scripts-dir=".length)
            );
        } else if (argument.startsWith("--json=")) {
            result.jsonPath = path.resolve(argument.slice("--json=".length));
        } else if (argument.startsWith("--exceptions=")) {
            result.exceptionsPath = path.resolve(
                argument.slice("--exceptions=".length)
            );
        } else if (argument.startsWith("--blank-run=")) {
            result.options.blankRun = parsePositiveInteger(
                argument.slice("--blank-run=".length),
                "--blank-run"
            );
        } else if (argument.startsWith("--max-rows=")) {
            result.options.maxRows = parsePositiveInteger(
                argument.slice("--max-rows=".length),
                "--max-rows"
            );
        } else if (argument.startsWith("--tiny-tail-rows=")) {
            result.options.tinyTailRows = parsePositiveInteger(
                argument.slice("--tiny-tail-rows=".length),
                "--tiny-tail-rows"
            );
        } else if (argument.startsWith("--type=")) {
            const issueType = argument.slice("--type=".length);
            if (!KNOWN_ISSUE_TYPES.has(issueType)) {
                throw new Error(
                    `Unknown issue type '${issueType}'. Expected one of: ${[...KNOWN_ISSUE_TYPES].join(", ")}.`
                );
            }
            result.issueTypes.push(issueType);
        } else {
            throw new Error(`Unknown option: ${argument}`);
        }
    }
    if (result.options.tinyTailRows >= result.options.maxRows) {
        throw new RangeError("--tiny-tail-rows must be less than --max-rows.");
    }
    if (result.disableExceptions && result.exceptionsPath) {
        throw new Error(
            "--exceptions and --no-exceptions cannot be used together."
        );
    }
    return result;
}

/**
 * @param {string} filePath
 *
 * @returns {{
 *     issueType: string;
 *     family: string;
 *     panel?: number;
 *     reason: string;
 * }[]}
 */
function loadAnalysisExceptions(filePath) {
    let parsed;
    try {
        parsed = JSON.parse(fs.readFileSync(filePath, "utf8"));
    } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        throw new Error(
            `Unable to read analysis exceptions from ${filePath}: ${message}`
        );
    }
    if (
        !parsed ||
        typeof parsed !== "object" ||
        Array.isArray(parsed) ||
        parsed.schemaVersion !== 1 ||
        !Array.isArray(parsed.exceptions)
    ) {
        throw new Error(
            `Invalid analysis-exception document in ${filePath}: expected schemaVersion 1 and an exceptions array.`
        );
    }
    const allowedKeys = new Set([
        "family",
        "issueType",
        "panel",
        "reason",
    ]);
    return parsed.exceptions.map((exception, index) => {
        if (
            !exception ||
            typeof exception !== "object" ||
            Array.isArray(exception)
        ) {
            throw new Error(
                `Invalid analysis exception ${index + 1} in ${filePath}: expected an object.`
            );
        }
        const unknownKeys = Object.keys(exception).filter(
            (key) => !allowedKeys.has(key)
        );
        if (unknownKeys.length > 0) {
            throw new Error(
                `Invalid analysis exception ${index + 1} in ${filePath}: unknown field(s) ${unknownKeys.join(", ")}.`
            );
        }
        const { family, issueType, panel, reason } = exception;
        if (
            typeof family !== "string" ||
            family.trim() === "" ||
            typeof issueType !== "string" ||
            !KNOWN_ISSUE_TYPES.has(issueType) ||
            typeof reason !== "string" ||
            reason.trim() === "" ||
            (panel !== undefined && (!Number.isSafeInteger(panel) || panel < 1))
        ) {
            throw new Error(
                `Invalid analysis exception ${index + 1} in ${filePath}: family, known issueType, and reason are required; panel must be a positive integer when present.`
            );
        }
        return panel === undefined
            ? { family, issueType, reason }
            : { family, issueType, panel, reason };
    });
}

/**
 * Suppress only exact, currently present findings. A stale, duplicate, or
 * ambiguous entry is an error so the exception ledger cannot quietly rot.
 *
 * @param {Record<string, unknown>[]} issues
 * @param {ReturnType<typeof loadAnalysisExceptions>} exceptions
 *
 * @returns {{
 *     issues: Record<string, unknown>[];
 *     applied: ReturnType<typeof loadAnalysisExceptions>;
 * }}
 */
function applyAnalysisExceptions(issues, exceptions) {
    const suppressedIndexes = new Set();
    const signatures = new Set();
    for (const exception of exceptions) {
        const signature = `${exception.issueType}\0${exception.family}\0${exception.panel ?? "*"}`;
        if (signatures.has(signature)) {
            throw new Error(
                `Duplicate analysis exception for ${exception.issueType}/${exception.family}${exception.panel ? `/panel${exception.panel}` : ""}.`
            );
        }
        signatures.add(signature);
        const matchingIndexes = [];
        for (let index = 0; index < issues.length; index += 1) {
            const issue = issues[index];
            if (
                issue.type === exception.issueType &&
                issue.family === exception.family &&
                (exception.panel === undefined ||
                    issue.panel === exception.panel)
            ) {
                matchingIndexes.push(index);
            }
        }
        if (matchingIndexes.length !== 1) {
            throw new Error(
                `Stale or ambiguous analysis exception for ${exception.issueType}/${exception.family}${exception.panel ? `/panel${exception.panel}` : ""}: matched ${matchingIndexes.length} findings.`
            );
        }
        suppressedIndexes.add(matchingIndexes[0]);
    }
    return {
        issues: issues.filter((_, index) => !suppressedIndexes.has(index)),
        applied: exceptions,
    };
}

/**
 * @param {string} value
 * @param {string} option
 *
 * @returns {number}
 */
function parsePositiveInteger(value, option) {
    const parsed = Number(value);
    if (!Number.isSafeInteger(parsed) || parsed < 1) {
        throw new RangeError(`${option} must be a positive integer.`);
    }
    return parsed;
}

/**
 * @param {unknown} attributes
 *
 * @returns {string}
 */
function styleKey(attributes) {
    if (!attributes || typeof attributes !== "object") return "";
    const value = /** @type {Record<string, unknown>} */ (attributes);
    return JSON.stringify([
        value.bold,
        value.dim,
        value.italic,
        value.underline,
        value.blink,
        value.inverse,
        value.hidden,
        value.strike,
        value.fg,
        value.bg,
    ]);
}

/**
 * @param {unknown} cell
 *
 * @returns {boolean}
 */
function isVisibleCell(cell) {
    if (!cell || typeof cell !== "object") return false;
    const value =
        /**
         * @type {{
         *     char?: string;
         *     attrs?: {
         *         bg?: unknown;
         *         fg?: unknown;
         *         hidden?: boolean;
         *         inverse?: boolean;
         *     };
         * }}
         */ (cell);
    const attributes = value.attrs || {};
    return (
        Boolean(attributes.inverse) ||
        Boolean(attributes.bg) ||
        (!attributes.hidden && Boolean(value.char) && value.char !== " ")
    );
}

/**
 * Analyze terminal-cell complexity without treating background-colored spaces
 * as blank. The returned measurements are review signals, not an automatic
 * aesthetic verdict.
 *
 * @param {string[]} lines
 *
 * @returns {{
 *     rows: number;
 *     visibleRows: number;
 *     visibleCells: number;
 *     leadingBlankRows: number;
 *     trailingBlankRows: number;
 *     longestBlankRun: number;
 *     uniqueGlyphs: number;
 *     uniqueStyles: number;
 *     uniqueRowPatterns: number;
 *     asciiGlyphRatio: number;
 *     blockGlyphRatio: number;
 *     boxGlyphRatio: number;
 *     extendedGlyphRatio: number;
 *     sgrSequences: number;
 *     width: number;
 * }}
 */
function analyzeAnsiLines(lines) {
    // Generated scripts store logical rows without a required line-ending
    // convention. Reconstruct terminal newlines as CRLF so every row returns
    // to column zero, matching the source terminal matrix.
    const content = lines.join("\r\n");
    const converted = convertAnsiToPs1(content, {
        autoWrap: false,
        columns: 2048,
        stripSpaceBackground: false,
    });
    const glyphs = new Set();
    const styles = new Set();
    const rowPatterns = new Set();
    const blankRows = [];
    let visibleCells = 0;
    let asciiGlyphs = 0;
    let blockGlyphs = 0;
    let boxGlyphs = 0;
    let extendedGlyphs = 0;
    let glyphCount = 0;
    let width = 0;

    for (let rowIndex = 0; rowIndex < lines.length; rowIndex += 1) {
        const row = converted.terminal.rows.get(rowIndex);
        const entries = row
            ? [...row.cells.entries()].sort(
                  ([leftColumn], [rightColumn]) => leftColumn - rightColumn
              )
            : [];
        let rowVisible = false;
        const pattern = [];
        for (const [column, cell] of entries) {
            if (!isVisibleCell(cell)) continue;
            rowVisible = true;
            visibleCells += 1;
            width = Math.max(width, column + 1);
            const key = styleKey(cell.attrs);
            styles.add(key);
            pattern.push(`${column}:${cell.char}:${key}`);
            if (cell.char !== " ") {
                glyphCount += 1;
                glyphs.add(cell.char);
                if (ASCII_GLYPH.test(cell.char)) asciiGlyphs += 1;
                if (BLOCK_GLYPH.test(cell.char)) blockGlyphs += 1;
                if (BOX_GLYPH.test(cell.char)) boxGlyphs += 1;
                if (cell.char.codePointAt(0) > 0x7f) extendedGlyphs += 1;
            }
        }
        blankRows.push(!rowVisible);
        if (rowVisible) rowPatterns.add(pattern.join("|"));
    }

    let longestBlankRun = 0;
    let currentBlankRun = 0;
    for (const isBlank of blankRows) {
        if (isBlank) {
            currentBlankRun += 1;
            longestBlankRun = Math.max(longestBlankRun, currentBlankRun);
        } else {
            currentBlankRun = 0;
        }
    }
    const leadingBlankRows = blankRows.findIndex((isBlank) => !isBlank);
    const firstVisible =
        leadingBlankRows === -1 ? blankRows.length : leadingBlankRows;
    const lastVisibleFromEnd = [...blankRows]
        .reverse()
        .findIndex((isBlank) => !isBlank);
    const trailingBlankRows =
        lastVisibleFromEnd === -1 ? blankRows.length : lastVisibleFromEnd;
    const ratio = (count) => (glyphCount === 0 ? 0 : count / glyphCount);

    return {
        rows: lines.length,
        visibleRows: blankRows.length - blankRows.filter(Boolean).length,
        visibleCells,
        leadingBlankRows: firstVisible,
        trailingBlankRows,
        longestBlankRun,
        uniqueGlyphs: glyphs.size,
        uniqueStyles: styles.size,
        uniqueRowPatterns: rowPatterns.size,
        asciiGlyphRatio: ratio(asciiGlyphs),
        blockGlyphRatio: ratio(blockGlyphs),
        boxGlyphRatio: ratio(boxGlyphs),
        extendedGlyphRatio: ratio(extendedGlyphs),
        sgrSequences: content.match(ESCAPE_SEQUENCE)?.length || 0,
        width,
    };
}

/**
 * @param {string} filePath
 *
 * @returns {ScriptRecord}
 */
function analyzeScript(filePath) {
    const source = fs.readFileSync(filePath, "utf8");
    const name = path.basename(filePath, path.extname(filePath));
    const rowMatch = SOURCE_ROW_RANGE.exec(source);
    const columnMatch = SOURCE_COLUMN_RANGE.exec(source);
    const splitMatch = SPLIT_NAME.exec(name);
    const header = {};
    for (const match of source.matchAll(HEADER_FIELD)) {
        header[match[1]] = match[2];
    }
    let lines = [];
    let metrics = null;
    let analysisError = null;
    try {
        lines = extractLinesFromPs1(filePath);
        if (rowMatch) {
            const expectedRows = Number(rowMatch[2]) - Number(rowMatch[1]) + 1;
            if (lines.length === expectedRows + 1 && lines[0] === "") {
                // The serializer intentionally puts the opening quote on the
                // preceding line. That presentation newline is not one of the
                // source rows named by the provenance coordinates.
                lines = lines.slice(1);
            }
        }
    } catch (error) {
        analysisError = error instanceof Error ? error.message : String(error);
    }
    if (!analysisError) {
        try {
            metrics = analyzeAnsiLines(lines);
        } catch (error) {
            analysisError =
                error instanceof Error ? error.message : String(error);
        }
    }
    return {
        name,
        filePath,
        lines,
        header,
        sourceRowStart: rowMatch ? Number(rowMatch[1]) : null,
        sourceRowEnd: rowMatch ? Number(rowMatch[2]) : null,
        sourceColumnStart: columnMatch ? Number(columnMatch[1]) : null,
        sourceColumnEnd: columnMatch ? Number(columnMatch[2]) : null,
        splitBase: splitMatch?.groups?.base || null,
        panel: splitMatch?.groups?.panel
            ? Number(splitMatch.groups.panel)
            : null,
        part: splitMatch?.groups?.part ? Number(splitMatch.groups.part) : null,
        metrics,
        analysisError,
        reviewEligible: Boolean(
            header["Converted from"] ||
            header["Source URL"] ||
            splitMatch?.groups?.base
        ),
    };
}

/**
 * @param {number} start
 * @param {number} end
 * @param {number} maxRows
 *
 * @returns {string[]}
 */
function buildBalancedRanges(start, end, maxRows) {
    if (
        !Number.isSafeInteger(start) ||
        !Number.isSafeInteger(end) ||
        !Number.isSafeInteger(maxRows) ||
        start < 1 ||
        end < start ||
        maxRows < 1
    ) {
        throw new RangeError(
            "Balanced source ranges require positive integers and an end row no earlier than the start row."
        );
    }
    const totalRows = end - start + 1;
    const partCount = Math.ceil(totalRows / maxRows);
    const baseSize = Math.floor(totalRows / partCount);
    let remainder = totalRows % partCount;
    let nextStart = start;
    const ranges = [];
    for (let index = 0; index < partCount; index += 1) {
        const size = baseSize + (remainder > 0 ? 1 : 0);
        remainder = Math.max(0, remainder - 1);
        const nextEnd = nextStart + size - 1;
        ranges.push(`${nextStart}-${nextEnd}`);
        nextStart = nextEnd + 1;
    }
    return ranges;
}

/**
 * @param {ScriptRecord[]} records
 * @param {AnalysisOptions} options
 *
 * @returns {Record<string, unknown>[]}
 */
function analyzeSplitFamilies(records, options) {
    const families = new Map();
    for (const record of records) {
        if (!record.splitBase) continue;
        const key = `${record.splitBase}\0${record.panel || 0}`;
        const members = families.get(key) || [];
        members.push(record);
        families.set(key, members);
    }

    const issues = [];
    for (const members of families.values()) {
        members.sort(
            (left, right) =>
                (left.sourceRowStart || 0) - (right.sourceRowStart || 0)
        );
        const first = members[0];
        const last = members.at(-1);
        if (
            first.sourceRowStart === null ||
            last.sourceRowEnd === null ||
            members.some(
                (member) =>
                    member.sourceRowStart === null ||
                    member.sourceRowEnd === null
            )
        ) {
            issues.push({
                type: "missing-source-coordinates",
                family: first.splitBase,
                scripts: members.map((member) => member.name),
            });
            continue;
        }
        for (let index = 1; index < members.length; index += 1) {
            const previous = members[index - 1];
            const current = members[index];
            if (current.sourceRowStart !== previous.sourceRowEnd + 1) {
                issues.push({
                    type: "source-row-gap-or-overlap",
                    family: first.splitBase,
                    scripts: [previous.name, current.name],
                    previousEnd: previous.sourceRowEnd,
                    currentStart: current.sourceRowStart,
                });
            }
        }

        const tailRows = last.sourceRowEnd - last.sourceRowStart + 1;
        const totalRows = last.sourceRowEnd - first.sourceRowStart + 1;
        const minimumParts = Math.ceil(totalRows / options.maxRows);
        if (tailRows <= options.tinyTailRows) {
            issues.push({
                type: "tiny-tail-part",
                family: first.splitBase,
                panel: first.panel,
                script: last.name,
                tailRows,
                currentRanges: members.map(
                    (member) =>
                        `${member.sourceRowStart}-${member.sourceRowEnd}`
                ),
                suggestedRanges: buildBalancedRanges(
                    first.sourceRowStart,
                    last.sourceRowEnd,
                    options.maxRows
                ),
            });
        }
        if (members.length > minimumParts) {
            issues.push({
                type: "avoidable-extra-part",
                family: first.splitBase,
                panel: first.panel,
                currentParts: members.length,
                minimumParts,
                currentRanges: members.map(
                    (member) =>
                        `${member.sourceRowStart}-${member.sourceRowEnd}`
                ),
                suggestedRanges: buildBalancedRanges(
                    first.sourceRowStart,
                    last.sourceRowEnd,
                    options.maxRows
                ),
            });
        }
    }
    return issues;
}

/**
 * @param {ScriptRecord[]} records
 * @param {AnalysisOptions} options
 *
 * @returns {Record<string, unknown>[]}
 */
function analyzeReviewSignals(records, options) {
    const issues = [];
    for (const record of records) {
        if (!record.reviewEligible) continue;
        if (!record.metrics) {
            issues.push({
                type: "analysis-error",
                script: record.name,
                error: record.analysisError,
            });
            continue;
        }
        const metrics = record.metrics;
        if (metrics.leadingBlankRows >= options.blankRun) {
            issues.push({
                type: "leading-blank-run",
                script: record.name,
                rows: metrics.leadingBlankRows,
            });
        }
        if (metrics.trailingBlankRows >= options.blankRun) {
            issues.push({
                type: "trailing-blank-run",
                script: record.name,
                rows: metrics.trailingBlankRows,
            });
        }
        if (metrics.visibleRows === 0) {
            issues.push({ type: "blank-part", script: record.name });
        } else if (metrics.visibleRows <= 5 || metrics.visibleCells <= 80) {
            issues.push({
                type: "very-small-output",
                script: record.name,
                visibleRows: metrics.visibleRows,
                visibleCells: metrics.visibleCells,
            });
        }
        if (
            metrics.rows >= 20 &&
            metrics.uniqueGlyphs <= 4 &&
            metrics.uniqueStyles <= 10 &&
            metrics.uniqueRowPatterns <= 10
        ) {
            issues.push({
                type: "low-cell-variety",
                script: record.name,
                uniqueGlyphs: metrics.uniqueGlyphs,
                uniqueStyles: metrics.uniqueStyles,
                uniqueRowPatterns: metrics.uniqueRowPatterns,
            });
        }
        if (
            metrics.rows >= 10 &&
            metrics.asciiGlyphRatio >= 0.95 &&
            metrics.uniqueStyles <= 4
        ) {
            issues.push({
                type: "mostly-plain-ascii",
                script: record.name,
                asciiGlyphRatio: metrics.asciiGlyphRatio,
                uniqueStyles: metrics.uniqueStyles,
            });
        }
    }
    return issues;
}

/**
 * Review source-level properties once per artwork instead of reporting the same
 * derivative note or deliberately simple composition for every part.
 *
 * @param {ScriptRecord[]} records
 *
 * @returns {Record<string, unknown>[]}
 */
function analyzeFamilyReviewSignals(records) {
    const derivativeFamilies = new Map();
    const structuralFamilies = new Map();
    for (const record of records) {
        if (!record.reviewEligible || !record.metrics) continue;
        const sourceIdentity =
            record.header["Source URL"] ||
            record.header["Source SHA-256"] ||
            record.splitBase ||
            record.name;
        const derivativeMembers = derivativeFamilies.get(sourceIdentity) || [];
        derivativeMembers.push(record);
        derivativeFamilies.set(sourceIdentity, derivativeMembers);

        const structuralIdentity = record.splitBase
            ? `${record.splitBase}\0${record.panel || 0}`
            : record.name;
        const structuralMembers =
            structuralFamilies.get(structuralIdentity) || [];
        structuralMembers.push(record);
        structuralFamilies.set(structuralIdentity, structuralMembers);
    }

    const issues = [];
    for (const members of derivativeFamilies.values()) {
        const provenanceEvidence = [
            ...new Set(
                members.flatMap((record) =>
                    Object.entries(record.header)
                        .filter(([key]) =>
                            /^(?:SAUCE Comments|Source Attribution)$/u.test(key)
                        )
                        .map(([, value]) => value)
                )
            ),
        ];
        const artworkEvidence = [
            ...new Set(
                members.flatMap((record) =>
                    record.lines
                        .map((line) => line.replace(ESCAPE_SEQUENCE, "").trim())
                        .filter((line) => DERIVATIVE_SIGNAL.test(line))
                )
            ),
        ];
        const evidence = [...provenanceEvidence, ...artworkEvidence]
            .filter((value) => DERIVATIVE_SIGNAL.test(value))
            .join(" | ")
            .slice(0, 1024);
        if (evidence) {
            issues.push({
                type: "derivative-attribution-review",
                family: members[0].splitBase || members[0].name,
                scripts: members.map((record) => record.name).sort(),
                evidence,
            });
        }
    }

    for (const members of structuralFamilies.values()) {
        members.sort(
            (left, right) =>
                (left.sourceRowStart || 0) - (right.sourceRowStart || 0)
        );
        const metrics = analyzeAnsiLines(
            members.flatMap((record) => record.lines)
        );
        const rowPatternRatio =
            metrics.visibleRows === 0
                ? 0
                : metrics.uniqueRowPatterns / metrics.visibleRows;
        if (
            metrics.visibleRows >= 40 &&
            metrics.uniqueGlyphs <= 8 &&
            metrics.uniqueStyles <= 10 &&
            rowPatternRatio <= 0.3
        ) {
            issues.push({
                type: "low-structural-complexity",
                family: members[0].splitBase || members[0].name,
                scripts: members.map((record) => record.name),
                visibleRows: metrics.visibleRows,
                uniqueGlyphs: metrics.uniqueGlyphs,
                uniqueStyles: metrics.uniqueStyles,
                uniqueRowPatterns: metrics.uniqueRowPatterns,
                rowPatternRatio,
            });
        }
    }
    return issues;
}

/**
 * @param {string} scriptsDirectory
 * @param {AnalysisOptions} options
 * @param {ReturnType<typeof loadAnalysisExceptions>} [exceptions]
 *
 * @returns {{
 *     schemaVersion: number;
 *     generatedAt: string;
 *     scriptsDirectory: string;
 *     summary: Record<string, number>;
 *     appliedExceptions: ReturnType<typeof loadAnalysisExceptions>;
 *     issues: Record<string, unknown>[];
 *     scripts: Record<string, unknown>[];
 * }}
 */
function buildReport(scriptsDirectory, options, exceptions = []) {
    if (!fs.existsSync(scriptsDirectory)) {
        throw new Error(
            `Scripts directory does not exist: ${scriptsDirectory}`
        );
    }
    const files = fs
        .readdirSync(scriptsDirectory, { withFileTypes: true })
        .filter(
            (entry) =>
                entry.isFile() && entry.name.toLowerCase().endsWith(".ps1")
        )
        .map((entry) => path.join(scriptsDirectory, entry.name))
        .sort((left, right) => left.localeCompare(right));
    const records = files.map(analyzeScript);
    const detectedIssues = [
        ...analyzeSplitFamilies(records, options),
        ...analyzeReviewSignals(records, options),
        ...analyzeFamilyReviewSignals(records),
    ].sort((left, right) =>
        JSON.stringify(left).localeCompare(JSON.stringify(right))
    );
    const exceptionResult = applyAnalysisExceptions(detectedIssues, exceptions);
    const issues = exceptionResult.issues;
    const issuesByType = Object.fromEntries(
        Object.entries(Object.groupBy(issues, (issue) => String(issue.type)))
            .sort(([left], [right]) => left.localeCompare(right))
            .map(([type, values]) => [type, values.length])
    );
    return {
        schemaVersion: 2,
        generatedAt: new Date().toISOString(),
        scriptsDirectory,
        summary: {
            scripts: records.length,
            splitScripts: records.filter((record) => record.splitBase).length,
            issues: issues.length,
            suppressedIssues: exceptionResult.applied.length,
            ...issuesByType,
        },
        appliedExceptions: exceptionResult.applied,
        issues,
        scripts: records.map((record) => ({
            name: record.name,
            sourceRows:
                record.sourceRowStart === null
                    ? null
                    : `${record.sourceRowStart}-${record.sourceRowEnd}`,
            sourceColumns:
                record.sourceColumnStart === null
                    ? null
                    : `${record.sourceColumnStart}-${record.sourceColumnEnd}`,
            metrics: record.metrics,
            analysisError: record.analysisError,
            reviewEligible: record.reviewEligible,
        })),
    };
}

/**
 * @param {ReturnType<typeof buildReport>} report
 * @param {string[]} issueTypes
 *
 * @returns {ReturnType<typeof buildReport>}
 */
function filterReport(report, issueTypes) {
    if (issueTypes.length === 0) return report;
    const selectedTypes = new Set(issueTypes);
    const issues = report.issues.filter((issue) =>
        selectedTypes.has(String(issue.type))
    );
    const issuesByType = Object.fromEntries(
        Object.entries(Object.groupBy(issues, (issue) => String(issue.type)))
            .sort(([left], [right]) => left.localeCompare(right))
            .map(([type, values]) => [type, values.length])
    );
    const appliedExceptions = report.appliedExceptions.filter((exception) =>
        selectedTypes.has(exception.issueType)
    );
    return {
        ...report,
        summary: {
            scripts: report.summary.scripts,
            splitScripts: report.summary.splitScripts,
            issues: issues.length,
            suppressedIssues: appliedExceptions.length,
            ...issuesByType,
        },
        appliedExceptions,
        issues,
    };
}

/**
 * @returns {void}
 */
function printUsage() {
    console.log(`Usage: node scripts/Analyze-ColorScripts.mjs [options]

Review static colorscripts for suspicious split geometry, blank boundaries,
small output, low terminal-cell complexity, plain ASCII, and derivative-source
attribution. Findings are review signals, not automatic deletion decisions.

Options:
  --json=<path>             Write the complete deterministic-data report as JSON
  --type=<issue-name>       Emit only one issue type (repeatable)
  --scripts-dir=<path>      Analyze a different colorscript directory
  --exceptions=<path>       Use a specific reviewed-exception ledger
  --no-exceptions           Show findings suppressed by the default ledger
  --max-rows=<count>        Maximum permitted source rows per part (default: 50)
  --tiny-tail-rows=<count>  Tail size to flag (default: 10)
  --blank-run=<count>       Leading/trailing blank run to flag (default: 3)
  --check                   Exit nonzero when the selected report has findings
  --help, -h                Show this help`);
}

/**
 * @param {string} targetPath
 * @param {string} content
 *
 * @returns {void}
 */
function writeFileAtomic(targetPath, content) {
    fs.mkdirSync(path.dirname(targetPath), { recursive: true });
    const temporaryPath = `${targetPath}.${process.pid}.tmp`;
    fs.writeFileSync(temporaryPath, content);
    fs.renameSync(temporaryPath, targetPath);
}

/**
 * @param {string[]} [argv]
 *
 * @returns {void}
 */
function main(argv = process.argv.slice(2)) {
    const parsed = parseArguments(argv);
    if (parsed.help) {
        printUsage();
        return;
    }
    const usesDefaultScriptsDirectory =
        path.resolve(parsed.scriptsDirectory).toLowerCase() ===
        path.resolve(defaultScriptsDirectory).toLowerCase();
    const exceptionsPath = parsed.disableExceptions
        ? null
        : parsed.exceptionsPath ||
          (usesDefaultScriptsDirectory ? defaultExceptionsPath : null);
    const exceptions = exceptionsPath
        ? loadAnalysisExceptions(exceptionsPath)
        : [];
    const report = filterReport(
        buildReport(parsed.scriptsDirectory, parsed.options, exceptions),
        parsed.issueTypes
    );
    if (parsed.jsonPath) {
        writeFileAtomic(
            parsed.jsonPath,
            `${JSON.stringify(report, null, 2)}\n`
        );
        console.log(`Report: ${parsed.jsonPath}`);
    }
    console.log(JSON.stringify(report.summary, null, 2));
    for (const issue of report.issues) {
        console.log(JSON.stringify(issue));
    }
    if (parsed.check && report.issues.length > 0) {
        process.exitCode = 1;
    }
}

if (
    process.argv[1] &&
    path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)
) {
    main();
}

export {
    analyzeAnsiLines,
    analyzeFamilyReviewSignals,
    analyzeReviewSignals,
    analyzeScript,
    analyzeSplitFamilies,
    applyAnalysisExceptions,
    buildBalancedRanges,
    buildReport,
    filterReport,
    loadAnalysisExceptions,
    main,
    parseArguments,
    printUsage,
};
