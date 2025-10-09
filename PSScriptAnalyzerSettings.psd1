# PSScriptAnalyzer Settings
# https://github.com/PowerShell/PSScriptAnalyzer

@{
    # Enable all rules by default
    IncludeDefaultRules = $true

    # Exclude specific rules if needed
    ExcludeRules        = @(
        'PSAvoidUsingWriteHost',                 # We intentionally use Write-Host for colorscripts
        'PSUseShouldProcessForStateChangingFunctions', # Already implemented where needed
        'PSAlignAssignmentStatement',            # Manifest files intentionally use standard formatting
        'PSUseBOMForUnicodeEncodedFile',         # UTF-8 without BOM is intentional for cross-platform scripts
        'PSUseDeclaredVarsMoreThanAssignments'  # False positives in some scripts
    )

    # Severity levels to include
    Severity            = @('Error', 'Warning', 'Information')

    # Rules configuration
    Rules               = @{
        PSPlaceOpenBrace                               = @{
            Enable             = $true
            OnSameLine         = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }

        PSPlaceCloseBrace                              = @{
            Enable             = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
            NoEmptyLineBefore  = $true
        }

        PSUseConsistentIndentation                     = @{
            Enable              = $true
            Kind                = 'space'
            PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
            IndentationSize     = 4
        }

        PSUseConsistentWhitespace                      = @{
            Enable                          = $true
            CheckInnerBrace                 = $true
            CheckOpenBrace                  = $true
            CheckOpenParen                  = $true
            CheckOperator                   = $false
            CheckPipe                       = $true
            CheckPipeForRedundantWhitespace = $true
            CheckSeparator                  = $true
            CheckParameter                  = $true
        }

        PSUseCorrectCasing                             = @{
            Enable = $true
        }

        PSProvideCommentHelp                           = @{
            Enable                  = $true
            ExportedOnly            = $true
            BlockComment            = $true
            VSCodeSnippetCorrection = $true
            Placement               = 'begin'
        }

        PSAvoidUsingCmdletAliases                      = @{
            Enable    = $true
            Allowlist = @()
        }

        PSAvoidUsingPositionalParameters               = @{
            Enable           = $true
            CommandAllowList = @()
        }

        PSAvoidGlobalVars                              = @{
            Enable = $true
        }

        PSAvoidUsingInvokeExpression                   = @{
            Enable = $true
        }

        PSAvoidUsingPlainTextForPassword               = @{
            Enable = $true
        }

        PSAvoidTrailingWhitespace                      = @{
            Enable = $true
        }

        PSUseOutputTypeCorrectly                       = @{
            Enable = $true
        }

        PSUseDeclaredVarsMoreThanAssignments           = @{
            Enable = $true
        }

        PSUsePSCredentialType                          = @{
            Enable = $true
        }

        PSUseUTF8EncodingForHelpFile                   = @{
            Enable = $true
        }

        PSAvoidDefaultValueSwitchParameter             = @{
            Enable = $true
        }

        PSAvoidLongLines                               = @{
            Enable            = $false
            MaximumLineLength = 1000
        }

        PSAvoidSemicolonsAsLineTerminators             = @{
            Enable = $true
        }

        PSAvoidUsingDoubleQuotesForConstantString      = @{
            Enable = $false
        }

        PSAvoidAssignmentToAutomaticVariable           = @{
            Enable = $true
        }

        PSAvoidOverwritingBuiltInCmdlets               = @{
            Enable            = $true
            PowerShellVersion = @('core-6.1.0-windows', 'core-6.1.0-linux')
        }

        PSReviewUnusedParameter                        = @{
            Enable             = $true
            CommandsToTraverse = @('*')
        }

        PSAvoidUsingEmptyCatchBlock                    = @{
            Enable = $true
        }

        PSAvoidNullOrEmptyHelpMessageAttribute         = @{
            Enable = $true
        }

        PSAvoidUsingConvertToSecureStringWithPlainText = @{
            Enable = $true
        }

        PSMisleadingBacktick                           = @{
            Enable = $true
        }

        PSPossibleIncorrectComparisonWithNull          = @{
            Enable = $true
        }

        PSPossibleIncorrectUsageOfRedirectionOperator  = @{
            Enable = $true
        }

        PSPossibleIncorrectUsageOfAssignmentOperator   = @{
            Enable = $true
        }

        PSUseApprovedVerbs                             = @{
            Enable = $true
        }

        PSUseSingularNouns                             = @{
            Enable        = $true
            NounAllowList = @()
        }

        PSReservedCmdletChar                           = @{
            Enable = $true
        }

        PSReservedParams                               = @{
            Enable = $true
        }

        PSUseCmdletCorrectly                           = @{
            Enable = $true
        }

        PSAvoidUsingWMICmdlet                          = @{
            Enable = $true
        }

        PSUseLiteralInitializerForHashtable            = @{
            Enable = $true
        }

        PSUseProcessBlockForPipelineCommand            = @{
            Enable = $true
        }

        PSUseSupportsShouldProcess                     = @{
            Enable = $true
        }

        PSUseCompatibleSyntax                          = @{
            Enable         = $true
            TargetVersions = @(
                '5.1',
                '7.0',
                '7.2'
            )
        }

        # PSUseCompatibleTypes                           = @{
        #     Enable         = $true
        #     TargetProfiles = @(
        #         'win-8_x64_10.0.17763.0_6.1.3_x64_4.0.30319.42000_core',
        #         'win-8_x64_10.0.17763.0_7.0.0_x64_3.1.2_core',
        #         'ubuntu_x64_18.04_7.0.0_x64_3.1.2_core'
        #     )
        # }

        # PSUseCompatibleCommands                        = @{
        #     Enable         = $true
        #     TargetProfiles = @(
        #         'win-8_x64_10.0.17763.0_6.1.3_x64_4.0.30319.42000_core',
        #         'win-8_x64_10.0.17763.0_7.0.0_x64_3.1.2_core',
        #         'ubuntu_x64_18.04_7.0.0_x64_3.1.2_core'
        #     )
        # }
    }
}
