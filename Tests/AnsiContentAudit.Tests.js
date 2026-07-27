"use strict";

const assert = require("node:assert/strict");
const test = require("node:test");

const {
    analyzeRow,
    auditSource,
    blankTextRow,
    documentCuration,
    extractPowerShellPayload,
    findPolicyTerms,
    parseArguments,
    removeFlaggedText,
    removeTrailingBlankRows,
    stripAnsiControls,
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
    assert.deepEqual(findPolicyTerms("classic artwork").terms, []);
});

test("extractPowerShellPayload decodes apostrophes in safe literals", () => {
    const payload = extractPowerShellPayload(
        "# metadata\nWrite-Host '\nartist''s work\n'"
    );

    assert.equal(payload.kind, "literal");
    assert.equal(payload.value, "\nartist's work\n");
});

test("auditSource counts trailing rendered-blank rows including ANSI spaces", () => {
    const source =
        "Write-Host '\nART\n\u001b[41m   \u001b[0m\n\u001b[0m\n'";
    const audit = auditSource(source);

    assert.equal(audit.trailingBlankRows, 3);
    assert.equal(audit.textRows.length, 0);
});

test("blankTextRow preserves ANSI controls, geometry, and art glyphs", () => {
    const input = "\u001b[31m░ Hello, world! ▓\u001b[0m";
    const output = blankTextRow(input);

    assert.equal(
        output,
        "\u001b[31m░               ▓\u001b[0m"
    );
    assert.equal(
        stripAnsiControls(output).length,
        stripAnsiControls(input).length
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
