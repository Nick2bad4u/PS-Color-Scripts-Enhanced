#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");
const iconv = require("iconv-lite");
const { DEFAULT_PROVENANCE_PATH } = require("./ArtworkProvenance.js");
const {
    buildGeneratedArtworkEntry,
    prepareGeneratedArtworkProvenance,
    readGeneratedArtworkTemplate,
    writeGeneratedArtworkTransaction,
} = require("./GeneratedArtworkProvenance.js");
const {
    readAnsiFile,
    convertAnsiToPs1,
    sanitizeName,
    validateSourceMetadataValue,
    validateSourceUrl,
    buildSourceMetadataHeader,
    buildPowerShellOutput,
    writePowerShellFile,
    usesDosAnsiSemantics,
    MAX_INPUT_BYTES,
    MAX_TERMINAL_COLUMNS,
} = require("./Convert-AnsiToColorScript.js");

const DEFAULT_OUTPUT_DIR = path.join(
    __dirname,
    "..",
    "ColorScripts-Enhanced",
    "Scripts"
);

/**
 * @typedef {Object} SplitOptions
 *
 * @property {string} outputDir
 * @property {string | null} outputBase
 * @property {number | null} columns
 * @property {ColumnRange[]} columnRanges
 * @property {number[]} heights
 * @property {number[]} breaks
 * @property {boolean} autoDetect
 * @property {number} gap
 * @property {number} minSegment
 * @property {"ps1" | "ansi"} format
 * @property {boolean} dryRun
 * @property {boolean} stripSpaceBackground
 * @property {"auto" | "ansi" | "ps1"} inputFormat
 * @property {number | null} segmentEvery
 * @property {"cp437" | "utf8" | null} encoding
 * @property {boolean} force
 * @property {string} provenancePath
 * @property {string | null} provenanceRecordPath
 * @property {{
 *     url: string | null;
 *     revision: string | null;
 *     sha256: string | null;
 *     license: string | null;
 *     attribution: string | null;
 *     modification: string | null;
 * }} sourceProvenance
 */

/**
 * @typedef {Object} ColumnRange
 *
 * @property {number} start Zero-based inclusive start column.
 * @property {number} end Zero-based inclusive end column.
 */

/**
 * @typedef {Object} Chunk
 *
 * @property {number} start
 * @property {number} end
 * @property {string[]} lines
 */

/**
 * @param {string} value
 *
 * @returns {number[]}
 */
function parseNumberList(value) {
    if (!value) {
        return [];
    }
    return value
        .split(",")
        .map((token) => Number.parseInt(token.trim(), 10))
        .filter((num) => !Number.isNaN(num) && num > 0);
}

/**
 * Parse one-based inclusive column ranges and reject ambiguous or overlapping
 * panel definitions.
 *
 * @param {string} value
 *
 * @returns {ColumnRange[]}
 */
function parseColumnRanges(value) {
    if (!value) {
        throw new Error("Column ranges cannot be empty.");
    }

    const ranges = value.split(",").map((token) => {
        const match = /^(\d+)-(\d+)$/u.exec(token.trim());
        if (!match) {
            throw new Error(
                `Invalid column range '${token}'. Use one-based inclusive ranges such as 1-80,81-160.`
            );
        }
        const start = Number.parseInt(match[1], 10);
        const end = Number.parseInt(match[2], 10);
        if (
            !Number.isSafeInteger(start) ||
            !Number.isSafeInteger(end) ||
            start < 1 ||
            end < start ||
            end > MAX_TERMINAL_COLUMNS
        ) {
            throw new RangeError(
                `Column ranges must be within 1-${MAX_TERMINAL_COLUMNS}, with each start no greater than its end.`
            );
        }
        return { start: start - 1, end: end - 1 };
    });

    ranges.forEach((range, index) => {
        const previous = ranges[index - 1];
        if (previous && range.start <= previous.end) {
            throw new Error(
                "Column ranges must be ordered and must not overlap."
            );
        }
    });
    return ranges;
}

/**
 * @param {string[]} argv
 *
 * @returns {{ options: SplitOptions; positional: string[] }}
 */
function createSplitOptions() {
    /** @type {SplitOptions} */
    return {
        outputDir: DEFAULT_OUTPUT_DIR,
        outputBase: null,
        columns: null,
        columnRanges: [],
        heights: [],
        breaks: [],
        autoDetect: false,
        gap: 4,
        minSegment: 60,
        format: "ps1",
        dryRun: false,
        stripSpaceBackground: false,
        inputFormat: "auto",
        segmentEvery: null,
        encoding: null,
        force: false,
        provenancePath: DEFAULT_PROVENANCE_PATH,
        provenanceRecordPath: null,
        sourceProvenance: {
            url: null,
            revision: null,
            sha256: null,
            license: null,
            attribution: null,
            modification: null,
        },
    };
}

