# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "New-ProjectIteration" -Tag Build {

        $testcases = @(
            @{ 
                Organization  = "Contoso"
                Project       = "ADO-project"
                IterationPath = "\ADO-Project\Iteration\Database"
                StartDate     = "21-01-04"
                FinishDate    = "21-01-18"
            }
        )
        It "should create new Board Iteration" -TestCases $testcases {
            $BoardIteration = @{
                Organization  = $Organization 
                Project       = $Project 
                IterationPath = $IterationPath 
                StartDate     = $StartDate 
                FinishDate    = $FinishDate
            }
            New-ProjectIteration @BoardIteration -WhatIf | Should -Not -BeNullOrEmpty
        }
    }
}