#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");
const { spawnSync } = require("node:child_process");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const DEFAULT_SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);
const MAX_SOURCE_BYTES = 16 * 1024 * 1024;
const ANSI_CONTROL_PATTERN =
    /(?:\x1B\][^\x07\x1B]*(?:\x07|\x1B\\)|\x1B[P_X^][\s\S]*?\x1B\\|\x1B\[[0-?]*[ -/]*[@-~]|\x9B[0-?]*[ -/]*[@-~]|\x1B[ -/]*[@-~])/gu;
const LETTER_PATTERN = /\p{L}|\p{M}/gu;
const DIGIT_PATTERN = /\p{N}/gu;
const WORD_PATTERN = /\p{L}[\p{L}\p{M}'’-]*/gu;
const ART_GLYPH_PATTERN =
    /[\u2190-\u21FF\u2300-\u23FF\u2500-\u259F\u25A0-\u25FF\u2800-\u28FF]/gu;
const ART_GLYPH_SINGLE_PATTERN =
    /^[\u2190-\u21FF\u2300-\u23FF\u2500-\u259F\u25A0-\u25FF\u2800-\u28FF]$/u;
const NONSPACE_PATTERN = /\S/gu;
const RESET_SEQUENCE = "\u001b[0m";
const CURATION_MODIFICATION_NOTICE =
    "# Source Modification: Decoded from the attributed archive source and serialized from the rendered terminal cell matrix; project curation removes trailing rendered-blank rows plus standalone written-text and policy-ineligible display cells when present, while preserving retained ANSI controls, terminal-art glyphs, row geometry, and source coordinates.";

const POLICY_TERMS = Object.freeze({
    profanity: Object.freeze([
        "asshole",
        "bastard",
        "bitch",
        "bullshit",
        "cocksucker",
        "cunt",
        "dickhead",
        "fuck",
        "motherfucker",
        "piss",
        "shit",
        "whore",
    ]),
    sexual: Object.freeze([
        "blowjob",
        "cumshot",
        "hardcore",
        "hentai",
        "porn",
        "porno",
        "pussy",
        "sex",
    ]),
    slur: Object.freeze([
        "faggot",
        "nigga",
        "nigger",
        "retard",
        "tranny",
    ]),
});
const POLICY_MATCHERS = Object.freeze(
    Object.entries(POLICY_TERMS).flatMap(([category, terms]) =>
        terms.map((term) =>
            Object.freeze({
                category,
                separatedPattern: new RegExp(
                    String.raw`(?:^|[^\p{L}\p{N}])${[...term]
                        .map((character) => escapeRegExp(character))
                        .join(String.raw`[^\p{L}\p{N}]*`)}(?:$|[^\p{L}\p{N}])`,
                    "u"
                ),
                term,
                wordPattern: new RegExp(
                    String.raw`(?:^|\s)${escapeRegExp(term)}(?:$|\s)`,
                    "u"
                ),
            })
        )
    )
);

/**
 * @typedef {"literal" | "single-here-string" | "double-here-string"} LiteralKind
 */

/**
 * @typedef {Object} PowerShellPayload
 * @property {number} contentEnd
 * @property {number} contentStart
 * @property {LiteralKind} kind
 * @property {string} value
 */

/**
 * @typedef {Object} RowAnalysis
 * @property {number} artGlyphCount
 * @property {number} digitCount
 * @property {boolean} highConfidenceTextOnly
 * @property {number} letterCount
 * @property {number} letterRatio
 * @property {number} nonspaceCount
 * @property {string[]} policyCategories
 * @property {string[]} policyTerms
 * @property {boolean} textOnlyCandidate
 * @property {string} visible
 * @property {string[]} words
 */

/**
 * Remove ECMA-48 control sequences while retaining rendered characters.
 *
 * @param {string} value
 * @returns {string}
 */
function stripAnsiControls(value) {
    return value
        .replace(ANSI_CONTROL_PATTERN, "")
        .replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F]/gu, "");
}

