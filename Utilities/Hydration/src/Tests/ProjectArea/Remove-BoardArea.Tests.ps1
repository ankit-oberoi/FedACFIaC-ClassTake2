# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "Remove-ProjectArea" -Tag Build {

        $testcases = @(
            @{ 
                Organization = "Contoso"
                Project      = "ADO-project"
                AreaPath     = "Database"
            }
        )
        It "should remove Board Area" -TestCases $testcases {
            $BoardArea = @{
                Organization = $Organization 
                Project      = $Project 
                AreaPath     = $AreaPath
            }
            Remove-ProjectArea @BoardArea -WhatIf | Should -Not -BeNullOrEmpty
        }
    }
}