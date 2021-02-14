<#
    .SYNOPSIS
    Creates a new Team for a given Azure DevOps Project

    .DESCRIPTION
    Creates a new Team for a given Azure DevOps Project

    .PARAMETER Organization
    Organization Name

    .PARAMETER Project
    Project Name

    .PARAMETER Name
    Team  Name

    .PARAMETER Description
    Azure DevOps Project Team Description

    .EXAMPLE
    New-ProjectTeam -Organization Contoso -Project ADO-project -Name 'Database Team' -Descripton 'Database Team Description'

    Create a new team for project 'ADO-project' using name 'Database Team' using description 'Database Team Description'
#>
function New-ProjectTeam {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([System.String])]
    param (
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Azure DevOps Organization."
        )]
        [string] $Organization,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Azure DevOps Project."
        )]
        [string] $Project,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Azure DevOps Project Team Name."
        )]
        [string] $Name,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Azure DevOps Project Team Description."
        )]
        [string] $Description
    )

    process {
        Write-Verbose "Adding project team [$Name]"
        if ($pscmdlet.ShouldProcess("Project team [$Name]", 'Create')) {
            if ($Description) {
                az devops team create `
                    --organization "https://dev.azure.com/$Organization" `
                    --project "$Project" `
                    --name "$Name" `
                    --description "$Description" `
                    -o json
            }
            else {
                az devops team create `
                    --organization "https://dev.azure.com/$Organization" `
                    --project "$Project" `
                    --name "$Name" `
                    -o json
            }
        }
        else {
            $s = @"
az devops team create `
    --organization '$Organization'  `
    --project '$Project' `
    --name "$Name" `
    --description "$Description"
"@
            Write-Warning $s
            return $script:MOCK_OBJECTS.team_project_create
        }
    }
}