/**
 * @param {string} value
 * @param {RegExp} pattern
 * @returns {number}
 */
function countMatches(value, pattern) {
    return [...value.matchAll(pattern)].length;
}

/**
 * @param {string} value
 * @returns {string}
 */
function escapeRegExp(value) {
    return value.replace(/[.*+?^${}()|[\]\\]/gu, String.raw`\$&`);
}

/**
 * @param {string} visible
 * @returns {{ categories: string[]; terms: string[] }}
 */
function findPolicyTerms(visible) {
    const lowercase = visible.normalize("NFKC").toLocaleLowerCase("en-US");
    const normalized = lowercase
        .replace(/[^\p{L}\p{N}]+/gu, " ")
        .trim();
    const categories = new Set();
    const terms = new Set();

    for (const matcher of POLICY_MATCHERS) {
        if (
            matcher.wordPattern.test(normalized) ||
            (matcher.term.length >= 4 &&
                matcher.separatedPattern.test(lowercase))
        ) {
            categories.add(matcher.category);
            terms.add(matcher.term);
        }
    }

    return {
        categories: [...categories].sort(),
        terms: [...terms].sort(),
    };
}

/**
 * Classify one rendered output row. A candidate remains a review signal, not
 * permission to delete the row automatically.
 *
 * @param {string} rawRow
 * @returns {RowAnalysis}
 */
function analyzeRow(rawRow) {
    const visible = stripAnsiControls(rawRow).replace(/\t/gu, "    ");
    const nonspaceCount = countMatches(visible, NONSPACE_PATTERN);
    const letterCount = countMatches(visible, LETTER_PATTERN);
    const digitCount = countMatches(visible, DIGIT_PATTERN);
    const artGlyphCount = countMatches(visible, ART_GLYPH_PATTERN);
    const words = [...visible.matchAll(WORD_PATTERN)]
        .map((match) => match[0])
        .filter((word) => [...word].length >= 2);
    const letterRatio =
        nonspaceCount === 0 ? 0 : letterCount / nonspaceCount;
    const artGlyphRatio =
        nonspaceCount === 0 ? 0 : artGlyphCount / nonspaceCount;
    const hasSubstantiveWord = words.some((word) => [...word].length >= 3);
    const highConfidenceTextOnly =
        letterCount >= 4 &&
        hasSubstantiveWord &&
        artGlyphCount === 0 &&
        letterRatio >= 0.7;
    const textOnlyCandidate =
        highConfidenceTextOnly ||
        (letterCount >= 6 &&
            hasSubstantiveWord &&
            letterRatio >= 0.45 &&
            artGlyphRatio <= 0.25);
    const policy = findPolicyTerms(visible);

    return {
        artGlyphCount,
        digitCount,
        highConfidenceTextOnly,
        letterCount,
        letterRatio,
        nonspaceCount,
        policyCategories: policy.categories,
        policyTerms: policy.terms,
        textOnlyCandidate,
        visible,
        words,
    };
}

/**
 * @param {string} source
 * @returns {PowerShellPayload}
 */
function extractPowerShellPayload(source) {
    const literalPattern = /Write-Host\s+'((?:[^']|'')*)'/mu;
    const literalMatch = literalPattern.exec(source);
    if (literalMatch) {
        const captured = literalMatch[1];
        const relativeStart = literalMatch[0].indexOf(captured);
        const contentStart = literalMatch.index + relativeStart;
        return {
            contentEnd: contentStart + captured.length,
            contentStart,
            kind: "literal",
            value: captured.replaceAll("''", "'"),
        };
    }

    const singleHerePattern = /Write-Host\s+@'\r?\n([\s\S]*?)\r?\n'@/mu;
    const singleHereMatch = singleHerePattern.exec(source);
    if (singleHereMatch) {
        const captured = singleHereMatch[1];
        const relativeStart = singleHereMatch[0].indexOf(captured);
        const contentStart = singleHereMatch.index + relativeStart;
        return {
            contentEnd: contentStart + captured.length,
            contentStart,
            kind: "single-here-string",
            value: captured,
        };
    }

    const doubleHerePattern = /Write-Host\s+@"\r?\n([\s\S]*?)\r?\n"@/mu;
    const doubleHereMatch = doubleHerePattern.exec(source);
    if (doubleHereMatch) {
        const captured = doubleHereMatch[1];
        const relativeStart = doubleHereMatch[0].indexOf(captured);
        const contentStart = doubleHereMatch.index + relativeStart;
        return {
            contentEnd: contentStart + captured.length,
            contentStart,
            kind: "double-here-string",
            value: captured,
        };
    }

    throw new Error("Unable to locate a supported Write-Host string literal.");
}

