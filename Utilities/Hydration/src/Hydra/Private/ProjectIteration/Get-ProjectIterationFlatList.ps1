<#
    .Synopsis
    Get the project iterations as a flat list

    .Description
    Get the project iterations as a flat list
#>
function Get-ProjectIterationFlatList {

    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Iteration object structure."
        )]
        [object] $IterationObj,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Full Iteration Path."
        )]
        [string] $Path,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Iteration List."
        )]
        [object] $List
    )
    process {
        if ($null -eq $List) {
            $List = @()
        }
        foreach ($iteration in $IterationObj) {
            $iterationPath = "$Path\$($iteration.name)"
            $List += [pscustomobject]@{IterationPath = $iterationPath; Depth = $iterationPath.split('\').Length - 3; Start = $iteration.attributes.startDate; End = $iteration.attributes.finishDate }
            if ($iteration.children) {
                $List += Get-ProjectIterationFlatList $iteration.children $iterationPath
            }
        }
        return $List
    }
}