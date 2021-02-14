# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "Remove-ProjectTeam" -Tag Build {

        $testcases = @(
            @{ 
                Organization  = "Contoso"
                Project       = "ADO-project"
                TeamId        = "123"
            }
        )
        It "should remove Team" -TestCases $testcases {
            $BoardArea = @{
                Organization  = $Organization 
                Project       = $Project 
                TeamId        = $TeamId
            }
            Remove-ProjectTeam @BoardArea -WhatIf | Should -Not -BeNullOrEmpty
        }
    }
}