/**
 * @param {string} value
 * @param {LiteralKind} kind
 * @returns {string}
 */
function serializePayload(value, kind) {
    return kind === "literal" ? value.replaceAll("'", "''") : value;
}

/**
 * Blank non-art characters while preserving ECMA-48 controls, whitespace, and
 * terminal-art glyphs at their original columns.
 *
 * @param {string} rawRow
 * @returns {string}
 */
function blankTextRow(rawRow) {
    let result = "";
    let cursor = 0;

    for (const match of rawRow.matchAll(ANSI_CONTROL_PATTERN)) {
        const plainText = rawRow.slice(cursor, match.index);
        result += [...plainText]
            .map((character) => {
                if (
                    /\s/u.test(character) ||
                    ART_GLYPH_SINGLE_PATTERN.test(character)
                ) {
                    return character;
                }
                return " ";
            })
            .join("");
        result += match[0];
        cursor = match.index + match[0].length;
    }

    result += [...rawRow.slice(cursor)]
        .map((character) => {
            if (
                /\s/u.test(character) ||
                ART_GLYPH_SINGLE_PATTERN.test(character)
            ) {
                return character;
            }
            return " ";
        })
        .join("");
    return result;
}

/**
 * @param {string} source
 * @returns {{
 *     blankedRows: number;
 *     changed: boolean;
 *     removedTrailingRows: number;
 *     source: string;
 * }}
 */
function removeFlaggedText(source) {
    const payload = extractPowerShellPayload(source);
    const lineEnding = source.includes("\r\n") ? "\r\n" : "\n";
    const rows = payload.value.replace(/\r\n?/gu, "\n").split("\n");
    let blankedRows = 0;
    const cleanedRows = rows.map((row) => {
        const analysis = analyzeRow(row);
        if (
            !analysis.textOnlyCandidate &&
            analysis.policyTerms.length === 0
        ) {
            return row;
        }
        blankedRows += 1;
        return blankTextRow(row);
    });

    if (blankedRows === 0) {
        return {
            blankedRows: 0,
            changed: false,
            removedTrailingRows: 0,
            source,
        };
    }

    const serialized = serializePayload(
        cleanedRows.join(lineEnding),
        payload.kind
    );
    const updatedSource =
        source.slice(0, payload.contentStart) +
        serialized +
        source.slice(payload.contentEnd);
    const trailingCleanup = removeTrailingBlankRows(updatedSource);
    const documentedSource = documentCuration(trailingCleanup.source);

    return {
        blankedRows,
        changed: documentedSource !== source,
        removedTrailingRows: trailingCleanup.removedRows,
        source: documentedSource,
    };
}

/**
 * @param {string} source
 * @returns {string}
 */
function documentCuration(source) {
    const modificationPattern = /^# Source Modification:.*$/mu;
    return modificationPattern.test(source)
        ? source.replace(
              modificationPattern,
              CURATION_MODIFICATION_NOTICE
          )
        : source;
}

/**
 * @param {string} source
 * @returns {{
 *     changed: boolean;
 *     removedRows: number;
 *     source: string;
 * }}
 */
