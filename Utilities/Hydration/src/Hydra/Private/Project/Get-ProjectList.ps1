<#
.Synopsis
    Loads existing projects for organization
.Description
    Loads existing projects for organization
#>
function Get-ProjectList {

    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([System.String])]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Azure DevOps Organization."
            )]
        [string] $Organization
    )
    process {
        if ($pscmdlet.ShouldProcess("Project list of organization [$Organization]", 'Get')) {
            $projects = az devops project list --org https://dev.azure.com/$Organization -o json
            if ($projects) {
                return $projects | ConvertFrom-Json -ErrorAction SilentlyContinue
            }
        }
        else {
            $s = @"
az devops project list `
    --org 'https://dev.azure.com/$Organization'
"@
            Write-Warning $s
            return  $script:MOCK_OBJECTS.project_list
        }
    }
}