function parseOutputBase(value) {
    const outputBase = sanitizeName(value);
    if (!outputBase) {
        throw new Error(
            "Output base must contain at least one safe filename character."
        );
    }
    return outputBase;
}

/**
 * @param {string} value
 * @param {string} option
 * @param {readonly string[]} allowed
 */
function parseChoiceOption(value, option, allowed) {
    if (!allowed.includes(value)) {
        throw new Error(`${option} must be ${allowed.join(" or ")}.`);
    }
    return value;
}

function parseSplitEncoding(value) {
    if (value === "cp437" || value === "437") return "cp437";
    if (value === "utf8" || value === "utf-8") return "utf8";
    throw new Error("--encoding must be cp437 or utf8.");
}

function parseSourceSha256(value) {
    if (!/^[a-f\d]{64}$/iu.test(value)) {
        throw new Error(
            "Source SHA-256 must contain exactly 64 hexadecimal characters."
        );
    }
    return value.toLowerCase();
}

/**
 * @param {SplitOptions} options
 * @param {string} argument
 *
 * @returns {boolean} Whether the argument was an option.
 */
function applySplitOption(options, argument) {
    const flags = new Map([
        ["--ansi", () => (options.format = "ansi")],
        ["--auto", () => (options.autoDetect = true)],
        ["--dry-run", () => (options.dryRun = true)],
        ["--force", () => (options.force = true)],
        ["--from-ps1", () => (options.inputFormat = "ps1")],
        ["--keep-space-bg", () => (options.stripSpaceBackground = false)],
        ["--ps1", () => (options.format = "ps1")],
        [
            "--strip-space-background",
            () => (options.stripSpaceBackground = true),
        ],
        ["--strip-space-bg", () => (options.stripSpaceBackground = true)],
        ["--utf8", () => (options.encoding = "utf8")],
    ]);
    const applyFlag = flags.get(argument);
    if (applyFlag) {
        applyFlag();
        return true;
    }
    if (!argument.startsWith("--")) return false;
    const optionMatch = /^--([^=]+)=(.*)$/u.exec(argument);
    if (!optionMatch) throw new Error(`Unknown option: ${argument}`);
    const [
        ,
        name,
        value,
    ] = optionMatch;
    switch (name) {
        case "output-dir":
            options.outputDir = path.resolve(value);
            return true;
        case "output-base":
            options.outputBase = parseOutputBase(value);
            return true;
        case "columns":
            options.columns = parsePositiveOption(value, options.columns);
            return true;
        case "column-ranges":
            options.columnRanges = parseColumnRanges(value);
            return true;
        case "heights":
            options.heights = parseNumberList(value);
            return true;
        case "breaks":
            options.breaks = parseNumberList(value);
            return true;
        case "gap":
            options.gap = parsePositiveOption(value, options.gap);
            return true;
        case "min-segment":
            options.minSegment = parsePositiveOption(value, options.minSegment);
            return true;
        case "every":
            options.segmentEvery = parsePositiveOption(
                value,
                options.segmentEvery
            );
            return true;
        case "format":
            options.format = parseChoiceOption(value, "--format", [
                "ps1",
                "ansi",
            ]);
            return true;
        case "input":
            options.inputFormat = parseChoiceOption(value, "--input", [
                "ps1",
                "ansi",
            ]);
            return true;
        case "encoding":
            options.encoding = parseSplitEncoding(value);
            return true;
        case "provenance-record":
            options.provenanceRecordPath = path.resolve(value);
            return true;
        case "provenance-path":
            options.provenancePath = path.resolve(value);
            return true;
        case "source-url":
            options.sourceProvenance.url = validateSourceUrl(value);
            return true;
        case "source-revision":
            options.sourceProvenance.revision = validateSourceMetadataValue(
                value,
                "Source revision",
                256
            );
            return true;
        case "source-sha256":
            options.sourceProvenance.sha256 = parseSourceSha256(value);
            return true;
        case "source-license":
            options.sourceProvenance.license = validateSourceMetadataValue(
                value,
                "Source license",
                256
            );
            return true;
        case "source-attribution":
            options.sourceProvenance.attribution = validateSourceMetadataValue(
                value,
                "Source attribution",
                1024
            );
            return true;
        case "source-modification":
            options.sourceProvenance.modification = validateSourceMetadataValue(
                value,
                "Source modification",
                1024
            );
            return true;
        default:
            throw new Error(`Unknown option: ${argument}`);
    }
}

/**
 * Preserve the prior CLI behavior: invalid non-positive numeric overrides are
 * ignored and leave the default value unchanged.
 *
 * @param {string} value
 * @param {number | null} fallback
 */
