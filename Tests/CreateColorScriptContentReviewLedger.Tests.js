"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const test = require("node:test");

const {
    createReviewLedger,
    normalizeCategories,
    parseAdditionalReview,
    parseArguments,
} = require("../scripts/Create-ColorScriptContentReviewLedger.js");

test("normalizeCategories keeps unique machine-readable categories", () => {
    assert.deepEqual(
        normalizeCategories([
            "phone",
            "contact-block",
            "phone",
            "Not Valid",
            42,
        ]),
        ["contact-block", "phone"]
    );
});

test("parseAdditionalReview validates file, row, and category syntax", () => {
    assert.deepEqual(
        parseAdditionalReview(
            "16c-example.ps1:25:policy-profanity,promotional-text"
        ),
        {
            action: "blank-text",
            categories: ["policy-profanity", "promotional-text"],
            file: "16c-example.ps1",
            row: 25,
        }
    );
    assert.deepEqual(
        parseAdditionalReview(
            "16c-example.ps1:25:remove-row:orphan-footer"
        ),
        {
            action: "remove-row",
            categories: ["orphan-footer"],
            file: "16c-example.ps1",
            row: 25,
        }
    );
    assert.throws(
        () => parseAdditionalReview("../bad.ps1:1:phone"),
        /Invalid --additional|Unsafe/u
    );
    assert.throws(
        () => parseAdditionalReview("sample.ps1:0:phone"),
        /Invalid --additional/u
    );
});

test("ledger arguments accept supplemental-only reviews", () => {
    assert.throws(() => parseArguments([]), /--review|--additional/u);
    const options = parseArguments([
        "--additional=sample.ps1:3:remove-row:orphan-footer",
    ]);

    assert.equal(options.reviewPath, null);
    assert.deepEqual(options.additional, [
        {
            action: "remove-row",
            categories: ["orphan-footer"],
            file: "sample.ps1",
            row: 3,
        },
    ]);
});

test("createReviewLedger retains hashes and metadata but not identifying text", () => {
    const scriptsDirectory = fs.mkdtempSync(
        path.join(os.tmpdir(), "ansi-review-ledger-")
    );
    try {
        fs.writeFileSync(
            path.join(scriptsDirectory, "manual.ps1"),
            "Write-Host '\nART\nRemove this footer\n'"
        );
        const raw = {
            candidates: [
                {
                    evidence: [
                        {
                            action: "remove-row",
                            category: ["phone"],
                            row: 2,
                            severity: "high",
                            text: "Call 212-555-0198",
                        },
                    ],
                    file: "contact.ps1",
                    sourceFidelityLocked: false,
                },
            ],
            explicitExceptions: [{}],
            falsePositives: [{}, {}],
            parseFailures: [{}],
            summary: {
                candidateFiles: 1,
                filesScanned: 2,
            },
        };
        const ledger = createReviewLedger(
            raw,
            [
                {
                    action: "remove-row",
                    categories: ["policy-profanity"],
                    file: "manual.ps1",
                    row: 3,
                },
            ],
            scriptsDirectory
        );
        const serialized = JSON.stringify(ledger);

        assert.equal(ledger.summary.candidateFiles, 2);
        assert.equal(ledger.summary.evidenceRows, 2);
        assert.equal(ledger.summary.supplementalRows, 1);
        assert.equal(ledger.sourceAudit.filesScanned, 2);
        assert.equal(
            ledger.sourceAudit.explicitFunctionalExceptions,
            1
        );
        assert.equal(ledger.sourceAudit.reviewedFalsePositiveRows, 2);
        assert.equal(ledger.sourceAudit.parseFailures, 1);
        assert.equal(
            ledger.candidates[0].evidence[0].action,
            "remove-row"
        );
        assert.doesNotMatch(serialized, /212-555-0198/u);
        assert.doesNotMatch(serialized, /Remove this footer/u);
        assert.match(serialized, /[a-f\d]{64}/u);
    } finally {
        fs.rmSync(scriptsDirectory, {
            force: true,
            recursive: true,
        });
    }
});

test("createReviewLedger rejects unsupported raw actions", () => {
    assert.throws(
        () =>
            createReviewLedger(
                {
                    candidates: [
                        {
                            evidence: [
                                {
                                    action: "crop-art",
                                    category: ["phone"],
                                    row: 1,
                                    text: "Call 212-555-0198",
                                },
                            ],
                            file: "contact.ps1",
                            sourceFidelityLocked: false,
                        },
                    ],
                },
                [],
                "."
            ),
        /raw row evidence is malformed/u
    );
});
