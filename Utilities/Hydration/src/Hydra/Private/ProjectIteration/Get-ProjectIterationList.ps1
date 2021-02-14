
    <#
	.Synopsis
		Loads existing projects iterations
	.Description
		Loads existing projects iterations
	#>
function Get-ProjectIterationList {

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
        if ($pscmdlet.ShouldProcess("Iterations of project [$Project]", 'Get')) {
            $iterations = az boards iteration project list --depth 10 --org https://dev.azure.com/$Organization --project $Project  -o json
            if ($iterations) {
                return $iterations | ConvertFrom-Json -ErrorAction SilentlyContinue
            }

        }
        else {
            $s = @"
az boards iteration project list `
    --depth 10 `
    --org 'https://dev.azure.com/$Organization `
    --project $Project'
"@
            Write-Warning $s
            return $script:MOCK_OBJECTS.boards_iteration_project_list
        }
    }
}