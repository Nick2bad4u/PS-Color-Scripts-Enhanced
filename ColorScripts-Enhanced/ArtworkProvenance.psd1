@{
    SchemaVersion = 1

    Collections   = @{
        'botany' = @{
            DisplayName     = 'botany'
            ProjectUrl      = 'https://github.com/jifunks/botany'
            Revision        = '2802121ed8268df1b69584167a14d4c690aaea35'
            Attribution     = 'Jacob Funke (jifunks)'
            License         = 'ISC'
            LicenseEvidence = 'ThirdPartyNotices/botany-ISC.txt'
            Selection       = 'Seventeen visually distinct flowering final-stage (*3.ansi) plants selected from 72 ANSI scenes.'
            Transformation  = 'Decoded as UTF-8 and preserved byte-for-byte in passthrough mode because the files are already formatted sequential ANSI streams.'
        }

        'os-ansi' = @{
            DisplayName     = 'OS ANSI art'
            ProjectUrl      = 'https://github.com/info-mono/os-ansi'
            CanonicalUrl    = 'https://codeberg.org/NNB/os-ansi'
            Revision        = '64449ace20798a2149eeb527e5cd16428f0b45e5'
            Attribution     = 'Joe Schillinger and NNBnh; logo source credited upstream to Ufetch by Jschx'
            License         = 'ISC'
            LicenseEvidence = 'ThirdPartyNotices/os-ansi-ISC.txt'
            Selection       = 'Two genuinely multicolor logos selected from 36 files after rendered-content comparison; 34 monochrome or duotone files were rejected.'
            Transformation  = 'Decoded as UTF-8 and preserved in passthrough mode because the LF-only files are already formatted terminal streams.'
        }

        'asciiville' = @{
            DisplayName     = 'Asciiville'
            ProjectUrl      = 'https://github.com/doctorfree/Asciiville'
            Revision        = '49f6289d511033b8ded1bd8d38f60c4bc5fd0301'
            Attribution     = 'Ronald Record'
            License         = 'MIT'
            LicenseEvidence = 'ThirdPartyNotices/asciiville-MIT.txt'
            Selection       = 'One project-authored 67-column rainbow wordmark selected from 946 files; image-derived and ambiguously licensed galleries were rejected.'
            Transformation  = 'Decoded as UTF-8 and preserved byte-for-byte in passthrough mode because LF-only line breaks are part of the intended four-row layout.'
        }

        'durdraw' = @{
            DisplayName     = 'Durdraw examples'
            ProjectUrl      = 'https://github.com/durdraw/durdraw'
            Revision        = 'cf63d7445c00c5db1ee2dd28df8325649045b803'
            Attribution     = 'Durdraw contributors (copyright Sam Foster); upstream artwork filename credits indyz'
            License         = 'BSD-3-Clause'
            LicenseEvidence = 'ThirdPartyNotices/durdraw-BSD-3-Clause.txt'
            Selection       = 'One native 80-by-32 multicolor ANSI stream imported; animated .dur examples require a dedicated frame-aware parser.'
            Transformation  = 'Decoded as UTF-8 and preserved byte-for-byte in passthrough mode because the source is already a complete SGR-only ANSI stream.'
        }

        'roy-sac' = @{
            DisplayName          = 'Roy/SAC ANSI Art'
            ProjectUrl           = 'https://www.roysac.com/roy_ansishow.html'
            ArchiveUrl           = 'https://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP'
            ArchiveSha256        = '8598a9432b4feb86c4e79552795b407b9d7c576fb6f25e9828d6143f1c7b35bc'
            Attribution          = 'Roy/SAC aka Carsten Cumbrowski'
            License              = 'FAL-1.3'
            LicenseEvidence      = 'ThirdPartyNotices/roy-sac-FAL-1.3.txt'
            PublicDomainEvidence = @(
                'https://www.roysac.com/blog/2006/07/important-decision-made-regarding-my-text-art/'
                'https://www.roysac.com/roy_ansishow.html'
            )
            CopyleftEvidence      = 'https://www.roysac.com/blog/2008/08/copyleft-vs-public-domain/'
            Selection            = 'Thirty-five polished Roy-authored works selected after rendered preview, multicolor, provenance, duplicate, and terminal-size review; oversized works are split into numbered row segments.'
            Transformation       = 'Decoded as CP437 and flattened through the bounded ANSI terminal emulator; valid SAUCE metadata was retained, and oversized works were divided at reviewed row boundaries.'
        }
    }

    Scripts       = @{
        'botany-agave' = @{
            Collection     = 'botany'
            SourceFile     = 'art/agave3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/agave3.ansi'
            SourceSha256   = '9501e689a6422c07d2ffe10e7866c2456f20e9df122a74fb6bf8ae1f9825adab'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-baobab' = @{
            Collection     = 'botany'
            SourceFile     = 'art/baobab3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/baobab3.ansi'
            SourceSha256   = '7dac070a584168a492a19a3a1a72e56d897151c3d826b33ef12db2e0578951c2'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-brugmansia' = @{
            Collection     = 'botany'
            SourceFile     = 'art/brugmansia3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/brugmansia3.ansi'
            SourceSha256   = 'b9e9f33bce4cdc86fcd0ab61b3920a0d560df79af6573183a2352cd2e4685bfd'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-cactus' = @{
            Collection     = 'botany'
            SourceFile     = 'art/cactus3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/cactus3.ansi'
            SourceSha256   = '263260fdea7ef37b89adb3e5a5e9b80c43b863d427bc47ba4bdcd1244f534885'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-columbine' = @{
            Collection     = 'botany'
            SourceFile     = 'art/columbine3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/columbine3.ansi'
            SourceSha256   = 'b05c1400253400bf1d218e4ca3530088ec5bcf1f69d98f43f85b47ec4dd0a94d'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-daffodil' = @{
            Collection     = 'botany'
            SourceFile     = 'art/daffodil3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/daffodil3.ansi'
            SourceSha256   = '434bd95fd47417dc1038fb99ed201807a072055e3a81ce47665fed65c442822f'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-fern' = @{
            Collection     = 'botany'
            SourceFile     = 'art/fern3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/fern3.ansi'
            SourceSha256   = 'c4993e9fb35a4d7cbb35311d273dbcfa21bdf873aac1005fef161e317a45548c'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-ficus' = @{
            Collection     = 'botany'
            SourceFile     = 'art/ficus3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/ficus3.ansi'
            SourceSha256   = 'e5d616ce314b11e0d8fe7422db56b603432330bef85d3bff1d16676db843b855'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-flytrap' = @{
            Collection     = 'botany'
            SourceFile     = 'art/flytrap3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/flytrap3.ansi'
            SourceSha256   = '8dcdd0803d02344720f1429c59db7982ab11d477023cf3020ba0b19c05e7d790'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-hemp' = @{
            Collection     = 'botany'
            SourceFile     = 'art/hemp3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/hemp3.ansi'
            SourceSha256   = 'a2919289a3c14b6b8c6e3c2b9a08c4d7fc9bfdb652fa7a3c07ff270c5a719084'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-iris' = @{
            Collection     = 'botany'
            SourceFile     = 'art/iris3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/iris3.ansi'
            SourceSha256   = 'f8b7d0efd6741c48fa464ddf10f165bff1a18d437b1147f896a6cbfe187c0393'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-jadeplant' = @{
            Collection     = 'botany'
            SourceFile     = 'art/jadeplant3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/jadeplant3.ansi'
            SourceSha256   = 'e5488546df66a21a2be98cd6c08136fd88db44e7efe2d50407564e2928e38b96'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-lithops' = @{
            Collection     = 'botany'
            SourceFile     = 'art/lithops3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/lithops3.ansi'
            SourceSha256   = 'b2b48c3924f0a44e4b65333d113c27a59c80e12d78faa9f1023d4f96497ceae5'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-moss' = @{
            Collection     = 'botany'
            SourceFile     = 'art/moss3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/moss3.ansi'
            SourceSha256   = 'f6eda9206ec99a1832c394ff608cce5be1e040f5ab67545754e6ff7d751bff17'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-palm' = @{
            Collection     = 'botany'
            SourceFile     = 'art/palm3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/palm3.ansi'
            SourceSha256   = 'cd0a0fd4a53f637ac79f777cd882f0db0ad1dd43fb3ce761505794e791b0b245'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-snapdragon' = @{
            Collection     = 'botany'
            SourceFile     = 'art/snapdragon3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/snapdragon3.ansi'
            SourceSha256   = '2c14bf0c7d757d6c0a058b2cf55932b1ce4cebffaccacd07cb8ab81e9e6e016e'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'botany-sunflower' = @{
            Collection     = 'botany'
            SourceFile     = 'art/sunflower3.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/jifunks/botany/2802121ed8268df1b69584167a14d4c690aaea35/art/sunflower3.ansi'
            SourceSha256   = 'e02b15f93f48933c3def511369efb843c3f059cc55b4b4ffba8fbafc910e5316'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }

        'os-ansi-centos' = @{
            Collection     = 'os-ansi'
            SourceFile     = 'centos.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/info-mono/os-ansi/64449ace20798a2149eeb527e5cd16428f0b45e5/centos.ansi'
            SourceSha256   = '8a63d9cadc931afa901e6facf2e9b336133fefaaf5c4a33e87027eb269b4a4a1'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'os-ansi-macos' = @{
            Collection     = 'os-ansi'
            SourceFile     = 'macos.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/info-mono/os-ansi/64449ace20798a2149eeb527e5cd16428f0b45e5/macos.ansi'
            SourceSha256   = 'c4c03388dd24aa7d9b5b63026702bbbb23beade6ea4ff97cfc4493254da540c7'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'asciiville-wordmark' = @{
            Collection     = 'asciiville'
            SourceFile     = 'art/asciiville.asc'
            SourceUrl      = 'https://raw.githubusercontent.com/doctorfree/Asciiville/49f6289d511033b8ded1bd8d38f60c4bc5fd0301/art/asciiville.asc'
            SourceSha256   = '5168a8d94f8cc7cbbb810951c390e50d8617448ad224e39733bd80c13d3cb0ba'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }

        'durdraw-indyz-kali' = @{
            Collection     = 'durdraw'
            SourceFile     = 'examples/indyz-kali.utf8.ans'
            SourceUrl      = 'https://raw.githubusercontent.com/durdraw/durdraw/cf63d7445c00c5db1ee2dd28df8325649045b803/examples/indyz-kali.utf8.ans'
            SourceSha256   = 'f7d3a9abc3adb84f1512561a3ac483eace743856b69fbff76fc8b53dbf340f66'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }

        'roy-sac-500n' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0395/ROY-500N.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0395/ROY-500N.ANS'
            SourceRevision = 'archive-sha256:7b30118405d4d21f05022ba0c6f9cc20d209f8b3e8684cf8db7bf6713b2b2425'
            SourceSha256   = '278fa5e2c20fbd3f7bc6446834dc12b0edb2c362f365a5632a8e35a47d3fab08'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-biza' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0396a/ROY-BIZA.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0396a/ROY-BIZA.ANS'
            SourceRevision = 'archive-sha256:c3d9b108bac9f368f69bc8e60a13ba1af3964411e19719c53ca175ef47f6be86'
            SourceSha256   = '93038afb037fbd6dd61e79eb72ee356f0c892ad5001963fa62d0d3ebabc5a784'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-bj' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0695a/ROY-BJ.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0695a/ROY-BJ.ANS'
            SourceRevision = 'archive-sha256:fdb220fd949148b42f901401233ee5917f0ab0d506d9b91fc04ce4bed204f9b8'
            SourceSha256   = '43fc956a17b083ed09d113685089b3ac8fd6098e0f0b3707ccd133c611cbdf62'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-blh2' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac1296/ROY-BLH2.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac1296/ROY-BLH2.ANS'
            SourceRevision = 'archive-sha256:c85a4096950740daf891e591a7227b3738f0676b5756c32fe6c534f5c1bf43cd'
            SourceSha256   = 'ff03d8775b267d5b1238aac22f1232cd076fc36b5add8a3c77bf52fd172419cd'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-cshe' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0398/ROY-CSHE.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0398/ROY-CSHE.ANS'
            SourceRevision = 'archive-sha256:5deb0c572555b712853a4e44d44a0abdfad1e60e47bfcff7ce192c9fa583bdec'
            SourceSha256   = 'eebaea8a83a30b88528d1bfaced5a96e52e98e1933e87376573cc292b050e3d2'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-dnxa' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0396a/ROY-DNXA.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0396a/ROY-DNXA.ANS'
            SourceRevision = 'archive-sha256:c3d9b108bac9f368f69bc8e60a13ba1af3964411e19719c53ca175ef47f6be86'
            SourceSha256   = 'd6462994d24ce3da44c11c6189a8d5ad94cf5b32847eadd428a363988bb77a48'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-drow' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0997/ROY-DROW.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0997/ROY-DROW.ANS'
            SourceRevision = 'archive-sha256:da5320832895c3901d4f15edb6d72c8cae3759c8058411ecb6a63c5962f374c9'
            SourceSha256   = '07b933c7d0d0b41e5b96a84a4e2352e2d7b65da99327ac43b5eab95177e461c1'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-ds-part01' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac1294/ROY-DS.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac1294/ROY-DS.ANS'
            SourceRevision = 'archive-sha256:4cf7765ee6660556cb900dacf0ec67f070b8e4df414172b5e01733a49d10031f'
            SourceSha256   = 'a32f5a27974c0fb843751a2b34e078fb36ad73287abe531600da02dd400697d8'
            SourceRows     = '1-33'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-ds-part02' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac1294/ROY-DS.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac1294/ROY-DS.ANS'
            SourceRevision = 'archive-sha256:4cf7765ee6660556cb900dacf0ec67f070b8e4df414172b5e01733a49d10031f'
            SourceSha256   = 'a32f5a27974c0fb843751a2b34e078fb36ad73287abe531600da02dd400697d8'
            SourceRows     = '34-65'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-ed1' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0397b/ROY-ED1.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0397b/ROY-ED1.ANS'
            SourceRevision = 'archive-sha256:4675e986db6899c1d9bb95711f69cdb168742dca5b3bf60822d0bd9e3e64898a'
            SourceSha256   = '1f34ef423308da444c347c502d6666e2e4884f26fd14a9f33a16d146e45af47a'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-fh' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0698/ROY-FH.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0698/ROY-FH.ANS'
            SourceRevision = 'archive-sha256:3ad60d24dadce29394a34ab0bc7060bed41c9764a3ef5a1e4b7bb7b85284a7ac'
            SourceSha256   = '7d50efa037a2956f34468e232a33beec49f4b74b046cfeb2000000d294c46e1f'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-fun' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0395/ROY-FUN.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0395/ROY-FUN.ANS'
            SourceRevision = 'archive-sha256:7b30118405d4d21f05022ba0c6f9cc20d209f8b3e8684cf8db7bf6713b2b2425'
            SourceSha256   = '3336364bc118b333d2899abba9ca7ffe7e9816a648cd0d6486b982c79e2bbef8'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-hoe' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0995/ROY-HOE.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0995/ROY-HOE.ANS'
            SourceRevision = 'archive-sha256:cc360b79185ba045775293710395ac2d0a043a893088560f3313eb0514dcb071'
            SourceSha256   = 'c4fcd877177092fc29805e74b9423dac373e651186e3ad7cf3cefbf15bc274a2'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-hype' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0396a/ROY-HYPE.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0396a/ROY-HYPE.ANS'
            SourceRevision = 'archive-sha256:c3d9b108bac9f368f69bc8e60a13ba1af3964411e19719c53ca175ef47f6be86'
            SourceSha256   = '7b739201d2b66f85547ba958d9630267f97ff1953f17cce4a3afd42ff308e8cb'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-kit' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0397b/ROY-KIT.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0397b/ROY-KIT.ANS'
            SourceRevision = 'archive-sha256:4675e986db6899c1d9bb95711f69cdb168742dca5b3bf60822d0bd9e3e64898a'
            SourceSha256   = '55568fd0050c5d8061a14f12a22aa1864ea4268498ce0cde2c4a0e73c28c4f62'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-lala' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0995/ROY-LALA.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0995/ROY-LALA.ANS'
            SourceRevision = 'archive-sha256:cc360b79185ba045775293710395ac2d0a043a893088560f3313eb0514dcb071'
            SourceSha256   = '94d81605fd6f5dfebc3417fc32355a5c9b5749549231f8a47e1bc10e0ffb925b'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-lod' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac1297b/ROY-LOD.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac1297b/ROY-LOD.ANS'
            SourceRevision = 'archive-sha256:e4c35a24ffc69bcc579de5fc26d58b207367560ff74b93ff41cdf43e1a9c1c22'
            SourceSha256   = '5838f0a36cd08ee92ff5b1ddac3db86aa1a5b81e22f7cb857ae33166d1b03331'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-lsd3' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0695a/ROY-LSD3.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0695a/ROY-LSD3.ANS'
            SourceRevision = 'archive-sha256:fdb220fd949148b42f901401233ee5917f0ab0d506d9b91fc04ce4bed204f9b8'
            SourceSha256   = '0d81ae7c8bbdd1db6c5e9741a6a7a9c65bf158c36c2208cee53f26a1fa7348ab'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-m8' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac1297b/ROY-M8.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac1297b/ROY-M8.ANS'
            SourceRevision = 'archive-sha256:e4c35a24ffc69bcc579de5fc26d58b207367560ff74b93ff41cdf43e1a9c1c22'
            SourceSha256   = '50a5229d056a2f9a9e040c75990d207ae7a46387091a14c2d4eb2ed1aa35b337'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-maze' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0398/ROY-MAZE.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0398/ROY-MAZE.ANS'
            SourceRevision = 'archive-sha256:5deb0c572555b712853a4e44d44a0abdfad1e60e47bfcff7ce192c9fa583bdec'
            SourceSha256   = 'f5ed7ec6966eaf35a8f882d8c692a3d8f9048c184ca4cb66bc1c7233627435b0'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-obs' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac1294/ROY-OBS.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac1294/ROY-OBS.ANS'
            SourceRevision = 'archive-sha256:4cf7765ee6660556cb900dacf0ec67f070b8e4df414172b5e01733a49d10031f'
            SourceSha256   = 'ce60b80ec187b81380218be4395ad9c13b9ef9d8251cc6055d70a0e08ce3b6d2'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-outb' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0995/ROY-OUTB.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0995/ROY-OUTB.ANS'
            SourceRevision = 'archive-sha256:cc360b79185ba045775293710395ac2d0a043a893088560f3313eb0514dcb071'
            SourceSha256   = '25162b7057cc2f80fda4f309ddc736d002606f954c074908c2dc76291ec14750'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-pc1-part01' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0395/ROY-PC1.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0395/ROY-PC1.ANS'
            SourceRevision = 'archive-sha256:7b30118405d4d21f05022ba0c6f9cc20d209f8b3e8684cf8db7bf6713b2b2425'
            SourceSha256   = 'b823bdacce5d24d70985f7694503b3bdfd98d75eac9110af79c20d1c277968a9'
            SourceRows     = '1-44'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-pc1-part02' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0395/ROY-PC1.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0395/ROY-PC1.ANS'
            SourceRevision = 'archive-sha256:7b30118405d4d21f05022ba0c6f9cc20d209f8b3e8684cf8db7bf6713b2b2425'
            SourceSha256   = 'b823bdacce5d24d70985f7694503b3bdfd98d75eac9110af79c20d1c277968a9'
            SourceRows     = '45-83'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-pc1-part03' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0395/ROY-PC1.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0395/ROY-PC1.ANS'
            SourceRevision = 'archive-sha256:7b30118405d4d21f05022ba0c6f9cc20d209f8b3e8684cf8db7bf6713b2b2425'
            SourceSha256   = 'b823bdacce5d24d70985f7694503b3bdfd98d75eac9110af79c20d1c277968a9'
            SourceRows     = '84-122'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-ph' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0997/ROY-PH.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0997/ROY-PH.ANS'
            SourceRevision = 'archive-sha256:da5320832895c3901d4f15edb6d72c8cae3759c8058411ecb6a63c5962f374c9'
            SourceSha256   = 'cb4e67de4ccdfcf93303cac7bbce6d38178dfdf3d3a866c1f5f7d36fe8fd4b77'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-rav1' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0395/ROY-RAV1.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0395/ROY-RAV1.ANS'
            SourceRevision = 'archive-sha256:7b30118405d4d21f05022ba0c6f9cc20d209f8b3e8684cf8db7bf6713b2b2425'
            SourceSha256   = '66b9b0470807772dc5c6bd76b6f07f0c7f8b1d9b3246e661ef6db2635ce2d022'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-rav2' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0395/ROY-RAV2.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0395/ROY-RAV2.ANS'
            SourceRevision = 'archive-sha256:7b30118405d4d21f05022ba0c6f9cc20d209f8b3e8684cf8db7bf6713b2b2425'
            SourceSha256   = '5972fabbee62c53585fefe8812df4e33d761bdcc92d43513019c4e6308eed9d0'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-shlg' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0395/ROY-SHLG.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0395/ROY-SHLG.ANS'
            SourceRevision = 'archive-sha256:7b30118405d4d21f05022ba0c6f9cc20d209f8b3e8684cf8db7bf6713b2b2425'
            SourceSha256   = 'ae42ca154b474994da325145f7fc44518e64587f1b1cdafbf65762c244f51612'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-tdt' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0998b/ROY-TDT.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0998b/ROY-TDT.ANS'
            SourceRevision = 'archive-sha256:19c53dfc47387efbbd82613dca5be9c93436f5cc68bae78cca35e6d1a766cbaa'
            SourceSha256   = '1439e06a8a0f3e69309e54d12f107e3bb19593bab6e0eeeead5ec8e6dda9310f'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-tdu-part01' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0395/ROY-TDU.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0395/ROY-TDU.ANS'
            SourceRevision = 'archive-sha256:7b30118405d4d21f05022ba0c6f9cc20d209f8b3e8684cf8db7bf6713b2b2425'
            SourceSha256   = 'f6a581cd3525cfb3d632f1dd7046aed725d671dc8839fe1bb488cdbb9ecc2f1a'
            SourceRows     = '1-44'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-tdu-part02' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0395/ROY-TDU.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0395/ROY-TDU.ANS'
            SourceRevision = 'archive-sha256:7b30118405d4d21f05022ba0c6f9cc20d209f8b3e8684cf8db7bf6713b2b2425'
            SourceSha256   = 'f6a581cd3525cfb3d632f1dd7046aed725d671dc8839fe1bb488cdbb9ecc2f1a'
            SourceRows     = '45-83'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-tdu-part03' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0395/ROY-TDU.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0395/ROY-TDU.ANS'
            SourceRevision = 'archive-sha256:7b30118405d4d21f05022ba0c6f9cc20d209f8b3e8684cf8db7bf6713b2b2425'
            SourceSha256   = 'f6a581cd3525cfb3d632f1dd7046aed725d671dc8839fe1bb488cdbb9ecc2f1a'
            SourceRows     = '84-122'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-tga' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac0396a/ROY-TGA.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac0396a/ROY-TGA.ANS'
            SourceRevision = 'archive-sha256:c3d9b108bac9f368f69bc8e60a13ba1af3964411e19719c53ca175ef47f6be86'
            SourceSha256   = '2c47f45cdaaf81775397e5f95bcf8332eaa9afcace90548cb554bf533c078846'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-trsi' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'sac1294/ROY-TRSI.ANS'
            SourceUrl      = 'https://16colo.rs/pack/sac1294/ROY-TRSI.ANS'
            SourceRevision = 'archive-sha256:4cf7765ee6660556cb900dacf0ec67f070b8e4df414172b5e01733a49d10031f'
            SourceSha256   = 'fe62af5c5c52ce9e02cc34cf006778fabfc6346212bbf36f8811dcf3a39e9499'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }

        'roy-sac-dgzn' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'ROY-DGZN.ANS'
            SourceUrl      = 'https://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP'
            SourceSha256   = 'acd1755ac10c8d9cc10e824a544c8ad5bb249f7ae363c9393f1f10e63377ff83'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-dimx' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'ROY-DIMX.ANS'
            SourceUrl      = 'https://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP'
            SourceSha256   = '961fe0e0f95af1eae3f9371ccabdd01e6559cb6ad9b2dae962e55f5dab5c47a7'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-faith' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'ROY-FAITH.ANS'
            SourceUrl      = 'https://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP'
            SourceSha256   = '3e160713c19211ecd322dcf5fd6a4a0acf559a4ae63abb260f422adf3de3ceb9'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-os-amiga-new' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'Roy-OS-AmigaNew.ANS'
            SourceUrl      = 'https://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP'
            SourceSha256   = '680b324dbe0ff7cae218b7bc76b5bc41102e39627f607a0e347f80459544d297'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
        'roy-sac-sky' = @{
            Collection     = 'roy-sac'
            SourceFile     = 'ROY-SKY.ANS'
            SourceUrl      = 'https://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP'
            SourceSha256   = '6f4c685f5429d0b750c3ee9cdb2084544384aec176ada5a91848d65eb12ce5b8'
            InputEncoding  = 'cp437'
            ConversionMode = 'TerminalEmulation'
        }
    }
}
