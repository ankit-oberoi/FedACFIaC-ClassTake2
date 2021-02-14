<#
    .SYNOPSIS
    Creates a new Iteration for a given Azure DevOps Project

    .DESCRIPTION
    Creates a new Iteration for a given Azure DevOps Project

    .PARAMETER Organization
    Organization Name

    .PARAMETER Project
    Project Name

    .PARAMETER IterationPath
    Full Iteration Name

    .PARAMETER StartDate
    Azure DevOps Project Iteration Start Date

    .PARAMETER FinishDate
    Azure DevOps Project Iteration Finish Date

    .EXAMPLE
    New-ProjectIteration -Organization Contoso -Project ADO-project -IterationPath \ADO-Project\Iteration\Database -StartDate 21-01-04 -FinishDate 21-01-18

    Create a new board iteration for project 'ADO-project' in path '\ADO-Project\Iteration\Database' using start date '21-01-04' and end date '21-01-18'
#>
function New-ProjectIteration {
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
            HelpMessage = "Azure DevOps Project IterationPath."
        )]
        [string] $IterationPath,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Azure DevOps Project Iteration Start Date."
        )]
        [string] $StartDate,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Azure DevOps Project Iteration Finish Date."
        )]
        [string] $FinishDate
    )

    process {

        $iterationName = $IterationPath.split('\')[$IterationPath.split('\').length - 1]
        $Path = $IterationPath -replace "$iterationName$", ''

        Write-Verbose "Adding project iteration [$iterationName] to path [$Path]"
        if ($pscmdlet.ShouldProcess("Project iteration [$iterationName]", 'Create')) {
            if ($StartDate -and $FinishDate) {
                az boards iteration project create `
                    --organization "https://dev.azure.com/$Organization" `
                    --project "$Project" `
                    --name "$iterationName" `
                    --path "$Path" `
                    --start-date "$StartDate" `
                    --finish-date "$FinishDate" `
                    -o json
            }
            else {
                az boards iteration project create `
                    --organization "https://dev.azure.com/$Organization" `
                    --project "$Project" `
                    --name "$iterationName" `
                    --path "$Path" `
                    -o json
            }
        }
        else {
            $s = @"
az boards iteration project create `
    --organization '$Organization'  `
    --project '$Project' `
    --name '$iterationName' `
    --path '$Path'
    --start-date "$StartDate" `
    --finish-date "$FinishDate"
"@
            Write-Warning $s
            return $script:MOCK_OBJECTS.boards_iteration_project_create
        }
    }
}