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
| [rest_resource.vpn_gateway](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_enable_bgp_route_translation_for_nat"></a> [enable\_bgp\_route\_translation\_for\_nat](#input\_enable\_bgp\_route\_translation\_for\_nat) | Enable BGP routes translation for NAT on this VPN gateway. | `bool` | `null` | no |
| <a name="input_gateway_name"></a> [gateway\_name](#input\_gateway\_name) | The name of the VPN gateway. | `string` | n/a | yes |
| <a name="input_is_routing_preference_internet"></a> [is\_routing\_preference\_internet](#input\_is\_routing\_preference\_internet) | Enable Routing Preference property for the Public IP Interface of the VPN gateway. | `bool` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_virtual_hub_id"></a> [virtual\_hub\_id](#input\_virtual\_hub\_id) | The ARM resource ID of the Virtual Hub this VPN gateway belongs to. | `string` | n/a | yes |
| <a name="input_vpn_gateway_scale_unit"></a> [vpn\_gateway\_scale\_unit](#input\_vpn\_gateway\_scale\_unit) | The scale unit for this VPN gateway. | `number` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the VPN gateway. |
| <a name="output_location"></a> [location](#output\_location) | The location of the VPN gateway (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the VPN gateway (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the VPN gateway. |
<!-- END_TF_DOCS -->