function parsePositiveOption(value, fallback) {
    const parsed = Number.parseInt(value, 10);
    return !Number.isNaN(parsed) && parsed > 0 ? parsed : fallback;
}

/**
 * @param {string[]} argv
 *
 * @returns {{ options: SplitOptions; positional: string[] }}
 */
function parseArguments(argv) {
    const options = createSplitOptions();
    /** @type {string[]} */
    const positional = [];

    let optionsEnded = false;
    for (const arg of argv) {
        if (!optionsEnded && arg === "--") {
            optionsEnded = true;
            continue;
        }
        if (!optionsEnded && applySplitOption(options, arg)) continue;
        positional.push(arg);
    }

    return { options, positional };
}

/**
 * @param {string} filePath
 *
 * @returns {string[]}
 */
function extractLinesFromPs1(filePath) {
    if (fs.statSync(filePath).size > MAX_INPUT_BYTES) {
        throw new RangeError(
            `PowerShell input exceeds the ${MAX_INPUT_BYTES}-byte safety limit.`
        );
    }
    const text = fs.readFileSync(filePath, "utf8");
    const safeLiteralPattern = /Write-Host\s+'((?:[^']|'')*)'/m;
    const safeLiteralMatch = safeLiteralPattern.exec(text);
    if (safeLiteralMatch) {
        return safeLiteralMatch[1]
            .replaceAll("''", "'")
            .replaceAll(/\r\n?/g, "\n")
            .split("\n");
    }

    const safeHereStringPattern = /Write-Host\s+@'\r?\n([\s\S]*?)\r?\n'@/m;
    const safeHereStringMatch = safeHereStringPattern.exec(text);
    if (safeHereStringMatch) {
        return safeHereStringMatch[1].replaceAll(/\r\n?/g, "\n").split("\n");
    }

    // Continue to accept colorscripts generated by older releases.
    const legacyHereStringPattern = /Write-Host\s+@"\r?\n([\s\S]*?)\r?\n"@/m;
    const legacyMatch = legacyHereStringPattern.exec(text);
    if (legacyMatch) {
        return legacyMatch[1].replaceAll(/\r\n?/g, "\n").split("\n");
    }

    throw new Error(
        `Unable to locate a supported Write-Host literal in ${filePath}.`
    );
}

/**
 * @param {number} totalLines
 * @param {SplitOptions} options
 * @param {string[]} lines
 *
 * @returns {number[]}
 */
function determineBreaks(totalLines, options, lines) {
    const breaks = new Set();

    addHeightBreaks(breaks, options.heights, totalLines);
    for (const value of options.breaks) {
        if (value > 0 && value < totalLines) breaks.add(value);
    }
    addPeriodicBreaks(breaks, options.segmentEvery, totalLines);
    if (options.autoDetect && Array.isArray(lines)) {
        addDetectedBlankBreaks(breaks, lines, totalLines, options);
    }

    return [...breaks].sort((a, b) => a - b);
}

/**
 * @param {Set<number>} breaks
 * @param {number[]} heights
 * @param {number} totalLines
 */
function addHeightBreaks(breaks, heights, totalLines) {
    let accumulated = 0;
    for (const segmentHeight of heights) {
        accumulated += segmentHeight;
        if (accumulated > 0 && accumulated < totalLines) {
            breaks.add(accumulated);
        }
    }
}

/**
 * @param {Set<number>} breaks
 * @param {number | null} interval
 * @param {number} totalLines
 */
function addPeriodicBreaks(breaks, interval, totalLines) {
    if (!interval || interval < 1) return;
    for (let position = interval; position < totalLines; position += interval) {
        breaks.add(position);
    }
}

/**
 * @param {Set<number>} breaks
 * @param {string[]} lines
 * @param {number} totalLines
 * @param {SplitOptions} options
 */
function addDetectedBlankBreaks(breaks, lines, totalLines, options) {
    let runLength = 0;
    for (let index = 0; index < lines.length; index += 1) {
        const isBlank = (lines[index] || "").trim().length === 0;
        if (isBlank) {
            runLength += 1;
            continue;
        }
        const isUsableBoundary =
            runLength >= options.gap &&
            index >= options.minSegment &&
            index < totalLines - options.minSegment;
        if (isUsableBoundary) breaks.add(index);
        runLength = 0;
    }
}

/**
 * @param {number} totalLines
 * @param {number} maxRows
 * @param {number[]} preferredBreakpoints
 *
 * @returns {Set<number>}
 */
