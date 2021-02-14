<#
    .Synopsis
    Checks if Project properties in hydration definition and in ADO are equal

    .Description
    Checks if Project properties in hydration definition and in ADO are equal
#>
function Confirm-ProjectIsEqual {

    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Hydration definition object."
        )]
        [object] $HydrationDefinitionObj,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Existing ADO Project object."
        )]
        [object] $ExistingProject
    )
    process {
        $equal = ($existingProject.name -ne $HydrationDefinitionObj.projectName `
                -or $existingProject.description -ne $HydrationDefinitionObj.description `
                -or $existingProject.capabilities.processTemplate.templateName -ne $HydrationDefinitionObj.process `
                -or $existingProject.capabilities.versioncontrol.sourceControlType -ne $HydrationDefinitionObj.sourceControl `
                -or $existingProject.visibility -ne $HydrationDefinitionObj.visibility)
        return $equal
    }
}