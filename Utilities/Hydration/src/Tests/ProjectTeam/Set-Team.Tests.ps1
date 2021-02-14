# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "Set-ProjectTeam" -Tag Build {

        $testcases = @(
            @{ 
                Organization  = "Contoso"
                Project       = "ADO-project"
                TeamId        = "123"
                Description   = "Database Team description."
            }
        )
        It "should update Team with description" -TestCases $testcases {
            $Team = @{
                Organization  = $Organization
                Project       = $Project
                TeamId        = $TeamId
                Description   = $Description
            }
            Set-ProjectTeam @Team -WhatIf | Should -Not -BeNullOrEmpty
        }

        $testcases = @(
            @{ 
                Organization  = "Contoso"
                Project       = "ADO-project"
                TeamId        = "123"
            }
        )
        It "should update Team without description" -TestCases $testcases {
            $Team = @{
                Organization  = $Organization 
                Project       = $Project 
                TeamId        = $TeamId
            }
            Set-ProjectTeam @Team -WhatIf | Should -Not -BeNullOrEmpty
        }
    }
}