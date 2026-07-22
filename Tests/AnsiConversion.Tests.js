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
    getSauceFontName,
    MAX_TERMINAL_COLUMNS,
    parseArguments,
    readAnsiFile,
    stripSauce,
    trimSauceTextField,
    writePowerShellFile,
} = require("../scripts/Convert-AnsiToColorScript.js");
const {
    extractLinesFromPs1,
    parseArguments: parseSplitArguments,
    writeChunkPs1,
    writeChunkAnsi,
} = require("../scripts/Split-AnsiFile.js");

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
            assert.equal(stdout, `${payload}\n`)
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
            assert.equal(stdout, "snow: 雪\n")
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
            modification: "Converted to a safe PowerShell literal and split by rendered rows.",
        },
    };

    writeChunkPs1(
        scriptPath,
        { start: 0, end: lines.length, lines },
        baseInfo
    );
    writeChunkPs1(
        repeatedScriptPath,
        { start: 0, end: lines.length, lines },
        baseInfo
    );

    assert.deepEqual(extractLinesFromPs1(scriptPath), [...lines, "\u001b[0m"]);
    const outputs = runPowerShell(scriptPath);
    outputs.forEach((stdout) =>
        assert.equal(stdout, `${lines.join("\n")}\n\u001b[0m\n`)
    );
    assert.deepEqual(
        fs.readFileSync(scriptPath),
        fs.readFileSync(repeatedScriptPath)
    );
    const generatedSource = fs.readFileSync(scriptPath, "utf8");
    assert.match(generatedSource, /# Source URL: https:\/\/example\.test\/art\.ans/);
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
        modification: "Decoded from CP437 and flattened through terminal emulation.",
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

test("hostile cursor coordinates fail before terminal allocation", () => {
    for (const source of [
        "\u001b[1000000000;1000000000HX",
        "\u001b[1000000000CX",
        "\u001b[1000000000BX",
        "\u001b[10000@X",
        "\u001b[10000LX",
    ]) {
        assert.throws(
            () => convertAnsiToPs1(source, { columns: 80 }),
            /exceeds the supported/
        );
    }
});

test("untrusted terminal dimensions are bounded", () => {
    assert.throws(
        () =>
            convertAnsiToPs1("X", {
                columns: MAX_TERMINAL_COLUMNS + 1,
            }),
        /Terminal columns must be between/
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

test("stripSauce removes only the metadata-adjacent DOS EOF marker", () => {
    const content = Buffer.from([
        0x41,
        0x1a,
        0x42,
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

test("ANSI split output preserves the selected source encoding", () => {
    const directory = createTemporaryDirectory();
    const cp437Path = path.join(directory, "cp437.ans");
    const utf8Path = path.join(directory, "utf8.ans");

    writeChunkAnsi(cp437Path, { start: 0, end: 1, lines: ["café ░"] }, "cp437");
    writeChunkAnsi(utf8Path, { start: 0, end: 1, lines: ["snow 雪"] }, "utf8");

    assert.equal(readAnsiFile(cp437Path, "cp437").content, "café ░\n\u001b[0m");
    assert.equal(readAnsiFile(utf8Path, "utf8").content, "snow 雪\n\u001b[0m");
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
