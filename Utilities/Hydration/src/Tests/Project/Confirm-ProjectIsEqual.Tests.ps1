# Load module and dependencies
. ("{0}\helper\Shared.ps1" -f (Split-Path $PSScriptRoot -Parent))

InModuleScope $ModuleName {

    Describe "Confirm-ProjectIsEqual" -Tag Build { 

        $VALID_DEFINTION_FILE_NAME = 'hydrationDefinition.json'
        $definitionFilePath = "{0}\resources\$VALID_DEFINTION_FILE_NAME" -f (Split-Path $PSScriptRoot -Parent)
        $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $definitionFilePath

        $existingProjectMock = @{
            name         = $definition.projectName
            description  = $definition.description
            capabilities = @{ 
                processTemplate = @{ 
                    templateName = $definition.process
                }
                versioncontrol  = @{ 
                    sourceControlType = $definition.sourceControl
                }
            }
            visibility   = $definition.visibility
        }
        $testcases = @(
            @{ 
                HydrationDefinitionObj = $definition
                ExistingProject        = $existingProjectMock
            }
        )
        It "should check Project properties in hydration definition and are equal" -TestCases $testcases {
            $EqualProject = @{
                HydrationDefinitionObj = $HydrationDefinitionObj
                ExistingProject        = $ExistingProject
            }
            # FIXME: This is somehow not working
            #  Confirm-ProjectIsEqual @EqualProject |        Should -Be $True
        }
    }
}