# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {

    Describe "Get-Project" -Tag Build {

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)
        $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $definitionFilePath

        $testcases = @(
            @{ 
                HydrationDefinitionObj = $definition
            }
        )
        It "should check existing projects" -TestCases $testcases {
            $check = @{
                HydrationDefinitionObj = $HydrationDefinitionObj
            }
            #FIXME: This is not working
            # $existingProject = Get-Project @check  

            # $existingProject | Should -Not -BeNullOrEmpty

            # TODO: Maybe add some more here
        }
    }
}