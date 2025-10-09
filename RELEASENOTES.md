# ColorScripts-Enhanced Module Release Notes

## Version 2025.10.09.1625

### New Features
- Enhanced caching system with OS-wide cache in AppData
- 6-19x performance improvement over non-cached execution
- Centralized cache location that works from any directory
- Automatic cache validation and regeneration
- 185+ beautiful colorscripts included
- Complete comment-based help documentation
- Full PowerShell Gallery compliance

### Performance Improvements
- Cached scripts display in 8-16ms vs 50-300ms uncached
- Simple scripts: ~6x faster with cache
- Medium scripts: ~12x faster with cache
- Complex scripts: ~19x faster with cache

### Cache System
- Cache stored in: `$env:APPDATA\ColorScripts-Enhanced\cache`
- Automatic cache invalidation on script modification
- UTF-8 encoding preserved for perfect rendering
- Cache files include timestamp validation

### Commands
All commands include comprehensive help:
- `Show-ColorScript` (alias: `scs`) - Display colorscripts
- `Get-ColorScriptList` - List available scripts
- `Build-ColorScriptCache` - Pre-generate cache files
- `Clear-ColorScriptCache` - Remove cache files

### Documentation
- Complete about_ColorScripts-Enhanced help topic
- Individual cmdlet help in markdown format
- Examples for all use cases
- Troubleshooting guide
- Performance metrics

### Script Categories
New colorscripts added in categories:
- Geometric patterns
- Nature and space
- Artistic designs
- Gaming references
- System utilities
- OS logos
- Nerd Font showcases
- Data visualization

## Version 2025.10.08

### Initial Release
- Basic colorscript display functionality
- Random script selection
- Script listing
- Initial caching implementation

## Planned Features

### Version 2025.11.x
- Custom colorscript import/export
- Script categories and tagging
- Favorite scripts management
- Theme support for colorscripts
- Web-based script browser
- Script search functionality

### Version 2026.x.x
- Animated colorscript support
- Interactive colorscripts
- Sound integration
- Community script repository
- Script editor integration
- PowerShell 7.5+ specific features

## Breaking Changes

None in current version. Module maintains backward compatibility with PowerShell 5.1+.

## Known Issues

### Terminal Compatibility
- Some terminals may not support full ANSI escape code sequences
- Windows Terminal recommended for best experience
- ConEmu and iTerm2 fully supported
- Legacy cmd.exe has limited ANSI support

### Performance
- First run of each script is slower as cache is built
- Use `Build-ColorScriptCache -All` to pre-build all caches
- Very complex scripts may take 200-300ms to cache initially

## Upgrade Notes

### From Earlier Versions
1. Remove old module version if manually installed
2. Install new version
3. Run `Build-ColorScriptCache -All` to rebuild cache
4. Update any scripts that reference old function names

### Clean Installation
1. Install from PowerShell Gallery: `Install-Module ColorScripts-Enhanced`
2. Import module: `Import-Module ColorScripts-Enhanced`
3. Optional: Pre-build cache: `Build-ColorScriptCache -All`
4. View available scripts: `Get-ColorScriptList`

## Contributing

Contributions welcome! See CONTRIBUTING.md for guidelines.

### Adding New Colorscripts
1. Create script in `Scripts/` folder
2. Follow naming convention: `lowercase-with-hyphens.ps1`
3. Include cache header: `if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }`
4. Use UTF-8 encoding
5. Test with `Show-ColorScript -Name yourscript`

### Reporting Issues
- Use GitHub Issues
- Include PowerShell version
- Include terminal information
- Provide script name if applicable
- Include error messages

## Credits

- Original inspiration: shell-color-scripts
- Community contributors
- Script authors and designers

## License

MIT License - See LICENSE file for details
