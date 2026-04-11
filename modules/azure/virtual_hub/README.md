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
| [rest_resource.virtual_hub](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_address_prefix"></a> [address\_prefix](#input\_address\_prefix) | The address prefix (CIDR) for this Virtual Hub. | `string` | n/a | yes |
| <a name="input_allow_branch_to_branch_traffic"></a> [allow\_branch\_to\_branch\_traffic](#input\_allow\_branch\_to\_branch\_traffic) | Flag to control transit for VirtualRouter hub. | `bool` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_hub_routing_preference"></a> [hub\_routing\_preference](#input\_hub\_routing\_preference) | The hubRoutingPreference (ExpressRoute, VpnGateway, ASPath). | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region for the Virtual Hub. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU of this Virtual Hub (Basic or Standard). | `string` | `"Standard"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_virtual_hub_name"></a> [virtual\_hub\_name](#input\_virtual\_hub\_name) | The name of the Virtual Hub. | `string` | `null` | no |
| <a name="input_virtual_router_auto_scale_min_capacity"></a> [virtual\_router\_auto\_scale\_min\_capacity](#input\_virtual\_router\_auto\_scale\_min\_capacity) | The minimum number of scale units for VirtualHub Router. | `number` | `null` | no |
| <a name="input_virtual_wan_id"></a> [virtual\_wan\_id](#input\_virtual\_wan\_id) | The ARM resource ID of the Virtual WAN this hub belongs to. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_address_prefix"></a> [address\_prefix](#output\_address\_prefix) | The address prefix of the Virtual Hub (plan-time, echoes input). |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the Virtual Hub. |
| <a name="output_location"></a> [location](#output\_location) | The location of the Virtual Hub (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the Virtual Hub (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Virtual Hub. |
| <a name="output_routing_state"></a> [routing\_state](#output\_routing\_state) | The routing state of the Virtual Hub. |
<!-- END_TF_DOCS -->