# PowerShell ANSI Color Script Guide

## Critical Rules for Coloring ASCII Art in PowerShell

### 1. **Variable Delimiter Issues**

**Problem:** When using `${variable}` syntax followed by a letter, PowerShell tries to interpret the letter as part of the variable name.

```powershell
# ❌ WRONG - PowerShell thinks variable is ${gray}P
"${gray}P"  # Outputs nothing because ${gray}P doesn't exist

# ✅ CORRECT - Use $reset between color changes
"${reset}${gray}P"  # Outputs gray "P"
```

**Solution:** Always insert `$reset` between any color variable and following text that starts with a letter.

### 2. **Backtick Escape Sequences**

**Problem:** Backticks (`` ` ``) before certain letters create escape sequences:
- `` `b `` = backspace
- `` `d `` = (not defined but causes issues)
- `` `t `` = tab
- `` `n `` = newline
- `` `r `` = carriage return

```powershell
# ❌ WRONG - The `b gets escaped
"${white}`[${brightred}`bug${white}`]"
# Output: "[ug]" - the 'b' disappears!

# ✅ CORRECT - Use reset to separate
"${white}[$reset${brightred}bug$reset${white}]"
```

### 3. **Dollar Sign Escaping**

**Problem:** Dollar signs ($) need to be escaped with backticks, but this creates alignment issues.

```powershell
# ❌ WRONG - Literal $ interpreted as variable
"$$$$$"  # PowerShell tries to evaluate variables

# ✅ CORRECT - Escape each dollar sign
"`$`$`$`$`$"  # Outputs: $$$$$
```

### 4. **Mixing Color Variables and Literal Text**

**Problem:** When transitioning between colors and literal characters, variable expansion can break.

```powershell
# ❌ WRONG - ${gray}P becomes one variable name
"$red`$`$`$${gray}P^*"

# ✅ CORRECT - Insert reset between transitions
"$red`$`$`$$reset${gray}P^*"
```

### 5. **Here-String vs Write-Host Lines**

**Here-String Issues:**
- Variable interpolation happens all at once
- Harder to debug specific lines
- Can have unexpected escape sequence interactions

**Write-Host Line-by-Line:**
- Each line is independent
- Easier to debug
- Better control over color transitions
- **RECOMMENDED for complex ASCII art**

```powershell
# ❌ Problematic Here-String
Write-Host @"
${gray}Text${red}`$`$`$${gray}More
"@

# ✅ Better approach - Individual lines
Write-Host "${gray}Text$reset$red`$`$`$$reset${gray}More$reset"
```

### 6. **The Reset Pattern**

**Always follow this pattern for color transitions:**

```powershell
# Pattern: [color][content]$reset[next-color][content]$reset

Write-Host "$red`$`$`$$reset${gray}P^*^T$reset$red`$`$$reset"
```

This ensures:
- No variable name collisions
- Clean color boundaries
- Predictable output

### 7. **Special Characters That Need Backticks**

Characters that need escaping in double-quoted strings:
- `` ` `` (backtick itself) - ``` `` ```
- `$` (dollar) - `` `$ ``
- `"` (quote) - `` `" ``
- Newlines/tabs if you DON'T want them - `` `n ``, `` `t ``

**IMPORTANT - Backslash is NOT an escape character in PowerShell:**

Unlike many other languages, backslash (`\`) is a literal character in PowerShell, NOT an escape character. The backtick (`` ` ``) is PowerShell's escape character.

```powershell
# ✅ CORRECT - Backslash is literal, no escaping needed
Write-Host "C:\Users\Name"      # Outputs: C:\Users\Name
Write-Host "\.period"            # Outputs: \.period
Write-Host "\-dash"              # Outputs: \-dash

# ❌ WRONG - Don't escape backslash with backtick
Write-Host "C:\`Users\`Name"    # Unnecessary escaping
Write-Host "\`.period"          # Outputs backtick, not what you want
Write-Host "\`-dash"            # Outputs backtick, not what you want

# ✅ CORRECT - Only escape backticks and dollars
Write-Host "``backtick"         # Outputs: `backtick
Write-Host "`$dollar"           # Outputs: $dollar
```

**Common Pattern Mistakes:**
- `\`` - This is backslash + escaped-backtick (outputs: \`)
- `\.` - This is just backslash + period (outputs: \.)
- `\-` - This is just backslash + dash (outputs: \-)

**When working with ASCII art containing backslashes:**
- Use `\\` to output a single backslash (PowerShell string literal, not escaping)
- Use `\` followed by any character that's not special
- Never use `` \` `` unless you specifically want backslash-backtick output

**CRITICAL - Backtick Escaping in Strings:**

When the original ASCII art contains a literal backtick character (`` ` ``), you MUST escape it with another backtick in PowerShell double-quoted strings:

```powershell
# Original ASCII has: `*TP*
# ❌ WRONG - Creates escape sequence issues
Write-Host "\`*TP*"  # May cause parser errors

# ❌ WRONG - Backslash-backtick is NOT the same as double-backtick
Write-Host "\``*TP*"  # This is backslash + escaped-backtick - WRONG!

# ✅ CORRECT - Double backtick for literal backtick
Write-Host "``*TP*"  # Outputs: `*TP*
```

**Common Mistakes with Backslash-Backtick (`\```):**

The pattern `\``` appears to work but causes subtle parser errors:
- `\``` means: backslash + backtick-escape-for-backtick
- This creates ambiguous parsing situations
- Can cause "Unexpected token" errors at seemingly random positions

**Always use double-backtick (``` `` ```) for literal backticks, never `\```**

```powershell
# ❌ WRONG - All of these use incorrect \` pattern
Write-Host "${gray}P*     ${white}\`*'${gray} _._  \`T$reset"

# ✅ CORRECT - Use `` for literal backticks
Write-Host "${gray}P*     ${white}``*'${gray} _._  ``T$reset"
```

### 8. **Color Variable Definition**

Use RGB ANSI codes for best compatibility:

```powershell
$esc = [char]27

# Basic format: ESC[38;2;R;G;Bm
$red = "$esc[38;2;238;0;0m"
$gray = "$esc[38;2;140;140;140m"
$white = "$esc[38;2;220;220;220m"

# Bold
$boldon = "$esc[1m"

# Always include reset
$reset = "$esc[0m"
```

### 9. **Debugging Alignment Issues**

If output is misaligned:

1. **Check for escape sequence bugs** - Look for backtick before b, d, t, n, r
2. **Verify dollar escaping** - Each $ should be `` `$ ``
3. **Test color boundaries** - Add $reset between color changes
4. **Count visible characters** - ANSI codes don't count toward width
5. **Test line by line** - Comment out lines to isolate the problem
6. **Compare character-by-character** - Count $ symbols, spaces, and special characters against original
7. **Watch for incorrect backslash escaping** - Don't use `` \` `` when you mean `\.` or `\-`

**Character Counting Tips:**
- Count each literal `$` in the original ASCII (each becomes `` `$ `` in code)
- Verify spaces match exactly
- Check that backslashes are literal `\`, not escaped with backtick
- Ensure color codes don't accidentally consume following characters

### 10. **Best Practices Template**

```powershell
# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27

# Define all colors
$red = "$esc[38;2;238;0;0m"
$gray = "$esc[38;2;140;140;140m"
$white = "$esc[38;2;220;220;220m"
$boldon = "$esc[1m"
$reset = "$esc[0m"

# Use Write-Host per line
Write-Host ""
Write-Host "$boldon${red}Title$reset"
Write-Host "${gray}Text $reset$red`$`$`$$reset${gray} More$reset"
Write-Host ""
```

## Complete Example

```powershell
# RedHat Bug - Proper Implementation
$esc = [char]27
$red = "$esc[38;2;238;0;0m"
$gray = "$esc[38;2;140;140;140m"
$white = "$esc[38;2;220;220;220m"
$reset = "$esc[0m"

# Notice the $reset between each color transition
Write-Host "${gray}            .sd$red`$`$`$`$`$`$`$$reset${gray}P^*^T${reset}$red`$`$`$$reset${gray}P^*"*^T${reset}$red`$`$`$`$$reset${gray}bs.$reset"
```

## Quick Reference

| Issue | Wrong | Right |
|-------|-------|-------|
| Letter after color | `${gray}P` | `$reset${gray}P` |
| Backtick + letter | ``` ${white}`bug ``` | `$reset${white}bug` |
| Dollar signs | `$$$` | `` `$`$`$ `` |
| Color transitions | `$red$$$${gray}P` | `$red`$`$`$$reset${gray}P` |
| Complex strings | Here-string | Write-Host lines |
| Backslash escaping | `` \`. `` or `` \`- `` | `\.` or `\-` |
| Missing dollars | Count mismatch | Count each $ in original |

## Testing Checklist

- [ ] Run script and verify alignment matches original
- [ ] Check for missing characters (especially b, d, t after backticks)
- [ ] Verify all dollar signs display correctly
- [ ] Confirm colors appear as intended
- [ ] Test with cache disabled
- [ ] Compare output character-by-character with original ASCII
- [ ] Count $ symbols in each line matches original exactly
- [ ] Verify backslashes are literal (not escaped with backtick)
- [ ] Check that color transitions use $reset properly
- [ ] Ensure no accidental escape sequences (`` `b ``, `` `d ``, `` `n ``, `` `r ``, `` `t ``)

---

**Remember:** When in doubt, add more `$reset` markers. They don't add visible characters but ensure clean color transitions.
