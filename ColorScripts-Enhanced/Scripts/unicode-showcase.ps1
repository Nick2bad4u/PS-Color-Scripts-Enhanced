# Unicode Showcase - Beautiful display of various Unicode glyphs and symbols
# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27

function Color($r, $g, $b, $text) {
    "$esc[38;2;$r;$g;${b}m$text$esc[0m"
}

Write-Host ""
Write-Host (Color 100 200 255 "  ╔═══════════════════════════════════════════════════════════════╗")
Write-Host (Color 100 200 255 "  ║") + (Color 255 255 150 "          UNICODE GLYPH SHOWCASE - Terminal Art Symbols") + (Color 100 200 255 "        ║")
Write-Host (Color 100 200 255 "  ╚═══════════════════════════════════════════════════════════════╝")
Write-Host ""

# Box Drawing
Write-Host (Color 150 150 255 "  Box Drawing:")
Write-Host "    ┌─┬─┐  ╔═╦═╗  ╒═╤═╕  ╓─╥─╖  ▗▄▄▖  ▛▀▀▜"
Write-Host "    │ │ │  ║ ║ ║  │ │ │  ║ ║ ║  ▐▌▐▌  ▌  ▐"
Write-Host "    ├─┼─┤  ╠═╬═╣  ╞═╪═╡  ╟─╫─╢  ▐▌▐▌  ▙▄▄▟"
Write-Host "    │ │ │  ║ ║ ║  │ │ │  ║ ║ ║  ▝▀▀▘  ▌  ▐"
Write-Host "    └─┴─┘  ╚═╩═╝  ╘═╧═╛  ╙─╨─╜         ▀▀▀▘"
Write-Host ""

# Geometric Shapes
Write-Host (Color 255 150 150 "  Geometric Shapes:")
Write-Host "    ● ◉ ○ ◌ ◍ ◎ ◐ ◑ ◒ ◓ ◔ ◕ ◖ ◗ ◘ ◙ ◚ ◛ ◜ ◝ ◞ ◟"
Write-Host "    ■ □ ▢ ▣ ▤ ▥ ▦ ▧ ▨ ▩ ▪ ▫ ▬ ▭ ▮ ▯ ▰ ▱ ◆ ◇ ◈"
Write-Host "    ▲ △ ▴ ▵ ▶ ▷ ▸ ▹ ► ▻ ▼ ▽ ▾ ▿ ◀ ◁ ◂ ◃ ◄ ◅"
Write-Host ""

# Arrows
Write-Host (Color 150 255 150 "  Arrows & Directions:")
Write-Host "    ← ↑ → ↓ ↔ ↕ ↖ ↗ ↘ ↙ ↚ ↛ ↜ ↝ ↞ ↟ ↠ ↡ ↢ ↣"
Write-Host "    ⇐ ⇑ ⇒ ⇓ ⇔ ⇕ ⇖ ⇗ ⇘ ⇙ ⇚ ⇛ ⇜ ⇝ ⇞ ⇟ ⇠ ⇡ ⇢ ⇣"
Write-Host "    ➔ ➘ ➙ ➚ ➛ ➜ ➝ ➞ ➟ ➠ ➡ ➢ ➣ ➤ ➥ ➦ ➧ ➨ ➩ ➪"
Write-Host ""

# Stars & Symbols
Write-Host (Color 255 255 100 "  Stars & Celestial:")
Write-Host "    ★ ☆ ✦ ✧ ✨ ✩ ✪ ✫ ✬ ✭ ✮ ✯ ✰ ✱ ✲ ✳ ✴ ✵ ✶ ✷ ✸ ✹"
Write-Host "    ❋ ❊ ❉ ❈ ❇ ❆ ❅ ❄ ❃ ❂ ❁ ❀ ✿ ✾ ✽ ✼ ✻ ✺ ✹ ✸"
Write-Host ""

# Musical
Write-Host (Color 200 150 255 "  Musical Notes:")
Write-Host "    ♩ ♪ ♫ ♬ ♭ ♮ ♯ 𝄞 𝄢 𝄫 𝄪 𝅗𝅥 𝅘𝅥 𝅘𝅥𝅮 𝅘𝅥𝅯 𝅘𝅥𝅰 𝅘𝅥𝅱 𝅘𝅥𝅲"
Write-Host ""

# Technical & Math
Write-Host (Color 100 255 200 "  Math & Technical:")
Write-Host "    ± × ÷ ≠ ≈ ≡ ∞ ∫ ∂ √ ∛ ∜ ≤ ≥ ∈ ∉ ∋ ∩ ∪ ⊂ ⊃"
Write-Host "    α β γ δ ε ζ η θ λ μ π ρ σ τ φ χ ψ ω Σ Δ Ω"
Write-Host ""

# Playing Cards & Games
Write-Host (Color 255 100 100 "  Cards & Games:")
Write-Host "    ♠ ♣ ♥ ♦ ♤ ♧ ♡ ♢ 🂡 🂢 🂣 🂤 🂥 🂦 🂧 🂨 🂩 🂪 🂫"
Write-Host "    ☰ ☱ ☲ ☳ ☴ ☵ ☶ ☷ ⚀ ⚁ ⚂ ⚃ ⚄ ⚅"
Write-Host ""

# Braille Patterns
Write-Host (Color 200 200 200 "  Braille Patterns (Sample):")
Write-Host "    ⠀⠁⠂⠃⠄⠅⠆⠇⠈⠉⠊⠋⠌⠍⠎⠏⠐⠑⠒⠓⠔⠕⠖⠗⠘⠙⠚⠛⠜⠝⠞⠟⠠⠡⠢⠣⠤⠥⠦⠧⠨⠩⠪⠫⠬⠭⠮⠯"
Write-Host "    ⡀⡁⡂⡃⡄⡅⡆⡇⡈⡉⡊⡋⡌⡍⡎⡏⡐⡑⡒⡓⡔⡕⡖⡗⡘⡙⡚⡛⡜⡝⡞⡟⡠⡡⡢⡣⡤⡥⡦⡧⡨⡩⡪⡫⡬⡭⡮⡯"
Write-Host ""
