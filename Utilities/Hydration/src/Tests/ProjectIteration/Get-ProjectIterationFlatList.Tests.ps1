# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {

    Describe "Get-ProjectIterationFlatList" -Tag Build {

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)
        $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $definitionFilePath

        $testcases = @(
            @{ 
                IterationObj = $definition.iterationPaths
                Path         = "\$($definition.projectName)\Iteration"
            }
        )
        It "should build iteration list" -TestCases $testcases {
            $buildAreaList = @{
                IterationObj = $IterationObj 
                Path         = $Path 
            }
            Get-ProjectIterationFlatList @buildAreaList  | Should -Not -BeNullOrEmpty
        }  
    }
}

