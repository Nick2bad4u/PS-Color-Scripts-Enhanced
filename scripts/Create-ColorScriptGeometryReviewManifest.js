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
const { assertSafeScriptName } = require("./Prune-ColorScripts.js");
const { readArtworkProvenance } = require("./ArtworkProvenance.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const DEFAULT_SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);
let checkedInProvenance = null;

const ACTION_MAP = new Map([
    ["crop-leading-blank-rows", "crop-leading-blank-rows"],
    ["crop-orphaned-tail-after-last-substantive-row", "crop-orphaned-tail"],
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
 * Reproduce the analyzer's source-row normalization so reviewed row numbers can
 * be mapped back to the serialized payload. The analyzer removes the
 * serializer's opening presentation row only when the current payload length
 * still matches the declared source span. Earlier curation may legitimately
 * remove trailing blank rows without narrowing the archival source coordinates,
 * in which case the analyzer keeps that presentation row.
 *
 * @param {string} source
 * @param {string[]} rows
 * @param {number} presentationRows
 * @param {{ totalRows?: number }} finding
 * @param {string | null} [externalSourceRows]
 *
 * @returns {number}
 */
function getAnalysisRowOffset(
    source,
    rows,
    presentationRows,
    finding,
    externalSourceRows = null
) {
    if (presentationRows === 0) return 0;
    if (Number.isSafeInteger(finding.totalRows)) {
        if (finding.totalRows === rows.length - presentationRows) {
            return presentationRows;
        }
        if (finding.totalRows === rows.length) return 0;
        throw new Error(
            "Reviewed total rows no longer match either analyzer row convention."
        );
    }
    const sourceRowsMatch = /^(?:# Lines:\s*)?(\d+)\s*-\s*(\d+)\s*$/mu.exec(
        externalSourceRows || source
    );
    if (!sourceRowsMatch) return 0;
    const startRow = Number(sourceRowsMatch[1]);
    const endRow = Number(sourceRowsMatch[2]);
    const declaredRows = endRow - startRow + 1;
    return rows.length === declaredRows + presentationRows
        ? presentationRows
        : 0;
}

/**
 * @param {string} scriptName
 * @param {string} scriptsDirectory
 *
 * @returns {string | null}
 */
function getExternalSourceRows(scriptName, scriptsDirectory) {
    const isCheckedInDirectory =
        path.resolve(scriptsDirectory).toLowerCase() ===
        path.resolve(DEFAULT_SCRIPTS_DIRECTORY).toLowerCase();
    if (!isCheckedInDirectory) return null;
    checkedInProvenance ??= readArtworkProvenance();
    const sourceRows = checkedInProvenance.scripts.get(scriptName)?.SourceRows;
    return typeof sourceRows === "string" ? sourceRows : null;
}

/**
 * @param {object} finding
 * @param {string} scriptsDirectory
 */
function loadGeometryFinding(finding, scriptsDirectory) {
    if (
        typeof finding.script !== "string" ||
        typeof finding.rationale !== "string"
    ) {
        throw new TypeError("Geometry classification finding is malformed.");
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
    const presentationRows = payload.kind === "literal" && blankRows[0] ? 1 : 0;
    const analysisRowOffset = getAnalysisRowOffset(
        source,
        rows,
        presentationRows,
        finding,
        getExternalSourceRows(finding.script, scriptsDirectory)
    );
    return {
        analysisRowOffset,
        blankRows,
        common: {
            action: ACTION_MAP.get(finding.recommendedAction),
            expectedPayloadSha256: getPayloadSha256(payload.value),
            reason: finding.rationale,
            script,
            totalRows: rows.length,
        },
        presentationRows,
        rows,
        script,
    };
}

/**
 * @param {object} finding
 * @param {ReturnType<typeof loadGeometryFinding>} context
 */
function createLeadingGeometryAction(finding, context) {
    const classifiedPresentationRows =
        context.analysisRowOffset === 0 ? context.presentationRows : 0;
    const removableRows = finding.rows - classifiedPresentationRows;
    const reviewedRowsAreBlank = context.blankRows
        .slice(
            context.presentationRows,
            context.presentationRows + removableRows
        )
        .every(Boolean);
    const valid =
        Number.isSafeInteger(finding.rows) &&
        Number.isSafeInteger(removableRows) &&
        removableRows >= 1 &&
        removableRows + context.presentationRows < context.rows.length &&
        reviewedRowsAreBlank &&
        !context.blankRows[context.presentationRows + removableRows];
    if (!valid) {
        throw new Error(
            `${context.script}: leading geometry no longer matches the reviewed finding.`
        );
    }
    return {
        ...context.common,
        preserveLeadingRows: context.presentationRows,
        rows: removableRows,
    };
}

/**
 * @param {object} finding
 * @param {ReturnType<typeof loadGeometryFinding>} context
 */
function createOrphanTailGeometryAction(finding, context) {
    const gapStartRow = finding.startRow + context.analysisRowOffset;
    const gapEndRow = finding.endRow + context.analysisRowOffset;
    const reviewedGapIsBlank = context.blankRows
        .slice(gapStartRow - 1, gapEndRow)
        .every(Boolean);
    const valid =
        Number.isSafeInteger(finding.startRow) &&
        Number.isSafeInteger(finding.endRow) &&
        finding.startRow >= 2 &&
        finding.endRow >= finding.startRow &&
        gapEndRow < context.rows.length &&
        reviewedGapIsBlank;
    if (!valid) {
        throw new Error(
            `${context.script}: orphan-tail geometry no longer matches the reviewed finding.`
        );
    }
    const visibleTailRows = context.blankRows
        .slice(gapEndRow)
        .filter((isBlank) => !isBlank).length;
    if (visibleTailRows < 1) {
        throw new Error(
            `${context.script}: reviewed orphan tail is now blank.`
        );
    }
    return {
        ...context.common,
        gapEndRow,
        gapStartRow,
        keepRows: gapStartRow - 1,
        visibleTailRows,
    };
}

/**
 * @param {object} finding
 * @param {string} scriptsDirectory
 */
function createGeometryAction(finding, scriptsDirectory) {
    const context = loadGeometryFinding(finding, scriptsDirectory);
    return context.common.action === "crop-leading-blank-rows"
        ? createLeadingGeometryAction(finding, context)
        : createOrphanTailGeometryAction(finding, context);
}

/**
 * @param {unknown} classification
 * @param {string} scriptsDirectory
 *
 * @returns {object}
 */
function createGeometryReviewManifest(classification, scriptsDirectory) {
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
        actions.push(createGeometryAction(finding, scriptsDirectory));
    }
    const manifest = {
        schemaVersion: 1,
        reviewedAt:
            typeof classification.generatedAt === "string"
                ? classification.generatedAt
                : new Date().toISOString(),
        policy: "Apply only high-confidence reviewed crops that remove rendered-blank leading margins or stranded tails after a verified blank gap. Background-colored spaces and source-fidelity-locked payloads fail closed.",
        summary: {
            actions: actions.length,
            leadingCrops: actions.filter(
                (action) => action.action === "crop-leading-blank-rows"
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
 *
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
            "audit",
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
 *
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
    getAnalysisRowOffset,
    main,
    parseArguments,
};
