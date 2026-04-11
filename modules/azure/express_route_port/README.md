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
| [rest_resource.express_route_port](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_bandwidth_in_gbps"></a> [bandwidth\_in\_gbps](#input\_bandwidth\_in\_gbps) | Bandwidth of procured ports in Gbps. | `number` | n/a | yes |
| <a name="input_billing_type"></a> [billing\_type](#input\_billing\_type) | The billing type of the ExpressRoute port resource (MeteredData or UnlimitedData). | `string` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_encapsulation"></a> [encapsulation](#input\_encapsulation) | Encapsulation method on physical ports (Dot1Q or QinQ). | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_peering_location"></a> [peering\_location](#input\_peering\_location) | The name of the peering location that the ExpressRoute port is mapped to physically. | `string` | n/a | yes |
| <a name="input_port_name"></a> [port\_name](#input\_port\_name) | The name of the ExpressRoute port. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ether_type"></a> [ether\_type](#output\_ether\_type) | The Ether type of the physical port. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the ExpressRoute port. |
| <a name="output_location"></a> [location](#output\_location) | The location of the ExpressRoute port (plan-time, echoes input). |
| <a name="output_mtu"></a> [mtu](#output\_mtu) | Maximum transmission unit of the physical port pair(s). |
| <a name="output_name"></a> [name](#output\_name) | The name of the ExpressRoute port (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the ExpressRoute port. |
<!-- END_TF_DOCS -->