function validateBalancedSplitInputs(
    totalLines,
    maxRows,
    preferredBreakpoints
) {
    if (
        !Number.isSafeInteger(totalLines) ||
        !Number.isSafeInteger(maxRows) ||
        totalLines < 1 ||
        maxRows < 1
    ) {
        throw new RangeError(
            "Balanced splitting requires positive safe-integer row counts."
        );
    }
    if (!Array.isArray(preferredBreakpoints)) {
        throw new TypeError("Preferred breakpoints must be an array.");
    }
    const preferred = new Set();
    for (const breakpoint of preferredBreakpoints) {
        if (
            !Number.isSafeInteger(breakpoint) ||
            breakpoint < 1 ||
            breakpoint >= totalLines
        ) {
            throw new RangeError(
                "Preferred breakpoints must be safe integers within the artwork."
            );
        }
        preferred.add(breakpoint);
    }
    return preferred;
}

/**
 * @param {number} previousEnd
 * @param {number} remainingSegments
 * @param {{ totalLines: number; maxRows: number; minimumRows: number }} limits
 *
 * @returns {{ minimum: number; maximum: number }}
 */
function getBalancedLengthRange(previousEnd, remainingSegments, limits) {
    return {
        minimum: Math.max(
            limits.minimumRows,
            limits.totalLines - previousEnd - remainingSegments * limits.maxRows
        ),
        maximum: Math.min(
            limits.maxRows,
            limits.totalLines -
                previousEnd -
                remainingSegments * limits.minimumRows
        ),
    };
}

/**
 * @param {{ cost: number; breaks: number[] } | undefined} existing
 * @param {{ cost: number; breaks: number[] }} candidate
 *
 * @returns {boolean}
 */
function isBetterBalancedState(existing, candidate) {
    return (
        !existing ||
        candidate.cost < existing.cost ||
        (candidate.cost === existing.cost &&
            winsTie(candidate.breaks, existing.breaks))
    );
}

/**
 * @param {Map<number, { cost: number; breaks: number[] }>} nextStates
 * @param {number} previousEnd
 * @param {{ cost: number; breaks: number[] }} state
 * @param {number} remainingSegments
 * @param {{
 *     totalLines: number;
 *     maxRows: number;
 *     minimumRows: number;
 *     partCount: number;
 *     nonPreferredPenalty: number;
 *     preferred: Set<number>;
 * }} context
 */
function addBalancedTransitions(
    nextStates,
    previousEnd,
    state,
    remainingSegments,
    context
) {
    const range = getBalancedLengthRange(
        previousEnd,
        remainingSegments,
        context
    );
    const isFinal = remainingSegments === 0;
    for (let length = range.minimum; length <= range.maximum; length += 1) {
        const end = previousEnd + length;
        const invalidEnd = isFinal
            ? end !== context.totalLines
            : end >= context.totalLines;
        if (invalidEnd) continue;
        const scaledDeviation = length * context.partCount - context.totalLines;
        const candidate = {
            cost:
                state.cost +
                8 * scaledDeviation ** 2 +
                (isFinal || context.preferred.has(end)
                    ? 0
                    : context.nonPreferredPenalty),
            breaks: isFinal ? state.breaks : [...state.breaks, end],
        };
        if (isBetterBalancedState(nextStates.get(end), candidate)) {
            nextStates.set(end, candidate);
        }
    }
}

/**
 * @param {Map<number, { cost: number; breaks: number[] }>} states
 * @param {number} remainingSegments
 * @param {Parameters<typeof addBalancedTransitions>[4]} context
 *
 * @returns {Map<number, { cost: number; breaks: number[] }>}
 */
function advanceBalancedStates(states, remainingSegments, context) {
    const nextStates = new Map();
    for (const [previousEnd, state] of states) {
        addBalancedTransitions(
            nextStates,
            previousEnd,
            state,
            remainingSegments,
            context
        );
    }
    return nextStates;
}

/**
 * Choose the minimum number of row breaks needed to keep every part within the
 * requested height. The optimizer considers the full work at once, preventing a
 * locally attractive blank-row cut from leaving a tiny final part.
 *
 * Preferred breakpoints are normally the rows immediately after visible blank
 * rows or reviewed compositional transitions. They receive a bounded scoring
 * preference, but balance and the hard maximum remain authoritative.
 *
 * @param {number} totalLines
 * @param {number} [maxRows]
 * @param {number[]} [preferredBreakpoints]
 *
 * @returns {number[]}
 */
