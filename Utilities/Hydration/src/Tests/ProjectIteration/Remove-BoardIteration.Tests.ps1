# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "Remove-ProjectIteration" -Tag Build {

        $testcases = @(
            @{ 
                Organization  = "Contoso"
                Project       = "ADO-project"
                IterationPath = "\ADO-Project\Iteration\Database"
            }
        )
        It "should remove Board Iteration" -TestCases $testcases {
            $BoardArea = @{
                Organization  = $Organization 
                Project       = $Project 
                IterationPath = $IterationPath
            }
            Remove-ProjectIteration @BoardArea -WhatIf | Should -Not -BeNullOrEmpty
        }
    }
}
