# Text Styles - Showcase ANSI text formatting capabilities
# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27

Write-Host "`n  ANSI TEXT FORMATTING STYLES`n" -ForegroundColor Cyan

# Basic formatting
Write-Host "  Basic Text Formatting:"
Write-Host "    Normal Text                  $esc[0mNormal$esc[0m"
Write-Host "    Bold/Bright                  $esc[1mBold Text$esc[0m"
Write-Host "    Dim/Faint                    $esc[2mDim Text$esc[0m"
Write-Host "    Italic                       $esc[3mItalic Text$esc[0m"
Write-Host "    Underline                    $esc[4mUnderlined Text$esc[0m"
Write-Host "    Blinking (may not work)      $esc[5mBlinking Text$esc[0m"
Write-Host "    Reverse/Inverse              $esc[7mReversed Text$esc[0m"
Write-Host "    Strikethrough                $esc[9mStrikethrough Text$esc[0m"
Write-Host ""

# Combined styles
Write-Host "  Combined Formatting:"
Write-Host "    Bold + Underline             $esc[1;4mBold & Underlined$esc[0m"
Write-Host "    Bold + Italic                $esc[1;3mBold & Italic$esc[0m"
Write-Host "    Underline + Italic           $esc[3;4mItalic & Underlined$esc[0m"
Write-Host "    All Three                    $esc[1;3;4mBold, Italic & Underlined$esc[0m"
Write-Host ""

# Colors with styles
Write-Host "  Colored Text with Formatting:"
Write-Host "    $esc[31mRed$esc[0m                          $esc[1;31mBold Red$esc[0m          $esc[4;31mUnderlined Red$esc[0m"
Write-Host "    $esc[32mGreen$esc[0m                        $esc[1;32mBold Green$esc[0m        $esc[4;32mUnderlined Green$esc[0m"
Write-Host "    $esc[34mBlue$esc[0m                         $esc[1;34mBold Blue$esc[0m         $esc[4;34mUnderlined Blue$esc[0m"
Write-Host "    $esc[35mMagenta$esc[0m                      $esc[1;35mBold Magenta$esc[0m      $esc[4;35mUnderlined Magenta$esc[0m"
Write-Host "    $esc[36mCyan$esc[0m                         $esc[1;36mBold Cyan$esc[0m         $esc[4;36mUnderlined Cyan$esc[0m"
Write-Host "    $esc[33mYellow$esc[0m                       $esc[1;33mBold Yellow$esc[0m       $esc[4;33mUnderlined Yellow$esc[0m"
Write-Host ""

# RGB colored text with styles
Write-Host "  True Color (RGB) with Formatting:"
Write-Host "    $esc[38;2;255;100;100mLight Red$esc[0m                  $esc[1;38;2;255;100;100mBold Light Red$esc[0m"
Write-Host "    $esc[38;2;100;255;100mLight Green$esc[0m                $esc[1;38;2;100;255;100mBold Light Green$esc[0m"
Write-Host "    $esc[38;2;100;100;255mLight Blue$esc[0m                 $esc[1;38;2;100;100;255mBold Light Blue$esc[0m"
Write-Host "    $esc[38;2;255;150;0mOrange$esc[0m                     $esc[3;38;2;255;150;0mItalic Orange$esc[0m"
Write-Host "    $esc[38;2;128;0;255mPurple$esc[0m                     $esc[4;38;2;128;0;255mUnderlined Purple$esc[0m"
Write-Host ""

# Background colors
Write-Host "  Background Colors:"
Write-Host "    $esc[41m  Red BG  $esc[0m  $esc[42m Green BG  $esc[0m  $esc[43m Yellow BG $esc[0m  $esc[44m  Blue BG $esc[0m"
Write-Host "    $esc[45mMagenta BG$esc[0m  $esc[46m  Cyan BG $esc[0m  $esc[47m  White BG $esc[0m  $esc[100m  Gray BG $esc[0m"
Write-Host ""

# Fancy combinations
Write-Host "  Creative Combinations:"
Write-Host "    $esc[1;38;2;255;215;0m✦ $esc[4;38;2;255;215;0mGolden Underlined Text$esc[0;38;2;255;215;0m ✦$esc[0m"
Write-Host "    $esc[1;38;2;0;255;255m◆ $esc[3;38;2;0;255;255mCyan Italic Diamonds$esc[0;38;2;0;255;255m ◆$esc[0m"
Write-Host "    $esc[1;38;2;255;105;180m★ $esc[38;2;255;105;180mHot Pink Stars$esc[0;38;2;255;105;180m ★$esc[0m"
Write-Host "    $esc[7;38;2;100;200;255m▓▓▓ Reversed Light Blue ▓▓▓$esc[0m"
Write-Host ""

# Rainbow text
Write-Host -NoNewline "  Rainbow Text: "
$text = "The Quick Brown Fox Jumps Over The Lazy Dog"
$colors = @(
    @(255, 0, 0), @(255, 127, 0), @(255, 255, 0), @(0, 255, 0),
    @(0, 0, 255), @(75, 0, 130), @(148, 0, 211)
)
for ($i = 0; $i -lt $text.Length; $i++) {
    $c = $colors[$i % $colors.Count]
    Write-Host -NoNewline "$esc[38;2;$($c[0]);$($c[1]);$($c[2])m$($text[$i])$esc[0m"
}
Write-Host "`n"
