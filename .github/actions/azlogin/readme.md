# GitHub Action azlogin

The GitHub Action **azlogin** for [Azure](https://azure.microsoft.com/) Login wraps the Azure PowerShell's `Connect-AzAccount`, allowing for Actions to log into Azure.

Because `$HOME` is persisted across Actions, the `az login` command will save this information on the filesystem, allowing other Actions to reuse the context.
The official action azure/login@v1 does not use `$HOME`.

## Usage

```

- uses: segraef/azlogin@v1
  with:
    clientId: ${{ secrets.clientId }}
    clientSecret: ${{ secrets.clientSecret }}
    tenantId: <tenantId>
    subscriptionId: <subscriptionId>

```

## Secrets

- `clientId` – **Required**
- `clientSecret` – **Required**
- `tenantId` – **Required**
- `subscriptionId` – **Required**

## Variables

- `identity: true/false` – **Optional**
- `environmentName` – **Optional**

You can create get the above details by running following command ([details](https://docs.microsoft.com/en-us/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create-for-rbac)).

`az ad sp create-for-rbac --name "<spName>" --role contributor --scopes /subscriptions/<subscriptionId> --sdk-auth`