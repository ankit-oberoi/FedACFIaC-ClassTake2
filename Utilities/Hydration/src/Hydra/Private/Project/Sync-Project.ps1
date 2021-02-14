. "$PSScriptRoot\Get-Project.ps1"

<#
    .Synopsis
    Create or update ADO Project

    .Description
    Create or update ADO Project
#>
function Sync-Project {

    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([System.String])]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Hydration definition object."
        )]
        [object] $HydrationDefinitionObj,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Update ADO Project if already exists."
        )]
        [boolean] $Force = $false
    )
    process {
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
        Write-Verbose  "Creating or updating ADO Project"
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"

        # Check ADO Project exists
        ## Temp solution until wrapping az devops commands using Invoke-Command
        $existingProjects = Get-ProjectList $HydrationDefinitionObj.organizationName
        # list projects
        $exists = $false
        foreach ($project in $existingProjects.value) {
            if ($project.name -eq $HydrationDefinitionObj.projectName) {
                $exists = $true
                break
            }
        }

        if ($exists) {
            $existingProject = Get-Project $HydrationDefinitionObj
        }

        if (-not $existingProject) {

            Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
            Write-Verbose  "Creating ADO Project"
            Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"

            if ($pscmdlet.ShouldProcess(('Project [{0}] in organization [{1}]' -f $HydrationDefinitionObj.projectName, $HydrationDefinitionObj.organizationName), 'Create')) {
                New-Project -HydrationDefinitionObj $HydrationDefinitionObj
            }
            else {
                New-Project -HydrationDefinitionObj $HydrationDefinitionObj -WhatIf
            }
        }
        else {

            if ($Force -and (Confirm-ProjectIsEqual -HydrationDefinitionObj $HydrationDefinitionObj -ExistingProject $existingProject)) {

                # to-do: update existing project parameters

                Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
                Write-Verbose  "Updating existing ADO Project"
                Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"

            }
        }

        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
        Write-Verbose  "Creating or updating ADO Project completed"
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
    }
}