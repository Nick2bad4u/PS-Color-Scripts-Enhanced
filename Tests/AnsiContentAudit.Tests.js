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
    blankTextColumns,
    blankTextRow,
    compactBlankRowsIntroducedSince,
    documentCuration,
    extractPowerShellPayload,
    findBlankRuns,
    findContactDetails,
    findPolicyTerms,
    getRenderedBlankRows,
    getRawRowHash,
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

test("blankTextColumns preserves controls, geometry, and unselected cells", () => {
    const input = "\u001b[41mAB\u0016CD ░ EF\u001b[0m";
    const output = blankTextColumns(input, [{ end: 5, start: 4 }]);
    const multiRangeOutput = blankTextColumns(
        "\u001b[31mABC\u001b[0m DEF",
        [
            { end: 1, start: 1 },
            { end: 7, start: 5 },
        ]
    );

    assert.equal(output, "\u001b[41mAB\u0016   ░ EF\u001b[0m");
    assert.equal(multiRangeOutput, "\u001b[31m BC\u001b[0m    ");
    assert.equal(stripAnsiControls(output), "AB   ░ EF");
    assert.equal(
        stripAnsiControls(output).length,
        stripAnsiControls(input).length
    );
});

test("blankTextColumns treats non-breaking spaces as single spacing cells", () => {
    const input = "I\u00A0think. beside";
    const selectedOutput = blankTextColumns(input, [{ end: 8, start: 1 }]);
    const unselectedOutput = blankTextColumns(input, [{ end: 15, start: 10 }]);

    assert.equal(selectedOutput, "         beside");
    assert.equal(unselectedOutput, "I\u00A0think.       ");
    assert.equal([...selectedOutput].length, [...input].length);
    assert.equal([...unselectedOutput].length, [...input].length);
});

test("blankTextColumns treats archived CP437 symbols as single art cells", () => {
    const input = "≡─°²·ⁿ∙♥ cut here ♥─";
    const output = blankTextColumns(input, [
        { end: 12, start: 10 },
        { end: 17, start: 14 },
    ]);

    assert.equal(output, "≡─°²·ⁿ∙♥          ♥─");
    assert.equal([...output].length, [...input].length);
});

test("blankTextColumns preserves CP437 guillemet hotkey framing", () => {
    const input = "«B»Options go here stupid";
    const output = blankTextColumns(input, [{ end: 25, start: 4 }]);

    assert.equal(output, "«B»                      ");
    assert.equal([...output].length, [...input].length);
});

test("blankTextColumns preserves the CP437 not-sign art cell", () => {
    const input = "¬┐  called";
    const output = blankTextColumns(input, [{ end: 10, start: 5 }]);

    assert.equal(output, "¬┐        ");
    assert.equal([...output].length, [...input].length);
});

test("blankTextColumns preserves the CP437 half-sign art cell", () => {
    const input = "!#½gRAPE";
    const output = blankTextColumns(input, [
        { end: 2, start: 1 },
        { end: 8, start: 4 },
    ]);

    assert.equal(output, "  ½     ");
    assert.equal([...output].length, [...input].length);
    assert.throws(
        () => blankTextColumns(input, [{ end: 3, start: 3 }]),
        /terminal-art/u
    );
});

test("blankTextColumns preserves the CP437 pound-sign art cell", () => {
    const input = '.commands @£#!"';
    const output = blankTextColumns(input, [{ end: 11, start: 1 }]);

    assert.equal(output, '           £#!"');
    assert.equal([...output].length, [...input].length);
    assert.throws(
        () => blankTextColumns(input, [{ end: 12, start: 12 }]),
        /terminal-art/u
    );
});

