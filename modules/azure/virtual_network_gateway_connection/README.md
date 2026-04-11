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
| [rest_resource.virtual_network_gateway_connection](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_connection_name"></a> [connection\_name](#input\_connection\_name) | The name of the connection. | `string` | n/a | yes |
| <a name="input_connection_type"></a> [connection\_type](#input\_connection\_type) | The connection type (IPsec, Vnet2Vnet, ExpressRoute). | `string` | n/a | yes |
| <a name="input_enable_bgp"></a> [enable\_bgp](#input\_enable\_bgp) | Whether BGP is enabled. | `bool` | `null` | no |
| <a name="input_enable_private_link_fast_path"></a> [enable\_private\_link\_fast\_path](#input\_enable\_private\_link\_fast\_path) | Whether private link fast path is enabled. | `bool` | `null` | no |
| <a name="input_express_route_gateway_bypass"></a> [express\_route\_gateway\_bypass](#input\_express\_route\_gateway\_bypass) | Whether ExpressRoute gateway bypass (FastPath) is enabled. | `bool` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_peer_id"></a> [peer\_id](#input\_peer\_id) | The resource ID of the peer (ExpressRoute circuit or local network gateway). | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_routing_weight"></a> [routing\_weight](#input\_routing\_weight) | The routing weight. | `number` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_virtual_network_gateway1_id"></a> [virtual\_network\_gateway1\_id](#input\_virtual\_network\_gateway1\_id) | The resource ID of the first virtual network gateway. | `string` | n/a | yes |
| <a name="input_virtual_network_gateway2_id"></a> [virtual\_network\_gateway2\_id](#input\_virtual\_network\_gateway2\_id) | The resource ID of the second virtual network gateway (Vnet2Vnet). | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The resource ID of the virtual network gateway connection (plan-time). |
| <a name="output_location"></a> [location](#output\_location) | The Azure region. |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual network gateway connection. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state (known after apply). |
<!-- END_TF_DOCS -->