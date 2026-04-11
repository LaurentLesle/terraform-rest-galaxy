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
| [rest_resource.express_route_circuit](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allow_classic_operations"></a> [allow\_classic\_operations](#input\_allow\_classic\_operations) | Allow classic operations. | `bool` | `null` | no |
| <a name="input_bandwidth_in_gbps"></a> [bandwidth\_in\_gbps](#input\_bandwidth\_in\_gbps) | Bandwidth in Gbps (for ExpressRoute Direct). | `number` | `null` | no |
| <a name="input_bandwidth_in_mbps"></a> [bandwidth\_in\_mbps](#input\_bandwidth\_in\_mbps) | Bandwidth in Mbps (for provider-based circuits). | `number` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_circuit_name"></a> [circuit\_name](#input\_circuit\_name) | The name of the ExpressRoute circuit. | `string` | `null` | no |
| <a name="input_express_route_port_id"></a> [express\_route\_port\_id](#input\_express\_route\_port\_id) | ARM resource ID of the ExpressRoute port (for Direct circuits). | `string` | `null` | no |
| <a name="input_global_reach_enabled"></a> [global\_reach\_enabled](#input\_global\_reach\_enabled) | Enable Global Reach. | `bool` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_peering_location"></a> [peering\_location](#input\_peering\_location) | The peering location (for provider-based circuits). | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_service_provider_name"></a> [service\_provider\_name](#input\_service\_provider\_name) | The service provider name (for provider-based circuits). | `string` | `null` | no |
| <a name="input_sku_family"></a> [sku\_family](#input\_sku\_family) | The SKU family (MeteredData, UnlimitedData). | `string` | n/a | yes |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The SKU tier (Standard, Premium, Local). | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the ExpressRoute circuit. |
| <a name="output_location"></a> [location](#output\_location) | The location. |
| <a name="output_name"></a> [name](#output\_name) | The name of the ExpressRoute circuit. |
| <a name="output_service_key"></a> [service\_key](#output\_service\_key) | The service key. |
<!-- END_TF_DOCS -->