function chooseBalancedBreaks(
    totalLines,
    maxRows = 50,
    preferredBreakpoints = []
) {
    const preferred = validateBalancedSplitInputs(
        totalLines,
        maxRows,
        preferredBreakpoints
    );
    const partCount = Math.ceil(totalLines / maxRows);
    if (partCount === 1) return [];
    const targetRows = totalLines / partCount;
    const context = {
        totalLines,
        maxRows,
        minimumRows: Math.max(1, Math.floor(targetRows * 0.6)),
        partCount,
        nonPreferredPenalty: totalLines ** 2,
        preferred,
    };
    /** @type {Map<number, { cost: number; breaks: number[] }>} */
    let states = new Map([[0, { cost: 0, breaks: [] }]]);
    for (let segment = 1; segment <= partCount; segment += 1) {
        states = advanceBalancedStates(states, partCount - segment, context);
    }
    const result = states.get(totalLines);
    if (!result) {
        throw new Error(
            "Unable to produce a balanced split within the requested row limit."
        );
    }
    return result.breaks;
}

/**
 * Prefer larger earlier segments when two complete plans have exactly the same
 * score. This matches the conventional even split where remainder rows are
 * assigned from the first part onward.
 *
 * @param {number[]} candidate
 * @param {number[]} current
 *
 * @returns {boolean}
 */
function winsTie(candidate, current) {
    for (let index = 0; index < candidate.length; index += 1) {
        if (candidate[index] !== current[index]) {
            return candidate[index] > current[index];
        }
    }
    return false;
}

/**
 * @param {string[]} lines
 * @param {number[]} breakpoints
 *
 * @returns {Chunk[]}
 */
function splitLines(lines, breakpoints) {
    /** @type {Chunk[]} */
    const chunks = [];
    let start = 0;
    const sortedBreaks = [...breakpoints, lines.length];

    sortedBreaks.forEach((end) => {
        if (end <= start) {
            return;
        }
        const slice = lines.slice(start, end);
        chunks.push({ start, end, lines: slice });
        start = end;
    });

    return chunks;
}

/**
 * @param {string} content
 *
 * @returns {string}
 */
function ensureTrailingReset(content) {
    if (content.trimEnd().endsWith("\u001b[0m")) {
        return content;
    }
    let bodyEnd = content.length;
    while (bodyEnd > 0 && content[bodyEnd - 1] === "\n") {
        bodyEnd -= 1;
        if (bodyEnd > 0 && content[bodyEnd - 1] === "\r") {
            bodyEnd -= 1;
        }
    }
    const trailingLineBreaks = content.slice(bodyEnd);
    const body = trailingLineBreaks ? content.slice(0, bodyEnd) : content;
    return `${body}\u001b[0m${trailingLineBreaks}`;
}

/**
 * @param {Chunk} chunk
 * @param {{
 *     sourceName: string;
 *     sourceEncoding?: string;
 *     sauce?: object | null;
 *     sourceProvenance?: {
 *         url?: string | null;
 *         revision?: string | null;
 *         sha256?: string | null;
 *         license?: string | null;
 *         attribution?: string | null;
 *         modification?: string | null;
 *     };
 *     sourceColumns?: string | null;
 *     compactHeader?: string | null;
 * }} baseInfo
 *
 * @returns {string}
 */
function buildChunkPs1(chunk, baseInfo) {
    const joined = chunk.lines.join("\n");
    const normalized = ensureTrailingReset(joined);
    if (baseInfo.compactHeader) {
        return `${baseInfo.compactHeader}\n\n${buildPowerShellOutput(normalized, { startOnNewLine: true })}`;
    }
    const header = [
        buildSourceMetadataHeader(
            baseInfo.sourceName,
            baseInfo.sourceEncoding || "unknown",
            baseInfo.sauce || null,
            baseInfo.sourceProvenance || {}
        ).trimEnd(),
        `# Lines: ${chunk.start + 1}-${chunk.end}`,
    ].join("\n");
    const coordinateHeader = baseInfo.sourceColumns
        ? `${header}\n# Columns: ${baseInfo.sourceColumns}`
        : header;
    return `${coordinateHeader}\n\n${buildPowerShellOutput(normalized, { startOnNewLine: true })}`;
}

/**
 * @param {string} outputPath
 * @param {Chunk} chunk
 * @param {{
 *     sourceName: string;
 *     sourceEncoding?: string;
 *     sauce?: object | null;
 *     sourceProvenance?: {
 *         url?: string | null;
 *         revision?: string | null;
 *         sha256?: string | null;
 *         license?: string | null;
 *         attribution?: string | null;
 *         modification?: string | null;
 *     };
 *     sourceColumns?: string | null;
 *     compactHeader?: string | null;
 * }} baseInfo
 *
 * @returns {void}
 */
function writeChunkPs1(outputPath, chunk, baseInfo) {
    writePowerShellFile(outputPath, buildChunkPs1(chunk, baseInfo));
}

/**
 * @param {string} outputPath
 * @param {Chunk} chunk
 *
 * @returns {void}
 */
