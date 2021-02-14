# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "Sync-ProjectIterations" -Tag Build {

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)
        $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $definitionFilePath

        $testcases = @(
            @{ 
                HydrationDefinitionObj = $definition
            }
        )
        It "should creating and removing project iterations" -TestCases $testcases {
            $check = @{
                HydrationDefinitionObj = $HydrationDefinitionObj
            }
            # TODO: This should be a more valid test..
            { Sync-ProjectIterations @check -WhatIf } | Should -Not -Throw
        }
    }
}