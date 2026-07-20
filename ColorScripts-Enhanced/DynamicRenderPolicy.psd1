@{
    # These bundled scripts intentionally vary between invocations. Every other bundled
    # colorscript must be statically extractable so ordinary rendering never needs to execute
    # script code. Keep this list explicit: AST complexity alone is not proof of dynamic output.
    DynamicScripts = @(
        # Current-time-driven renderers
        'chrono-tilt'
        'complex-lissajous'
        'flower-of-life'
        'fourier-epicycles'
        'julia-morphing'
        'kaleidoscope-mirror'
        'lissajous-harmony'
        'perlin-clouds'
        'rose-curves'
        'wave-interference'

        # Intentionally randomized renderers
        'Galaxy'
        'nerd-font-glyphs'
        'prismatic-rain'
        'triforce'
        'unowns'
        'waveform-spectra'

        # Reports live timing measurements
        'terminal-benchmark'
    )
}
