"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const test = require("node:test");

const {
    loadReview,
    main,
    mayContainNewBlankRows,
    parseArguments,
} = require("../scripts/Apply-ColorScriptContentReview.js");

/**
 * @param {(directory: string) => void} callback
 * @returns {void}
 */
function withTemporaryDirectory(callback) {
    const directory = fs.mkdtempSync(
        path.join(os.tmpdir(), "ansi-content-review-")
    );
    try {
        callback(directory);
    } finally {
        fs.rmSync(directory, { force: true, recursive: true });
    }
}

test("parseArguments requires review evidence or a baseline", () => {
    assert.throws(() => parseArguments([]), /Provide --review/u);
    const options = parseArguments([
        "--review=temp/review.json",
        "--baseline-dir=temp/baseline",
        "--scripts-dir=temp/scripts",
        "--output=temp/output.json",
        "--write",
    ]);

    assert.equal(options.write, true);
    assert.equal(options.leadingOnly, false);
    assert.match(options.reviewPath, /temp[\\/]review\.json$/u);
    assert.match(options.baselineDirectory, /temp[\\/]baseline$/u);
    assert.match(options.scriptsDirectory, /temp[\\/]scripts$/u);
    assert.match(options.output, /temp[\\/]output\.json$/u);
});

test("leading-only mode requires a baseline and excludes review evidence", () => {
    assert.throws(
        () => parseArguments(["--leading-only", "--review=temp/a.json"]),
        /requires --baseline-dir/u
    );
    assert.throws(
        () =>
            parseArguments([
                "--leading-only",
                "--baseline-dir=temp/baseline",
                "--review=temp/a.json",
            ]),
        /cannot be combined/u
    );
    const options = parseArguments([
        "--leading-only",
        "--baseline-dir=temp/baseline",
    ]);
    assert.equal(options.leadingOnly, true);
});

test("loadReview rejects duplicate files and conflicting row evidence", () => {
    withTemporaryDirectory((directory) => {
        const reviewPath = path.join(directory, "review.json");
        fs.writeFileSync(
            reviewPath,
            JSON.stringify({
                candidates: [
                    {
                        evidence: [{ row: 1, text: "first" }],
                        file: "sample.ps1",
                    },
                    {
                        evidence: [{ row: 2, text: "second" }],
                        file: "sample.ps1",
                    },
                ],
            })
        );

        assert.throws(() => loadReview(reviewPath), /repeats/u);
        fs.writeFileSync(
            reviewPath,
            JSON.stringify({
                candidates: [
                    {
                        evidence: [
                            { row: 1, text: "first" },
                            { row: 1, text: "second" },
                        ],
                        file: "sample.ps1",
                    },
                ],
            })
        );
        assert.throws(() => loadReview(reviewPath), /conflicting/u);
    });
});

test("loadReview accepts hashed evidence without retaining reviewed text", () => {
    withTemporaryDirectory((directory) => {
        const reviewPath = path.join(directory, "review.json");
        const sha256 = "a".repeat(64);
        fs.writeFileSync(
            reviewPath,
            JSON.stringify({
                candidates: [
                    {
                        evidence: [{ row: 7, sha256 }],
                        file: "sample.ps1",
                    },
                ],
            })
        );

        assert.deepEqual(loadReview(reviewPath), new Map([
            [
                "sample.ps1",
                [{ row: 7, sha256 }],
            ],
        ]));
    });
});

test("loadReview preserves bounded duplicate-hash allowances", () => {
    withTemporaryDirectory((directory) => {
        const reviewPath = path.join(directory, "review.json");
        const sha256 = "b".repeat(64);
        fs.writeFileSync(
            reviewPath,
            JSON.stringify({
                candidates: [
                    {
                        evidence: [
                            {
                                action: "remove-row",
                                allowedRemainingOccurrences: 1,
                                row: 7,
                                sha256,
                            },
                        ],
                        file: "sample.ps1",
                    },
                ],
            })
        );

        assert.deepEqual(loadReview(reviewPath), new Map([
            [
                "sample.ps1",
                [
                    {
                        action: "remove-row",
                        allowedRemainingOccurrences: 1,
                        row: 7,
                        sha256,
                    },
                ],
            ],
        ]));
    });
});

test("baseline comparison distinguishes introduced blanks from authored blanks", () => {
    const baseline =
        "# Source Modification: original\nWrite-Host '\nART\nPROMO\n\n'";
    const changed =
        "# Source Modification: original\nWrite-Host '\nART\n     \n\n'";

    assert.equal(mayContainNewBlankRows(changed, baseline), true);
    assert.equal(mayContainNewBlankRows(baseline, baseline), false);
});

test("dry run leaves unchanged baseline files byte-identical", () => {
    withTemporaryDirectory((directory) => {
        const scriptsDirectory = path.join(directory, "scripts");
        const baselineDirectory = path.join(directory, "baseline");
        const outputPath = path.join(directory, "report.json");
        fs.mkdirSync(scriptsDirectory);
        fs.mkdirSync(baselineDirectory);
        const source =
            "# Source Modification: original conversion\n\nWrite-Host 'ART'";
        const scriptPath = path.join(scriptsDirectory, "sample.ps1");
        fs.writeFileSync(scriptPath, source);
        fs.writeFileSync(path.join(baselineDirectory, "sample.ps1"), source);

        main([
            `--baseline-dir=${baselineDirectory}`,
            `--scripts-dir=${scriptsDirectory}`,
            `--output=${outputPath}`,
        ]);

        assert.equal(fs.readFileSync(scriptPath, "utf8"), source);
        const report = JSON.parse(fs.readFileSync(outputPath, "utf8"));
        assert.equal(report.summary.changedFiles, 0);
        assert.deepEqual(report.records, []);
    });
});
