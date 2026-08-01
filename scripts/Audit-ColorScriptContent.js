#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");
const { spawnSync } = require("node:child_process");
const { createHash } = require("node:crypto");
const {
    convertAnsiToPs1,
} = require("./Convert-AnsiToColorScript.js");

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
    /[\u00AB\u00AC\u00B0\u00B2\u00B7\u00BB\u207F\u2190-\u21FF\u2219\u2261\u2300-\u23FF\u2500-\u259F\u25A0-\u25FF\u2665\u2800-\u28FF]/gu;
const ART_GLYPH_SINGLE_PATTERN =
    /^[\u00AB\u00AC\u00B0\u00B2\u00B7\u00BB\u207F\u2190-\u21FF\u2219\u2261\u2300-\u23FF\u2500-\u259F\u25A0-\u25FF\u2665\u2800-\u28FF]$/u;
const RAW_C0_PATTERN =
    /^[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F]$/u;
const LEGACY_CP437_SOURCE_CELL_PATTERN = /^\u0016$/u;
const NONSPACE_PATTERN = /\S/gu;
const RESET_SEQUENCE = "\u001b[0m";
const CONTACT_CONTEXT_PATTERN =
    /\b(?:bbs|board|call|contact|data|dial|fax|host|line|node|number|nup|pager|phone|sysop|tel|telephone|vmb|voice)\b/iu;
const CONTACT_FALSE_POSITIVE_CONTEXT_PATTERN =
    /\b(?:anniversary|baud|birthday|bps|date|kbps|open|version|v\d{2}(?:bis)?)\b/iu;
const DATE_TIME_BAUD_PATTERN =
    /\b\d{1,2}\s*[/.-]\s*\d{1,2}\s*[/.-]\s*\d{2,4}\b[^\r\n]{0,40}\b\d{1,2}\s*:\s*\d{2}\b[^\r\n]{0,40}\b(?:300|1200|2400|4800|9600|14400|16800|19200|28800|33600|56000|115200)\b/iu;
const EMAIL_PATTERN =
    /[\p{L}\p{N}._%+-]+@[\p{L}\p{N}.-]+\.[\p{L}]{2,}/giu;
const NETWORK_ENDPOINT_PATTERN =
    /\b(?:(?:https?|ftp|telnet):\/\/|www\.)[^\s]+|\b(?:bbs|telnet)\.[\p{L}\p{N}.-]+\.[\p{L}]{2,}\b/giu;
const FIDO_ENDPOINT_PATTERN =
    /(?<![\p{L}\p{N}])[\dOo]{1,3}:[\dOo]{1,6}\/[\dOo]{1,6}(?:\.[\dOo]{1,6})?(?![\p{L}\p{N}])/giu;
