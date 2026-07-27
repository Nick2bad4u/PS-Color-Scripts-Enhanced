#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");
const {
    isSourceFidelityLocked,
} = require("./Audit-ColorScriptContent.js");
const {
    assertSafeScriptName,
} = require("./Prune-ColorScripts.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const DEFAULT_SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);
const DEFAULT_REASON =
    "Reviewed explicit nudity or adult content; removed under the gallery general-audience policy.";

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
 * @param {unknown[]} auditDocuments
 * @param {string[]} selectedIds
 * @param {string} scriptsDirectory
 * @param {string} [reason]
 * @returns {object}
 */
function createPolicyRemovalManifest(
    auditDocuments,
    selectedIds,
    scriptsDirectory,
    reason = DEFAULT_REASON
) {
    if (!reason.trim()) {
        throw new Error("Removal reason cannot be empty.");
    }
    const sourceIndex = new Map();
    for (const document of auditDocuments) {
        if (!Array.isArray(document)) {
            throw new Error(
                "Policy audit input must be an array of source records."
            );
        }
        for (const source of document) {
            if (
                !source ||
                typeof source !== "object" ||
                typeof source.id !== "string"
            ) {
                throw new Error("Policy audit source record is malformed.");
            }
            const existing = sourceIndex.get(source.id);
            if (
                existing &&
                JSON.stringify(existing) !== JSON.stringify(source)
            ) {
                throw new Error(
                    `Policy audit sources conflict for ${source.id}.`
                );
            }
            sourceIndex.set(source.id, source);
        }
    }
    if (new Set(selectedIds).size !== selectedIds.length) {
        throw new Error("Policy selection repeats a source identifier.");
    }

    const seenScripts = new Set();
    const works = selectedIds
        .map((id) => {
            const source = sourceIndex.get(id);
            if (!source) {
                throw new Error(
                    `Selected policy source is absent from the audits: ${id}`
                );
            }
            if (
                typeof source.sourceUrl !== "string" ||
                !/^https:\/\/16colo\.rs\/pack\/[^/]+\/raw\/[^/]+$/u.test(
                    source.sourceUrl
                ) ||
                !Array.isArray(source.tags) ||
                !source.tags.every(
                    (tag) =>
                        typeof tag === "string" && tag.trim().length > 0
                ) ||
                !Array.isArray(source.scripts) ||
                source.scripts.length === 0
            ) {
                throw new Error(
                    `${id}: policy source metadata is malformed.`
                );
            }
            const scripts = source.scripts.map((name) => {
                if (typeof name !== "string") {
                    throw new Error(
                        `${id}: policy script name is malformed.`
                    );
                }
                assertSafeScriptName(name);
                if (seenScripts.has(name)) {
                    throw new Error(
                        `${name}: policy selection repeats a script.`
                    );
                }
                seenScripts.add(name);
                const scriptPath = path.join(
                    scriptsDirectory,
                    `${name}.ps1`
                );
                if (!fs.existsSync(scriptPath)) {
                    throw new Error(
                        `${name}: selected policy script is missing.`
                    );
                }
                if (
                    isSourceFidelityLocked(
                        fs.readFileSync(scriptPath, "utf8")
                    )
                ) {
                    throw new Error(
                        `${name}: source-fidelity-locked script cannot be removed by content curation.`
                    );
                }
                return name;
            });
            return {
                id,
                scripts: scripts.sort((left, right) =>
                    left.localeCompare(right, "en-US")
                ),
                sourceUrl: source.sourceUrl,
                tags: [...new Set(source.tags)].sort(),
            };
        })
        .sort((left, right) =>
            left.id.localeCompare(right.id, "en-US")
        );
    const scripts = works
        .flatMap((work) =>
            work.scripts.map((name) => ({
                name,
                reason,
                workId: work.id,
            }))
        )
        .sort((left, right) =>
            left.name.localeCompare(right.name, "en-US")
        );

    return {
        schemaVersion: 1,
        reviewedAt: "2026-07-27",
        disposition: "rejected-content",
        policy:
            "Remove works confirmed by official archive tags and manual preview review to contain explicit nudity or adult content. Ambiguous, clothed, or merely suggestive works are not selected automatically.",
        summary: {
            scripts: scripts.length,
            works: works.length,
        },
        works,
        scripts,
    };
}

/**
 * @param {string[]} arguments_
 * @returns {{
 *     auditPaths: string[];
 *     outputPath: string;
 *     scriptsDirectory: string;
 *     selectedIds: string[];
 * }}
 */
function parseArguments(arguments_) {
    const options = {
        auditPaths: [],
        outputPath: path.join(
            REPOSITORY_ROOT,
            "ColorScripts-Enhanced",
            "AnsiPolicyRemovalManifest.json"
        ),
        scriptsDirectory: DEFAULT_SCRIPTS_DIRECTORY,
        selectedIds: [],
    };
    for (const argument of arguments_) {
        if (argument.startsWith("--audit=")) {
            options.auditPaths.push(
                path.resolve(
                    REPOSITORY_ROOT,
                    argument.slice("--audit=".length)
                )
            );
        } else if (argument.startsWith("--include=")) {
            const id = argument.slice("--include=".length);
            if (!/^16colors:[^/]+\/[^/]+$/u.test(id)) {
                throw new Error(
                    `Invalid 16colors source identifier: ${id}`
                );
            }
            options.selectedIds.push(id);
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
            console.log(`Usage: node scripts/Create-ColorScriptPolicyRemovalManifest.js [options]

Options:
  --audit=<path>       Reviewed policy audit JSON; repeatable
  --include=<source>   Selected 16colors:pack/file source; repeatable
  --output=<path>      Validated removal manifest
  --scripts-dir=<path> Current Scripts directory
  --help               Show this help`);
            process.exit(0);
        } else {
            throw new Error(`Unknown option: ${argument}`);
        }
    }
    if (options.auditPaths.length === 0) {
        throw new Error("Provide at least one --audit=<path>.");
    }
    if (options.selectedIds.length === 0) {
        throw new Error("Provide at least one --include=<source>.");
    }
    return options;
}

/**
 * @param {string[]} arguments_
 * @returns {void}
 */
function main(arguments_ = process.argv.slice(2)) {
    const options = parseArguments(arguments_);
    const audits = options.auditPaths.map((auditPath) =>
        JSON.parse(fs.readFileSync(auditPath, "utf8"))
    );
    const manifest = createPolicyRemovalManifest(
        audits,
        options.selectedIds,
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
    createPolicyRemovalManifest,
    main,
    parseArguments,
};
