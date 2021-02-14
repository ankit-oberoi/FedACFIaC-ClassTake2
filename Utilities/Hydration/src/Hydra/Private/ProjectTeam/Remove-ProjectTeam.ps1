<#
    .SYNOPSIS
    Deletes an existng Team from a given Azure DevOps Project

    .DESCRIPTION
    Deletes an existng Team from a given Azure DevOps Project

    .PARAMETER Organization
    Organization Name

    .PARAMETER Project
    Project Name

    .PARAMETER TeamId
    TeamId

    .EXAMPLE
    Remove-ProjectTeam -Organization Contoso -Project ADO-project -TeamId '99999999-9999-9999-9999-999999999999'

    Remove team with Id '99999999-9999-9999-9999-999999999999' from DevOps project 'ADO-project'
#>
function Remove-ProjectTeam {

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
            HelpMessage = "Azure DevOps Team Id."
        )]
        [string] $TeamId
    )

    process {
        Write-Verbose "Removing project team Id [$TeamId]"
        if ($pscmdlet.ShouldProcess("Project team [$TeamId]", 'Remove')) {
            az devops team delete `
                --organization "https://dev.azure.com/$Organization" `
                --project "$Project" `
                --id "$TeamId" `
                --yes `
                -o json
        }
        else {
            $s = @"
az devops team delete `
    --organization 'https://dev.azure.com/$Organization'  `
    --project '$Project' `
    --id "$TeamId" `
    --yes
"@
            Write-Warning $s
            return $s
        }
    }
}