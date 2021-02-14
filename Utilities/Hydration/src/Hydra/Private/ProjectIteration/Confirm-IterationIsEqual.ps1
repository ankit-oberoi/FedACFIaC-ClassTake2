<#
    .Synopsis
    Checks if iteration properties in hydration definition and in ADO are equal

    .Description
    Checks if iteration properties in hydration definition and in ADO are equal
#>
function Confirm-IterationIsEqual {

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Hydration StartDate."
        )]
        [object] $Start,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Hydration FinishDate."
        )]
        [object] $End,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Existing Iteration object."
        )]
        [object] $Iteration
    )

    process {
        if ($Iteration.Start) {
            $existingStart = $Iteration.Start.date
        }
        if ($Iteration.End) {
            $existingEnd = $Iteration.End.Date
        }

        $equal = $existingStart -eq $Start -and $existingEnd -eq $End
        return $equal
    }
}