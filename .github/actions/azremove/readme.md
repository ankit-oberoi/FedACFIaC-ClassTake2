# GitHub Action azremove

This action can be used to remove a single resource or a complete resource group in Azure using PowerShell.<br>

To be able to remove resources your Action needs to be logged into Azure. The Action [azlogin](https://github.com/segraef/azlogin) does that for you.

## Usage

```

- uses: segraef/azremove@v1
  with:
    resourceGroupName: "rg-deploy"
    resourceName: "resource01"

```

## Requirements

segraef/azlogin@v1

## Variables

- `resourceGroupName` – **Mandatory**
-  If `resourceName` is "true"
   - `resourceGroupName` – **Mandatory**
- `resourceId` – **Optional**