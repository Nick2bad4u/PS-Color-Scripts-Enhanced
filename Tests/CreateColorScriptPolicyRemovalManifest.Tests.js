"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const test = require("node:test");

const {
    createPolicyRemovalManifest,
    parseArguments,
} = require("../scripts/Create-ColorScriptPolicyRemovalManifest.js");

test("parseArguments requires audits and explicit source selections", () => {
    assert.throws(() => parseArguments([]), /--audit/u);
    assert.throws(
        () => parseArguments(["--audit=temp/audit.json"]),
        /--include/u
    );
    const options = parseArguments([
        "--audit=temp/audit.json",
        "--include=16colors:pack/FILE.ANS",
        "--output=temp/manifest.json",
    ]);

    assert.equal(options.auditPaths.length, 1);
    assert.deepEqual(options.selectedIds, [
        "16colors:pack/FILE.ANS",
    ]);
    assert.match(options.outputPath, /temp[\\/]manifest\.json$/u);
});

test("manifest validation checks files, fidelity locks, and duplicates", () => {
    const scriptsDirectory = fs.mkdtempSync(
        path.join(os.tmpdir(), "ansi-policy-manifest-")
    );
    try {
        const source = {
            id: "16colors:pack/FILE.ANS",
            scripts: ["16c-example"],
            sourceUrl:
                "https://16colo.rs/pack/pack/raw/FILE.ANS",
            tags: ["nudity", "nsfw"],
        };
        fs.writeFileSync(
            path.join(scriptsDirectory, "16c-example.ps1"),
            "Write-Host 'ART'"
        );
        const manifest = createPolicyRemovalManifest(
            [[source]],
            [source.id],
            scriptsDirectory
        );

        assert.deepEqual(manifest.summary, {
            scripts: 1,
            works: 1,
        });
        assert.deepEqual(manifest.scripts, [
            {
                name: "16c-example",
                reason:
                    "Reviewed explicit nudity or adult content; removed under the gallery general-audience policy.",
                workId: source.id,
            },
        ]);
        assert.throws(
            () =>
                createPolicyRemovalManifest(
                    [[source]],
                    [source.id, source.id],
                    scriptsDirectory
                ),
            /repeats a source/u
        );
        fs.writeFileSync(
            path.join(scriptsDirectory, "16c-example.ps1"),
            "# Source Conversion Mode: Passthrough\nWrite-Host 'ART'"
        );
        assert.throws(
            () =>
                createPolicyRemovalManifest(
                    [[source]],
                    [source.id],
                    scriptsDirectory
                ),
            /source-fidelity-locked/u
        );
    } finally {
        fs.rmSync(scriptsDirectory, {
            force: true,
            recursive: true,
        });
    }
});
