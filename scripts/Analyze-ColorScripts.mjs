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
const REPLACEMENT_CHARACTER = /\ufffd/gu;
const MOJIBAKE_SEQUENCE = /(?:Ã[\u0080-\u00bf]|â€|ðŸ|ï»¿)/gu;
const DOS_EOF_CHARACTER = /\u001a/gu;
const ANSI_COLOR_FAMILIES = [
    "neutral",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "neutral",
];
const KNOWN_ISSUE_TYPES = new Set([
    "analysis-error",
    "avoidable-extra-part",
    "blank-part",
    "continuous-split-review",
    "dense-split-boundary",
    "derivative-attribution-review",
    "embedded-dos-eof",
    "leading-blank-run",
    "low-cell-variety",
    "low-color-variety",
    "low-structural-complexity",
    "mergeable-adjacent-parts",
    "missing-source-coordinates",
    "mostly-plain-ascii",
    "source-row-gap-or-overlap",
    "sparse-cell-density",
    "suspicious-character-decoding",
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
 *     boundaryAfterRow?: number;
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
        "boundaryAfterRow",
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
        const { boundaryAfterRow, family, issueType, panel, reason } =
            exception;
        if (
            typeof family !== "string" ||
            family.trim() === "" ||
            typeof issueType !== "string" ||
            !KNOWN_ISSUE_TYPES.has(issueType) ||
            typeof reason !== "string" ||
            reason.trim() === "" ||
            (boundaryAfterRow !== undefined &&
                (!Number.isSafeInteger(boundaryAfterRow) ||
                    boundaryAfterRow < 1)) ||
            (panel !== undefined && (!Number.isSafeInteger(panel) || panel < 1))
        ) {
            throw new Error(
                `Invalid analysis exception ${index + 1} in ${filePath}: family, known issueType, and reason are required; boundaryAfterRow and panel must be positive integers when present.`
            );
        }
        return {
            ...(boundaryAfterRow === undefined ? {} : { boundaryAfterRow }),
            family,
            issueType,
            ...(panel === undefined ? {} : { panel }),
            reason,
        };
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
        const signature = `${exception.issueType}\0${exception.family}\0${exception.panel ?? "*"}\0${exception.boundaryAfterRow ?? "*"}`;
        if (signatures.has(signature)) {
            throw new Error(
                `Duplicate analysis exception for ${exception.issueType}/${exception.family}${exception.panel ? `/panel${exception.panel}` : ""}${exception.boundaryAfterRow ? `/row${exception.boundaryAfterRow}` : ""}.`
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
                    issue.panel === exception.panel) &&
                (exception.boundaryAfterRow === undefined ||
                    issue.boundaryAfterRow === exception.boundaryAfterRow)
            ) {
                matchingIndexes.push(index);
            }
        }
        if (matchingIndexes.length !== 1) {
            throw new Error(
                `Stale or ambiguous analysis exception for ${exception.issueType}/${exception.family}${exception.panel ? `/panel${exception.panel}` : ""}${exception.boundaryAfterRow ? `/row${exception.boundaryAfterRow}` : ""}: matched ${matchingIndexes.length} findings.`
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
 * Convert an xterm 256-color palette index to RGB.
 *
 * @param {number} index
 *
 * @returns {{ r: number; g: number; b: number } | null}
 */
function paletteColorToRgb(index) {
    if (!Number.isSafeInteger(index) || index < 16 || index > 255) {
        return null;
    }
    if (index >= 232) {
        const value = 8 + (index - 232) * 10;
        return { r: value, g: value, b: value };
    }
    const offset = index - 16;
    const levels = [
        0,
        95,
        135,
        175,
        215,
        255,
    ];
    const red = levels[Math.floor(offset / 36)];
    const green = levels[Math.floor((offset % 36) / 6)];
    const blue = levels[offset % 6];
    if (red === undefined || green === undefined || blue === undefined) {
        return null;
    }
    return { r: red, g: green, b: blue };
}

/**
 * Collapse RGB colors into broad visual families. Bright and dark variants
 * intentionally share a family so a duotone work is not misclassified merely
 * because it uses intensity variants.
 *
 * @param {number} red
 * @param {number} green
 * @param {number} blue
 *
 * @returns {string}
 */
function rgbColorFamily(red, green, blue) {
    const maximum = Math.max(red, green, blue);
    const minimum = Math.min(red, green, blue);
    const delta = maximum - minimum;
    if (maximum === 0 || delta / maximum < 0.2) return "neutral";

    let hue;
    if (maximum === red) {
        hue = 60 * (((green - blue) / delta) % 6);
    } else if (maximum === green) {
        hue = 60 * ((blue - red) / delta + 2);
    } else {
        hue = 60 * ((red - green) / delta + 4);
    }
    if (hue < 0) hue += 360;
    if (hue < 30 || hue >= 330) return "red";
    if (hue < 90) return "yellow";
    if (hue < 150) return "green";
    if (hue < 210) return "cyan";
    if (hue < 270) return "blue";
    return "magenta";
}

/**
 * @param {unknown} color
 *
 * @returns {string}
 */
function colorFamily(color) {
    if (!color || typeof color !== "object") return "neutral";
    const value = /** @type {Record<string, unknown>} */ (color);
    if (
        (value.mode === "basic" || value.mode === "bright") &&
        typeof value.value === "number"
    ) {
        return ANSI_COLOR_FAMILIES[value.value % 8] || "neutral";
    }
    if (value.mode === "palette" && typeof value.value === "number") {
        if (value.value < 16) {
            return ANSI_COLOR_FAMILIES[value.value % 8] || "neutral";
        }
        const rgb = paletteColorToRgb(value.value);
        return rgb ? rgbColorFamily(rgb.r, rgb.g, rgb.b) : "neutral";
    }
    if (
        value.mode === "rgb" &&
        typeof value.r === "number" &&
        typeof value.g === "number" &&
        typeof value.b === "number"
    ) {
        return rgbColorFamily(value.r, value.g, value.b);
    }
    return "neutral";
}

/**
 * Collect only colors that visibly contribute to the rendered cell. Default
 * foreground/background colors are treated as one neutral family.
 *
 * @param {unknown} cell
 *
 * @returns {Set<string>}
 */
function visibleCellColorFamilies(cell) {
    const families = new Set();
    if (!cell || typeof cell !== "object") return families;
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
    const foreground = attributes.inverse ? attributes.bg : attributes.fg;
    const background = attributes.inverse ? attributes.fg : attributes.bg;
    if (!attributes.hidden && value.char && value.char !== " ") {
        families.add(colorFamily(foreground));
    }
    if (background || attributes.inverse) {
        families.add(colorFamily(background));
    }
    return families;
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
 *     colorFamilies: string[];
 *     uniqueColorFamilies: number;
 *     coloredCellRatio: number;
 *     cellDensity: number;
 *     firstRowVisibleCells: number;
 *     lastRowVisibleCells: number;
 *     rowVisibleCellCounts: number[];
 *     replacementCharacters: number;
 *     mojibakeSequences: number;
 *     dosEofCharacters: number;
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
    const colorFamilies = new Set();
    const blankRows = [];
    const visibleCellsByRow = [];
    let visibleCells = 0;
    let coloredCells = 0;
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
        let rowVisibleCells = 0;
        const pattern = [];
        for (const [column, cell] of entries) {
            if (!isVisibleCell(cell)) continue;
            rowVisible = true;
            rowVisibleCells += 1;
            visibleCells += 1;
            width = Math.max(width, column + 1);
            const key = styleKey(cell.attrs);
            styles.add(key);
            pattern.push(`${column}:${cell.char}:${key}`);
            const cellColorFamilies = visibleCellColorFamilies(cell);
            let cellUsesColor = false;
            for (const family of cellColorFamilies) {
                colorFamilies.add(family);
                if (family !== "neutral") cellUsesColor = true;
            }
            if (cellUsesColor) {
                coloredCells += 1;
            }
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
        visibleCellsByRow.push(rowVisibleCells);
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
    const plainText = content.replace(ESCAPE_SEQUENCE, "");

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
        colorFamilies: [...colorFamilies].sort(),
        uniqueColorFamilies: colorFamilies.size,
        coloredCellRatio: visibleCells === 0 ? 0 : coloredCells / visibleCells,
        cellDensity:
            width === 0 || blankRows.length === 0
                ? 0
                : visibleCells / (width * blankRows.length),
        firstRowVisibleCells: visibleCellsByRow[0] || 0,
        lastRowVisibleCells: visibleCellsByRow.at(-1) || 0,
        rowVisibleCellCounts: visibleCellsByRow,
        replacementCharacters:
            plainText.match(REPLACEMENT_CHARACTER)?.length || 0,
        mojibakeSequences: plainText.match(MOJIBAKE_SEQUENCE)?.length || 0,
        dosEofCharacters: plainText.match(DOS_EOF_CHARACTER)?.length || 0,
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
 * Find a nearby source blank row that can replace a dense cut without changing
 * the part count or violating the row limit. This deliberately avoids reporting
 * continuous tall artwork whose dense split is unavoidable.
 *
 * @param {ScriptRecord} previous
 * @param {ScriptRecord} current
 * @param {number} maxRows
 *
 * @returns {number | null}
 */
function findNearbyBlankBoundary(previous, current, maxRows) {
    if (
        !previous.metrics ||
        !current.metrics ||
        previous.sourceRowStart === null ||
        previous.sourceRowEnd === null ||
        current.sourceRowStart === null ||
        current.sourceRowEnd === null
    ) {
        return null;
    }
    const firstSourceRow = previous.sourceRowStart;
    const currentBoundary = previous.sourceRowEnd;
    const lastSourceRow = current.sourceRowEnd;
    const rowCounts = [
        ...previous.metrics.rowVisibleCellCounts,
        ...current.metrics.rowVisibleCellCounts,
    ];
    const minimumPreviousVisibleRows = Math.min(
        10,
        previous.metrics.visibleRows
    );
    const minimumNextVisibleRows = Math.min(10, current.metrics.visibleRows);
    const minimumPartRows = Math.min(10, Math.floor(rowCounts.length / 3));
    const lowerBound = Math.max(
        firstSourceRow + minimumPartRows - 1,
        lastSourceRow - maxRows,
        currentBoundary - 10
    );
    const upperBound = Math.min(
        firstSourceRow + maxRows - 1,
        lastSourceRow - minimumPartRows,
        currentBoundary + 10
    );
    const candidates = [];
    for (
        let boundaryAfterRow = lowerBound;
        boundaryAfterRow <= upperBound;
        boundaryAfterRow += 1
    ) {
        if (boundaryAfterRow === currentBoundary) continue;
        const beforeIndex = boundaryAfterRow - firstSourceRow;
        const afterIndex = beforeIndex + 1;
        const beforeCells = rowCounts[beforeIndex];
        const afterCells = rowCounts[afterIndex];
        if (
            beforeCells === undefined ||
            afterCells === undefined ||
            (beforeCells !== 0 && afterCells !== 0)
        ) {
            continue;
        }
        const previousVisibleRows = rowCounts
            .slice(0, beforeIndex + 1)
            .filter((count) => count > 0).length;
        const nextVisibleRows = rowCounts
            .slice(afterIndex)
            .filter((count) => count > 0).length;
        if (
            previousVisibleRows < minimumPreviousVisibleRows ||
            nextVisibleRows < minimumNextVisibleRows
        ) {
            continue;
        }
        candidates.push({
            boundaryAfterRow,
            activity: beforeCells + afterCells,
            distance: Math.abs(boundaryAfterRow - currentBoundary),
            leavesTrailingBlank: beforeCells === 0 ? 0 : 1,
        });
    }
    candidates.sort(
        (left, right) =>
            left.activity - right.activity ||
            left.leavesTrailingBlank - right.leavesTrailingBlank ||
            left.distance - right.distance ||
            left.boundaryAfterRow - right.boundaryAfterRow
    );
    return candidates[0]?.boundaryAfterRow ?? null;
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
        const mergeablePairs = [];
        const continuousBoundaries = [];
        if (first.sourceRowStart !== 1) {
            issues.push({
                type: "source-row-gap-or-overlap",
                family: first.splitBase,
                scripts: [first.name],
                previousEnd: 0,
                currentStart: first.sourceRowStart,
            });
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
                continue;
            }
            const adjacentRows =
                previous.sourceRowEnd -
                previous.sourceRowStart +
                1 +
                (current.sourceRowEnd - current.sourceRowStart + 1);
            if (adjacentRows <= options.maxRows) {
                mergeablePairs.push({
                    scripts: [previous.name, current.name],
                    combinedRows: adjacentRows,
                    suggestedRange: `${previous.sourceRowStart}-${current.sourceRowEnd}`,
                });
            }
            if (previous.metrics && current.metrics) {
                const boundaryWidth = Math.min(
                    previous.metrics.width,
                    current.metrics.width
                );
                const minimumBoundaryCells = Math.max(
                    12,
                    Math.ceil(boundaryWidth * 0.25)
                );
                if (
                    boundaryWidth > 0 &&
                    previous.metrics.lastRowVisibleCells >=
                        minimumBoundaryCells &&
                    current.metrics.firstRowVisibleCells >= minimumBoundaryCells
                ) {
                    const suggestedBoundaryAfterRow = findNearbyBlankBoundary(
                        previous,
                        current,
                        options.maxRows
                    );
                    if (suggestedBoundaryAfterRow !== null) {
                        issues.push({
                            type: "dense-split-boundary",
                            family: first.splitBase,
                            panel: first.panel,
                            scripts: [previous.name, current.name],
                            boundaryAfterRow: previous.sourceRowEnd,
                            suggestedBoundaryAfterRow,
                            previousVisibleCells:
                                previous.metrics.lastRowVisibleCells,
                            nextVisibleCells:
                                current.metrics.firstRowVisibleCells,
                            boundaryWidth,
                            minimumBoundaryCells,
                        });
                    } else {
                        continuousBoundaries.push({
                            scripts: [previous.name, current.name],
                            boundaryAfterRow: previous.sourceRowEnd,
                            previousVisibleCells:
                                previous.metrics.lastRowVisibleCells,
                            nextVisibleCells:
                                current.metrics.firstRowVisibleCells,
                            boundaryWidth,
                            minimumBoundaryCells,
                        });
                    }
                }
            }
        }
        if (continuousBoundaries.length > 0) {
            issues.push({
                type: "continuous-split-review",
                family: first.splitBase,
                panel: first.panel,
                scripts: members.map((member) => member.name),
                partCount: members.length,
                boundaryCount: continuousBoundaries.length,
                boundaryRatio:
                    continuousBoundaries.length /
                    Math.max(1, members.length - 1),
                sourceRows: `${first.sourceRowStart}-${last.sourceRowEnd}`,
                boundaries: continuousBoundaries,
            });
        }
        if (mergeablePairs.length > 0) {
            issues.push({
                type: "mergeable-adjacent-parts",
                family: first.splitBase,
                panel: first.panel,
                pairs: mergeablePairs,
            });
        }

        const tailRows = last.sourceRowEnd - last.sourceRowStart + 1;
        const totalRows = last.sourceRowEnd - first.sourceRowStart + 1;
        const minimumParts = Math.ceil(totalRows / options.maxRows);
        const previousVisibleCellCounts = members
            .slice(0, -1)
            .map((member) => member.metrics?.visibleCells)
            .filter((count) => typeof count === "number")
            .sort((left, right) => left - right);
        const medianPreviousVisibleCells =
            previousVisibleCellCounts.length === 0
                ? null
                : previousVisibleCellCounts[
                      Math.floor(previousVisibleCellCounts.length / 2)
                  ];
        const tailVisibleCellRatio =
            medianPreviousVisibleCells &&
            last.metrics &&
            medianPreviousVisibleCells > 0
                ? last.metrics.visibleCells / medianPreviousVisibleCells
                : null;
        const tailRowRatio = tailRows / options.maxRows;
        const tinyByRows =
            tailRows <= options.tinyTailRows || tailRowRatio <= 0.25;
        const tinyByVisibleCells =
            tailVisibleCellRatio !== null && tailVisibleCellRatio <= 0.15;
        if (tinyByRows || tinyByVisibleCells) {
            issues.push({
                type: "tiny-tail-part",
                family: first.splitBase,
                panel: first.panel,
                script: last.name,
                tailRows,
                tailRowRatio,
                tailVisibleCells: last.metrics?.visibleCells ?? null,
                medianPreviousVisibleCells,
                tailVisibleCellRatio,
                signals: [
                    ...(tinyByRows ? ["row-count"] : []),
                    ...(tinyByVisibleCells ? ["visible-cell-ratio"] : []),
                ],
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
        const family = record.name;
        if (!record.metrics) {
            issues.push({
                type: "analysis-error",
                family,
                script: record.name,
                error: record.analysisError,
            });
            continue;
        }
        const metrics = record.metrics;
        if (metrics.leadingBlankRows >= options.blankRun) {
            issues.push({
                type: "leading-blank-run",
                family,
                script: record.name,
                rows: metrics.leadingBlankRows,
            });
        }
        if (metrics.trailingBlankRows >= options.blankRun) {
            issues.push({
                type: "trailing-blank-run",
                family,
                script: record.name,
                rows: metrics.trailingBlankRows,
            });
        }
        if (metrics.visibleRows === 0) {
            issues.push({
                type: "blank-part",
                family,
                script: record.name,
            });
        } else if (metrics.visibleRows <= 5 || metrics.visibleCells <= 80) {
            issues.push({
                type: "very-small-output",
                family,
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
                family,
                script: record.name,
                uniqueGlyphs: metrics.uniqueGlyphs,
                uniqueStyles: metrics.uniqueStyles,
                uniqueRowPatterns: metrics.uniqueRowPatterns,
            });
        }
        if (
            metrics.visibleRows >= 10 &&
            metrics.width >= 20 &&
            metrics.cellDensity <= 0.04
        ) {
            issues.push({
                type: "sparse-cell-density",
                family,
                script: record.name,
                rows: metrics.rows,
                visibleRows: metrics.visibleRows,
                visibleCells: metrics.visibleCells,
                width: metrics.width,
                cellDensity: metrics.cellDensity,
            });
        }
        if (
            metrics.rows >= 10 &&
            metrics.asciiGlyphRatio >= 0.95 &&
            metrics.uniqueStyles <= 4
        ) {
            issues.push({
                type: "mostly-plain-ascii",
                family,
                script: record.name,
                asciiGlyphRatio: metrics.asciiGlyphRatio,
                uniqueStyles: metrics.uniqueStyles,
            });
        }
        if (
            metrics.replacementCharacters > 0 ||
            metrics.mojibakeSequences > 0
        ) {
            issues.push({
                type: "suspicious-character-decoding",
                family,
                script: record.name,
                replacementCharacters: metrics.replacementCharacters,
                mojibakeSequences: metrics.mojibakeSequences,
            });
        }
        if (metrics.dosEofCharacters > 0) {
            issues.push({
                type: "embedded-dos-eof",
                family,
                script: record.name,
                characters: metrics.dosEofCharacters,
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
        const colorMetrics = analyzeAnsiLines(
            members.flatMap((record) => record.lines)
        );
        if (
            colorMetrics.visibleRows >= 6 &&
            colorMetrics.visibleCells >= 80 &&
            colorMetrics.uniqueColorFamilies < 3
        ) {
            issues.push({
                type: "low-color-variety",
                family: members[0].splitBase || members[0].name,
                scripts: members
                    .map((record) => record.name)
                    .sort((left, right) => left.localeCompare(right)),
                visibleRows: colorMetrics.visibleRows,
                visibleCells: colorMetrics.visibleCells,
                colorFamilies: colorMetrics.colorFamilies,
                uniqueColorFamilies: colorMetrics.uniqueColorFamilies,
                coloredCellRatio: colorMetrics.coloredCellRatio,
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
        schemaVersion: 4,
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
            metrics: record.metrics
                ? Object.fromEntries(
                      Object.entries(record.metrics).filter(
                          ([key]) => key !== "rowVisibleCellCounts"
                      )
                  )
                : null,
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
small output, low terminal-cell or color complexity, character-decoding damage,
plain ASCII, continuous artwork fragments, and derivative-source attribution.
Findings are review signals, not automatic deletion decisions.

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