function writeChunkAnsi(outputPath, chunk, encoding = "utf8") {
    const joined = chunk.lines.join("\n");
    const normalized = ensureTrailingReset(joined);
    if (encoding === "cp437") {
        fs.writeFileSync(outputPath, iconv.encode(normalized, "cp437"));
    } else {
        fs.writeFileSync(outputPath, normalized, "utf8");
    }
}

/**
 * @param {string} baseName
 * @param {number} index
 * @param {string} extension
 *
 * @returns {string}
 */
function formatChunkName(baseName, index, extension) {
    const suffix = String(index + 1).padStart(2, "0");
    return `${baseName}-part${suffix}.${extension}`;
}

/**
 * @param {string} baseName
 * @param {number} panelIndex
 * @param {number} partIndex
 * @param {number} partCount
 * @param {string} extension
 *
 * @returns {string}
 */
function formatPanelChunkName(
    baseName,
    panelIndex,
    partIndex,
    partCount,
    extension
) {
    const panelSuffix = String(panelIndex + 1).padStart(2, "0");
    if (partCount === 1) {
        return `${baseName}-panel${panelSuffix}.${extension}`;
    }
    const partSuffix = String(partIndex + 1).padStart(2, "0");
    return `${baseName}-panel${panelSuffix}-part${partSuffix}.${extension}`;
}

/**
 * @param {Chunk[]} chunks
 *
 * @returns {string[]}
 */
function describeChunks(chunks) {
    return chunks.map(
        (chunk, index) =>
            `  [${String(index + 1).padStart(2, "0")}] rows ${chunk.start + 1}–${chunk.end} (${chunk.end - chunk.start})`
    );
}

function printSplitUsage() {
    console.error(`Usage: node scripts/Split-AnsiFile.js [options] <ansi-file>
Options:
  --output-dir=<path>        Where to place generated files
  --output-base=<name>       Override the generated filename prefix
  --format=ps1|ansi          Output format (default: ps1)
  --columns=<n>              Override SAUCE width for ANSI input
  --column-ranges=1-80,...   Emit cell-sliced logical panels
  --strip-space-bg           Clear backgrounds on plain spaces
  --heights=h1,h2,...        Segment heights (cumulative)
  --every=<n>                Split after every n lines
  --breaks=b1,b2,...         Absolute one-based row breakpoints
  --auto                     Enable automatic break detection
  --gap=<n>                  Blank-line run for automatic breaks
  --min-segment=<n>          Minimum rows around automatic breaks
  --input=ansi|ps1           Force input interpretation
  --encoding=cp437|utf8      Input and ANSI-output encoding
  --dry-run                  Report without writing files
  --force                    Replace existing outputs
  --source-url=<url>         Original artwork URL
  --source-revision=<id>     Source revision or archive identifier
  --source-sha256=<hash>     Original artwork SHA-256
  --source-license=<id>      Source license identifier
  --source-attribution=<text> Source attribution
  --source-modification=<text> Source modification description
  --provenance-record=<json> Upsert complete external provenance
  --provenance-path=<psd1>   Override authoritative provenance data`);
}

/**
 * @param {string} ansiPath
 * @param {SplitOptions} options
 */
function resolveInputFormat(ansiPath, options) {
    if (options.inputFormat !== "auto") return options.inputFormat;
    return path.extname(ansiPath).toLowerCase() === ".ps1" ? "ps1" : "ansi";
}

/**
 * @param {SplitOptions} options
 * @param {"ansi" | "ps1"} inputFormat
 */
function loadProvenanceTemplate(options, inputFormat) {
    if (!options.provenanceRecordPath) return null;
    const template = readGeneratedArtworkTemplate(options.provenanceRecordPath);
    if (inputFormat !== "ansi" || options.format !== "ps1") {
        throw new Error(
            "--provenance-record requires ANSI/ICE input and PowerShell output."
        );
    }
    if (
        Object.values(options.sourceProvenance).some((value) => value !== null)
    ) {
        throw new Error(
            "--provenance-record cannot be combined with legacy --source-* header options. Put those values in the JSON record."
        );
    }
    return template;
}

/**
 * @param {string} ansiPath
 * @param {SplitOptions} options
 * @param {"ansi" | "ps1"} inputFormat
 * @param {string} sourceEncoding
 */
