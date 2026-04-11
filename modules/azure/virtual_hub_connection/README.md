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
| [rest_resource.virtual_hub_connection](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allow_hub_to_remote_vnet_transit"></a> [allow\_hub\_to\_remote\_vnet\_transit](#input\_allow\_hub\_to\_remote\_vnet\_transit) | Allow hub to remote VNet transit. | `bool` | `null` | no |
| <a name="input_allow_remote_vnet_to_use_hub_vnet_gateways"></a> [allow\_remote\_vnet\_to\_use\_hub\_vnet\_gateways](#input\_allow\_remote\_vnet\_to\_use\_hub\_vnet\_gateways) | Allow remote VNet to use hub VNet gateways. | `bool` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_connection_name"></a> [connection\_name](#input\_connection\_name) | The name of the hub virtual network connection. | `string` | n/a | yes |
| <a name="input_enable_internet_security"></a> [enable\_internet\_security](#input\_enable\_internet\_security) | Enable internet security (default route through the hub). | `bool` | `null` | no |
| <a name="input_remote_virtual_network_id"></a> [remote\_virtual\_network\_id](#input\_remote\_virtual\_network\_id) | The ARM resource ID of the remote virtual network. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_virtual_hub_name"></a> [virtual\_hub\_name](#input\_virtual\_hub\_name) | The name of the Virtual Hub. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the hub virtual network connection. |
| <a name="output_name"></a> [name](#output\_name) | The name of the hub virtual network connection (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the hub virtual network connection. |
<!-- END_TF_DOCS -->