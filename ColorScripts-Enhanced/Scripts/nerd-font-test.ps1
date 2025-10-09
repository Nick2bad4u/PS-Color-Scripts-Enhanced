# Nerd Font Test - Showcases popular Nerd Font glyphs and icons
# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27

function Color($r, $g, $b, $text) {
    "$esc[38;2;$r;$g;${b}m$text$esc[0m"
}

Write-Host ""
Write-Host (Color 100 200 255 "  ╔═══════════════════════════════════════════════════════════════╗")
Write-Host (Color 100 200 255 "  ║") + (" " * 19) + (Color 255 200 100 "NERD FONT GLYPH SHOWCASE") + (" " * 8) + (Color 100 200 255 "║")
Write-Host (Color 100 200 255 "  ╚═══════════════════════════════════════════════════════════════╝")
Write-Host ""

# Installation Note
Write-Host (Color 200 200 200 "  Note: These glyphs require a Nerd Font to display correctly.")
Write-Host (Color 200 200 200 "        Download from: https://www.nerdfonts.com/")
Write-Host ""


# Programming Languages & Frameworks
Write-Host (Color 255 150 100 "   Programming Languages & Frameworks:")
Write-Host "    $(Color 229 77 66 '') JavaScript    $(Color 55 119 190 '') TypeScript    $(Color 88 166 255 '') React"
Write-Host "    $(Color 51 153 51 '') Node.js       $(Color 97 218 251 '') Vue.js        $(Color 221 44 41 '') Angular"
Write-Host "    $(Color 53 114 165 '') Python        $(Color 204 52 45 '') Ruby          $(Color 239 111 60 '') Rust"
Write-Host "    $(Color 0 125 156 '') Go/Golang     $(Color 244 68 62 '') Java          $(Color 149 117 205 '') C#"
Write-Host "    $(Color 88 166 255 '') C/C++         $(Color 111 66 193 '') PHP           $(Color 178 98 44 '') Swift"
Write-Host "    $(Color 74 103 133 '') Lua           $(Color 241 90 34 '') HTML5         $(Color 37 155 219 '') CSS3"
Write-Host "    $(Color 138 173 244 '') Kotlin        $(Color 220 118 51 '') Scala         $(Color 100 200 255 '') Dart"
Write-Host ""

# File Types
Write-Host (Color 150 200 255 "   File Types & Icons:")
Write-Host "    $(Color 100 180 255 '') Folder        $(Color 255 200 100 '') JSON          $(Color 90 180 90 '') Markdown"
Write-Host "    $(Color 255 150 100 '') Archive       $(Color 150 200 255 '') Config        $(Color 200 100 255 '') Image"
Write-Host "    $(Color 200 150 100 '') PDF           $(Color 100 255 150 '') Document      $(Color 255 100 200 '') Video"
Write-Host "    $(Color 100 200 255 '') Audio         $(Color 255 200 150 '') Database      $(Color 200 200 100 '') Lock"
Write-Host "    $(Color 150 255 100 '') Binary        $(Color 255 150 200 '') XML           $(Color 100 150 255 '') YAML"
Write-Host ""

# Version Control
Write-Host (Color 240 120 80 "   Version Control & DevOps:")
Write-Host "    $(Color 240 88 53 '') Git           $(Color 33 136 255 '') GitHub        $(Color 252 109 38 '') GitLab"
Write-Host "    $(Color 33 136 255 '') Docker        $(Color 51 103 214 '') Kubernetes    $(Color 100 255 100 '') CI/CD Pipeline"
Write-Host "    $(Color 100 200 255 '') Branch        $(Color 255 150 100 '') Merge         $(Color 150 255 150 '') Pull Request"
Write-Host ""

# Development Tools
Write-Host (Color 100 255 200 "   Development Tools & Editors:")
Write-Host "    $(Color 0 122 204 '') VS Code       $(Color 0 150 0 '') Vim           $(Color 100 200 100 '') Neovim"
Write-Host "    $(Color 200 150 255 '') Terminal     $(Color 255 200 100 '') Package       $(Color 204 52 45 '') NPM"
Write-Host "    $(Color 44 142 187 '') Yarn          $(Color 142 214 251 '') Webpack       $(Color 189 147 249 '') Vite"
Write-Host ""

