$script:DefaultAutoCategoryRules = @(
    [pscustomobject]@{
        Category = 'Pokemon'
        Tags     = @('Pokemon', 'Gaming', 'Character')
        Patterns = @(
            # Pokemon with variant suffixes (-shiny, -mega, -gmax, etc.)
            '-shiny$',
            '-mega$',
            '-mega-shiny$',
            '-gmax$',
            '-gmax-shiny$',
            '-alola$',
            '-alola-shiny$',
            '-galar$',
            '-galar-shiny$',
            '-hisui$',
            '-hisui-shiny$',
            '-paldea$',
            '-paldea-shiny$',
            '-origin$',
            '-origin-shiny$',
            '-primal$',
            '-primal-shiny$',
            '-blade$',
            '-blade-shiny$',
            '-shield$',
            '-shield-shiny$',
            '-therian$',
            '-therian-shiny$',
            '-incarnate$',
            '-incarnate-shiny$',
            '-female$',
            '-female-shiny$',
            '-male$',
            '-male-shiny$',
            # Common Pokemon form patterns
            '-.*-form$',
            '-.*-forme$',
            '-.*-cloak$',
            '-.*-style$',
            '-.*-mode$',
            '-.*-size$',
            # Alcremie variants (very common pattern)
            '^alcremie-',
            # Vivillon patterns
            '^vivillon-',
            # Flabebe/Floette/Florges variants
            '^flab[eé]b[eé]-',
            '^floette-',
            '^florges-',
            # Minior variants
            '^minior-',
            # Oricorio variants
            '^oricorio-',
            # Wormadam variants
            '^wormadam-',
            # Rotom forms
            '^rotom-',
            # Deoxys forms
            '^deoxys-',
            # Castform forms
            '^castform-',
            # Meowstic forms
            '^meowstic-',
            # Indeedee forms
            '^indeedee-',
            # Basculin forms
            '^basculin-',
            # Lycanroc forms
            '^lycanroc-',
            # Toxtricity forms
            '^toxtricity-',
            # Urshifu forms
            '^urshifu-',
            # Calyrex forms
            '^calyrex-',
            # Zacian/Zamazenta forms
            '^zacian-',
            '^zamazenta-',
            # Eternatus forms
            '^eternatus-',
            # Necrozma forms
            '^necrozma-',
            # Zygarde forms
            '^zygarde-',
            # Hoopa forms
            '^hoopa-',
            # Kyurem forms
            '^kyurem-',
            # Giratina forms
            '^giratina-',
            # Shaymin forms
            '^shaymin-',
            # Meloetta forms
            '^meloetta-',
            # Keldeo forms
            '^keldeo-',
            # Tornadus/Thundurus/Landorus forms
            '^tornadus-',
            '^thundurus-',
            '^landorus-',
            # Enamorus forms
            '^enamorus-'
        )
    }
    [pscustomobject]@{
        Category = 'System'
        Tags     = @('System', 'Utility')
        Patterns = @(
            '^(00default|alpha)$',
            '^ansi-palette$',
            '^awk-rgb-test$',
            '^colortest(-slim)?$',
            '^colorbars$',
            '^colorview$',
            '^colorwheel$',
            '^(A{6}|O{6})$',
            '^nerd-font-(glyphs|test)$',
            '^rgb-spectrum$',
            '^RGB-Wave(-Shifted)?$',
            '^spectrum(-flames)?$',
            '^terminal-benchmark$',
            '^text-styles$',
            '^unicode-showcase$',
            '^gradient-test$'
        )
    }
    [pscustomobject]@{
        Category = 'TerminalThemes'
        Tags     = @('Terminal', 'Theme')
        Patterns = @('^terminal($|-.*)')
    }
    [pscustomobject]@{
        Category = 'Logos'
        Tags     = @('Logo')
        Patterns = @('arch', 'debian', 'manjaro', 'kaisen', 'tux', 'xmonad', 'suckless', 'android', 'apple', 'windows', 'ubuntu', 'pinguco', 'crunchbang', 'amiga')
    }
    [pscustomobject]@{
        Category = 'Gaming'
        Tags     = @('Gaming', 'PopCulture')
        Patterns = @('doom', 'pacman', 'space-invaders', 'tiefighter', 'rally-x', 'tanks', 'guns', 'pukeskull', 'rupees', 'unowns', 'jangofett', 'darthvader')
    }
    [pscustomobject]@{
        Category = 'ASCIIArt'
        Tags     = @('ASCIIArt')
        Patterns = @('cats', 'crabs', 'crowns', 'elfman', 'faces', '^hearts[0-9]*$', 'kevin-woods', 'monster', '^mouseface', 'pinguco', '^thebat', 'thisisfine', '^welcome-', 'ghosts', 'bears', 'hedgehogs', '^tvs$', 'pukeskull')
    }
    [pscustomobject]@{
        Category = 'Physics'
        Tags     = @('Physics')
        Patterns = @('boids', 'cyclone', 'domain', '\bdla\b', '\bdna\b', 'lightning', 'nbody', 'particle', 'perlin', 'plasma', 'sandpile', '\bsdf\b', 'solar-system', 'verlet', 'waveform', 'wavelet', 'wave-interference', 'wave-pattern', 'vector-streams', 'vortex', 'orbit', 'field', 'life', 'langton', 'electrostatic')
    }
    [pscustomobject]@{
        Category = 'Nature'
        Tags     = @('Nature')
        Patterns = @('aurora', 'nebula', 'galaxy', 'forest', 'crystal', 'fern', 'dunes', 'twilight', 'starlit', 'cloud', 'horizon', 'cosmic', 'enchanted')
    }
    [pscustomobject]@{
        Category = 'Mathematical'
        Tags     = @('Mathematical')
        Patterns = @('apollonian', 'barnsley', 'binary-tree', 'clifford', 'fourier', 'fractal', 'hilbert', 'koch', 'lissajous', 'mandelbrot', 'newton', 'penrose', 'pythagorean', 'quasicrystal', 'rossler', 'sierpinski', 'circle-packing', 'lorenz', 'julia', 'lsystem', 'voronoi', 'iso-cubes')
    }
    [pscustomobject]@{
        Category = 'Artistic'
        Tags     = @('Artistic')
        Patterns = @('braid', 'chromatic', 'chrono', 'city', 'ember', 'kaleidoscope', 'mandala', 'mosaic', 'prismatic', 'midnight', 'illumina', 'inkblot', 'pixel', 'sunburst', 'fade', 'starlit', 'twilight', 'rainbow', 'matrix')
    }
    [pscustomobject]@{
        Category = 'Patterns'
        Tags     = @('Pattern')
        Patterns = @('bars?', 'block', 'blok', 'grid', 'maze', 'spiral', 'wave', 'zigzag', 'tile', 'lattice', 'hex', 'ring', 'polygon', 'prism', 'tessell', 'iso', 'quasicrystal', 'rail', 'pane', 'truchet', 'pattern', 'panes', 'rails', 'circle', 'square', 'triangles', 'gradient', 'voronoi', 'radial', '^six$')
    }
)
