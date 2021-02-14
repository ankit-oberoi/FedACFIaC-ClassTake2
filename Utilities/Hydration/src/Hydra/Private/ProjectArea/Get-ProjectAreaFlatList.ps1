<#
    .Synopsis
    Get the project areas as a flat list

    .Description
    Get the project areas as a flat list
#>
function Get-ProjectAreaFlatList {

    [CmdletBinding()]
    [OutputType([System.String[]])]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Area object structure."
        )]
        [object] $AreaObj,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Full Area Path."
        )]
        [string] $Path,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Area List."
        )]
        [System.String[]] $List
    )
    process {
        if ($null -eq $List) {
            $List = @()
        }
        foreach ($area in $AreaObj) {
            $List += "$Path\$($area.name)"
            if ($area.children) {
                $List += Get-ProjectAreaFlatList $area.children "$Path\$($area.name)"
            }
        }
        return $List
    }
}