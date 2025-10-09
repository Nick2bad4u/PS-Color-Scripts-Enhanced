# PSScriptAnalyzer Settings
# https://github.com/PowerShell/PSScriptAnalyzer

@{
    # Enable all rules by default
    IncludeDefaultRules = $true
    
    # Exclude specific rules if needed
    ExcludeRules = @(
        'PSAvoidUsingWriteHost',  # We intentionally use Write-Host for colorscripts
        'PSUseShouldProcessForStateChangingFunctions'  # Already implemented where needed
    )
    
    # Severity levels to include
    Severity = @('Error', 'Warning', 'Information')
    
    # Rules configuration
    Rules = @{
        PSPlaceOpenBrace = @{
            Enable = $true
            OnSameLine = $true
            NewLineAfter = $true
            IgnoreOneLineBlock = $true
        }
        
        PSPlaceCloseBrace = @{
            Enable = $true
            NewLineAfter = $true
            IgnoreOneLineBlock = $true
            NoEmptyLineBefore = $false
        }
        
        PSUseConsistentIndentation = @{
            Enable = $true
            Kind = 'space'
            PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
            IndentationSize = 4
        }
        
        PSUseConsistentWhitespace = @{
            Enable = $true
            CheckInnerBrace = $true
            CheckOpenBrace = $true
            CheckOpenParen = $true
            CheckOperator = $true
            CheckPipe = $true
            CheckPipeForRedundantWhitespace = $false
            CheckSeparator = $true
            CheckParameter = $false
        }
        
        PSAlignAssignmentStatement = @{
            Enable = $true
            CheckHashtable = $true
        }
        
        PSUseCorrectCasing = @{
            Enable = $true
        }
        
        PSProvideCommentHelp = @{
            Enable = $true
            ExportedOnly = $true
            BlockComment = $true
            VSCodeSnippetCorrection = $true
            Placement = 'begin'
        }
    }
}
