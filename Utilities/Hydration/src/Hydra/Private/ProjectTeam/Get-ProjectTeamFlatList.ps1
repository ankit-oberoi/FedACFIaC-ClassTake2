<#
    .Synopsis
    Get the project teams as a flat list

    .Description
    Get the project teams as a flat list
#>
function Get-ProjectTeamFlatList {

    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Teams object structure."
        )]
        [object] $teamObj
    )
    process {
        if ($null -eq $List) {
            $List = @()
        }
        foreach ($team in $teamObj) {
            $List += [pscustomobject]@{Name = $team.name; Id = $team.id; Description = $team.description }
        }
        return $List
    }
}