test("blankTextColumns rejects ambiguous or destructive ranges", () => {
    assert.throws(() => blankTextColumns("text", []), /non-empty/u);
    assert.throws(
        () =>
            blankTextColumns("text", [
                { end: 2, start: 1 },
                { end: 3, start: 2 },
            ]),
        /sorted, non-overlapping/u
    );
    assert.throws(
        () => blankTextColumns("text", [{ end: 5, start: 4 }]),
        /beyond/u
    );
    assert.throws(
        () => blankTextColumns("te\txt", [{ end: 2, start: 1 }]),
        /tabs/u
    );
    assert.throws(
        () => blankTextColumns("tést", [{ end: 1, start: 1 }]),
        /ambiguous terminal width/u
    );
    assert.throws(
        () => blankTextColumns("░ text", [{ end: 1, start: 1 }]),
        /terminal-art/u
    );
    assert.throws(
        () => blankTextColumns("A\u0016B", [{ end: 2, start: 2 }]),
        /raw C0/u
    );
    assert.throws(
        () => blankTextColumns("AB\u001b", [{ end: 1, start: 1 }]),
        /unsupported raw C0/u
    );
    assert.throws(
        () => blankTextColumns(" text", [{ end: 1, start: 1 }]),
        /did not redact/u
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

test("reviewed targeted redaction requires pinned output hashes", () => {
    const rawRow = "\u001b[41mLabel: 12345 ░\u001b[0m";
    const source = `Write-Host '
${rawRow}
'`;
    const columnRanges = [{ end: 12, start: 8 }];
    const expectedRow = blankTextColumns(rawRow, columnRanges);
    const evidence = {
        action: "blank-columns",
        columnRanges,
        expectedRawSha256: getRawRowHash(expectedRow),
        expectedRenderedSha256: getReviewEvidenceHash(
            stripAnsiControls(expectedRow)
        ),
        row: 2,
        sha256: getReviewEvidenceHash(stripAnsiControls(rawRow)),
    };
    const result = applyReviewedRows(source, [evidence]);

    assert.equal(result.blankedRows, 1);
    assert.equal(result.removedRows, 0);
    assert.match(result.source, /Label: {7}░/u);
    assert.throws(
        () =>
            applyReviewedRows(source, [
                { ...evidence, expectedRawSha256: "0".repeat(64) },
            ]),
        /projection is stale/u
    );
    assert.throws(
        () =>
            applyReviewedRows(source, [
                {
                    ...evidence,
                    expectedRenderedSha256: "0".repeat(64),
                },
            ]),
        /projection is stale/u
    );
    assert.throws(
        () =>
            applyReviewedRows(source.replace("[41m", "[42m"), [
                evidence,
            ]),
        /projection is stale/u
    );
    assert.throws(
        () =>
            applyReviewedRows(source, [
                {
                    ...evidence,
                    action: "blank-text",
                },
            ]),
        /malformed/u
    );
    assert.throws(
        () =>
            applyReviewedRows(source, [
                evidence,
                {
                    action: "remove-row",
                    row: evidence.row,
                    sha256: evidence.sha256,
                },
            ]),
        /conflicting actions/u
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
    assert.equal(checkpoint.removals.postCurationDuplicateScripts, 19);
    assert.equal(checkpoint.removals.postCurationDuplicateWorks.length, 19);
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
    assert.equal(checkpoint.archiveState.reviewedAnalysisExceptions, 398);
    assert.equal(checkpoint.removals.adultContentWorks, 21);
    assert.equal(checkpoint.policyReview.adultTaggedWorksRetained, 9);
    assert.equal(checkpoint.policyReview.adultTaggedScriptsRetained, 13);
    assert.equal(checkpoint.contentCleanup.totalRowsBlanked, 49796);
    assert.equal(checkpoint.contentCleanup.totalTrailingRowsRemoved, 23973);
    assert.equal(
        checkpoint.contentCleanup.highConfidenceGeometryRowsRemoved,
        767
    );
    assert.equal(checkpoint.contentCleanup.residualContentRowsBlanked, 148);
    assert.equal(checkpoint.contentCleanup.residualContentRowsRemoved, 6);
    assert.equal(checkpoint.contentCleanup.residualGeometryRowsRemoved, 77);
    assert.equal(checkpoint.contentCleanup.contactOrPromotionalRowsBlanked, 646);
    assert.equal(checkpoint.contentCleanup.residualMixedTextRowsBlanked, 15837);
    assert.equal(
        checkpoint.contentCleanup.residualMixedTextTrailingRowsRemoved,
        214
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
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass7FilesRedacted,
        1376
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass7RowsBlanked,
        1897
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass7TrailingRowsRemoved,
        1
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass8FilesRedacted,
        785
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass8RowsBlanked,
        1082
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass8TrailingRowsRemoved,
        6
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass9FilesRedacted,
        134
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass9RowsBlanked,
        207
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass9TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass10FilesRedacted,
        50
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass10RowsBlanked,
        62
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass10TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass11FilesRedacted,
        170
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass11RowsBlanked,
        227
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass11TrailingRowsRemoved,
        9
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass12FilesRedacted,
        76
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass12RowsBlanked,
        87
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass12TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass13FilesRedacted,
        42
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass13RowsBlanked,
        44
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass13TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass14FilesRedacted,
        8
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass14RowsBlanked,
        22
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass14TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass15FilesRedacted,
        4
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass15RowsBlanked,
        5
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass15TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass16FilesRedacted,
        36
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass16RowsBlanked,
        129
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass16TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass17FilesRedacted,
        33
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass17RowsBlanked,
        202
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass17TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass18FilesRedacted,
        20
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass18RowsBlanked,
        134
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass18TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass19FilesRedacted,
        41
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass19RowsBlanked,
        108
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass19TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass20FilesRedacted,
        48
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass20RowsBlanked,
        230
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass20TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass21FilesRedacted,
        42
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass21RowsBlanked,
        264
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass21TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass22FilesRedacted,
        29
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass22RowsBlanked,
        192
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass22TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass23FilesRedacted,
        8
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass23RowsBlanked,
        46
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass23TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass24FilesRedacted,
        1
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass24RowsBlanked,
        4
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass24TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass25FilesRedacted,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass25RowsBlanked,
        13
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass25TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass26FilesRedacted,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass26RowsBlanked,
        4
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass26TrailingRowsRemoved,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass27FilesRedacted,
        53
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass27RowsBlanked,
        81
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass27TrailingRowsRemoved,
        52
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass28FilesRedacted,
        193
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass28RowsBlanked,
        249
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass28TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass29FilesRedacted,
        221
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass29RowsBlanked,
        374
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass29TrailingRowsRemoved,
        7
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass30FilesRedacted,
        95
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass30RowsBlanked,
        331
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass30TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass31FilesRedacted,
        10
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass31RowsBlanked,
        31
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass31TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass32FilesRedacted,
        12
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass32RowsBlanked,
        37
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass32TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass33FilesRedacted,
        10
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass33RowsBlanked,
        50
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass33TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass34FilesRedacted,
        9
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass34RowsBlanked,
        24
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass34TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass35FilesRedacted,
        1
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass35RowsBlanked,
        5
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass35TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass36FilesRedacted,
        42
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass36RowsBlanked,
        55
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass36TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass37FilesRedacted,
        16
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass37RowsBlanked,
        21
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass37TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass38FilesRedacted,
        5
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass38RowsBlanked,
        14
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass38TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass39FilesRedacted,
        7
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass39RowsBlanked,
        24
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass39TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass40FilesRedacted,
        14
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass40RowsBlanked,
        35
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass40TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass41FilesRedacted,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass41RowsBlanked,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass41TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass42FilesRedacted,
        12
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass42RowsBlanked,
        85
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass42TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass43FilesRedacted,
        36
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass43RowsBlanked,
        261
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass43TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass44FilesRedacted,
        13
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass44RowsBlanked,
        52
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass44TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass45FilesRedacted,
        12
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass45RowsBlanked,
        30
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass45TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass46FilesRedacted,
        4
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass46RowsBlanked,
        8
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass46TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass47FilesRedacted,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass47RowsBlanked,
        11
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass47TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass48FilesRedacted,
        5
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass48RowsBlanked,
        10
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass48TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass49FilesRedacted,
        1
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass49RowsBlanked,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass49TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass50FilesRedacted,
        39
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass50RowsBlanked,
        40
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass50TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass51FilesRedacted,
        22
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass51RowsBlanked,
        23
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass51TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass52FilesRedacted,
        34
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass52RowsBlanked,
        55
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass52TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass53FilesRedacted,
        13
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass53RowsBlanked,
        17
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass53TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass54FilesRedacted,
        55
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass54RowsBlanked,
        85
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass54TrailingRowsRemoved,
        4
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass55FilesRedacted,
        31
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass55RowsBlanked,
        39
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass55TrailingRowsRemoved,
        8
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass56FilesRedacted,
        8
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass56RowsBlanked,
        18
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass56TrailingRowsRemoved,
        5
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass57FilesRedacted,
        12
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass57RowsBlanked,
        46
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass57TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass58FilesRedacted,
        7
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass58RowsBlanked,
        9
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass58TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass59FilesRedacted,
        3
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass59RowsBlanked,
        4
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass59TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass60FilesRedacted,
        27
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass60RowsBlanked,
        79
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass60TrailingRowsRemoved,
        7
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass61FilesRedacted,
        7
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass61RowsBlanked,
        22
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass61TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass62FilesRedacted,
        7
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass62RowsBlanked,
        16
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass62TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass63FilesRedacted,
        26
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass63RowsBlanked,
        41
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass63TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass64FilesRedacted,
        11
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass64RowsBlanked,
        27
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass64TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass65FilesRedacted,
        69
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass65RowsBlanked,
        129
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass65TrailingRowsRemoved,
        4
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass66FilesRedacted,
        47
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass66RowsBlanked,
        63
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass66TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass67FilesRedacted,
        23
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass67RowsBlanked,
        31
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass67TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass68FilesRedacted,
        16
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass68RowsBlanked,
        19
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass68TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass69FilesRedacted,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass69RowsBlanked,
        4
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass69TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass70FilesRedacted,
        10
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass70RowsBlanked,
        21
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass70TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass71FilesRedacted,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass71RowsBlanked,
        8
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass71TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass72FilesRedacted,
        28
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass72RowsBlanked,
        41
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass72TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass73FilesRedacted,
        6
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass73RowsBlanked,
        17
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass73TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass74FilesRedacted,
        6
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass74RowsBlanked,
        17
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass74TrailingRowsRemoved,
        4
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass75FilesRedacted,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass75RowsBlanked,
        3
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass75TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass76FilesRedacted,
        9
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass76RowsBlanked,
        24
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass76TrailingRowsRemoved,
        3
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass77FilesRedacted,
        10
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass77RowsBlanked,
        19
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass77TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass78FilesRedacted,
        14
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass78RowsBlanked,
        17
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass78TrailingRowsRemoved,
        15
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass79FilesRedacted,
        4
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass79RowsBlanked,
        4
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass79TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass80FilesRedacted,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass80RowsBlanked,
        7
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass80TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass81FilesRedacted,
        7
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass81RowsBlanked,
        18
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass81TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass82FilesRedacted,
        3
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass82RowsBlanked,
        3
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass82TrailingRowsRemoved,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass83FilesRedacted,
        1
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass83RowsBlanked,
        1
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass83TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass84FilesRedacted,
        1
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass84RowsBlanked,
        2
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass84TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass85FilesRedacted,
        1
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass85RowsBlanked,
        1
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass85TrailingRowsRemoved,
        0
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass86FilesRedacted,
        1
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass86RowsBlanked,
        5
    );
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass86TrailingRowsRemoved,
        0
    );
    assert.equal(checkpoint.residualCleanupReview.mixedTextPass87FilesRedacted, 2);
    assert.equal(checkpoint.residualCleanupReview.mixedTextPass87RowsBlanked, 8);
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass87TrailingRowsRemoved,
        0
    );
    assert.equal(checkpoint.residualCleanupReview.mixedTextPass88FilesRedacted, 1);
    assert.equal(checkpoint.residualCleanupReview.mixedTextPass88RowsBlanked, 5);
    assert.equal(
        checkpoint.residualCleanupReview.mixedTextPass88TrailingRowsRemoved,
        0
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
