# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {
    Describe "Confirm-IterationIsEqual" -Tag Build { 
        $startDate = "2020-01-01"
        $endDate = "2020-12-32"
        $testcases = @(
            @{ 
                Start     = $startDate
                End       = $endDate
                Iteration = @{
                    Start = @{
                        date = $startDate
                    }
                    End   = @{
                        date = $endDate
                    }
                }
            }
        )
        It "should check project properties" -TestCases $testcases {
            $IterationEqual = @{
                Start     = $Start
                End       = $End
                Iteration = $Iteration
            }
            Confirm-IterationIsEqual @IterationEqual | Should -Be $True
        }
    }
}
