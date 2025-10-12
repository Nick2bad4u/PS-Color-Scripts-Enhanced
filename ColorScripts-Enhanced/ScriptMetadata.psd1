@{
    # Script Categories
    Categories  = @{
        Geometric    = @(
            'mandelbrot-zoom',
            'apollonian-circles',
            'sierpinski-carpet',
            'koch-snowflake',
            'penrose-quasicrystal',
            'pythagorean-tree',
            'hilbert-spectrum',
            'fractal-tree',
            'binary-tree',
            'circle-packing',
            'flower-of-life',
            'geometric-tessellation',
            'honeycomb-lattice',
            'kaleidoscope-mirror',
            'polygon-wavefront',
            'quasicrystal-arbor',
            'radial-rings',
            'rose-curves',
            'rose-window',
            'spiral-lattice',
            'spiral-tessellation',
            'sunburst-geodesics',
            'tessellation-static',
            'triforce',
            'truchet-flow'
        )

        Nature       = @(
            'galaxy-spiral',
            'aurora-bands',
            'aurora-storm',
            'aurora-stream',
            'aurora-waves',
            'aurora-halo',
            'crystal-drift',
            'crystal-grid',
            'crystal-lattice',
            'barnsley-fern',
            'enchanted-forest',
            'perlin-clouds',
            'nebula',
            'nebula-lights',
            'domain-warp-aurora',
            'lsystem-plant',
            'starfield-warp',
            'solar-system',
            'voronoi-aurora',
            'cosmic-web',
            'cosmic-mandala',
            'lunar-orbit',
            'twilight-dunes',
            'sunrise-lattice'
        )

        Artistic     = @(
            'kaleidoscope',
            'rainbow-waves',
            'prismatic-rain',
            'color-morphing',
            'rainbow-spiral',
            'mosaic-shine',
            'chromatic-lorenz',
            'inkblot-spectrum',
            'flower-mandala',
            'mandala-pattern',
            'floral-mandala',
            'prismatic-crystals',
            'psychedelic-vortex',
            'tie-dye-spiral',
            'rainbow-ridges',
            'spectrum-flames',
            'plasma-fractal',
            'plasma-field',
            'lightning-plasma',
            'prism-diagonals',
            'sdf-neon-orb',
            'city-neon',
            'starlit-plaza',
            'wave-interference',
            'waveform-spectra',
            'wavelet-ridges',
            'vortex',
            'hyperbolic-bloom',
            'ember-spiral',
            'explosive-burst',
            'braid-resonance',
            'chrono-tilt',
            'cyclone-vortex'
        )

        Gaming       = @(
            'doom-original',
            'doom-outlined',
            'pacman',
            'space-invaders',
            'rally-x',
            'tanks',
            'crunchbang',
            'crunchbang-mini',
            'tiefighter1',
            'tiefighter2',
            'tiefighter1-no-invo',
            'tiefighter1row'
        )

        System       = @(
            'colortest',
            'colortest-slim',
            'nerd-font-test',
            'terminal-benchmark',
            'ansi-palette',
            'gradient-test',
            'block-test',
            'text-styles',
            'unicode-showcase',
            'colorview',
            'colorwheel',
            'nerd-font-glyphs',
            'rgb-spectrum',
            'awk-rgb-test',
            'spectrum'
        )

        Logos        = @(
            'arch',
            'debian',
            'ubuntu',
            'manjaro',
            'kaisen',
            'windows',
            'android',
            'apple'
        )

        NerdFont     = @(
            'dev-workspace',
            'music-studio',
            'game-setup',
            'cloud-services',
            'data-science',
            'design-studio',
            'network-tools',
            'productivity-suite',
            'security-tools',
            'mobile-dev'
        )

        Patterns     = @(
            'bars',
            'colorbars',
            'gradient-bars',
            'blocks1',
            'blocks2',
            'hex-blocks',
            'iso-cubes',
            'diamonds',
            'triangles',
            'zigzag-lines',
            'bloks',
            'hex-maze',
            'labyrinth-pattern',
            'hex',
            'horizon-stripes',
            'panes',
            'midnight-grid',
            'dot-matrix',
            'wave-pattern',
            'rails',
            'flow-field-static'
        )

        Physics      = @(
            'boids-flock',
            'nbody-gravity',
            'particle-field',
            'verlet-chains',
            'langton-ant',
            'dla-cluster',
            'dla-nebula',
            'electrostatic-lattice',
            'quantum-entanglement',
            'sandpile-sparks',
            'life-trails',
            'vector-streams'
        )

        Mathematical = @(
            'fourier-epicycles',
            'lissajous-harmony',
            'lissajous-weave',
            'julia-morphing',
            'clifford-trails',
            'rossler-ribbon',
            'newton-basins',
            'complex-lissajous',
            'fractal-nebula',
            'galactic-spiral'
        )

        Skull        = @(
            'pukeskull',
            'pukeskull-neon',
            'pukeskull-rainbow',
            'rainbow-pukeskull'
        )

        TerminalThemes = @(
            'terminal',
            'terminal-fire',
            'terminal-fire-wave',
            'terminal-forest-wave',
            'terminal-glow',
            'terminal-halloween',
            'terminal-monochrome',
            'terminal-neon',
            'terminal-ocean',
            'terminal-ocean-wave',
            'terminal-pastel',
            'terminal-rainbow',
            'terminal-rainbow-wave',
            'terminal-retro',
            'terminal-space-wave',
            'terminal-sunset-wave'
        )

        ASCIIArt     = @(
            'cats',
            'crabs',
            'crowns',
            'darthvader',
            'dna',
            'dotx',
            'elfman',
            'faces',
            'ghosts',
            'guns',
            'hearts',
            'hearts2',
            'hedgehogs',
            'jangofett',
            'kevin-woods',
            'monster',
            'mouseface',
            'mouseface2',
            'pinguco',
            'rupees',
            'six',
            'square',
            'suckless',
            'thebat',
            'thebat2',
            'thisisfine',
            'tux',
            'tvs',
            'unowns',
            'xmonad',
            'alpha',
            'AAAAAA',
            'OOOOOO',
            'amiga-classic',
            'arrows',
            'fade',
            'illumina',
            'pixel-falls'
        )

        RGB          = @(
            'RGB-Wave',
            'RGB-Wave-Shifted',
            'Gradient-Tiles',
            'Galaxy'
        )

        Welcome      = @(
            'welcome-Bears2',
            'welcome-cats'
        )

        Default      = @(
            '00default',
            'crunch',
            'zwaves'
        )
    }

    # Difficulty levels (for future filtering)
    Difficulty  = @{
        Beginner     = @(
            'bars', 'hearts', 'colorbars', 'gradient-bars', 'blocks1', 'blocks2',
            'diamonds', 'triangles', 'zigzag-lines', 'panes', 'rails', 'fade',
            'horizon-stripes', 'dot-matrix', 'arch', 'debian', 'tux'
        )
        Intermediate = @(
            'galaxy-spiral', 'rainbow-waves', 'kaleidoscope', 'mandala-pattern',
            'aurora-bands', 'aurora-waves', 'rainbow-spiral', 'prismatic-rain',
            'flower-mandala', 'rose-window', 'geometric-tessellation', 'hex-maze',
            'terminal-rainbow', 'terminal-fire', 'terminal-ocean', 'plasma-field'
        )
        Advanced     = @(
            'mandelbrot-zoom', 'fourier-epicycles', 'boids-flock', 'julia-morphing',
            'fractal-nebula', 'galactic-spiral', 'quantum-entanglement', 'nbody-gravity',
            'psychedelic-vortex', 'tie-dye-spiral', 'kaleidoscope-mirror', 'domain-warp-aurora',
            'wave-interference', 'verlet-chains', 'life-trails', 'langton-ant'
        )
    }

    # Rendering complexity (affects cache build time)
    Complexity  = @{
        Fast   = @(
            'bars', 'colorbars', 'hearts', 'arch', 'debian', 'blocks1', 'blocks2',
            'gradient-bars', 'diamonds', 'triangles', 'panes', 'rails', 'fade',
            'terminal', 'colortest', 'ansi-palette', 'text-styles', 'tux',
            'pukeskull', 'pukeskull-neon', 'rainbow-pukeskull', 'cats', 'crabs'
        )
        Medium = @(
            'galaxy-spiral', 'rainbow-waves', 'mandala-pattern', 'aurora-bands',
            'rainbow-spiral', 'kaleidoscope', 'flower-mandala', 'prismatic-rain',
            'rose-window', 'geometric-tessellation', 'terminal-rainbow', 'terminal-fire',
            'plasma-field', 'vortex', 'spiral-lattice', 'hex-maze', 'labyrinth-pattern',
            'aurora-waves', 'crystal-grid', 'nebula-lights', 'starlit-plaza',
            'prism-diagonals', 'spectrum-flames', 'wavelet-ridges'
        )
        Slow   = @(
            'mandelbrot-zoom', 'julia-morphing', 'fourier-epicycles', 'boids-flock',
            'fractal-nebula', 'galactic-spiral', 'quantum-entanglement', 'nbody-gravity',
            'psychedelic-vortex', 'tie-dye-spiral', 'kaleidoscope-mirror', 'domain-warp-aurora',
            'wave-interference', 'verlet-chains', 'life-trails', 'particle-field',
            'lissajous-harmony', 'complex-lissajous', 'rossler-ribbon', 'newton-basins',
            'sandpile-sparks', 'dla-nebula', 'electrostatic-lattice'
        )
    }

    # Recommended for profile
    Recommended = @(
        'hearts',
        'galaxy-spiral',
        'rainbow-spiral',
        'mandala-pattern',
        'aurora-bands',
        'aurora-waves',
        'nerd-font-test',
        'dev-workspace',
        'arch',
        'bars',
        'rainbow-pukeskull',
        'terminal-rainbow',
        'kaleidoscope',
        'flower-mandala',
        'prismatic-rain'
    )
}
