# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "New-Repository" -Tag Build {

        $testcases = @(
            @{ 
                Organization   = "Contoso"
                Project        = "ADO-project"
                RepositoryName = "ContosoRepo"
            }
        )
        It "should create new repository" -TestCases $testcases {
            $Repository = @{
                Organization   = $Organization 
                Project        = $Project 
                RepositoryName = $RepositoryName
            }
            New-Repository @Repository -WhatIf | Should -Not -BeNullOrEmpty
        }
    }
}