# OS & Environment
Write-Host (Color 200 200 255 "   Operating Systems:")
Write-Host "    $(Color 100 200 255 '') Linux         $(Color 0 162 232 '') Windows       $(Color 220 220 220 '') Apple/macOS"
Write-Host "    $(Color 142 192 124 '') Android       $(Color 215 10 83 '') Debian        $(Color 230 130 40 '') Ubuntu"
Write-Host "    $(Color 51 105 173 '') Fedora        $(Color 23 147 209 '') Arch Linux    $(Color 201 42 76 '') Raspberry Pi"
Write-Host ""

# Status & Indicators
Write-Host (Color 255 255 100 "   Status Icons & Symbols:")
Write-Host "    $(Color 100 255 100 '') Success       $(Color 255 200 50 '') Warning        $(Color 255 100 100 '') Error"
Write-Host "    $(Color 100 200 255 '') Info          $(Color 200 50 50 '') Bug           $(Color 255 150 50 '') Fire"
Write-Host "    $(Color 255 215 0 '') Star          $(Color 255 100 150 '') Heart         $(Color 255 200 100 '') Lightning"
Write-Host "    $(Color 150 200 255 '') Bookmark      $(Color 100 255 200 '') Tag           $(Color 150 200 255 '') Search"
Write-Host ""

# UI Elements
Write-Host (Color 255 200 150 "   UI & Navigation:")
Write-Host "    $(Color 255 150 100 '') Home          $(Color 180 180 180 '') Settings      $(Color 100 150 255 '') Dashboard"
Write-Host "    $(Color 100 200 255 '') Folder Open   $(Color 255 100 150 '') Download      $(Color 150 255 100 '') Upload"
Write-Host "    $(Color 200 150 255 '') Calendar      $(Color 100 255 150 '') Clock         $(Color 255 200 100 '') Bell"
Write-Host "    $(Color 255 150 200 '') User          $(Color 150 255 150 '') Team          $(Color 100 200 255 '') Globe"
Write-Host ""

# Arrows & Separators
Write-Host (Color 150 255 255 "   Powerline & Separators:")
Write-Host "                   "
Write-Host "                   "
Write-Host "                   "
Write-Host ""

# Weather & Miscellaneous
Write-Host (Color 255 255 150 "   Weather & Miscellaneous:")
Write-Host "    $(Color 255 200 50 '') Sun           $(Color 200 200 200 '') Cloud         $(Color 100 150 255 '') Rain"
Write-Host "    $(Color 200 200 255 '') Moon          $(Color 150 200 255 '') Snowflake     $(Color 255 215 0 '') Lightning"
Write-Host "    $(Color 100 200 255 '') WiFi          $(Color 100 255 100 '') Battery       $(Color 255 100 100 '') Power"
Write-Host "    $(Color 200 100 100 '') CPU           $(Color 100 200 255 '') Memory        $(Color 100 255 200 '') Network"
Write-Host ""

# Special Characters
Write-Host (Color 200 150 255 "   Special Symbols:")
Write-Host "    $(Color 100 255 100 '') Checkmark     $(Color 255 100 100 '') Cross         $(Color 150 200 255 '') Plus"
Write-Host "    $(Color 255 200 150 '') Circle        $(Color 150 255 100 '') Square        $(Color 100 150 255 '') Diamond"
Write-Host "    $(Color 255 150 100 '') Arrow Right   $(Color 150 255 200 '') Arrow Left    $(Color 200 150 100 '') Arrow Up"
Write-Host "    $(Color 100 255 150 '') Dot           $(Color 255 100 200 '') Line          $(Color 150 200 255 '') Ellipsis"
Write-Host ""

# Cool Demo
Write-Host (Color 255 255 100 "   Cool Gradient Demo:")
Write-Host "    $(Color 255 0 0 '') $(Color 255 50 0 '') $(Color 255 100 0 '') $(Color 255 150 0 '') $(Color 255 200 0 '') $(Color 255 255 0 '') $(Color 200 255 0 '') $(Color 150 255 0 '') $(Color 100 255 0 '') $(Color 50 255 0 '') $(Color 0 255 0 '') $(Color 0 255 50 '') $(Color 0 255 100 '') $(Color 0 255 150 '') $(Color 0 255 200 '') $(Color 0 255 255 '')"
Write-Host ""
