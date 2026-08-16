#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");
const { createHash } = require("node:crypto");
const {
    documentCuration,
    extractPowerShellPayload,
    getRenderedBlankRows,
    isSourceFidelityLocked,
    removeRowsPreservingControls,
    replacePayloadRows,
} = require("./Audit-ColorScriptContent.js");
const { assertSafeFileName } = require("./Apply-ColorScriptContentReview.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const DEFAULT_SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);

/**
 * @param {string} value
 *
 * @returns {string}
 */
function getPayloadSha256(value) {
    return createHash("sha256")
        .update(value.replace(/\r\n?/gu, "\n"), "utf8")
        .digest("hex");
}

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
 * @param {unknown} document
 *
 * @returns {{
 *     action: "crop-leading-blank-rows" | "crop-orphaned-tail";
 *     expectedPayloadSha256: string;
 *     gapEndRow?: number;
 *     gapStartRow?: number;
 *     keepRows?: number;
 *     preserveLeadingRows?: number;
 *     reason: string;
 *     rows?: number;
 *     script: string;
 *     totalRows: number;
 *     visibleTailRows?: number;
 * }[]}
 */
function validateManifest(document) {
    if (
        !document ||
        typeof document !== "object" ||
        document.schemaVersion !== 1 ||
        !Array.isArray(document.actions)
    ) {
        throw new Error(
            "Geometry review manifest must use schemaVersion 1 and contain an actions array."
        );
    }
    const actions = [];
    const scripts = new Set();
    for (const candidate of document.actions) {
        if (
            !candidate ||
            typeof candidate !== "object" ||
            typeof candidate.script !== "string" ||
            (candidate.action !== "crop-leading-blank-rows" &&
                candidate.action !== "crop-orphaned-tail") ||
            typeof candidate.expectedPayloadSha256 !== "string" ||
            !/^[a-f\d]{64}$/u.test(candidate.expectedPayloadSha256) ||
            !Number.isSafeInteger(candidate.totalRows) ||
            candidate.totalRows < 1 ||
            typeof candidate.reason !== "string" ||
            candidate.reason.trim().length === 0
        ) {
            throw new Error("Geometry review action is malformed.");
        }
        assertSafeFileName(candidate.script);
        if (scripts.has(candidate.script)) {
            throw new Error(
                `${candidate.script}: duplicate geometry review action.`
            );
        }
        scripts.add(candidate.script);
        if (
            candidate.action === "crop-leading-blank-rows" &&
            (!Number.isSafeInteger(candidate.rows) ||
                candidate.rows < 1 ||
                !Number.isSafeInteger(candidate.preserveLeadingRows ?? 0) ||
                (candidate.preserveLeadingRows ?? 0) < 0 ||
                candidate.rows + (candidate.preserveLeadingRows ?? 0) >=
                    candidate.totalRows)
        ) {
            throw new Error(
                `${candidate.script}: leading-row review geometry is invalid.`
            );
        }
        if (
            candidate.action === "crop-orphaned-tail" &&
            (!Number.isSafeInteger(candidate.keepRows) ||
                !Number.isSafeInteger(candidate.gapStartRow) ||
                !Number.isSafeInteger(candidate.gapEndRow) ||
                !Number.isSafeInteger(candidate.visibleTailRows) ||
                candidate.keepRows < 1 ||
                candidate.gapStartRow !== candidate.keepRows + 1 ||
                candidate.gapEndRow < candidate.gapStartRow ||
                candidate.gapEndRow >= candidate.totalRows ||
                candidate.visibleTailRows < 1 ||
                candidate.visibleTailRows >
                    candidate.totalRows - candidate.gapEndRow)
        ) {
            throw new Error(
                `${candidate.script}: orphan-tail review geometry is invalid.`
            );
        }
        actions.push(candidate);
    }
    return actions;
}

/**
 * @param {string} source
 * @param {ReturnType<typeof validateManifest>[number]} action
 *
 * @returns {{ removedRows: number; source: string }}
 */
function applyGeometryAction(source, action) {
    if (isSourceFidelityLocked(source)) {
        throw new Error(
            `${action.script}: source-fidelity-locked payload cannot be curated.`
        );
    }
    const payload = extractPowerShellPayload(source);
    if (getPayloadSha256(payload.value) !== action.expectedPayloadSha256) {
        throw new Error(
            `${action.script}: payload hash has drifted since geometry review.`
        );
    }
    const rows = payload.value.replace(/\r\n?/gu, "\n").split("\n");
    if (rows.length !== action.totalRows) {
        throw new Error(
            `${action.script}: payload row count has drifted since geometry review.`
        );
    }
    const blankRows = getRenderedBlankRows(rows);
    const indexes =
        action.action === "crop-leading-blank-rows"
            ? collectLeadingCropRows(blankRows, action)
            : collectOrphanTailRows(blankRows, rows.length, action);
    const updatedRows = removeRowsPreservingControls(rows, indexes);
    return {
        removedRows: indexes.size,
        source: documentCuration(
            replacePayloadRows(source, payload, updatedRows)
        ),
    };
}

/**
 * @param {boolean[]} blankRows
 * @param {ReturnType<typeof validateManifest>[number]} action
 *
 * @returns {Set<number>}
 */
function collectLeadingCropRows(blankRows, action) {
    const preserveLeadingRows = action.preserveLeadingRows ?? 0;
    for (let index = 0; index < preserveLeadingRows; index += 1) {
        if (!blankRows[index]) {
            throw new Error(
                `${action.script}: preserved presentation row ${index + 1} is no longer rendered blank.`
            );
        }
    }
    const indexes = new Set();
    for (
        let index = preserveLeadingRows;
        index < preserveLeadingRows + action.rows;
        index += 1
    ) {
        if (!blankRows[index]) {
            throw new Error(
                `${action.script}: reviewed leading row ${index + 1} is no longer rendered blank.`
            );
        }
        indexes.add(index);
    }
    if (blankRows[preserveLeadingRows + action.rows]) {
        throw new Error(
            `${action.script}: reviewed leading crop no longer ends before visible content.`
        );
    }
    return indexes;
}

/**
 * @param {boolean[]} blankRows
 * @param {number} rowCount
 * @param {ReturnType<typeof validateManifest>[number]} action
 *
 * @returns {Set<number>}
 */
function collectOrphanTailRows(blankRows, rowCount, action) {
    for (
        let index = action.gapStartRow - 1;
        index < action.gapEndRow;
        index += 1
    ) {
        if (!blankRows[index]) {
            throw new Error(
                `${action.script}: reviewed orphan gap row ${index + 1} is no longer rendered blank.`
            );
        }
    }
    const visibleTailRows = blankRows
        .slice(action.gapEndRow)
        .filter((isBlank) => !isBlank).length;
    if (visibleTailRows !== action.visibleTailRows) {
        throw new Error(`${action.script}: reviewed orphan tail has drifted.`);
    }
    return new Set(
        Array.from(
            { length: rowCount - action.keepRows },
            (unusedValue, index) => index + action.keepRows
        )
    );
}

/**
 * @param {string[]} arguments_
 *
 * @returns {{
 *     manifestPath: string;
 *     onlyScript: string | null;
 *     scriptsDirectory: string;
 *     write: boolean;
 * }}
 */
function parseArguments(arguments_) {
    const options = {
        manifestPath: null,
        onlyScript: null,
        scriptsDirectory: DEFAULT_SCRIPTS_DIRECTORY,
        write: false,
    };
    for (const argument of arguments_) {
        if (argument.startsWith("--manifest=")) {
            options.manifestPath = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--manifest=".length)
            );
        } else if (argument.startsWith("--scripts-dir=")) {
            options.scriptsDirectory = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--scripts-dir=".length)
            );
        } else if (argument.startsWith("--only=")) {
            options.onlyScript = argument.slice("--only=".length);
            assertSafeFileName(options.onlyScript);
        } else if (argument === "--write") {
            options.write = true;
        } else if (argument === "--help") {
            console.log(`Usage: node scripts/Apply-ColorScriptGeometryReview.js [options]

Options:
  --manifest=<path>     Reviewed geometry action manifest
  --scripts-dir=<path>  Colorscript directory
  --only=<script.ps1>   Apply one manifest action for resumable review
  --write               Apply validated actions (default is a dry run)
  --help                Show this help`);
            process.exit(0);
        } else {
            throw new Error(`Unknown option: ${argument}`);
        }
    }
    if (!options.manifestPath) {
        throw new Error("Provide --manifest=<path>.");
    }
    return {
        manifestPath: options.manifestPath,
        onlyScript: options.onlyScript,
        scriptsDirectory: options.scriptsDirectory,
        write: options.write,
    };
}

