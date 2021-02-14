. "$PSScriptRoot\Get-ProjectList.ps1"

<#
    .Synopsis
    Checks existing projects

    .Description
    Checks existing projects
#>
function Get-Project {

    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([System.Boolean])]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Hydration definition object."
        )]
        [object] $HydrationDefinitionObj
    )

    process {
        if ($pscmdlet.ShouldProcess(('Project [{0}]' -f $HydrationDefinitionObj.projectName), 'Get')) {
            $existingProject = az devops project show --project "$($HydrationDefinitionObj.projectName)" --org "https://dev.azure.com/$($HydrationDefinitionObj.organizationName)"  -o json
            return $existingProject | ConvertFrom-Json -ErrorAction SilentlyContinue
        }
        else {
            $s = @"
az devops project show `
    --project "$($HydrationDefinitionObj.projectName)"
    --org 'https://dev.azure.com/$Organization'
"@
            Write-Warning $s
            return $script:MOCK_OBJECTS.project_list.value | Where-Object { $_.name -eq $HydrationDefinitionObj.projectName }
        }

    }
}