"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const { spawnSync } = require("node:child_process");
const { afterEach, test } = require("node:test");

const {
    buildPowerShellOutput,
    buildSourceMetadataHeader,
    convertAnsiToPs1,
    decodeCp437Ansi,
    decodeDosAnsi,
    getSauceFontName,
    MAX_TERMINAL_COLUMNS,
    MAX_TERMINAL_ROWS,
    parseArguments,
    readAnsiFile,
    resolveSauceEncoding,
    stripSauce,
    truncateDosAnsiAtEof,
    trimSauceTextField,
    usesDosAnsiSemantics,
    writePowerShellFile,
} = require("../scripts/Convert-AnsiToColorScript.js");
const {
    buildChunkPs1,
    chooseBalancedBreaks,
    ensureTrailingReset,
    extractLinesFromPs1,
    parseColumnRanges,
    parseArguments: parseSplitArguments,
    writeChunkPs1,
    writeChunkAnsi,
} = require("../scripts/Split-AnsiFile.js");
const conversionVerifier = import("../scripts/Verify-AnsiConversion.mjs");

const temporaryDirectories = [];

afterEach(() => {
    for (const directory of temporaryDirectories.splice(0)) {
        fs.rmSync(directory, { recursive: true, force: true });
    }
});

function createTemporaryDirectory() {
    const directory = fs.mkdtempSync(path.join(os.tmpdir(), "cse-converter-"));
    temporaryDirectories.push(directory);
    return directory;
}

function getPowerShellExecutables() {
    return process.platform === "win32"
        ? ["pwsh.exe", "powershell.exe"]
        : ["pwsh"];
}

function runPowerShell(scriptPath) {
    return getPowerShellExecutables().map((executable) => {
        const result = spawnSync(
            executable,
            [
                "-NoLogo",
                "-NoProfile",
                "-NonInteractive",
                "-File",
                scriptPath,
            ],
            { encoding: "utf8", cwd: path.dirname(scriptPath) }
        );

        assert.equal(
            result.status,
            0,
            `${executable}: ${result.error?.message || result.stderr || result.stdout}`
        );
        return result.stdout.replace(/\r\n/g, "\n");
    });
}

test("generated output treats hostile ANSI text as data", () => {
    const directory = createTemporaryDirectory();
    const sentinel = path.join(directory, "injected.txt");
    const payload = [
        "$env:TEMP ${HOME}",
        `$(Set-Content -LiteralPath '${sentinel}' -Value pwned)`,
        "`n `\" quoted ' apostrophe",
        '"@',
        "'@",
        "\u001b[31mUnicode: café 雪\u001b[0m  ",
    ].join("\n");
    const scriptPath = path.join(directory, "hostile.ps1");

    writePowerShellFile(scriptPath, buildPowerShellOutput(payload));

    const outputs = runPowerShell(scriptPath);
    outputs.forEach((stdout) => assert.equal(stdout, `${payload}\n`));
    assert.equal(fs.existsSync(sentinel), false);
});

test("terminal-emulated output starts artwork below Write-Host", () => {
    assert.equal(
        buildPowerShellOutput("art", { startOnNewLine: true }),
        "Write-Host '\nart'\n"
    );
    assert.equal(
        buildPowerShellOutput("\nalready separated", {
            startOnNewLine: true,
        }),
        "Write-Host '\nalready separated'\n"
    );
});

test("CP437 decoding preserves ANSI controls and emits visible DOS glyphs", () => {
    const input = Buffer.from([
        0x1b,
        ...Buffer.from("[1;34;44m", "ascii"),
        0x00,
        0x07,
        0x08,
        0x0b,
        0x0c,
        0x0e,
        0x0f,
        0x1a,
        0x1c,
        0x1f,
        0x7f,
        0x09,
        0x0d,
        0x0a,
    ]);

    assert.equal(decodeCp437Ansi(input), "\u001b[1;34;44m •◘♂♀♫☼→∟▼⌂\t\r\n");
    const rendered = convertAnsiToPs1(decodeCp437Ansi(input), {
        columns: 80,
        stripSpaceBackground: false,
    });
    assert.match(rendered.lines[0], /•◘♂♀♫☼→∟▼⌂/u);
    assert.doesNotMatch(
        rendered.lines.join("\n"),
        /[\u0000-\u0008\u000b\u000c\u000e-\u001a\u001c-\u001f\u007f]/u
    );
});

test("split output terminates style state without adding a phantom row", () => {
    assert.equal(ensureTrailingReset("art"), "art\u001b[0m");
    assert.equal(ensureTrailingReset("art\n"), "art\u001b[0m\n");
    assert.equal(ensureTrailingReset("art\u001b[0m\n"), "art\u001b[0m\n");
});

test("passthrough preserves sequential ANSI colors, line endings, and apostrophes", () => {
    const directory = createTemporaryDirectory();
    const inputPath = path.join(directory, "botany-like.ansi");
    const outputPath = path.join(directory, "botany-like.ps1");
    const payload = `${[
        "\u001b[38;5;7m  \u001b[38;5;3moo\u001b[38;5;2m|",
        "\u001b[38;5;7m  '  `  \u001b[38;5;8m ",
        "\u001b[0m",
    ].join("\r\n")}\r\n`;
    fs.writeFileSync(inputPath, payload, "utf8");

    const conversion = spawnSync(
        process.execPath,
        [
            path.join(__dirname, "../scripts/Convert-AnsiToColorScript.js"),
            "--utf8",
            "--passthrough",
            inputPath,
            outputPath,
        ],
        { encoding: "utf8" }
    );

    assert.equal(
        conversion.status,
        0,
        conversion.error?.message || conversion.stderr || conversion.stdout
    );
    assert.match(fs.readFileSync(outputPath, "utf8"), /  ''  `/u);

    const expected = payload.replace(/\r\n/g, "\n");
    runPowerShell(outputPath).forEach((stdout) =>
        assert.equal(stdout, expected)
    );
});

