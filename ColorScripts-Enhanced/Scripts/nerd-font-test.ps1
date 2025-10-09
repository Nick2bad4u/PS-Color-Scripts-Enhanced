# Nerd Font Test - Showcases popular Nerd Font glyphs and icons
# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27

function Color {
    param(
        [Parameter(Mandatory = $true)]
        [int]$r,
        [Parameter(Mandatory = $true)]
        [int]$g,
        [Parameter(Mandatory = $true)]
        [int]$b,
        [Parameter(Mandatory = $true)]
        [string]$text
    )
    "$esc[38;2;$r;$g;${b}m$text$esc[0m"
}

Write-Host -Object ""
Write-Host -Object (Color -r 100 -g 200 -b 255 -text "  ╔═══════════════════════════════════════════════════════════════╗")
Write-Host -Object ((Color -r 100 -g 200 -b 255 -text "  ║") + (" " * 19) + (Color -r 255 -g 200 -b 100 -text "NERD FONT GLYPH SHOWCASE") + (" " * 20) + (Color -r 100 -g 200 -b 255 -text "║"))
Write-Host -Object (Color -r 100 -g 200 -b 255 -text "  ╚═══════════════════════════════════════════════════════════════╝")
Write-Host -Object ""

# Installation Note
Write-Host -Object (Color -r 200 -g 200 -b 200 -text "  Note: These glyphs require a Nerd Font to display correctly.")
Write-Host -Object (Color -r 200 -g 200 -b 200 -text "        Download from: https://www.nerdfonts.com/")
Write-Host -Object ""


# Programming Languages & Frameworks
Write-Host -Object (Color -r 255 -g 150 -b 100 -text "   Programming Languages & Frameworks:")
Write-Host -Object "    $(Color -r 229 -g 77 -b 66 -text '') JavaScript    $(Color -r 55 -g 119 -b 190 -text '') TypeScript    $(Color -r 88 -g 166 -b 255 -text '') React"
Write-Host -Object "    $(Color -r 51 -g 153 -b 51 -text '') Node.js       $(Color -r 97 -g 218 -b 251 -text '') Vue.js        $(Color -r 221 -g 44 -b 41 -text '') Angular"
Write-Host -Object "    $(Color -r 53 -g 114 -b 165 -text '') Python        $(Color -r 204 -g 52 -b 45 -text '') Ruby          $(Color -r 239 -g 111 -b 60 -text '') Rust"
Write-Host -Object "    $(Color -r 0 -g 125 -b 156 -text '') Go/Golang     $(Color -r 244 -g 68 -b 62 -text '') Java          $(Color -r 149 -g 117 -b 205 -text '') C#"
Write-Host -Object "    $(Color -r 88 -g 166 -b 255 -text '') C/C++         $(Color -r 111 -g 66 -b 193 -text '') PHP           $(Color -r 178 -g 98 -b 44 -text '') Swift"
Write-Host -Object "    $(Color -r 74 -g 103 -b 133 -text '') Lua           $(Color -r 241 -g 90 -b 34 -text '') HTML5         $(Color -r 37 -g 155 -b 219 -text '') CSS3"
Write-Host -Object "    $(Color -r 138 -g 173 -b 244 -text '') Kotlin        $(Color -r 220 -g 118 -b 51 -text '') Scala         $(Color -r 100 -g 200 -b 255 -text '') Dart"
Write-Host -Object ""

# File Types
Write-Host -Object (Color -r 150 -g 200 -b 255 -text "   File Types & Icons:")
Write-Host -Object "    $(Color -r 100 -g 180 -b 255 -text '') Folder        $(Color -r 255 -g 200 -b 100 -text '') JSON          $(Color -r 90 -g 180 -b 90 -text '') Markdown"
Write-Host -Object "    $(Color -r 255 -g 150 -b 100 -text '') Archive       $(Color -r 150 -g 200 -b 255 -text '') Config        $(Color -r 200 -g 100 -b 255 -text '') Image"
Write-Host -Object "    $(Color -r 200 -g 150 -b 100 -text '') PDF           $(Color -r 100 -g 255 -b 150 -text '') Document      $(Color -r 255 -g 100 -b 200 -text '') Video"
Write-Host -Object "    $(Color -r 100 -g 200 -b 255 -text '') Audio         $(Color -r 255 -g 200 -b 150 -text '') Database      $(Color -r 200 -g 200 -b 100 -text '') Lock"
Write-Host -Object "    $(Color -r 150 -g 255 -b 100 -text '') Binary        $(Color -r 255 -g 150 -b 200 -text '') XML           $(Color -r 100 -g 150 -b 255 -text '') YAML"
Write-Host -Object ""

