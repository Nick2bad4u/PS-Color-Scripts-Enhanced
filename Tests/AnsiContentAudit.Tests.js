"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");

const {
    analyzeRow,
    auditAuthoredSourceContacts,
    applyReviewedRows,
    auditSource,
    blankTextRow,
    compactBlankRowsIntroducedSince,
    documentCuration,
    extractPowerShellPayload,
    findBlankRuns,
    findContactDetails,
    findPolicyTerms,
    getRenderedBlankRows,
    getReviewEvidenceHash,
    isFunctionalContactException,
    isSourceFidelityLocked,
    parseArguments,
    removeRowsPreservingControls,
    removeFlaggedText,
    removeTrailingBlankRows,
    stripAnsiControls,
    trimExpandedLeadingBlankRows,
} = require("../scripts/Audit-ColorScriptContent.js");

test("stripAnsiControls removes SGR and OSC controls without removing art", () => {
    const input =
        "\u001b[31mRED\u001b[0m ▓\u001b]8;;https://example.test\u0007link\u001b]8;;\u0007";
    assert.equal(stripAnsiControls(input), "RED ▓link");
});

test("analyzeRow distinguishes prose-like rows from ANSI art rows", () => {
    const prose = analyzeRow("   Greetings from the ANSI scene!   ");
    const art = analyzeRow("███▀▄HELLO▄▀███");

    assert.equal(prose.highConfidenceTextOnly, true);
    assert.equal(prose.textOnlyCandidate, true);
    assert.equal(art.highConfidenceTextOnly, false);
    assert.equal(art.textOnlyCandidate, false);
});

test("findPolicyTerms detects plain and separator-obfuscated terms", () => {
    assert.deepEqual(findPolicyTerms("this is shit").terms, ["shit"]);
    assert.deepEqual(findPolicyTerms("f.u.c.k").terms, ["fuck"]);
    assert.deepEqual(findPolicyTerms("damn n.a.z.i naked"), {
        categories: [
            "hate",
            "profanity",
            "sexual",
        ],
        terms: [
            "damn",
            "naked",
            "nazi",
        ],
    });
    assert.deepEqual(findPolicyTerms("a grape illustration").terms, []);
    assert.deepEqual(findPolicyTerms("g r a p e").terms, []);
    assert.deepEqual(findPolicyTerms("masked 555-xxx-xxxx").terms, []);
    assert.deepEqual(findPolicyTerms("Amroth Gore").terms, []);
    assert.deepEqual(findPolicyTerms("white power slogans"), {
        categories: ["hate"],
        terms: ["white power"],
    });
    assert.deepEqual(findPolicyTerms("classic artwork").terms, []);
});

test("extractPowerShellPayload decodes apostrophes in safe literals", () => {
    const payload = extractPowerShellPayload(
        "# metadata\nWrite-Host '\nartist''s work\n'"
    );

    assert.equal(payload.kind, "literal");
    assert.equal(payload.value, "\nartist's work\n");
});

test("auditSource preserves background-colored spaces as visible artwork", () => {
    const source = "Write-Host '\nART\n\u001b[41m   \u001b[0m\n\u001b[0m\n'";
    const audit = auditSource(source);

    assert.equal(audit.trailingBlankRows, 2);
    assert.equal(audit.textRows.length, 0);
});

test("rendered blank analysis reports leading, internal, and trailing runs", () => {
    const blankRows = getRenderedBlankRows([
        "",
        "\u001b[0m",
        "ART",
        "",
        "\u001b[41m   \u001b[0m",
        "",
    ]);

    assert.deepEqual(blankRows, [
        true,
        true,
        false,
        true,
        false,
        true,
    ]);
    assert.deepEqual(findBlankRuns(blankRows), [
        {
            count: 2,
            endRow: 2,
            kind: "leading",
            startRow: 1,
        },
        {
            count: 1,
            endRow: 4,
            kind: "internal",
            startRow: 4,
        },
        {
            count: 1,
            endRow: 6,
            kind: "trailing",
            startRow: 6,
        },
    ]);
});

