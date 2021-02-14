# GitHub Action azvalidate

This action can be used to validate an ARM template.<br>

To be able to validate the ARM template your Action needs to be logged into Azure. The Action [azlogin](https://github.com/segraef/azlogin) does that for you.

## Usage

```

- uses: segraef/azvalidate@v1
  with:
    resourceGroupName: "rg-deploy"
    location: "westeurope"
    templateFile: "deploy.json"
    parametersFile: "parameters.json"

```

## Requirements

segraef/azlogin@v1

## Variables

- `resourceGroupCommand` – **Optional**.

  - If `resourceGroupCommand` is not specified or is "create"
    - `resourceGroupName` – **Mandatory**
    - `resourceGroupLocation` – **Mandatory**
    - `templateFile` – **Mandatory** - Relative path in your github repository.
    - `parametersFile` – **Mandatory** - Relative path in your github repository.
    - `templateUri` – **Optional** - Template Uri.
    - `parametersUri` – **Optional** - Parameters URI.
    
  -  If `resourceGroupCommand` is "delete"
     - `resourceGroupName` – **Mandatory**