const PHONE_CANDIDATE_PATTERN =
    /(?<![\p{L}\p{N}])(?:\+|00|011)?[\dOoIiLl([][\dOoIiLl\s()[\]./·■-]{5,}[\dOoIiLl)](?![\p{L}\p{N}])/giu;
const SOURCE_FIDELITY_LOCK_PATTERN =
    /^# Source Conversion Mode:\s*Passthrough\s*$/imu;
const CURATION_MODIFICATION_NOTICE =
    "# Source Modification: Decoded from the attributed archive source and serialized from the rendered terminal cell matrix; project curation removes trailing rendered-blank rows, blank rows introduced by redaction, and standalone written-text, contact, or policy-ineligible display cells when present, while preserving retained ANSI controls, terminal-art glyphs, colored spaces, and source coordinates.";
const FUNCTIONAL_CONTACT_EXCEPTIONS = new Map([
    [
        "nerd-font-test.ps1",
        new Set([
            "a22f84546f017b195e858cadd8fee57579c5649b691693482df9461c9b6509a2",
        ]),
    ],
]);

const POLICY_TERMS = Object.freeze({
    hate: Object.freeze([
        "kkk",
        "nazi",
        "swastika",
        "white power",
        "whitepower",
    ]),
    profanity: Object.freeze([
        "arse",
        "ass",
        "asshole",
        "bastard",
        "bitch",
        "bollocks",
        "bullshit",
        "cock",
        "cocksucker",
        "crap",
        "cunt",
        "damn",
        "dick",
        "dickhead",
        "douche",
        "douchebag",
        "fuck",
        "hell",
        "motherfucker",
        "piss",
        "shit",
        "slut",
        "wanker",
        "whore",
    ]),
    sexual: Object.freeze([
        "anal",
        "blowjob",
        "boobs",
        "cum",
        "cumshot",
        "dildo",
        "erection",
        "hardcore",
        "hentai",
        "incest",
        "masturbate",
        "masturbation",
        "naked",
        "nude",
        "nudes",
        "orgasm",
        "penis",
        "porn",
        "porno",
        "pussy",
        "rape",
        "raped",
        "sex",
        "sexy",
        "tit",
        "tits",
        "vagina",
    ]),
    slur: Object.freeze([
        "chink",
        "coon",
        "dyke",
        "fag",
        "faggot",
        "gook",
        "kike",
        "nigga",
        "nigger",
        "retard",
        "spic",
        "tranny",
        "wetback",
    ]),
    violence: Object.freeze([
        "beheading",
        "decapitate",
        "decapitated",
        "dismember",
        "dismembered",
        "torture",
    ]),
});
const POLICY_MATCHERS = Object.freeze(
    Object.entries(POLICY_TERMS).flatMap(([category, terms]) =>
        terms.map((term) =>
            Object.freeze({
                category,
                term,
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
 * @property {string[]} contactCategories
 * @property {string[]} contactValues
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
 * @param {unknown} cell
 * @returns {boolean}
 */
function isVisibleTerminalCell(cell) {
    if (!cell || typeof cell !== "object") return false;
    const value =
        /**
         * @type {{
         *     char?: string;
         *     attrs?: {
         *         bg?: unknown;
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
 * Render logical rows through the same terminal emulator used by the converter.
 * This is deliberately more expensive than stripping escape sequences: a row
 * of spaces with a background color is visible artwork, not a blank row.
 *
 * @param {string[]} rows
 * @returns {boolean[]}
 */
function getRenderedBlankRows(rows) {
    if (rows.length === 0) return [];
    const { terminal } = convertAnsiToPs1(rows.join("\r\n"), {
        autoWrap: false,
        columns: 2048,
        stripSpaceBackground: false,
    });
    return rows.map((unusedRow, rowIndex) => {
        const row = terminal.rows.get(rowIndex);
        if (!row) return true;
        return ![...row.cells.values()].some(isVisibleTerminalCell);
    });
}

/**
 * @param {boolean[]} blankRows
 * @returns {{
 *     count: number;
 *     endRow: number;
 *     kind: "internal" | "leading" | "trailing";
 *     startRow: number;
 * }[]}
 */
function findBlankRuns(blankRows) {
    const runs = [];
    let runStart = null;
    for (let index = 0; index <= blankRows.length; index += 1) {
        if (blankRows[index] && runStart === null) {
            runStart = index;
        }
        if (!blankRows[index] && runStart !== null) {
            runs.push({
                count: index - runStart,
                endRow: index,
                kind:
                    runStart === 0
                        ? "leading"
                        : index === blankRows.length
                          ? "trailing"
                          : "internal",
                startRow: runStart + 1,
            });
            runStart = null;
        }
    }
    return runs;
}

/**
 * @param {string} value
 * @returns {string}
 */
function normalizePhoneDigits(value) {
    return value
        .replace(/[Oo]/gu, "0")
        .replace(/[IiLl]/gu, "1")
        .replace(/\D/gu, "");
}

/**
 * @param {string} candidate
 * @param {string} visible
 * @returns {boolean}
 */
function isHighConfidencePhone(candidate, visible) {
    const digits = normalizePhoneDigits(candidate);
    if (digits.length < 7 || digits.length > 16) return false;
    const counts = new Map();
    for (const digit of digits) {
        counts.set(digit, (counts.get(digit) || 0) + 1);
    }
    if (Math.max(...counts.values()) / digits.length >= 0.75) {
        return false;
    }

    const hasContactContext = CONTACT_CONTEXT_PATTERN.test(visible);
    const actualDigits = candidate.replace(/\D/gu, "");
    if (actualDigits.length < 3 && !hasContactContext) {
        return false;
    }
    if (/^[01]+$/u.test(digits) && !hasContactContext) {
        return false;
    }
    if (DATE_TIME_BAUD_PATTERN.test(visible)) {
        return false;
    }
    if (
        /\b(?:date|released)\s*:/iu.test(visible) &&
        /\b\d{1,2}\s*[/.-]\s*\d{1,2}\s*[/.-]\s*\d{2,4}\b/u.test(
            visible
        )
    ) {
        return false;
    }
    const normalizedGroups = candidate
        .replace(/[Oo]/gu, "0")
        .replace(/[IiLl]/gu, "1")
        .split(/\D+/gu)
        .filter(Boolean);
    const commonBaudRates = new Set([
        "300",
        "1200",
        "2400",
        "4800",
        "9600",
        "14400",
        "16800",
        "19200",
        "28800",
        "33600",
        "56000",
        "115200",
    ]);
    if (
        normalizedGroups.length >= 2 &&
        normalizedGroups.every((group) =>
            commonBaudRates.has(group)
        )
    ) {
        return false;
    }
    if (
        CONTACT_FALSE_POSITIVE_CONTEXT_PATTERN.test(visible) &&
        !hasContactContext
    ) {
        return false;
    }
    if (
        /\b(?:19|20)\d{2}\s*[/.-]\s*\d{1,2}\s*[/.-]\s*\d{1,2}\b/u.test(
            candidate
        ) ||
        /\b\d{1,2}\s*[/.-]\s*\d{1,2}\s*[/.-]\s*(?:19|20)\d{2}\b/u.test(
            candidate
        )
    ) {
        return false;
    }

    const normalizedShape = candidate
        .replace(/[Oo]/gu, "0")
        .replace(/[IiLl]/gu, "1")
        .trim();
    const groups = normalizedShape.split(/\D+/gu).filter(Boolean);
    const hasInternationalPrefix = /^(?:\+|00|011)/u.test(normalizedShape);
    const hasParenthesizedAreaCode = /\(\s*\d{2,4}\s*\)/u.test(
        normalizedShape
    );
    const hasConventionalGroups =
        groups.length >= 2 &&
        groups.at(-1).length === 4 &&
        (groups.some((group) => group.length === 3) ||
            groups.filter((group) => group.length === 1).length >= 7);
    const surroundingText = visible
        .replace(candidate, "")
        .replace(ART_GLYPH_PATTERN, "")
        .replace(/[^\p{L}\p{N}]/gu, "");
    const isIsolatedSeparatedNumber =
        surroundingText.length === 0 &&
        groups.length >= 3 &&
        groups.at(-1).length >= 4 &&
        groups.some((group) => group.length >= 3);

    return (
        hasContactContext ||
        hasInternationalPrefix ||
        hasParenthesizedAreaCode ||
        hasConventionalGroups ||
        isIsolatedSeparatedNumber
    );
}

/**
 * @param {string} visible
 * @returns {{ categories: string[]; values: string[] }}
 */
function findContactDetails(visible) {
    const categories = new Set();
    const values = new Set();
    for (const match of visible.matchAll(EMAIL_PATTERN)) {
        categories.add("email");
        values.add(match[0]);
    }
    for (const match of visible.matchAll(NETWORK_ENDPOINT_PATTERN)) {
        categories.add("network-endpoint");
        values.add(match[0]);
    }
    const fidoMatches = [...visible.matchAll(FIDO_ENDPOINT_PATTERN)];
    for (const match of fidoMatches) {
        categories.add("network-endpoint");
        values.add(match[0]);
    }
    for (const match of visible.matchAll(PHONE_CANDIDATE_PATTERN)) {
        const start = match.index ?? -1;
        const end = start + match[0].length;
        if (
            fidoMatches.some((fidoMatch) => {
                const fidoStart = fidoMatch.index ?? -1;
                const fidoEnd = fidoStart + fidoMatch[0].length;
                return start < fidoEnd && end > fidoStart;
            })
        ) {
            continue;
        }
        if (!isHighConfidencePhone(match[0], visible)) continue;
        categories.add("phone");
        values.add(match[0].trim());
    }
    return {
        categories: [...categories].sort(),
        values: [...values].sort(),
    };
}

/**
 * Passthrough scripts promise that the PowerShell literal is byte-identical to
 * the decoded source stream. Content curation must not rewrite their payload,
 * trailing line endings, or provenance claim.
 *
 * @param {string} source
 * @returns {boolean}
 */
function isSourceFidelityLocked(source) {
    return SOURCE_FIDELITY_LOCK_PATTERN.test(source);
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
    const normalizedTokens = new Set(
        normalized.length === 0 ? [] : normalized.split(/\s+/gu)
    );
    const collapsedTokens = new Set(
        lowercase
            .split(/\s+/gu)
            .map((token) => token.replace(/[^\p{L}\p{N}]/gu, ""))
            .filter(Boolean)
    );
    const paddedNormalized = ` ${normalized} `;
    const categories = new Set();
    const terms = new Set();

    for (const matcher of POLICY_MATCHERS) {
        if (
            normalizedTokens.has(matcher.term) ||
            collapsedTokens.has(matcher.term) ||
            (matcher.term.includes(" ") &&
                paddedNormalized.includes(` ${matcher.term} `))
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
    const contact = findContactDetails(visible);

    return {
        artGlyphCount,
        contactCategories: contact.categories,
        contactValues: contact.values,
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
 * @param {string} source
 * @param {PowerShellPayload} payload
 * @param {string[]} rows
 * @returns {string}
 */
function replacePayloadRows(source, payload, rows) {
    const lineEnding = source.includes("\r\n") ? "\r\n" : "\n";
    const serialized = serializePayload(rows.join(lineEnding), payload.kind);
    return (
        source.slice(0, payload.contentStart) +
        serialized +
        source.slice(payload.contentEnd)
    );
}

/**
 * Remove logical rows while carrying their terminal controls forward. Generated
 * archival payloads contain SGR controls; discarding a reset or style change
 * together with a blank row can recolor the following artwork.
 *
 * @param {string[]} rows
 * @param {Set<number>} indexes Zero-based row indexes.
 * @returns {string[]}
 */
function removeRowsPreservingControls(rows, indexes) {
    const kept = [];
    let pendingControls = "";
    for (const [index, originalRow] of rows.entries()) {
        if (indexes.has(index)) {
            pendingControls += [...originalRow.matchAll(ANSI_CONTROL_PATTERN)]
                .map((match) => match[0])
                .join("");
            continue;
        }
        const row = pendingControls + originalRow;
        pendingControls = "";
        kept.push(row);
    }
    if (pendingControls && kept.length > 0) {
        kept[kept.length - 1] += pendingControls;
    }
    return kept;
}

/**
 * @param {string} visible
 * @returns {string}
 */
function getReviewEvidenceHash(visible) {
    return createHash("sha256")
        .update(visible.trim(), "utf8")
        .digest("hex");
}

/**
 * Keep functional first-party endpoint instructions while making any content
 * drift re-enter review. Exceptions are scoped to an exact file and rendered
 * row hash rather than a broad URL allowlist.
 *
 * @param {string} file
 * @param {{ text: string }} row
 * @returns {boolean}
 */
function isFunctionalContactException(file, row) {
    const hashes = FUNCTIONAL_CONTACT_EXCEPTIONS.get(path.basename(file));
    return hashes?.has(getReviewEvidenceHash(row.text)) === true;
}

/**
 * Apply exact, human-reviewed payload-row redactions. Evidence text is checked
 * before any write so stale row numbers fail closed. A reviewed ledger may
 * store a SHA-256 instead of the original identifying text.
 *
 * @param {string} source
 * @param {{
 *     action?: "blank-columns" | "blank-text" | "remove-row";
 *     columnRanges?: { end: number; start: number }[];
 *     expectedRawSha256?: string;
 *     expectedRenderedSha256?: string;
 *     row: number;
 *     sha256?: string;
 *     text?: string;
 * }[]} evidence
 * @returns {{
 *     blankedRows: number;
 *     changed: boolean;
 *     removedRows: number;
 *     source: string;
 * }}
 */
function applyReviewedRows(source, evidence) {
    const payload = extractPowerShellPayload(source);
    const rows = payload.value.replace(/\r\n?/gu, "\n").split("\n");
    const blankIndexes = new Set();
    const blankColumnRows = new Map();
    const removeIndexes = new Set();

    for (const item of evidence) {
        const action = item?.action || "blank-text";
        const isBlankColumns = action === "blank-columns";
        if (
            !item ||
            !Number.isInteger(item.row) ||
            item.row < 1 ||
            item.row > rows.length ||
            (typeof item.text !== "string" &&
                (typeof item.sha256 !== "string" ||
                    !/^[a-f\d]{64}$/u.test(item.sha256)))
            ||
            (item.action != null &&
                item.action !== "blank-columns" &&
                item.action !== "blank-text" &&
                item.action !== "remove-row") ||
            (isBlankColumns &&
                (!Array.isArray(item.columnRanges) ||
                    typeof item.expectedRawSha256 !== "string" ||
                    !/^[a-f\d]{64}$/u.test(item.expectedRawSha256) ||
                    typeof item.expectedRenderedSha256 !== "string" ||
                    !/^[a-f\d]{64}$/u.test(
                        item.expectedRenderedSha256
                    ))) ||
            (!isBlankColumns &&
                (item.columnRanges != null ||
                    item.expectedRawSha256 != null ||
                    item.expectedRenderedSha256 != null))
        ) {
            throw new RangeError("Reviewed row evidence is malformed.");
        }
        const rowIndex = item.row - 1;
        const visible = stripAnsiControls(rows[rowIndex]);
        const textMatches =
            typeof item.text === "string" &&
            visible.trim() === item.text.trim();
        const hashMatches =
            typeof item.sha256 === "string" &&
            getReviewEvidenceHash(visible) === item.sha256;
        if (!textMatches && !hashMatches) {
            throw new Error(
                `Reviewed row ${item.row} is stale: rendered text no longer matches.`
            );
        }
        if (
            blankIndexes.has(rowIndex) ||
            blankColumnRows.has(rowIndex) ||
            removeIndexes.has(rowIndex)
        ) {
            throw new Error(
                `Reviewed row ${item.row} has conflicting actions.`
            );
        }
        if (action === "remove-row") {
            removeIndexes.add(rowIndex);
        } else if (action === "blank-columns") {
            const blanked = blankTextColumns(
                rows[rowIndex],
                item.columnRanges
            );
            const rawHash = getRawRowHash(blanked);
            const renderedHash = getReviewEvidenceHash(
                stripAnsiControls(blanked)
            );
            if (
                rawHash !== item.expectedRawSha256 ||
                renderedHash !== item.expectedRenderedSha256
            ) {
                throw new Error(
                    `Reviewed row ${item.row} projection is stale: expected output hashes no longer match.`
                );
            }
            blankColumnRows.set(rowIndex, blanked);
        } else {
            blankIndexes.add(rowIndex);
        }
    }

    if (
        blankIndexes.size === 0 &&
        blankColumnRows.size === 0 &&
        removeIndexes.size === 0
    ) {
        return {
            blankedRows: 0,
            changed: false,
            removedRows: 0,
            source,
        };
    }
    let blankedRowCount = 0;
    const blankedRows = rows.map((row, index) => {
        const columnBlanked = blankColumnRows.get(index);
        if (!blankIndexes.has(index) && columnBlanked == null) return row;
        const blanked = columnBlanked ?? blankTextRow(row);
        if (blanked !== row) blankedRowCount += 1;
        return blanked;
    });
    const updatedRows = removeRowsPreservingControls(
        blankedRows,
        removeIndexes
    );
    const updatedSource = documentCuration(
        replacePayloadRows(source, payload, updatedRows)
    );
    return {
        blankedRows: blankedRowCount,
        changed: updatedSource !== source,
        removedRows: removeIndexes.size,
        source: updatedSource,
    };
}

/**
 * Delete rows that are blank now but rendered visible in the pre-curation
 * baseline. This repairs blank holes introduced by row-level redaction without
 * collapsing source-authored negative space.
 *
 * @param {string} source
 * @param {string} baselineSource
 * @returns {{
 *     changed: boolean;
 *     removedRows: number;
 *     source: string;
 * }}
 */
function compactBlankRowsIntroducedSince(source, baselineSource) {
    const payload = extractPowerShellPayload(source);
    const baselinePayload = extractPowerShellPayload(baselineSource);
    const rows = payload.value.replace(/\r\n?/gu, "\n").split("\n");
    const baselineRows = baselinePayload.value
        .replace(/\r\n?/gu, "\n")
        .split("\n");
    const currentBlankRows = getRenderedBlankRows(rows);
    const baselineBlankRows = getRenderedBlankRows(baselineRows);
    const indexes = new Set();

    for (
        let index = 0;
        index < rows.length && index < baselineRows.length;
        index += 1
    ) {
        if (currentBlankRows[index] && !baselineBlankRows[index]) {
            indexes.add(index);
        }
    }
    if (indexes.size === 0) {
        return { changed: false, removedRows: 0, source };
    }

    const compactedRows = removeRowsPreservingControls(rows, indexes);
    const updatedSource = documentCuration(
        replacePayloadRows(source, payload, compactedRows)
    );
    return {
        changed: updatedSource !== source,
        removedRows: indexes.size,
        source: updatedSource,
    };
}

/**
 * Removing a heading can expose a large source-authored spacer as the new top
 * margin. Trim only the excess over the source's original leading margin, and
 * only when the current run is objectively extreme.
 *
 * @param {string} source
 * @param {string} baselineSource
 * @returns {{
 *     changed: boolean;
 *     removedRows: number;
 *     source: string;
 * }}
 */
function trimExpandedLeadingBlankRows(source, baselineSource) {
    const payload = extractPowerShellPayload(source);
    const baselinePayload = extractPowerShellPayload(baselineSource);
    const rows = payload.value.replace(/\r\n?/gu, "\n").split("\n");
    const baselineRows = baselinePayload.value
        .replace(/\r\n?/gu, "\n")
        .split("\n");
    const currentBlankRows = getRenderedBlankRows(rows);
    const baselineBlankRows = getRenderedBlankRows(baselineRows);
    const firstCurrentVisible = currentBlankRows.findIndex(
        (isBlank) => !isBlank
    );
    const firstBaselineVisible = baselineBlankRows.findIndex(
        (isBlank) => !isBlank
    );
    const currentLeadingRows =
        firstCurrentVisible === -1
            ? currentBlankRows.length
            : firstCurrentVisible;
    const baselineLeadingRows =
        firstBaselineVisible === -1
            ? baselineBlankRows.length
            : firstBaselineVisible;
    const isExtreme =
        currentLeadingRows >= 15 ||
        (currentLeadingRows >= 3 &&
            currentLeadingRows / rows.length >= 0.5);
    if (
        !isExtreme ||
        currentLeadingRows <= baselineLeadingRows ||
        firstCurrentVisible === -1 ||
        firstBaselineVisible === -1
    ) {
        return { changed: false, removedRows: 0, source };
    }

    const indexes = new Set();
    for (
        let index = baselineLeadingRows;
        index < currentLeadingRows;
        index += 1
    ) {
        indexes.add(index);
    }
    const updatedRows = removeRowsPreservingControls(rows, indexes);
    const updatedSource = documentCuration(
        replacePayloadRows(source, payload, updatedRows)
    );
    return {
        changed: updatedSource !== source,
        removedRows: indexes.size,
        source: updatedSource,
    };
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
 * Validate one-based inclusive terminal-cell column ranges.
 *
 * @param {unknown} columnRanges
 * @returns {{ end: number; start: number }[]}
 */
function validateColumnRanges(columnRanges) {
    if (!Array.isArray(columnRanges) || columnRanges.length === 0) {
        throw new RangeError(
            "Column ranges must be a non-empty array."
        );
    }
    let previousEnd = 0;
    return columnRanges.map((range) => {
        if (
            !range ||
            typeof range !== "object" ||
            !Number.isSafeInteger(range.start) ||
            !Number.isSafeInteger(range.end) ||
            range.start < 1 ||
            range.end < range.start ||
            range.start <= previousEnd
        ) {
            throw new RangeError(
                "Column ranges must be sorted, non-overlapping, one-based inclusive safe integers."
            );
        }
        previousEnd = range.end;
        return { end: range.end, start: range.start };
    });
}

/**
 * Blank only explicitly reviewed source-cell columns. ANSI sequences do not
 * consume a source cell. The one legacy raw CP437 0x16 glyph required by the
 * retained corpus consumes one source cell and is retained byte-for-byte;
 * every other unmatched C0 byte fails closed. The accepted glyph set is
 * deliberately narrow so ambiguous Unicode display widths fail closed.
 *
 * @param {string} rawRow
 * @param {{ end: number; start: number }[]} columnRanges
 * @returns {string}
 */
function blankTextColumns(rawRow, columnRanges) {
    if (/[\t\r\n]/u.test(rawRow)) {
        throw new RangeError(
            "Targeted column blanking does not support tabs or line breaks."
        );
    }
    const ranges = validateColumnRanges(columnRanges);
    let result = "";
    let rawCursor = 0;
    let visibleColumn = 0;
    let changedCharacters = 0;
    let rangeIndex = 0;

    /**
     * @param {string} plainText
     * @returns {void}
     */
    const appendPlainText = (plainText) => {
        for (const character of plainText) {
            if (LEGACY_CP437_SOURCE_CELL_PATTERN.test(character)) {
                visibleColumn += 1;
                while (
                    rangeIndex < ranges.length &&
                    visibleColumn > ranges[rangeIndex].end
                ) {
                    rangeIndex += 1;
                }
                if (
                    rangeIndex < ranges.length &&
                    visibleColumn >= ranges[rangeIndex].start &&
                    visibleColumn <= ranges[rangeIndex].end
                ) {
                    throw new RangeError(
                        "Targeted column ranges may not select raw C0 source cells."
                    );
                }
                result += character;
                continue;
            }
            if (RAW_C0_PATTERN.test(character)) {
                throw new RangeError(
                    "Targeted column blanking encountered an unsupported raw C0 control."
                );
            }
            if (
                !/^[\u0020-\u007E]$/u.test(character) &&
                !ART_GLYPH_SINGLE_PATTERN.test(character)
            ) {
                throw new RangeError(
                    "Targeted column blanking encountered a glyph with ambiguous terminal width."
                );
            }
            visibleColumn += 1;
            while (
                rangeIndex < ranges.length &&
                visibleColumn > ranges[rangeIndex].end
            ) {
                rangeIndex += 1;
            }
            const selected =
                rangeIndex < ranges.length &&
                visibleColumn >= ranges[rangeIndex].start &&
                visibleColumn <= ranges[rangeIndex].end;
            if (selected && ART_GLYPH_SINGLE_PATTERN.test(character)) {
                throw new RangeError(
                    "Targeted column ranges may not select terminal-art glyphs."
                );
            }
            if (selected && character !== " ") {
                result += " ";
                changedCharacters += 1;
            } else {
                result += character;
            }
        }
    };

    for (const match of rawRow.matchAll(ANSI_CONTROL_PATTERN)) {
        appendPlainText(rawRow.slice(rawCursor, match.index));
        result += match[0];
        rawCursor = match.index + match[0].length;
    }
    appendPlainText(rawRow.slice(rawCursor));

    const lastRange = ranges.at(-1);
    if (lastRange === undefined || lastRange.end > visibleColumn) {
        throw new RangeError(
            "Targeted column range extends beyond the rendered row."
        );
    }
    if (changedCharacters === 0) {
        throw new RangeError(
            "Targeted column ranges did not redact any visible characters."
        );
    }
    return result;
}

/**
 * @param {string} rawRow
 * @returns {string}
 */
function getRawRowHash(rawRow) {
    return createHash("sha256").update(rawRow, "utf8").digest("hex");
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
    const rows = payload.value.replace(/\r\n?/gu, "\n").split("\n");
    const blankRows = getRenderedBlankRows(rows);
    let lastContentIndex = rows.length - 1;

    while (lastContentIndex >= 0 && blankRows[lastContentIndex]) {
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

    return {
        changed: true,
        removedRows,
        source: replacePayloadRows(source, payload, keptRows),
    };
}

/**
 * @param {string} source
 * @returns {{
 *     contactRows: object[];
 *     internalBlankRuns: object[];
 *     leadingBlankRows: number;
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
    const blankRuns = findBlankRuns(getRenderedBlankRows(rows));
    const leadingBlankRows =
        blankRuns.find((run) => run.kind === "leading")?.count || 0;
    const trailingBlankRows =
        blankRuns.find((run) => run.kind === "trailing")?.count || 0;
    const internalBlankRuns = blankRuns.filter(
        (run) => run.kind === "internal"
    );

    const textRows = [];
    const policyRows = [];
    const contactRows = [];
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
        if (analysis.contactValues.length > 0) {
            contactRows.push({
                ...reportRow,
                categories: analysis.contactCategories,
                values: analysis.contactValues,
            });
        }
    }

    return {
        contactRows,
        internalBlankRuns,
        leadingBlankRows,
        policyRows,
        rowCount: rows.length,
        textRows,
        trailingBlankRows,
    };
}

/**
 * A script can fail terminal rendering or use a dynamic Write-Host expression
 * that the static payload extractor intentionally rejects. Search its authored
 * executable lines as a conservative fallback so those failures do not become
 * a blind spot for literal contact data. Provenance comments are excluded.
 *
 * @param {string} source
 * @returns {{
 *     categories: string[];
 *     row: number;
 *     text: string;
 *     values: string[];
 * }[]}
 */
function auditAuthoredSourceContacts(source) {
    const contactRows = [];
    const rows = source.replace(/\r\n?/gu, "\n").split("\n");
    for (const [index, row] of rows.entries()) {
        if (/^\s*#/u.test(row)) continue;
        const analysis = analyzeRow(row);
        if (analysis.contactValues.length === 0) continue;
        contactRows.push({
            categories: analysis.contactCategories,
            row: index + 1,
            text: analysis.visible,
            values: analysis.contactValues,
        });
    }
    return contactRows;
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
    let skippedSourceFidelityFiles = 0;
    const functionalContactExceptions = [];

    for (const file of files) {
        let source = null;
        try {
            const stat = fs.statSync(file);
            if (stat.size > MAX_SOURCE_BYTES) {
                throw new RangeError(
                    `Source exceeds the ${MAX_SOURCE_BYTES}-byte safety limit.`
                );
            }
            source = fs.readFileSync(file, "utf8");
            if (isSourceFidelityLocked(source)) {
                skippedSourceFidelityFiles += 1;
                continue;
            }
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
            const contactRows = finalAudit.contactRows.filter((row) => {
                if (!isFunctionalContactException(file, row)) {
                    return true;
                }
                functionalContactExceptions.push({
                    file: path
                        .relative(REPOSITORY_ROOT, file)
                        .replaceAll(path.sep, "/"),
                    row: row.row,
                    sha256: getReviewEvidenceHash(row.text),
                });
                return false;
            });
            const reportAudit = {
                ...finalAudit,
                contactRows,
            };
            if (
                reportAudit.contactRows.length > 0 ||
                reportAudit.internalBlankRuns.some((run) => run.count >= 3) ||
                reportAudit.leadingBlankRows >= 3 ||
                reportAudit.trailingBlankRows > 0 ||
                reportAudit.textRows.length > 0 ||
                reportAudit.policyRows.length > 0
            ) {
                records.push({
                    file: path
                        .relative(REPOSITORY_ROOT, file)
                        .replaceAll(path.sep, "/"),
                    ...reportAudit,
                });
            }
        } catch (error) {
            const fallbackContactRows =
                source == null
                    ? []
                    : auditAuthoredSourceContacts(source).filter(
                          (row) =>
                              !isFunctionalContactException(file, row)
                      );
            failures.push({
                error: error instanceof Error ? error.message : String(error),
                fallbackContactRows,
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
            contactRows: records.reduce(
                (total, record) => total + record.contactRows.length,
                0
            ),
            documentedFiles,
            filesWithContactRows: records.filter(
                (record) => record.contactRows.length > 0
            ).length,
            functionalContactExceptions:
                functionalContactExceptions.length,
            failedFileContactRows: failures.reduce(
                (total, failure) =>
                    total + failure.fallbackContactRows.length,
                0
            ),
            failedFilesWithContactRows: failures.filter(
                (failure) => failure.fallbackContactRows.length > 0
            ).length,
            filesWithInternalBlankRuns: records.filter((record) =>
                record.internalBlankRuns.some((run) => run.count >= 3)
            ).length,
            filesWithLeadingBlankRows: records.filter(
                (record) => record.leadingBlankRows >= 3
            ).length,
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
            internalBlankRuns: records.reduce(
                (total, record) =>
                    total +
                    record.internalBlankRuns.filter(
                        (run) => run.count >= 3
                    ).length,
                0
            ),
            leadingBlankRows: records.reduce(
                (total, record) =>
                    total +
                    (record.leadingBlankRows >= 3
                        ? record.leadingBlankRows
                        : 0),
                0
            ),
            policyRows: records.reduce(
                (total, record) => total + record.policyRows.length,
                0
            ),
            removedTrailingRows,
            skippedSourceFidelityFiles,
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
        functionalContactExceptions,
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
    auditAuthoredSourceContacts,
    applyReviewedRows,
    auditSource,
    blankTextColumns,
    blankTextRow,
    compactBlankRowsIntroducedSince,
    documentCuration,
    extractPowerShellPayload,
    findBlankRuns,
    findContactDetails,
    findPolicyTerms,
    getAddedFiles,
    getRenderedBlankRows,
    getRawRowHash,
    getReviewEvidenceHash,
    getWorkingTreeFiles,
    isFunctionalContactException,
    isSourceFidelityLocked,
    isHighConfidencePhone,
    parseArguments,
    replacePayloadRows,
    removeRowsPreservingControls,
    removeFlaggedText,
    removeTrailingBlankRows,
    serializePayload,
    stripAnsiControls,
    trimExpandedLeadingBlankRows,
    validateColumnRanges,
};
