# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "Set-ProjectIteration" -Tag Build {

        $testcases = @(
            @{ 
                Organization  = "Contoso"
                Project       = "ADO-project"
                IterationPath = "\ADO-Project\Iteration\Database"
                StartDate     = "21-01-04"
                FinishDate    = "21-01-18"
            }
        )
        It "should update Board Iteration with dates" -TestCases $testcases {
            $BoardIteration = @{
                Organization  = $Organization 
                Project       = $Project 
                IterationPath = $IterationPath 
                StartDate     = $StartDate 
                FinishDate    = $FinishDate
            }
            Set-ProjectIteration @BoardIteration -WhatIf | Should -Not -BeNullOrEmpty
        }

        $testcases = @(
            @{ 
                Organization  = "Contoso"
                Project       = "ADO-project"
                IterationPath = "\ADO-Project\Iteration\Database"
            }
        )
        It "should update Board Iteration without dates" -TestCases $testcases {
            $BoardIteration = @{
                Organization  = $Organization 
                Project       = $Project 
                IterationPath = $IterationPath 
            }
            Set-ProjectIteration @BoardIteration -WhatIf | Should -Not -BeNullOrEmpty
        }
    }
}