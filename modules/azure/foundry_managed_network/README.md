<!-- BEGIN_TF_DOCS -->


## Requirements

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_rest"></a> [rest](#requirement\_rest) | = 1.2.0 |

## Providers

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_rest"></a> [rest](#provider\_rest) | = 1.2.0 |

## Resources

## Resources

| Name | Type |
| ---- | ---- |
| [rest_operation.foundry_managed_network](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/operation) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The name of the parent Foundry account (Microsoft.CognitiveServices/accounts). | `string` | n/a | yes |
| <a name="input_firewall_sku"></a> [firewall\_sku](#input\_firewall\_sku) | The Azure Firewall SKU used for FQDN outbound rules. Only relevant when<br/>isolation\_mode is 'AllowOnlyApprovedOutbound' and FQDN rules are added.<br/><br/>- Standard (default): Full feature set including threat intelligence-based filtering.<br/>- Basic: Reduced cost option. Sufficient for most scenarios without advanced filtering.<br/><br/>WARNING: Cannot be changed after initial deployment. | `string` | `"Standard"` | no |
| <a name="input_isolation_mode"></a> [isolation\_mode](#input\_isolation\_mode) | The managed network isolation mode. Controls how Agent egress traffic is secured.<br/><br/>- AllowOnlyApprovedOutbound (default): Restricts outbound to approved destinations<br/>  only (service tags, private endpoints, FQDN rules). A managed Azure Firewall is<br/>  created automatically when FQDN rules are added. Recommended for production.<br/>- AllowInternetOutbound: Allows all outbound internet traffic. Simpler setup but<br/>  provides weaker data exfiltration protection.<br/>- Disabled: No managed network isolation. Use with a custom VNet instead.<br/><br/>WARNING: This setting is IRREVERSIBLE. Once set to AllowInternetOutbound or<br/>AllowOnlyApprovedOutbound, it cannot be changed back to Disabled. Changing from<br/>AllowInternetOutbound to AllowOnlyApprovedOutbound is also not supported. | `string` | `"AllowOnlyApprovedOutbound"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region of the parent Foundry account. Must be one of the regions that<br/>support managed virtual network (preview). The managed network is always<br/>co-located with its parent account.<br/><br/>Supported regions: eastus, eastus2, japaneast, francecentral, uaenorth,<br/>brazilsouth, spaincentral, germanywestcentral, italynorth, southcentralus,<br/>westcentralus, australiaeast, swedencentral, canadaeast, southafricanorth,<br/>westeurope, westus, westus3, southindia, uksouth. | `string` | `"francecentral"` | no |
| <a name="input_managed_network_kind"></a> [managed\_network\_kind](#input\_managed\_network\_kind) | The managed network kind. Controls the access control model:<br/>- V2 (default): Granular access controls. Recommended for new deployments.<br/>- V1: Legacy access controls.<br/><br/>WARNING: Once set to V2, it cannot be reverted to V1. | `string` | `"V2"` | no |
| <a name="input_outbound_rules"></a> [outbound\_rules](#input\_outbound\_rules) | Map of outbound rules for the managed network. Each key is the rule name.<br/><br/>Three rule types are supported:<br/><br/>FQDN rule (allows outbound to a specific domain; requires AllowOnlyApprovedOutbound + firewall):<br/>  my\_fqdn\_rule = {<br/>    type             = "FQDN"<br/>    fqdn\_destination = "*.example.com"<br/>  }<br/><br/>PrivateEndpoint rule (creates a managed private endpoint to an Azure resource):<br/>  my\_storage\_pe = {<br/>    type                                 = "PrivateEndpoint"<br/>    private\_endpoint\_service\_resource\_id = "/subscriptions/.../storageAccounts/mystorage"<br/>    private\_endpoint\_subresource\_target  = "blob"<br/>  }<br/><br/>ServiceTag rule (allows outbound to an Azure service tag):<br/>  my\_service\_tag\_rule = {<br/>    type                = "ServiceTag"<br/>    service\_tag         = "AzureActiveDirectory"<br/>    service\_tag\_action  = "Allow"<br/>    service\_tag\_protocol = "TCP"<br/>    service\_tag\_port\_ranges = "443"<br/>  }<br/><br/>NOTE: FQDN rules are only supported on ports 80 and 443.<br/>NOTE: PrivateEndpoint rules require the Foundry managed identity to have<br/>      the 'Azure AI Enterprise Network Connection Approver' role on the target resource. | <pre>map(object({<br/>    type     = string<br/>    category = optional(string, "UserDefined")<br/>    # FQDN rule fields<br/>    fqdn_destination = optional(string, null)<br/>    # PrivateEndpoint rule fields<br/>    private_endpoint_service_resource_id = optional(string, null)<br/>    private_endpoint_subresource_target  = optional(string, null)<br/>    private_endpoint_fqdns               = optional(list(string), null)<br/>    # ServiceTag rule fields<br/>    service_tag                  = optional(string, null)<br/>    service_tag_action           = optional(string, "Allow")<br/>    service_tag_protocol         = optional(string, null)<br/>    service_tag_port_ranges      = optional(string, null)<br/>    service_tag_address_prefixes = optional(list(string), null)<br/>  }))</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group containing the parent Foundry account. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_account_name"></a> [account\_name](#output\_account\_name) | The parent Foundry account name (plan-time, echoes input). |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this resource. |
| <a name="output_firewall_sku"></a> [firewall\_sku](#output\_firewall\_sku) | The firewall SKU as confirmed by Azure after apply. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the managed network (plan-time). |
| <a name="output_isolation_mode"></a> [isolation\_mode](#output\_isolation\_mode) | The managed network isolation mode (plan-time, echoes input). |
| <a name="output_managed_network_kind"></a> [managed\_network\_kind](#output\_managed\_network\_kind) | The managed network kind: V1 or V2 (plan-time, echoes input). |
| <a name="output_network_isolation_mode"></a> [network\_isolation\_mode](#output\_network\_isolation\_mode) | The isolation mode as confirmed by Azure after apply. |
| <a name="output_network_kind"></a> [network\_kind](#output\_network\_kind) | The managed network kind as confirmed by Azure after apply. |
| <a name="output_network_status"></a> [network\_status](#output\_network\_status) | The managed network provisioning status: Active or Inactive. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the managed network (e.g. Succeeded). |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name (plan-time, echoes input). |
<!-- END_TF_DOCS -->