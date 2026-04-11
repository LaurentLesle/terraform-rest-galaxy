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
| [rest_operation.check_name_availability](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/operation) | resource |
| [rest_resource.postgresql_flexible_server](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_active_directory_auth"></a> [active\_directory\_auth](#input\_active\_directory\_auth) | Enable Microsoft Entra authentication. Options: Enabled, Disabled. | `string` | `null` | no |
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | The administrator login name. Required when password auth is enabled. | `string` | `null` | no |
| <a name="input_administrator_login_password"></a> [administrator\_login\_password](#input\_administrator\_login\_password) | The administrator login password. Required when password auth is enabled. | `string` | `null` | no |
| <a name="input_auth_tenant_id"></a> [auth\_tenant\_id](#input\_auth\_tenant\_id) | Tenant ID for Entra authentication. | `string` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability zone. | `string` | `null` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Backup retention days (7-35). | `number` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_delegated_subnet_id"></a> [delegated\_subnet\_id](#input\_delegated\_subnet\_id) | Resource ID of the delegated subnet for VNet integration. | `string` | `null` | no |
| <a name="input_geo_redundant_backup"></a> [geo\_redundant\_backup](#input\_geo\_redundant\_backup) | Enable geo-redundant backup. Options: Enabled, Disabled. | `string` | `null` | no |
| <a name="input_ha_mode"></a> [ha\_mode](#input\_ha\_mode) | High availability mode. Options: Disabled, SameZone, ZoneRedundant. | `string` | `null` | no |
| <a name="input_ha_standby_availability_zone"></a> [ha\_standby\_availability\_zone](#input\_ha\_standby\_availability\_zone) | Availability zone for the standby server. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window configuration. | <pre>object({<br/>    custom_window = optional(string, "Disabled")<br/>    start_hour    = optional(number, 0)<br/>    start_minute  = optional(number, 0)<br/>    day_of_week   = optional(number, 0)<br/>  })</pre> | `null` | no |
| <a name="input_password_auth"></a> [password\_auth](#input\_password\_auth) | Enable password authentication. Options: Enabled, Disabled. | `string` | `null` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | Resource ID of the private DNS zone for VNet-integrated servers. | `string` | `null` | no |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Public network access. Options: Enabled, Disabled. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group. | `string` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | The name of the PostgreSQL Flexible Server. | `string` | `null` | no |
| <a name="input_server_version"></a> [server\_version](#input\_server\_version) | PostgreSQL major version. Options: 12, 13, 14, 15, 16, 17, 18. | `string` | `"16"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Compute SKU name (e.g. Standard\_B1ms, Standard\_D2ds\_v5). | `string` | `"Standard_D2ds_v5"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | SKU tier. Options: Burstable, GeneralPurpose, MemoryOptimized. | `string` | `"GeneralPurpose"` | no |
| <a name="input_storage_auto_grow"></a> [storage\_auto\_grow](#input\_storage\_auto\_grow) | Enable auto-grow for storage. Options: Enabled, Disabled. | `string` | `null` | no |
| <a name="input_storage_size_gb"></a> [storage\_size\_gb](#input\_storage\_size\_gb) | Storage size in GB. | `number` | `32` | no |
| <a name="input_storage_tier"></a> [storage\_tier](#input\_storage\_tier) | Storage performance tier (e.g. P10, P20, P30). | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The fully qualified domain name of the server. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the PostgreSQL Flexible Server. |
| <a name="output_location"></a> [location](#output\_location) | The location (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The server name (plan-time, echoes input). |
| <a name="output_state"></a> [state](#output\_state) | The state of the server (e.g. Ready). |
| <a name="output_version"></a> [version](#output\_version) | The PostgreSQL version. |
<!-- END_TF_DOCS -->