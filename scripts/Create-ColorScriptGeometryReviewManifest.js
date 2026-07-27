#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");
const {
    extractPowerShellPayload,
    getRenderedBlankRows,
    isSourceFidelityLocked,
} = require("./Audit-ColorScriptContent.js");
const {
    getPayloadSha256,
    validateManifest,
} = require("./Apply-ColorScriptGeometryReview.js");
const {
    assertSafeScriptName,
} = require("./Prune-ColorScripts.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const DEFAULT_SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);

const ACTION_MAP = new Map([
    ["crop-leading-blank-rows", "crop-leading-blank-rows"],
    [
        "crop-orphaned-tail-after-last-substantive-row",
        "crop-orphaned-tail",
    ],
]);

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
 * @param {unknown} classification
 * @param {string} scriptsDirectory
 * @returns {object}
 */
function createGeometryReviewManifest(
    classification,
    scriptsDirectory
) {
    if (
        !classification ||
        typeof classification !== "object" ||
        !Array.isArray(classification.findings)
    ) {
        throw new Error("Geometry classification lacks a findings array.");
    }
    const actions = [];
    for (const finding of classification.findings) {
        if (
            !finding ||
            typeof finding !== "object" ||
            finding.disposition !== "high-confidence-change" ||
            !ACTION_MAP.has(finding.recommendedAction)
        ) {
            continue;
        }
        if (
            typeof finding.script !== "string" ||
            typeof finding.rationale !== "string"
        ) {
            throw new Error("Geometry classification finding is malformed.");
        }
        assertSafeScriptName(finding.script);
        const script = `${finding.script}.ps1`;
        const filePath = path.join(scriptsDirectory, script);
        if (!fs.existsSync(filePath)) {
            throw new Error(`${script}: reviewed script is missing.`);
        }
        const source = fs.readFileSync(filePath, "utf8");
        if (isSourceFidelityLocked(source)) {
            throw new Error(
                `${script}: source-fidelity-locked payload cannot enter a geometry manifest.`
            );
        }
        const payload = extractPowerShellPayload(source);
        const rows = payload.value.replace(/\r\n?/gu, "\n").split("\n");
        const blankRows = getRenderedBlankRows(rows);
        const presentationRows =
            payload.kind === "literal" && blankRows[0] ? 1 : 0;
        const action = ACTION_MAP.get(finding.recommendedAction);
        const common = {
            action,
            expectedPayloadSha256: getPayloadSha256(payload.value),
            reason: finding.rationale,
            script,
            totalRows: rows.length,
        };
        if (action === "crop-leading-blank-rows") {
            if (
                !Number.isSafeInteger(finding.rows) ||
                finding.rows < 1 ||
                finding.rows + presentationRows >= rows.length ||
                blankRows
                    .slice(
                        presentationRows,
                        presentationRows + finding.rows
                    )
                    .some((isBlank) => !isBlank) ||
                blankRows[presentationRows + finding.rows] ||
                (Number.isSafeInteger(finding.totalRows) &&
                    finding.totalRows !==
                        rows.length - presentationRows)
            ) {
                throw new Error(
                    `${script}: leading geometry no longer matches the reviewed finding.`
                );
            }
            actions.push({
                ...common,
                preserveLeadingRows: presentationRows,
                rows: finding.rows,
            });
            continue;
        }
        if (
            !Number.isSafeInteger(finding.startRow) ||
            !Number.isSafeInteger(finding.endRow) ||
            finding.startRow < 2 ||
            finding.endRow < finding.startRow ||
            finding.endRow + presentationRows >= rows.length ||
            blankRows
                .slice(
                    finding.startRow - 1 + presentationRows,
                    finding.endRow + presentationRows
                )
                .some((isBlank) => !isBlank)
        ) {
            throw new Error(
                `${script}: orphan-tail geometry no longer matches the reviewed finding.`
            );
        }
        const visibleTailRows = blankRows
            .slice(finding.endRow + presentationRows)
            .filter((isBlank) => !isBlank).length;
        if (visibleTailRows < 1) {
            throw new Error(`${script}: reviewed orphan tail is now blank.`);
        }
        actions.push({
            ...common,
            gapEndRow: finding.endRow + presentationRows,
            gapStartRow: finding.startRow + presentationRows,
            keepRows: finding.startRow - 1 + presentationRows,
            visibleTailRows,
        });
    }
    const manifest = {
        schemaVersion: 1,
        reviewedAt:
            typeof classification.generatedAt === "string"
                ? classification.generatedAt
                : new Date().toISOString(),
        policy:
            "Apply only high-confidence reviewed crops that remove rendered-blank leading margins or stranded tails after a verified blank gap. Background-colored spaces and source-fidelity-locked payloads fail closed.",
        summary: {
            actions: actions.length,
            leadingCrops: actions.filter(
                (action) =>
                    action.action === "crop-leading-blank-rows"
            ).length,
            orphanTailCrops: actions.filter(
                (action) => action.action === "crop-orphaned-tail"
            ).length,
        },
        actions,
    };
    validateManifest(manifest);
    return manifest;
}

/**
 * @param {string[]} arguments_
 * @returns {{
 *     classificationPath: string;
 *     outputPath: string;
 *     scriptsDirectory: string;
 * }}
 */
function parseArguments(arguments_) {
    const options = {
        classificationPath: null,
        outputPath: path.join(
            REPOSITORY_ROOT,
            "ColorScripts-Enhanced",
            "AnsiGeometryReviewManifest.json"
        ),
        scriptsDirectory: DEFAULT_SCRIPTS_DIRECTORY,
    };
    for (const argument of arguments_) {
        if (argument.startsWith("--classification=")) {
            options.classificationPath = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--classification=".length)
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
        } else if (argument === "--help") {
            console.log(`Usage: node scripts/Create-ColorScriptGeometryReviewManifest.js [options]

Options:
  --classification=<path>  Reviewed geometry classification JSON
  --output=<path>          Hash-locked geometry action manifest
  --scripts-dir=<path>     Colorscript directory
  --help                   Show this help`);
            process.exit(0);
        } else {
            throw new Error(`Unknown option: ${argument}`);
        }
    }
    if (!options.classificationPath) {
        throw new Error("Provide --classification=<path>.");
    }
    return {
        classificationPath: options.classificationPath,
        outputPath: options.outputPath,
        scriptsDirectory: options.scriptsDirectory,
    };
}

/**
 * @param {string[]} arguments_
 * @returns {void}
 */
function main(arguments_ = process.argv.slice(2)) {
    const options = parseArguments(arguments_);
    const classification = JSON.parse(
        fs.readFileSync(options.classificationPath, "utf8")
    );
    const manifest = createGeometryReviewManifest(
        classification,
        options.scriptsDirectory
    );
    fs.mkdirSync(path.dirname(options.outputPath), { recursive: true });
    writeFileAtomic(
        options.outputPath,
        `${JSON.stringify(manifest, null, 2)}\n`
    );
    console.log(JSON.stringify(manifest.summary, null, 2));
    console.log(`Manifest: ${options.outputPath}`);
}

if (require.main === module) {
    main();
}

module.exports = {
    createGeometryReviewManifest,
    main,
    parseArguments,
};
