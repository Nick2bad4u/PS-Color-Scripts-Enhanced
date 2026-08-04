#!/usr/bin/env node

import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import process from "node:process";
import { createRequire } from "node:module";
import { fileURLToPath } from "node:url";

const require = createRequire(import.meta.url);
const {
    MAX_TERMINAL_COLUMNS,
    convertAnsiToPs1,
    readAnsiFile,
} = require("./Convert-AnsiToColorScript.js");
const { fingerprintTerminal } = require("./Audit-AnsiArchives.js");
const { extractLinesFromPs1 } = require("./Split-AnsiFile.js");
const { readArtworkProvenance } = require("./ArtworkProvenance.js");

const SOURCE_ROWS = /^# Lines:\s*(\d+)-(\d+)\s*$/mu;
const SOURCE_COLUMNS = /^# Columns:\s*(\d+)-(\d+)\s*$/mu;
const SOURCE_SHA256 = /^# Source SHA-256:\s*([a-f\d]{64})\s*$/imu;
const scriptDirectory = path.dirname(fileURLToPath(import.meta.url));
const repositoryRoot = path.resolve(scriptDirectory, "..");
const defaultScriptsDirectory = path.join(
    repositoryRoot,
    "ColorScripts-Enhanced",
    "Scripts"
);
let checkedInProvenance = null;

function getCheckedInProvenance() {
    checkedInProvenance ??= readArtworkProvenance();
    return checkedInProvenance;
}

/**
 * @param {Buffer | string} value
 *
 * @returns {string}
 */
function sha256(value) {
    return crypto.createHash("sha256").update(value).digest("hex");
}

/**
 * @param {string[]} argv
 *
 * @returns {{
 *     allowPartial: boolean;
 *     columns: number | null;
 *     encoding: string;
 *     help: boolean;
 *     iceColors: boolean | null;
 *     jsonPath: string | null;
 *     prefix: string | null;
 *     scriptPaths: string[];
 *     scriptsDirectory: string;
 *     sourcePath: string | null;
 * }}
 */
function parseArguments(argv) {
    const options = {
        allowPartial: false,
        columns: null,
        encoding: "cp437",
        help: false,
        iceColors: null,
        jsonPath: null,
        prefix: null,
        scriptPaths: [],
        scriptsDirectory: defaultScriptsDirectory,
        sourcePath: null,
    };
    for (let index = 0; index < argv.length; index += 1) {
        const argument = argv[index];
        const takeValue = (option) => {
            const separator = argument.indexOf("=");
            if (separator >= 0) return argument.slice(separator + 1);
            const value = argv[index + 1];
            if (!value || value.startsWith("--")) {
                throw new Error(`${option} requires a value.`);
            }
            index += 1;
            return value;
        };
        if (argument === "--help" || argument === "-h") {
            options.help = true;
        } else if (
            argument === "--allow-partial" ||
            argument === "--no-coverage-check"
        ) {
            options.allowPartial = true;
        } else if (
            argument === "--source" ||
            argument.startsWith("--source=")
        ) {
            options.sourcePath = path.resolve(takeValue("--source"));
        } else if (
            argument === "--script" ||
            argument.startsWith("--script=")
        ) {
            options.scriptPaths.push(path.resolve(takeValue("--script")));
        } else if (
            argument === "--scripts-dir" ||
            argument.startsWith("--scripts-dir=")
        ) {
            options.scriptsDirectory = path.resolve(takeValue("--scripts-dir"));
        } else if (
            argument === "--prefix" ||
            argument.startsWith("--prefix=")
        ) {
            const prefix = takeValue("--prefix");
            if (!/^[a-z\d][a-z\d-]*$/iu.test(prefix)) {
                throw new Error(
                    "--prefix must be a colorscript filename prefix without path separators."
                );
            }
            options.prefix = prefix;
        } else if (
            argument === "--encoding" ||
            argument.startsWith("--encoding=")
        ) {
            const encoding = takeValue("--encoding");
            if (!/^[a-z\d_-]+$/iu.test(encoding)) {
                throw new Error("--encoding contains unsupported characters.");
            }
            options.encoding = encoding;
        } else if (
            argument === "--columns" ||
            argument.startsWith("--columns=")
        ) {
            const columns = Number(takeValue("--columns"));
            if (
                !Number.isSafeInteger(columns) ||
                columns < 1 ||
                columns > MAX_TERMINAL_COLUMNS
            ) {
                throw new RangeError(
                    `--columns must be between 1 and ${MAX_TERMINAL_COLUMNS}.`
                );
            }
            options.columns = columns;
        } else if (argument === "--ice-colors") {
            options.iceColors = true;
        } else if (argument === "--no-ice-colors") {
            options.iceColors = false;
        } else if (argument === "--json" || argument.startsWith("--json=")) {
            options.jsonPath = path.resolve(takeValue("--json"));
        } else if (argument.startsWith("--")) {
            throw new Error(`Unknown option: ${argument}`);
        } else {
            throw new Error(
                `Unexpected positional argument: ${argument}. Use --source and --script.`
            );
        }
    }
    if (options.scriptPaths.length > 0 && options.prefix) {
        throw new Error("Use either repeated --script options or --prefix.");
    }
    return options;
}

