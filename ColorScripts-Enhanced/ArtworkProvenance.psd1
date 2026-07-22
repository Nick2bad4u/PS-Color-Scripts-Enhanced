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
            Selection       = 'Seventeen visually distinct mature stage-3 plants selected from 72 ANSI scenes.'
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
            Selection       = 'Eight distinctive logos selected from 36 files after rendered-content comparison.'
            Transformation  = 'Decoded as UTF-8 and preserved in passthrough mode because the LF-only files are already formatted terminal streams.'
        }

        'roy-sac' = @{
            DisplayName          = 'Roy/SAC ANSI Art'
            ProjectUrl           = 'https://www.roysac.com/roy_ansishow.html'
            ArchiveUrl           = 'https://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP'
            ArchiveSha256        = '8598a9432b4feb86c4e79552795b407b9d7c576fb6f25e9828d6143f1c7b35bc'
            Attribution          = 'Roy/SAC aka Carsten Cumbrowski'
            License              = 'LicenseRef-Roy-SAC-Public-Domain'
            LicenseEvidence      = 'ThirdPartyNotices/roy-sac-public-domain.txt'
            PublicDomainEvidence = @(
                'https://www.roysac.com/blog/2006/07/important-decision-made-regarding-my-text-art/'
                'https://www.roysac.com/blog/2008/08/copyleft-vs-public-domain/'
            )
            Selection            = 'Five polished works selected from 183 Roy-authored ANSI files after rendered previews and size checks.'
            Transformation       = 'Decoded as CP437 and flattened through the bounded ANSI terminal emulator; valid SAUCE metadata was retained in comments.'
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

        'os-ansi-alpine' = @{
            Collection     = 'os-ansi'
            SourceFile     = 'alpine.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/info-mono/os-ansi/64449ace20798a2149eeb527e5cd16428f0b45e5/alpine.ansi'
            SourceSha256   = 'b95c0f4381e0f43240e27cf433d2e1552c874880450749b0d470a17f0fb08a48'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'os-ansi-freebsd' = @{
            Collection     = 'os-ansi'
            SourceFile     = 'freebsd.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/info-mono/os-ansi/64449ace20798a2149eeb527e5cd16428f0b45e5/freebsd.ansi'
            SourceSha256   = 'fd17eaee8524ac47a4b6aaa95cbf7d05501e386629fdd0817c5528d076873ea1'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'os-ansi-guix' = @{
            Collection     = 'os-ansi'
            SourceFile     = 'guix.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/info-mono/os-ansi/64449ace20798a2149eeb527e5cd16428f0b45e5/guix.ansi'
            SourceSha256   = 'fd16e9eaade5a0b1cb67a1d675e74dd5e2b7279a7d6a369e5710d4225beb485b'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'os-ansi-haiku' = @{
            Collection     = 'os-ansi'
            SourceFile     = 'haiku.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/info-mono/os-ansi/64449ace20798a2149eeb527e5cd16428f0b45e5/haiku.ansi'
            SourceSha256   = 'f8cbe9e5c78b0b82aa1e56e9e921d4f7240e16624f0c6bf5574d18a44b39bca6'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'os-ansi-nixos' = @{
            Collection     = 'os-ansi'
            SourceFile     = 'nixos.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/info-mono/os-ansi/64449ace20798a2149eeb527e5cd16428f0b45e5/nixos.ansi'
            SourceSha256   = '96bdbfd9b59dd84a687e73438cd7c3a6c8024c521af6537dac4a2080f3a286ec'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'os-ansi-openbsd' = @{
            Collection     = 'os-ansi'
            SourceFile     = 'openbsd.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/info-mono/os-ansi/64449ace20798a2149eeb527e5cd16428f0b45e5/openbsd.ansi'
            SourceSha256   = '4351b7bbb8224b70d45ec1c27481fe4b06ac4337d76c28e780930d9c7d2da2bc'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'os-ansi-popos' = @{
            Collection     = 'os-ansi'
            SourceFile     = 'popos.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/info-mono/os-ansi/64449ace20798a2149eeb527e5cd16428f0b45e5/popos.ansi'
            SourceSha256   = 'a0e398d22ed8a06551675b481f7bf09fe7471e34da12ba3c68f5b91f7653fa6c'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
        }
        'os-ansi-void' = @{
            Collection     = 'os-ansi'
            SourceFile     = 'void.ansi'
            SourceUrl      = 'https://raw.githubusercontent.com/info-mono/os-ansi/64449ace20798a2149eeb527e5cd16428f0b45e5/void.ansi'
            SourceSha256   = '0256261465e72935254f54ba69171110d740aac4f7a20e0f84b41fea4550c50f'
            InputEncoding  = 'utf8'
            ConversionMode = 'Passthrough'
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
