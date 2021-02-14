# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {

    Describe "Get-ProjectIterationList" -Tag Build {

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)
        $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $definitionFilePath

        $testcases = @(
            @{ 
                Organization = $definition.organizationName
                Project      = $definition.projectName
            }
        )
        It "should list project iteration" -TestCases $testcases {
            $ProjectIterationsList = @{
                Organization = $Organization
                Project      = $Project
            }
            Get-ProjectIterationList @ProjectIterationsList -WhatIf | Should -Not -BeNullOrEmpty
        }
    }
}