test("PowerShell converter emits safe PS5.1-compatible scripts", () => {
    const directory = createTemporaryDirectory();
    const inputPath = path.join(directory, "hostile.ans");
    const sentinel = path.join(directory, "injected.txt");
    const payload = [
        "$env:TEMP",
        "$(Set-Content -LiteralPath 'injected.txt' -Value pwned)",
        "`n ' apostrophe",
        "'@",
    ].join("\n");
    fs.writeFileSync(inputPath, payload.replace(/\n/g, "\r\n"), "ascii");

    for (const executable of getPowerShellExecutables()) {
        const outputPath = path.join(
            directory,
            `${path.basename(executable, ".exe")}.ps1`
        );
        const conversion = spawnSync(
            executable,
            [
                "-NoLogo",
                "-NoProfile",
                "-NonInteractive",
                "-File",
                path.join(
                    __dirname,
                    "../scripts/Convert-AnsiToColorScript.ps1"
                ),
                "-AnsiFile",
                inputPath,
                "-OutputFile",
                outputPath,
            ],
            { encoding: "utf8" }
        );
        assert.equal(
            conversion.status,
            0,
            `${executable}: ${conversion.error?.message || conversion.stderr || conversion.stdout}`
        );
        assert.deepEqual(
            [...fs.readFileSync(outputPath).subarray(0, 3)],
            [
                0xef,
                0xbb,
                0xbf,
            ]
        );
        runPowerShell(outputPath).forEach((stdout) =>
            assert.equal(stdout, `\n${payload}\n`)
        );
    }
    assert.equal(fs.existsSync(sentinel), false);
});

test("PowerShell converter derives one output name per pipeline item", () => {
    const directory = createTemporaryDirectory();
    const outputDirectory = path.join(directory, "output");
    const firstInput = path.join(directory, "first.ans");
    const secondInput = path.join(directory, "second.ans");
    fs.writeFileSync(firstInput, "first", "ascii");
    fs.writeFileSync(secondInput, "second", "ascii");
    const quote = (value) => `'${value.replace(/'/g, "''")}'`;
    const converter = path.join(
        __dirname,
        "../scripts/Convert-AnsiToColorScript.ps1"
    );
    const command = `Get-Item -LiteralPath ${quote(firstInput)},${quote(secondInput)} | & ${quote(converter)} -OutputDirectory ${quote(outputDirectory)} -Confirm:$false`;
    const conversion = spawnSync(
        process.platform === "win32" ? "pwsh.exe" : "pwsh",
        [
            "-NoLogo",
            "-NoProfile",
            "-NonInteractive",
            "-Command",
            command,
        ],
        { encoding: "utf8" }
    );

    assert.equal(conversion.status, 0, conversion.stderr || conversion.stdout);
    assert.equal(fs.existsSync(path.join(outputDirectory, "first.ps1")), true);
    assert.equal(fs.existsSync(path.join(outputDirectory, "second.ps1")), true);
});

