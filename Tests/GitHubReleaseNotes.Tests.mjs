import assert from "node:assert/strict";
import childProcess from "node:child_process";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

import {
    GITHUB_RELEASE_BODY_LIMIT,
    countReleaseNoteCharacters,
    limitGitHubReleaseNotes,
} from "../scripts/Limit-GitHubReleaseNotes.mjs";

const repositoryRoot = path.resolve(
    path.dirname(fileURLToPath(import.meta.url)),
    ".."
);
const scriptPath = path.join(
    repositoryRoot,
    "scripts",
    "Limit-GitHubReleaseNotes.mjs"
);

test("short GitHub release notes remain byte-for-byte unchanged", () => {
    const notes = "## Release\r\n\r\nComplete notes.\r\n";
    const result = limitGitHubReleaseNotes(notes, { version: "2026.8.4.412" });

    assert.equal(result.truncated, false);
    assert.equal(result.notes, notes);
    assert.equal(result.originalCharacters, countReleaseNoteCharacters(notes));
    assert.equal(result.finalCharacters, result.originalCharacters);
});

test("long notes stop at a paragraph and link to the tag-pinned changelog", () => {
    const paragraphs = Array.from(
        { length: 100 },
        (_, index) => `Paragraph ${index}: ${"🎨 ANSI ".repeat(12)}`
    );
    const notes = `${paragraphs.join("\n\n")}\n\nTAIL-MUST-NOT-SHIP`;
    const result = limitGitHubReleaseNotes(notes, {
        maximumCharacters: 1_000,
        version: "2026.8.4.412",
    });

    assert.equal(result.truncated, true);
    assert.ok(result.finalCharacters <= 1_000);
    assert.equal(
        countReleaseNoteCharacters(result.notes),
        result.finalCharacters
    );
    assert.doesNotMatch(result.notes, /TAIL-MUST-NOT-SHIP/u);
    assert.match(
        result.notes,
        /These release notes were shortened to fit GitHub's 125,000-character body limit\./u
    );
    assert.match(result.notes, /blob\/v2026\.8\.4\.412\/CHANGELOG\.md/u);
    assert.match(result.notes, /\n\n---\n\n> \[!NOTE\]\n/u);
});

test("hard truncation preserves complete Unicode code points", () => {
    const result = limitGitHubReleaseNotes("🎨".repeat(2_000), {
        maximumCharacters: 600,
        version: "2026.8.4.412",
    });

    assert.equal(result.truncated, true);
    assert.ok(result.finalCharacters <= 600);
    assert.doesNotMatch(result.notes, /�/u);
});

test("invalid limits and identifiers fail closed", () => {
    assert.throws(
        () =>
            limitGitHubReleaseNotes("notes", {
                maximumCharacters: GITHUB_RELEASE_BODY_LIMIT + 1,
                version: "2026.8.4.412",
            }),
        /maximumCharacters/u
    );
    assert.throws(
        () => limitGitHubReleaseNotes("notes", { version: "not-a-version" }),
        /Invalid release version/u
    );
    assert.throws(
        () =>
            limitGitHubReleaseNotes("notes", {
                repository: "../unsafe",
                version: "2026.8.4.412",
            }),
        /Invalid GitHub repository/u
    );
});

test("CLI writes bounded notes atomically and reports its disposition", () => {
    const temporaryDirectory = fs.mkdtempSync(
        path.join(os.tmpdir(), "github-release-notes-")
    );
    const inputPath = path.join(temporaryDirectory, "input.md");
    const outputPath = path.join(temporaryDirectory, "output.md");
    try {
        fs.writeFileSync(
            inputPath,
            `${"Release paragraph.\n\n".repeat(200)}`,
            "utf8"
        );
        const result = childProcess.spawnSync(
            process.execPath,
            [
                scriptPath,
                `--input=${inputPath}`,
                `--output=${outputPath}`,
                "--version=2026.8.4.412",
                "--maximum-characters=800",
            ],
            { encoding: "utf8" }
        );

        assert.equal(result.status, 0, result.stderr);
        const summary = JSON.parse(result.stdout);
        const output = fs.readFileSync(outputPath, "utf8");
        assert.equal(summary.truncated, true);
        assert.equal(summary.maximumCharacters, 800);
        assert.equal(
            summary.finalCharacters,
            countReleaseNoteCharacters(output)
        );
        assert.ok(summary.finalCharacters <= 800);
    } finally {
        fs.rmSync(temporaryDirectory, { force: true, recursive: true });
    }
});

test("CLI refuses same-path and pre-existing outputs", () => {
    const temporaryDirectory = fs.mkdtempSync(
        path.join(os.tmpdir(), "github-release-notes-guards-")
    );
    const inputPath = path.join(temporaryDirectory, "input.md");
    const outputPath = path.join(temporaryDirectory, "output.md");
    const commonArguments = [
        scriptPath,
        `--input=${inputPath}`,
        "--version=2026.8.4.412",
    ];

    try {
        fs.writeFileSync(inputPath, "Release notes.\n", "utf8");
        const samePathResult = childProcess.spawnSync(
            process.execPath,
            [...commonArguments, `--output=${inputPath}`],
            { encoding: "utf8" }
        );
        assert.notEqual(samePathResult.status, 0);
        assert.match(samePathResult.stderr, /must differ from --input/u);
        assert.equal(fs.readFileSync(inputPath, "utf8"), "Release notes.\n");

        fs.writeFileSync(outputPath, "Do not replace.\n", "utf8");
        const existingOutputResult = childProcess.spawnSync(
            process.execPath,
            [...commonArguments, `--output=${outputPath}`],
            { encoding: "utf8" }
        );
        assert.notEqual(existingOutputResult.status, 0);
        assert.match(existingOutputResult.stderr, /output already exists/u);
        assert.equal(fs.readFileSync(outputPath, "utf8"), "Do not replace.\n");
    } finally {
        fs.rmSync(temporaryDirectory, { force: true, recursive: true });
    }
});
