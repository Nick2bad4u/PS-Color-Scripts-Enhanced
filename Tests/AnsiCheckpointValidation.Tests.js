"use strict";

const assert = require("node:assert/strict");
const { test } = require("node:test");
const {
    IMPORTABLE_REPORT_DISPOSITIONS,
    assertCheckpointCurrent,
    reconcileImportedDisposition,
} = require("../scripts/AnsiCheckpointValidation.js");

test("checkpoint validation rejects stale generated content", () => {
    assert.doesNotThrow(() =>
        assertCheckpointCurrent("same-sha256", "same-sha256")
    );
    assert.throws(
        () => assertCheckpointCurrent("old-sha256", "new-sha256"),
        /checkpoint is stale/
    );
});

test("provenance only reconciles importable report dispositions", () => {
    assert.deepEqual(IMPORTABLE_REPORT_DISPOSITIONS, [
        "accepted",
        "already-imported-render",
        "already-imported-source",
    ]);
    for (const disposition of IMPORTABLE_REPORT_DISPOSITIONS) {
        assert.equal(
            reconcileImportedDisposition(
                "2024\u0000mist0624/example.ans",
                disposition
            ),
            "accepted"
        );
    }
    for (const disposition of [
        "rejected-content",
        "rejected-quality",
        "pending-review",
        undefined,
    ]) {
        assert.throws(
            () =>
                reconcileImportedDisposition(
                    "2024\u0000mist0624/example.ans",
                    disposition
                ),
            /expected accepted or already imported/
        );
    }
});
