. "$PSScriptRoot\Confirm-TeamIsEqual.ps1"
. "$PSScriptRoot\Get-ProjectTeamList.ps1"
. "$PSScriptRoot\Get-ProjectTeamFlatList.ps1"

<#
    .Synopsis
    Create or delete ADO Project Teams

    .Description
    Create or delete ADO Project Teams
#>
function Sync-ProjectTeams {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([System.String])]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Hydration definition object."
        )]
        [object] $HydrationDefinitionObj,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Delete existing teams not in Hydration definition."
        )]
        [boolean] $Force = $false
    )
    process {
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
        Write-Verbose  "Creating and removing project teams"
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"

        # Get existing Teams
        Write-Verbose  "    Loading teams for project: $($HydrationDefinitionObj.projectName)"
        $existingTeamsObj = Get-ProjectTeamList -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName

        # Build full list of teams to hydrate
        $teams = Get-ProjectTeamFlatList -TeamObj $HydrationDefinitionObj.teams

        # Build full list of existing teams
        if ($existingTeamsObj.Length -gt 0) {
            $existingTeams = Get-ProjectTeamFlatList -TeamObj $existingTeamsObj

            # get teams for removal/update
            $teamsToRemove = @()
            foreach ($team in $existingTeams) {
                if ($teams.Name -contains $team.Name -and $Force) {
                    # should we update description?
                    $description = ($teams | Where-Object { $_.Name -eq $team.Name }).Description
                    if (-not (Confirm-TeamIsEqual -Description $description -Team $team)) {
                        Set-ProjectTeam -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName -TeamId $team.id -Description $description
                    }
                }
                if (-not ($teams.Name -contains $team.Name) -and $Force) {
                    # remove team not in hydration definition
                    $teamsToRemove += $team.Id
                }
            }
        }

        # remove teams
        foreach ($removeTeam in $teamsToRemove ) {
            if ($PSCmdlet.ShouldProcess(("Team [{0}] from project [{1}] of organization [{2}]" -f $removeTeam.Name, $HydrationDefinitionObj.projectName, $HydrationDefinitionObj.organizationName), "Remove")) {
                Remove-ProjectTeam -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName -TeamId $removeTeam
            }
        }

        # check for add
        foreach ($teamDef in $teams) {
            if ($existingTeams.Name -notcontains $teamDef.Name) {
                if ($PSCmdlet.ShouldProcess(("Team [{0}] with description [{1}] to project [{2}] of organization [{3}]" -f $teamDef.Name, $teamDef.Description, $HydrationDefinitionObj.projectName, $HydrationDefinitionObj.organizationName), "Create")) {
                    New-ProjectTeam -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName -Name $teamDef.Name -Description $teamDef.Description
                }
            }
        }

        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
        Write-Verbose  "Creating and removing project teams completed"
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
    }
}