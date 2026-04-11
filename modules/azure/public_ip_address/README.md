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
| [rest_resource.public_ip_address](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allocation_method"></a> [allocation\_method](#input\_allocation\_method) | The allocation method (Static or Dynamic). | `string` | n/a | yes |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_idle_timeout_in_minutes"></a> [idle\_timeout\_in\_minutes](#input\_idle\_timeout\_in\_minutes) | Idle timeout in minutes. | `number` | `null` | no |
| <a name="input_ip_version"></a> [ip\_version](#input\_ip\_version) | The IP address version (IPv4 or IPv6). | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_public_ip_address_name"></a> [public\_ip\_address\_name](#input\_public\_ip\_address\_name) | The name of the public IP address. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name (Basic or Standard). | `string` | n/a | yes |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The SKU tier (Regional or Global). | `string` | `"Regional"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of availability zones. | `list(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the public IP address. |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The allocated IP address. |
| <a name="output_location"></a> [location](#output\_location) | The location. |
| <a name="output_name"></a> [name](#output\_name) | The name of the public IP address. |
<!-- END_TF_DOCS -->