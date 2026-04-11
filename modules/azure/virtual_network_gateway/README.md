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
| [rest_resource.virtual_network_gateway](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_active_active"></a> [active\_active](#input\_active\_active) | Whether active-active mode is enabled. | `bool` | `null` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | The admin state (Enabled, Disabled). | `string` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_enable_bgp"></a> [enable\_bgp](#input\_enable\_bgp) | Whether BGP is enabled. | `bool` | `null` | no |
| <a name="input_enable_private_ip_address"></a> [enable\_private\_ip\_address](#input\_enable\_private\_ip\_address) | Whether private IP is enabled. | `bool` | `null` | no |
| <a name="input_gateway_name"></a> [gateway\_name](#input\_gateway\_name) | The name of the virtual network gateway. | `string` | `null` | no |
| <a name="input_gateway_type"></a> [gateway\_type](#input\_gateway\_type) | The gateway type (Vpn or ExpressRoute). | `string` | n/a | yes |
| <a name="input_ip_configurations"></a> [ip\_configurations](#input\_ip\_configurations) | IP configurations for the gateway. | <pre>list(object({<br/>    name                 = string<br/>    subnet_id            = optional(string)<br/>    public_ip_address_id = optional(string)<br/>  }))</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name (e.g. VpnGw1, ErGw1AZ, UltraPerformance). | `string` | n/a | yes |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The SKU tier. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_vpn_client_configuration"></a> [vpn\_client\_configuration](#input\_vpn\_client\_configuration) | P2S VPN client configuration. Required for Point-to-Site VPN. | <pre>object({<br/>    address_prefixes         = list(string)<br/>    vpn_client_protocols     = optional(list(string))<br/>    vpn_authentication_types = optional(list(string))<br/>    aad_tenant               = optional(string)<br/>    aad_audience             = optional(string)<br/>    aad_issuer               = optional(string)<br/>    radius_server_address    = optional(string)<br/>    radius_server_secret     = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_vpn_gateway_generation"></a> [vpn\_gateway\_generation](#input\_vpn\_gateway\_generation) | The VPN gateway generation (None, Generation1, Generation2). | `string` | `null` | no |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | The VPN type (PolicyBased, RouteBased). | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The resource ID of the virtual network gateway (plan-time). |
| <a name="output_location"></a> [location](#output\_location) | The Azure region. |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual network gateway. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state (known after apply). |
<!-- END_TF_DOCS -->