/**
 * @param {string[]} lines
 *
 * @returns {string}
 */
function fingerprintLines(lines) {
    const terminal = convertAnsiToPs1(lines.join("\r\n"), {
        autoWrap: false,
        columns: MAX_TERMINAL_COLUMNS,
        minimumRows: lines.length,
        stripSpaceBackground: false,
    }).terminal;
    return fingerprintTerminal(terminal).renderSha256;
}

/**
 * @param {string[]} expectedLines
 * @param {string[]} actualLines
 * @param {number} sourceRowStart
 *
 * @returns {number[]}
 */
function findMismatchedRows(expectedLines, actualLines, sourceRowStart) {
    const mismatchedRows = [];
    const rowCount = Math.max(expectedLines.length, actualLines.length);
    for (let index = 0; index < rowCount; index += 1) {
        const expected = expectedLines[index];
        const actual = actualLines[index];
        if (
            expected === undefined ||
            actual === undefined ||
            fingerprintLines([expected]) !== fingerprintLines([actual])
        ) {
            mismatchedRows.push(sourceRowStart + index);
        }
    }
    return mismatchedRows;
}

/**
 * @param {{
 *     columnEnd: number;
 *     columnStart: number;
 *     rowEnd: number;
 *     rowStart: number;
 * }[]} coordinates
 * @param {number} sourceWidth
 * @param {number} sourceHeight
 *
 * @returns {{
 *     complete: boolean;
 *     columnRanges: string[];
 *     problems: string[];
 * }}
 */
function analyzeCoverage(coordinates, sourceWidth, sourceHeight) {
    const groups = Map.groupBy(
        coordinates,
        (coordinate) => `${coordinate.columnStart}-${coordinate.columnEnd}`
    );
    const problems = [];
    const columnRanges = [];
    for (const [columnRange, members] of groups) {
        columnRanges.push(columnRange);
        members.sort(
            (left, right) =>
                left.rowStart - right.rowStart || left.rowEnd - right.rowEnd
        );
        let expectedStart = 1;
        for (const member of members) {
            if (member.rowStart !== expectedStart) {
                problems.push(
                    `${columnRange} has a row gap or overlap before ${member.rowStart}.`
                );
            }
            expectedStart = member.rowEnd + 1;
        }
        if (expectedStart !== sourceHeight + 1) {
            problems.push(
                `${columnRange} ends at row ${expectedStart - 1}, not source row ${sourceHeight}.`
            );
        }
    }
    const parsedColumnRanges = columnRanges
        .map((range) => range.split("-").map(Number))
        .sort(([leftStart], [rightStart]) => leftStart - rightStart);
    let expectedColumnStart = 1;
    for (const [columnStart, columnEnd] of parsedColumnRanges) {
        if (columnStart !== expectedColumnStart) {
            problems.push(
                `Column coverage has a gap or overlap before column ${columnStart}.`
            );
        }
        expectedColumnStart = columnEnd + 1;
    }
    if (expectedColumnStart !== sourceWidth + 1) {
        problems.push(
            `Column coverage ends at ${expectedColumnStart - 1}, not source column ${sourceWidth}.`
        );
    }
    return {
        complete: problems.length === 0,
        columnRanges: columnRanges.sort((left, right) =>
            left.localeCompare(right, undefined, { numeric: true })
        ),
        problems,
    };
}

/**
 * @param {{
 *     allowPartial?: boolean;
 *     columns?: number | null;
 *     encoding?: string;
 *     iceColors?: boolean | null;
 *     scriptPaths: string[];
 *     sourcePath: string;
 * }} options
 *
 * @returns {{
 *     schemaVersion: number;
 *     source: Record<string, unknown>;
 *     coverage: ReturnType<typeof analyzeCoverage>;
 *     parts: Record<string, unknown>[];
 *     matches: boolean;
 * }}
 */
