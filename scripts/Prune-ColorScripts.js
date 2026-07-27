#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");

const { auditSource } = require("./Audit-ColorScriptContent.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);
const SCRIPT_METADATA_PATH = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "ScriptMetadata.psd1"
);
const PROVENANCE_PATH = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "ArtworkProvenance.psd1"
);
const CHECKPOINT_PATH = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "AnsiArchiveCurationCheckpoint.json"
);
const EXCEPTIONS_PATH = path.join(
    REPOSITORY_ROOT,
    "scripts",
    "ColorScriptAnalysisExceptions.json"
);

/**
 * @param {string} value
 * @returns {string}
 */
function escapeRegExp(value) {
    return value.replace(/[.*+?^${}()|[\]\\]/gu, String.raw`\$&`);
}

/**
 * @param {string} name
 * @returns {void}
 */
function assertSafeScriptName(name) {
    if (!/^[a-z0-9][a-z0-9-]*$/u.test(name)) {
        throw new Error(`Unsafe script name: ${name}`);
    }
}

/**
 * @param {string} block
 * @param {string} property
 * @returns {string | null}
 */
function getQuotedProperty(block, property) {
    const expression = new RegExp(
        String.raw`^ {12}${escapeRegExp(property)}\s*=\s*'((?:[^']|'')*)'\r?$`,
        "mu"
    );
    const match = expression.exec(block);
    return match ? match[1].replaceAll("''", "'") : null;
}

/**
 * @param {string} source
 * @param {string[]} names
 * @returns {{
 *     removedBlocks: Map<string, string>;
 *     source: string;
 * }}
 */
function removeProvenanceEntries(source, names) {
    const removedBlocks = new Map();
    const namesToRemove = new Set(names);
    const entryPattern =
        /^ {8}'([^'\r\n]+)'\s*=\s*@\{\r?\n[\s\S]*?^ {8}\}\r?\n/gmu;
    const updated = source.replace(entryPattern, (block, name) => {
        if (!namesToRemove.has(name)) {
            return block;
        }
        if (removedBlocks.has(name)) {
            throw new Error(`${name}: duplicate provenance entry.`);
        }
        removedBlocks.set(name, block);
        return "";
    });
    for (const name of names) {
        if (!removedBlocks.has(name)) {
            throw new Error(`${name}: provenance entry is missing.`);
        }
    }

    return { removedBlocks, source: updated };
}

/**
 * @param {string} source
 * @param {string[]} names
 * @returns {{ removedLines: Map<string, number>; source: string }}
 */
function removeScriptMetadataLines(source, names) {
    const removedLines = new Map(names.map((name) => [name, 0]));
    const namesToRemove = new Set(names);
    const lineEnding = source.includes("\r\n") ? "\r\n" : "\n";
    const output = [];

    for (const line of source.replace(/\r\n?/gu, "\n").split("\n")) {
        const nameMatch = /'([^'\r\n]+)'(?:,|\s*=)/u.exec(line);
        const matchedName =
            nameMatch && namesToRemove.has(nameMatch[1])
                ? nameMatch[1]
                : null;
        if (matchedName) {
            removedLines.set(
                matchedName,
                (removedLines.get(matchedName) || 0) + 1
            );
        } else {
            output.push(line);
        }
    }

    for (const [name, count] of removedLines) {
        if (count < 3) {
            throw new Error(
                `${name}: expected at least three metadata references, found ${count}.`
            );
        }
    }

    return {
        removedLines,
        source: output.join(lineEnding),
    };
}

/**
 * @param {{ exceptions: object[]; schemaVersion: number }} document
 * @param {string[]} names
 * @returns {{
 *     document: { exceptions: object[]; schemaVersion: number };
 *     removedCount: number;
 * }}
 */
function removeAnalysisExceptions(document, names) {
    if (!Array.isArray(document.exceptions)) {
        throw new Error("Analysis exceptions document is malformed.");
    }
    const nameSet = new Set(names);
    const retained = document.exceptions.filter(
        (entry) =>
            !entry ||
            typeof entry !== "object" ||
            !nameSet.has(String(entry.family || ""))
    );
    return {
        document: {
            ...document,
            exceptions: retained,
        },
        removedCount: document.exceptions.length - retained.length,
    };
}

/**
 * @param {object} checkpoint
 * @param {Map<string, string>} removedProvenanceBlocks
 * @param {string} remainingProvenance
 * @returns {object}
 */
