# IaC Repository

## Setting up the new IaC repo for your project

Follow [these instructions](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template) to create a new repository based on the template for this IaC repository.

The new repository structure should look like the following:

   <img src=".attachments/top-level-directory-structure.jpg" alt="top-level-directory-structure" title="Top Level Directory Structure"/>

* The **Docs** directory contains this documentation
* The **Scripts** directory contains all no ARM based code used to deploy or configure resources in Azure.
* The **Modules** directory contains all the ARM templates used in this project. There is one module per Azure resource type.
* The **.github** directory contains the github workflows developped for the project to deploy Azure resources. These worflows are stored in the **workfow** sub-directory and they call the GitHub actions located in the **actions** sub-directory.

To find out how the actions and workflows need to be setup under the .github directory, click on [Setup your Workflows](../Docs/Setup-your-workflows.md/)
