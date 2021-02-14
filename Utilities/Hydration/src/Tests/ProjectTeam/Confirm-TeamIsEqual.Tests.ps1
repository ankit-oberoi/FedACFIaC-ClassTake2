# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "Confirm-TamIsEqual" -Tag Build { 
        $description = "Team description."
        $testcases = @(
            @{ 
                Description     = $description
                Team = @{
                    Description = $description
                }
            }
        )
        It "should check team properties" -TestCases $testcases {
            $TeamEqual = @{
                Description     = $description
                Team = $Team
            }
            Confirm-TeamIsEqual @TeamEqual | Should -Be $True
        }
    }
}