# Version Control
Write-Host -Object (Color -r 240 -g 120 -b 80 -text "   Version Control & DevOps:")
Write-Host -Object "    $(Color -r 240 -g 88 -b 53 -text '') Git           $(Color -r 33 -g 136 -b 255 -text '') GitHub        $(Color -r 252 -g 109 -b 38 -text '') GitLab"
Write-Host -Object "    $(Color -r 33 -g 136 -b 255 -text '') Docker        $(Color -r 51 -g 103 -b 214 -text '') Kubernetes    $(Color -r 100 -g 255 -b 100 -text '') CI/CD Pipeline"
Write-Host -Object "    $(Color -r 100 -g 200 -b 255 -text '') Branch        $(Color -r 255 -g 150 -b 100 -text '') Merge         $(Color -r 150 -g 255 -b 150 -text '') Pull Request"
Write-Host -Object ""

# Development Tools
Write-Host -Object (Color -r 100 -g 255 -b 200 -text "   Development Tools & Editors:")
Write-Host -Object "    $(Color -r 0 -g 122 -b 204 -text '') VS Code       $(Color -r 0 -g 150 -b 0 -text '') Vim           $(Color -r 100 -g 200 -b 100 -text '') Neovim"
Write-Host -Object "    $(Color -r 200 -g 150 -b 255 -text '') Terminal     $(Color -r 255 -g 200 -b 100 -text '') Package       $(Color -r 204 -g 52 -b 45 -text '') NPM"
Write-Host -Object "    $(Color -r 44 -g 142 -b 187 -text '') Yarn          $(Color -r 142 -g 214 -b 251 -text '') Webpack       $(Color -r 189 -g 147 -b 249 -text '') Vite"
Write-Host -Object ""

# OS & Environment
Write-Host -Object (Color -r 200 -g 200 -b 255 -text "   Operating Systems:")
Write-Host -Object "    $(Color -r 100 -g 200 -b 255 -text '') Linux         $(Color -r 0 -g 162 -b 232 -text '') Windows       $(Color -r 220 -g 220 -b 220 -text '') Apple/macOS"
Write-Host -Object "    $(Color -r 142 -g 192 -b 124 -text '') Android       $(Color -r 215 -g 10 -b 83 -text '') Debian        $(Color -r 230 -g 130 -b 40 -text '') Ubuntu"
Write-Host -Object "    $(Color -r 51 -g 105 -b 173 -text '') Fedora        $(Color -r 23 -g 147 -b 209 -text '') Arch Linux    $(Color -r 201 -g 42 -b 76 -text '') Raspberry Pi"
Write-Host -Object ""

# Status & Indicators
Write-Host -Object (Color -r 255 -g 255 -b 100 -text "   Status Icons & Symbols:")
Write-Host -Object "    $(Color -r 100 -g 255 -b 100 -text '') Success       $(Color -r 255 -g 200 -b 50 -text '') Warning        $(Color -r 255 -g 100 -b 100 -text '') Error"
Write-Host -Object "    $(Color -r 100 -g 200 -b 255 -text '') Info          $(Color -r 200 -g 50 -b 50 -text '') Bug           $(Color -r 255 -g 150 -b 50 -text '') Fire"
Write-Host -Object "    $(Color -r 255 -g 215 -b 0 -text '') Star          $(Color -r 255 -g 100 -b 150 -text '') Heart         $(Color -r 255 -g 200 -b 100 -text '') Lightning"
Write-Host -Object "    $(Color -r 150 -g 200 -b 255 -text '') Bookmark      $(Color -r 100 -g 255 -b 200 -text '') Tag           $(Color -r 150 -g 200 -b 255 -text '') Search"
Write-Host -Object ""

