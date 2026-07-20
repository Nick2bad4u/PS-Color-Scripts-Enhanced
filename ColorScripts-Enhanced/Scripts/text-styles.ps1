# Generated from verified deterministic output by scripts/Convert-DeterministicColorScripts.ps1.
$esc = [char]27
$sp = ' '

Write-Host @"
$esc[96m
  ANSI TEXT FORMATTING STYLES
$esc[0m
  Basic Text Formatting:
    Normal Text                  $esc[0mNormal$esc[0m
    Bold/Bright                  $esc[1mBold Text$esc[0m
    Dim/Faint                    $esc[2mDim Text$esc[0m
    Italic                       $esc[3mItalic Text$esc[0m
    Underline                    $esc[4mUnderlined Text$esc[0m
    Blinking (may not work)      $esc[5mBlinking Text$esc[0m
    Reverse/Inverse              $esc[7mReversed Text$esc[0m
    Strikethrough                $esc[9mStrikethrough Text$esc[0m

  Combined Formatting:
    Bold + Underline             $esc[1;4mBold & Underlined$esc[0m
    Bold + Italic                $esc[1;3mBold & Italic$esc[0m
    Underline + Italic           $esc[3;4mItalic & Underlined$esc[0m
    All Three                    $esc[1;3;4mBold, Italic & Underlined$esc[0m

  Colored Text with Formatting:
    $esc[31mRed$esc[0m                          $esc[1;31mBold Red$esc[0m          $esc[4;31mUnderlined Red$esc[0m
    $esc[32mGreen$esc[0m                        $esc[1;32mBold Green$esc[0m        $esc[4;32mUnderlined Green$esc[0m
    $esc[34mBlue$esc[0m                         $esc[1;34mBold Blue$esc[0m         $esc[4;34mUnderlined Blue$esc[0m
    $esc[35mMagenta$esc[0m                      $esc[1;35mBold Magenta$esc[0m      $esc[4;35mUnderlined Magenta$esc[0m
    $esc[36mCyan$esc[0m                         $esc[1;36mBold Cyan$esc[0m         $esc[4;36mUnderlined Cyan$esc[0m
    $esc[33mYellow$esc[0m                       $esc[1;33mBold Yellow$esc[0m       $esc[4;33mUnderlined Yellow$esc[0m

  True Color (RGB) with Formatting:
    $esc[38;2;255;100;100mLight Red$esc[0m                  $esc[1;38;2;255;100;100mBold Light Red$esc[0m
    $esc[38;2;100;255;100mLight Green$esc[0m                $esc[1;38;2;100;255;100mBold Light Green$esc[0m
    $esc[38;2;100;100;255mLight Blue$esc[0m                 $esc[1;38;2;100;100;255mBold Light Blue$esc[0m
    $esc[38;2;255;150;0mOrange$esc[0m                     $esc[3;38;2;255;150;0mItalic Orange$esc[0m
    $esc[38;2;128;0;255mPurple$esc[0m                     $esc[4;38;2;128;0;255mUnderlined Purple$esc[0m

  Background Colors:
    $esc[41m  Red BG  $esc[0m  $esc[42m Green BG  $esc[0m  $esc[43m Yellow BG $esc[0m  $esc[44m  Blue BG $esc[0m
    $esc[45mMagenta BG$esc[0m  $esc[46m  Cyan BG $esc[0m  $esc[47m  White BG $esc[0m  $esc[100m  Gray BG $esc[0m

  Creative Combinations:
    $esc[1;38;2;255;215;0m✦ $esc[4;38;2;255;215;0mGolden Underlined Text$esc[0;38;2;255;215;0m ✦$esc[0m
    $esc[1;38;2;0;255;255m◆ $esc[3;38;2;0;255;255mCyan Italic Diamonds$esc[0;38;2;0;255;255m ◆$esc[0m
    $esc[1;38;2;255;105;180m★ $esc[38;2;255;105;180mHot Pink Stars$esc[0;38;2;255;105;180m ★$esc[0m
    $esc[7;38;2;100;200;255m▓▓▓ Reversed Light Blue ▓▓▓$esc[0m

  Rainbow Text: $esc[38;2;255;0;0mT$esc[0m$esc[38;2;255;127;0mh$esc[0m$esc[38;2;255;255;0me$esc[0m$esc[38;2;0;255;0m $esc[0m$esc[38;2;0;0;255mQ$esc[0m$esc[38;2;75;0;130mu$esc[0m$esc[38;2;148;0;211mi$esc[0m$esc[38;2;255;0;0mc$esc[0m$esc[38;2;255;127;0mk$esc[0m$esc[38;2;255;255;0m $esc[0m$esc[38;2;0;255;0mB$esc[0m$esc[38;2;0;0;255mr$esc[0m$esc[38;2;75;0;130mo$esc[0m$esc[38;2;148;0;211mw$esc[0m$esc[38;2;255;0;0mn$esc[0m$esc[38;2;255;127;0m $esc[0m$esc[38;2;255;255;0mF$esc[0m$esc[38;2;0;255;0mo$esc[0m$esc[38;2;0;0;255mx$esc[0m$esc[38;2;75;0;130m $esc[0m$esc[38;2;148;0;211mJ$esc[0m$esc[38;2;255;0;0mu$esc[0m$esc[38;2;255;127;0mm$esc[0m$esc[38;2;255;255;0mp$esc[0m$esc[38;2;0;255;0ms$esc[0m$esc[38;2;0;0;255m $esc[0m$esc[38;2;75;0;130mO$esc[0m$esc[38;2;148;0;211mv$esc[0m$esc[38;2;255;0;0me$esc[0m$esc[38;2;255;127;0mr$esc[0m$esc[38;2;255;255;0m $esc[0m$esc[38;2;0;255;0mT$esc[0m$esc[38;2;0;0;255mh$esc[0m$esc[38;2;75;0;130me$esc[0m$esc[38;2;148;0;211m $esc[0m$esc[38;2;255;0;0mL$esc[0m$esc[38;2;255;127;0ma$esc[0m$esc[38;2;255;255;0mz$esc[0m$esc[38;2;0;255;0my$esc[0m$esc[38;2;0;0;255m $esc[0m$esc[38;2;75;0;130mD$esc[0m$esc[38;2;148;0;211mo$esc[0m$esc[38;2;255;0;0mg$esc[0m

"@