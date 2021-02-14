<#
    .Synopsis
    Create or update ADO Repo

    .Description
    Create or update ADO Repo
#>
function Sync-Repo {

    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([System.String])]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Hydration definition object."
        )]
        [object] $HydrationDefinitionObj
    )

    process {
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
        Write-Verbose  "Creating ADO Repo"
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"

        if ($pscmdlet.ShouldProcess(('Repository [{0}] to project [{1}] of organization [{2}]' -f $HydrationDefinitionObj.RepositoryName, $HydrationDefinitionObj.projectName, $HydrationDefinitionObj.organizationName), 'Create')) {
            New-Repository -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName -RepositoryName $HydrationDefinitionObj.RepositoryName
        }
        else {
            New-Repository -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName -RepositoryName $HydrationDefinitionObj.RepositoryName -WhatIf
        }
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
        Write-Verbose  "Creating ADO Repo completed"
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
    }
}