function removeTrailingBlankRows(source) {
    const payload = extractPowerShellPayload(source);
    const lineEnding = source.includes("\r\n") ? "\r\n" : "\n";
    const rows = payload.value.replace(/\r\n?/gu, "\n").split("\n");
    let lastContentIndex = rows.length - 1;

    while (
        lastContentIndex >= 0 &&
        stripAnsiControls(rows[lastContentIndex]).trim().length === 0
    ) {
        lastContentIndex -= 1;
    }

    const removedRows = rows.length - lastContentIndex - 1;
    if (removedRows === 0 || lastContentIndex < 0) {
        return { changed: false, removedRows: 0, source };
    }

    const keptRows = rows.slice(0, lastContentIndex + 1);
    const removedContent = rows.slice(lastContentIndex + 1).join("\n");
    const containsAnsi = payload.value.includes("\u001b");
    const removedReset = removedContent.includes(RESET_SEQUENCE);
    if (
        containsAnsi &&
        removedReset &&
        !keptRows.at(-1).endsWith(RESET_SEQUENCE)
    ) {
        keptRows[keptRows.length - 1] += RESET_SEQUENCE;
    }

    const serialized = serializePayload(keptRows.join(lineEnding), payload.kind);
    return {
        changed: true,
        removedRows,
        source:
            source.slice(0, payload.contentStart) +
            serialized +
            source.slice(payload.contentEnd),
    };
}

/**
 * @param {string} source
 * @returns {{
 *     rowCount: number;
 *     policyRows: object[];
 *     textRows: object[];
 *     trailingBlankRows: number;
 * }}
 */
function auditSource(source) {
    const payload = extractPowerShellPayload(source);
    const rows = payload.value.replace(/\r\n?/gu, "\n").split("\n");
    const analyses = rows.map((row) => analyzeRow(row));
    let trailingBlankRows = 0;

    for (let index = analyses.length - 1; index >= 0; index -= 1) {
        if (analyses[index].visible.trim().length > 0) {
            break;
        }
        trailingBlankRows += 1;
    }

    const textRows = [];
    const policyRows = [];
    for (const [index, analysis] of analyses.entries()) {
        const reportRow = {
            artGlyphCount: analysis.artGlyphCount,
            highConfidence: analysis.highConfidenceTextOnly,
            letterCount: analysis.letterCount,
            letterRatio: Number(analysis.letterRatio.toFixed(4)),
            row: index + 1,
            text: analysis.visible,
            words: analysis.words,
        };
        if (analysis.textOnlyCandidate) {
            textRows.push(reportRow);
        }
        if (analysis.policyTerms.length > 0) {
            policyRows.push({
                ...reportRow,
                categories: analysis.policyCategories,
                terms: analysis.policyTerms,
            });
        }
    }

    return {
        policyRows,
        rowCount: rows.length,
        textRows,
        trailingBlankRows,
    };
}

/**
 * @param {string} revision
 * @param {string} scriptsDirectory
 * @returns {string[]}
 */
function getAddedFiles(revision, scriptsDirectory) {
    const result = spawnSync(
        "git",
        [
            "diff",
            "--name-only",
            "--diff-filter=A",
            `${revision}...HEAD`,
            "--",
            path.relative(REPOSITORY_ROOT, scriptsDirectory),
        ],
        {
            cwd: REPOSITORY_ROOT,
            encoding: "utf8",
            maxBuffer: 64 * 1024 * 1024,
        }
    );
    if (result.status !== 0) {
        throw new Error(
            `git diff failed: ${(result.stderr || result.stdout).trim()}`
        );
    }

    return result.stdout
        .split(/\r?\n/gu)
        .filter((file) => file.toLocaleLowerCase("en-US").endsWith(".ps1"))
        .map((file) => path.resolve(REPOSITORY_ROOT, file))
        .filter((file) => fs.existsSync(file));
}

/**
 * @param {string} scriptsDirectory
 * @returns {string[]}
 */
