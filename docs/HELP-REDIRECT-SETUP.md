# Multi-Language Help Redirect System

## Overview

This document explains the automatic culture-aware help redirect system for ColorScripts-Enhanced that enables `Get-Help -Online` to automatically redirect users to help documentation in their preferred language.

## How It Works

### The Problem

PowerShell's `HelpUri` parameter in `[CmdletBinding()]` is a **static string** that cannot dynamically change based on the user's culture (`$PSUICulture`). This means we can't directly point to language-specific documentation.

### The Solution

We created a smart redirect page (`help-redirect.html`) that:

1. **Detects the user's browser language** when they visit
2. **Maps it to a PowerShell culture** (de, es, fr, it, ja, nl, pt, ru, zh-CN, or en-US)
3. **Automatically redirects** to the appropriate language version of the documentation
4. **Falls back to English** if the user's language isn't supported

## Setup Instructions

### 1. Enable GitHub Pages

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Pages**
3. Under **Source**, select **Deploy from a branch**
4. Choose **main** branch and **/ (root)** or **/docs** folder
5. Click **Save**

### 2. Wait for Deployment

GitHub Pages will deploy automatically (usually takes 1-2 minutes). You'll see a message like:

```
Your site is live at https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/
```

### 3. Update HelpUri Values

The redirect URL format is:

```
https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=<CmdletName>
```

For example:
- `Show-ColorScript`: `https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript`
- `Get-ColorScriptList`: `https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList`

### 4. Optional: Force a Specific Language

Users can override automatic detection by adding `&lang=<culture>`:

```
https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript&lang=fr
```

## Supported Languages

The redirect system automatically detects and maps these languages:

| Language | Culture Code | Supported |
|----------|-------------|-----------|
| German | de | ✅ |
| English (US) | en-US | ✅ |
| Spanish | es | ✅ |
| French | fr | ✅ |
| Italian | it | ✅ |
| Japanese | ja | ✅ |
| Dutch | nl | ✅ |
| Portuguese | pt | ✅ |
| Russian | ru | ✅ |
| Chinese (Simplified) | zh-CN | ✅ |

## Language Detection Logic

The redirect page uses this priority order:

1. **URL Parameter** (`&lang=de`) - Highest priority
2. **Browser Languages** (from `navigator.languages`)
3. **Language Mapping** (e.g., `de-AT` → `de`)
4. **Fallback to English** (`en-US`) - Default

## Testing

You can test the redirect system by:

1. **Testing automatic detection**:
   ```
   Start-Process "https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript"
   ```

2. **Testing specific language**:
   ```
   Start-Process "https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript&lang=fr"
   ```

3. **Testing from PowerShell**:
   ```powershell
   Get-Help Show-ColorScript -Online
   ```

## Benefits

✅ **Automatic Language Detection** - Users see help in their preferred language
✅ **Universal HelpUri** - One static URL works for all languages
✅ **Fast Redirect** - 500ms delay for smooth user experience
✅ **Fallback Support** - Always defaults to English if language unavailable
✅ **Manual Override** - Users can force a specific language via URL parameter
✅ **No Server Required** - Pure client-side JavaScript on GitHub Pages

## Troubleshooting

### Redirect doesn't work

- **Check GitHub Pages is enabled** and deployed
- **Verify the URL** matches your repository name
- **Check browser console** for JavaScript errors

### Wrong language displayed

- Add `&lang=<culture>` to force a specific language
- Check your browser's language settings

### Page not found (404)

- Ensure `help-redirect.html` is in the `docs/` folder
- Verify GitHub Pages is set to deploy from `docs/` folder or `/` (root)
- Wait a few minutes for GitHub Pages to rebuild

## Maintenance

When adding a new language:

1. Add the culture code to `supportedCultures` array in `help-redirect.html`
2. Add language mappings to `languageMap` object
3. Create the corresponding help files in `ColorScripts-Enhanced/<culture>/`
4. Rebuild help files with `.\scripts\build.ps1`

## Alternative: Deep Linking

If you prefer direct GitHub links without redirect, you can use:

```
https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/en-US/Show-ColorScript.md
```

But this won't auto-detect the user's language.

## Related Files

- `docs/help-redirect.html` - The redirect page
- `ColorScripts-Enhanced/*.psm1` - Module files with HelpUri attributes
- `scripts/build.ps1` - Help file builder
- All `*.md` help files in culture-specific folders

---

**Last Updated**: November 1, 2025
**Version**: 1.0.0
