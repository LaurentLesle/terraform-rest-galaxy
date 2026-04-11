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
| [rest_resource.redis_enterprise_database](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_access_keys_authentication"></a> [access\_keys\_authentication](#input\_access\_keys\_authentication) | Allow or deny access with current access keys. One of: 'Enabled', 'Disabled'. | `string` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_client_protocol"></a> [client\_protocol](#input\_client\_protocol) | Specifies whether redis clients connect using TLS-encrypted or plaintext. One of: 'Encrypted', 'Plaintext'. | `string` | `"Encrypted"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the parent Redis Enterprise cluster. | `string` | n/a | yes |
| <a name="input_clustering_policy"></a> [clustering\_policy](#input\_clustering\_policy) | Clustering policy. One of: 'EnterpriseCluster', 'OSSCluster', 'NoCluster'. | `string` | `"OSSCluster"` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the database. Defaults to 'default'. | `string` | `"default"` | no |
| <a name="input_eviction_policy"></a> [eviction\_policy](#input\_eviction\_policy) | Redis eviction policy. One of: 'AllKeysLFU', 'AllKeysLRU', 'AllKeysRandom', 'VolatileLRU', 'VolatileLFU', 'VolatileTTL', 'VolatileRandom', 'NoEviction'. | `string` | `"VolatileLRU"` | no |
| <a name="input_modules"></a> [modules](#input\_modules) | Optional set of Redis modules to enable (can only be set at creation time). | <pre>list(object({<br/>    name = string<br/>    args = optional(string)<br/>  }))</pre> | `null` | no |
| <a name="input_persistence"></a> [persistence](#input\_persistence) | Persistence settings for the database. | <pre>object({<br/>    aof_enabled   = optional(bool)<br/>    aof_frequency = optional(string)<br/>    rdb_enabled   = optional(bool)<br/>    rdb_frequency = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | TCP port of the database endpoint. Specified at create time. | `number` | `10000` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this Redis Enterprise database. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The parent cluster name (plan-time, echoes input). |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the Redis Enterprise database. |
| <a name="output_name"></a> [name](#output\_name) | The name of the database (plan-time, echoes input). |
| <a name="output_port"></a> [port](#output\_port) | The TCP port of the database endpoint (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the database. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name (plan-time, echoes input). |
| <a name="output_type"></a> [type](#output\_type) | The ARM resource type string. |
<!-- END_TF_DOCS -->