test("contact detection finds real endpoints without flagging dates or baud rates", () => {
    assert.deepEqual(
        findContactDetails(
            "Call (212) 555-0198 or mail sysop@example.org; telnet://bbs.example.org"
        ),
        {
            categories: [
                "email",
                "network-endpoint",
                "phone",
            ],
            values: [
                "(212) 555-0198",
                "sysop@example.org",
                "telnet://bbs.example.org",
            ],
        }
    );
    assert.deepEqual(findContactDetails("Node 2:292/5o7.13"), {
        categories: ["network-endpoint"],
        values: ["2:292/5o7.13"],
    });
    assert.deepEqual(findContactDetails("@MSGID: 69:800/0"), {
        categories: ["network-endpoint"],
        values: ["69:800/0"],
    });
    assert.deepEqual(findContactDetails("       11-305-927-78011       "), {
        categories: ["phone"],
        values: ["11-305-927-78011"],
    });
    assert.deepEqual(findContactDetails("    444o4.977.348OOO    "), {
        categories: ["phone"],
        values: ["444o4.977.348OOO"],
    });
    assert.deepEqual(findContactDetails("Released 1997-05-31 at 14400 baud"), {
        categories: [],
        values: [],
    });
    assert.deepEqual(findContactDetails("Date: 11-01-92 (12:17) Number: 107"), {
        categories: [],
        values: [],
    });
    assert.deepEqual(findContactDetails("300/1200/2400 baud accepted"), {
        categories: [],
        values: [],
    });
    assert.deepEqual(findContactDetails("24OO/96OO/144OO Accepted"), {
        categories: [],
        values: [],
    });
    assert.deepEqual(findContactDetails("████ 11111111 ████"), {
        categories: [],
        values: [],
    });
    assert.deepEqual(findContactDetails("░▒ 01110010 011000 ▒░"), {
        categories: [],
        values: [],
    });
    assert.deepEqual(findContactDetails("$$$$OOOOOIIIIIiiiii"), {
        categories: [],
        values: [],
    });
    assert.deepEqual(findContactDetails("Scene ratio 292/507"), {
        categories: [],
        values: [],
    });
    assert.deepEqual(
        findContactDetails("SYSOP [*] SOLITARIO [*] 07-10-97 12:30 115200"),
        {
            categories: [],
            values: [],
        }
    );
});

test("functional contact exceptions are exact-file and exact-row scoped", () => {
    const text =
        "$esc[38;2;200;200;200m        Download from: https://www.nerdfonts.com/$esc[0m";

    assert.equal(
        isFunctionalContactException("nerd-font-test.ps1", { text }),
        true
    );
    assert.equal(
        isFunctionalContactException("nested/nerd-font-test.ps1", {
            text,
        }),
        true
    );
    assert.equal(isFunctionalContactException("other.ps1", { text }), false);
    assert.equal(
        isFunctionalContactException("nerd-font-test.ps1", {
            text: text.replace("https://", "http://"),
        }),
        false
    );
});

test("authored-source fallback audits executable lines but not provenance", () => {
    const source = `# Source URL: https://16colo.rs/pack/example
# Source Attribution: Example 212-555-0100
$number = "212-555-0198"
Write-Host ("Call " + $number)`;

    assert.deepEqual(auditAuthoredSourceContacts(source), [
        {
            categories: ["phone"],
            row: 3,
            text: '$number = "212-555-0198"',
            values: ["212-555-0198"],
        },
    ]);
});

test("blankTextRow preserves ANSI controls, geometry, and art glyphs", () => {
    const input = "\u001b[31m░ Hello, world! ▓\u001b[0m";
    const output = blankTextRow(input);

    assert.equal(output, "\u001b[31m░               ▓\u001b[0m");
    assert.equal(
        stripAnsiControls(output).length,
        stripAnsiControls(input).length
    );
});

