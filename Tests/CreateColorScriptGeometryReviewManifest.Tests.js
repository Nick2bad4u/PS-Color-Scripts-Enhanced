"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const test = require("node:test");

const {
    createGeometryReviewManifest,
    parseArguments,
} = require("../scripts/Create-ColorScriptGeometryReviewManifest.js");

test("geometry manifest generator selects only supported reviewed crops", () => {
    const directory = fs.mkdtempSync(
        path.join(os.tmpdir(), "geometry-manifest-")
    );
    try {
        fs.writeFileSync(
            path.join(directory, "leading.ps1"),
            "Write-Host '\n\nART'"
        );
        fs.writeFileSync(
            path.join(directory, "tail.ps1"),
            "Write-Host 'ART\n\n\n.'"
        );
        const manifest = createGeometryReviewManifest(
            {
                generatedAt: "2026-07-27T00:00:00.000Z",
                findings: [
                    {
                        disposition: "high-confidence-change",
                        rationale: "Standalone blank margin.",
                        recommendedAction: "crop-leading-blank-rows",
                        rows: 1,
                        script: "leading",
                        totalRows: 2,
                    },
                    {
                        disposition: "high-confidence-change",
                        endRow: 3,
                        rationale: "Stranded dot.",
                        recommendedAction:
                            "crop-orphaned-tail-after-last-substantive-row",
                        script: "tail",
                        startRow: 2,
                    },
                    {
                        disposition: "retain-authentic-composition",
                        recommendedAction: "none",
                        script: "ignored",
                    },
                ],
            },
            directory
        );

        assert.deepEqual(manifest.summary, {
            actions: 2,
            leadingCrops: 1,
            orphanTailCrops: 1,
        });
        assert.deepEqual(
            manifest.actions.map((action) => action.action),
            ["crop-leading-blank-rows", "crop-orphaned-tail"]
        );
        assert.match(
            manifest.actions[0].expectedPayloadSha256,
            /^[a-f\d]{64}$/u
        );
        assert.equal(
            manifest.actions[0].preserveLeadingRows,
            1
        );
    } finally {
        fs.rmSync(directory, { force: true, recursive: true });
    }
});

test("geometry manifest generator rejects reviewed geometry drift", () => {
    const directory = fs.mkdtempSync(
        path.join(os.tmpdir(), "geometry-manifest-drift-")
    );
    try {
        fs.writeFileSync(
            path.join(directory, "leading.ps1"),
            "Write-Host '\nART'"
        );
        assert.throws(
            () =>
                createGeometryReviewManifest(
                    {
                        findings: [
                            {
                                disposition:
                                    "high-confidence-change",
                                rationale: "Reviewed.",
                                recommendedAction:
                                    "crop-leading-blank-rows",
                                rows: 2,
                                script: "leading",
                            },
                        ],
                    },
                    directory
                ),
            /no longer matches/u
        );
    } finally {
        fs.rmSync(directory, { force: true, recursive: true });
    }
});

test("geometry manifest arguments require a classification", () => {
    assert.throws(
        () => parseArguments([]),
        /--classification/u
    );
});
