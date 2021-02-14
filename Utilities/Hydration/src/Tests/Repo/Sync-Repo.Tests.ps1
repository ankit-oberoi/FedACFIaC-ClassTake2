# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "Sync-Repo" -Tag Build {

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)
        $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $definitionFilePath

        $testcases = @(
            @{
                HydrationDefinitionObj = $definition
            }
        )
        It "should create or update ADO Repo" -TestCases $testcases {
            $check = @{
                HydrationDefinitionObj = $HydrationDefinitionObj
            }
            Sync-Repo @check -WhatIf | Should -Not -BeNullOrEmpty
        } 
    }
}
