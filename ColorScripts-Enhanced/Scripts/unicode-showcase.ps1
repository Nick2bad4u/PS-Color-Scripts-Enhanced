# Unicode Showcase - Beautiful display of various Unicode glyphs and symbols

$esc = [char]27

function Color {
    param(
        [int]$r,
        [int]$g,
        [int]$b,
        [string]$text
    )
    "$esc[38;2;$r;$g;${b}m$text$esc[0m"
}

Write-Host -Object ""
Write-Host -Object (Color -r 100 -g 200 -b 255 -text "  ╔═══════════════════════════════════════════════════════════════╗")
Write-Host -Object ((Color -r 100 -g 200 -b 255 -text "  ║") + (Color -r 255 -g 255 -b 150 -text "          UNICODE GLYPH SHOWCASE - Terminal Art Symbols") + (Color -r 100 -g 200 -b 255 -text "        ║"))
Write-Host -Object (Color -r 100 -g 200 -b 255 -text "  ╚═══════════════════════════════════════════════════════════════╝")
Write-Host -Object ""

# Box Drawing
Write-Host -Object (Color -r 150 -g 150 -b 255 -text "  Box Drawing:")
Write-Host -Object "    ┌─┬─┐  ╔═╦═╗  ╒═╤═╕  ╓─╥─╖  ▗▄▄▖  ▛▀▀▜"
Write-Host -Object "    │ │ │  ║ ║ ║  │ │ │  ║ ║ ║  ▐▌▐▌  ▌  ▐"
Write-Host -Object "    ├─┼─┤  ╠═╬═╣  ╞═╪═╡  ╟─╫─╢  ▐▌▐▌  ▙▄▄▟"
Write-Host -Object "    │ │ │  ║ ║ ║  │ │ │  ║ ║ ║  ▝▀▀▘  ▌  ▐"
Write-Host -Object "    └─┴─┘  ╚═╩═╝  ╘═╧═╛  ╙─╨─╜        ▀▀▀▀"
Write-Host -Object ""

# Geometric Shapes
Write-Host -Object (Color -r 255 -g 150 -b 150 -text "  Geometric Shapes:")
Write-Host -Object "    ● ◉ ○ ◌ ◍ ◎ ◐ ◑ ◒ ◓ ◔ ◕ ◖ ◗ ◘ ◙ ◚ ◛ ◜ ◝ ◞ ◟"
Write-Host -Object "    ■ □ ▢ ▣ ▤ ▥ ▦ ▧ ▨ ▩ ▪ ▫ ▬ ▭ ▮ ▯ ▰ ▱ ◆ ◇ ◈"
Write-Host -Object "    ▲ △ ▴ ▵ ▶ ▷ ▸ ▹ ► ▻ ▼ ▽ ▾ ▿ ◀ ◁ ◂ ◃ ◄ ◅"
Write-Host -Object ""

# Arrows
Write-Host -Object (Color -r 150 -g 255 -b 150 -text "  Arrows & Directions:")
Write-Host -Object "    ← ↑ → ↓ ↔ ↕ ↖ ↗ ↘ ↙ ↚ ↛ ↜ ↝ ↞ ↟ ↠ ↡ ↢ ↣"
Write-Host -Object "    ⇐ ⇑ ⇒ ⇓ ⇔ ⇕ ⇖ ⇗ ⇘ ⇙ ⇚ ⇛ ⇜ ⇝ ⇞ ⇟ ⇠ ⇡ ⇢ ⇣"
Write-Host -Object "    ➔ ➘ ➙ ➚ ➛ ➜ ➝ ➞ ➟ ➠ ➡ ➢ ➣ ➤ ➥ ➦ ➧ ➨ ➩ ➪"
Write-Host -Object ""

# Stars & Symbols
Write-Host -Object (Color -r 255 -g 255 -b 100 -text "  Stars & Celestial:")
Write-Host -Object "    ★ ☆ ✦ ✧ ✨ ✩ ✪ ✫ ✬ ✭ ✮ ✯ ✰ ✱ ✲ ✳ ✴ ✵ ✶ ✷ ✸ ✹"
Write-Host -Object "    ❋ ❊ ❉ ❈ ❇ ❆ ❅ ❄ ❃ ❂ ❁ ❀ ✿ ✾ ✽ ✼ ✻ ✺ ✹ ✸"
Write-Host -Object ""

# Musical
Write-Host -Object (Color -r 200 -g 150 -b 255 -text "  Musical Notes:")
Write-Host -Object "    ♩ ♪ ♫ ♬ ♭ ♮ ♯ 𝄞 𝄢 𝄫 𝄪 𝅗𝅥 𝅘𝅥 𝅘𝅥𝅮 𝅘𝅥𝅯 𝅘𝅥𝅰 𝅘𝅥𝅱 𝅘𝅥𝅲"
Write-Host -Object ""

# Technical & Math
Write-Host -Object (Color -r 100 -g 255 -b 200 -text "  Math & Technical:")
Write-Host -Object "    ± × ÷ ≠ ≈ ≡ ∞ ∫ ∂ √ ∛ ∜ ≤ ≥ ∈ ∉ ∋ ∩ ∪ ⊂ ⊃"
Write-Host -Object "    α β γ δ ε ζ η θ λ μ π ρ σ τ φ χ ψ ω Σ Δ Ω"
Write-Host -Object ""

# Playing Cards & Games
Write-Host -Object (Color -r 255 -g 100 -b 100 -text "  Cards & Games:")
Write-Host -Object "    ♠ ♣ ♥ ♦ ♤ ♧ ♡ ♢ 🂡 🂢 🂣 🂤 🂥 🂦 🂧 🂨 🂩 🂪 🂫"
Write-Host -Object "    ☰ ☱ ☲ ☳ ☴ ☵ ☶ ☷ ⚀ ⚁ ⚂ ⚃ ⚄ ⚅"
Write-Host -Object ""

# Braille Patterns
Write-Host -Object (Color -r 200 -g 200 -b 200 -text "  Braille Patterns (Sample):")
Write-Host -Object "    ⠀⠁⠂⠃⠄⠅⠆⠇⠈⠉⠊⠋⠌⠍⠎⠏⠐⠑⠒⠓⠔⠕⠖⠗⠘⠙⠚⠛⠜⠝⠞⠟⠠⠡⠢⠣⠤⠥⠦⠧⠨⠩⠪⠫⠬⠭⠮⠯"
Write-Host -Object "    ⡀⡁⡂⡃⡄⡅⡆⡇⡈⡉⡊⡋⡌⡍⡎⡏⡐⡑⡒⡓⡔⡕⡖⡗⡘⡙⡚⡛⡜⡝⡞⡟⡠⡡⡢⡣⡤⡥⡦⡧⡨⡩⡪⡫⡬⡭⡮⡯"
Write-Host -Object ""
