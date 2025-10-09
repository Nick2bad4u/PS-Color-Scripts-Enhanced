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
            'binary-tree'
        )

        Nature       = @(
            'galaxy-spiral',
            'aurora-bands',
            'aurora-storm',
            'aurora-stream',
            'crystal-drift',
            'crystal-grid',
            'barnsley-fern',
            'enchanted-forest',
            'perlin-clouds',
            'nebula'
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
            'mandala-pattern'
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
            'tiefighter2'
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
            'unicode-showcase'
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
            'zigzag-lines'
        )

        Physics      = @(
            'boids-flock',
            'nbody-gravity',
            'particle-field',
            'verlet-chains',
            'langton-ant',
            'dla-cluster',
            'dla-nebula',
            'electrostatic-lattice'
        )

        Mathematical = @(
            'fourier-epicycles',
            'lissajous-harmony',
            'lissajous-weave',
            'julia-morphing',
            'clifford-trails',
            'rossler-ribbon',
            'newton-basins'
        )
    }

    # Difficulty levels (for future filtering)
    Difficulty  = @{
        Beginner     = @('bars', 'hearts', 'colorbars', 'gradient-bars')
        Intermediate = @('galaxy-spiral', 'rainbow-waves', 'kaleidoscope')
        Advanced     = @('mandelbrot-zoom', 'fourier-epicycles', 'boids-flock')
    }

    # Rendering complexity (affects cache build time)
    Complexity  = @{
        Fast   = @('bars', 'colorbars', 'hearts', 'arch', 'debian')
        Medium = @('galaxy-spiral', 'rainbow-waves', 'mandala-pattern')
        Slow   = @('mandelbrot-zoom', 'julia-morphing', 'fourier-epicycles')
    }

    # Recommended for profile
    Recommended = @(
        'hearts',
        'galaxy-spiral',
        'rainbow-spiral',
        'mandala-pattern',
        'aurora-bands',
        'nerd-font-test',
        'dev-workspace',
        'arch',
        'bars'
    )
}