function loadSplitPanels(ansiPath, options, inputFormat, sourceEncoding) {
    if (inputFormat === "ps1") {
        if (options.columnRanges.length > 0) {
            throw new Error(
                "--column-ranges requires ANSI or ICE input so panels can be sliced from terminal cells."
            );
        }
        if (options.stripSpaceBackground) {
            console.warn(
                "Warning: --strip-space-bg has no effect when splitting a PowerShell script input."
            );
        }
        return {
            fullSourceColumns: null,
            panels: [extractLinesFromPs1(ansiPath)],
            sauce: null,
        };
    }
    const ansiFile = readAnsiFile(ansiPath, sourceEncoding);
    const columns = options.columns || ansiFile.sauce?.tInfo1 || null;
    const converted = convertAnsiToPs1(ansiFile.content, {
        columns: columns || undefined,
        stripSpaceBackground: options.stripSpaceBackground,
        iceColors: Boolean(ansiFile.sauce?.flags & 1),
        dosAnsi: usesDosAnsiSemantics(sourceEncoding),
    });
    if (options.columnRanges.length > 0) {
        converted.terminal.recalculateBounds();
        const lastColumn = options.columnRanges.at(-1).end;
        const availableColumns = Math.max(
            converted.terminal.maxCol,
            converted.terminal.columns - 1
        );
        if (lastColumn > availableColumns) {
            throw new RangeError(
                "A requested column range extends beyond the declared or rendered terminal width."
            );
        }
    }
    return {
        fullSourceColumns: columns || 80,
        panels:
            options.columnRanges.length > 0
                ? options.columnRanges.map((range) =>
                      converted.terminal.buildLines(range)
                  )
                : [converted.lines],
        sauce: ansiFile.sauce,
    };
}

/**
 * @param {string[][]} panels
 * @param {SplitOptions} options
 */
function buildPanelChunks(panels, options) {
    return panels.map((panelLines, panelIndex) => ({
        panelIndex,
        range: options.columnRanges[panelIndex] || null,
        chunks: splitLines(
            panelLines,
            determineBreaks(panelLines.length, options, panelLines)
        ),
    }));
}

/**
 * @param {ReturnType<typeof buildPanelChunks>} panelChunks
 */
function printSplitPlan(panelChunks) {
    for (const panel of panelChunks) {
        console.log(
            panel.range
                ? `Panel ${panel.panelIndex + 1}: columns ${panel.range.start + 1}-${panel.range.end + 1}`
                : "Chunks:"
        );
        for (const line of describeChunks(panel.chunks)) console.log(line);
    }
}

/**
 * @param {ReturnType<typeof buildPanelChunks>} panelChunks
 * @param {string} baseName
 * @param {string} outputDir
 * @param {string} extension
 */
function buildSplitOutputs(panelChunks, baseName, outputDir, extension) {
    return panelChunks.flatMap((panel) =>
        panel.chunks.map((chunk, partIndex) => ({
            chunk,
            range: panel.range,
            outputPath: path.join(
                outputDir,
                panel.range
                    ? formatPanelChunkName(
                          baseName,
                          panel.panelIndex,
                          partIndex,
                          panel.chunks.length,
                          extension
                      )
                    : formatChunkName(baseName, partIndex, extension)
            ),
        }))
    );
}

/**
 * @param {ReturnType<typeof buildSplitOutputs>} outputs
 * @param {SplitOptions} options
 * @param {string} outputDir
 */
function prepareOutputDirectory(outputs, options, outputDir) {
    if (!options.force) {
        const existingOutput = outputs
            .map(({ outputPath }) => outputPath)
            .find((outputPath) => fs.existsSync(outputPath));
        if (existingOutput) {
            throw new Error(
                `Output file already exists: ${existingOutput}. Use --force to replace it.`
            );
        }
    }
    fs.mkdirSync(outputDir, { recursive: true });
}

/**
 * @param {ReturnType<typeof buildSplitOutputs>} outputs
 * @param {Readonly<
 *     Record<string, import("./ArtworkProvenance.js").ProvenanceValue>
 * >} provenanceTemplate
 * @param {{
 *     fullSourceColumns: number | null;
 *     sauce: import("./Convert-AnsiToColorScript.js").SauceRecord | null;
 * }} source
 * @param {string} ansiPath
 * @param {string} sourceEncoding
 * @param {SplitOptions} options
 */
function writeProvenanceOutputs(
    outputs,
    provenanceTemplate,
    source,
    ansiPath,
    sourceEncoding,
    options
) {
    const sourceBuffer = fs.readFileSync(ansiPath);
    const entries = new Map();
    for (const { chunk, range, outputPath } of outputs) {
        const scriptName = path.basename(outputPath, ".ps1");
        const sourceColumns = range
            ? `${range.start + 1}-${range.end + 1}`
            : `1-${source.fullSourceColumns || 80}`;
        entries.set(
            scriptName,
            buildGeneratedArtworkEntry({
                conversionMode: "TerminalEmulation",
                name: scriptName,
                sauce: source.sauce,
                sourceBuffer,
                sourceColumns,
                sourceEncoding,
                sourceName: ansiPath,
                sourceRows: `${chunk.start + 1}-${chunk.end}`,
                template: provenanceTemplate,
            })
        );
    }
    const prepared = prepareGeneratedArtworkProvenance(
        options.provenancePath,
        entries
    );
    const scripts = new Map();
    for (const { chunk, range, outputPath } of outputs) {
        const scriptName = path.basename(outputPath, ".ps1");
        scripts.set(
            path.resolve(outputPath),
            buildChunkPs1(chunk, {
                compactHeader: prepared.headers.get(scriptName),
                sauce: source.sauce,
                sourceColumns: range
                    ? `${range.start + 1}-${range.end + 1}`
                    : `1-${source.fullSourceColumns || 80}`,
                sourceEncoding,
                sourceName: path.basename(ansiPath),
            })
        );
    }
    writeGeneratedArtworkTransaction(
        options.provenancePath,
        prepared.provenanceSource,
        scripts
    );
}

