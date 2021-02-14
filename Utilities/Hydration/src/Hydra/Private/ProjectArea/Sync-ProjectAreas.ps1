. "$PSScriptRoot\Get-ProjectAreaList.ps1"
. "$PSScriptRoot\Get-ProjectAreaFlatList.ps1"

<#
    .Synopsis
    Create or delete ADO Project Areas

    .Description
    Create or delete ADO Project Areas
#>
function Sync-ProjectAreas {

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
            HelpMessage = "Delete existing areas not in Hydration definition."
        )]
        [boolean] $Force = $false
    )
    process {
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
        Write-Verbose  "Creating and removing project areas"
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"

        # Get existing areas
        Write-Verbose  "    Loading areas for project: $($HydrationDefinitionObj.projectName)"
        $existingAreasObj = Get-ProjectAreaList -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName

        # Build full list of areas to hydrate
        $areas = Get-ProjectAreaFlatList -AreaObj $HydrationDefinitionObj.areaPaths -Path "\$($HydrationDefinitionObj.projectName)\Area"

        # Build full list of existing areas to hydrate
        if ($existingAreasObj.children) {
            $existingAreas = Get-ProjectAreaFlatList -AreaObj $existingAreasObj.children -Path "\$($HydrationDefinitionObj.projectName)\Area"

            # get areas for removal
            $areasToRemove = @()
            foreach ($area in $existingAreas) {
                if (-not ($areas -contains $area) -and $Force) {
                    $areasToRemove += [pscustomobject]@{Area = $area; Depth = $area.split('\').Length - 3 }
                }
            }
        }

        # remove areas
        foreach ($removeArea in $areasToRemove | Sort-Object -Property Depth, name –Descending ) {
            if ($PSCmdlet.ShouldProcess(("Area [{0}] from project [{1}] of organization [{2}]" -f $removeArea.Area, $HydrationDefinitionObj.projectName, $HydrationDefinitionObj.organizationName), "Remove")) {
                Remove-ProjectArea -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName -AreaPath $removeArea.Area
            }
        }

        # check for adding
        foreach ($areaDef in $areas) {
            if ($existingAreas -notcontains $areaDef) {
                if ($PSCmdlet.ShouldProcess(("Area [{0}] to project [{1}] of organization [{2}]" -f $areaDef, $HydrationDefinitionObj.projectName, $HydrationDefinitionObj.organizationName), "Create")) {
                    New-ProjectArea -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName -AreaPath $areaDef
                }
            }
        }

        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
        Write-Verbose  "Creating and removing project areas completed"
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
    }
}