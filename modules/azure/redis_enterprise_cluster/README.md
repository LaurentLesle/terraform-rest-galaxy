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
| [rest_resource.redis_enterprise_cluster](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the Redis Enterprise cluster. | `string` | n/a | yes |
| <a name="input_high_availability"></a> [high\_availability](#input\_high\_availability) | High availability setting. One of: 'Enabled', 'Disabled'. Enabled by default. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region for the Redis Enterprise cluster. | `string` | n/a | yes |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | The minimum TLS version for the cluster to support. One of: '1.0', '1.1', '1.2'. | `string` | `"1.2"` | no |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Whether public network access is allowed. One of: 'Enabled', 'Disabled'. | `string` | `"Disabled"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group. | `string` | n/a | yes |
| <a name="input_sku_capacity"></a> [sku\_capacity](#input\_sku\_capacity) | The capacity of the SKU. Valid values are (2, 4, 6, ...) for Enterprise and (3, 9, 15, ...) for EnterpriseFlash. | `number` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name (e.g. Enterprise\_E10, Enterprise\_E5, Balanced\_B5, etc.). | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | The Availability Zones where this cluster will be deployed. | `list(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this Redis Enterprise cluster. |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | The hostname of the Redis Enterprise cluster (known after apply). |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the Redis Enterprise cluster. |
| <a name="output_location"></a> [location](#output\_location) | The Azure region (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the Redis Enterprise cluster (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Redis Enterprise cluster. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name (plan-time, echoes input). |
| <a name="output_type"></a> [type](#output\_type) | The ARM resource type string. |
<!-- END_TF_DOCS -->