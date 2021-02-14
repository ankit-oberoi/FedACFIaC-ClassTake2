. "$moduleRoot\Private\Shared\Get-RelativeConfigData.ps1"

<#
    .Synopsis
    Loads existing projects areas

    .Description
    Loads existing projects areas
#>
function Get-ProjectAreaList {

    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([System.String])]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Azure DevOps Organization."
        )]
        [string] $Organization,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Azure DevOps Project."
        )]
        [string] $Project
    )
    process {
        $depth = Get-RelativeConfigData -configToken 'project_list_depth'
        if ($pscmdlet.ShouldProcess("Areas of project [$Project]", 'Get')) {
            $boards = az boards area project list --depth $depth --org "https://dev.azure.com/$Organization" --project $Project  -o json
            if ($boards) {
                return $boards | ConvertFrom-Json -ErrorAction SilentlyContinue
            }
        }
        else {
            $s = @"
az boards area project list `
    --depth 10 `
    --org 'https://dev.azure.com/$Organization' `
    --project $Project'
"@
            Write-Warning $s
            return $script:MOCK_OBJECTS.boards_area_project_list
        }
    }
}