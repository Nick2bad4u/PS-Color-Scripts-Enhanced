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
const {
    loadReview,
} = require("./Apply-ColorScriptContentReview.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const DEFAULT_SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);

/**
 * @param {string} targetPath
 * @param {string} content
 * @returns {void}
 */
function writeFileAtomic(targetPath, content) {
    const temporaryPath = `${targetPath}.${process.pid}.tmp`;
    fs.writeFileSync(temporaryPath, content, "utf8");
    fs.renameSync(temporaryPath, targetPath);
}

/**
 * @param {string} scriptsDirectory
 * @param {ReturnType<typeof loadReview>} review
 * @returns {{
 *     failures: { error: string; file: string }[];
 *     missing: string[];
 *     remaining: {
 *         file: string;
 *         rows: number[];
 *         sha256: string;
 *     }[];
 *     summary: {
 *         evidenceHashes: number;
 *         failures: number;
 *         missingScripts: number;
 *         remainingMatches: number;
 *         reviewedScripts: number;
 *     };
 * }}
 */
function verifyReviewApplied(scriptsDirectory, review) {
    const failures = [];
    const missing = [];
    const remaining = [];
    let evidenceHashes = 0;
    let missingScripts = 0;
    for (const [fileName, evidence] of review) {
        const filePath = path.join(scriptsDirectory, fileName);
        if (!fs.existsSync(filePath)) {
            missingScripts += 1;
            missing.push(fileName);
            evidenceHashes += evidence.length;
            continue;
        }
        try {
            const payload = extractPowerShellPayload(
                fs.readFileSync(filePath, "utf8")
            );
            const hashRows = new Map();
            for (const [index, row] of payload.value
                .replace(/\r\n?/gu, "\n")
                .split("\n")
                .entries()) {
                const sha256 = getReviewEvidenceHash(
                    stripAnsiControls(row)
                );
                const rows = hashRows.get(sha256) || [];
                rows.push(index + 1);
                hashRows.set(sha256, rows);
            }
            for (const item of evidence) {
                const sha256 =
                    item.sha256 ||
                    (typeof item.text === "string"
                        ? getReviewEvidenceHash(item.text)
                        : null);
                if (!sha256) {
                    throw new Error(
                        "Reviewed evidence lacks a verifiable hash."
                    );
                }
                evidenceHashes += 1;
                const rows = hashRows.get(sha256);
                const allowedRemainingOccurrences =
                    item.allowedRemainingOccurrences || 0;
                if (
                    rows &&
                    rows.length > allowedRemainingOccurrences
                ) {
                    remaining.push({
                        allowedRemainingOccurrences,
                        file: fileName,
                        rows,
                        sha256,
                    });
                }
            }
        } catch (error) {
            failures.push({
                error:
                    error instanceof Error
                        ? error.message
                        : String(error),
                file: fileName,
            });
        }
    }
    return {
        failures,
        missing,
        remaining,
        summary: {
            evidenceHashes,
            failures: failures.length,
            missingScripts,
            remainingMatches: remaining.length,
            reviewedScripts: review.size,
        },
    };
}

/**
 * @param {string[]} arguments_
 * @returns {{
 *     outputPath: string;
 *     reviewPath: string;
 *     scriptsDirectory: string;
 * }}
 */
function parseArguments(arguments_) {
    const options = {
        outputPath: path.join(
            REPOSITORY_ROOT,
            "temp",
            "ansi-content-audit",
            "content-review-verification.json"
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
        } else if (argument.startsWith("--scripts-dir=")) {
            options.scriptsDirectory = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--scripts-dir=".length)
            );
        } else if (argument.startsWith("--output=")) {
            options.outputPath = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--output=".length)
            );
        } else if (argument === "--help") {
            console.log(`Usage: node scripts/Test-ColorScriptContentReview.js [options]

Options:
  --review=<path>        Hash-only reviewed-content ledger
  --scripts-dir=<path>   Current Scripts directory
  --output=<path>        JSON verification report
  --help                 Show this help`);
            process.exit(0);
        } else {
            throw new Error(`Unknown option: ${argument}`);
        }
    }
    if (!options.reviewPath) {
        throw new Error("Provide --review=<path>.");
    }
    return {
        outputPath: options.outputPath,
        reviewPath: options.reviewPath,
        scriptsDirectory: options.scriptsDirectory,
    };
}

/**
 * @param {string[]} arguments_
 * @returns {void}
 */
function main(arguments_ = process.argv.slice(2)) {
    const options = parseArguments(arguments_);
    const result = verifyReviewApplied(
        options.scriptsDirectory,
        loadReview(options.reviewPath)
    );
    fs.mkdirSync(path.dirname(options.outputPath), { recursive: true });
    writeFileAtomic(
        options.outputPath,
        `${JSON.stringify(result, null, 2)}\n`
    );
    console.log(JSON.stringify(result.summary, null, 2));
    console.log(`Report: ${options.outputPath}`);
    if (
        result.summary.failures > 0 ||
        result.summary.remainingMatches > 0
    ) {
        process.exitCode = 1;
    }
}

if (require.main === module) {
    main();
}

module.exports = {
    main,
    parseArguments,
    verifyReviewApplied,
};