function verifyAnsiConversion(options) {
    const sourcePath = path.resolve(options.sourcePath);
    if (!fs.existsSync(sourcePath)) {
        throw new Error(`ANSI source file does not exist: ${sourcePath}`);
    }
    if (
        !Array.isArray(options.scriptPaths) ||
        options.scriptPaths.length === 0
    ) {
        throw new Error(
            "At least one generated PowerShell script is required."
        );
    }
    const { content, sauce } = readAnsiFile(
        sourcePath,
        options.encoding || "cp437"
    );
    const raw = fs.readFileSync(sourcePath);
    const sourceSha256 = sha256(raw);
    const sourceWidth = options.columns || sauce?.tInfo1 || 80;
    const iceColors =
        options.iceColors === true ||
        (options.iceColors !== false && Boolean(sauce && sauce.flags & 1));
    const convertedSource = convertAnsiToPs1(content, {
        columns: sourceWidth,
        iceColors,
        stripSpaceBackground: false,
        dosAnsi: !/^(?:utf8|utf-8)$/u.test(
            (options.encoding || "cp437").toLowerCase()
        ),
    });
    const sourceLines = convertedSource.terminal.buildLines();
    const parts = [];
    const coordinates = [];
    const provenance = getCheckedInProvenance();
    for (const unresolvedScriptPath of options.scriptPaths) {
        const scriptPath = path.resolve(unresolvedScriptPath);
        if (!fs.existsSync(scriptPath)) {
            throw new Error(`PowerShell script does not exist: ${scriptPath}`);
        }
        let actualLines = extractLinesFromPs1(scriptPath);
        const scriptSource = fs.readFileSync(scriptPath, "utf8");
        const scriptName = path.basename(scriptPath, path.extname(scriptPath));
        const provenanceEntry = provenance.scripts.get(scriptName);
        const rowMatch = provenanceEntry
            ? /^(\d+)-(\d+)$/u.exec(String(provenanceEntry.SourceRows || ""))
            : SOURCE_ROWS.exec(scriptSource);
        const columnMatch = provenanceEntry
            ? /^(\d+)-(\d+)$/u.exec(String(provenanceEntry.SourceColumns || ""))
            : SOURCE_COLUMNS.exec(scriptSource);
        if (!rowMatch || !columnMatch) {
            throw new Error(
                `${scriptPath} must have both source-row and source-column provenance.`
            );
        }
        const rowStart = Number(rowMatch[1]);
        const rowEnd = Number(rowMatch[2]);
        const columnStart = Number(columnMatch[1]);
        const columnEnd = Number(columnMatch[2]);
        if (
            rowStart < 1 ||
            rowEnd < rowStart ||
            rowEnd > sourceLines.length ||
            columnStart < 1 ||
            columnEnd < columnStart ||
            columnEnd > sourceWidth
        ) {
            throw new RangeError(
                `${scriptPath} declares coordinates outside the ${sourceWidth}x${sourceLines.length} source canvas.`
            );
        }
        const expectedLines = convertedSource.terminal
            .buildLines({
                start: columnStart - 1,
                end: columnEnd - 1,
            })
            .slice(rowStart - 1, rowEnd);
        const expectedRowCount = rowEnd - rowStart + 1;
        if (
            actualLines.length === expectedRowCount + 1 &&
            actualLines[0] === ""
        ) {
            actualLines = actualLines.slice(1);
        }
        const expectedRenderSha256 = fingerprintLines(expectedLines);
        const actualRenderSha256 = fingerprintLines(actualLines);
        const declaredSourceSha256 =
            (typeof provenanceEntry?.SourceSha256 === "string"
                ? provenanceEntry.SourceSha256
                : SOURCE_SHA256.exec(scriptSource)?.[1]
            )?.toLowerCase() || null;
        const sourceIdentityMatches =
            declaredSourceSha256 === null ||
            declaredSourceSha256 === sourceSha256;
        const mismatchedRows = findMismatchedRows(
            expectedLines,
            actualLines,
            rowStart
        );
        const matches =
            actualLines.length === expectedRowCount &&
            expectedRenderSha256 === actualRenderSha256 &&
            sourceIdentityMatches;
        coordinates.push({
            columnEnd,
            columnStart,
            rowEnd,
            rowStart,
        });
        parts.push({
            script: path.basename(scriptPath),
            sourceRows: `${rowStart}-${rowEnd}`,
            sourceColumns: `${columnStart}-${columnEnd}`,
            expectedRows: expectedRowCount,
            actualRows: actualLines.length,
            expectedRenderSha256,
            actualRenderSha256,
            declaredSourceSha256,
            sourceIdentityMatches,
            mismatchedRows,
            firstMismatchedRow: mismatchedRows[0] || null,
            matches,
        });
    }
    parts.sort((left, right) =>
        String(left.script).localeCompare(String(right.script), undefined, {
            numeric: true,
        })
    );
    const coverage = analyzeCoverage(
        coordinates,
        sourceWidth,
        sourceLines.length
    );
    return {
        schemaVersion: 1,
        source: {
            file: path.basename(sourcePath),
            sourceSha256,
            renderSha256: fingerprintTerminal(convertedSource.terminal)
                .renderSha256,
            encoding: options.encoding || "cp437",
            width: sourceWidth,
            height: sourceLines.length,
            iceColors,
            sauceWidth: sauce?.tInfo1 || null,
            sauceHeight: sauce?.tInfo2 || null,
            warnings: convertedSource.warnings,
        },
        coverage,
        parts,
        matches:
            parts.every((part) => part.matches === true) &&
            (options.allowPartial === true || coverage.complete),
    };
}

