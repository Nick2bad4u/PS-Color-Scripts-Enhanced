import fs from "node:fs";
import path from "node:path";
import process from "node:process";
import { pathToFileURL } from "node:url";

export const GITHUB_RELEASE_BODY_LIMIT = 125_000;
export const DEFAULT_RELEASE_BODY_TARGET = 120_000;

/**
 * Count Unicode code points rather than UTF-16 code units. GitHub documents its
 * release-body limit in characters, and this remains conservative for non-BMP
 * characters such as emoji.
 *
 * @param {string} value
 *
 * @returns {number}
 */
export function countReleaseNoteCharacters(value) {
    return [...value].length;
}

/**
 * @param {string} version
 * @param {string} repository
 *
 * @returns {string}
 */
function buildTruncationNotice(version, repository) {
    const changelogUrl = `https://github.com/${repository}/blob/v${version}/CHANGELOG.md`;
    return `\n\n---\n\n> [!NOTE]\n> These release notes were shortened to fit GitHub's ${GITHUB_RELEASE_BODY_LIMIT.toLocaleString("en-US")}-character body limit. Read the [complete changelog for v${version}](${changelogUrl}) for every change.\n`;
}

/**
 * Bound generated notes at a paragraph boundary while retaining a permanent
 * link to the complete, tag-pinned changelog.
 *
 * @param {string} notes
 * @param {{
 *     maximumCharacters?: number;
 *     repository?: string;
 *     version: string;
 * }} options
 *
 * @returns {{
 *     finalCharacters: number;
 *     notes: string;
 *     originalCharacters: number;
 *     truncated: boolean;
 * }}
 */
export function limitGitHubReleaseNotes(notes, options) {
    const {
        maximumCharacters = DEFAULT_RELEASE_BODY_TARGET,
        repository = "Nick2bad4u/PS-Color-Scripts-Enhanced",
        version,
    } = options;

    if (!/^\d+(?:\.\d+){1,3}$/u.test(version)) {
        throw new Error(`Invalid release version: ${version}`);
    }
    const repositoryParts = repository.split("/");
    if (
        !/^[A-Za-z\d_.-]+\/[A-Za-z\d_.-]+$/u.test(repository) ||
        repositoryParts.some(
            (component) => component === "." || component === ".."
        )
    ) {
        throw new Error(`Invalid GitHub repository: ${repository}`);
    }
    if (
        !Number.isSafeInteger(maximumCharacters) ||
        maximumCharacters < 256 ||
        maximumCharacters > GITHUB_RELEASE_BODY_LIMIT
    ) {
        throw new RangeError(
            `maximumCharacters must be an integer from 256 through ${GITHUB_RELEASE_BODY_LIMIT}.`
        );
    }
    if (typeof notes !== "string" || notes.trim().length === 0) {
        throw new Error("Release notes must contain non-whitespace text.");
    }

    const originalCharacters = countReleaseNoteCharacters(notes);
    if (originalCharacters <= maximumCharacters) {
        return {
            finalCharacters: originalCharacters,
            notes,
            originalCharacters,
            truncated: false,
        };
    }

    const normalized = notes.replace(/\r\n?/gu, "\n").trimEnd();
    const notice = buildTruncationNotice(version, repository);
    const noticeCharacters = countReleaseNoteCharacters(notice);
    const contentBudget = maximumCharacters - noticeCharacters;
    if (contentBudget < 1) {
        throw new RangeError(
            "maximumCharacters is too small to retain content and the changelog notice."
        );
    }

    let prefix = [...normalized].slice(0, contentBudget).join("");
    const paragraphBoundary = prefix.lastIndexOf("\n\n");
    if (paragraphBoundary > 0) {
        prefix = prefix.slice(0, paragraphBoundary);
    }
    prefix = prefix.trimEnd();
    if (prefix.length === 0) {
        throw new Error(
            "Release-note truncation removed all original content."
        );
    }

    const limitedNotes = `${prefix}${notice}`;
    const finalCharacters = countReleaseNoteCharacters(limitedNotes);
    if (finalCharacters > maximumCharacters) {
        throw new Error(
            `Release-note limiter produced ${finalCharacters} characters, exceeding ${maximumCharacters}.`
        );
    }

    return {
        finalCharacters,
        notes: limitedNotes,
        originalCharacters,
        truncated: true,
    };
}

/**
 * @param {string[]} arguments_
 *
 * @returns {{
 *     input: string;
 *     maximumCharacters: number;
 *     output: string;
 *     repository: string;
 *     version: string;
 * }}
 */
function parseArguments(arguments_) {
    const options = {
        input: "",
        maximumCharacters: DEFAULT_RELEASE_BODY_TARGET,
        output: "",
        repository: "Nick2bad4u/PS-Color-Scripts-Enhanced",
        version: "",
    };

    for (const argument of arguments_) {
        const separatorIndex = argument.indexOf("=");
        if (!argument.startsWith("--") || separatorIndex < 3) {
            throw new Error(`Unsupported argument: ${argument}`);
        }
        const name = argument.slice(2, separatorIndex);
        const value = argument.slice(separatorIndex + 1);
        if (name === "input") options.input = value;
        else if (name === "output") options.output = value;
        else if (name === "repository") options.repository = value;
        else if (name === "version") options.version = value;
        else if (name === "maximum-characters") {
            options.maximumCharacters = Number(value);
        } else throw new Error(`Unsupported argument: --${name}`);
    }

    if (options.input.length === 0) throw new Error("--input is required.");
    if (options.output.length === 0) throw new Error("--output is required.");
    if (options.version.length === 0) throw new Error("--version is required.");
    return options;
}

/**
 * @param {string} outputPath
 * @param {string} content
 */
function writeFileAtomic(outputPath, content) {
    const temporaryPath = `${outputPath}.${process.pid}.tmp`;
    try {
        fs.writeFileSync(temporaryPath, content, "utf8");
        fs.renameSync(temporaryPath, outputPath);
    } finally {
        if (fs.existsSync(temporaryPath)) fs.rmSync(temporaryPath);
    }
}

/**
 * @param {string[]} arguments_
 *
 * @returns {void}
 */
export function main(arguments_ = process.argv.slice(2)) {
    const options = parseArguments(arguments_);
    const inputPath = path.resolve(options.input);
    const outputPath = path.resolve(options.output);
    if (!fs.existsSync(inputPath) || !fs.statSync(inputPath).isFile()) {
        throw new Error(`Release-note input does not exist: ${inputPath}`);
    }
    if (inputPath === outputPath) {
        throw new Error("--output must differ from --input.");
    }
    if (fs.existsSync(outputPath)) {
        throw new Error(`Release-note output already exists: ${outputPath}`);
    }

    const result = limitGitHubReleaseNotes(
        fs.readFileSync(inputPath, "utf8"),
        options
    );
    writeFileAtomic(outputPath, result.notes);
    process.stdout.write(
        `${JSON.stringify({
            finalCharacters: result.finalCharacters,
            maximumCharacters: options.maximumCharacters,
            originalCharacters: result.originalCharacters,
            output: outputPath,
            truncated: result.truncated,
        })}\n`
    );
}

if (
    process.argv[1] &&
    import.meta.url === pathToFileURL(path.resolve(process.argv[1])).href
) {
    try {
        main();
    } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        process.stderr.write(
            `Failed to limit GitHub release notes: ${message}\n`
        );
        process.exitCode = 1;
    }
}
