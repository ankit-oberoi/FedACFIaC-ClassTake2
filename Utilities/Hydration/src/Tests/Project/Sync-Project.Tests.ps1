# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "Sync-Project" -Tag Build {

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)
        $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $definitionFilePath

        $testcases = @(
            @{ 
                HydrationDefinitionObj = $definition
            }
        )
        It "should update ADO Project" -TestCases $testcases {
            $check = @{
                HydrationDefinitionObj = $HydrationDefinitionObj
            }
            { Sync-Project @check -WhatIf } | Should -Not -Throw
        }  
        
        It "should create ADO Project" -TestCases $testcases {
            $check = @{
                HydrationDefinitionObj = $HydrationDefinitionObj
            }
            $check.HydrationDefinitionObj.projectName = 'nonexistend'
            Sync-Project @check -WhatIf | Should -Not -BeNullOrEmpty
        }  
    }
}
