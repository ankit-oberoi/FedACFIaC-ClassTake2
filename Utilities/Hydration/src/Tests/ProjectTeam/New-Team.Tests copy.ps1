# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "New-ProjectTeam" -Tag Build {

        $testcases = @(
            @{ 
                Organization  = "Contoso"
                Project       = "ADO-project"
                TeamName      = "Database Team"
                Description   = "Database Team description."
            }
        )
        It "should create new Team with description" -TestCases $testcases {
            $Team = @{
                Organization  = $Organization 
                Project       = $Project 
                Name          = $TeamName
                Description   = $Description 
            }
            New-ProjectTeam @Team -WhatIf | Should -Not -BeNullOrEmpty
        }

        $testcases = @(
            @{ 
                Organization  = "Contoso"
                Project       = "ADO-project"
                TeamName      = "Database Team"
            }
        )
        It "should create new Team without description" -TestCases $testcases {
            $Team = @{
                Organization  = $Organization 
                Project       = $Project 
                Name          = $TeamName
            }
            New-ProjectTeam @Team -WhatIf | Should -Not -BeNullOrEmpty
        }
    }
}