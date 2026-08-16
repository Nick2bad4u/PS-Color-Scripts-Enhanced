#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");
const {
    extractPowerShellPayload,
    getReviewEvidenceHash,
    stripAnsiControls,
} = require("./Audit-ColorScriptContent.js");
const { assertSafeFileName } = require("./Apply-ColorScriptContentReview.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const DEFAULT_SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);
const ALLOWED_SEVERITIES = new Set([
    "critical",
    "high",
    "medium",
]);

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
 * @param {unknown} value
 *
 * @returns {string[]}
 */
function normalizeCategories(value) {
    if (!Array.isArray(value)) return [];
    return [
        ...new Set(
            value.filter(
                (category) =>
                    typeof category === "string" &&
                    /^[a-z][a-z\d-]*$/u.test(category)
            )
        ),
    ].sort((left, right) => left.localeCompare(right, "en-US"));
}

/**
 * @param {string} value
 *
 * @returns {{
 *     action: "blank-text" | "remove-row";
 *     categories: string[];
 *     file: string;
 *     row: number;
 * }}
 */
function parseAdditionalReview(value) {
    const match =
        /^(?<file>[^:]+\.ps1):(?<row>[1-9]\d*):(?:(?<action>blank-text|remove-row):)?(?<categories>[a-z][a-z\d-]*(?:,[a-z][a-z\d-]*)*)$/u.exec(
            value
        );
    if (!match?.groups) {
        throw new Error(
            `Invalid --additional review: ${value}. Expected file.ps1:row:[blank-text|remove-row:]category[,category].`
        );
    }
    assertSafeFileName(match.groups.file);
    return {
        action:
            match.groups.action === "remove-row" ? "remove-row" : "blank-text",
        categories: normalizeCategories(match.groups.categories.split(",")),
        file: match.groups.file,
        row: Number.parseInt(match.groups.row, 10),
    };
}

/**
 * @param {Map<string, Map<number, object>>} candidates
 * @param {{
 *     action?: "blank-text" | "remove-row";
 *     categories: string[];
 *     file: string;
 *     row: number;
 *     severity?: string;
 *     sha256: string;
 * }} evidence
 *
 * @returns {void}
 */
function addEvidence(candidates, evidence) {
    let rows = candidates.get(evidence.file);
    if (!rows) {
        rows = new Map();
        candidates.set(evidence.file, rows);
    }
    const existing =
        /**
         * @type {{
         *           categories?: string[];
         *           severity?: string;
         *           sha256?: string;
         *       }
         *     | undefined}
         */ (rows.get(evidence.row));
    if (existing && existing.sha256 !== evidence.sha256) {
        throw new Error(
            `${evidence.file}: row ${evidence.row} has conflicting review evidence.`
        );
    }
    const categories = [
        ...new Set([...(existing?.categories || []), ...evidence.categories]),
    ].sort((left, right) => left.localeCompare(right, "en-US"));
    const severity = evidence.severity || existing?.severity;
    rows.set(evidence.row, {
        action:
            evidence.action ||
            /** @type {"blank-text" | "remove-row"} */ (
                existing?.action || "blank-text"
            ),
        categories,
        row: evidence.row,
        ...(severity ? { severity } : {}),
        sha256: evidence.sha256,
    });
}

/**
 * @param {unknown} candidate
 * @param {Map<string, Map<number, object>>} candidates
 */
function addRawCandidateEvidence(candidate, candidates) {
    if (
        !candidate ||
        typeof candidate !== "object" ||
        typeof candidate.file !== "string" ||
        !Array.isArray(candidate.evidence)
    ) {
        throw new Error("Raw review candidate is malformed.");
    }
    assertSafeFileName(candidate.file);
    if (candidate.sourceFidelityLocked === true) {
        throw new Error(
            `${candidate.file}: source-fidelity-locked payload cannot enter the review ledger.`
        );
    }
    for (const evidence of candidate.evidence) {
        if (
            !evidence ||
            typeof evidence !== "object" ||
            !Number.isInteger(evidence.row) ||
            evidence.row < 1 ||
            typeof evidence.text !== "string" ||
            (evidence.action != null &&
                evidence.action !== "blank-text" &&
                evidence.action !== "remove-row")
        ) {
            throw new Error(
                `${candidate.file}: raw row evidence is malformed.`
            );
        }
        const severity =
            typeof evidence.severity === "string" &&
            ALLOWED_SEVERITIES.has(evidence.severity)
                ? evidence.severity
                : undefined;
        addEvidence(candidates, {
            action:
                evidence.action === "remove-row" ? "remove-row" : "blank-text",
            categories: normalizeCategories(
                evidence.categories ?? evidence.category
            ),
            file: candidate.file,
            row: evidence.row,
            ...(severity ? { severity } : {}),
            sha256: getReviewEvidenceHash(evidence.text),
        });
    }
}

/**
 * @param {Map<string, Map<number, object>>} candidates
 * @param {{
 *     action: "blank-text" | "remove-row";
 *     categories: string[];
 *     file: string;
 *     row: number;
 * }} evidence
 * @param {string} scriptsDirectory
 */
function addSupplementalEvidence(candidates, evidence, scriptsDirectory) {
    const filePath = path.join(scriptsDirectory, evidence.file);
    if (!fs.existsSync(filePath)) {
        throw new Error(
            `${evidence.file}: additional review target is missing.`
        );
    }
    const payload = extractPowerShellPayload(fs.readFileSync(filePath, "utf8"));
    const rows = payload.value.replace(/\r\n?/gu, "\n").split("\n");
    const row = rows[evidence.row - 1];
    if (row == null) {
        throw new RangeError(
            `${evidence.file}: additional review row ${evidence.row} is outside the payload.`
        );
    }
    addEvidence(candidates, {
        action: evidence.action,
        categories: evidence.categories,
        file: evidence.file,
        row: evidence.row,
        severity: "critical",
        sha256: getReviewEvidenceHash(stripAnsiControls(row)),
    });
}

/**
 * @param {Map<string, Map<number, object>>} candidates
 */
function buildReviewedCandidates(candidates) {
    return [...candidates]
        .sort(([left], [right]) => left.localeCompare(right, "en-US"))
        .map(([file, rows]) => ({
            evidence: [...rows.values()].sort(
                (left, right) => left.row - right.row
            ),
            file,
        }));
}

/**
 * @param {{
 *     candidates: unknown[];
 *     explicitExceptions?: unknown[];
 *     falsePositives?: unknown[];
 *     parseFailures?: unknown[];
 *     summary?: Record<string, unknown>;
 * }} raw
 */
function buildSourceAudit(raw) {
    const summary = raw.summary || {};
    return {
        candidateFiles:
            typeof summary.candidateFiles === "number"
                ? summary.candidateFiles
                : raw.candidates.length,
        explicitFunctionalExceptions: Array.isArray(raw.explicitExceptions)
            ? raw.explicitExceptions.length
            : 0,
        filesScanned:
            typeof summary.filesScanned === "number"
                ? summary.filesScanned
                : null,
        parseFailures: Array.isArray(raw.parseFailures)
            ? raw.parseFailures.length
            : 0,
        reviewedFalsePositiveRows: Array.isArray(raw.falsePositives)
            ? raw.falsePositives.length
            : 0,
    };
}

/**
 * @param {unknown} rawDocument
 * @param {{
 *     action: "blank-text" | "remove-row";
 *     categories: string[];
 *     file: string;
 *     row: number;
 * }[]} additional
 * @param {string} scriptsDirectory
 *
 * @returns {object}
 */
function createReviewLedger(rawDocument, additional, scriptsDirectory) {
    if (
        !rawDocument ||
        typeof rawDocument !== "object" ||
        !Array.isArray(rawDocument.candidates)
    ) {
        throw new Error("Raw review report lacks a candidates array.");
    }
    const raw =
        /**
         * @type {{
         *     candidates: unknown[];
         *     explicitExceptions?: unknown[];
         *     falsePositives?: unknown[];
         *     parseFailures?: unknown[];
         *     summary?: Record<string, unknown>;
         * }}
         */ (rawDocument);
    const candidates = new Map();

    for (const candidate of raw.candidates) {
        addRawCandidateEvidence(candidate, candidates);
    }

    for (const evidence of additional) {
        addSupplementalEvidence(candidates, evidence, scriptsDirectory);
    }

    const reviewedCandidates = buildReviewedCandidates(candidates);
    const evidenceRows = reviewedCandidates.reduce(
        (total, candidate) => total + candidate.evidence.length,
        0
    );
    return {
        schemaVersion: 1,
        reviewedAt: "2026-07-27",
        normalization:
            "SHA-256 of UTF-8 rendered row text after ANSI-control removal and outer-whitespace trimming.",
        policy: "Rows were manually reviewed for contact details, identifying information, promotional blocks, or policy-ineligible standalone text. Hash-only evidence avoids retaining removed text.",
        sourceAudit: buildSourceAudit(raw),
        summary: {
            candidateFiles: reviewedCandidates.length,
            evidenceRows,
            supplementalRows: additional.length,
        },
        candidates: reviewedCandidates,
    };
}

/**
 * @param {string[]} arguments_
 *
 * @returns {{
 *     additional: {
 *         action: "blank-text" | "remove-row";
 *         categories: string[];
 *         file: string;
 *         row: number;
 *     }[];
 *     outputPath: string;
 *     reviewPath: string | null;
 *     scriptsDirectory: string;
 * }}
 */
function parseArguments(arguments_) {
    const options = {
        additional: [],
        outputPath: path.join(
            REPOSITORY_ROOT,
            "audit",
            "AnsiContentReviewLedger.json"
        ),
        reviewPath: null,
        scriptsDirectory: DEFAULT_SCRIPTS_DIRECTORY,
    };
    for (const argument of arguments_) {
        if (argument.startsWith("--review=")) {
            options.reviewPath = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--review=".length)
            );
        } else if (argument.startsWith("--output=")) {
            options.outputPath = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--output=".length)
            );
        } else if (argument.startsWith("--scripts-dir=")) {
            options.scriptsDirectory = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--scripts-dir=".length)
            );
        } else if (argument.startsWith("--additional=")) {
            options.additional.push(
                parseAdditionalReview(argument.slice("--additional=".length))
            );
        } else if (argument === "--help") {
            console.log(`Usage: node scripts/Create-ColorScriptContentReviewLedger.js [options]

Options:
  --review=<path>       Raw reviewed-candidate report
  --output=<path>       Hash-only review ledger
  --scripts-dir=<path>  Current Scripts directory for supplemental rows
  --additional=<file.ps1:row:[action:]category[,category]>
                        Add a manually reviewed current payload row
  --help                Show this help`);
            process.exit(0);
        } else {
            throw new Error(`Unknown option: ${argument}`);
        }
    }
    if (!options.reviewPath && options.additional.length === 0) {
        throw new Error(
            "Provide --review=<path>, --additional=<review>, or both."
        );
    }
    return {
        additional: options.additional,
        outputPath: options.outputPath,
        reviewPath: options.reviewPath,
        scriptsDirectory: options.scriptsDirectory,
    };
}

/**
 * @param {string[]} arguments_
 *
 * @returns {void}
 */
function main(arguments_ = process.argv.slice(2)) {
    const options = parseArguments(arguments_);
    const rawDocument = options.reviewPath
        ? JSON.parse(fs.readFileSync(options.reviewPath, "utf8"))
        : {
              candidates: [],
              explicitExceptions: [],
              falsePositives: [],
              parseFailures: [],
              summary: {
                  candidateFiles: 0,
                  filesScanned: null,
              },
          };
    const ledger = createReviewLedger(
        rawDocument,
        options.additional,
        options.scriptsDirectory
    );
    fs.mkdirSync(path.dirname(options.outputPath), { recursive: true });
    writeFileAtomic(options.outputPath, `${JSON.stringify(ledger, null, 2)}\n`);
    console.log(JSON.stringify(ledger.summary, null, 2));
    console.log(`Ledger: ${options.outputPath}`);
}

if (require.main === module) {
    main();
}

module.exports = {
    createReviewLedger,
    main,
    normalizeCategories,
    parseAdditionalReview,
    parseArguments,
};