/**
 * @param {ReturnType<typeof buildSplitOutputs>} outputs
 * @param {{
 *     fullSourceColumns: number | null;
 *     sauce: import("./Convert-AnsiToColorScript.js").SauceRecord | null;
 * }} source
 * @param {string} ansiPath
 * @param {string} sourceEncoding
 * @param {SplitOptions} options
 */
function writeStandardOutputs(
    outputs,
    source,
    ansiPath,
    sourceEncoding,
    options
) {
    for (const { chunk, range, outputPath } of outputs) {
        if (options.format === "ansi") {
            writeChunkAnsi(outputPath, chunk, sourceEncoding);
            continue;
        }
        let sourceColumns = null;
        if (range) {
            sourceColumns = `${range.start + 1}-${range.end + 1}`;
        } else if (source.fullSourceColumns) {
            sourceColumns = `1-${source.fullSourceColumns}`;
        }
        writeChunkPs1(outputPath, chunk, {
            sourceName: path.basename(ansiPath),
            sourceEncoding,
            sauce: source.sauce,
            sourceProvenance: options.sourceProvenance,
            sourceColumns,
        });
    }
}

/**
 * @param {string[]} [argv]
 *
 * @returns {void}
 */
function main(argv = process.argv.slice(2)) {
    const { options, positional } = parseArguments(argv);
    if (positional.length === 0) {
        printSplitUsage();
        process.exit(1);
    }

    const ansiPath = path.resolve(positional[0]);
    if (!fs.existsSync(ansiPath)) {
        console.error(`Input file not found: ${ansiPath}`);
        process.exit(1);
    }

    const inputFormat = resolveInputFormat(ansiPath, options);
    const provenanceTemplate = loadProvenanceTemplate(options, inputFormat);
    const sourceEncoding =
        options.encoding || (inputFormat === "ansi" ? "cp437" : "utf8");
    const source = loadSplitPanels(
        ansiPath,
        options,
        inputFormat,
        sourceEncoding
    );
    const panelChunks = buildPanelChunks(source.panels, options);
    const chunks = panelChunks.flatMap((panel) => panel.chunks);

    if (chunks.length === 0) {
        console.error("No content generated.");
        process.exit(1);
    }

    const baseName =
        options.outputBase ||
        sanitizeName(path.basename(ansiPath, path.extname(ansiPath)));
    if (!baseName) {
        throw new Error(
            `Input filename cannot form a safe colorscript name: ${path.basename(ansiPath)}`
        );
    }
    const outputDir = path.resolve(options.outputDir);

    console.log(`Input file : ${ansiPath}`);
    console.log(`Input mode : ${inputFormat.toUpperCase()}`);
    console.log(`Total lines: ${source.panels[0].length}`);
    printSplitPlan(panelChunks);

    if (options.dryRun) {
        console.log("Dry run complete; no files written.");
        return;
    }

    const extension = options.format === "ansi" ? "ans" : "ps1";
    const outputs = buildSplitOutputs(
        panelChunks,
        baseName,
        outputDir,
        extension
    );
    prepareOutputDirectory(outputs, options, outputDir);

    if (provenanceTemplate) {
        writeProvenanceOutputs(
            outputs,
            provenanceTemplate,
            source,
            ansiPath,
            sourceEncoding,
            options
        );
    } else {
        writeStandardOutputs(
            outputs,
            source,
            ansiPath,
            sourceEncoding,
            options
        );
    }
    outputs.forEach(({ outputPath }) => console.log(`  → ${outputPath}`));

    console.log("Split complete.");
}

if (require.main === module) {
    main();
}

module.exports = {
    parseArguments,
    parseColumnRanges,
    extractLinesFromPs1,
    determineBreaks,
    chooseBalancedBreaks,
    splitLines,
    ensureTrailingReset,
    buildChunkPs1,
    writeChunkPs1,
    writeChunkAnsi,
    formatPanelChunkName,
    main,
};
