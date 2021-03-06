# PrivateEndpoints

# Resource

This template deploys private Endpoint for a generic service.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Resources/deployments`| 2020-10-01 |
| `Microsoft.Network/privateEndpoints` | 2020-07-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-07-01 |

### Resource dependency

The following resources are required to be able to deploy this resource:
- PrivateDNSZone
- VirtualNetwork/subnet
- The service that needs to be connected through private endpoint

**Important**: Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon).

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `privateEndpointName` | string | Required. Name of the private endpoint resource to create | | |
| `targetSubnetId` | string | Required. Resource Id of the subnet where the endpoint needs to be connected |  |  |
| `serviceResourceId` | string | Required. Resource Id of the resource that needs to be connected to the network | |  |
| `groupId` | array | Required. Subtype(s) of the connection to be created. The allowed values depend on the type serviceResourceId refers to. Currently only array of a single element are supported. | | See [here](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource) for possible values (subresources column).<br>For Azure DataFactory: portal, dataFactory |
| `privateDNSId` | string | Optional. Resource id of the private DNS zone | | |
| `location` | string | Optional. Location for all Resources | resourceGroup().location | |
| `tags` | object | Optional. Tags of the resource |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `privateEndpointResourceGroup` | string | The name of the Resource Group the resources was deployed to |
| `privateEndpointResourceId` | string | The Resource id of the resource deployed. |
| `privateEndpointName` | string | The Name of the deployed private endpoint. |

## Considerations

*N/A*

## Additional resources

- [Private endpoint](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview)
- [Template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/privateendpoints)
