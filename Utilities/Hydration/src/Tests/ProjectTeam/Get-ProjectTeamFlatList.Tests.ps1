# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {

    Describe "Get-ProjectTeamFlatList" -Tag Build {

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)
        $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $definitionFilePath

        $testcases = @(
            @{ 
                TeamObj = $definition.teams
            }
        )
        It "should build team list" -TestCases $testcases {
            $buildTeamList = @{
                TeamObj = $TeamObj 
            }
            Get-ProjectTeamFlatList @buildTeamList  | Should -Not -BeNullOrEmpty
        }  
    }
}

