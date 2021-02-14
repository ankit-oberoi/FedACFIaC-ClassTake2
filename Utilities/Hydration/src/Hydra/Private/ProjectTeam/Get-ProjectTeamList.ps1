
    <#
	.Synopsis
		Loads existing projects teams
	.Description
		Loads existing projects teams
	#>
function Get-ProjectTeamList {

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
        if ($pscmdlet.ShouldProcess("Teams of project [$Project]", 'Get')) {
            $items = az devops team list --org https://dev.azure.com/$Organization --project $Project  -o json
            if ($items) {
                return $items | ConvertFrom-Json -ErrorAction SilentlyContinue
            }
        }
        else {
            $s = @"
az devops team list `
    --org 'https://dev.azure.com/$Organization `
    --project $Project'
"@
            Write-Warning $s
            return $script:MOCK_OBJECTS.teams_project_list
        }
    }
}