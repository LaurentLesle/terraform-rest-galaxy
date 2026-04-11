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
| [rest_resource.dns_zone_group](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.private_endpoint](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_custom_network_interface_name"></a> [custom\_network\_interface\_name](#input\_custom\_network\_interface\_name) | Custom name for the network interface created by the private endpoint. | `string` | `null` | no |
| <a name="input_ip_configurations"></a> [ip\_configurations](#input\_ip\_configurations) | Static IP configurations for the private endpoint. | <pre>list(object({<br/>    name               = string<br/>    group_id           = optional(string)<br/>    member_name        = optional(string)<br/>    private_ip_address = string<br/>  }))</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_manual_private_link_service_connections"></a> [manual\_private\_link\_service\_connections](#input\_manual\_private\_link\_service\_connections) | Manually-approved private link service connections. | <pre>list(object({<br/>    name                    = string<br/>    private_link_service_id = string<br/>    group_ids               = optional(list(string))<br/>    request_message         = optional(string)<br/>  }))</pre> | `null` | no |
| <a name="input_private_dns_zone_group"></a> [private\_dns\_zone\_group](#input\_private\_dns\_zone\_group) | DNS zone group to automatically register A records in private DNS zones. | <pre>object({<br/>    name                 = optional(string, "default")<br/>    private_dns_zone_ids = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_private_endpoint_name"></a> [private\_endpoint\_name](#input\_private\_endpoint\_name) | The name of the private endpoint. | `string` | n/a | yes |
| <a name="input_private_link_service_connections"></a> [private\_link\_service\_connections](#input\_private\_link\_service\_connections) | Auto-approved private link service connections. | <pre>list(object({<br/>    name                    = string<br/>    private_link_service_id = string<br/>    group_ids               = optional(list(string))<br/>    request_message         = optional(string)<br/>  }))</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The resource ID of the subnet to place the private endpoint in. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The resource ID of the private endpoint (plan-time). |
| <a name="output_location"></a> [location](#output\_location) | The Azure region. |
| <a name="output_name"></a> [name](#output\_name) | The name of the private endpoint. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state (known after apply). |
<!-- END_TF_DOCS -->