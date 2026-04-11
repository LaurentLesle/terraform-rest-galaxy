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
| [rest_resource.virtual_wan](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allow_branch_to_branch_traffic"></a> [allow\_branch\_to\_branch\_traffic](#input\_allow\_branch\_to\_branch\_traffic) | True if branch to branch traffic is allowed. | `bool` | `null` | no |
| <a name="input_allow_vnet_to_vnet_traffic"></a> [allow\_vnet\_to\_vnet\_traffic](#input\_allow\_vnet\_to\_vnet\_traffic) | True if Vnet to Vnet traffic is allowed. | `bool` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_disable_vpn_encryption"></a> [disable\_vpn\_encryption](#input\_disable\_vpn\_encryption) | Vpn encryption to be disabled or not. | `bool` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region for the Virtual WAN. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of the VirtualWAN (Basic or Standard). | `string` | `"Standard"` | no |
| <a name="input_virtual_wan_name"></a> [virtual\_wan\_name](#input\_virtual\_wan\_name) | The name of the Virtual WAN. | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the Virtual WAN. |
| <a name="output_location"></a> [location](#output\_location) | The location of the Virtual WAN (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the Virtual WAN (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Virtual WAN. |
<!-- END_TF_DOCS -->