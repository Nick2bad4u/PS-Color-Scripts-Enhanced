"use strict";

const assert = require("node:assert/strict");
const test = require("node:test");

const {
    applyGeometryAction,
    getPayloadSha256,
    validateManifest,
} = require("../scripts/Apply-ColorScriptGeometryReview.js");
const {
    extractPowerShellPayload,
} = require("../scripts/Audit-ColorScriptContent.js");

function createAction(source, overrides) {
    const payload = extractPowerShellPayload(source);
    return {
        action: "crop-leading-blank-rows",
        expectedPayloadSha256: getPayloadSha256(payload.value),
        reason: "Reviewed excessive standalone margin.",
        rows: 2,
        script: "sample.ps1",
        totalRows: payload.value.split("\n").length,
        ...overrides,
    };
}

test("leading geometry review removes only rendered-blank rows", () => {
    const source =
        "# Source Modification: original conversion\n\nWrite-Host '\n\nART\n'";
    const action = createAction(source);
    const result = applyGeometryAction(source, action);

    assert.equal(result.removedRows, 2);
    assert.equal(extractPowerShellPayload(result.source).value, "ART\n");
    assert.match(result.source, /# Source Modification:/u);
});

test("leading geometry review preserves background-colored spaces", () => {
    const source = "Write-Host '\n\u001b[41m   \u001b[0m\nART'";
    const action = createAction(source, { rows: 2 });

    assert.throws(
        () => applyGeometryAction(source, action),
        /no longer rendered blank/u
    );
});

test("orphan-tail review validates the blank gap before cropping", () => {
    const source = "Write-Host 'ART\n\n\n.\u001b[0m'";
    const action = createAction(source, {
        action: "crop-orphaned-tail",
        gapEndRow: 3,
        gapStartRow: 2,
        keepRows: 1,
        rows: undefined,
        totalRows: 4,
        visibleTailRows: 1,
    });
    const result = applyGeometryAction(source, action);

    assert.equal(result.removedRows, 3);
    assert.equal(
        extractPowerShellPayload(result.source).value,
        "ART\u001b[0m"
    );
});

test("geometry review fails closed on payload drift and fidelity locks", () => {
    const source = "Write-Host '\n\nART'";
    const action = createAction(source);

    assert.throws(
        () =>
            applyGeometryAction(
                source.replace("ART", "CHANGED"),
                action
            ),
        /payload hash has drifted/u
    );
    assert.throws(
        () =>
            applyGeometryAction(
                `# Source Conversion Mode: Passthrough\n${source}`,
                action
            ),
        /source-fidelity-locked/u
    );
});

test("geometry manifest rejects duplicates and invalid coordinates", () => {
    const action = {
        action: "crop-leading-blank-rows",
        expectedPayloadSha256: "a".repeat(64),
        reason: "Reviewed.",
        rows: 2,
        script: "sample.ps1",
        totalRows: 3,
    };

    assert.throws(
        () =>
            validateManifest({
                schemaVersion: 1,
                actions: [action, action],
            }),
        /duplicate/u
    );
    assert.throws(
        () =>
            validateManifest({
                schemaVersion: 1,
                actions: [
                    {
                        ...action,
                        rows: 3,
                    },
                ],
            }),
        /leading-row review geometry is invalid/u
    );
});