test("reviewed row redaction fails closed and preserves neighboring artwork", () => {
    const source = `# Source Modification: original conversion

Write-Host '
\u001b[31m██ ART ██
Call 212-555-0198
\u001b[32m▓▓ MORE ART ▓▓
'`;
    const result = applyReviewedRows(source, [
        { row: 3, text: "Call 212-555-0198" },
    ]);

    assert.equal(result.changed, true);
    assert.equal(result.blankedRows, 1);
    assert.equal(result.removedRows, 0);
    assert.match(result.source, /██ ART ██/u);
    assert.match(result.source, /▓▓ MORE ART ▓▓/u);
    assert.doesNotMatch(result.source, /212-555-0198/u);
    const hashedResult = applyReviewedRows(source, [
        {
            row: 3,
            sha256: getReviewEvidenceHash("Call 212-555-0198"),
        },
    ]);
    assert.equal(hashedResult.source, result.source);
    const removedResult = applyReviewedRows(source, [
        {
            action: "remove-row",
            row: 3,
            sha256: getReviewEvidenceHash("Call 212-555-0198"),
        },
    ]);
    assert.equal(removedResult.blankedRows, 0);
    assert.equal(removedResult.removedRows, 1);
    assert.doesNotMatch(removedResult.source, /212-555-0198/u);
    assert.match(removedResult.source, /██ ART ██\n\u001b\[32m▓▓ MORE ART ▓▓/u);
    assert.throws(
        () =>
            applyReviewedRows(source, [{ row: 3, text: "Call 212-555-0100" }]),
        /stale/u
    );
});

test("reviewed row redaction does not count art-only context as blanked", () => {
    const source = `Write-Host '
██ ART ██
'`;
    const result = applyReviewedRows(source, [
        {
            row: 2,
            sha256: getReviewEvidenceHash("██ ART ██"),
        },
    ]);

    assert.equal(result.blankedRows, 1);
    const artOnlySource = `Write-Host '
██ ▓▓ ██
'`;
    const artOnlyResult = applyReviewedRows(artOnlySource, [
        {
            row: 2,
            sha256: getReviewEvidenceHash("██ ▓▓ ██"),
        },
    ]);
    assert.equal(artOnlyResult.blankedRows, 0);
    assert.equal(artOnlyResult.changed, false);
});

test("baseline compaction removes only rows blanked by curation", () => {
    const baseline = `# Source Modification: original conversion

Write-Host '
ART
Promotional text

\u001b[41m   \u001b[0m
MORE ART
'`;
    const current = baseline.replace("Promotional text", "                ");
    const result = compactBlankRowsIntroducedSince(current, baseline);
    const payload = extractPowerShellPayload(result.source).value;

    assert.equal(result.changed, true);
    assert.equal(result.removedRows, 1);
    assert.doesNotMatch(payload, /Promotional text/u);
    assert.match(payload, /ART\n\n\u001b\[41m {3}\u001b\[0m\nMORE ART/u);
});

test("expanded leading trim restores the original margin only when extreme", () => {
    const baseline = `# Source Modification: original conversion

Write-Host '

Removed heading















ART
'`;
    const current = baseline.replace("Removed heading", "               ");
    const result = trimExpandedLeadingBlankRows(current, baseline);
    const payload = extractPowerShellPayload(result.source).value;

    assert.equal(result.changed, true);
    assert.equal(result.removedRows, 16);
    assert.equal(
        getRenderedBlankRows(payload.split("\n")).findIndex(
            (isBlank) => !isBlank
        ),
        2
    );
    assert.equal(
        trimExpandedLeadingBlankRows(baseline, baseline).changed,
        false
    );
});

test("removed rows carry terminal controls into the retained payload", () => {
    assert.deepEqual(
        removeRowsPreservingControls(
            [
                "\u001b[31mART",
                "\u001b[0m",
                "MORE",
            ],
            new Set([1])
        ),
        ["\u001b[31mART", "\u001b[0mMORE"]
    );
});

test("removeFlaggedText blanks text rows and documents the curation", () => {
    const source = `# Source Modification: original conversion

Write-Host '
\u001b[31m██ ART ██
Read the instructions, please.
\u001b[0m
'`;
    const result = removeFlaggedText(source);
    const audit = auditSource(result.source);

    assert.equal(result.changed, true);
    assert.equal(result.blankedRows, 1);
    assert.equal(result.removedTrailingRows, 3);
    assert.equal(audit.textRows.length, 0);
    assert.equal(audit.trailingBlankRows, 0);
    assert.match(result.source, /project curation removes trailing/u);
    assert.match(result.source, /██ ART ██/u);
});

test("documentCuration replaces only an existing modification notice", () => {
    const documented = documentCuration(
        "# Source Modification: old claim\nWrite-Host 'ART'"
    );
    const undocumented = documentCuration("Write-Host 'ART'");

    assert.match(documented, /removes trailing rendered-blank rows/u);
    assert.doesNotMatch(documented, /old claim/u);
    assert.equal(undocumented, "Write-Host 'ART'");
});

test("source-fidelity locks are explicit and exact", () => {
    assert.equal(
        isSourceFidelityLocked(
            "# Source Conversion Mode: Passthrough\nWrite-Host 'ART'"
        ),
        true
    );
    assert.equal(
        isSourceFidelityLocked(
            "# Source Conversion Mode: TerminalEmulation\nWrite-Host 'ART'"
        ),
        false
    );
    assert.equal(
        isSourceFidelityLocked(
            "# Source Modification: preserved byte-for-byte\nWrite-Host 'ART'"
        ),
        false
    );
});

test("removeTrailingBlankRows preserves layout and moves a final reset", () => {
    const source =
        "# metadata\r\n\r\nWrite-Host '\r\n\u001b[31mART\r\n\u001b[0m\r\n'\r\n";
    const result = removeTrailingBlankRows(source);

    assert.equal(result.changed, true);
    assert.equal(result.removedRows, 2);
    assert.equal(
        result.source,
        "# metadata\r\n\r\nWrite-Host '\r\n\u001b[31mART\u001b[0m'\r\n"
    );
    assert.equal(auditSource(result.source).trailingBlankRows, 0);
});

test("removeTrailingBlankRows leaves an all-blank payload unchanged", () => {
    const source = "Write-Host '\n\n'";
    const result = removeTrailingBlankRows(source);

    assert.equal(result.changed, false);
    assert.equal(result.source, source);
});

test("parseArguments accepts explicit audit options", () => {
    const options = parseArguments([
        "--changed-since=origin/main",
        "--document-working-tree",
        "--scripts-dir=ColorScripts-Enhanced/Scripts",
        "--output=temp/report.json",
        "--fix-text",
        "--fix-trailing",
    ]);

    assert.equal(options.changedSince, "origin/main");
    assert.equal(options.documentWorkingTree, true);
    assert.equal(options.fixText, true);
    assert.equal(options.fixTrailing, true);
    assert.match(options.output, /temp[\\/]report\.json$/u);
});

test("content curation checkpoint matches the retained gallery state", () => {
    const checkpoint = JSON.parse(
        fs.readFileSync(
            path.resolve(
                __dirname,
                "..",
                "ColorScripts-Enhanced",
                "AnsiContentCurationCheckpoint.json"
            ),
            "utf8"
        )
    );
    const archiveCheckpoint = JSON.parse(
        fs.readFileSync(
            path.resolve(
                __dirname,
                "..",
                "ColorScripts-Enhanced",
                "AnsiArchiveCurationCheckpoint.json"
            ),
            "utf8"
        )
    );
    const scriptCount = fs
        .readdirSync(
            path.resolve(__dirname, "..", "ColorScripts-Enhanced", "Scripts"),
            { withFileTypes: true }
        )
        .filter(
            (entry) =>
                entry.isFile() &&
                entry.name.toLocaleLowerCase("en-US").endsWith(".ps1")
        ).length;

    assert.equal(checkpoint.schemaVersion, 1);
    assert.equal(
        checkpoint.scope.initialAddedScripts - checkpoint.scope.removedScripts,
        checkpoint.scope.remainingAddedScripts
    );
    assert.equal(checkpoint.scope.finalGalleryScripts, scriptCount);
    assert.equal(
        checkpoint.archiveState.accepted16colorsSources,
        archiveCheckpoint.sixteenColors.totals.acceptedSourceCount
    );
    assert.equal(
        checkpoint.archiveState.emitted16colorsScripts,
        archiveCheckpoint.sixteenColors.totals.emittedScriptCount
    );
    assert.equal(checkpoint.scope.sourceFidelityLockedScripts, 21);
    assert.equal(checkpoint.removals.incompleteSourceWorks.length, 12);
    assert.equal(checkpoint.removals.postCurationDuplicateScripts, 17);
    assert.equal(checkpoint.removals.postCurationDuplicateWorks.length, 17);
    assert.equal(
        checkpoint.removals.allBlankScripts +
            checkpoint.removals.adultContentScripts +
            checkpoint.removals.lowQualityScripts +
            checkpoint.removals.incompleteSourceScripts +
            checkpoint.removals.postCurationDuplicateScripts +
            checkpoint.removals.residualAdvertisementScripts,
        checkpoint.scope.removedScripts
    );
    for (const property of [
        "contactRows",
        "failedFileContactRows",
        "filesWithContactRows",
        "filesWithPolicyRows",
        "filesWithTrailingBlankRows",
        "policyRows",
        "shadowGenuineContactOrPromotionalRows",
        "trailingBlankRows",
    ]) {
        assert.equal(checkpoint.finalAudit[property], 0, property);
    }
    assert.equal(checkpoint.finalAudit.failedFiles, 56);
    assert.equal(checkpoint.finalAudit.functionalContactExceptions, 1);
    assert.equal(checkpoint.finalAudit.sourceFidelityLockedScripts, 21);
    assert.equal(checkpoint.archiveState.reviewedAnalysisExceptions, 404);
    assert.equal(checkpoint.removals.adultContentWorks, 21);
    assert.equal(checkpoint.policyReview.adultTaggedWorksRetained, 9);
    assert.equal(checkpoint.policyReview.adultTaggedScriptsRetained, 13);
    assert.equal(checkpoint.contentCleanup.totalRowsBlanked, 42058);
    assert.equal(checkpoint.contentCleanup.totalTrailingRowsRemoved, 23844);
    assert.equal(
        checkpoint.contentCleanup.highConfidenceGeometryRowsRemoved,
        767
    );
    assert.equal(checkpoint.contentCleanup.residualContentRowsBlanked, 148);
    assert.equal(checkpoint.contentCleanup.residualContentRowsRemoved, 6);
    assert.equal(checkpoint.contentCleanup.residualGeometryRowsRemoved, 77);
    assert.equal(checkpoint.contentCleanup.contactOrPromotionalRowsBlanked, 646);
    assert.equal(checkpoint.contentCleanup.residualMixedTextRowsBlanked, 8098);
    assert.equal(
        checkpoint.contentCleanup.residualMixedTextTrailingRowsRemoved,
        85
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass2FilesRedacted,
        755
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass2RowsBlanked,
        1629
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass2TrailingRowsRemoved,
        23
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass3FilesRedacted,
        753
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass3RowsBlanked,
        1303
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass3TrailingRowsRemoved,
        44
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass4FilesRedacted,
        709
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass4RowsBlanked,
        1311
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass4TrailingRowsRemoved,
        5
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass5FilesRedacted,
        671
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass5RowsBlanked,
        1298
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass5TrailingRowsRemoved,
        7
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass6FilesRedacted,
        1276
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass6RowsBlanked,
        1943
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass6TrailingRowsRemoved,
        5
    );
    assert.equal(checkpoint.removals.residualAdvertisementWorks, 8);
    assert.equal(checkpoint.removals.residualAdvertisementScripts, 27);
    assert.equal(checkpoint.contentCleanup.rebalancedFamilies, 26);
    assert.equal(checkpoint.contentCleanup.rebalancedScripts, 134);
    assert.equal(checkpoint.contentCleanup.rebalancedSourceRowsRetained, 5078);
    assert.equal(
        checkpoint.contentCleanup.rebalancedPresentationRowsDiscarded,
        69
    );
    assert.equal(checkpoint.contentCleanup.rebalancedLeadingRowsRemoved, 544);
    assert.ok(
        Object.values(checkpoint.finalFreshContentOrIntegrityFindings).every(
            (count) => count === 0
        )
    );
});