/**
 * @param {string[]} arguments_
 *
 * @returns {{ changedFiles: number; removedRows: number; write: boolean }}
 */
function main(arguments_ = process.argv.slice(2)) {
    const options = parseArguments(arguments_);
    const manifest = JSON.parse(fs.readFileSync(options.manifestPath, "utf8"));
    const manifestActions = validateManifest(manifest);
    const actions =
        options.onlyScript == null
            ? manifestActions
            : manifestActions.filter(
                  (action) => action.script === options.onlyScript
              );
    if (options.onlyScript != null && actions.length !== 1) {
        throw new Error(
            `${options.onlyScript}: manifest contains no matching geometry action.`
        );
    }
    let removedRows = 0;
    for (const action of actions) {
        const filePath = path.join(options.scriptsDirectory, action.script);
        if (!fs.existsSync(filePath)) {
            throw new Error(`${action.script}: reviewed script is missing.`);
        }
        const source = fs.readFileSync(filePath, "utf8");
        const result = applyGeometryAction(source, action);
        removedRows += result.removedRows;
        if (options.write) {
            writeFileAtomic(filePath, result.source);
        }
    }
    const summary = {
        changedFiles: actions.length,
        removedRows,
        write: options.write,
    };
    console.log(JSON.stringify(summary, null, 2));
    return summary;
}

if (require.main === module) {
    main();
}

module.exports = {
    applyGeometryAction,
    getPayloadSha256,
    main,
    parseArguments,
    validateManifest,
};