function updateCheckpoint(
    checkpoint,
    removedProvenanceBlocks,
    remainingProvenance
) {
    const acceptedSources = checkpoint?.sixteenColors?.acceptedSources;
    const years = checkpoint?.sixteenColors?.years;
    const totals = checkpoint?.sixteenColors?.totals;
    if (
        !Array.isArray(acceptedSources) ||
        !Array.isArray(years) ||
        !totals ||
        typeof totals !== "object"
    ) {
        throw new Error("ANSI archive checkpoint is malformed.");
    }

    const scriptDecrementsByYear = new Map();
    const removedHashes = new Map();
    const remainingSourceHashes = new Set(
        [
            ...remainingProvenance.matchAll(
                /SourceSha256\s*=\s*'([a-f\d]{64})'/giu
            ),
        ].map((match) => match[1].toLocaleLowerCase("en-US"))
    );
    for (const [name, block] of removedProvenanceBlocks) {
        const sourceSha256 = getQuotedProperty(block, "SourceSha256");
        if (!sourceSha256) {
            throw new Error(`${name}: provenance lacks SourceSha256.`);
        }
        const acceptedSource = acceptedSources.find(
            (entry) => entry.sourceSha256 === sourceSha256
        );
        if (!acceptedSource || !Number.isInteger(acceptedSource.archiveYear)) {
            throw new Error(
                `${name}: source hash is absent from the accepted-source checkpoint.`
            );
        }
        scriptDecrementsByYear.set(
            acceptedSource.archiveYear,
            (scriptDecrementsByYear.get(acceptedSource.archiveYear) || 0) + 1
        );
        removedHashes.set(sourceSha256, acceptedSource.archiveYear);
    }

    const updated = structuredClone(checkpoint);
    const fullyRemovedHashes = new Map(
        [...removedHashes].filter(
            ([sourceSha256]) => !remainingSourceHashes.has(sourceSha256)
        )
    );
    updated.sixteenColors.totals.emittedScriptCount -=
        removedProvenanceBlocks.size;
    updated.sixteenColors.totals.importedWorkCount -=
        fullyRemovedHashes.size;
    updated.sixteenColors.totals.acceptedSourceCount -=
        fullyRemovedHashes.size;
    updated.sixteenColors.totals.dispositionTotals.accepted -=
        fullyRemovedHashes.size;
    updated.sixteenColors.totals.dispositionTotals["rejected-quality"] +=
        fullyRemovedHashes.size;
    updated.sixteenColors.acceptedSources =
        updated.sixteenColors.acceptedSources.filter(
            (source) => !fullyRemovedHashes.has(source.sourceSha256)
        );
    for (const [year, decrement] of scriptDecrementsByYear) {
        const yearRecord = updated.sixteenColors.years.find(
            (entry) => entry.year === year
        );
        if (!yearRecord) {
            throw new Error(`Checkpoint year ${year} is missing.`);
        }
        yearRecord.emittedScriptCount -= decrement;
    }
    for (const year of new Set(fullyRemovedHashes.values())) {
        const decrement = [...fullyRemovedHashes.values()].filter(
            (value) => value === year
        ).length;
        const yearRecord = updated.sixteenColors.years.find(
            (entry) => entry.year === year
        );
        yearRecord.importedWorkCount -= decrement;
        yearRecord.dispositionTotals.accepted -= decrement;
        yearRecord.dispositionTotals["rejected-quality"] += decrement;
    }
    return updated;
}

/**
 * @param {string} filePath
 * @param {string} content
 * @returns {void}
 */
function writeFileAtomic(filePath, content) {
    const temporaryPath = `${filePath}.${process.pid}.tmp`;
    fs.writeFileSync(temporaryPath, content, "utf8");
    fs.renameSync(temporaryPath, filePath);
}

/**
 * @param {string[]} arguments_
 * @returns {{
 *     namesPath: string | null;
 *     reportPath: string;
 *     write: boolean;
 * }}
 */
function parseArguments(arguments_) {
    let reportPath = path.join(
        REPOSITORY_ROOT,
        "temp",
        "ansi-content-audit",
        "report.after-text.json"
    );
    let namesPath = null;
    let write = false;

    for (const argument of arguments_) {
        if (argument === "--write") {
            write = true;
        } else if (argument.startsWith("--report=")) {
            reportPath = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--report=".length)
            );
        } else if (argument.startsWith("--names-file=")) {
            namesPath = path.resolve(
                REPOSITORY_ROOT,
                argument.slice("--names-file=".length)
            );
        } else if (argument === "--help") {
            console.log(`Usage: node scripts/Prune-ColorScripts.js [options]

Options:
  --report=<path>  Content-audit report containing all-blank scripts
  --names-file=<path>
                   JSON manifest with scripts selected for removal
  --write          Apply the validated deletions and registry updates
  --help           Show this help`);
            process.exit(0);
        } else {
            throw new Error(`Unknown option: ${argument}`);
        }
    }
    return { namesPath, reportPath, write };
}