/**
 * @returns {void}
 */
function printUsage() {
    console.log(`Usage:
  node scripts/Verify-AnsiConversion.mjs --source=<file> --prefix=<name>
  node scripts/Verify-AnsiConversion.mjs --source=<file> --script=<file> [--script=<file> ...]

Render the raw ANSI source and generated PowerShell payloads into terminal cells,
then compare characters, coordinates, colors, styles, colored spaces, and blank
canvas rows exactly. This is a conversion-fidelity check, not an artistic score.

Options:
  --source=<path>       Raw ANSI or ICE source file
  --prefix=<name>       Verify every <name>*.ps1 in the scripts directory
  --script=<path>       Verify one generated script (repeatable)
  --scripts-dir=<path>  Override the module scripts directory
  --encoding=<name>     Source encoding (default: cp437)
  --columns=<count>     Override the SAUCE/default source width
  --ice-colors          Force iCE background behavior
  --no-ice-colors       Disable SAUCE-declared iCE background behavior
  --allow-partial       Verify selected parts without requiring full coverage
  --json=<path>         Write the complete report as JSON
  --help, -h            Show this help`);
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
    const options = parseArguments(argv);
    if (options.help) {
        printUsage();
        return;
    }
    if (!options.sourcePath) {
        throw new Error("--source is required.");
    }
    let scriptPaths = options.scriptPaths;
    if (options.prefix) {
        if (!fs.existsSync(options.scriptsDirectory)) {
            throw new Error(
                `Scripts directory does not exist: ${options.scriptsDirectory}`
            );
        }
        scriptPaths = fs
            .readdirSync(options.scriptsDirectory, { withFileTypes: true })
            .filter((entry) => {
                if (
                    !entry.isFile() ||
                    !entry.name.toLowerCase().endsWith(".ps1")
                ) {
                    return false;
                }
                const stem = entry.name.slice(0, -4);
                return (
                    stem === options.prefix ||
                    stem.startsWith(`${options.prefix}-part`) ||
                    stem.startsWith(`${options.prefix}-panel`)
                );
            })
            .map((entry) => path.join(options.scriptsDirectory, entry.name));
    }
    const report = verifyAnsiConversion({
        allowPartial: options.allowPartial,
        columns: options.columns,
        encoding: options.encoding,
        iceColors: options.iceColors,
        scriptPaths,
        sourcePath: options.sourcePath,
    });
    if (options.jsonPath) {
        writeFileAtomic(
            options.jsonPath,
            `${JSON.stringify(report, null, 2)}\n`
        );
        console.log(`Report: ${options.jsonPath}`);
    }
    console.log(
        JSON.stringify(
            {
                source: report.source.file,
                scripts: report.parts.length,
                coverageComplete: report.coverage.complete,
                mismatchedParts: report.parts.filter(
                    (part) => part.matches !== true
                ).length,
                matches: report.matches,
            },
            null,
            2
        )
    );
    for (const part of report.parts.filter(
        (candidate) => candidate.matches !== true
    )) {
        console.log(JSON.stringify(part));
    }
    if (!report.matches) process.exitCode = 1;
}

if (
    process.argv[1] &&
    path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)
) {
    try {
        main();
    } catch (error) {
        console.error(error instanceof Error ? error.message : String(error));
        process.exitCode = 1;
    }
}

export {
    analyzeCoverage,
    findMismatchedRows,
    main,
    parseArguments,
    printUsage,
    verifyAnsiConversion,
};
