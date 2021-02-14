# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "New-ProjectArea" -Tag Build {

        $testcases = @(
            @{ 
                Organization = "Contoso"
                Project      = "ADO-project"
                AreaPath     = "Database"
            }
        )
        It "should create new Board Area" -TestCases $testcases {
            New-ProjectArea -Organization $Organization -Project $Project -AreaPath $AreaPath -WhatIf | Should -Not -BeNullOrEmpty
        }
    }
}