/**
 * @param {string[]} arguments_
 * @returns {void}
 */
function main(arguments_ = process.argv.slice(2)) {
    const options = parseArguments(arguments_);
    const selectedFromManifest = options.namesPath !== null;
    const names = selectedFromManifest
        ? (() => {
              const manifest = JSON.parse(
                  fs.readFileSync(options.namesPath, "utf8")
              );
              if (!Array.isArray(manifest.scripts)) {
                  throw new Error("Removal manifest lacks a scripts array.");
              }
              return manifest.scripts.map((entry) => {
                  if (
                      !entry ||
                      typeof entry.name !== "string" ||
                      typeof entry.reason !== "string" ||
                      !entry.reason.trim()
                  ) {
                      throw new Error(
                          "Each removal manifest entry needs a name and reason."
                      );
                  }
                  return entry.name;
              });
          })()
        : (() => {
              const report = JSON.parse(
                  fs.readFileSync(options.reportPath, "utf8")
              );
              return report.records
                  .filter(
                      (record) =>
                          Number(record.rowCount) > 0 &&
                          Number(record.trailingBlankRows) ===
                              Number(record.rowCount)
                  )
                  .map((record) => path.basename(record.file, ".ps1"));
          })();
    names.sort((left, right) => left.localeCompare(right, "en-US"));
    if (new Set(names).size !== names.length) {
        throw new Error("Removal selection contains duplicate script names.");
    }
    if (names.length === 0) {
        console.log("No all-blank scripts were found.");
        return;
    }
    names.forEach(assertSafeScriptName);

    for (const name of names) {
        const scriptPath = path.join(SCRIPTS_DIRECTORY, `${name}.ps1`);
        const source = fs.readFileSync(scriptPath, "utf8");
        if (!selectedFromManifest) {
            const audit = auditSource(source);
            if (
                audit.rowCount === 0 ||
                audit.trailingBlankRows !== audit.rowCount
            ) {
                throw new Error(
                    `${name}: script is not entirely rendered-blank.`
                );
            }
        }
    }

    const metadataSource = fs.readFileSync(SCRIPT_METADATA_PATH, "utf8");
    const provenanceSource = fs.readFileSync(PROVENANCE_PATH, "utf8");
    const checkpoint = JSON.parse(fs.readFileSync(CHECKPOINT_PATH, "utf8"));
    const exceptions = JSON.parse(fs.readFileSync(EXCEPTIONS_PATH, "utf8"));
    const metadataResult = removeScriptMetadataLines(metadataSource, names);
    const provenanceResult = removeProvenanceEntries(
        provenanceSource,
        names
    );
    const exceptionsResult = removeAnalysisExceptions(exceptions, names);
    const updatedCheckpoint = updateCheckpoint(
        checkpoint,
        provenanceResult.removedBlocks,
        provenanceResult.source
    );

    console.log(`Validated scripts selected for removal: ${names.length}`);
    names.forEach((name) => console.log(`  ${name}`));
    console.log(
        `Metadata references: ${[...metadataResult.removedLines.values()].reduce(
            (total, count) => total + count,
            0
        )}`
    );
    console.log(
        `Analysis exceptions: ${exceptionsResult.removedCount}`
    );

    if (!options.write) {
        console.log("Dry run complete. Use --write to apply.");
        return;
    }

    writeFileAtomic(SCRIPT_METADATA_PATH, metadataResult.source);
    writeFileAtomic(PROVENANCE_PATH, provenanceResult.source);
    writeFileAtomic(
        CHECKPOINT_PATH,
        `${JSON.stringify(updatedCheckpoint, null, 2)}\n`
    );
    writeFileAtomic(
        EXCEPTIONS_PATH,
        `${JSON.stringify(exceptionsResult.document, null, 4)}\n`
    );
    for (const name of names) {
        fs.unlinkSync(path.join(SCRIPTS_DIRECTORY, `${name}.ps1`));
    }
    console.log("Pruned empty scripts and synchronized registries.");
}

if (require.main === module) {
    main();
}

module.exports = {
    assertSafeScriptName,
    getQuotedProperty,
    parseArguments,
    removeAnalysisExceptions,
    removeProvenanceEntries,
    removeScriptMetadataLines,
    updateCheckpoint,
};