function getWorkingTreeFiles(scriptsDirectory) {
    const result = spawnSync(
        "git",
        [
            "diff",
            "--name-only",
            "--diff-filter=M",
            "--",
            path.relative(REPOSITORY_ROOT, scriptsDirectory),
        ],
        {
            cwd: REPOSITORY_ROOT,
            encoding: "utf8",
            maxBuffer: 64 * 1024 * 1024,
        }
    );
    if (result.status !== 0) {
        throw new Error(
            `git diff failed: ${(result.stderr || result.stdout).trim()}`
        );
    }
    return result.stdout
        .split(/\r?\n/gu)
        .filter((file) => file.toLocaleLowerCase("en-US").endsWith(".ps1"))
        .map((file) => path.resolve(REPOSITORY_ROOT, file));
}

/**
 * @param {string} directory
 * @returns {string[]}
 */
function getAllScripts(directory) {
    return fs
        .readdirSync(directory, { withFileTypes: true })
        .filter(
            (entry) =>
                entry.isFile() &&
                entry.name.toLocaleLowerCase("en-US").endsWith(".ps1")
        )
        .map((entry) => path.join(directory, entry.name));
}

/**
 * @param {string[]} arguments_
 * @returns {{
 *     changedSince: string | null;
 *     documentWorkingTree: boolean;
 *     fixText: boolean;
 *     fixTrailing: boolean;
 *     output: string;
 *     scriptsDirectory: string;
 * }}
 */
function parseArguments(arguments_) {
    const options = {
        changedSince: null,
        documentWorkingTree: false,
        fixText: false,
        fixTrailing: false,
        output: path.join(
            REPOSITORY_ROOT,
            "temp",
            "ansi-content-audit",
            "report.json"
        ),
        scriptsDirectory: DEFAULT_SCRIPTS_DIRECTORY,
    };

    for (let index = 0; index < arguments_.length; index += 1) {
        const argument = arguments_[index];
        if (argument === "--fix-trailing") {
            options.fixTrailing = true;
        } else if (argument === "--fix-text") {
            options.fixText = true;
        } else if (argument === "--document-working-tree") {
            options.documentWorkingTree = true;
        } else if (argument.startsWith("--changed-since=")) {
            options.changedSince = argument.slice("--changed-since=".length);
        } else if (argument.startsWith("--output=")) {
            options.output = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--output=".length)
            );
        } else if (argument.startsWith("--scripts-dir=")) {
            options.scriptsDirectory = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--scripts-dir=".length)
            );
        } else if (argument === "--help") {
            console.log(`Usage: node scripts/Audit-ColorScriptContent.js [options]

Options:
  --changed-since=<ref>  Audit scripts added since a Git revision
  --document-working-tree
                         Synchronize curation notices in modified scripts
  --scripts-dir=<path>   Scripts directory to audit
  --output=<path>        JSON report path
  --fix-text             Blank reviewed text-like and policy-ineligible rows
  --fix-trailing         Remove rendered-blank rows after the final artwork row
  --help                 Show this help`);
            process.exit(0);
        } else {
            throw new Error(`Unknown option: ${argument}`);
        }
    }

    return options;
}

/**
 * @param {string[]} arguments_
 * @returns {void}
 */
