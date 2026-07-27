"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const test = require("node:test");

const {
    getReviewEvidenceHash,
} = require("../scripts/Audit-ColorScriptContent.js");
const {
    parseArguments,
    verifyReviewApplied,
} = require("../scripts/Test-ColorScriptContentReview.js");

test("parseArguments requires a review ledger", () => {
    assert.throws(() => parseArguments([]), /--review/u);
    const options = parseArguments([
        "--review=temp/review.json",
        "--scripts-dir=temp/scripts",
        "--output=temp/report.json",
    ]);

    assert.match(options.reviewPath, /temp[\\/]review\.json$/u);
    assert.match(options.scriptsDirectory, /temp[\\/]scripts$/u);
    assert.match(options.outputPath, /temp[\\/]report\.json$/u);
});

test("verification finds reviewed text at any shifted row", () => {
    const scriptsDirectory = fs.mkdtempSync(
        path.join(os.tmpdir(), "ansi-review-verification-")
    );
    try {
        const sha256 = getReviewEvidenceHash("reviewed contact");
        fs.writeFileSync(
            path.join(scriptsDirectory, "remaining.ps1"),
            "Write-Host '\nART\n\nreviewed contact\n'"
        );
        fs.writeFileSync(
            path.join(scriptsDirectory, "removed.ps1"),
            "Write-Host '\nART\n'"
        );
        const review = new Map([
            ["remaining.ps1", [{ row: 1, sha256 }]],
            ["removed.ps1", [{ row: 1, sha256 }]],
            ["missing.ps1", [{ row: 1, sha256 }]],
        ]);
        const result = verifyReviewApplied(
            scriptsDirectory,
            review
        );

        assert.deepEqual(result.summary, {
            evidenceHashes: 3,
            failures: 0,
            missingScripts: 1,
            remainingMatches: 1,
            reviewedScripts: 3,
        });
        assert.deepEqual(result.remaining, [
            {
                allowedRemainingOccurrences: 0,
                file: "remaining.ps1",
                rows: [4],
                sha256,
            },
        ]);
        assert.deepEqual(result.missing, ["missing.ps1"]);

        const allowed = verifyReviewApplied(
            scriptsDirectory,
            new Map([
                [
                    "remaining.ps1",
                    [
                        {
                            allowedRemainingOccurrences: 1,
                            row: 1,
                            sha256,
                        },
                    ],
                ],
            ])
        );
        assert.equal(allowed.summary.remainingMatches, 0);
    } finally {
        fs.rmSync(scriptsDirectory, {
            force: true,
            recursive: true,
        });
    }
});
