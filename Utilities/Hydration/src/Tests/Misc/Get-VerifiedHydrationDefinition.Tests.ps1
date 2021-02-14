. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {

    Describe "Get-VerifiedHydrationDefinition" -Tag Build {
    
        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)

        $testcases = @(
            @{           
                Path = $definitionFilePath
            }
        )
        It "should prase a valid file" -TestCases $testcases {
            $parse = @{
                Path = $Path
            }
            $definitionObject = Get-VerifiedHydrationDefinition @parse  

            $definitionObject | Should -Not -BeNullOrEmpty

            $definitionObject.projectName | Should -BeOfType "System.String"
            # TODO: Maybe add some more here
        }
    }
}
