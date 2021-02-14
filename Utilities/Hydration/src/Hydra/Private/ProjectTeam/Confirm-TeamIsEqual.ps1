<#
    .Synopsis
    Checks if team properties in hydration definition and in ADO are equal

    .Description
    Checks if team properties in hydration definition and in ADO are equal
#>
function Confirm-TeamIsEqual {

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Hydration Description."
        )]
        [object] $Description,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Existing Team object."
        )]
        [object] $Team
    )

    process {
        if ($Team.Description) {
            $existingDescription = $Team.Description
        }

        $equal = $existingDescription -eq $Description
        return $equal
    }
}