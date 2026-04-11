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
| [rest_resource.storage_account](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Required for kind = BlobStorage. Billing access tier. Options: Hot, Cool, Cold, Premium. | `string` | `null` | no |
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The name of the storage account. Globally unique, 3–24 lowercase alphanumeric characters. | `string` | `null` | no |
| <a name="input_allow_blob_public_access"></a> [allow\_blob\_public\_access](#input\_allow\_blob\_public\_access) | Allow or disallow public access to all blobs or containers. Default is false. | `bool` | `false` | no |
| <a name="input_allow_cross_tenant_replication"></a> [allow\_cross\_tenant\_replication](#input\_allow\_cross\_tenant\_replication) | Allow or disallow cross-AAD-tenant object replication. Default is false for new accounts. | `bool` | `null` | no |
| <a name="input_allow_shared_key_access"></a> [allow\_shared\_key\_access](#input\_allow\_shared\_key\_access) | Whether the storage account permits Shared Key authorization. Null is equivalent to true. | `bool` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_default_to_oauth_authentication"></a> [default\_to\_oauth\_authentication](#input\_default\_to\_oauth\_authentication) | Set the default authentication to OAuth/Entra ID. Default interpretation is false. | `bool` | `null` | no |
| <a name="input_encryption_identity"></a> [encryption\_identity](#input\_encryption\_identity) | The ARM resource ID of the user-assigned identity used to access the key vault for CMK encryption. | `string` | `null` | no |
| <a name="input_encryption_key_name"></a> [encryption\_key\_name](#input\_encryption\_key\_name) | The name of the key vault key used for CMK encryption. | `string` | `null` | no |
| <a name="input_encryption_key_source"></a> [encryption\_key\_source](#input\_encryption\_key\_source) | The encryption key source. Options: Microsoft.Storage, Microsoft.Keyvault. Set to Microsoft.Keyvault for CMK. | `string` | `null` | no |
| <a name="input_encryption_key_vault_uri"></a> [encryption\_key\_vault\_uri](#input\_encryption\_key\_vault\_uri) | The URI of the key vault hosting the customer-managed key. | `string` | `null` | no |
| <a name="input_encryption_key_version"></a> [encryption\_key\_version](#input\_encryption\_key\_version) | The version of the key vault key. Omit for automatic key rotation. | `string` | `null` | no |
| <a name="input_encryption_require_infrastructure_encryption"></a> [encryption\_require\_infrastructure\_encryption](#input\_encryption\_require\_infrastructure\_encryption) | Enable a secondary layer of encryption with platform-managed keys. | `bool` | `null` | no |
| <a name="input_https_traffic_only_enabled"></a> [https\_traffic\_only\_enabled](#input\_https\_traffic\_only\_enabled) | Allow only HTTPS traffic to the storage service. Default is true. | `bool` | `true` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The type of managed identity. Options: None, SystemAssigned, UserAssigned, SystemAssigned,UserAssigned. | `string` | `null` | no |
| <a name="input_identity_user_assigned_identity_ids"></a> [identity\_user\_assigned\_identity\_ids](#input\_identity\_user\_assigned\_identity\_ids) | List of user-assigned managed identity ARM resource IDs to associate with this storage account. | `list(string)` | `null` | no |
| <a name="input_is_hns_enabled"></a> [is\_hns\_enabled](#input\_is\_hns\_enabled) | Enable Hierarchical Namespace (Azure Data Lake Storage Gen2). Immutable after creation. | `bool` | `null` | no |
| <a name="input_kind"></a> [kind](#input\_kind) | The type of storage account. Options: Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region in which the storage account is created. Cannot be changed after creation. | `string` | n/a | yes |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | Minimum TLS version permitted on requests. Options: TLS1\_0, TLS1\_1, TLS1\_2. | `string` | `"TLS1_2"` | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Network ACL rules. When set, default\_action must be 'Allow' or 'Deny'. | <pre>object({<br/>    default_action             = string<br/>    bypass                     = optional(list(string), ["AzureServices"])<br/>    ip_rules                   = optional(list(string), [])<br/>    virtual_network_subnet_ids = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Control public network access. Options: Enabled, Disabled, SecuredByPerimeter. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the storage account. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name. Options: Standard\_LRS, Standard\_GRS, Standard\_RAGRS, Standard\_ZRS, Premium\_LRS, Premium\_ZRS, Standard\_GZRS, Standard\_RAGZRS. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID in which the storage account is created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the storage account (maximum 15). | `map(string)` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Pinned logical availability zones for the storage account. | `list(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this storage account. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the storage account. |
| <a name="output_kind"></a> [kind](#output\_kind) | The kind of the storage account (plan-time, echoes input). |
| <a name="output_location"></a> [location](#output\_location) | The Azure region where the storage account is deployed (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the storage account (plan-time, echoes input). |
| <a name="output_primary_blob_endpoint"></a> [primary\_blob\_endpoint](#output\_primary\_blob\_endpoint) | The primary Blob service endpoint URL. |
| <a name="output_primary_dfs_endpoint"></a> [primary\_dfs\_endpoint](#output\_primary\_dfs\_endpoint) | The primary Data Lake Storage Gen2 (DFS) endpoint URL. |
| <a name="output_primary_file_endpoint"></a> [primary\_file\_endpoint](#output\_primary\_file\_endpoint) | The primary File service endpoint URL. |
| <a name="output_primary_queue_endpoint"></a> [primary\_queue\_endpoint](#output\_primary\_queue\_endpoint) | The primary Queue service endpoint URL. |
| <a name="output_primary_table_endpoint"></a> [primary\_table\_endpoint](#output\_primary\_table\_endpoint) | The primary Table service endpoint URL. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the storage account (e.g. Succeeded). |
| <a name="output_sku_name"></a> [sku\_name](#output\_sku\_name) | The SKU name of the storage account (plan-time, echoes input). |
| <a name="output_type"></a> [type](#output\_type) | The resource type string returned by ARM (Microsoft.Storage/storageAccounts). |
<!-- END_TF_DOCS -->