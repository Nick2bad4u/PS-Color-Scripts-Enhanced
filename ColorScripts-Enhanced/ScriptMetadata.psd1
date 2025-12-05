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

        Pokemon         = @(

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
