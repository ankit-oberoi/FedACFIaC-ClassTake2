<#
    .SYNOPSIS
    Invokes the hydration given the definition file.
    Creates Azure DevOps resources based on a hydration definition file that matches a given schema.

    1. Run `Get-AzHydrationSchema` and create a definition file based on the given JSON schema you can find an example in [hydrationDefinition.json](../src/Tests/hydrationDefinition.json)
    2. Run `Test-AzHydrationTemplate` to validate the create definition template against the schema
    3. Run `Invoke-AzHydrationTemplate` to run the actual hydration
    4. Login to Azure DevOps
        1. The user is prompted to [login with a personal access token](https://docs.microsoft.com/en-us/azure/devops/cli/log-in-via-pat?view=azure-devops&tabs=windows).
        1. This login can be avoided using the `-SkipLogin` parameter. Make sure to be logged in using `az login` before using the `-SkipLogin` option.

    .DESCRIPTION
    Invokes the hydration given the definition file.
    Creates Azure DevOps resources based on a hydration definition file that matches a given schema.

    1. Run `Get-AzHydrationSchema` and create a definition file based on the given JSON schema you can find an example in [hydrationDefinition.json](../src/Tests/hydrationDefinition.json)
    2. Run `Test-AzHydrationTemplate` to validate the create definition template against the schema
    3. Run `Invoke-AzHydrationTemplate` to run the actual hydration
    4. Login to Azure DevOps
        1. The user is prompted to [login with a personal access token](https://docs.microsoft.com/en-us/azure/devops/cli/log-in-via-pat?view=azure-devops&tabs=windows).
        1. This login can be avoided using the `-SkipLogin` parameter. Make sure to be logged in using `az login` before using the `-SkipLogin` option.

    The `Invoke-AzHydrationTemplate` will create Azure DevOps resources based on a hydration defintion file that matches a given schema.
    The module uses the extension 'azure-devops' and installs it if misisng.

    .PARAMETER Path
    Path to the definition template file.
    The defintion tempalte file can be tested against a schema using `Test-AzHydrationTemplate`.
    The schema for the definition file can be generated using `Get-AzHydrationSchema`.

    .PARAMETER Force
    ATTENTION! Forces the replacement of exsiting resources.
    Make sure to validate the defintion file before applying it using `-Force`.
    Deletes exsisting resource before recreating the ones specified in the defintion file.
    Make sure to backup exsiting resources before applying them with force.

    .PARAMETER SkipLogin
    Skip the login and uses cached credentials.
    Make sure you run `az devops login` previous to running `Invoke-AzHydrationTempalte -SkipLogin`.
    Follow https://docs.microsoft.com/en-us/azure/devops/cli/log-in-via-pat?view=azure-devops&tabs=windows to Sign in with a Personal Access Token

    .EXAMPLE
    Invoke-HydraTemplate -Path $path

    Extension 'azure-devops' is already installed.
    Token:
    TODO: input output of actual execution

    .EXAMPLE
    Invoke-HydraTemplate -Path $path -SkipLogin

    Extension 'azure-devops' is already installed.
    TODO: input output of actual execution

    .NOTES
    The `Hydra` PowerShell module is used to rehydrate a given Azure DevOps project.
    I uses a configuration based approach, similar to an ARM template.
    The module implements a ordered collection of Azure cli commands to achieve the rehydration.

    As the hydration is opinionated, we are execting a defined configuration file.
    The default configuration file can then be changed and adopted to customers needs - providing a flexible approach.

    TODO: #67790 A blueprint hydration template file is beeing provided as a reference to the module.
    A hydration template can also be created from scratch, given that it alignes to the schema (`Get-HydraSchema` and `Test-HydraTemplate).

    The currentenly implemented test hydration file looks like this:

    ```json
    {
        "$schema": "../Hydra/Hydra.Schema.json",
        "projectName": "infra-as-code-source",
        "organizationName": "servicescode",
        "description": "infra-as-code-source",
        "process": "Agile",
        "sourceControl": "git",
        "visibility": "private",
        "repositoryName" : "Hydration-Components",
        "areaPaths": [
            {
                "name": "CCoE Cloud Solutions Team"
            },
            {
                "name": "CCoE Cloud Platform Team"
            },
            {
                "name": "CCoE Security Champions"
            },
            {
                "name": "CCoE Cloud Operations Champions"
            },
            {
                "name": "CCoE DevOps Enablement Office"
            },
            {
                "name": "Customer Application Teams",
                "children": [
                    {
                        "name": "Customer Application Team 3",
                        "children": []
                    },
                    {
                        "name": "CCoE Cloud Solutions Team 4",
                        "children": []
                    }
                ]
            }
        ],
        "iterationPaths": [
            {
                "name": "Sprint 0",
                "attributes":
                {
                    "startDate": "2020-12-14",
                    "finishDate": "2020-12-28"
                }
            },
            {
                "name": "Sprint 1",
                "children":[
                    {
                        "name": "Sprint 1.1",
                        "attributes":
                        {
                            "startDate": "2021-01-04",
                            "finishDate": "2021-01-11"
                        }
                    },
                    {
                        "name": "Sprint 1.2",
                        "attributes":
                        {
                            "startDate": "2021-01-12",
                            "finishDate": "2021-01-18"
                        }
                    }
                ]
            },
            {
                "name": "Sprint 3"
            }
        ],
        "teams": [
            {
                "name": "infra-as-code-source Team",
                "description": "The default project team."
            },
            {
                "name": "CCoE Cloud Solutions Team"
            },
            {
                "name": "CCoE Cloud Platform Team"
            },
            {
                "name": "CCoE Security Champions"
            },
            {
                "name": "CCoE Cloud Operations Champions"
            },
            {
                "name": "CCoE DevOps Enablement Office"
            }
        ]
    }
    ```

    The configuration will be aligned to configure the resources outlined in the diagram displayed in the [Wiki ccoe-hydration-0.1](https://servicescode.visualstudio.com/infra-as-code-source/_wiki/wikis/Wiki/4888/Cloud-Center-of-Excellence?anchor=ccoe-hydration-0.1)

    To get started the user has to create a hydration template based on the schema using `Get-HydraSchema`.
    Next the template is tested against the schema using `Test-HydraTemplate`.
    Laslty, the configuration will be read by `Invoke-HydraTemplate` and executed using different functions to invoke the changes on Azure DevOps.


    .LINK
    https://docs.microsoft.com/en-us/azure/devops/cli/log-in-via-pat?view=azure-devops&tabs=windows
#>
function Invoke-Template {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Path to the hydration definition JSON."
        )]
        [string] $Path,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Update ADO Project if already exists."
        )]
        [switch] $force = $false,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Skip the login and uses cached credentials."
        )]
        [switch] $skipLogin = $false

    )

    # Verify JSON
    $definition = Get-VerifiedHydrationDefinition -ParameterFilePath $Path

    # DevOps Login
    if ($pscmdlet.ShouldProcess('CLI Login function', 'Execute')) {
        if ($skipLogin) {
            Connect-DevOps -skipLogin
        }
        else {
            Connect-DevOps
        }
    }
    else {
        Connect-DevOps -WhatIf
    }

    # Create or update DevOps Project
    if ($pscmdlet.ShouldProcess('CreateUpdateProject')) {
        Sync-Project -HydrationDefinitionObj $definition -Force $force
    }
    else {
        Sync-Project -HydrationDefinitionObj $definition -Force $force -WhatIf
    }

    # Create or update Devops Project Areas
    if ($pscmdlet.ShouldProcess('CreateDeleteAreas')) {
        Sync-ProjectAreas -HydrationDefinitionObj $definition -Force $force
    }
    else {
        Sync-ProjectAreas -HydrationDefinitionObj $definition -Force $force -WhatIf
    }

    # Create or update Devops Project Iterations
    if ($pscmdlet.ShouldProcess('CreateUpdateProjectIterations')) {
        Sync-ProjectIterations -HydrationDefinitionObj $definition -Force $force
    }
    else {
        Sync-ProjectIterations -HydrationDefinitionObj $definition -Force $force -WhatIf
    }

    # Create or update Devops Project Teams
    if ($pscmdlet.ShouldProcess('CreateUpdateProjectTeams')) {
        Sync-ProjectTeams -HydrationDefinitionObj $definition -Force $force
    }
    else {
        Sync-ProjectTeams -HydrationDefinitionObj $definition -Force $force -WhatIf
    }

    # Create or update Devops Project Repo
    if ($pscmdlet.ShouldProcess('CreateUpdateRepo')) {
        Sync-Repo -HydrationDefinitionObj $definition
    }
    else {
        Sync-Repo -HydrationDefinitionObj $definition -WhatIf
    }
}