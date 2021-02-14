<#
    .SYNOPSIS
    Creates a new Team for a given Azure DevOps Project

    .DESCRIPTION
    Creates a new Team for a given Azure DevOps Project

    .PARAMETER Organization
    Azure DevOps Organization Name

    .PARAMETER Project
    Azure DevOps Project Name

    .PARAMETER Id
    Full Azure DevOps Project Team Id

    .PARAMETER Description
    Azure DevOps Project Team Description

    .EXAMPLE
    Set-ProjectTeam -Organization Contoso -Project ADO-project -Id '99999999-9999-9999-9999-999999999999' -Description 'Database Team Description'

    Update team of DevOps project 'ADO-project' with Id '99999999-9999-9999-9999-999999999999' with description 'Database Team Description'
#>
function Set-ProjectTeam {

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
            HelpMessage = "Azure DevOps Project Team Id."
        )]
        [string] $TeamId,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Azure DevOps Project Team Description"
        )]
        [string] $Description
    )

    process {

        Write-Verbose "Updating project team Id [$TeamId]"
        if ($pscmdlet.ShouldProcess("Project team [$TeamId]", 'Update')) {
            if ($Description) {
                az devops team update `
                    --organization "https://dev.azure.com/$Organization" `
                    --project "$Project" `
                    --team "$TeamId" `
                    --description "$Description" `
                    -o json
            }
            else {
                az devops team update `
                    --organization "https://dev.azure.com/$Organization" `
                    --project "$Project" `
                    --team "$TeamId" `
                    --description " " `
                    -o json
            }
        }
        else {
            $s = @"
az devops team update `
    --organization '$Organization'  `
    --project '$Project' `
    --team "$TeamId" `
    --description "$Description"
"@
            Write-Warning $s
            return $s
        }
    }
}