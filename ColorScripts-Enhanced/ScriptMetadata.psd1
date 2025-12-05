@{
    # Script Categories
    Categories   = @{
        Geometric       = @(
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

        Nature          = @(
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

        Artistic        = @(
            'kaleidoscope',
            'rainbow-waves',
            'prismatic-rain',
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
            'cyclone-vortex',
            'city-neon'
        )

        Gaming          = @(
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

        # NOTE: This category is intentionally empty by default so you can
        # paste your full list of Pokémon colorscript basenames here without
        # touching the rest of the metadata structure.
        #
        # How to use:
        #   - Put script names here WITHOUT the .ps1 extension
        #   - One name per line, wrapped in single quotes and ending with a comma
        #   - Example:
        #       'pikachu',
        #       'pikachu-shiny',
        #       'charizard',
        #       'charizard-mega-x',
        #       'charizard-mega-y',
        #       ... etc ...
        #
        # After editing this list, reload the module in any open sessions:
        #   Import-Module ColorScripts-Enhanced -Force
        #
        # Once populated, you can use:
        #   Show-ColorScript -ExcludePokemon
        #   Show-ColorScript -Category Pokemon
        #   Get-ColorScriptList -Category Pokemon
        Pokemon         = @(
            'abomasnow',
            'abomasnow-mega',
            'abra',
            'absol',
            'absol-mega',
            'accelgor',
            'aegislash',
            'aegislash-blade',
            'aerodactyl',
            'aerodactyl-mega',
            'aggron',
            'aggron-mega',
            'aipom',
            'alakazam',
            'alakazam-mega',
            'alcremie',
            'alcremie-caramel-swirl-berry',
            'alcremie-caramel-swirl-clover',
            'alcremie-caramel-swirl-flower',
            'alcremie-caramel-swirl-love',
            'alcremie-caramel-swirl-plain',
            'alcremie-caramel-swirl-ribbon',
            'alcremie-caramel-swirl-star',
            'alcremie-caramel-swirl-strawberry',
            'alcremie-gmax',
            'alcremie-lemon-cream-berry',
            'alcremie-lemon-cream-clover',
            'alcremie-lemon-cream-flower',
            'alcremie-lemon-cream-love',
            'alcremie-lemon-cream-plain',
            'alcremie-lemon-cream-ribbon',
            'alcremie-lemon-cream-star',
            'alcremie-lemon-cream-strawberry',
            'alcremie-matcha-cream-berry',
            'alcremie-matcha-cream-clover',
            'alcremie-matcha-cream-flower',
            'alcremie-matcha-cream-love',
            'alcremie-matcha-cream-plain',
            'alcremie-matcha-cream-ribbon',
            'alcremie-matcha-cream-star',
            'alcremie-matcha-cream-strawberry',
            'alcremie-mint-cream-berry',
            'alcremie-mint-cream-clover',
            'alcremie-mint-cream-flower',
            'alcremie-mint-cream-love',
            'alcremie-mint-cream-plain',
            'alcremie-mint-cream-ribbon',
            'alcremie-mint-cream-star',
            'alcremie-mint-cream-strawberry',
            'alcremie-rainbow-swirl-berry',
            'alcremie-rainbow-swirl-clover',
            'alcremie-rainbow-swirl-flower',
            'alcremie-rainbow-swirl-love',
            'alcremie-rainbow-swirl-plain',
            'alcremie-rainbow-swirl-ribbon',
            'alcremie-rainbow-swirl-star',
            'alcremie-rainbow-swirl-strawberry',
            'alcremie-ruby-cream-berry',
            'alcremie-ruby-cream-clover',
            'alcremie-ruby-cream-flower',
            'alcremie-ruby-cream-love',
            'alcremie-ruby-cream-plain',
            'alcremie-ruby-cream-ribbon',
            'alcremie-ruby-cream-star',
            'alcremie-ruby-cream-strawberry',
            'alcremie-ruby-swirl-berry',
            'alcremie-ruby-swirl-clover',
            'alcremie-ruby-swirl-flower',
            'alcremie-ruby-swirl-love',
            'alcremie-ruby-swirl-plain',
            'alcremie-ruby-swirl-ribbon',
            'alcremie-ruby-swirl-star',
            'alcremie-ruby-swirl-strawberry',
            'alcremie-salted-cream-berry',
            'alcremie-salted-cream-clover',
            'alcremie-salted-cream-flower',
            'alcremie-salted-cream-love',
            'alcremie-salted-cream-plain',
            'alcremie-salted-cream-ribbon',
            'alcremie-salted-cream-star',
            'alcremie-salted-cream-strawberry',
            'alcremie-vanilla-cream-berry',
            'alcremie-vanilla-cream-clover',
            'alcremie-vanilla-cream-flower',
            'alcremie-vanilla-cream-love',
            'alcremie-vanilla-cream-plain',
            'alcremie-vanilla-cream-ribbon',
            'alcremie-vanilla-cream-star',
            'alcremie-vanilla-cream-strawberry',
            'alomomola',
            'altaria',
            'altaria-mega',
            'amaura',
            'ambipom',
            'amoonguss',
            'ampharos',
            'ampharos-mega',
            'anorith',
            'appletun',
            'applin',
            'araquanid',
            'arbok',
            'arcanine',
            'arcanine-hisui',
            'arcanine-hisui-noble',
            'arceus',
            'arceus-bug',
            'arceus-dark',
            'arceus-dragon',
            'arceus-electric',
            'arceus-fairy',
            'arceus-fighting',
            'arceus-fire',
            'arceus-flying',
            'arceus-ghost',
            'arceus-grass',
            'arceus-ground',
            'arceus-ice',
            'arceus-poison',
            'arceus-psychic',
            'arceus-rock',
            'arceus-steel',
            'arceus-unknown',
            'arceus-water',
            'archen',
            'archeops',
            'arctovish',
            'arctozolt',
            'ariados',
            'armaldo',
            'aromatisse',
            'aron',
            'arrokuda',
            'articuno',
            'articuno-galar',
            'audino',
            'audino-mega',
            'aurorus',
            'avalugg',
            'avalugg-hisui',
            'avalugg-hisui-noble',
            'axew',
            'azelf',
            'azumarill',
            'azurill',
            'bagon',
            'baltoy',
            'banette',
            'banette-mega',
            'barbaracle',
            'barboach',
            'barraskewda',
            'basculegion',
            'basculin',
            'basculin-blue-striped',
            'basculin-white-striped',
            'bastiodon',
            'bayleef',
            'beartic',
            'beautifly',
            'beedrill',
            'beedrill-mega',
            'beheeyem',
            'beldum',
            'bellossom',
            'bellsprout',
            'bergmite',
            'bewear',
            'bibarel',
            'bidoof',
            'binacle',
            'bisharp',
            'blacephalon',
            'blastoise',
            'blastoise-gmax',
            'blastoise-mega',
            'blaziken',
            'blaziken-mega',
            'blipbug',
            'blissey',
            'blitzle',
            'boldore',
            'boltund',
            'bonsly',
            'bouffalant',
            'bounsweet',
            'braixen',
            'braviary',
            'braviary-hisui',
            'breloom',
            'brionne',
            'bronzong',
            'bronzor',
            'bruxish',
            'budew',
            'buizel',
            'bulbasaur',
            'buneary',
            'bunnelby',
            'burmy',
            'burmy-sandy',
            'burmy-trash',
            'butterfree',
            'butterfree-gmax',
            'buzzwole',
            'cacnea',
            'cacturne',
            'calyrex',
            'calyrex-ice-rider',
            'calyrex-shadow-rider',
            'camerupt',
            'camerupt-mega',
            'carbink',
            'carkol',
            'carnivine',
            'carracosta',
            'carvanha',
            'cascoon',
            'castform',
            'castform-rainy',
            'castform-snowy',
            'castform-sunny',
            'caterpie',
            'celebi',
            'celesteela',
            'centiskorch',
            'centiskorch-gmax',
            'chandelure',
            'chansey',
            'charizard',
            'charizard-gmax',
            'charizard-mega-x',
            'charizard-mega-y',
            'charjabug',
            'charmander',
            'charmeleon',
            'chatot',
            'cherrim',
            'cherrim-sunshine',
            'cherubi',
            'chesnaught',
            'chespin',
            'chewtle',
            'chikorita',
            'chimchar',
            'chimecho',
            'chinchou',
            'chingling',
            'cinccino',
            'cinderace',
            'cinderace-gmax',
            'clamperl',
            'clauncher',
            'clawitzer',
            'claydol',
            'clefable',
            'clefairy',
            'cleffa',
            'clobbopus',
            'cloyster',
            'coalossal',
            'coalossal-gmax',
            'cobalion',
            'cofagrigus',
            'combee',
            'combusken',
            'comfey',
            'conkeldurr',
            'copperajah',
            'copperajah-gmax',
            'corphish',
            'corsola',
            'corsola-galar',
            'corviknight',
            'corviknight-gmax',
            'corvisquire',
            'cosmoem',
            'cosmog',
            'cottonee',
            'crabominable',
            'crabrawler',
            'cradily',
            'cramorant',
            'cramorant-gorging',
            'cramorant-gulping',
            'cranidos',
            'crawdaunt',
            'cresselia',
            'croagunk',
            'crobat',
            'croconaw',
            'crustle',
            'cryogonal',
            'cubchoo',
            'cubone',
            'cufant',
            'cursola',
            'cutiefly',
            'cyndaquil',
            'darkrai',
            'darmanitan',
            'darmanitan-galar',
            'darmanitan-galar-zen',
            'darmanitan-zen',
            'dartrix',
            'darumaka',
            'darumaka-galar',
            'decidueye',
            'decidueye-hisui',
            'dedenne',
            'deerling',
            'deerling-autumn',
            'deerling-summer',
            'deerling-winter',
            'deino',
            'delcatty',
            'delibird',
            'delphox',
            'deoxys',
            'deoxys-attack',
            'deoxys-defense',
            'deoxys-speed',
            'dewgong',
            'dewott',
            'dewpider',
            'dhelmise',
            'dialga',
            'dialga-origin',
            'diancie',
            'diancie-mega',
            'diggersby',
            'diglett',
            'diglett-alola',
            'ditto',
            'dodrio',
            'doduo',
            'donphan',
            'dottler',
            'doublade',
            'dracovish',
            'dracozolt',
            'dragalge',
            'dragapult',
            'dragonair',
            'dragonite',
            'drakloak',
            'drampa',
            'drapion',
            'dratini',
            'drednaw',
            'drednaw-gmax',
            'dreepy',
            'drifblim',
            'drifloon',
            'drilbur',
            'drizzile',
            'drowzee',
            'druddigon',
            'dubwool',
            'ducklett',
            'dugtrio',
            'dugtrio-alola',
            'dunsparce',
            'duosion',
            'duraludon',
            'duraludon-gmax',
            'durant',
            'dusclops',
            'dusknoir',
            'duskull',
            'dustox',
            'dwebble',
            'eelektrik',
            'eelektross',
            'eevee',
            'eevee-gmax',
            'eevee-starter',
            'eiscue',
            'eiscue-noice',
            'ekans',
            'eldegoss',
            'electabuzz',
            'electivire',
            'electrike',
            'electrode',
            'electrode-hisui',
            'electrode-hisui-noble',
            'elekid',
            'elgyem',
            'emboar',
            'emolga',
            'empoleon',
            'enamorus',
            'enamorus-therian',
            'entei',
            'escavalier',
            'espeon',
            'espurr',
            'eternatus',
            'eternatus-eternamax',
            'excadrill',
            'exeggcute',
            'exeggutor',
            'exeggutor-alola',
            'exploud',
            'falinks',
            'farfetchd',
            'farfetchd-galar',
            'fearow',
            'feebas',
            'fennekin',
            'feraligatr',
            'ferroseed',
            'ferrothorn',
            'finneon',
            'flaaffy',
            'flabebe',
            'flabebe-blue',
            'flabebe-orange',
            'flabebe-white',
            'flabebe-yellow',
            'flapple',
            'flapple-gmax',
            'flareon',
            'fletchinder',
            'fletchling',
            'floatzel',
            'floette',
            'floette-blue',
            'floette-eternal',
            'floette-orange',
            'floette-white',
            'floette-yellow',
            'florges',
            'florges-blue',
            'florges-orange',
            'florges-white',
            'florges-yellow',
            'flygon',
            'fomantis',
            'foongus',
            'forretress',
            'fraxure',
            'frillish',
            'froakie',
            'frogadier',
            'froslass',
            'frosmoth',
            'furfrou',
            'furfrou-dandy',
            'furfrou-debutante',
            'furfrou-diamond',
            'furfrou-heart',
            'furfrou-kabuki',
            'furfrou-la-reine',
            'furfrou-matron',
            'furfrou-pharaoh',
            'furfrou-star',
            'furret',
            'gabite',
            'gallade',
            'gallade-mega',
            'galvantula',
            'garbodor',
            'garbodor-gmax',
            'garchomp',
            'garchomp-mega',
            'gardevoir',
            'gardevoir-mega',
            'gastly',
            'gastrodon',
            'gastrodon-east',
            'genesect',
            'genesect-burn',
            'genesect-chill',
            'genesect-douse',
            'genesect-shock',
            'gengar',
            'gengar-gmax',
            'gengar-mega',
            'geodude',
            'geodude-alola',
            'gible',
            'gigalith',
            'girafarig',
            'giratina',
            'giratina-origin',
            'glaceon',
            'glalie',
            'glalie-mega',
            'glameow',
            'glastrier',
            'gligar',
            'gliscor',
            'gloom',
            'gogoat',
            'golbat',
            'goldeen',
            'golduck',
            'golem',
            'golem-alola',
            'golett',
            'golisopod',
            'golurk',
            'goodra',
            'goodra-hisui',
            'goomy',
            'gorebyss',
            'gossifleur',
            'gothita',
            'gothitelle',
            'gothorita',
            'gourgeist',
            'granbull',
            'grapploct',
            'graveler',
            'graveler-alola',
            'greedent',
            'greninja',
            'greninja-ash',
            'grimer',
            'grimer-alola',
            'grimmsnarl',
            'grimmsnarl-gmax',
            'grookey',
            'grotle',
            'groudon',
            'groudon-primal',
            'grovyle',
            'growlithe',
            'growlithe-hisui',
            'grubbin',
            'grumpig',
            'gulpin',
            'gumshoos',
            'gurdurr',
            'guzzlord',
            'gyarados',
            'gyarados-mega',
            'hakamo-o',
            'happiny',
            'hariyama',
            'hatenna',
            'hatterene',
            'hatterene-gmax',
            'hattrem',
            'haunter',
            'hawlucha',
            'haxorus',
            'heatmor',
            'heatran',
            'heliolisk',
            'helioptile',
            'heracross',
            'heracross-mega',
            'herdier',
            'hippopotas',
            'hippowdon',
            'hitmonchan',
            'hitmonlee',
            'hitmontop',
            'ho-oh',
            'honchkrow',
            'honedge',
            'hoopa',
            'hoopa-unbound',
            'hoothoot',
            'hoppip',
            'horsea',
            'houndoom',
            'houndoom-mega',
            'houndour',
            'huntail',
            'hydreigon',
            'hypno',
            'igglybuff',
            'illumise',
            'impidimp',
            'incineroar',
            'indeedee',
            'infernape',
            'inkay',
            'inteleon',
            'inteleon-gmax',
            'ivysaur',
            'jangmo-o',
            'jellicent',
            'jigglypuff',
            'jirachi',
            'jolteon',
            'joltik',
            'jumpluff',
            'jynx',
            'kabuto',
            'kabutops',
            'kadabra',
            'kakuna',
            'kangaskhan',
            'kangaskhan-mega',
            'karrablast',
            'kartana',
            'kecleon',
            'keldeo',
            'keldeo-resolute',
            'kingdra',
            'kingler',
            'kingler-gmax',
            'kirlia',
            'klang',
            'kleavor',
            'kleavor-noble',
            'klefki',
            'klink',
            'klinklang',
            'koffing',
            'komala',
            'kommo-o',
            'krabby',
            'kricketot',
            'kricketune',
            'krokorok',
            'krookodile',
            'kubfu',
            'kyogre',
            'kyogre-primal',
            'kyurem',
            'kyurem-black',
            'kyurem-white',
            'lairon',
            'lampent',
            'landorus',
            'landorus-therian',
            'lanturn',
            'lapras',
            'lapras-gmax',
            'larvesta',
            'larvitar',
            'latias',
            'latias-mega',
            'latios',
            'latios-mega',
            'leafeon',
            'leavanny',
            'ledian',
            'ledyba',
            'lickilicky',
            'lickitung',
            'liepard',
            'lileep',
            'lilligant',
            'lilligant-hisui',
            'lilligant-hisui-noble',
            'lillipup',
            'linoone',
            'linoone-galar',
            'litleo',
            'litten',
            'litwick',
            'lombre',
            'lopunny',
            'lopunny-mega',
            'lotad',
            'loudred',
            'lucario',
            'lucario-mega',
            'ludicolo',
            'lugia',
            'lugia-shadow',
            'lumineon',
            'lunala',
            'lunatone',
            'lurantis',
            'luvdisc',
            'luxio',
            'luxray',
            'lycanroc',
            'lycanroc-dusk',
            'lycanroc-midnight',
            'machamp',
            'machamp-gmax',
            'machoke',
            'machop',
            'magby',
            'magcargo',
            'magearna',
            'magearna-original',
            'magikarp',
            'magmar',
            'magmortar',
            'magnemite',
            'magneton',
            'magnezone',
            'makuhita',
            'malamar',
            'mamoswine',
            'manaphy',
            'mandibuzz',
            'manectric',
            'manectric-mega',
            'mankey',
            'mantine',
            'mantyke',
            'maractus',
            'mareanie',
            'mareep',
            'marill',
            'marowak',
            'marowak-alola',
            'marshadow',
            'marshadow-gen7',
            'marshtomp',
            'masquerain',
            'mawile',
            'mawile-mega',
            'medicham',
            'medicham-mega',
            'meditite',
            'meganium',
            'melmetal',
            'melmetal-gmax',
            'meloetta',
            'meloetta-pirouette',
            'meltan',
            'meowstic',
            'meowth',
            'meowth-alola',
            'meowth-galar',
            'meowth-gmax',
            'mesprit',
            'metagross',
            'metagross-mega',
            'metang',
            'metapod',
            'mew',
            'mewtwo',
            'mewtwo-mega-x',
            'mewtwo-mega-y',
            'mienfoo',
            'mienshao',
            'mightyena',
            'milcery',
            'milotic',
            'miltank',
            'mime-jr',
            'mimikyu',
            'minccino',
            'minior',
            'minior-blue',
            'minior-blue-gen7',
            'minior-green',
            'minior-green-gen7',
            'minior-indigo',
            'minior-indigo-gen7',
            'minior-orange',
            'minior-orange-gen7',
            'minior-red',
            'minior-red-gen7',
            'minior-violet',
            'minior-violet-gen7',
            'minior-yellow',
            'minior-yellow-gen7',
            'minun',
            'misdreavus',
            'mismagius',
            'moltres',
            'moltres-galar',
            'monferno',
            'morelull',
            'morgrem',
            'morpeko',
            'morpeko-hangry',
            'mothim',
            'mr-mime',
            'mr-mime-galar',
            'mr-rime',
            'mudbray',
            'mudkip',
            'mudsdale',
            'muk',
            'muk-alola',
            'munchlax',
            'munna',
            'murkrow',
            'musharna',
            'naganadel',
            'natu',
            'necrozma',
            'necrozma-dawn',
            'necrozma-dusk',
            'necrozma-ultra',
            'nickit',
            'nidoking',
            'nidoqueen',
            'nidoran-f',
            'nidoran-m',
            'nidorina',
            'nidorino',
            'nihilego',
            'nincada',
            'ninetales',
            'ninetales-alola',
            'ninjask',
            'noctowl',
            'noibat',
            'noivern',
            'nosepass',
            'numel',
            'nuzleaf',
            'obstagoon',
            'octillery',
            'oddish',
            'omanyte',
            'omastar',
            'onix',
            'oranguru',
            'orbeetle',
            'orbeetle-gmax',
            'oricorio',
            'oricorio-pau',
            'oricorio-pom-pom',
            'oricorio-sensu',
            'oshawott',
            'overqwil',
            'pachirisu',
            'palkia',
            'palkia-origin',
            'palossand',
            'palpitoad',
            'pancham',
            'pangoro',
            'panpour',
            'pansage',
            'pansear',
            'paras',
            'parasect',
            'passimian',
            'patrat',
            'pawniard',
            'pelipper',
            'perrserker',
            'persian',
            'persian-alola',
            'petilil',
            'phanpy',
            'phantump',
            'pheromosa',
            'phione',
            'pichu',
            'pichu-spiky-eared',
            'pidgeot',
            'pidgeot-mega',
            'pidgeotto',
            'pidgey',
            'pidove',
            'pignite',
            'pikachu',
            'pikachu-alola-cap',
            'pikachu-belle',
            'pikachu-cosplay',
            'pikachu-gmax',
            'pikachu-hoenn-cap',
            'pikachu-kalos-cap',
            'pikachu-libre',
            'pikachu-original-cap',
            'pikachu-partner-cap',
            'pikachu-phd',
            'pikachu-pop-star',
            'pikachu-rock-star',
            'pikachu-sinnoh-cap',
            'pikachu-starter',
            'pikachu-unova-cap',
            'pikachu-world-cap',
            'pikipek',
            'piloswine',
            'pincurchin',
            'pineco',
            'pinsir',
            'pinsir-mega',
            'piplup',
            'plusle',
            'poipole',
            'politoed',
            'poliwag',
            'poliwhirl',
            'poliwrath',
            'polteageist',
            'ponyta',
            'ponyta-galar',
            'poochyena',
            'popplio',
            'porygon',
            'porygon-z',
            'porygon2',
            'primarina',
            'primeape',
            'prinplup',
            'probopass',
            'psyduck',
            'pumpkaboo',
            'pumpkaboo-large',
            'pumpkaboo-small',
            'pumpkaboo-super',
            'pupitar',
            'purrloin',
            'purugly',
            'pyroar',
            'pyukumuku',
            'quagsire',
            'quilava',
            'quilladin',
            'qwilfish',
            'qwilfish-hisui',
            'raboot',
            'raichu',
            'raichu-alola',
            'raikou',
            'ralts',
            'rampardos',
            'rapidash',
            'rapidash-galar',
            'raticate',
            'raticate-alola',
            'rattata',
            'rattata-alola',
            'rayquaza',
            'rayquaza-mega',
            'regice',
            'regidrago',
            'regieleki',
            'regigigas',
            'regirock',
            'registeel',
            'relicanth',
            'remoraid',
            'reshiram',
            'reuniclus',
            'rhydon',
            'rhyhorn',
            'rhyperior',
            'ribombee',
            'rillaboom',
            'rillaboom-gmax',
            'riolu',
            'rockruff',
            'roggenrola',
            'rolycoly',
            'rookidee',
            'roselia',
            'roserade',
            'rotom',
            'rotom-fan',
            'rotom-frost',
            'rotom-heat',
            'rotom-mow',
            'rotom-wash',
            'rowlet',
            'rufflet',
            'runerigus',
            'sableye',
            'sableye-mega',
            'salamence',
            'salamence-mega',
            'salandit',
            'salazzle',
            'samurott',
            'samurott-hisui',
            'sandaconda',
            'sandaconda-gmax',
            'sandile',
            'sandshrew',
            'sandshrew-alola',
            'sandslash',
            'sandslash-alola',
            'sandygast',
            'sawk',
            'sawsbuck',
            'sawsbuck-autumn',
            'sawsbuck-summer',
            'sawsbuck-winter',
            'scatterbug',
            'sceptile',
            'sceptile-mega',
            'scizor',
            'scizor-mega',
            'scolipede',
            'scorbunny',
            'scrafty',
            'scraggy',
            'scyther',
            'seadra',
            'seaking',
            'sealeo',
            'seedot',
            'seel',
            'seismitoad',
            'sentret',
            'serperior',
            'servine',
            'seviper',
            'sewaddle',
            'sharpedo',
            'sharpedo-mega',
            'shaymin',
            'shaymin-sky',
            'shedinja',
            'shelgon',
            'shellder',
            'shellos',
            'shellos-east',
            'shelmet',
            'shieldon',
            'shiftry',
            'shiinotic',
            'shinx',
            'shroomish',
            'shuckle',
            'shuppet',
            'sigilyph',
            'silcoon',
            'silicobra',
            'silvally',
            'silvally-bug',
            'silvally-dark',
            'silvally-dragon',
            'silvally-electric',
            'silvally-fairy',
            'silvally-fighting',
            'silvally-fire',
            'silvally-flying',
            'silvally-ghost',
            'silvally-grass',
            'silvally-ground',
            'silvally-ice',
            'silvally-poison',
            'silvally-psychic',
            'silvally-rock',
            'silvally-steel',
            'silvally-water',
            'simipour',
            'simisage',
            'simisear',
            'sinistea',
            'sirfetchd',
            'sizzlipede',
            'skarmory',
            'skiddo',
            'skiploom',
            'skitty',
            'skorupi',
            'skrelp',
            'skuntank',
            'skwovet',
            'slaking',
            'slakoth',
            'sliggoo',
            'sliggoo-hisui',
            'slowbro',
            'slowbro-galar',
            'slowbro-mega',
            'slowking',
            'slowking-galar',
            'slowpoke',
            'slowpoke-galar',
            'slugma',
            'slurpuff',
            'smeargle',
            'smoochum',
            'sneasel',
            'sneasel-hisui',
            'sneasler',
            'snivy',
            'snom',
            'snorlax',
            'snorlax-gmax',
            'snorunt',
            'snover',
            'snubbull',
            'sobble',
            'solgaleo',
            'solosis',
            'solrock',
            'spearow',
            'spectrier',
            'spewpa',
            'spheal',
            'spinarak',
            'spinda',
            'spinda-blank',
            'spinda-filled',
            'spiritomb',
            'spoink',
            'spritzee',
            'squirtle',
            'stakataka',
            'stantler',
            'staraptor',
            'staravia',
            'starly',
            'starmie',
            'staryu',
            'steelix',
            'steelix-mega',
            'steenee',
            'stonjourner',
            'stoutland',
            'stufful',
            'stunfisk',
            'stunfisk-galar',
            'stunky',
            'sudowoodo',
            'suicune',
            'sunflora',
            'sunkern',
            'surskit',
            'swablu',
            'swadloon',
            'swalot',
            'swampert',
            'swampert-mega',
            'swanna',
            'swellow',
            'swinub',
            'swirlix',
            'swoobat',
            'sylveon',
            'taillow',
            'talonflame',
            'tangela',
            'tangrowth',
            'tapu-bulu',
            'tapu-fini',
            'tapu-koko',
            'tapu-lele',
            'tauros',
            'teddiursa',
            'tentacool',
            'tentacruel',
            'tepig',
            'terrakion',
            'thievul',
            'throh',
            'thundurus',
            'thundurus-therian',
            'thwackey',
            'timburr',
            'tirtouga',
            'togedemaru',
            'togekiss',
            'togepi',
            'togetic',
            'torchic',
            'torkoal',
            'tornadus',
            'tornadus-therian',
            'torracat',
            'torterra',
            'totodile',
            'toucannon',
            'toxapex',
            'toxel',
            'toxicroak',
            'toxtricity',
            'toxtricity-gmax',
            'toxtricity-low-key',
            'tranquill',
            'trapinch',
            'treecko',
            'trevenant',
            'tropius',
            'trubbish',
            'trumbeak',
            'tsareena',
            'turtonator',
            'turtwig',
            'tympole',
            'tynamo',
            'type-null',
            'typhlosion',
            'typhlosion-hisui',
            'tyranitar',
            'tyranitar-mega',
            'tyrantrum',
            'tyrogue',
            'tyrunt',
            'umbreon',
            'unfezant',
            'unown',
            'unown-b',
            'unown-c',
            'unown-d',
            'unown-e',
            'unown-exclamation',
            'unown-f',
            'unown-g',
            'unown-h',
            'unown-i',
            'unown-j',
            'unown-k',
            'unown-l',
            'unown-m',
            'unown-n',
            'unown-o',
            'unown-p',
            'unown-q',
            'unown-question',
            'unown-r',
            'unown-s',
            'unown-t',
            'unown-u',
            'unown-v',
            'unown-w',
            'unown-x',
            'unown-y',
            'unown-z',
            'ursaluna',
            'ursaring',
            'urshifu',
            'urshifu-gmax',
            'urshifu-rapid-strike-gmax',
            'uxie',
            'vanillish',
            'vanillite',
            'vanilluxe',
            'vaporeon',
            'venipede',
            'venomoth',
            'venonat',
            'venusaur',
            'venusaur-gmax',
            'venusaur-mega',
            'vespiquen',
            'vibrava',
            'victini',
            'victreebel',
            'vigoroth',
            'vikavolt',
            'vileplume',
            'virizion',
            'vivillon',
            'vivillon-archipelago',
            'vivillon-continental',
            'vivillon-elegant',
            'vivillon-fancy',
            'vivillon-garden',
            'vivillon-high-plains',
            'vivillon-icy-snow',
            'vivillon-jungle',
            'vivillon-marine',
            'vivillon-modern',
            'vivillon-monsoon',
            'vivillon-ocean',
            'vivillon-poke-ball',
            'vivillon-polar',
            'vivillon-river',
            'vivillon-sandstorm',
            'vivillon-savanna',
            'vivillon-sun',
            'vivillon-tundra',
            'volbeat',
            'volcanion',
            'volcarona',
            'voltorb',
            'voltorb-hisui',
            'vullaby',
            'vulpix',
            'vulpix-alola',
            'wailmer',
            'wailord',
            'walrein',
            'wartortle',
            'watchog',
            'weavile',
            'weedle',
            'weepinbell',
            'weezing',
            'weezing-galar',
            'whimsicott',
            'whirlipede',
            'whiscash',
            'whismur',
            'wigglytuff',
            'wimpod',
            'wingull',
            'wishiwashi',
            'wishiwashi-school',
            'wobbuffet',
            'woobat',
            'wooloo',
            'wooper',
            'wormadam',
            'wormadam-sandy',
            'wormadam-trash',
            'wurmple',
            'wynaut',
            'wyrdeer',
            'xatu',
            'xerneas',
            'xerneas-active',
            'xurkitree',
            'yamask',
            'yamask-galar',
            'yamper',
            'yanma',
            'yanmega',
            'yungoos',
            'yveltal',
            'zacian',
            'zacian-crowned',
            'zamazenta',
            'zamazenta-crowned',
            'zangoose',
            'zapdos',
            'zapdos-galar',
            'zarude',
            'zarude-dada',
            'zebstrika',
            'zekrom',
            'zeraora',
            'zigzagoon',
            'zigzagoon-galar',
            'zoroark',
            'zoroark-hisui',
            'zorua',
            'zorua-hisui',
            'zubat',
            'zweilous',
            'zygarde',
            'zygarde-10',
            'zygarde-complete'
        )

        ShinyPokemon         = @(
            "abomasnow-mega-shiny",
            "abomasnow-shiny",
            "abra-shiny",
            "absol-mega-shiny",
            "absol-shiny",
            "accelgor-shiny",
            "aegislash-blade-shiny",
            "aegislash-shiny",
            "aerodactyl-mega-shiny",
            "aerodactyl-shiny",
            "aggron-mega-shiny",
            "aggron-shiny",
            "aipom-shiny",
            "alakazam-mega-shiny",
            "alakazam-shiny",
            "alcremie-caramel-swirl-berry-shiny",
            "alcremie-caramel-swirl-clover-shiny",
            "alcremie-caramel-swirl-flower-shiny",
            "alcremie-caramel-swirl-love-shiny",
            "alcremie-caramel-swirl-plain-shiny",
            "alcremie-caramel-swirl-ribbon-shiny",
            "alcremie-caramel-swirl-star-shiny",
            "alcremie-caramel-swirl-strawberry-shiny",
            "alcremie-gmax-shiny",
            "alcremie-lemon-cream-berry-shiny",
            "alcremie-lemon-cream-clover-shiny",
            "alcremie-lemon-cream-flower-shiny",
            "alcremie-lemon-cream-love-shiny",
            "alcremie-lemon-cream-plain-shiny",
            "alcremie-lemon-cream-ribbon-shiny",
            "alcremie-lemon-cream-star-shiny",
            "alcremie-lemon-cream-strawberry-shiny",
            "alcremie-matcha-cream-berry-shiny",
            "alcremie-matcha-cream-clover-shiny",
            "alcremie-matcha-cream-flower-shiny",
            "alcremie-matcha-cream-love-shiny",
            "alcremie-matcha-cream-plain-shiny",
            "alcremie-matcha-cream-ribbon-shiny",
            "alcremie-matcha-cream-star-shiny",
            "alcremie-matcha-cream-strawberry-shiny",
            "alcremie-mint-cream-berry-shiny",
            "alcremie-mint-cream-clover-shiny",
            "alcremie-mint-cream-flower-shiny",
            "alcremie-mint-cream-love-shiny",
            "alcremie-mint-cream-plain-shiny",
            "alcremie-mint-cream-ribbon-shiny",
            "alcremie-mint-cream-star-shiny",
            "alcremie-mint-cream-strawberry-shiny",
            "alcremie-rainbow-swirl-berry-shiny",
            "alcremie-rainbow-swirl-clover-shiny",
            "alcremie-rainbow-swirl-flower-shiny",
            "alcremie-rainbow-swirl-love-shiny",
            "alcremie-rainbow-swirl-plain-shiny",
            "alcremie-rainbow-swirl-ribbon-shiny",
            "alcremie-rainbow-swirl-star-shiny",
            "alcremie-rainbow-swirl-strawberry-shiny",
            "alcremie-ruby-cream-berry-shiny",
            "alcremie-ruby-cream-clover-shiny",
            "alcremie-ruby-cream-flower-shiny",
            "alcremie-ruby-cream-love-shiny",
            "alcremie-ruby-cream-plain-shiny",
            "alcremie-ruby-cream-ribbon-shiny",
            "alcremie-ruby-cream-star-shiny",
            "alcremie-ruby-cream-strawberry-shiny",
            "alcremie-ruby-swirl-berry-shiny",
            "alcremie-ruby-swirl-clover-shiny",
            "alcremie-ruby-swirl-flower-shiny",
            "alcremie-ruby-swirl-love-shiny",
            "alcremie-ruby-swirl-plain-shiny",
            "alcremie-ruby-swirl-ribbon-shiny",
            "alcremie-ruby-swirl-star-shiny",
            "alcremie-ruby-swirl-strawberry-shiny",
            "alcremie-salted-cream-berry-shiny",
            "alcremie-salted-cream-clover-shiny",
            "alcremie-salted-cream-flower-shiny",
            "alcremie-salted-cream-love-shiny",
            "alcremie-salted-cream-plain-shiny",
            "alcremie-salted-cream-ribbon-shiny",
            "alcremie-salted-cream-star-shiny",
            "alcremie-salted-cream-strawberry-shiny",
            "alcremie-shiny",
            "alcremie-vanilla-cream-berry-shiny",
            "alcremie-vanilla-cream-clover-shiny",
            "alcremie-vanilla-cream-flower-shiny",
            "alcremie-vanilla-cream-love-shiny",
            "alcremie-vanilla-cream-plain-shiny",
            "alcremie-vanilla-cream-ribbon-shiny",
            "alcremie-vanilla-cream-star-shiny",
            "alcremie-vanilla-cream-strawberry-shiny",
            "alomomola-shiny",
            "altaria-mega-shiny",
            "altaria-shiny",
            "amaura-shiny",
            "ambipom-shiny",
            "amoonguss-shiny",
            "ampharos-mega-shiny",
            "ampharos-shiny",
            "anorith-shiny",
            "appletun-shiny",
            "applin-shiny",
            "araquanid-shiny",
            "arbok-shiny",
            "arcanine-hisui-noble-shiny",
            "arcanine-hisui-shiny",
            "arcanine-shiny",
            "arceus-bug-shiny",
            "arceus-dark-shiny",
            "arceus-dragon-shiny",
            "arceus-electric-shiny",
            "arceus-fairy-shiny",
            "arceus-fighting-shiny",
            "arceus-fire-shiny",
            "arceus-flying-shiny",
            "arceus-ghost-shiny",
            "arceus-grass-shiny",
            "arceus-ground-shiny",
            "arceus-ice-shiny",
            "arceus-poison-shiny",
            "arceus-psychic-shiny",
            "arceus-rock-shiny",
            "arceus-shiny",
            "arceus-steel-shiny",
            "arceus-unknown-shiny",
            "arceus-water-shiny",
            "archen-shiny",
            "archeops-shiny",
            "arctovish-shiny",
            "arctozolt-shiny",
            "ariados-shiny",
            "armaldo-shiny",
            "aromatisse-shiny",
            "aron-shiny",
            "arrokuda-shiny",
            "articuno-galar-shiny",
            "articuno-shiny",
            "audino-mega-shiny",
            "audino-shiny",
            "aurorus-shiny",
            "avalugg-hisui-noble-shiny",
            "avalugg-hisui-shiny",
            "avalugg-shiny",
            "axew-shiny",
            "azelf-shiny",
            "azumarill-shiny",
            "azurill-shiny",
            "bagon-shiny",
            "baltoy-shiny",
            "banette-mega-shiny",
            "banette-shiny",
            "barbaracle-shiny",
            "barboach-shiny",
            "barraskewda-shiny",
            "basculegion-shiny",
            "basculin-blue-striped-shiny",
            "basculin-shiny",
            "basculin-white-striped-shiny",
            "bastiodon-shiny",
            "bayleef-shiny",
            "beartic-shiny",
            "beautifly-shiny",
            "beedrill-mega-shiny",
            "beedrill-shiny",
            "beheeyem-shiny",
            "beldum-shiny",
            "bellossom-shiny",
            "bellsprout-shiny",
            "bergmite-shiny",
            "bewear-shiny",
            "bibarel-shiny",
            "bidoof-shiny",
            "binacle-shiny",
            "bisharp-shiny",
            "blacephalon-shiny",
            "blastoise-gmax-shiny",
            "blastoise-mega-shiny",
            "blastoise-shiny",
            "blaziken-mega-shiny",
            "blaziken-shiny",
            "blipbug-shiny",
            "blissey-shiny",
            "blitzle-shiny",
            "boldore-shiny",
            "boltund-shiny",
            "bonsly-shiny",
            "bouffalant-shiny",
            "bounsweet-shiny",
            "braixen-shiny",
            "braviary-hisui-shiny",
            "braviary-shiny",
            "breloom-shiny",
            "brionne-shiny",
            "bronzong-shiny",
            "bronzor-shiny",
            "bruxish-shiny",
            "budew-shiny",
            "buizel-shiny",
            "bulbasaur-shiny",
            "buneary-shiny",
            "bunnelby-shiny",
            "burmy-sandy-shiny",
            "burmy-shiny",
            "burmy-trash-shiny",
            "butterfree-gmax-shiny",
            "butterfree-shiny",
            "buzzwole-shiny",
            "cacnea-shiny",
            "cacturne-shiny",
            "calyrex-ice-rider-shiny",
            "calyrex-shadow-rider-shiny",
            "calyrex-shiny",
            "camerupt-mega-shiny",
            "camerupt-shiny",
            "carbink-shiny",
            "carkol-shiny",
            "carnivine-shiny",
            "carracosta-shiny",
            "carvanha-shiny",
            "cascoon-shiny",
            "castform-rainy-shiny",
            "castform-shiny",
            "castform-snowy-shiny",
            "castform-sunny-shiny",
            "caterpie-shiny",
            "celebi-shiny",
            "celesteela-shiny",
            "centiskorch-gmax-shiny",
            "centiskorch-shiny",
            "chandelure-shiny",
            "chansey-shiny",
            "charizard-gmax-shiny",
            "charizard-mega-x-shiny",
            "charizard-mega-y-shiny",
            "charizard-shiny",
            "charjabug-shiny",
            "charmander-shiny",
            "charmeleon-shiny",
            "chatot-shiny",
            "cherrim-shiny",
            "cherrim-sunshine-shiny",
            "cherubi-shiny",
            "chesnaught-shiny",
            "chespin-shiny",
            "chewtle-shiny",
            "chikorita-shiny",
            "chimchar-shiny",
            "chimecho-shiny",
            "chinchou-shiny",
            "chingling-shiny",
            "cinccino-shiny",
            "cinderace-gmax-shiny",
            "cinderace-shiny",
            "clamperl-shiny",
            "clauncher-shiny",
            "clawitzer-shiny",
            "claydol-shiny",
            "clefable-shiny",
            "clefairy-shiny",
            "cleffa-shiny",
            "clobbopus-shiny",
            "cloyster-shiny",
            "coalossal-gmax-shiny",
            "coalossal-shiny",
            "cobalion-shiny",
            "cofagrigus-shiny",
            "combee-shiny",
            "combusken-shiny",
            "comfey-shiny",
            "conkeldurr-shiny",
            "copperajah-gmax-shiny",
            "copperajah-shiny",
            "corphish-shiny",
            "corsola-galar-shiny",
            "corsola-shiny",
            "corviknight-gmax-shiny",
            "corviknight-shiny",
            "corvisquire-shiny",
            "cosmoem-shiny",
            "cosmog-shiny",
            "cottonee-shiny",
            "crabominable-shiny",
            "crabrawler-shiny",
            "cradily-shiny",
            "cramorant-gorging-shiny",
            "cramorant-gulping-shiny",
            "cramorant-shiny",
            "cranidos-shiny",
            "crawdaunt-shiny",
            "cresselia-shiny",
            "croagunk-shiny",
            "crobat-shiny",
            "croconaw-shiny",
            "crustle-shiny",
            "cryogonal-shiny",
            "cubchoo-shiny",
            "cubone-shiny",
            "cufant-shiny",
            "cursola-shiny",
            "cutiefly-shiny",
            "cyndaquil-shiny",
            "darkrai-shiny",
            "darmanitan-galar-shiny",
            "darmanitan-galar-zen-shiny",
            "darmanitan-shiny",
            "darmanitan-zen-shiny",
            "dartrix-shiny",
            "darumaka-galar-shiny",
            "darumaka-shiny",
            "decidueye-hisui-shiny",
            "decidueye-shiny",
            "dedenne-shiny",
            "deerling-autumn-shiny",
            "deerling-shiny",
            "deerling-summer-shiny",
            "deerling-winter-shiny",
            "deino-shiny",
            "delcatty-shiny",
            "delibird-shiny",
            "delphox-shiny",
            "deoxys-attack-shiny",
            "deoxys-defense-shiny",
            "deoxys-shiny",
            "deoxys-speed-shiny",
            "dewgong-shiny",
            "dewott-shiny",
            "dewpider-shiny",
            "dhelmise-shiny",
            "dialga-origin-shiny",
            "dialga-shiny",
            "diancie-mega-shiny",
            "diancie-shiny",
            "diggersby-shiny",
            "diglett-alola-shiny",
            "diglett-shiny",
            "ditto-shiny",
            "dodrio-shiny",
            "doduo-shiny",
            "donphan-shiny",
            "dottler-shiny",
            "doublade-shiny",
            "dracovish-shiny",
            "dracozolt-shiny",
            "dragalge-shiny",
            "dragapult-shiny",
            "dragonair-shiny",
            "dragonite-shiny",
            "drakloak-shiny",
            "drampa-shiny",
            "drapion-shiny",
            "dratini-shiny",
            "drednaw-gmax-shiny",
            "drednaw-shiny",
            "dreepy-shiny",
            "drifblim-shiny",
            "drifloon-shiny",
            "drilbur-shiny",
            "drizzile-shiny",
            "drowzee-shiny",
            "druddigon-shiny",
            "dubwool-shiny",
            "ducklett-shiny",
            "dugtrio-alola-shiny",
            "dugtrio-shiny",
            "dunsparce-shiny",
            "duosion-shiny",
            "duraludon-gmax-shiny",
            "duraludon-shiny",
            "durant-shiny",
            "dusclops-shiny",
            "dusknoir-shiny",
            "duskull-shiny",
            "dustox-shiny",
            "dwebble-shiny",
            "eelektrik-shiny",
            "eelektross-shiny",
            "eevee-gmax-shiny",
            "eevee-shiny",
            "eevee-starter-shiny",
            "eiscue-noice-shiny",
            "eiscue-shiny",
            "ekans-shiny",
            "eldegoss-shiny",
            "electabuzz-shiny",
            "electivire-shiny",
            "electrike-shiny",
            "electrode-hisui-noble-shiny",
            "electrode-hisui-shiny",
            "electrode-shiny",
            "elekid-shiny",
            "elgyem-shiny",
            "emboar-shiny",
            "emolga-shiny",
            "empoleon-shiny",
            "enamorus-shiny",
            "enamorus-therian-shiny",
            "entei-shiny",
            "escavalier-shiny",
            "espeon-shiny",
            "espurr-shiny",
            "eternatus-eternamax-shiny",
            "eternatus-shiny",
            "excadrill-shiny",
            "exeggcute-shiny",
            "exeggutor-alola-shiny",
            "exeggutor-shiny",
            "exploud-shiny",
            "falinks-shiny",
            "farfetchd-galar-shiny",
            "farfetchd-shiny",
            "fearow-shiny",
            "feebas-shiny",
            "fennekin-shiny",
            "feraligatr-shiny",
            "ferroseed-shiny",
            "ferrothorn-shiny",
            "finneon-shiny",
            "flaaffy-shiny",
            "flabebe-blue-shiny",
            "flabebe-orange-shiny",
            "flabebe-shiny",
            "flabebe-white-shiny",
            "flabebe-yellow-shiny",
            "flapple-gmax-shiny",
            "flapple-shiny",
            "flareon-shiny",
            "fletchinder-shiny",
            "fletchling-shiny",
            "floatzel-shiny",
            "floette-blue-shiny",
            "floette-eternal-shiny",
            "floette-orange-shiny",
            "floette-shiny",
            "floette-white-shiny",
            "floette-yellow-shiny",
            "florges-blue-shiny",
            "florges-orange-shiny",
            "florges-shiny",
            "florges-white-shiny",
            "florges-yellow-shiny",
            "flygon-shiny",
            "fomantis-shiny",
            "foongus-shiny",
            "forretress-shiny",
            "fraxure-shiny",
            "frillish-shiny",
            "froakie-shiny",
            "frogadier-shiny",
            "froslass-shiny",
            "frosmoth-shiny",
            "furfrou-dandy-shiny",
            "furfrou-debutante-shiny",
            "furfrou-diamond-shiny",
            "furfrou-heart-shiny",
            "furfrou-kabuki-shiny",
            "furfrou-la-reine-shiny",
            "furfrou-matron-shiny",
            "furfrou-pharaoh-shiny",
            "furfrou-shiny",
            "furfrou-star-shiny",
            "furret-shiny",
            "gabite-shiny",
            "gallade-mega-shiny",
            "gallade-shiny",
            "galvantula-shiny",
            "garbodor-gmax-shiny",
            "garbodor-shiny",
            "garchomp-mega-shiny",
            "garchomp-shiny",
            "gardevoir-mega-shiny",
            "gardevoir-shiny",
            "gastly-shiny",
            "gastrodon-east-shiny",
            "gastrodon-shiny",
            "genesect-burn-shiny",
            "genesect-chill-shiny",
            "genesect-douse-shiny",
            "genesect-shiny",
            "genesect-shock-shiny",
            "gengar-gmax-shiny",
            "gengar-mega-shiny",
            "gengar-shiny",
            "geodude-alola-shiny",
            "geodude-shiny",
            "gible-shiny",
            "gigalith-shiny",
            "girafarig-shiny",
            "giratina-origin-shiny",
            "giratina-shiny",
            "glaceon-shiny",
            "glalie-mega-shiny",
            "glalie-shiny",
            "glameow-shiny",
            "glastrier-shiny",
            "gligar-shiny",
            "gliscor-shiny",
            "gloom-shiny",
            "gogoat-shiny",
            "golbat-shiny",
            "goldeen-shiny",
            "golduck-shiny",
            "golem-alola-shiny",
            "golem-shiny",
            "golett-shiny",
            "golisopod-shiny",
            "golurk-shiny",
            "goodra-hisui-shiny",
            "goodra-shiny",
            "goomy-shiny",
            "gorebyss-shiny",
            "gossifleur-shiny",
            "gothita-shiny",
            "gothitelle-shiny",
            "gothorita-shiny",
            "gourgeist-shiny",
            "granbull-shiny",
            "grapploct-shiny",
            "graveler-alola-shiny",
            "graveler-shiny",
            "greedent-shiny",
            "greninja-ash-shiny",
            "greninja-shiny",
            "grimer-alola-shiny",
            "grimer-shiny",
            "grimmsnarl-gmax-shiny",
            "grimmsnarl-shiny",
            "grookey-shiny",
            "grotle-shiny",
            "groudon-primal-shiny",
            "groudon-shiny",
            "grovyle-shiny",
            "growlithe-hisui-shiny",
            "growlithe-shiny",
            "grubbin-shiny",
            "grumpig-shiny",
            "gulpin-shiny",
            "gumshoos-shiny",
            "gurdurr-shiny",
            "guzzlord-shiny",
            "gyarados-mega-shiny",
            "gyarados-shiny",
            "hakamo-o-shiny",
            "happiny-shiny",
            "hariyama-shiny",
            "hatenna-shiny",
            "hatterene-gmax-shiny",
            "hatterene-shiny",
            "hattrem-shiny",
            "haunter-shiny",
            "hawlucha-shiny",
            "haxorus-shiny",
            "heatmor-shiny",
            "heatran-shiny",
            "heliolisk-shiny",
            "helioptile-shiny",
            "heracross-mega-shiny",
            "heracross-shiny",
            "herdier-shiny",
            "hippopotas-shiny",
            "hippowdon-shiny",
            "hitmonchan-shiny",
            "hitmonlee-shiny",
            "hitmontop-shiny",
            "ho-oh-shiny",
            "honchkrow-shiny",
            "honedge-shiny",
            "hoopa-shiny",
            "hoopa-unbound-shiny",
            "hoothoot-shiny",
            "hoppip-shiny",
            "horsea-shiny",
            "houndoom-mega-shiny",
            "houndoom-shiny",
            "houndour-shiny",
            "huntail-shiny",
            "hydreigon-shiny",
            "hypno-shiny",
            "igglybuff-shiny",
            "illumise-shiny",
            "impidimp-shiny",
            "incineroar-shiny",
            "indeedee-shiny",
            "infernape-shiny",
            "inkay-shiny",
            "inteleon-gmax-shiny",
            "inteleon-shiny",
            "ivysaur-shiny",
            "jangmo-o-shiny",
            "jellicent-shiny",
            "jigglypuff-shiny",
            "jirachi-shiny",
            "jolteon-shiny",
            "joltik-shiny",
            "jumpluff-shiny",
            "jynx-shiny",
            "kabuto-shiny",
            "kabutops-shiny",
            "kadabra-shiny",
            "kakuna-shiny",
            "kangaskhan-mega-shiny",
            "kangaskhan-shiny",
            "karrablast-shiny",
            "kartana-shiny",
            "kecleon-shiny",
            "keldeo-resolute-shiny",
            "keldeo-shiny",
            "kingdra-shiny",
            "kingler-gmax-shiny",
            "kingler-shiny",
            "kirlia-shiny",
            "klang-shiny",
            "kleavor-noble-shiny",
            "kleavor-shiny",
            "klefki-shiny",
            "klink-shiny",
            "klinklang-shiny",
            "koffing-shiny",
            "komala-shiny",
            "kommo-o-shiny",
            "krabby-shiny",
            "kricketot-shiny",
            "kricketune-shiny",
            "krokorok-shiny",
            "krookodile-shiny",
            "kubfu-shiny",
            "kyogre-primal-shiny",
            "kyogre-shiny",
            "kyurem-black-shiny",
            "kyurem-shiny",
            "kyurem-white-shiny",
            "lairon-shiny",
            "lampent-shiny",
            "landorus-shiny",
            "landorus-therian-shiny",
            "lanturn-shiny",
            "lapras-gmax-shiny",
            "lapras-shiny",
            "larvesta-shiny",
            "larvitar-shiny",
            "latias-mega-shiny",
            "latias-shiny",
            "latios-mega-shiny",
            "latios-shiny",
            "leafeon-shiny",
            "leavanny-shiny",
            "ledian-shiny",
            "ledyba-shiny",
            "lickilicky-shiny",
            "lickitung-shiny",
            "liepard-shiny",
            "lileep-shiny",
            "lilligant-hisui-noble-shiny",
            "lilligant-hisui-shiny",
            "lilligant-shiny",
            "lillipup-shiny",
            "linoone-galar-shiny",
            "linoone-shiny",
            "litleo-shiny",
            "litten-shiny",
            "litwick-shiny",
            "lombre-shiny",
            "lopunny-mega-shiny",
            "lopunny-shiny",
            "lotad-shiny",
            "loudred-shiny",
            "lucario-mega-shiny",
            "lucario-shiny",
            "ludicolo-shiny",
            "lugia-shadow-shiny",
            "lugia-shiny",
            "lumineon-shiny",
            "lunala-shiny",
            "lunatone-shiny",
            "lurantis-shiny",
            "luvdisc-shiny",
            "luxio-shiny",
            "luxray-shiny",
            "lycanroc-dusk-shiny",
            "lycanroc-midnight-shiny",
            "lycanroc-shiny",
            "machamp-gmax-shiny",
            "machamp-shiny",
            "machoke-shiny",
            "machop-shiny",
            "magby-shiny",
            "magcargo-shiny",
            "magearna-original-shiny",
            "magearna-shiny",
            "magikarp-shiny",
            "magmar-shiny",
            "magmortar-shiny",
            "magnemite-shiny",
            "magneton-shiny",
            "magnezone-shiny",
            "makuhita-shiny",
            "malamar-shiny",
            "mamoswine-shiny",
            "manaphy-shiny",
            "mandibuzz-shiny",
            "manectric-mega-shiny",
            "manectric-shiny",
            "mankey-shiny",
            "mantine-shiny",
            "mantyke-shiny",
            "maractus-shiny",
            "mareanie-shiny",
            "mareep-shiny",
            "marill-shiny",
            "marowak-alola-shiny",
            "marowak-shiny",
            "marshadow-gen7-shiny",
            "marshadow-shiny",
            "marshtomp-shiny",
            "masquerain-shiny",
            "mawile-mega-shiny",
            "mawile-shiny",
            "medicham-mega-shiny",
            "medicham-shiny",
            "meditite-shiny",
            "meganium-shiny",
            "melmetal-gmax-shiny",
            "melmetal-shiny",
            "meloetta-pirouette-shiny",
            "meloetta-shiny",
            "meltan-shiny",
            "meowstic-shiny",
            "meowth-alola-shiny",
            "meowth-galar-shiny",
            "meowth-gmax-shiny",
            "meowth-shiny",
            "mesprit-shiny",
            "metagross-mega-shiny",
            "metagross-shiny",
            "metang-shiny",
            "metapod-shiny",
            "mew-shiny",
            "mewtwo-mega-x-shiny",
            "mewtwo-mega-y-shiny",
            "mewtwo-shiny",
            "mienfoo-shiny",
            "mienshao-shiny",
            "mightyena-shiny",
            "milcery-shiny",
            "milotic-shiny",
            "miltank-shiny",
            "mime-jr-shiny",
            "mimikyu-shiny",
            "minccino-shiny",
            "minior-blue-gen7-shiny",
            "minior-blue-shiny",
            "minior-green-gen7-shiny",
            "minior-green-shiny",
            "minior-indigo-gen7-shiny",
            "minior-indigo-shiny",
            "minior-orange-gen7-shiny",
            "minior-orange-shiny",
            "minior-red-gen7-shiny",
            "minior-red-shiny",
            "minior-shiny",
            "minior-violet-gen7-shiny",
            "minior-violet-shiny",
            "minior-yellow-gen7-shiny",
            "minior-yellow-shiny",
            "minun-shiny",
            "misdreavus-shiny",
            "mismagius-shiny",
            "moltres-galar-shiny",
            "moltres-shiny",
            "monferno-shiny",
            "morelull-shiny",
            "morgrem-shiny",
            "morpeko-hangry-shiny",
            "morpeko-shiny",
            "mothim-shiny",
            "mr-mime-galar-shiny",
            "mr-mime-shiny",
            "mr-rime-shiny",
            "mudbray-shiny",
            "mudkip-shiny",
            "mudsdale-shiny",
            "muk-alola-shiny",
            "muk-shiny",
            "munchlax-shiny",
            "munna-shiny",
            "murkrow-shiny",
            "musharna-shiny",
            "naganadel-shiny",
            "natu-shiny",
            "necrozma-dawn-shiny",
            "necrozma-dusk-shiny",
            "necrozma-shiny",
            "necrozma-ultra-shiny",
            "nickit-shiny",
            "nidoking-shiny",
            "nidoqueen-shiny",
            "nidoran-f-shiny",
            "nidoran-m-shiny",
            "nidorina-shiny",
            "nidorino-shiny",
            "nihilego-shiny",
            "nincada-shiny",
            "ninetales-alola-shiny",
            "ninetales-shiny",
            "ninjask-shiny",
            "noctowl-shiny",
            "noibat-shiny",
            "noivern-shiny",
            "nosepass-shiny",
            "numel-shiny",
            "nuzleaf-shiny",
            "obstagoon-shiny",
            "octillery-shiny",
            "oddish-shiny",
            "omanyte-shiny",
            "omastar-shiny",
            "onix-shiny",
            "oranguru-shiny",
            "orbeetle-gmax-shiny",
            "orbeetle-shiny",
            "oricorio-pau-shiny",
            "oricorio-pom-pom-shiny",
            "oricorio-sensu-shiny",
            "oricorio-shiny",
            "oshawott-shiny",
            "overqwil-shiny",
            "pachirisu-shiny",
            "palkia-origin-shiny",
            "palkia-shiny",
            "palossand-shiny",
            "palpitoad-shiny",
            "pancham-shiny",
            "pangoro-shiny",
            "panpour-shiny",
            "pansage-shiny",
            "pansear-shiny",
            "paras-shiny",
            "parasect-shiny",
            "passimian-shiny",
            "patrat-shiny",
            "pawniard-shiny",
            "pelipper-shiny",
            "perrserker-shiny",
            "persian-alola-shiny",
            "persian-shiny",
            "petilil-shiny",
            "phanpy-shiny",
            "phantump-shiny",
            "pheromosa-shiny",
            "phione-shiny",
            "pichu-shiny",
            "pichu-spiky-eared-shiny",
            "pidgeot-mega-shiny",
            "pidgeot-shiny",
            "pidgeotto-shiny",
            "pidgey-shiny",
            "pidove-shiny",
            "pignite-shiny",
            "pikachu-alola-cap-shiny",
            "pikachu-belle-shiny",
            "pikachu-cosplay-shiny",
            "pikachu-gmax-shiny",
            "pikachu-hoenn-cap-shiny",
            "pikachu-kalos-cap-shiny",
            "pikachu-libre-shiny",
            "pikachu-original-cap-shiny",
            "pikachu-partner-cap-shiny",
            "pikachu-phd-shiny",
            "pikachu-pop-star-shiny",
            "pikachu-rock-star-shiny",
            "pikachu-shiny",
            "pikachu-sinnoh-cap-shiny",
            "pikachu-starter-shiny",
            "pikachu-unova-cap-shiny",
            "pikachu-world-cap-shiny",
            "pikipek-shiny",
            "piloswine-shiny",
            "pincurchin-shiny",
            "pineco-shiny",
            "pinsir-mega-shiny",
            "pinsir-shiny",
            "piplup-shiny",
            "plusle-shiny",
            "poipole-shiny",
            "politoed-shiny",
            "poliwag-shiny",
            "poliwhirl-shiny",
            "poliwrath-shiny",
            "polteageist-shiny",
            "ponyta-galar-shiny",
            "ponyta-shiny",
            "poochyena-shiny",
            "popplio-shiny",
            "porygon-shiny",
            "porygon-z-shiny",
            "porygon2-shiny",
            "primarina-shiny",
            "primeape-shiny",
            "prinplup-shiny",
            "probopass-shiny",
            "psyduck-shiny",
            "pumpkaboo-large-shiny",
            "pumpkaboo-shiny",
            "pumpkaboo-small-shiny",
            "pumpkaboo-super-shiny",
            "pupitar-shiny",
            "purrloin-shiny",
            "purugly-shiny",
            "pyroar-shiny",
            "pyukumuku-shiny",
            "quagsire-shiny",
            "quilava-shiny",
            "quilladin-shiny",
            "qwilfish-hisui-shiny",
            "qwilfish-shiny",
            "raboot-shiny",
            "raichu-alola-shiny",
            "raichu-shiny",
            "raikou-shiny",
            "ralts-shiny",
            "rampardos-shiny",
            "rapidash-galar-shiny",
            "rapidash-shiny",
            "raticate-alola-shiny",
            "raticate-shiny",
            "rattata-alola-shiny",
            "rattata-shiny",
            "rayquaza-mega-shiny",
            "rayquaza-shiny",
            "regice-shiny",
            "regidrago-shiny",
            "regieleki-shiny",
            "regigigas-shiny",
            "regirock-shiny",
            "registeel-shiny",
            "relicanth-shiny",
            "remoraid-shiny",
            "reshiram-shiny",
            "reuniclus-shiny",
            "rhydon-shiny",
            "rhyhorn-shiny",
            "rhyperior-shiny",
            "ribombee-shiny",
            "rillaboom-gmax-shiny",
            "rillaboom-shiny",
            "riolu-shiny",
            "rockruff-shiny",
            "roggenrola-shiny",
            "rolycoly-shiny",
            "rookidee-shiny",
            "roselia-shiny",
            "roserade-shiny",
            "rotom-fan-shiny",
            "rotom-frost-shiny",
            "rotom-heat-shiny",
            "rotom-mow-shiny",
            "rotom-shiny",
            "rotom-wash-shiny",
            "rowlet-shiny",
            "rufflet-shiny",
            "runerigus-shiny",
            "sableye-mega-shiny",
            "sableye-shiny",
            "salamence-mega-shiny",
            "salamence-shiny",
            "salandit-shiny",
            "salazzle-shiny",
            "samurott-hisui-shiny",
            "samurott-shiny",
            "sandaconda-gmax-shiny",
            "sandaconda-shiny",
            "sandile-shiny",
            "sandshrew-alola-shiny",
            "sandshrew-shiny",
            "sandslash-alola-shiny",
            "sandslash-shiny",
            "sandygast-shiny",
            "sawk-shiny",
            "sawsbuck-autumn-shiny",
            "sawsbuck-shiny",
            "sawsbuck-summer-shiny",
            "sawsbuck-winter-shiny",
            "scatterbug-shiny",
            "sceptile-mega-shiny",
            "sceptile-shiny",
            "scizor-mega-shiny",
            "scizor-shiny",
            "scolipede-shiny",
            "scorbunny-shiny",
            "scrafty-shiny",
            "scraggy-shiny",
            "scyther-shiny",
            "seadra-shiny",
            "seaking-shiny",
            "sealeo-shiny",
            "seedot-shiny",
            "seel-shiny",
            "seismitoad-shiny",
            "sentret-shiny",
            "serperior-shiny",
            "servine-shiny",
            "seviper-shiny",
            "sewaddle-shiny",
            "sharpedo-mega-shiny",
            "sharpedo-shiny",
            "shaymin-shiny",
            "shaymin-sky-shiny",
            "shedinja-shiny",
            "shelgon-shiny",
            "shellder-shiny",
            "shellos-east-shiny",
            "shellos-shiny",
            "shelmet-shiny",
            "shieldon-shiny",
            "shiftry-shiny",
            "shiinotic-shiny",
            "shinx-shiny",
            "shroomish-shiny",
            "shuckle-shiny",
            "shuppet-shiny",
            "sigilyph-shiny",
            "silcoon-shiny",
            "silicobra-shiny",
            "silvally-bug-shiny",
            "silvally-dark-shiny",
            "silvally-dragon-shiny",
            "silvally-electric-shiny",
            "silvally-fairy-shiny",
            "silvally-fighting-shiny",
            "silvally-fire-shiny",
            "silvally-flying-shiny",
            "silvally-ghost-shiny",
            "silvally-grass-shiny",
            "silvally-ground-shiny",
            "silvally-ice-shiny",
            "silvally-poison-shiny",
            "silvally-psychic-shiny",
            "silvally-rock-shiny",
            "silvally-shiny",
            "silvally-steel-shiny",
            "silvally-water-shiny",
            "simipour-shiny",
            "simisage-shiny",
            "simisear-shiny",
            "sinistea-shiny",
            "sirfetchd-shiny",
            "sizzlipede-shiny",
            "skarmory-shiny",
            "skiddo-shiny",
            "skiploom-shiny",
            "skitty-shiny",
            "skorupi-shiny",
            "skrelp-shiny",
            "skuntank-shiny",
            "skwovet-shiny",
            "slaking-shiny",
            "slakoth-shiny",
            "sliggoo-hisui-shiny",
            "sliggoo-shiny",
            "slowbro-galar-shiny",
            "slowbro-mega-shiny",
            "slowbro-shiny",
            "slowking-galar-shiny",
            "slowking-shiny",
            "slowpoke-galar-shiny",
            "slowpoke-shiny",
            "slugma-shiny",
            "slurpuff-shiny",
            "smeargle-shiny",
            "smoochum-shiny",
            "sneasel-hisui-shiny",
            "sneasel-shiny",
            "sneasler-shiny",
            "snivy-shiny",
            "snom-shiny",
            "snorlax-gmax-shiny",
            "snorlax-shiny",
            "snorunt-shiny",
            "snover-shiny",
            "snubbull-shiny",
            "sobble-shiny",
            "solgaleo-shiny",
            "solosis-shiny",
            "solrock-shiny",
            "spearow-shiny",
            "spectrier-shiny",
            "spewpa-shiny",
            "spheal-shiny",
            "spinarak-shiny",
            "spinda-blank-shiny",
            "spinda-filled-shiny",
            "spinda-shiny",
            "spiritomb-shiny",
            "spoink-shiny",
            "spritzee-shiny",
            "squirtle-shiny",
            "stakataka-shiny",
            "stantler-shiny",
            "staraptor-shiny",
            "staravia-shiny",
            "starly-shiny",
            "starmie-shiny",
            "staryu-shiny",
            "steelix-mega-shiny",
            "steelix-shiny",
            "steenee-shiny",
            "stonjourner-shiny",
            "stoutland-shiny",
            "stufful-shiny",
            "stunfisk-galar-shiny",
            "stunfisk-shiny",
            "stunky-shiny",
            "sudowoodo-shiny",
            "suicune-shiny",
            "sunflora-shiny",
            "sunkern-shiny",
            "surskit-shiny",
            "swablu-shiny",
            "swadloon-shiny",
            "swalot-shiny",
            "swampert-mega-shiny",
            "swampert-shiny",
            "swanna-shiny",
            "swellow-shiny",
            "swinub-shiny",
            "swirlix-shiny",
            "swoobat-shiny",
            "sylveon-shiny",
            "taillow-shiny",
            "talonflame-shiny",
            "tangela-shiny",
            "tangrowth-shiny",
            "tapu-bulu-shiny",
            "tapu-fini-shiny",
            "tapu-koko-shiny",
            "tapu-lele-shiny",
            "tauros-shiny",
            "teddiursa-shiny",
            "tentacool-shiny",
            "tentacruel-shiny",
            "tepig-shiny",
            "terrakion-shiny",
            "thievul-shiny",
            "throh-shiny",
            "thundurus-shiny",
            "thundurus-therian-shiny",
            "thwackey-shiny",
            "timburr-shiny",
            "tirtouga-shiny",
            "togedemaru-shiny",
            "togekiss-shiny",
            "togepi-shiny",
            "togetic-shiny",
            "torchic-shiny",
            "torkoal-shiny",
            "tornadus-shiny",
            "tornadus-therian-shiny",
            "torracat-shiny",
            "torterra-shiny",
            "totodile-shiny",
            "toucannon-shiny",
            "toxapex-shiny",
            "toxel-shiny",
            "toxicroak-shiny",
            "toxtricity-gmax-shiny",
            "toxtricity-low-key-shiny",
            "toxtricity-shiny",
            "tranquill-shiny",
            "trapinch-shiny",
            "treecko-shiny",
            "trevenant-shiny",
            "tropius-shiny",
            "trubbish-shiny",
            "trumbeak-shiny",
            "tsareena-shiny",
            "turtonator-shiny",
            "turtwig-shiny",
            "tympole-shiny",
            "tynamo-shiny",
            "type-null-shiny",
            "typhlosion-hisui-shiny",
            "typhlosion-shiny",
            "tyranitar-mega-shiny",
            "tyranitar-shiny",
            "tyrantrum-shiny",
            "tyrogue-shiny",
            "tyrunt-shiny",
            "umbreon-shiny",
            "unfezant-shiny",
            "unown-b-shiny",
            "unown-c-shiny",
            "unown-d-shiny",
            "unown-e-shiny",
            "unown-exclamation-shiny",
            "unown-f-shiny",
            "unown-g-shiny",
            "unown-h-shiny",
            "unown-i-shiny",
            "unown-j-shiny",
            "unown-k-shiny",
            "unown-l-shiny",
            "unown-m-shiny",
            "unown-n-shiny",
            "unown-o-shiny",
            "unown-p-shiny",
            "unown-q-shiny",
            "unown-question-shiny",
            "unown-r-shiny",
            "unown-s-shiny",
            "unown-shiny",
            "unown-t-shiny",
            "unown-u-shiny",
            "unown-v-shiny",
            "unown-w-shiny",
            "unown-x-shiny",
            "unown-y-shiny",
            "unown-z-shiny",
            "ursaluna-shiny",
            "ursaring-shiny",
            "urshifu-gmax-shiny",
            "urshifu-rapid-strike-gmax-shiny",
            "urshifu-shiny",
            "uxie-shiny",
            "vanillish-shiny",
            "vanillite-shiny",
            "vanilluxe-shiny",
            "vaporeon-shiny",
            "venipede-shiny",
            "venomoth-shiny",
            "venonat-shiny",
            "venusaur-gmax-shiny",
            "venusaur-mega-shiny",
            "venusaur-shiny",
            "vespiquen-shiny",
            "vibrava-shiny",
            "victini-shiny",
            "victreebel-shiny",
            "vigoroth-shiny",
            "vikavolt-shiny",
            "vileplume-shiny",
            "virizion-shiny",
            "vivillon-archipelago-shiny",
            "vivillon-continental-shiny",
            "vivillon-elegant-shiny",
            "vivillon-fancy-shiny",
            "vivillon-garden-shiny",
            "vivillon-high-plains-shiny",
            "vivillon-icy-snow-shiny",
            "vivillon-jungle-shiny",
            "vivillon-marine-shiny",
            "vivillon-modern-shiny",
            "vivillon-monsoon-shiny",
            "vivillon-ocean-shiny",
            "vivillon-poke-ball-shiny",
            "vivillon-polar-shiny",
            "vivillon-river-shiny",
            "vivillon-sandstorm-shiny",
            "vivillon-savanna-shiny",
            "vivillon-shiny",
            "vivillon-sun-shiny",
            "vivillon-tundra-shiny",
            "volbeat-shiny",
            "volcanion-shiny",
            "volcarona-shiny",
            "voltorb-hisui-shiny",
            "voltorb-shiny",
            "vullaby-shiny",
            "vulpix-alola-shiny",
            "vulpix-shiny",
            "wailmer-shiny",
            "wailord-shiny",
            "walrein-shiny",
            "wartortle-shiny",
            "watchog-shiny",
            "weavile-shiny",
            "weedle-shiny",
            "weepinbell-shiny",
            "weezing-galar-shiny",
            "weezing-shiny",
            "whimsicott-shiny",
            "whirlipede-shiny",
            "whiscash-shiny",
            "whismur-shiny",
            "wigglytuff-shiny",
            "wimpod-shiny",
            "wingull-shiny",
            "wishiwashi-school-shiny",
            "wishiwashi-shiny",
            "wobbuffet-shiny",
            "woobat-shiny",
            "wooloo-shiny",
            "wooper-shiny",
            "wormadam-sandy-shiny",
            "wormadam-shiny",
            "wormadam-trash-shiny",
            "wurmple-shiny",
            "wynaut-shiny",
            "wyrdeer-shiny",
            "xatu-shiny",
            "xerneas-active-shiny",
            "xerneas-shiny",
            "xurkitree-shiny",
            "yamask-galar-shiny",
            "yamask-shiny",
            "yamper-shiny",
            "yanma-shiny",
            "yanmega-shiny",
            "yungoos-shiny",
            "yveltal-shiny",
            "zacian-crowned-shiny",
            "zacian-shiny",
            "zamazenta-crowned-shiny",
            "zamazenta-shiny",
            "zangoose-shiny",
            "zapdos-galar-shiny",
            "zapdos-shiny",
            "zarude-dada-shiny",
            "zarude-shiny",
            "zebstrika-shiny",
            "zekrom-shiny",
            "zeraora-shiny",
            "zigzagoon-galar-shiny",
            "zigzagoon-shiny",
            "zoroark-hisui-shiny",
            "zoroark-shiny",
            "zorua-hisui-shiny",
            "zorua-shiny",
            "zubat-shiny",
            "zweilous-shiny",
            "zygarde-10-shiny",
            "zygarde-complete-shiny",
            "zygarde-shiny"
        )

        System          = @(
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

        Logos           = @(
            'arch',
            'debian',
            'manjaro',
            'kaisen',
            'us-tuxedomask-1'
        )

        Patterns        = @(
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

        Physics         = @(
            'boids-flock',
            'nbody-gravity',
            'particle-field',
            'verlet-chains',
            'langton-ant',
            'dla-nebula',
            'electrostatic-lattice',
            'quantum-entanglement',
            'sandpile-sparks',
            'life-trails',
            'vector-streams'
        )

        Mathematical    = @(
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

        Skull           = @(
            'pukeskull',
            'pukeskull-neon',
            'pukeskull-rainbow',
            'rainbow-pukeskull'
        )

        TerminalThemes  = @(
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

        ASCIIArt        = @(
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

        RGB             = @(
            'RGB-Wave',
            'RGB-Wave-Shifted',
            'Gradient-Tiles',
            'Galaxy'
        )

        Welcome         = @(
            'welcome-Bears2',
            'welcome-cats'
        )

        Default         = @(
            '00default',
            'crunch',
            'zwaves'
        )

        AutoCategorized = @(
        )

        Custom          = @(
            '67-acid',
            'avg-elko',
            'cal24-01',
            'cal24-02',
            'cal24-05',
            'cal24-07',
            'cal24-10',
            'cal25-05',
            'cal25-08',
            'cybercatgirl-i',
            'cybercatgirl-ii',
            'cyberlove',
            'del-block',
            'del-flag',
            'netrun',
            'nf-deep',
            'ob-mario',
            'tg-jacko',
            'us-bless',
            'us-evo11',
            'us-kame-house',
            'zii-dosz',
            'zii-lotr',
            'zii-waro',
            'zo-acid',
            'fuel26-nfo',
            'gj-fuel',
            'ppe-hero',
            'sm-raidersinc',
            'syl-k7',
            'syl-mega',
            'syl-noel',
            'syl-nyan',
            'syl-sntx',
            'syl-strt',
            'syl-trck',
            'tk-16colors',
            'tk-toorconbilly',
            'tk-unc2017',
            'txt-r3m1',
            'nf-evoke2018',
            'nf-learyscat',
            'nf-marble',
            'alpha-king-ill-form-the-head',
            'alpha-king-tangle',
            'ant80s-gwar-tribute-1',
            'ant80s-gwar-tribute-2',
            'ant80s-gwar-tribute-3',
            'blocktronics-wtf4-megajoint-3',
            'bw-ansiland-1',
            'bw-ansiland-2',
            'bw-ansiland-3',
            'bw-ansiland-4',
            'bw-wtf4-ans-1',
            'bw-wtf4-ans-2',
            'bw-wtf4-ans-4',
            'bw-wtf4-ans-6',
            'tcf-adam',
            'td-ilovethejoker',
            'ungenannt-mcd',
            'ungenannt-rawn',
            'us-neonlove',
            'us-pigeon',
            'wa-jiufen',
            'we-b7evoke-2',
            'we-b7evoke-3',
            'we-b7evoke-4',
            'we-bunny',
            'xmas-nf-snowman',
            'fuel-logo',
            'handofgod',
            'mcdonalds',
            'evil-burger'
        )
    }

    # Difficulty levels (for future filtering)
    Difficulty   = @{
        Beginner     = @(
            'bars', 'hearts', 'hearts2', 'colorbars', 'gradient-bars', 'blocks1', 'blocks2',
            'diamonds', 'triangles', 'zigzag-lines', 'panes', 'rails', 'fade',
            'horizon-stripes', 'dot-matrix', 'arch', 'debian', 'manjaro', 'kaisen', 'tux',
            'crunch', 'zwaves', '00default', 'cats', 'crabs', 'crowns', 'six', 'square',
            'bloks', 'hex', 'dotx', 'arrows', 'iso-cubes', 'hex-blocks', 'wave-pattern',
            'terminal', 'colortest', 'colortest-slim', 'ansi-palette', 'spectrum', 'colorwheel',
            'pukeskull', 'pukeskull-neon', 'pukeskull-rainbow', 'rainbow-pukeskull',
            'alpha', 'AAAAAA', 'OOOOOO', 'amiga-classic', 'faces', 'ghosts', 'guns',
            'hedgehogs', 'kevin-woods', 'mouseface', 'mouseface2', 'pinguco', 'rupees',
            'suckless', 'thisisfine', 'tvs', 'unowns', 'xmonad', 'dna', 'illumina',
            'pixel-falls', 'text-styles', 'unicode-showcase', 'nerd-font-glyphs',
            'nerd-font-test', 'terminal-benchmark', 'rgb-spectrum', 'awk-rgb-test',
            'gradient-test', 'block-test', 'colorview'
        )
        Intermediate = @(
            'galaxy-spiral', 'rainbow-waves', 'kaleidoscope', 'mandala-pattern',
            'aurora-bands', 'aurora-waves', 'rainbow-spiral', 'prismatic-rain',
            'flower-mandala', 'rose-window', 'geometric-tessellation', 'hex-maze',
            'terminal-rainbow', 'terminal-fire', 'terminal-ocean', 'plasma-field',
            'nebula', 'nebula-lights', 'crystal-grid', 'crystal-lattice', 'crystal-drift',
            'vortex', 'spiral-lattice', 'prism-diagonals', 'mosaic-shine', 'starlit-plaza',
            'aurora-stream', 'aurora-halo', 'aurora-storm', 'perlin-clouds', 'enchanted-forest', 'lsystem-plant',
            'barnsley-fern', 'fractal-tree', 'pythagorean-tree', 'koch-snowflake', 'sierpinski-carpet',
            'apollonian-circles', 'flower-of-life', 'triforce', 'rose-curves', 'radial-rings',
            'labyrinth-pattern', 'midnight-grid', 'flow-field-static',
            'doom-original', 'doom-outlined', 'pacman', 'space-invaders', 'rally-x', 'tanks',
            'crunchbang', 'crunchbang-mini', 'tiefighter1', 'tiefighter2', 'tiefighter1-no-invo', 'tiefighter1row',
            'darthvader', 'jangofett', 'thebat', 'thebat2', 'monster', 'elfman',
            'terminal-fire-wave', 'terminal-forest-wave', 'terminal-glow',
            'terminal-halloween', 'terminal-monochrome', 'terminal-neon', 'terminal-ocean-wave',
            'terminal-pastel', 'terminal-rainbow-wave', 'terminal-retro', 'terminal-space-wave',
            'terminal-sunset-wave', 'RGB-Wave', 'RGB-Wave-Shifted', 'Gradient-Tiles', 'Galaxy',
            'welcome-Bears2', 'welcome-cats',
            '67-acid', 'avg-elko', 'cal24-01', 'cal24-02', 'cal24-05', 'cal24-07', 'cal24-10',
            'cal25-05', 'cal25-08', 'cybercatgirl-i', 'cybercatgirl-ii', 'cyberlove',
            'del-block', 'del-flag', 'netrun', 'nf-deep', 'nf-evoke2018', 'nf-learyscat', 'nf-marble',
            'ob-mario', 'tg-jacko', 'us-bless', 'us-evo11', 'us-kame-house', 'us-neonlove', 'us-pigeon',
            'us-tuxedomask-1', 'zii-dosz', 'zii-lotr', 'zii-waro', 'zo-acid',
            'fuel26-nfo', 'fuel-logo', 'gj-fuel', 'ppe-hero', 'sm-raidersinc',
            'syl-k7', 'syl-mega', 'syl-noel', 'syl-nyan', 'syl-sntx', 'syl-strt', 'syl-trck',
            'tk-16colors', 'tk-toorconbilly', 'tk-unc2017', 'txt-r3m1',
            'alpha-king-ill-form-the-head', 'alpha-king-tangle',
            'ant80s-gwar-tribute-1', 'ant80s-gwar-tribute-2', 'ant80s-gwar-tribute-3',
            'blocktronics-wtf4-megajoint-3',
            'bw-ansiland-1', 'bw-ansiland-2', 'bw-ansiland-3', 'bw-ansiland-4',
            'bw-wtf4-ans-1', 'bw-wtf4-ans-2', 'bw-wtf4-ans-4', 'bw-wtf4-ans-6',
            'tcf-adam', 'td-ilovethejoker', 'ungenannt-mcd', 'ungenannt-rawn',
            'wa-jiufen', 'we-b7evoke-2', 'we-b7evoke-3', 'we-b7evoke-4', 'we-bunny',
            'xmas-nf-snowman', 'handofgod', 'mcdonalds', 'evil-burger'
        )
        Advanced     = @(
            'mandelbrot-zoom', 'fourier-epicycles', 'boids-flock', 'julia-morphing',
            'fractal-nebula', 'galactic-spiral', 'quantum-entanglement', 'nbody-gravity',
            'psychedelic-vortex', 'tie-dye-spiral', 'kaleidoscope-mirror', 'domain-warp-aurora',
            'wave-interference', 'verlet-chains', 'life-trails', 'langton-ant', 'particle-field',
            'lissajous-harmony', 'lissajous-weave', 'complex-lissajous', 'clifford-trails',
            'rossler-ribbon', 'newton-basins', 'sandpile-sparks', 'dla-nebula',
            'electrostatic-lattice', 'chromatic-lorenz', 'wavelet-ridges', 'waveform-spectra',
            'voronoi-aurora', 'cosmic-web', 'cosmic-mandala', 'penrose-quasicrystal',
            'quasicrystal-arbor', 'hilbert-spectrum', 'sunburst-geodesics', 'spiral-tessellation',
            'geometric-tessellation', 'honeycomb-lattice', 'polygon-wavefront', 'truchet-flow',
            'binary-tree', 'circle-packing', 'tessellation-static', 'plasma-fractal',
            'lightning-plasma', 'sdf-neon-orb', 'inkblot-spectrum', 'hyperbolic-bloom',
            'explosive-burst', 'braid-resonance', 'chrono-tilt', 'cyclone-vortex',
            'city-neon', 'floral-mandala', 'ember-spiral', 'spectrum-flames',
            'prismatic-crystals', 'rainbow-ridges', 'vector-streams', 'starfield-warp',
            'solar-system', 'lunar-orbit', 'twilight-dunes', 'sunrise-lattice'
        )
    }

    # Rendering complexity (affects cache build time)
    Complexity   = @{
        Fast   = @(
            'bars', 'colorbars', 'hearts', 'hearts2', 'arch', 'debian', 'manjaro', 'kaisen',
            'blocks1', 'blocks2', 'gradient-bars', 'diamonds', 'triangles', 'panes', 'rails', 'fade',
            'terminal', 'colortest', 'colortest-slim', 'ansi-palette', 'text-styles', 'tux',
            'pukeskull', 'pukeskull-neon', 'rainbow-pukeskull', 'pukeskull-rainbow',
            'cats', 'crabs', 'crowns', 'six', 'square', 'dotx', 'arrows', 'alpha', 'AAAAAA', 'OOOOOO',
            'crunch', 'zwaves', '00default', 'bloks', 'hex', 'iso-cubes', 'hex-blocks',
            'horizon-stripes', 'dot-matrix', 'wave-pattern', 'zigzag-lines',
            'colorview', 'colorwheel', 'spectrum', 'rgb-spectrum', 'awk-rgb-test',
            'gradient-test', 'block-test', 'nerd-font-glyphs', 'nerd-font-test',
            'terminal-benchmark', 'unicode-showcase', 'faces', 'ghosts', 'guns',
            'hedgehogs', 'mouseface', 'mouseface2', 'pinguco', 'rupees', 'suckless',
            'tvs', 'unowns', 'xmonad', 'amiga-classic', 'illumina', 'pixel-falls',
            'dna', 'kevin-woods', 'thisisfine', 'welcome-Bears2', 'welcome-cats',
            'us-tuxedomask-1', 'darthvader', 'jangofett', 'thebat', 'thebat2',
            'doom-original', 'doom-outlined', 'pacman', 'space-invaders', 'rally-x', 'tanks',
            'crunchbang', 'crunchbang-mini', 'tiefighter1', 'tiefighter2', 'tiefighter1-no-invo', 'tiefighter1row'
        )
        Medium = @(
            'galaxy-spiral', 'rainbow-waves', 'mandala-pattern', 'aurora-bands',
            'rainbow-spiral', 'kaleidoscope', 'flower-mandala', 'prismatic-rain',
            'rose-window', 'geometric-tessellation', 'terminal-rainbow', 'terminal-fire',
            'plasma-field', 'vortex', 'spiral-lattice', 'hex-maze', 'labyrinth-pattern',
            'aurora-waves', 'aurora-stream', 'aurora-halo', 'aurora-storm', 'crystal-grid', 'crystal-lattice',
            'crystal-drift', 'nebula', 'nebula-lights', 'starlit-plaza', 'prism-diagonals',
            'spectrum-flames', 'wavelet-ridges', 'perlin-clouds', 'enchanted-forest',
            'lsystem-plant', 'barnsley-fern', 'fractal-tree', 'pythagorean-tree',
            'koch-snowflake', 'sierpinski-carpet', 'apollonian-circles', 'flower-of-life',
            'triforce', 'rose-curves', 'radial-rings', 'midnight-grid', 'flow-field-static',
            'mosaic-shine', 'floral-mandala', 'terminal-fire-wave',
            'terminal-forest-wave', 'terminal-glow', 'terminal-halloween', 'terminal-monochrome',
            'terminal-neon', 'terminal-ocean', 'terminal-ocean-wave', 'terminal-pastel',
            'terminal-rainbow-wave', 'terminal-retro', 'terminal-space-wave', 'terminal-sunset-wave',
            'RGB-Wave', 'RGB-Wave-Shifted', 'Gradient-Tiles', 'Galaxy', 'elfman', 'monster',
            '67-acid', 'avg-elko', 'cal24-01', 'cal24-02', 'cal24-05', 'cal24-07', 'cal24-10',
            'cal25-05', 'cal25-08', 'cybercatgirl-i', 'cybercatgirl-ii', 'cyberlove',
            'del-block', 'del-flag', 'netrun', 'nf-deep', 'nf-evoke2018', 'nf-learyscat', 'nf-marble',
            'ob-mario', 'tg-jacko', 'us-bless', 'us-evo11', 'us-kame-house', 'us-neonlove', 'us-pigeon',
            'zii-dosz', 'zii-lotr', 'zii-waro', 'zo-acid', 'fuel26-nfo', 'fuel-logo', 'gj-fuel',
            'ppe-hero', 'sm-raidersinc', 'syl-k7', 'syl-mega', 'syl-noel', 'syl-nyan',
            'syl-sntx', 'syl-strt', 'syl-trck', 'tk-16colors', 'tk-toorconbilly', 'tk-unc2017',
            'txt-r3m1', 'alpha-king-ill-form-the-head', 'alpha-king-tangle',
            'ant80s-gwar-tribute-1', 'ant80s-gwar-tribute-2', 'ant80s-gwar-tribute-3',
            'blocktronics-wtf4-megajoint-3', 'bw-ansiland-1', 'bw-ansiland-2', 'bw-ansiland-3',
            'bw-ansiland-4', 'bw-wtf4-ans-1', 'bw-wtf4-ans-2', 'bw-wtf4-ans-4', 'bw-wtf4-ans-6',
            'tcf-adam', 'td-ilovethejoker', 'ungenannt-mcd', 'ungenannt-rawn', 'wa-jiufen',
            'we-b7evoke-2', 'we-b7evoke-3', 'we-b7evoke-4', 'we-bunny', 'xmas-nf-snowman',
            'handofgod', 'mcdonalds', 'evil-burger'
        )
        Slow   = @(
            'mandelbrot-zoom', 'julia-morphing', 'fourier-epicycles', 'boids-flock',
            'fractal-nebula', 'galactic-spiral', 'quantum-entanglement', 'nbody-gravity',
            'psychedelic-vortex', 'tie-dye-spiral', 'kaleidoscope-mirror', 'domain-warp-aurora',
            'wave-interference', 'verlet-chains', 'life-trails', 'particle-field', 'langton-ant',
            'lissajous-harmony', 'lissajous-weave', 'complex-lissajous', 'clifford-trails',
            'rossler-ribbon', 'newton-basins', 'sandpile-sparks', 'dla-nebula',
            'electrostatic-lattice', 'chromatic-lorenz', 'waveform-spectra',
            'voronoi-aurora', 'cosmic-web', 'cosmic-mandala', 'penrose-quasicrystal',
            'quasicrystal-arbor', 'hilbert-spectrum', 'sunburst-geodesics',
            'spiral-tessellation', 'honeycomb-lattice', 'polygon-wavefront',
            'truchet-flow', 'binary-tree', 'circle-packing', 'tessellation-static',
            'plasma-fractal', 'lightning-plasma', 'sdf-neon-orb', 'inkblot-spectrum',
            'hyperbolic-bloom', 'explosive-burst', 'braid-resonance', 'chrono-tilt',
            'cyclone-vortex', 'city-neon', 'ember-spiral', 'prismatic-crystals',
            'rainbow-ridges', 'vector-streams', 'starfield-warp', 'solar-system',
            'lunar-orbit', 'twilight-dunes', 'sunrise-lattice', 'aurora-storm'
        )
    }

    # Recommended for profile
    Recommended  = @(
        'hearts',
        'galaxy-spiral',
        'rainbow-spiral',
        'mandala-pattern',
        'aurora-bands',
        'aurora-waves',
        'nerd-font-test',
        'arch',
        'bars',
        'rainbow-pukeskull',
        'terminal-rainbow',
        'kaleidoscope',
        'flower-mandala',
        'prismatic-rain'
    )

    Tags         = @{
        # Featured & Popular
        'mandelbrot-zoom'               = @('Fractal', 'Featured', 'HighDetail', 'Mathematical')
        'aurora-bands'                  = @('Aurora', 'Nature', 'Gradient', 'Featured')
        'rainbow-spiral'                = @('Rainbow', 'Spiral', 'Showcase', 'Featured')
        'hearts'                        = @('Classic', 'Profile', 'Beginner', 'Simple')
        'bars'                          = @('Beginner', 'Profile', 'SystemDemo', 'Test')
        'galaxy-spiral'                 = @('Space', 'Nature', 'Spiral', 'Popular')

        # System & Testing
        'nerd-font-test'                = @('NerdFont', 'Glyphs', 'Verification', 'System')
        'colortest'                     = @('System', 'Test', 'Palette', 'Diagnostic')
        'colortest-slim'                = @('System', 'Test', 'Compact')
        'ansi-palette'                  = @('System', 'Test', 'ANSI', 'Reference')
        'gradient-test'                 = @('System', 'Test', 'Gradient')
        'block-test'                    = @('System', 'Test', 'Blocks')
        'text-styles'                   = @('System', 'Test', 'Typography')
        'unicode-showcase'              = @('System', 'Test', 'Unicode')
        'terminal-benchmark'            = @('System', 'Performance', 'Test')
        'spectrum'                      = @('System', 'Colors', 'Reference')
        'rgb-spectrum'                  = @('System', 'RGB', 'Reference')
        'awk-rgb-test'                  = @('System', 'Test', 'RGB')

        # Terminal Themes
        'terminal'                      = @('Terminal', 'Theme', 'Default')
        'terminal-rainbow'              = @('Terminal', 'Theme', 'Profile', 'Rainbow')
        'terminal-fire'                 = @('Terminal', 'Theme', 'Fire', 'Warm')
        'terminal-ocean'                = @('Terminal', 'Theme', 'Ocean', 'Cool')
        'terminal-neon'                 = @('Terminal', 'Theme', 'Neon', 'Vibrant')
        'terminal-pastel'               = @('Terminal', 'Theme', 'Pastel', 'Soft')
        'terminal-retro'                = @('Terminal', 'Theme', 'Retro', 'Classic')
        'terminal-glow'                 = @('Terminal', 'Theme', 'Glow')
        'terminal-halloween'            = @('Terminal', 'Theme', 'Halloween', 'Seasonal')
        'terminal-monochrome'           = @('Terminal', 'Theme', 'Monochrome')

        # Gaming
        'doom-original'                 = @('Gaming', 'Classic', 'ASCIIArt', 'Retro')
        'doom-outlined'                 = @('Gaming', 'Classic', 'ASCIIArt')
        'pacman'                        = @('Gaming', 'Classic', 'Arcade')
        'space-invaders'                = @('Gaming', 'Classic', 'Arcade', 'Retro')
        'rally-x'                       = @('Gaming', 'Arcade', 'Retro')
        'tanks'                         = @('Gaming', 'Retro')
        'tiefighter1'                   = @('Gaming', 'StarWars', 'SciFi')
        'tiefighter2'                   = @('Gaming', 'StarWars', 'SciFi')

        # ASCII Art
        'cats'                          = @('ASCIIArt', 'Animals', 'Whimsy', 'Cute')
        'crabs'                         = @('ASCIIArt', 'Animals', 'Ocean')
        'darthvader'                    = @('ASCIIArt', 'StarWars', 'Movies')
        'jangofett'                     = @('ASCIIArt', 'StarWars', 'Movies')
        'tux'                           = @('ASCIIArt', 'Linux', 'Mascot', 'Penguin')
        'dna'                           = @('ASCIIArt', 'Science', 'Biology')
        'thisisfine'                    = @('ASCIIArt', 'Meme', 'Funny')

        # Mathematical & Physics
        'newton-basins'                 = @('Math', 'Fractal', 'ComplexPlane', 'Advanced')
        'fourier-epicycles'             = @('Math', 'Animation', 'Physics')
        'julia-morphing'                = @('Math', 'Fractal', 'Animation')
        'clifford-trails'               = @('Math', 'Chaos', 'Attractor')
        'rossler-ribbon'                = @('Math', 'Chaos', 'Attractor')
        'lissajous-harmony'             = @('Math', 'Harmonic', 'Curves')
        'complex-lissajous'             = @('Math', 'Harmonic', 'Advanced')
        'boids-flock'                   = @('Physics', 'Simulation', 'Emergent')
        'nbody-gravity'                 = @('Physics', 'Simulation', 'Gravity')
        'particle-field'                = @('Physics', 'Particles', 'Dynamic')
        'vector-streams'                = @('Physics', 'VectorField', 'Dynamic', 'Flow')
        'quantum-entanglement'          = @('Physics', 'Quantum', 'Simulation')
        'langton-ant'                   = @('Physics', 'CellularAutomata', 'Emergent')
        'life-trails'                   = @('Physics', 'CellularAutomata', 'GameOfLife')

        # Nature & Space
        'aurora-storm'                  = @('Aurora', 'Animated', 'Nature', 'Dynamic')
        'aurora-waves'                  = @('Aurora', 'Nature', 'Waves')
        'aurora-stream'                 = @('Aurora', 'Nature', 'Flow')
        'aurora-halo'                   = @('Aurora', 'Nature', 'Glow')
        'nebula'                        = @('Space', 'Nature', 'Clouds')
        'nebula-lights'                 = @('Space', 'Nature', 'Glow')
        'starfield-warp'                = @('Space', 'Motion', 'SciFi')
        'solar-system'                  = @('Space', 'Planets', 'Educational')
        'cosmic-web'                    = @('Space', 'Universe', 'Structure')
        'cosmic-mandala'                = @('Space', 'Mandala', 'Symmetry')

        # Artistic & Visual
        'mandala-pattern'               = @('Mandala', 'Symmetry', 'Artistic', 'Spiritual')
        'flower-mandala'                = @('Mandala', 'Floral', 'Artistic')
        'floral-mandala'                = @('Mandala', 'Floral', 'Organic')
        'kaleidoscope'                  = @('Kaleidoscope', 'Symmetry', 'Colorful')
        'kaleidoscope-mirror'           = @('Kaleidoscope', 'Mirror', 'Symmetry')
        'rainbow-waves'                 = @('Rainbow', 'Waveform', 'Featured', 'Gradient')
        'prismatic-rain'                = @('Rainbow', 'Prism', 'Gradient')
        'prismatic-crystals'            = @('Crystal', 'Prism', 'Geometric')
        'tie-dye-spiral'                = @('Spiral', 'Psychedelic', 'Retro')
        'psychedelic-vortex'            = @('Psychedelic', 'Vortex', 'Trippy')
        'vortex'                        = @('Vortex', 'Spiral', 'Motion')
        'city-neon'                     = @('Urban', 'Neon', 'Cityscape')

        # Geometric
        'sierpinski-carpet'             = @('Fractal', 'Geometric', 'Recursive')
        'koch-snowflake'                = @('Fractal', 'Geometric', 'Snowflake')
        'pythagorean-tree'              = @('Fractal', 'Tree', 'Geometric')
        'apollonian-circles'            = @('Fractal', 'Circles', 'Geometric')
        'penrose-quasicrystal'          = @('Quasicrystal', 'Geometric', 'Aperiodic')
        'flower-of-life'                = @('SacredGeometry', 'Circles', 'Spiritual')
        'triforce'                      = @('Geometric', 'Gaming', 'Zelda')
        'honeycomb-lattice'             = @('Geometric', 'Hexagonal', 'Pattern')

        # Patterns
        'gradient-bars'                 = @('Pattern', 'Gradient', 'Simple')
        'blocks1'                       = @('Pattern', 'Blocks', 'Simple')
        'blocks2'                       = @('Pattern', 'Blocks', 'Simple')
        'diamonds'                      = @('Pattern', 'Geometric', 'Simple')
        'triangles'                     = @('Pattern', 'Geometric', 'Simple')
        'hex-maze'                      = @('Pattern', 'Maze', 'Hexagonal')
        'labyrinth-pattern'             = @('Pattern', 'Maze', 'Complex')

        # Logos
        'arch'                          = @('Logo', 'Linux', 'Distribution')
        'debian'                        = @('Logo', 'Linux', 'Distribution')
        'manjaro'                       = @('Logo', 'Linux', 'Distribution')
        'kaisen'                        = @('Logo', 'Linux', 'Distribution')

        # Skull Theme
        'pukeskull'                     = @('Skull', 'Dark', 'Edgy')
        'pukeskull-neon'                = @('Skull', 'Neon', 'Vibrant')
        'pukeskull-rainbow'             = @('Skull', 'Rainbow', 'Colorful')
        'rainbow-pukeskull'             = @('Skull', 'Rainbow', 'Popular')

        # RGB & Special
        'RGB-Wave'                      = @('RGB', 'Wave', 'Gradient', 'Smooth')
        'RGB-Wave-Shifted'              = @('RGB', 'Wave', 'Gradient', 'Shifted')
        'Gradient-Tiles'                = @('RGB', 'Tiles', 'Gradient')
        'Galaxy'                        = @('RGB', 'Space', 'Colorful')

        # Default & Welcome
        '00default'                     = @('Default', 'Starter')
        'crunch'                        = @('Default', 'Classic')
        'zwaves'                        = @('Default', 'Waves')
        'welcome-Bears2'                = @('Welcome', 'Greeting', 'Cute')
        'welcome-cats'                  = @('Welcome', 'Greeting', 'Animals')

        # Abstract ANSI Art
        '67-acid'                       = @('Abstract', 'ANSI', 'Art')
        'alpha-king-ill-form-the-head'  = @('Abstract', 'ANSI', 'Art', 'Custom')
        'alpha-king-tangle'             = @('Abstract', 'ANSI', 'Art', 'Custom')
        'ant80s-gwar-tribute-1'         = @('Abstract', 'ANSI', 'Art', 'Music')
        'ant80s-gwar-tribute-2'         = @('Abstract', 'ANSI', 'Art', 'Music')
        'ant80s-gwar-tribute-3'         = @('Abstract', 'ANSI', 'Art', 'Music')
        'avg-elko'                      = @('Abstract', 'ANSI', 'Art')
        'blocktronics-wtf4-megajoint-3' = @('Abstract', 'ANSI', 'Art', 'Blocktronics')
        'bw-ansiland-1'                 = @('Abstract', 'ANSI', 'Art', 'Scene')
        'bw-ansiland-2'                 = @('Abstract', 'ANSI', 'Art', 'Scene')
        'bw-ansiland-3'                 = @('Abstract', 'ANSI', 'Art', 'Scene')
        'bw-ansiland-4'                 = @('Abstract', 'ANSI', 'Art', 'Scene')
        'bw-wtf4-ans-1'                 = @('Abstract', 'ANSI', 'Art')
        'bw-wtf4-ans-2'                 = @('Abstract', 'ANSI', 'Art')
        'bw-wtf4-ans-4'                 = @('Abstract', 'ANSI', 'Art')
        'bw-wtf4-ans-6'                 = @('Abstract', 'ANSI', 'Art')
        'cal24-01'                      = @('Abstract', 'ANSI', 'Calendar', '2024')
        'cal24-02'                      = @('Abstract', 'ANSI', 'Calendar', '2024')
        'cal24-05'                      = @('Abstract', 'ANSI', 'Calendar', '2024')
        'cal24-07'                      = @('Abstract', 'ANSI', 'Calendar', '2024')
        'cal24-10'                      = @('Abstract', 'ANSI', 'Calendar', '2024')
        'cal25-05'                      = @('Abstract', 'ANSI', 'Calendar', '2025')
        'cal25-08'                      = @('Abstract', 'ANSI', 'Calendar', '2025')
        'cybercatgirl-i'                = @('Abstract', 'ANSI', 'Art', 'Character')
        'cybercatgirl-ii'               = @('Abstract', 'ANSI', 'Art', 'Character')
        'cyberlove'                     = @('Abstract', 'ANSI', 'Art', 'Cyber')
        'del-block'                     = @('Abstract', 'ANSI', 'Art')
        'del-flag'                      = @('Abstract', 'ANSI', 'Art')
        'evil-burger'                   = @('Abstract', 'ANSI', 'Art', 'Food', 'Funny')
        'fuel26-nfo'                    = @('Abstract', 'ANSI', 'Art', 'NFO')
        'fuel-logo'                     = @('Abstract', 'ANSI', 'Art', 'Logo')
        'gj-fuel'                       = @('Abstract', 'ANSI', 'Art')
        'handofgod'                     = @('Abstract', 'ANSI', 'Art', 'Religious')
        'mcdonalds'                     = @('Abstract', 'ANSI', 'Art', 'Logo', 'Food')
        'netrun'                        = @('Abstract', 'ANSI', 'Art', 'Cyber')
        'nf-deep'                       = @('Abstract', 'ANSI', 'Art')
        'nf-evoke2018'                  = @('Abstract', 'ANSI', 'Art', 'Event')
        'nf-learyscat'                  = @('Abstract', 'ANSI', 'Art', 'Animal')
        'nf-marble'                     = @('Abstract', 'ANSI', 'Art', 'Texture')
        'ob-mario'                      = @('Abstract', 'ANSI', 'Art', 'Gaming')
        'ppe-hero'                      = @('Abstract', 'ANSI', 'Art')
        'sm-raidersinc'                 = @('Abstract', 'ANSI', 'Art')
        'syl-k7'                        = @('Abstract', 'ANSI', 'Art')
        'syl-mega'                      = @('Abstract', 'ANSI', 'Art')
        'syl-noel'                      = @('Abstract', 'ANSI', 'Art', 'Christmas')
        'syl-nyan'                      = @('Abstract', 'ANSI', 'Art', 'Meme')
        'syl-sntx'                      = @('Abstract', 'ANSI', 'Art')
        'syl-strt'                      = @('Abstract', 'ANSI', 'Art')
        'syl-trck'                      = @('Abstract', 'ANSI', 'Art')
        'tcf-adam'                      = @('Abstract', 'ANSI', 'Art', 'Portrait')
        'td-ilovethejoker'              = @('Abstract', 'ANSI', 'Art', 'Movies')
        'tg-jacko'                      = @('Abstract', 'ANSI', 'Art', 'Music')
        'tk-16colors'                   = @('Abstract', 'ANSI', 'Art')
        'tk-toorconbilly'               = @('Abstract', 'ANSI', 'Art')
        'tk-unc2017'                    = @('Abstract', 'ANSI', 'Art', 'Event')
        'txt-r3m1'                      = @('Abstract', 'ANSI', 'Art')
        'ungenannt-mcd'                 = @('Abstract', 'ANSI', 'Art')
        'ungenannt-rawn'                = @('Abstract', 'ANSI', 'Art')
        'us-bless'                      = @('Abstract', 'ANSI', 'Art')
        'us-evo11'                      = @('Abstract', 'ANSI', 'Art', 'Event')
        'us-kame-house'                 = @('Abstract', 'ANSI', 'Art', 'Anime')
        'us-neonlove'                   = @('Abstract', 'ANSI', 'Art', 'Neon')
        'us-pigeon'                     = @('Abstract', 'ANSI', 'Art', 'Bird')
        'wa-jiufen'                     = @('Abstract', 'ANSI', 'Art', 'Scene')
        'we-b7evoke-2'                  = @('Abstract', 'ANSI', 'Art', 'Event')
        'we-b7evoke-3'                  = @('Abstract', 'ANSI', 'Art', 'Event')
        'we-b7evoke-4'                  = @('Abstract', 'ANSI', 'Art', 'Event')
        'we-bunny'                      = @('Abstract', 'ANSI', 'Art', 'Animal')
        'xmas-nf-snowman'               = @('Abstract', 'ANSI', 'Art', 'Christmas')
        'zii-dosz'                      = @('Abstract', 'ANSI', 'Art')
        'zii-lotr'                      = @('Abstract', 'ANSI', 'Art', 'Movies', 'LOTR')
        'zii-waro'                      = @('Abstract', 'ANSI', 'Art')
        'zo-acid'                       = @('Abstract', 'ANSI', 'Art')

        # Additional Missing Tags
        'bloks'                         = @('Pattern', 'Blocks', 'Simple')
        'domain-warp-aurora'            = @('Aurora', 'Advanced', 'Warped')
        'galactic-spiral'               = @('Space', 'Galaxy', 'Spiral', 'Math')
        'terminal-fire-wave'            = @('Terminal', 'Theme', 'Fire', 'Wave')
        'terminal-forest-wave'          = @('Terminal', 'Theme', 'Forest', 'Wave')
        'terminal-ocean-wave'           = @('Terminal', 'Theme', 'Ocean', 'Wave')
        'terminal-rainbow-wave'         = @('Terminal', 'Theme', 'Rainbow', 'Wave')
        'terminal-space-wave'           = @('Terminal', 'Theme', 'Space', 'Wave')
        'terminal-sunset-wave'          = @('Terminal', 'Theme', 'Sunset', 'Wave')
        'tiefighter1-no-invo'           = @('Gaming', 'StarWars', 'SciFi', 'TIE')
        'tiefighter1row'                = @('Gaming', 'StarWars', 'SciFi', 'TIE')

        # More Missing Tags
        'AAAAAA'                        = @('Pattern', 'Letters', 'Simple')
        'OOOOOO'                        = @('Pattern', 'Letters', 'Simple')
        'alpha'                         = @('Pattern', 'Letters', 'Simple')
        'amiga-classic'                 = @('Retro', 'Classic', 'Computing')
        'arrows'                        = @('Pattern', 'Symbols', 'Simple')
        'barnsley-fern'                 = @('Fractal', 'Nature', 'Plant')
        'binary-tree'                   = @('Fractal', 'Tree', 'Structure')
        'braid-resonance'               = @('Math', 'Pattern', 'Resonance')
        'chromatic-lorenz'              = @('Math', 'Chaos', 'Colorful')
        'chrono-tilt'                   = @('Abstract', 'Time', 'Effect')
        'circle-packing'                = @('Geometric', 'Circles', 'Optimization')
        'colorbars'                     = @('Pattern', 'Test', 'Simple')
        'colorview'                     = @('System', 'Utility', 'Colors')
        'colorwheel'                    = @('System', 'Utility', 'Colors')
        'crowns'                        = @('Pattern', 'Symbols', 'Decorative')
        'crunchbang'                    = @('Logo', 'Linux', 'Distribution')
        'crunchbang-mini'               = @('Logo', 'Linux', 'Distribution', 'Compact')
        'crystal-drift'                 = @('Nature', 'Crystal', 'Motion')
        'crystal-grid'                  = @('Nature', 'Crystal', 'Grid')
        'crystal-lattice'               = @('Nature', 'Crystal', 'Structure')
        'cyclone-vortex'                = @('Nature', 'Vortex', 'Weather')
        'dla-nebula'                    = @('Physics', 'Simulation', 'Fractal')
        'dot-matrix'                    = @('Pattern', 'Dots', 'Grid')
        'dotx'                          = @('Pattern', 'Dots', 'Simple')
        'electrostatic-lattice'         = @('Physics', 'Electric', 'Field')
        'elfman'                        = @('ASCIIArt', 'Character', 'Fantasy')
        'ember-spiral'                  = @('Artistic', 'Spiral', 'Fire')
        'enchanted-forest'              = @('Nature', 'Forest', 'Fantasy')
        'explosive-burst'               = @('Artistic', 'Explosion', 'Radial')
        'faces'                         = @('ASCIIArt', 'Emoticons', 'Simple')
        'fade'                          = @('Pattern', 'Gradient', 'Simple')
        'flow-field-static'             = @('Physics', 'Flow', 'VectorField')
        'fractal-nebula'                = @('Fractal', 'Space', 'Clouds')
        'fractal-tree'                  = @('Fractal', 'Tree', 'Nature')
        'geometric-tessellation'        = @('Geometric', 'Tessellation', 'Complex')
        'ghosts'                        = @('ASCIIArt', 'Gaming', 'Retro')
        'guns'                          = @('ASCIIArt', 'Weapons', 'Symbols')
        'hearts2'                       = @('Pattern', 'Hearts', 'Simple', 'Profile')
        'hedgehogs'                     = @('ASCIIArt', 'Animals', 'Cute')
        'hex'                           = @('Pattern', 'Hexagonal', 'Simple')
        'hex-blocks'                    = @('Pattern', 'Hexagonal', 'Blocks')
        'hilbert-spectrum'              = @('Math', 'Fractal', 'Curve', 'Colorful')
        'horizon-stripes'               = @('Pattern', 'Stripes', 'Simple')
        'hyperbolic-bloom'              = @('Math', 'Hyperbolic', 'Geometric')
        'illumina'                      = @('Artistic', 'Light', 'Glow')
        'inkblot-spectrum'              = @('Artistic', 'Abstract', 'Colorful')
        'iso-cubes'                     = @('Pattern', 'Isometric', 'Cubes')
        'kevin-woods'                   = @('ASCIIArt', 'Portrait', 'Character')
        'lightning-plasma'              = @('Artistic', 'Electric', 'Plasma')
        'lissajous-weave'               = @('Math', 'Harmonic', 'Weave')
        'lsystem-plant'                 = @('Fractal', 'Plant', 'LSystem')
        'lunar-orbit'                   = @('Space', 'Moon', 'Orbital')
        'midnight-grid'                 = @('Pattern', 'Grid', 'Dark')
        'monster'                       = @('ASCIIArt', 'Character', 'Creature')
        'mosaic-shine'                  = @('Artistic', 'Mosaic', 'Shimmer')
        'mouseface'                     = @('ASCIIArt', 'Animals', 'Cute')
        'mouseface2'                    = @('ASCIIArt', 'Animals', 'Cute')
        'nerd-font-glyphs'              = @('System', 'NerdFont', 'Glyphs', 'Icons')
        'panes'                         = @('Pattern', 'Grid', 'Simple')
        'perlin-clouds'                 = @('Nature', 'Clouds', 'Noise')
        'pinguco'                       = @('ASCIIArt', 'Animals', 'Penguin')
        'pixel-falls'                   = @('Artistic', 'Animation', 'Pixels')
        'plasma-field'                  = @('Artistic', 'Plasma', 'Dynamic')
        'plasma-fractal'                = @('Artistic', 'Plasma', 'Fractal')
        'polygon-wavefront'             = @('Geometric', 'Polygon', 'Wave')
        'prism-diagonals'               = @('Artistic', 'Prism', 'Diagonal')
        'quasicrystal-arbor'            = @('Geometric', 'Quasicrystal', 'Tree')
        'radial-rings'                  = @('Geometric', 'Radial', 'Rings')
        'rails'                         = @('Pattern', 'Lines', 'Simple')
        'rainbow-ridges'                = @('Artistic', 'Rainbow', 'Terrain')
        'rose-curves'                   = @('Math', 'Geometric', 'Curves')
        'rose-window'                   = @('Geometric', 'Radial', 'Decorative')
        'rupees'                        = @('Gaming', 'Zelda', 'Symbols')
        'sandpile-sparks'               = @('Physics', 'CellularAutomata', 'Sandpile')
        'sdf-neon-orb'                  = @('Artistic', 'SDF', 'Neon', 'Orb')
        'six'                           = @('Pattern', 'Numbers', 'Simple')
        'spectrum-flames'               = @('Artistic', 'Flames', 'Spectrum')
        'spiral-lattice'                = @('Geometric', 'Spiral', 'Lattice')
        'spiral-tessellation'           = @('Geometric', 'Spiral', 'Tessellation')
        'square'                        = @('Pattern', 'Geometric', 'Simple')
        'starlit-plaza'                 = @('Artistic', 'Space', 'Scene')
        'suckless'                      = @('Logo', 'Software', 'Minimalist')
        'sunburst-geodesics'            = @('Geometric', 'Radial', 'Geodesic')
        'sunrise-lattice'               = @('Nature', 'Sunrise', 'Lattice')
        'tessellation-static'           = @('Geometric', 'Tessellation', 'Pattern')
        'thebat'                        = @('ASCIIArt', 'Batman', 'Comics')
        'thebat2'                       = @('ASCIIArt', 'Batman', 'Comics')
        'truchet-flow'                  = @('Geometric', 'Truchet', 'Flow')
        'tvs'                           = @('ASCIIArt', 'Electronics', 'Retro')
        'twilight-dunes'                = @('Nature', 'Desert', 'Sunset')
        'unowns'                        = @('Gaming', 'Pokemon', 'Symbols')
        'us-tuxedomask-1'               = @('Logo', 'Anime', 'Character')
        'verlet-chains'                 = @('Physics', 'Simulation', 'Verlet')
        'voronoi-aurora'                = @('Math', 'Voronoi', 'Aurora')
        'wave-interference'             = @('Physics', 'Waves', 'Interference')
        'wave-pattern'                  = @('Pattern', 'Waves', 'Simple')
        'waveform-spectra'              = @('Math', 'Waveform', 'Spectrum')
        'wavelet-ridges'                = @('Math', 'Wavelet', 'Terrain')
        'xmonad'                        = @('Logo', 'Software', 'WindowManager')
        'zigzag-lines'                  = @('Pattern', 'Lines', 'Simple')
    }

    Descriptions = @{
        # Featured & Popular
        'mandelbrot-zoom'               = 'Animated dive into the Mandelbrot set rendered with rich ANSI gradients.'
        'aurora-bands'                  = 'Waves of aurora-inspired color emitted with layered gradient passes.'
        'rainbow-spiral'                = 'Cycling rainbow spiral that highlights the ANSI 24-bit palette.'
        'hearts'                        = 'Simple heart glyph pattern ideal for quick profile previews.'
        'hearts2'                       = 'Alternative heart pattern with different styling.'
        'bars'                          = 'Evenly spaced color bars showcasing RGB intensity across the palette.'
        'galaxy-spiral'                 = 'Stunning spiral galaxy visualization with star field backdrop.'

        # System & Testing
        'nerd-font-test'                = 'Comprehensive Nerd Font glyph sampler for verifying terminal fonts.'
        'colortest'                     = 'Full terminal color palette test showing all 256 colors.'
        'colortest-slim'                = 'Compact color test display for quick verification.'
        'ansi-palette'                  = 'ANSI escape code reference with color samples.'
        'gradient-test'                 = 'Gradient rendering test across color spectrum.'
        'block-test'                    = 'Unicode block character test for font coverage.'
        'text-styles'                   = 'Demonstration of ANSI text styles and formatting.'
        'unicode-showcase'              = 'Showcase of Unicode characters and glyphs.'
        'terminal-benchmark'            = 'Performance benchmark for terminal rendering speed.'
        'spectrum'                      = 'Full color spectrum display.'
        'nerd-font-glyphs'              = 'Collection of useful Nerd Font icons and symbols.'

        # Terminal Themes
        'terminal'                      = 'Default terminal theme with balanced colors.'
        'terminal-rainbow'              = 'PowerShell profile-friendly terminal theme gradient with warm hues.'
        'terminal-fire'                 = 'Warm fire-inspired terminal theme with orange and red tones.'
        'terminal-ocean'                = 'Cool-toned PowerShell startup theme inspired by ocean gradients.'
        'terminal-neon'                 = 'Vibrant neon-colored terminal theme.'
        'terminal-pastel'               = 'Soft pastel-colored terminal theme.'
        'terminal-retro'                = 'Retro-styled terminal theme with classic computing aesthetics.'
        'terminal-glow'                 = 'Glowing gradient terminal theme.'
        'terminal-halloween'            = 'Spooky Halloween-themed terminal colors.'
        'terminal-monochrome'           = 'Minimalist monochrome terminal theme.'

        # Gaming & Pop Culture
        'doom-original'                 = 'Classic DOOM logo converted to ANSI fan art.'
        'doom-outlined'                 = 'Outlined version of the classic DOOM logo.'
        'pacman'                        = 'Iconic Pac-Man arcade game character.'
        'space-invaders'                = 'Classic Space Invaders alien sprite.'
        'rally-x'                       = 'Rally-X arcade game artwork.'
        'tanks'                         = 'Retro tank battle game graphics.'
        'tiefighter1'                   = 'Star Wars TIE Fighter spacecraft.'
        'tiefighter2'                   = 'Alternative TIE Fighter design.'
        'darthvader'                    = 'ASCII art portrait of Darth Vader.'
        'jangofett'                     = 'ASCII art portrait of Jango Fett.'

        # ASCII Art & Characters
        'cats'                          = 'Collection of ASCII cat doodles to warm up your terminal.'
        'crabs'                         = 'Adorable ASCII crab illustrations.'
        'tux'                           = 'Linux mascot Tux the penguin.'
        'dna'                           = 'Double helix DNA strand visualization.'
        'thisisfine'                    = 'Famous "This is Fine" meme dog in flames.'
        'crowns'                        = 'Decorative crown symbols.'
        'elfman'                        = 'Elf character ASCII art.'
        'monster'                       = 'Playful monster character.'
        'thebat'                        = 'Batman-inspired artwork.'
        'thebat2'                       = 'Alternative Batman design.'

        # Mathematical & Fractal
        'newton-basins'                 = 'Meticulous rendering of Newton fractal basins in ANSI color.'
        'fourier-epicycles'             = 'Animated Fourier series with rotating epicycles.'
        'julia-morphing'                = 'Morphing Julia set fractal animation.'
        'clifford-trails'               = 'Chaotic attractor trails from Clifford equations.'
        'rossler-ribbon'                = 'Rössler attractor rendered as flowing ribbon.'
        'lissajous-harmony'             = 'Harmonic Lissajous curve patterns.'
        'lissajous-weave'               = 'Woven patterns from Lissajous curves.'
        'complex-lissajous'             = 'Complex multi-frequency Lissajous figures.'
        'sierpinski-carpet'             = 'Sierpinski carpet fractal pattern.'
        'koch-snowflake'                = 'Koch snowflake fractal construction.'
        'pythagorean-tree'              = 'Fractal tree based on Pythagorean theorem.'
        'apollonian-circles'            = 'Apollonian gasket of tangent circles.'
        'fractal-tree'                  = 'Branching fractal tree structure.'
        'fractal-nebula'                = 'Nebula-like fractal cloud formation.'
        'binary-tree'                   = 'Structured binary tree visualization.'

        # Physics & Simulation
        'boids-flock'                   = 'Emergent flocking behavior simulation (boids algorithm).'
        'nbody-gravity'                 = 'N-body gravitational simulation with particle trails.'
        'particle-field'                = 'Dynamic particle field with force interactions.'
        'vector-streams'                = 'Animated particle streams flowing along computed vector fields.'
        'quantum-entanglement'          = 'Quantum entanglement visualization.'
        'langton-ant'                   = 'Langton''s ant cellular automaton.'
        'life-trails'                   = 'Conway''s Game of Life with trailing history.'
        'verlet-chains'                 = 'Verlet integration physics chains.'
        'dla-nebula'                    = 'Diffusion-limited aggregation forming nebula shapes.'
        'electrostatic-lattice'         = 'Electric field lattice visualization.'
        'sandpile-sparks'               = 'Sandpile model with cascading avalanches.'

        # Nature & Space
        'aurora-storm'                  = 'Dynamic aurora burst effect using layered noise for movement.'
        'aurora-waves'                  = 'Gentle aurora wave patterns.'
        'aurora-stream'                 = 'Flowing aurora streams.'
        'aurora-halo'                   = 'Circular aurora halo effect.'
        'nebula'                        = 'Cosmic nebula cloud formation.'
        'nebula-lights'                 = 'Glowing nebula with internal lighting.'
        'starfield-warp'                = 'Starfield warp effect like hyperspace.'
        'solar-system'                  = 'Orbital paths of solar system planets.'
        'cosmic-web'                    = 'Large-scale cosmic web structure.'
        'cosmic-mandala'                = 'Cosmic-themed mandala pattern.'
        'lunar-orbit'                   = 'Moon orbital path visualization.'
        'enchanted-forest'              = 'Mystical forest scene with atmospheric effects.'
        'perlin-clouds'                 = 'Perlin noise cloud patterns.'
        'crystal-grid'                  = 'Crystalline grid structure.'
        'crystal-lattice'               = 'Crystal lattice formation.'
        'crystal-drift'                 = 'Drifting crystal formations.'
        'barnsley-fern'                 = 'Barnsley fern fractal plant.'
        'lsystem-plant'                 = 'L-system generated plant structure.'

        # Artistic & Visual
        'mandala-pattern'               = 'Symmetric mandala rendering with layered rings and highlights.'
        'flower-mandala'                = 'Floral-inspired mandala design.'
        'floral-mandala'                = 'Organic floral mandala pattern.'
        'kaleidoscope'                  = 'Kaleidoscopic symmetry with vibrant colors.'
        'kaleidoscope-mirror'           = 'Mirrored kaleidoscope effect.'
        'rainbow-waves'                 = 'Smooth sine-wave gradients cycling through rainbow tones.'
        'prismatic-rain'                = 'Prismatic rainfall effect with color dispersion.'
        'prismatic-crystals'            = 'Crystalline prism formations.'
        'tie-dye-spiral'                = 'Psychedelic tie-dye spiral pattern.'
        'psychedelic-vortex'            = 'Trippy vortex with color distortion.'
        'vortex'                        = 'Swirling vortex pattern.'
        'city-neon'                     = 'Neon-lit cityscape at night.'
        'plasma-field'                  = 'Organic plasma field animation.'
        'plasma-fractal'                = 'Fractal plasma patterns.'
        'lightning-plasma'              = 'Electric plasma with lightning bolts.'
        'mosaic-shine'                  = 'Shimmering mosaic tile pattern.'
        'inkblot-spectrum'              = 'Inkblot test patterns in color spectrum.'
        'spectrum-flames'               = 'Flame effect across color spectrum.'
        'sdf-neon-orb'                  = 'Signed distance field neon orb.'
        'hyperbolic-bloom'              = 'Hyperbolic blooming pattern.'
        'explosive-burst'               = 'Radiating explosive burst effect.'
        'ember-spiral'                  = 'Glowing ember spiral.'
        'braid-resonance'               = 'Braided resonance patterns.'
        'chrono-tilt'                   = 'Time-shifted tilt effect.'
        'cyclone-vortex'                = 'Cyclonic vortex formation.'
        'chromatic-lorenz'              = 'Chromatic Lorenz attractor.'

        # Geometric Patterns
        'penrose-quasicrystal'          = 'Penrose tiling quasicrystal pattern.'
        'quasicrystal-arbor'            = 'Tree-like quasicrystal structure.'
        'hilbert-spectrum'              = 'Hilbert curve with color spectrum.'
        'flower-of-life'                = 'Sacred geometry flower of life pattern.'
        'triforce'                      = 'Zelda triforce geometric symbol.'
        'rose-curves'                   = 'Mathematical rose curve patterns.'
        'rose-window'                   = 'Rose window geometric design.'
        'radial-rings'                  = 'Concentric radial ring pattern.'
        'spiral-lattice'                = 'Spiral-based lattice structure.'
        'spiral-tessellation'           = 'Tessellated spiral patterns.'
        'sunburst-geodesics'            = 'Geodesic sunburst pattern.'
        'honeycomb-lattice'             = 'Hexagonal honeycomb structure.'
        'polygon-wavefront'             = 'Polygonal wavefront propagation.'
        'geometric-tessellation'        = 'Complex geometric tessellation.'
        'tessellation-static'           = 'Static tessellation pattern.'
        'truchet-flow'                  = 'Truchet tiles creating flow patterns.'
        'circle-packing'                = 'Circle packing algorithm visualization.'

        # Simple Patterns
        'gradient-bars'                 = 'Gradient color bars.'
        'colorbars'                     = 'Solid color bars.'
        'blocks1'                       = 'Block pattern variation 1.'
        'blocks2'                       = 'Block pattern variation 2.'
        'diamonds'                      = 'Diamond shape pattern.'
        'triangles'                     = 'Triangle pattern array.'
        'zigzag-lines'                  = 'Zigzag line pattern.'
        'hex-maze'                      = 'Hexagonal maze pattern.'
        'labyrinth-pattern'             = 'Complex labyrinth design.'
        'hex-blocks'                    = 'Hexagonal block pattern.'
        'iso-cubes'                     = 'Isometric cube pattern.'
        'horizon-stripes'               = 'Horizontal stripe pattern.'
        'midnight-grid'                 = 'Dark grid pattern.'
        'dot-matrix'                    = 'Dot matrix style pattern.'
        'wave-pattern'                  = 'Sinusoidal wave pattern.'
        'rails'                         = 'Railroad track pattern.'
        'flow-field-static'             = 'Static flow field visualization.'
        'panes'                         = 'Window pane pattern.'
        'fade'                          = 'Color fade gradient.'
        'bloks'                         = 'Block pattern design.'
        'hex'                           = 'Hexagonal pattern.'

        # Logos & Branding
        'arch'                          = 'Arch Linux logo.'
        'debian'                        = 'Debian Linux logo.'
        'manjaro'                       = 'Manjaro Linux logo.'
        'kaisen'                        = 'Kaisen Linux logo.'
        'crunchbang'                    = 'CrunchBang Linux logo.'
        'crunchbang-mini'               = 'Minimized CrunchBang logo.'
        'suckless'                      = 'Suckless.org logo.'
        'xmonad'                        = 'XMonad window manager logo.'

        # Skull Theme
        'pukeskull'                     = 'Skull artwork with dark theme.'
        'pukeskull-neon'                = 'Neon-colored skull.'
        'pukeskull-rainbow'             = 'Rainbow gradient skull.'
        'rainbow-pukeskull'             = 'Popular rainbow skull variant.'

        # RGB & Waves
        'RGB-Wave'                      = 'Smooth RGB wave gradient.'
        'RGB-Wave-Shifted'              = 'Phase-shifted RGB wave.'
        'Gradient-Tiles'                = 'Tiled gradient pattern.'
        'Galaxy'                        = 'Galaxy-themed RGB display.'
        'rainbow-ridges'                = 'Rainbow-colored ridge patterns.'
        'waveform-spectra'              = 'Waveform frequency spectrum.'
        'wavelet-ridges'                = 'Wavelet-based ridge visualization.'
        'wave-interference'             = 'Wave interference pattern simulation.'

        # Additional Missing Descriptions
        'faces'                         = 'Collection of ASCII emoticon faces.'
        'galactic-spiral'               = 'Mathematical galactic spiral formation.'
        'ghosts'                        = 'Retro gaming ghost characters.'
        'guns'                          = 'ASCII weapon and gun symbols.'
        'hedgehogs'                     = 'Cute ASCII hedgehog illustrations.'
        'kevin-woods'                   = 'ASCII portrait of Kevin Woods.'
        'mouseface'                     = 'Adorable ASCII mouse face.'
        'mouseface2'                    = 'Alternative ASCII mouse face design.'
        'pinguco'                       = 'Penguin ASCII character.'
        'prism-diagonals'               = 'Diagonal prismatic color pattern.'
        'rgb-spectrum'                  = 'RGB color spectrum reference display.'
        'rupees'                        = 'Zelda rupee gem symbols.'
        'terminal-fire-wave'            = 'Fire-themed terminal with wave effect.'
        'terminal-forest-wave'          = 'Forest-themed terminal with wave effect.'
        'terminal-ocean-wave'           = 'Ocean terminal theme with flowing waves.'
        'terminal-rainbow-wave'         = 'Rainbow terminal theme with wave animation.'
        'terminal-space-wave'           = 'Space-themed terminal with wave effect.'
        'terminal-sunset-wave'          = 'Sunset terminal theme with wave motion.'
        'tiefighter1-no-invo'           = 'TIE Fighter without invocation.'
        'tiefighter1row'                = 'Row of TIE Fighter spacecraft.'
        'tvs'                           = 'Retro television set ASCII art.'
        'unowns'                        = 'Pokemon Unown character symbols.'
        'us-tuxedomask-1'               = 'Tuxedo Mask from Sailor Moon.'
        'voronoi-aurora'                = 'Aurora effect using Voronoi diagrams.'

        # Welcome & Default
        '00default'                     = 'Default starter colorscript.'
        'crunch'                        = 'Classic crunch pattern.'
        'zwaves'                        = 'Z-shaped wave pattern.'
        'welcome-Bears2'                = 'Welcoming bears greeting message.'
        'welcome-cats'                  = 'Welcoming cats greeting message.'

        # Miscellaneous
        'illumina'                      = 'Illuminated pattern effect.'
        'pixel-falls'                   = 'Falling pixel animation.'
        'starlit-plaza'                 = 'Starlit nighttime plaza scene.'
        'twilight-dunes'                = 'Desert dunes at twilight.'
        'sunrise-lattice'               = 'Sunrise through lattice structure.'
        'amiga-classic'                 = 'Classic Amiga computer aesthetic.'
        'arrows'                        = 'Directional arrow symbols.'
        'dotx'                          = 'Dot pattern X design.'
        'alpha'                         = 'Alpha symbol pattern.'
        'AAAAAA'                        = 'Repeated A letter pattern.'
        'OOOOOO'                        = 'Repeated O letter pattern.'
        'six'                           = 'Number six pattern.'
        'square'                        = 'Square geometric pattern.'
        'colorview'                     = 'Color viewing utility.'
        'colorwheel'                    = 'Interactive color wheel.'
        'awk-rgb-test'                  = 'AWK-based RGB color test utility.'
        'domain-warp-aurora'            = 'Aurora with domain warping effect for distortion.'

        # Abstract ANSI Art Descriptions
        '67-acid'                       = 'Abstract acid-inspired ANSI artwork.'
        'alpha-king-ill-form-the-head'  = 'Custom ANSI art piece by Alpha King.'
        'alpha-king-tangle'             = 'Tangled abstract pattern ANSI art by Alpha King.'
        'ant80s-gwar-tribute-1'         = 'GWAR band tribute ANSI art (part 1 of 3).'
        'ant80s-gwar-tribute-2'         = 'GWAR band tribute ANSI art (part 2 of 3).'
        'ant80s-gwar-tribute-3'         = 'GWAR band tribute ANSI art (part 3 of 3).'
        'avg-elko'                      = 'ELKO ANSI artwork by AVG.'
        'blocktronics-wtf4-megajoint-3' = 'Blocktronics WTF4 Megajoint pack artwork (part 3).'
        'bw-ansiland-1'                 = 'ANSILand scene artwork by BW (part 1 of 4).'
        'bw-ansiland-2'                 = 'ANSILand scene artwork by BW (part 2 of 4).'
        'bw-ansiland-3'                 = 'ANSILand scene artwork by BW (part 3 of 4).'
        'bw-ansiland-4'                 = 'ANSILand scene artwork by BW (part 4 of 4).'
        'bw-wtf4-ans-1'                 = 'WTF4 ANSI pack artwork by BW (part 1).'
        'bw-wtf4-ans-2'                 = 'WTF4 ANSI pack artwork by BW (part 2).'
        'bw-wtf4-ans-4'                 = 'WTF4 ANSI pack artwork by BW (part 4).'
        'bw-wtf4-ans-6'                 = 'WTF4 ANSI pack artwork by BW (part 6).'
        'cal24-01'                      = '2024 Calendar artwork - January.'
        'cal24-02'                      = '2024 Calendar artwork - February.'
        'cal24-05'                      = '2024 Calendar artwork - May.'
        'cal24-07'                      = '2024 Calendar artwork - July.'
        'cal24-10'                      = '2024 Calendar artwork - October.'
        'cal25-05'                      = '2025 Calendar artwork - May.'
        'cal25-08'                      = '2025 Calendar artwork - August.'
        'cybercatgirl-i'                = 'Cyberpunk catgirl character artwork (variant I).'
        'cybercatgirl-ii'               = 'Cyberpunk catgirl character artwork (variant II).'
        'cyberlove'                     = 'Cyberpunk-themed love artwork.'
        'del-block'                     = 'Block-style artwork by DEL.'
        'del-flag'                      = 'Flag artwork by DEL.'
        'evil-burger'                   = 'Humorous evil burger character artwork.'
        'fuel26-nfo'                    = 'Fuel pack #26 NFO file artwork.'
        'fuel-logo'                     = 'Fuel brand logo artwork.'
        'gj-fuel'                       = 'Fuel-themed artwork by GJ.'
        'handofgod'                     = 'Hand of God religious-themed artwork.'
        'mcdonalds'                     = 'McDonalds logo parody artwork.'
        'netrun'                        = 'Cyberpunk netrunner-themed artwork.'
        'nf-deep'                       = 'Deep-themed ANSI artwork by NF.'
        'nf-evoke2018'                  = 'Evoke 2018 demoparty artwork by NF.'
        'nf-learyscat'                  = 'Learys Cat artwork by NF.'
        'nf-marble'                     = 'Marble texture artwork by NF.'
        'ob-mario'                      = 'Super Mario character artwork by OB.'
        'ppe-hero'                      = 'Hero character artwork by PPE.'
        'sm-raidersinc'                 = 'Raiders Inc artwork by SM.'
        'syl-k7'                        = 'K7 artwork by SYL.'
        'syl-mega'                      = 'Mega artwork by SYL.'
        'syl-noel'                      = 'Christmas Noel artwork by SYL.'
        'syl-nyan'                      = 'Nyan Cat meme artwork by SYL.'
        'syl-sntx'                      = 'Syntax artwork by SYL.'
        'syl-strt'                      = 'Start artwork by SYL.'
        'syl-trck'                      = 'Track artwork by SYL.'
        'tcf-adam'                      = 'Adam portrait artwork by TCF.'
        'td-ilovethejoker'              = 'Joker tribute artwork by TD.'
        'tg-jacko'                      = 'Michael Jackson tribute artwork by TG.'
        'tk-16colors'                   = '16Colors artwork by TK.'
        'tk-toorconbilly'               = 'Toorcon Billy artwork by TK.'
        'tk-unc2017'                    = 'UNC 2017 event artwork by TK.'
        'txt-r3m1'                      = 'R3M1 text artwork by TXT.'
        'ungenannt-mcd'                 = 'McDonalds themed artwork by Ungenannt.'
        'ungenannt-rawn'                = 'Rawn artwork by Ungenannt.'
        'us-bless'                      = 'Bless artwork by US.'
        'us-evo11'                      = 'Evoke 11 demoparty artwork by US.'
        'us-kame-house'                 = 'Dragon Ball Kame House artwork by US.'
        'us-neonlove'                   = 'Neon love artwork by US.'
        'us-pigeon'                     = 'Pigeon character artwork by US.'
        'wa-jiufen'                     = 'Jiufen scene artwork by WA.'
        'we-b7evoke-2'                  = 'Breakpoint 7 Evoke artwork (part 2) by WE.'
        'we-b7evoke-3'                  = 'Breakpoint 7 Evoke artwork (part 3) by WE.'
        'we-b7evoke-4'                  = 'Breakpoint 7 Evoke artwork (part 4) by WE.'
        'we-bunny'                      = 'Bunny character artwork by WE.'
        'xmas-nf-snowman'               = 'Christmas snowman artwork by NF.'
        'zii-dosz'                      = 'DOS artwork by ZII.'
        'zii-lotr'                      = 'Lord of the Rings tribute artwork by ZII.'
        'zii-waro'                      = 'WARO artwork by ZII.'
        'zo-acid'                       = 'Acid-style artwork by ZO.'
    }
}