# UI Elements
Write-Host -Object (Color -r 255 -g 200 -b 150 -text "   UI & Navigation:")
Write-Host -Object "    $(Color -r 255 -g 150 -b 100 -text '') Home          $(Color -r 180 -g 180 -b 180 -text '') Settings      $(Color -r 100 -g 150 -b 255 -text '') Dashboard"
Write-Host -Object "    $(Color -r 100 -g 200 -b 255 -text '') Folder Open   $(Color -r 255 -g 100 -b 150 -text '') Download      $(Color -r 150 -g 255 -b 100 -text '') Upload"
Write-Host -Object "    $(Color -r 200 -g 150 -b 255 -text '') Calendar      $(Color -r 100 -g 255 -b 150 -text '') Clock         $(Color -r 255 -g 200 -b 100 -text '') Bell"
Write-Host -Object "    $(Color -r 255 -g 150 -b 200 -text '') User          $(Color -r 150 -g 255 -b 150 -text '') Team          $(Color -r 100 -g 200 -b 255 -text '') Globe"
Write-Host -Object ""

# Arrows & Separators
Write-Host -Object (Color -r 150 -g 255 -b 255 -text "   Powerline & Separators:")
Write-Host -Object "                   "
Write-Host -Object "                   "
Write-Host -Object "                   "
Write-Host -Object ""

# Weather & Miscellaneous
Write-Host -Object (Color -r 255 -g 255 -b 150 -text "   Weather & Miscellaneous:")
Write-Host -Object "    $(Color -r 255 -g 200 -b 50 -text '') Sun           $(Color -r 200 -g 200 -b 200 -text '') Cloud         $(Color -r 100 -g 150 -b 255 -text '') Rain"
Write-Host -Object "    $(Color -r 200 -g 200 -b 255 -text '') Moon          $(Color -r 150 -g 200 -b 255 -text '') Snowflake     $(Color -r 255 -g 215 -b 0 -text '') Lightning"
Write-Host -Object "    $(Color -r 100 -g 200 -b 255 -text '') WiFi          $(Color -r 100 -g 255 -b 100 -text '') Battery       $(Color -r 255 -g 100 -b 100 -text '') Power"
Write-Host -Object "    $(Color -r 200 -g 100 -b 100 -text '') CPU           $(Color -r 100 -g 200 -b 255 -text '') Memory        $(Color -r 100 -g 255 -b 200 -text '') Network"
Write-Host -Object ""

# Special Characters
Write-Host -Object (Color -r 200 -g 150 -b 255 -text "   Special Symbols:")
Write-Host -Object "    $(Color -r 100 -g 255 -b 100 -text '') Checkmark     $(Color -r 255 -g 100 -b 100 -text '') Cross         $(Color -r 150 -g 200 -b 255 -text '') Plus"
Write-Host -Object "    $(Color -r 255 -g 200 -b 150 -text '') Circle        $(Color -r 150 -g 255 -b 100 -text '') Square        $(Color -r 100 -g 150 -b 255 -text '') Diamond"
Write-Host -Object "    $(Color -r 255 -g 150 -b 100 -text '') Arrow Right   $(Color -r 150 -g 255 -b 200 -text '') Arrow Left    $(Color -r 200 -g 150 -b 100 -text '') Arrow Up"
Write-Host -Object "    $(Color -r 100 -g 255 -b 150 -text '') Dot           $(Color -r 255 -g 100 -b 200 -text '') Line          $(Color -r 150 -g 200 -b 255 -text '') Ellipsis"
Write-Host -Object ""

# Cool Demo
Write-Host -Object (Color -r 255 -g 255 -b 100 -text "   Cool Gradient Demo:")
Write-Host -Object "    $(Color -r 255 -g 0 -b 0 -text '') $(Color -r 255 -g 50 -b 0 -text '') $(Color -r 255 -g 100 -b 0 -text '') $(Color -r 255 -g 150 -b 0 -text '') $(Color -r 255 -g 200 -b 0 -text '') $(Color -r 255 -g 255 -b 0 -text '') $(Color -r 200 -g 255 -b 0 -text '') $(Color -r 150 -g 255 -b 0 -text '') $(Color -r 100 -g 255 -b 0 -text '') $(Color -r 50 -g 255 -b 0 -text '') $(Color -r 0 -g 255 -b 0 -text '') $(Color -r 0 -g 255 -b 50 -text '') $(Color -r 0 -g 255 -b 100 -text '') $(Color -r 0 -g 255 -b 150 -text '') $(Color -r 0 -g 255 -b 200 -text '') $(Color -r 0 -g 255 -b 255 -text '')"
Write-Host -Object ""
