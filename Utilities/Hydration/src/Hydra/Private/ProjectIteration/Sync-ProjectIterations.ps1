. "$PSScriptRoot\Confirm-IterationIsEqual.ps1"
. "$PSScriptRoot\Get-ProjectIterationList.ps1"
. "$PSScriptRoot\Get-ProjectIterationFlatList.ps1"

<#
    .Synopsis
    Create or delete ADO Project Iterations

    .Description
    Create or delete ADO Project Iterations
#>
function Sync-ProjectIterations {
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
            HelpMessage = "Delete existing iterations not in Hydration definition."
        )]
        [boolean] $Force = $false
    )
    process {
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
        Write-Verbose  "Creating and removing project iterations"
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"

        # Get existing Iterations
        Write-Verbose  "    Loading iterations for project: $($HydrationDefinitionObj.projectName)"
        $existingIterationsObj = Get-ProjectIterationList -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName

        # Build full list of iterations to hydrate
        $iterations = Get-ProjectIterationFlatList -IterationObj $HydrationDefinitionObj.iterationPaths -Path "\$($HydrationDefinitionObj.projectName)\Iteration"

        # Build full list of existing iterations
        if ($existingIterationsObj.children) {
            $existingIterations = Get-ProjectIterationFlatList -IterationObj $existingIterationsObj.children -Path "\$($HydrationDefinitionObj.projectName)\Iteration"

            # get iterations for removal/update
            $iterationsToRemove = @()
            foreach ($iteration in $existingIterations) {
                if ($iterations.IterationPath -contains $iteration.IterationPath -and $Force) {
                    # should we update start end end date?
                    $start = ($iterations | Where-Object { $_.IterationPath -eq $iteration.IterationPath }).Start
                    if ($start) {
                        $start = [datetime]::ParseExact($start, 'yyyy-MM-dd', $null)
                    }
                    $end = ($iterations | Where-Object { $_.IterationPath -eq $iteration.IterationPath }).End
                    if ($end) {
                        $end = [datetime]::ParseExact($end, 'yyyy-MM-dd', $null)
                    }
                    if (-not (Confirm-IterationIsEqual -Start $start -End $end -Iteration $iteration)) {
                        Remove-ProjectIteration -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName -IterationPath $iteration.IterationPath
                        New-ProjectIteration -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName -IterationPath $iteration.IterationPath -StartDate $start -FinishDate $end
                    }
                }
                if (-not ($iterations.IterationPath -contains $iteration.IterationPath) -and $Force) {
                    # remove iteration not in hydration definition
                    $iterationsToRemove += [pscustomobject]@{Iteration = $iteration.IterationPath; Depth = $iteration.IterationPath.split('\').Length - 3 }
                }
            }
        }

        # remove iterations
        foreach ($removeIteration in $iterationsToRemove | Sort-Object -Property Depth, name –Descending ) {
            if ($PSCmdlet.ShouldProcess(("Iteration [{0}] from project [{1}] of organization [{2}]" -f $removeIteration.Iteration, $HydrationDefinitionObj.projectName, $HydrationDefinitionObj.organizationName), "Remove")) {
                Remove-ProjectIteration -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName -IterationPath $removeIteration.Iteration
            }
        }

        # check for add
        foreach ($iterationDef in $iterations) {
            if ($existingIterations.IterationPath -notcontains $iterationDef.IterationPath) {
                if ($PSCmdlet.ShouldProcess(("Iteration [{0}] with start [{1}] and end [{1}] to project [{2}] of organization [{3}]" -f $iterationDef.IterationPath, $iterationDef.Start, $iterationDef.End, $HydrationDefinitionObj.projectName, $HydrationDefinitionObj.organizationName), "Create")) {
                    New-ProjectIteration -Organization $HydrationDefinitionObj.organizationName -Project $HydrationDefinitionObj.projectName -IterationPath $iterationDef.IterationPath -StartDate $iterationDef.Start -FinishDate $iterationDef.End
                }
            }
        }

        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
        Write-Verbose  "Creating and removing project iterations completed"
        Write-Verbose  "-------------------------------------------------------------------------------------------------------------------"
    }
}