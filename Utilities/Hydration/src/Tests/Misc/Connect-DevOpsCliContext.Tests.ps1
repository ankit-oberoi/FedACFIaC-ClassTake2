# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {

    Describe "Connect-DevOps" -Tag Build {
    
        It "should prompt for login" {
            Connect-DevOps -WhatIf
        }
    }
}