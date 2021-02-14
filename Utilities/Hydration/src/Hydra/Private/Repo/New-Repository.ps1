<#
    .SYNOPSIS
    Creates a new Repo for a given Azure DevOps Project

    .DESCRIPTION
    Creates a new Repo for a given Azure DevOps Project

    .PARAMETER Organization
    Azure DevOps Organization Name

    .PARAMETER Project
    Azure DevOps Project Name

    .PARAMETER RepositoryName
    Azure DevOps Project Repository Name

    .EXAMPLE
    New-Repository -Organization Contoso -Project ADO-project -RepositoryName ContosoRepo

    Create a new repository for the DevOps project 'ADO-project' that goes by the name 'ContosoRepo'
#>
function New-Repository {

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
            HelpMessage = "Azure DevOps Project Repository Name."
        )]
        [string] $RepositoryName
    )

    process {

        Write-Verbose "Adding Repository [$RepositoryName] to project [$Project]"
        if ($pscmdlet.ShouldProcess("Repository [$RepositoryName]", 'Create')) {
            $repo = az repos create `
                --org "https://dev.azure.com/$Organization" `
                --project "$Project" `
                --name "$RepositoryName" `
                -o json
            return $repo
        }
        else {
            $s = @"
az repos create `
    --org '$Organization'
    --project '$Project'
    --name '$RepositoryName'
"@
            Write-Warning $s
            return $script:MOCK_OBJECTS.repo_create
        }
    }
}