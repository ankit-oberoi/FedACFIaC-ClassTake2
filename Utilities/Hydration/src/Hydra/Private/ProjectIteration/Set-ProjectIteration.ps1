<#
    .SYNOPSIS
    Creates a new Iteration for a given Azure DevOps Project

    .DESCRIPTION
    Creates a new Iteration for a given Azure DevOps Project

    .PARAMETER Organization
    Azure DevOps Organization Name

    .PARAMETER Project
    Azure DevOps Project Name

    .PARAMETER IterationPath
    Full Azure DevOps Project Iteration Path

    .PARAMETER StartDate
    Azure DevOps Project Iterations Start Date

    .PARAMETER FinishDate
    Azure DevOps Project Iterations Finish Date

    .EXAMPLE
    Set-ProjectIteration -Organization Contoso -Project ADO-project -IterationPath '\ADO-Project\Iteration\Database' -StartDate 21-01-04 -FinishDate 21-01-18

    Update board iteration of DevOps project 'ADO-project' in path '\ADO-Project\Iteration\Database' with start date '21-01-04' and end date '21-01-18'
#>
function Set-ProjectIteration {

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

        Write-Verbose "Updating project iteration [$iterationName] to path [$Path]"
        if ($pscmdlet.ShouldProcess("Project iteration [$iterationName]", 'Update')) {
            if ($StartDate -and $FinishDate) {
                az boards iteration project update `
                    --organization "https://dev.azure.com/$Organization" `
                    --project "$Project" `
                    --name "$iterationName" `
                    --path "$Path" `
                    --start-date "$StartDate" `
                    --finish-date "$FinishDate" `
                    -o json
            }
            else {
                az boards iteration project update `
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
    '$startDateCmd' `
    '$finishDateCmd'
"@
            Write-Warning $s
            return $s
        }
    }
}