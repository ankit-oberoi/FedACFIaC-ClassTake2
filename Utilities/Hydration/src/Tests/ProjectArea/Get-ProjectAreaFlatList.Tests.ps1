# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "Get-ProjectAreaFlatList" -Tag Build {

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)
        $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $definitionFilePath

        $testcases = @(
            @{ 
                AreaObj = $definition.areaPaths
                Path    = "\$($definition.projectName)\Area"
            }
        )

        It "should build area list" -TestCases $testcases {
            $buildAreaList = @{
                AreaObj = $AreaObj 
                Path    = $Path 
            }
            Get-ProjectAreaFlatList @buildAreaList  | Should -Not -BeNullOrEmpty
        }
    }
}
