@{
    # Pokémon colorscripts are static today, so none require output caching. Keep this separate
    # from the full metadata catalog so cache builds can apply their default exclusion cheaply.
    CacheablePokemonScripts = @()

    # Output caching is opt-in. Deterministic renderers are flattened at build time, so only
    # intentionally variable renderers whose output is expensive to regenerate belong here.
    # terminal-benchmark and unowns stay uncached because caching would defeat their live behavior.
    CacheableScripts = @(
        'chrono-tilt'
        'complex-lissajous'
        'flower-of-life'
        'fourier-epicycles'
        'Galaxy'
        'julia-morphing'
        'kaleidoscope-mirror'
        'lissajous-harmony'
        'nerd-font-glyphs'
        'perlin-clouds'
        'prismatic-rain'
        'rose-curves'
        'triforce'
        'wave-interference'
        'waveform-spectra'
    )
}
