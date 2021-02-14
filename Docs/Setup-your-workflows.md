## GitHub Actions and Workflows 
The github actions are powershell scripts that run in docker containers. The code for these actions is stored in the **action** folder under a sub-directory named after each action:
  * **[azlogin](../azlogin/../.github/actions/azlogin/readme.md)**: action used to login to Azure prior to calling any of the other actions. This actions executes the PowerShell cmdlet *Connect-AzAccount* to login and set the Azure context to the subscription specified through the cmdlet *Set-AzContext*.  
  * **[azdeploy](../azlogin/../.github/actions/azdeploy/readme.md)**: used to deploy Resources in Azure at the Resoure Group level or Subscription level by execuring the PowerShell cmdlet *New-AzResourceGroupDeployment* or  *New-AzDeployment*.
  * **[azremove](../azlogin/../.github/actions/azremove/readme.md)**: used to remove azure resources or Azure resource groups by execuring the PowerShell cmdlet *Remove-AzResource* or *Remove-AzResourceGroup*.
  * **[azvalidate](../azlogin/../.github/actions/azvalidate/readme.md)**: used to validate an ARM template by execuring the PowerShell cmdlet *Test-AzResourceGroupDeployment* at the Resource Group level or *Test-AzDeployment* at the Subscription level.
  * **[azpwsh](../azlogin/../.github/actions/azpwsh/readme.md)**: used to run any PowerShell script.

The sub-directories under the **.github** directory have to follow the structure depicted in the diagram below, otherwise the workfows defined will not run. Note that only a few of the sub-directories used in the project have been represented here.

   <img src=".attachments/iac-directory-structure.jpg" alt="iac-directory-structure" title="Directory Structure for .github"  />

As you can see in the diagram above, we have created a subdirectory and a corresponding workflow yaml file for each **Subscription** and **Resource Group** where we are deploying Azure resources. For example, the *rg-3rdparty-hub-govaz-001.yml* is the workflow file to deploy resources in the Azure Resource Group with the same name. This workflow relies on the  subdirectory with the same name to locate all the paramters files for the ARM templates that it uses. Notice that the parameter files are located under subdirectories representing the type of resources that they are used to build. If there are more that one parameter file for a given resource type, then the name of the paramter file represents the instance of the specifcic ressource being built. For example, under *VirtualMachines* you can see the parameter files *smtpRelay.json* and *DomainControllers.json* used to build respectively VMs to run an SMTP relay and Domain Controllers.

The top part of this workflow YAML file could look like the following:

```bash
name: rg-3rdparty-hub-govaz-001
on:
  push:
    branches: [ NotTrigger ] 
    paths:
      - ".github/workflows/rg-3rdparty-hub-govaz-001.yml"
      - ".github/workflows/rg-3rdparty-hub-govaz-001/*/*"
env:
  resourceGroupName: "rg-3rdparty-hub-govaz-001"
  location: "usgovarizona"
  
jobs:
  deploy:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v2
      - name: azlogin
        uses: ./.github/actions/azlogin
        with:
          environmentName: "AzureUSGovernment"
          subscriptionId: "ba02b7dd-3dbe-44a5-9588-96c18a096458"
          identity: "true"
          accountId: "3c067fa3-f7e6-46af-9b0f-f5ba4cfbdad7" # This is the ObjectID for 'mi-github-hub-001'

      - name: "Virtual Machines: RedHat Identity Manager"
        uses: ./.github/actions/azdeploy
        with:
          resourceGroupName: ${{ env.resourceGroupName }}
          location: ${{ env.location }}
          templateFile: "Modules/ARM/VirtualMachines/2020-04-20/deploy.json"
          parametersFile: "./.github/workflows/${{ env.resourceGroupName }}/VirtualMachines/redHat-IdM.json"
          resourceGroupCommand: 'create'
```

Notice the following parameters passed to the **azdlogin** action in the workflow above to login to Azure:
* **environmentName**: this parameter is only needed if the deployment is not taking place in the standard Azure commercial cloud.
* **subscriptionId**: this is the ID for the subscription where the deployment will take place.
* **identity**: if set to true, a managed identity will be used to login to Azure instead of a Service Principal. This is only applicable if you are using a self-hosted runner in Azure to run your workflows instead of the runners hosted in the GitHub Cloud.  
* **accountId**: this is the ID for the managed identity you have defined in your Azure tenant and associated with the VM that is hosting your GitHub runner in Azure.
  
After you have successfully logged into Azure, the next step in the workflow above calls **azdeploy** to deploy the first resource in this Resource Group. Notice the parameters passed to build Virtual Machines for "RedHat Identity Manager":
  * **resourceGroupName**: name of the Azure Resource Group, which is set as a variable in this worflow to **"rg-3rdparty-hub-govaz-001"**. This name should match the name of the workflow file.
  * **location**: Azure region where the resources are deployed, which is also defined as a variable in this workflow,
  * **templateFile**: location of the ARM template, which is pointing to the *Module* subdirectory. You typically should never have to touch the files there as they are provided by MCS as part of their engagement,  
  * **parametersFile**: location of the parameter file used by the ARM template. All customizations to the resources deployed through this ARM template should be done in this parameter file. Notice that this parameter file is located under the subdirectory with the same name as this workflow.
* **resourceGroupCommand**: if set to 'create', indicates that the Resource Group where this resource is being deployed has to be created if it does not already exist.

The following is another example of a workflow, but this one is used to deploy resources at the subscription level.

```bash
name: dcss-cseprod-001
on:
  push:
    branches: [ NotTrigger ] 
    paths:
    - '.github/workflows/dcss-cseprod-001.yml'
    - '.github/workflows/dcss-cseprod-001/**'

env:
  subscriptionName: 'dcss-cseprod-001'
  location: 'usgovarizona'

jobs:
  deploy:
    runs-on: self-hosted  
    steps:
    - uses: actions/checkout@v2
    - name: azlogin
      uses: ./.github/actions/azlogin
      with:
        environmentName: 'AzureUSGovernment'
        subscriptionId: "ba02b7dd-3dbe-44a5-9588-96c18a096458"
        identity: "true"
        accountId: "3c067fa3-f7e6-46af-9b0f-f5ba4cfbdad7" # This is the ObjectID for 'mi-github-hub-001'

    - name: AzureSecurityCenter
      uses: ./.github/actions/azdeploy
      with:
        scope: subscription
        location: '${{ env.location }}'
        templateFile: 'Modules/ARM/AzureSecurityCenter/2019-11-28/deploy.json'
        parametersFile: './.github/workflows/${{ env.subscriptionName }}/AzureSecurityCenter/parameters.json'
```

Notice the following differences in the parameters passed to **azdeploy** when deploying at the subscription level:
* **scope** is set to 'subscription' to indicate that the resources have to be deloyed at the subscription level and not within a Resource Group.
* There is no **resourceGroupName** and no **resourceGroupCommand** specified.
  

  

