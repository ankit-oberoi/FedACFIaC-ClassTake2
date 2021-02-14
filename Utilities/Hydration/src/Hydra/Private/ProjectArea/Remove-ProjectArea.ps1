<#
    .SYNOPSIS
    Deletes an existng Area from a given Azure DevOps Project

    .DESCRIPTION
    Deletes an existng Area from a given Azure DevOps Project

    .PARAMETER Organization
    Organization Name

    .PARAMETER Project
    Project Name

    .PARAMETER AreaPath
    Full Area Path

    .EXAMPLE
    Remove-ProjectArea -Organization Contoso -Project ADO-project -AreaPath Database

    Remove board area 'Database' from AzureDevOps Project 'Database'
#>
function Remove-ProjectArea {

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
            HelpMessage = "Azure DevOps Project Full Area Path."
        )]
        [string] $AreaPath
    )

    process {

        Write-Verbose "Removing project area [$AreaPath]"
        if ($pscmdlet.ShouldProcess("Project area [$AreaPath]", 'Remove')) {
            az boards area project delete `
                --organization "https://dev.azure.com/$Organization" `
                --project "$Project" `
                --path "$AreaPath" `
                --yes `
                -o json
        }
        else {
            $s = @"
az boards area project delete `
    --organization 'https://dev.azure.com/$Organization'  `
    --project '$Project' `
    --path '$AreaPath' `
    --yes
"@
            Write-Warning $s
            return $s
        }
    }
}