function main(arguments_ = process.argv.slice(2)) {
    const options = parseArguments(arguments_);
    const files = (
        options.documentWorkingTree
            ? getWorkingTreeFiles(options.scriptsDirectory)
            : options.changedSince
              ? getAddedFiles(options.changedSince, options.scriptsDirectory)
              : getAllScripts(options.scriptsDirectory)
    ).sort((left, right) => left.localeCompare(right, "en-US"));
    const records = [];
    const failures = [];
    let fixedFiles = 0;
    let textFixedFiles = 0;
    let blankedTextRows = 0;
    let documentedFiles = 0;
    let removedTrailingRows = 0;

    for (const file of files) {
        try {
            const stat = fs.statSync(file);
            if (stat.size > MAX_SOURCE_BYTES) {
                throw new RangeError(
                    `Source exceeds the ${MAX_SOURCE_BYTES}-byte safety limit.`
                );
            }
            let source = fs.readFileSync(file, "utf8");
            const audit = auditSource(source);
            if (
                options.fixText &&
                (audit.textRows.length > 0 || audit.policyRows.length > 0)
            ) {
                const cleanup = removeFlaggedText(source);
                if (cleanup.changed) {
                    fs.writeFileSync(file, cleanup.source, "utf8");
                    source = cleanup.source;
                    textFixedFiles += 1;
                    blankedTextRows += cleanup.blankedRows;
                    removedTrailingRows += cleanup.removedTrailingRows;
                }
            }
            const postTextAudit =
                options.fixText &&
                (audit.textRows.length > 0 || audit.policyRows.length > 0)
                    ? auditSource(source)
                    : audit;
            if (
                options.fixTrailing &&
                postTextAudit.trailingBlankRows > 0
            ) {
                const cleanup = removeTrailingBlankRows(source);
                if (cleanup.changed) {
                    fs.writeFileSync(file, cleanup.source, "utf8");
                    source = cleanup.source;
                    fixedFiles += 1;
                    removedTrailingRows += cleanup.removedRows;
                }
            }
            if (options.documentWorkingTree) {
                const documentedSource = documentCuration(source);
                if (documentedSource !== source) {
                    fs.writeFileSync(file, documentedSource, "utf8");
                    source = documentedSource;
                    documentedFiles += 1;
                }
            }
            const finalAudit =
                (options.fixText &&
                    (audit.textRows.length > 0 ||
                        audit.policyRows.length > 0)) ||
                (options.fixTrailing && postTextAudit.trailingBlankRows > 0)
                    ? auditSource(source)
                    : postTextAudit;
            if (
                finalAudit.trailingBlankRows > 0 ||
                finalAudit.textRows.length > 0 ||
                finalAudit.policyRows.length > 0
            ) {
                records.push({
                    file: path
                        .relative(REPOSITORY_ROOT, file)
                        .replaceAll(path.sep, "/"),
                    ...finalAudit,
                });
            }
        } catch (error) {
            failures.push({
                error: error instanceof Error ? error.message : String(error),
                file: path
                    .relative(REPOSITORY_ROOT, file)
                    .replaceAll(path.sep, "/"),
            });
        }
    }

    const report = {
        generatedAt: new Date().toISOString(),
        scope: {
            changedSince: options.changedSince,
            fileCount: files.length,
            scriptsDirectory: path
                .relative(REPOSITORY_ROOT, options.scriptsDirectory)
                .replaceAll(path.sep, "/"),
        },
        summary: {
            failedFiles: failures.length,
            blankedTextRows,
            documentedFiles,
            filesWithPolicyRows: records.filter(
                (record) => record.policyRows.length > 0
            ).length,
            filesWithTextRows: records.filter(
                (record) => record.textRows.length > 0
            ).length,
            filesWithTrailingBlankRows: records.filter(
                (record) => record.trailingBlankRows > 0
            ).length,
            fixedFiles,
            policyRows: records.reduce(
                (total, record) => total + record.policyRows.length,
                0
            ),
            removedTrailingRows,
            textFixedFiles,
            textRows: records.reduce(
                (total, record) => total + record.textRows.length,
                0
            ),
            trailingBlankRows: records.reduce(
                (total, record) => total + record.trailingBlankRows,
                0
            ),
        },
        failures,
        records,
    };
    fs.mkdirSync(path.dirname(options.output), { recursive: true });
    fs.writeFileSync(
        options.output,
        `${JSON.stringify(report, null, 2)}\n`,
        "utf8"
    );
    console.log(JSON.stringify(report.summary, null, 2));
    console.log(`Report: ${options.output}`);

    if (failures.length > 0) {
        process.exitCode = 1;
    }
}

if (require.main === module) {
    main();
}

module.exports = {
    analyzeRow,
    auditSource,
    blankTextRow,
    documentCuration,
    extractPowerShellPayload,
    findPolicyTerms,
    getAddedFiles,
    getWorkingTreeFiles,
    parseArguments,
    removeFlaggedText,
    removeTrailingBlankRows,
    serializePayload,
    stripAnsiControls,
};
