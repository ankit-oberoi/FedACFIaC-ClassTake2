# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {

    Describe "Get-ProjectList" -Tag Build {

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)
        $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $definitionFilePath

        $testcases = @(
            @{ 
                Organization = $definition.organizationName
            }
        )
        It "should list projects" -TestCases $testcases {
            $ProjectList = @{
                Organization = $Organization
            }
            Get-ProjectList @ProjectList -WhatIf | Should -Not -BeNullOrEmpty
        }  
    }
}