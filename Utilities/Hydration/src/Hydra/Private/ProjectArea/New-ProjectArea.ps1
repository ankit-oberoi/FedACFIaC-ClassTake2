<#
.SYNOPSIS
    Creates a new Area for a given Azure DevOps Project

    .DESCRIPTION
    Creates a new Area for a given Azure DevOps Project

    .PARAMETER Organization
    Azure DevOps Organization Name

    .PARAMETER Project
    Azure DevOps Project Name

    .PARAMETER AreaPath
    Azure DevOps Project AreaPath NAme

    .EXAMPLE
    New-ProjectArea -Organization Contoso -Project ADO-project -AreaPath 'Database'

    Create a new area for project 'ADO-project' in AreaPath 'Database'
#>
function New-ProjectArea {

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
            HelpMessage = "Azure DevOps Project AreaPath."
        )]
        [string] $AreaPath
    )

    process {

        $areaName = $AreaPath.split('\')[$AreaPath.split('\').length - 1]
        $Path = $AreaPath -replace "$areaName$", ''

        Write-Verbose "Adding project area $areaName to path $Path"
        if ($pscmdlet.ShouldProcess("Project area [$areaName]", 'Create')) {
            $boardArea = az boards area project create `
                --organization "https://dev.azure.com/$Organization" `
                --project "$Project" `
                --name "$areaName" `
                --path "$Path" `
                -o json
            return $boardArea
        }
        else {
            $s = @"
az boards area project create `
    --organization '$Organization'  `
    --project '$Project' `
    --name '$areaName' `
    --path '$Path'
"@
            Write-Warning $s
            return $script:MOCK_OBJECTS.boards_area_project_create
        }
    }
}