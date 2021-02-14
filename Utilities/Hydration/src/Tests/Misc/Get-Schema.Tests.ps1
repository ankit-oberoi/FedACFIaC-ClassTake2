# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

Describe "Get-HydraSchema" -Tag Build {

    It "should return schema" {
        Get-HydraSchema  | Should -Not -BeNullOrEmpty
    }
}

