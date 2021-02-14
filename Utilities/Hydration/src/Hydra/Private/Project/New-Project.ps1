<#
.SYNOPSIS
Creates a new Azure DevOps Project given parameter file

.DESCRIPTION
Creates a new Azure DevOps Project given parameter file

.PARAMETER HydrationDefinitionObj
Hydration definition object

.EXAMPLE
New-Project -Path $path

Create a new project using the given definitino object
#>
function New-Project {

    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([System.String])]
    param (
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Hydration definition object."
        )]
        [object] $HydrationDefinitionObj
    )

    process {
        Write-Verbose $HydrationDefinitionObj
        if ($pscmdlet.ShouldProcess('Project [{0}]' -f $HydrationDefinitionObj.projectName, 'Create')) {
            # az devops project create --name
            #              [--description]
            #              [--detect {false, true}]
            #              [--open]
            #              [--org]
            #              [--process]
            #              [--source-control {git, tfvc}]
            #              [--visibility {private, public}]
            az devops project create `
                --organization "https://dev.azure.com/$($HydrationDefinitionObj.organizationName)"  `
                --name "$($HydrationDefinitionObj.projectName)"  `
                --description "$($HydrationDefinitionObj.description)" `
                --process "$($HydrationDefinitionObj.process)" `
                --source-control "$($HydrationDefinitionObj.sourceControl)" `
                --visibility "$($HydrationDefinitionObj.visibility)" `
                -o json

            return $HydrationDefinitionObj
        }
        else {
            $s = @"
az devops project create `
    --organization 'https://dev.azure.com/$($HydrationDefinitionObj.organizationName)'  `
    --name '$($HydrationDefinitionObj.projectName)' `
    --description '$($HydrationDefinitionObj.description)' `
    --process '$($HydrationDefinitionObj.process)' `
    --source-control '$($HydrationDefinitionObj.sourceControl)' `
    --visibility '$($HydrationDefinitionObj.visibility)'
"@
            Write-Warning $s
            return $script:MOCK_OBJECTS.project_create
        }
    }

    end {

    }
}