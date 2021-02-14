# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {

    Describe "Invoke-HydraTemplate WhatIf" -Tag Build {

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)

        $testcases = @(
            @{ Path = $definitionFilePath; Expected = $true }
        )
        It "should invoke hydration" -TestCases $testcases {
            Invoke-HydraTemplate -Path $path -WhatIf |
            Should -Not -BeNullOrEmpty
        }
    }

    Describe "Invoke-HydraTemplate Mocked" -Tag Build {

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)

        $testcases = @(
            @{ Path = $definitionFilePath; Expected = $true }
        )
        It "should invoke hydration" -TestCases $testcases {

            Mock Connect-DevOps { return "Login Mock invoked" } -ModuleName 'Hydra'
            Mock Sync-ProjectAreas { return $False } -ModuleName 'Hydra'
            Mock Sync-Project { return $False } -ModuleName 'Hydra'
            Mock Sync-ProjectIterations { return $False } -ModuleName 'Hydra'
            Mock Sync-ProjectTeams { return $False } -ModuleName 'Hydra'
            Mock Sync-Repo { return $False } -ModuleName 'Hydra'

            Invoke-HydraTemplate -Path $path

            Assert-MockCalled Connect-DevOps -Times 1 -ModuleName 'Hydra'
            Assert-MockCalled Sync-ProjectAreas  -Times 1 -ModuleName 'Hydra'
            Assert-MockCalled Sync-Project -Times 1 -ModuleName 'Hydra'
            Assert-MockCalled Sync-ProjectIterations  -Times 1 -ModuleName 'Hydra'
            Assert-MockCalled Sync-ProjectTeams  -Times 1 -ModuleName 'Hydra'
            Assert-MockCalled Sync-Repo -Times 1 -ModuleName 'Hydra'
        }
    }
}