test("advanced PowerShell converter forwards encoding options on both engines", () => {
    const directory = createTemporaryDirectory();
    const inputPath = path.join(directory, "unicode.ans");
    fs.writeFileSync(inputPath, "snow: 雪", "utf8");

    for (const executable of getPowerShellExecutables()) {
        const outputPath = path.join(
            directory,
            `advanced-${path.basename(executable, ".exe")}.ps1`
        );
        const conversion = spawnSync(
            executable,
            [
                "-NoLogo",
                "-NoProfile",
                "-NonInteractive",
                "-File",
                path.join(
                    __dirname,
                    "../scripts/Convert-AnsiToColorScript-Advanced.ps1"
                ),
                "-AnsiFile",
                inputPath,
                "-OutputFile",
                outputPath,
                "-Encoding",
                "utf8",
                "-SourceUrl",
                "https://example.test/art/unicode.ans",
                "-SourceRevision",
                "release-2026.07",
                "-SourceSha256",
                "a".repeat(64),
                "-SourceLicense",
                "ISC",
                "-SourceAttribution",
                "Example Artist",
                "-SourceModification",
                "Decoded as UTF-8 and wrapped in a safe PowerShell literal.",
            ],
            { encoding: "utf8" }
        );

        assert.equal(
            conversion.status,
            0,
            `${executable}: ${conversion.error?.message || conversion.stderr || conversion.stdout}`
        );
        runPowerShell(outputPath).forEach((stdout) =>
            assert.equal(stdout, "\nsnow: 雪\n")
        );
        const generatedSource = fs.readFileSync(outputPath, "utf8");
        assert.match(
            generatedSource,
            /# Source URL: https:\/\/example\.test\/art\/unicode\.ans/
        );
        assert.match(generatedSource, /# Source Revision: release-2026\.07/);
        assert.match(generatedSource, /# Source SHA-256: a{64}/);
        assert.match(generatedSource, /# Source License: ISC/);
        assert.match(generatedSource, /# Source Attribution: Example Artist/);
        assert.match(
            generatedSource,
            /# Source Modification: Decoded as UTF-8 and wrapped in a safe PowerShell literal\./
        );
    }
});

test("splitter writes and reads the safe literal format", () => {
    const directory = createTemporaryDirectory();
    const sentinel = path.join(directory, "comment-injected.txt");
    const scriptPath = path.join(directory, "split.ps1");
    const repeatedScriptPath = path.join(directory, "split-repeated.ps1");
    const lines = [
        "$env:PATH",
        "$(throw 'must not execute')",
        "'@",
        "tail  ",
    ];
    const baseInfo = {
        sourceName: `art.ans\nSet-Content -LiteralPath '${sentinel}' -Value pwned`,
        sourceProvenance: {
            url: "https://example.test/art.ans",
            revision: "archive-2026.07",
            sha256: "a".repeat(64),
            license: "ISC",
            attribution: "Example Artist",
            modification:
                "Converted to a safe PowerShell literal and split by rendered rows.",
        },
    };

    writeChunkPs1(scriptPath, { start: 0, end: lines.length, lines }, baseInfo);
    writeChunkPs1(
        repeatedScriptPath,
        { start: 0, end: lines.length, lines },
        baseInfo
    );
    assert.equal(
        fs.readFileSync(scriptPath, "utf8"),
        `\ufeff${buildChunkPs1(
            { start: 0, end: lines.length, lines },
            baseInfo
        )}`
    );

    assert.deepEqual(extractLinesFromPs1(scriptPath), [
        "",
        ...lines.slice(0, -1),
        `${lines.at(-1)}\u001b[0m`,
    ]);
    const outputs = runPowerShell(scriptPath);
    outputs.forEach((stdout) =>
        assert.equal(
            stdout,
            `\n${lines.slice(0, -1).join("\n")}\n${lines.at(-1)}\u001b[0m\n`
        )
    );
    assert.deepEqual(
        fs.readFileSync(scriptPath),
        fs.readFileSync(repeatedScriptPath)
    );
    const generatedSource = fs.readFileSync(scriptPath, "utf8");
    assert.match(
        generatedSource,
        /# Source URL: https:\/\/example\.test\/art\.ans/
    );
    assert.match(generatedSource, /# Source Revision: archive-2026\.07/);
    assert.match(generatedSource, /# Source SHA-256: a{64}/);
    assert.match(generatedSource, /# Source License: ISC/);
    assert.match(generatedSource, /# Source Attribution: Example Artist/);
    assert.match(
        generatedSource,
        /# Source Modification: Converted to a safe PowerShell literal and split by rendered rows\./
    );
    assert.equal(fs.existsSync(sentinel), false);
});

test("stripSauce removes EOF before a valid COMNT block", () => {
    const content = Buffer.from([0x41, 0x1a]);
    const comment = Buffer.alloc(69);
    comment.write("COMNT", 0, "ascii");
    const sauce = Buffer.alloc(128);
    sauce.write("SAUCE00", 0, "ascii");
    sauce.write("A\0B", 7, "ascii");
    sauce.writeUInt32LE(1, 90);
    sauce.writeUInt8(1, 104);

    const result = stripSauce(
        Buffer.concat([
            content,
            comment,
            sauce,
        ])
    );

    assert.deepEqual([...result.buffer], [0x41]);
    assert.equal(result.sauce?.comments, 1);
    assert.equal(result.sauce?.title, "A\0B");
});

test("stripSauce removes explicitly framed truncated legacy metadata", () => {
    const artwork = Buffer.from([
        0x41,
        0x1a,
        0x42,
    ]);
    const truncated = Buffer.from(
        "\x1aSAUCE00Legacy title                    ROY",
        "binary"
    );

    const result = stripSauce(Buffer.concat([artwork, truncated]));

    assert.deepEqual(
        [...result.buffer],
        [
            0x41,
            0x1a,
            0x42,
        ]
    );
    assert.equal(result.sauce, null);
});

test("SAUCE text fields remove null-before-space padding without deleting embedded nulls", () => {
    assert.equal(trimSauceTextField("Faith\0        "), "Faith");
    assert.equal(trimSauceTextField("A\0B        "), "A\0B");
});

test("source metadata comments sanitize controls and preserve SAUCE provenance", () => {
    const sauce = {
        version: "00",
        title: "Title\nSet-Content sentinel pwned",
        author: "Artist",
        group: "Group",
        date: "20260720",
        fileSize: 1,
        dataType: 1,
        fileType: 1,
        tInfo1: 80,
        tInfo2: 25,
        tInfo3: 0,
        tInfo4: 0,
        comments: 1,
        flags: 0,
        tInfoS: Buffer.from("IBM VGA\0", "ascii"),
        commentLines: ["Comment\r\nsecond line"],
    };

    const header = buildSourceMetadataHeader(
        "source.ans\nWrite-Error injected",
        "cp437",
        sauce,
        {
            url: "https://example.test/source.ans\nWrite-Error provenance",
            revision: "abc123",
            sha256: "b".repeat(64),
            license: "ISC",
            attribution: "Artist\r\nInjected line",
        }
    );

    assert.match(header, /# Converted from: source\.ans Write-Error injected/);
    assert.match(header, /# SAUCE Title: Title Set-Content sentinel pwned/);
    assert.match(header, /# SAUCE Dimensions: 80x25/);
    assert.match(header, /# SAUCE Font: IBM VGA/);
    assert.match(header, /# SAUCE Comments: Comment second line/);
    assert.match(
        header,
        /# Source URL: https:\/\/example\.test\/source\.ans Write-Error provenance/
    );
    assert.match(header, /# Source Attribution: Artist Injected line/);
    assert.equal(
        header.split("\n").some((line) => line === "Write-Error injected"),
        false
    );
});

test("source metadata comments omit incomplete or invalid SAUCE fields", () => {
    const sauce = {
        version: "00",
        title: "Arpegio",
        author: "Squarel00p",
        group: "b0ca junio",
        date: "\0".repeat(8),
        fileSize: 1,
        dataType: 0,
        fileType: 0,
        tInfo1: 0,
        tInfo2: 0,
        tInfo3: 0,
        tInfo4: 0,
        comments: 0,
        flags: 0,
        tInfoS: Buffer.from("empathy by skaboy\0", "ascii"),
        commentLines: [],
    };

    const incompleteHeader = buildSourceMetadataHeader(
        "SL-L00P.ANS",
        "cp437",
        sauce
    );
    assert.doesNotMatch(incompleteHeader, /# SAUCE Date:/);
    assert.doesNotMatch(incompleteHeader, /# SAUCE Dimensions:/);
    assert.match(incompleteHeader, /# SAUCE Font: empathy by skaboy/);

    for (const invalidDate of [
        "00000000",
        "20260229",
        "20261301",
        "20260700",
        "200201 2",
    ]) {
        assert.doesNotMatch(
            buildSourceMetadataHeader("invalid.ans", "cp437", {
                ...sauce,
                date: invalidDate,
            }),
            /# SAUCE Date:/
        );
    }

    assert.match(
        buildSourceMetadataHeader("leap-day.ans", "cp437", {
            ...sauce,
            date: "20240229",
        }),
        /# SAUCE Date: 20240229/
    );
});

test("converter and splitter provenance options validate and normalize metadata", () => {
    const sha256 = "ABCDEF0123456789".repeat(4);
    const { options } = parseArguments([
        "--source-url=https://example.test/art.ans?download=1",
        "--source-revision=release/2026.07",
        `--source-sha256=${sha256}`,
        "--source-license=LicenseRef-Public-Domain",
        "--source-attribution=Roy/SAC aka Carsten Cumbrowski",
        "--source-modification=Decoded from CP437 and flattened through terminal emulation.",
        "--",
        "art.ans",
    ]);

    assert.deepEqual(options.sourceProvenance, {
        url: "https://example.test/art.ans?download=1",
        revision: "release/2026.07",
        sha256: sha256.toLowerCase(),
        license: "LicenseRef-Public-Domain",
        attribution: "Roy/SAC aka Carsten Cumbrowski",
        modification:
            "Decoded from CP437 and flattened through terminal emulation.",
    });
    const splitOptions = parseSplitArguments([
        "--output-base=ROY-SAC-PC1",
        "--source-url=https://example.test/art.ans?download=1",
        "--source-revision=release/2026.07",
        `--source-sha256=${sha256}`,
        "--source-license=LicenseRef-Public-Domain",
        "--source-attribution=Roy/SAC aka Carsten Cumbrowski",
        "--source-modification=Decoded from CP437 and flattened through terminal emulation.",
        "--",
        "art.ans",
    ]).options;
    assert.deepEqual(splitOptions.sourceProvenance, options.sourceProvenance);
    assert.equal(splitOptions.outputBase, "roy-sac-pc1");
    assert.throws(
        () => parseArguments(["--source-url=file:///tmp/art.ans"]),
        /absolute HTTP or HTTPS URL/
    );
    assert.throws(
        () => parseArguments(["--source-revision=main\ninjected"]),
        /single printable line/
    );
    assert.throws(
        () => parseArguments(["--source-sha256=abc123"]),
        /exactly 64 hexadecimal characters/
    );
    assert.throws(
        () => parseSplitArguments(["--source-sha256=abc123"]),
        /exactly 64 hexadecimal characters/
    );
    assert.throws(
        () => parseSplitArguments(["--output-base=---"]),
        /at least one safe filename character/
    );
});

test("identical ANSI input and options produce byte-identical scripts", () => {
    const directory = createTemporaryDirectory();
    const inputPath = path.join(directory, "deterministic.ansi");
    const firstOutput = path.join(directory, "first.ps1");
    const secondOutput = path.join(directory, "second.ps1");
    const converter = path.join(
        __dirname,
        "../scripts/Convert-AnsiToColorScript.js"
    );
    fs.writeFileSync(inputPath, "\u001b[32mrepeatable\u001b[0m\r\n", "utf8");
    const commonArguments = [
        converter,
        "--encoding=utf8",
        "--source-url=https://example.test/deterministic.ansi",
        `--source-sha256=${"c".repeat(64)}`,
    ];

    for (const outputPath of [firstOutput, secondOutput]) {
        const conversion = spawnSync(
            process.execPath,
            [
                ...commonArguments,
                "--",
                inputPath,
                outputPath,
            ],
            { encoding: "utf8" }
        );
        assert.equal(
            conversion.status,
            0,
            conversion.error?.message || conversion.stderr || conversion.stdout
        );
    }

    assert.deepEqual(
        fs.readFileSync(firstOutput),
        fs.readFileSync(secondOutput)
    );
    assert.doesNotMatch(
        fs.readFileSync(firstOutput, "utf8"),
        /Conversion date:/
    );
});

test("SAUCE font names stop at the first null terminator without regex backtracking", () => {
    assert.equal(getSauceFontName(null), "");
    assert.equal(
        getSauceFontName({ tInfoS: Buffer.from("  IBM VGA  ", "ascii") }),
        "IBM VGA"
    );
    assert.equal(
        getSauceFontName({
            tInfoS: Buffer.from("IBM VGA\0ignored metadata", "ascii"),
        }),
        "IBM VGA"
    );
});

test("iCE background intensity survives cursor save and restore", () => {
    const source = "\u001b[5m\u001b7\u001b[0m\u001b8\u001b[41mX";
    const result = convertAnsiToPs1(source, {
        columns: 80,
        iceColors: true,
    });

    assert.deepEqual(result.lines, ["\u001b[101mX\u001b[0m"]);
});

test("DOS ANSI mode ignores modern bright-color aliases like the canonical archive renderer", () => {
    const source = "\u001b[31mA\u001b[95mB\u001b[41mC\u001b[104mD";
    const modern = convertAnsiToPs1(source, { columns: 80 });
    const dos = convertAnsiToPs1(source, { columns: 80, dosAnsi: true });

    assert.deepEqual(modern.terminal.rows.get(0).cells.get(1).attrs.fg, {
        mode: "bright",
        value: 5,
    });
    assert.deepEqual(modern.terminal.rows.get(0).cells.get(3).attrs.bg, {
        mode: "bright",
        value: 4,
    });
    assert.deepEqual(dos.terminal.rows.get(0).cells.get(1).attrs.fg, {
        mode: "basic",
        value: 1,
    });
    assert.deepEqual(dos.terminal.rows.get(0).cells.get(3).attrs.bg, {
        mode: "basic",
        value: 1,
    });
});

test("DOS ANSI mode treats bare LF as a new line like the canonical archive renderer", () => {
    const source = "\u001b[6C\u001b[31mA\n\u001b[4C\u001b[32mB";
    const modern = convertAnsiToPs1(source, { columns: 80 });
    const dos = convertAnsiToPs1(source, { columns: 80, dosAnsi: true });
    const dosCrLf = convertAnsiToPs1(source.replace("\n", "\r\n"), {
        columns: 80,
        dosAnsi: true,
    });

    assert.equal(modern.terminal.rows.get(1).cells.get(11).char, "B");
    assert.equal(dos.terminal.rows.get(1).cells.get(4).char, "B");
    assert.deepEqual(dos.lines, dosCrLf.lines);
});

test("DOS ANSI mode resolves a full-width row before CRLF like libansilove", () => {
    const fullWidthRow = "A".repeat(80);
    const source = `${fullWidthRow}\r\nB`;
    const modern = convertAnsiToPs1(source, { columns: 80 });
    const dos = convertAnsiToPs1(source, { columns: 80, dosAnsi: true });

    assert.deepEqual(modern.lines, [fullWidthRow, "B"]);
    assert.deepEqual(dos.lines, [fullWidthRow, "", "B"]);
});

test("DOS ANSI mode resolves a full-width row before bare LF", () => {
    const fullWidthRow = "A".repeat(80);
    const dos = convertAnsiToPs1(`${fullWidthRow}\nB`, {
        columns: 80,
        dosAnsi: true,
    });

    assert.deepEqual(dos.lines, [fullWidthRow, "", "B"]);
});

test("DOS ANSI mode ignores bare CR while modern mode returns to column zero", () => {
    const source = "ABC\rD";
    const modern = convertAnsiToPs1(source, { columns: 80 });
    const dos = convertAnsiToPs1(source, { columns: 80, dosAnsi: true });

    assert.deepEqual(modern.lines, ["DBC"]);
    assert.deepEqual(dos.lines, ["ABCD"]);
});

test("DOS ANSI TAB advances eight columns without painting gap cells", () => {
    const source = "\u001b[41mA\tB";
    const modern = convertAnsiToPs1(source, { columns: 80 });
    const dos = convertAnsiToPs1(source, { columns: 80, dosAnsi: true });

    assert.equal(modern.terminal.rows.get(0).cells.get(8).char, "B");
    assert.equal(dos.terminal.rows.get(0).cells.get(9).char, "B");
    for (let column = 1; column <= 8; column += 1) {
        assert.equal(dos.terminal.rows.get(0).cells.has(column), false);
    }
});

test("DOS ANSI mode resolves a full-width row before cursor control", () => {
    const fullWidthRow = "A".repeat(80);
    const source = `${fullWidthRow}\u001b[1AB`;
    const modern = convertAnsiToPs1(source, { columns: 80 });
    const dos = convertAnsiToPs1(source, { columns: 80, dosAnsi: true });

    assert.equal(modern.lines[0], `${"A".repeat(79)}B`);
    assert.equal(dos.lines[0], `B${"A".repeat(79)}`);
});

test("DOS ANSI cursor-forward preserves the right-margin wrap sentinel", () => {
    const fullWidthRow = "A".repeat(80);
    const dos = convertAnsiToPs1(`${fullWidthRow}\u001b[80CB`, {
        columns: 80,
        dosAnsi: true,
    });

    assert.deepEqual(dos.lines, [fullWidthRow, "", "B"]);
});

test("DOS ANSI absolute cursor positioning can target the wrap sentinel", () => {
    for (const flag of ["H", "f"]) {
        const dos = convertAnsiToPs1(`A\u001b[1;81${flag}B`, {
            columns: 80,
            dosAnsi: true,
        });

        assert.deepEqual(dos.lines, ["A", "B"]);
    }
});

test("all supported DOS code pages use archival ANSI semantics", () => {
    assert.equal(usesDosAnsiSemantics("cp437"), true);
    assert.equal(usesDosAnsiSemantics("CP850"), true);
    assert.equal(usesDosAnsiSemantics("cp860"), true);
    assert.equal(usesDosAnsiSemantics("utf8"), false);
    assert.equal(usesDosAnsiSemantics("UTF-8"), false);
});

test("converter CLI applies DOS wrapping to a non-CP437 code page", () => {
    const directory = createTemporaryDirectory();
    const inputPath = path.join(directory, "cp860.ans");
    fs.writeFileSync(inputPath, `${"A".repeat(80)}\r\nB`, "ascii");

    const result = spawnSync(
        process.execPath,
        [
            path.join(__dirname, "../scripts/Convert-AnsiToColorScript.js"),
            "--analyze-json",
            "--encoding=cp860",
            inputPath,
        ],
        { encoding: "utf8" }
    );

    assert.equal(result.status, 0, result.stderr || result.stdout);
    assert.equal(JSON.parse(result.stdout).height, 3);
});

test("terminal column slicing reconstructs active style without reflowing cells", () => {
    const result = convertAnsiToPs1(
        "\u001b[31mABCD\u001b[44mEFGH\r\n\u001b[0m12345678",
        { columns: 8 }
    );

    assert.deepEqual(result.terminal.buildLines({ start: 4, end: 7 }), [
        "\u001b[31;44mEFGH\u001b[0m",
        "5678",
    ]);
    assert.deepEqual(result.terminal.buildLines({ start: 0, end: 3 }), [
        "\u001b[31mABCD\u001b[0m",
        "1234",
    ]);
});

test("column ranges are one-based, ordered, bounded, and non-overlapping", () => {
    assert.deepEqual(parseColumnRanges("1-80, 81-160"), [
        { start: 0, end: 79 },
        { start: 80, end: 159 },
    ]);
    assert.throws(() => parseColumnRanges(""), /cannot be empty/);
    assert.throws(() => parseColumnRanges("80"), /Invalid column range/);
    assert.throws(() => parseColumnRanges("20-10"), /start no greater/);
    assert.throws(() => parseColumnRanges("1-80,80-120"), /must not overlap/);
    assert.throws(
        () => parseColumnRanges(`1-${MAX_TERMINAL_COLUMNS + 1}`),
        /must be within/
    );
});

test("balanced splitting uses the minimum part count without tiny tails", () => {
    assert.deepEqual(chooseBalancedBreaks(50), []);
    assert.deepEqual(chooseBalancedBreaks(56), [28]);
    assert.deepEqual(chooseBalancedBreaks(107), [36, 72]);
    assert.deepEqual(
        chooseBalancedBreaks(184),
        [
            46,
            92,
            138,
        ]
    );

    for (let totalLines = 1; totalLines <= 500; totalLines += 1) {
        const breakpoints = chooseBalancedBreaks(totalLines, 50);
        const endpoints = [
            0,
            ...breakpoints,
            totalLines,
        ];
        const lengths = endpoints
            .slice(1)
            .map((end, index) => end - endpoints[index]);
        assert.equal(lengths.length, Math.ceil(totalLines / 50));
        assert.equal(Math.max(...lengths) <= 50, true);
        assert.equal(Math.max(...lengths) - Math.min(...lengths) <= 1, true);
    }
});

test("balanced splitting prefers viable reviewed transitions deterministically", () => {
    const preferred = [
        50,
        100,
        135,
    ];
    assert.deepEqual(
        chooseBalancedBreaks(184, 50, preferred),
        [
            50,
            100,
            135,
        ]
    );
    assert.deepEqual(
        chooseBalancedBreaks(184, 50, [...preferred].reverse()),
        [
            50,
            100,
            135,
        ]
    );

    const breakpoints = chooseBalancedBreaks(
        107,
        50,
        [
            20,
            36,
            72,
            90,
        ]
    );
    assert.deepEqual(breakpoints, [36, 72]);
});

test("balanced splitting rejects invalid dimensions and transitions", () => {
    assert.throws(() => chooseBalancedBreaks(0), /positive safe-integer/);
    assert.throws(() => chooseBalancedBreaks(10, 0), /positive safe-integer/);
    assert.throws(
        () => chooseBalancedBreaks(10, 5, /** @type {number[]} */ (null)),
        /must be an array/
    );
    assert.throws(() => chooseBalancedBreaks(10, 5, [0]), /within the artwork/);
    assert.throws(
        () => chooseBalancedBreaks(10, 5, [10]),
        /within the artwork/
    );
    assert.throws(
        () => chooseBalancedBreaks(10, 5, [1.5]),
        /within the artwork/
    );
});

test("hostile cursor coordinates fail before terminal allocation", () => {
    for (const source of [
        "\u001b[1000000000;1000000000HX",
        "\u001b[1000000000CX",
        "\u001b[1000000000BX",
        "\u001b[10000LX",
    ]) {
        assert.throws(
            () => convertAnsiToPs1(source, { columns: 80 }),
            /exceeds the supported/
        );
    }
});

test("horizontal cursor movement is clamped to the terminal right margin", () => {
    const absolute = convertAnsiToPs1("\u001b[1;99HX", { columns: 4 });
    const relative = convertAnsiToPs1("A\u001b[99CX", { columns: 4 });

    assert.deepEqual(absolute.lines, ["   X"]);
    assert.deepEqual(relative.lines, ["A  X"]);
    assert.equal(absolute.terminal.maxCol, 3);
    assert.equal(relative.terminal.maxCol, 3);
});

test("insert-character operations clip cells at the terminal right margin", () => {
    const result = convertAnsiToPs1("ABCD\r\u001b[3G\u001b[2@X", {
        columns: 4,
    });

    assert.deepEqual(result.lines, ["ABX"]);
    assert.equal(result.terminal.maxCol, 3);
});

test("trailing cursor movement does not serialize phantom blank rows", () => {
    const trailingNewline = convertAnsiToPs1("A\r\n", { columns: 80 });
    const trailingCursorMove = convertAnsiToPs1("A\u001b[20B", {
        columns: 80,
    });
    const interiorBlank = convertAnsiToPs1("A\r\n\r\nB", { columns: 80 });
    const leadingBlank = convertAnsiToPs1("\u001b[3;1HB", { columns: 80 });

    assert.deepEqual(trailingNewline.lines, ["A"]);
    assert.deepEqual(trailingCursorMove.lines, ["A"]);
    assert.deepEqual(interiorBlank.lines, [
        "A",
        "",
        "B",
    ]);
    assert.deepEqual(leadingBlank.lines, [
        "",
        "",
        "B",
    ]);
});

test("declared minimum canvas height preserves trailing blank rows", () => {
    const result = convertAnsiToPs1("A\r\n", {
        columns: 80,
        minimumRows: 4,
    });

    assert.deepEqual(result.lines, [
        "A",
        "",
        "",
        "",
    ]);
    assert.equal(result.terminal.maxRow, 3);
});

test("conversion verifier detects terminal-cell color mutations", async () => {
    const { verifyAnsiConversion } = await conversionVerifier;
    const directory = createTemporaryDirectory();
    const sourcePath = path.join(directory, "fixture.ans");
    const scriptPath = path.join(directory, "fixture-part01.ps1");
    const source = "\u001b[31mAB\u001b[0m\r\n\u001b[44m  \u001b[0m";
    fs.writeFileSync(sourcePath, source, "binary");
    const converted = convertAnsiToPs1(source, {
        columns: 80,
        dosAnsi: true,
        stripSpaceBackground: false,
    });
    fs.writeFileSync(
        scriptPath,
        buildChunkPs1(
            {
                start: 0,
                end: converted.lines.length,
                lines: converted.lines,
            },
            {
                sourceName: "fixture.ans",
                sourceEncoding: "CP437",
                sourceColumns: "1-80",
            }
        )
    );

    const matching = verifyAnsiConversion({
        sourcePath,
        scriptPaths: [scriptPath],
        encoding: "cp437",
    });
    assert.equal(matching.matches, true);
    assert.equal(matching.coverage.complete, true);
    assert.deepEqual(matching.parts[0].mismatchedRows, []);

    const damaged = fs
        .readFileSync(scriptPath, "utf8")
        .replace("\u001b[44m", "\u001b[41m");
    fs.writeFileSync(scriptPath, damaged);
    const mismatching = verifyAnsiConversion({
        sourcePath,
        scriptPaths: [scriptPath],
        encoding: "cp437",
    });

    assert.equal(mismatching.matches, false);
    assert.equal(mismatching.parts[0].matches, false);
    assert.deepEqual(mismatching.parts[0].mismatchedRows, [2]);
});

test("conversion verifier arguments bound geometry and iCE overrides", async () => {
    const { parseArguments: parseVerificationArguments } =
        await conversionVerifier;
    const parsed = parseVerificationArguments([
        "--source=fixture.ice",
        "--prefix=fixture",
        "--columns=160",
        "--ice-colors",
        "--allow-partial",
    ]);

    assert.equal(parsed.columns, 160);
    assert.equal(parsed.iceColors, true);
    assert.equal(parsed.allowPartial, true);
    assert.throws(
        () =>
            parseVerificationArguments([
                "--source=fixture.ans",
                "--prefix=fixture",
                `--columns=${MAX_TERMINAL_COLUMNS + 1}`,
            ]),
        /--columns must be between/
    );
    assert.throws(
        () =>
            parseVerificationArguments([
                "--source=fixture.ans",
                "--prefix=fixture",
                "--script=fixture.ps1",
            ]),
        /either repeated --script options or --prefix/
    );
});

test("untrusted terminal dimensions are bounded", () => {
    assert.throws(
        () =>
            convertAnsiToPs1("X", {
                columns: MAX_TERMINAL_COLUMNS + 1,
            }),
        /Terminal columns must be between/
    );
    assert.throws(
        () =>
            convertAnsiToPs1("X", {
                minimumRows: MAX_TERMINAL_ROWS + 1,
            }),
        /Terminal minimum rows must be between/
    );
});

test("erase-display preserves cursor position and color state", () => {
    const result = convertAnsiToPs1("\u001b[31mABC\u001b[2JX", {
        columns: 80,
    });

    assert.deepEqual(result.lines, ["   \u001b[31mX\u001b[0m"]);
});

test("PabloDraw RGB extensions preserve foreground and background", () => {
    const result = convertAnsiToPs1(
        "\u001b[0;1;2;3tB\u001b[1;4;5;6tF\u001b[0mX",
        { columns: 80 }
    );

    assert.deepEqual(result.lines, [
        "\u001b[48;2;1;2;3mB\u001b[0;38;2;4;5;6;48;2;1;2;3mF\u001b[0mX",
    ]);
    assert.deepEqual(result.warnings, []);
});

test("malformed CSI t sequences remain explicit warnings", () => {
    const result = convertAnsiToPs1("\u001b[8;24;80tX", { columns: 80 });

    assert.deepEqual(result.lines, ["X"]);
    assert.equal(result.warnings.length, 1);
    assert.equal(result.warnings[0].flag, "t");
});

test("DEC autowrap and PabloDraw iCE modes honor private toggles", () => {
    const disabledAutowrap = convertAnsiToPs1("\u001b[?7lABC", {
        columns: 2,
    });
    assert.deepEqual(disabledAutowrap.lines, ["AC"]);
    const enabledAutowrap = convertAnsiToPs1("\u001b[?7hABC", {
        columns: 2,
    });
    assert.deepEqual(enabledAutowrap.lines, ["AB", "C"]);

    const ice = convertAnsiToPs1(
        "\u001b[?33h\u001b[5m\u001b[41mI\u001b[?33l\u001b[0mN",
        { columns: 80 }
    );
    assert.deepEqual(ice.lines, ["\u001b[101mI\u001b[0mN"]);
    assert.deepEqual(
        [
            ...disabledAutowrap.warnings,
            ...enabledAutowrap.warnings,
            ...ice.warnings,
        ],
        []
    );
});

test("ambiguous non-private mode commands remain warnings", () => {
    const result = convertAnsiToPs1("\u001b[7hX", { columns: 80 });
    assert.equal(result.warnings.length, 1);
    assert.equal(result.warnings[0].flag, "h");
});

test("erase-in-line paints an empty row using the current background", () => {
    const result = convertAnsiToPs1("\u001b[40m\u001b[K", { columns: 4 });

    assert.deepEqual(result.lines, ["\u001b[40m    \u001b[0m"]);
});

test("unsupported scroll commands warn instead of moving the cursor", () => {
    const result = convertAnsiToPs1("A\u001b[2SB\u001b[3TC", {
        columns: 80,
    });

    assert.deepEqual(result.lines, ["ABC"]);
    assert.deepEqual(
        result.warnings.map((warning) => warning.flag),
        ["S", "T"]
    );
});

test("analysis CLI reports cells written after cursor positioning", () => {
    const directory = createTemporaryDirectory();
    const inputPath = path.join(directory, "positioned.ans");
    fs.writeFileSync(inputPath, "\u001b[1;10HHELLO", "ascii");

    const result = spawnSync(
        process.execPath,
        [
            path.join(__dirname, "../scripts/Convert-AnsiToColorScript.js"),
            "--analyze-json",
            inputPath,
        ],
        { encoding: "utf8" }
    );

    assert.equal(result.status, 0, result.stderr || result.stdout);
    assert.deepEqual(JSON.parse(result.stdout), {
        width: 14,
        height: 1,
        warnings: [],
    });
});

test("stripSauce removes repeated metadata-adjacent DOS EOF markers", () => {
    const content = Buffer.from([
        0x41,
        0x1a,
        0x42,
        0x1a,
        0x1a,
    ]);
    const sauce = Buffer.alloc(128);
    sauce.write("SAUCE00", 0, "ascii");
    sauce.writeUInt32LE(3, 90);

    const result = stripSauce(Buffer.concat([content, sauce]));

    assert.deepEqual(
        [...result.buffer],
        [
            0x41,
            0x1a,
            0x42,
        ]
    );
    assert.ok(result.sauce);
});

test("stripSauce removes newline-separated metadata-adjacent DOS EOF markers", () => {
    const content = Buffer.from("ART\r\n\r\n\x1a\r\n\x1a", "binary");
    const sauce = Buffer.alloc(128);
    sauce.write("SAUCE00", 0, "ascii");
    sauce.writeUInt32LE(7, 90);

    const result = stripSauce(Buffer.concat([content, sauce]));

    assert.equal(result.buffer.toString("binary"), "ART\r\n\r\n");
    assert.ok(result.sauce);
});

test("stripSauce preserves artwork rows before newline-separated COMNT EOF markers", () => {
    const content = Buffer.from("ART\r\n\x1a\r\n\x1a", "binary");
    const comments = Buffer.alloc(69);
    comments.write("COMNT", 0, "ascii");
    comments.write("reviewed", 5, "ascii");
    const sauce = Buffer.alloc(128);
    sauce.write("SAUCE00", 0, "ascii");
    sauce.writeUInt32LE(content.length, 90);
    sauce.writeUInt8(1, 104);

    const result = stripSauce(Buffer.concat([content, comments, sauce]));

    assert.equal(result.buffer.toString("binary"), "ART\r\n");
    assert.deepEqual(result.sauce?.commentLines, ["reviewed"]);
});

test("stripSauce removes newline-separated EOF markers before truncated SAUCE metadata", () => {
    const result = stripSauce(
        Buffer.from("ART\r\n\x1a\r\n\x1aSAUCE00broken", "binary")
    );

    assert.equal(result.buffer.toString("binary"), "ART\r\n");
    assert.equal(result.sauce, null);
});

test("stripSauce removes standalone trailing DOS EOF markers", () => {
    const result = stripSauce(
        Buffer.from([
            0x41,
            0x1a,
            0x42,
            0x1a,
            0x1a,
        ])
    );

    assert.deepEqual(
        [...result.buffer],
        [
            0x41,
            0x1a,
            0x42,
        ]
    );
    assert.equal(result.sauce, null);
});

test("stripSauce removes a DOS EOF marker followed only by newlines", () => {
    const result = stripSauce(
        Buffer.from("ART\r\n\r\n\x1a\r\n", "binary")
    );

    assert.equal(result.buffer.toString("binary"), "ART\r\n\r\n");
    assert.equal(result.sauce, null);
});

test("readAnsiFile stops DOS artwork at the first EOF marker", () => {
    const directory = createTemporaryDirectory();
    const inputPath = path.join(directory, "eof.ans");
    fs.writeFileSync(
        inputPath,
        Buffer.from("VISIBLE\x1a\r\nHIDDEN\x1a", "binary")
    );

    assert.equal(readAnsiFile(inputPath, "cp437").content, "VISIBLE");
    assert.equal(
        readAnsiFile(inputPath, "utf8").content,
        "VISIBLE\x1a\r\nHIDDEN"
    );
    assert.equal(
        truncateDosAnsiAtEof(Buffer.from("VISIBLE\x1aHIDDEN", "binary")).toString(
            "binary"
        ),
        "VISIBLE"
    );
});

test("splitter CLI can convert ANSI input in dry-run mode", () => {
    const directory = createTemporaryDirectory();
    const inputPath = path.join(directory, "input.ans");
    fs.writeFileSync(inputPath, "hello", "ascii");

    const result = spawnSync(
        process.execPath,
        [
            path.join(__dirname, "../scripts/Split-AnsiFile.js"),
            "--dry-run",
            "--input=ansi",
            inputPath,
        ],
        { encoding: "utf8" }
    );

    assert.equal(result.status, 0, result.stderr || result.stdout);
    assert.match(result.stdout, /Dry run complete; no files written\./);
});

test("splitter emits deterministic cell-aware panel and part files", () => {
    const directory = createTemporaryDirectory();
    const inputPath = path.join(directory, "panels.ans");
    fs.writeFileSync(
        inputPath,
        "\u001b[31mABCD\u001b[44mEFGH\r\n\u001b[0m12345678",
        "utf8"
    );

    const result = spawnSync(
        process.execPath,
        [
            path.join(__dirname, "../scripts/Split-AnsiFile.js"),
            "--input=ansi",
            "--encoding=utf8",
            "--columns=8",
            "--column-ranges=1-4,5-8",
            "--breaks=1",
            `--output-dir=${directory}`,
            "--output-base=logical-panels",
            inputPath,
        ],
        { encoding: "utf8" }
    );

    assert.equal(result.status, 0, result.stderr || result.stdout);
    const expectedFiles = [
        "logical-panels-panel01-part01.ps1",
        "logical-panels-panel01-part02.ps1",
        "logical-panels-panel02-part01.ps1",
        "logical-panels-panel02-part02.ps1",
    ];
    assert.deepEqual(
        fs
            .readdirSync(directory)
            .filter((name) => name.endsWith(".ps1"))
            .sort(),
        expectedFiles
    );

    const firstRightPanel = fs.readFileSync(
        path.join(directory, "logical-panels-panel02-part01.ps1"),
        "utf8"
    );
    assert.match(firstRightPanel, /# Lines: 1-1/);
    assert.match(firstRightPanel, /# Columns: 5-8/);
    assert.match(firstRightPanel, /\u001b\[31;44mEFGH\u001b\[0m/u);
    assert.ok(
        extractLinesFromPs1(path.join(directory, expectedFiles[3])).includes(
            "5678\u001b[0m"
        )
    );
});

test("ANSI split output preserves the selected source encoding", () => {
    const directory = createTemporaryDirectory();
    const cp437Path = path.join(directory, "cp437.ans");
    const utf8Path = path.join(directory, "utf8.ans");

    writeChunkAnsi(cp437Path, { start: 0, end: 1, lines: ["café ░"] }, "cp437");
    writeChunkAnsi(utf8Path, { start: 0, end: 1, lines: ["snow 雪"] }, "utf8");

    assert.equal(readAnsiFile(cp437Path, "cp437").content, "café ░\u001b[0m");
    assert.equal(readAnsiFile(utf8Path, "utf8").content, "snow 雪\u001b[0m");
});

test("SAUCE IBM font names resolve only registered DOS code-page suffixes", () => {
    assert.deepEqual(resolveSauceEncoding("IBM VGA 860"), {
        encoding: "cp860",
        label: "CP860",
        supported: true,
        explicit: true,
        codePage: "860",
    });
    assert.deepEqual(resolveSauceEncoding("IBM VGA25G"), {
        encoding: "cp437",
        label: "CP437",
        supported: true,
        explicit: false,
        codePage: "437",
    });
    assert.equal(resolveSauceEncoding("IBM VGA 872").supported, false);
    assert.equal(resolveSauceEncoding("IBM VGA MAZ").supported, false);
    assert.equal(resolveSauceEncoding("garbage-font-860").label, "CP437");
    assert.equal(resolveSauceEncoding("IBM VGA 1251").label, "CP437");
});

test("DOS decoding honors non-CP437 glyphs without leaking graphic controls", () => {
    const bytes = Buffer.from([
        0x86,
        0x0f,
        0x91,
    ]);
    assert.notEqual(decodeDosAnsi(bytes, "cp860"), decodeCp437Ansi(bytes));
    assert.equal(decodeDosAnsi(Buffer.from([0x0f]), "cp860"), "☼");
});

test("converter and splitter reject unknown options and unsafe overwrites", () => {
    assert.deepEqual(
        require("../scripts/Convert-AnsiToColorScript.js").parseArguments([
            "--",
            "--utf8",
        ]).positional,
        ["--utf8"]
    );
    assert.deepEqual(
        require("../scripts/Split-AnsiFile.js").parseArguments(["--", "--utf8"])
            .positional,
        ["--utf8"]
    );
    assert.throws(
        () =>
            require("../scripts/Convert-AnsiToColorScript.js").parseArguments([
                "--typo",
            ]),
        /Unknown option/
    );
    assert.throws(
        () =>
            require("../scripts/Split-AnsiFile.js").parseArguments(["--typo"]),
        /Unknown option/
    );

    const directory = createTemporaryDirectory();
    const inputPath = path.join(directory, "collision.ans");
    const outputPath = path.join(directory, "collision.ps1");
    fs.writeFileSync(inputPath, "art", "ascii");
    fs.writeFileSync(outputPath, "existing", "utf8");
    const result = spawnSync(
        process.execPath,
        [
            path.join(__dirname, "../scripts/Convert-AnsiToColorScript.js"),
            inputPath,
            outputPath,
        ],
        { encoding: "utf8" }
    );
    assert.notEqual(result.status, 0);
    assert.equal(fs.readFileSync(outputPath, "utf8"), "existing");
});

test("ANSI input size is checked before reading the file", () => {
    const directory = createTemporaryDirectory();
    const inputPath = path.join(directory, "oversized.ans");
    const descriptor = fs.openSync(inputPath, "w");
    try {
        fs.ftruncateSync(descriptor, 32 * 1024 * 1024 + 1);
    } finally {
        fs.closeSync(descriptor);
    }

    assert.throws(() => readAnsiFile(inputPath), /byte safety limit/);
});
