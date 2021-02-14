# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "New-Project" -Tag Build {
    
        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)
        $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $definitionFilePath
    
        $testcases = @(
            @{ definition = $definition; Expected = $true }
        )
        It "should create new project" -TestCases $testcases {
            New-Project -HydrationDefinitionObj $definition -WhatIf | Should -Not -BeNullOrEmpty
        }
    }
}
