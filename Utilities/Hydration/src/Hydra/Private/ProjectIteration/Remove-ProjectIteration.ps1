<#
    .SYNOPSIS
    Deletes an existng Iteration from a given Azure DevOps Project

    .DESCRIPTION
    Deletes an existng Iteration from a given Azure DevOps Project

    .PARAMETER Organization
    Organization Name

    .PARAMETER Project
    Project Name

    .PARAMETER IterationPath
    Full Iteration Path

    .EXAMPLE
    Remove-ProjectIteration -Organization Contoso -Project ADO-project -IterationPath Database

    Remove board iteration in path 'Database' from DevOps project 'ADO-project'
#>
function Remove-ProjectIteration {

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
            HelpMessage = "Azure DevOps Project Full Remove Path."
        )]
        [string] $IterationPath
    )

    process {

        $iterationName = $IterationPath.split('\')[$IterationPath.split('\').length - 1]

        Write-Verbose "Removing project iteration [$IterationPath]"
        if ($pscmdlet.ShouldProcess("Project iteration [$iterationName]", 'Remove')) {
            az boards iteration project delete `
                --organization "https://dev.azure.com/$Organization" `
                --project "$Project" `
                --path "$IterationPath" `
                --yes `
                -o json
        }
        else {
            $s = @"
az boards iteration project delete `
    --organization 'https://dev.azure.com/$Organization'  `
    --project '$Project' `
    --path '$IterationPath' `
    --yes
"@
            Write-Warning $s
            return $s
        }
    }
}