# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

Describe "Test-HydraTemplate" -Tag Build {

    $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
    $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)

    $testcases = @(
        @{ Path = $definitionFilePath; Expected = $true }
    )
    It "should validate definition" -TestCases $testcases {
        
        Test-HydraTemplate $path | Should -Be $expected
    }
}

