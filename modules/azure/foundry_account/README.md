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
| [rest_resource.foundry_account](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The name of the Azure AI Foundry account (2–64 chars, alphanumeric, hyphens, underscores, dots). | `string` | n/a | yes |
| <a name="input_allow_project_management"></a> [allow\_project\_management](#input\_allow\_project\_management) | When true, enables project management as child resources (Microsoft.CognitiveServices/accounts/projects). Required to create Foundry projects under this account. | `bool` | `null` | no |
| <a name="input_allowed_fqdn_list"></a> [allowed\_fqdn\_list](#input\_allowed\_fqdn\_list) | List of fully qualified domain names (FQDNs) allowed for outbound network access when restrict\_outbound\_network\_access is true. | `list(string)` | `null` | no |
| <a name="input_aml_workspace_identity_client_id"></a> [aml\_workspace\_identity\_client\_id](#input\_aml\_workspace\_identity\_client\_id) | Client ID of the managed identity used to access the AML workspace. | `string` | `null` | no |
| <a name="input_aml_workspace_resource_id"></a> [aml\_workspace\_resource\_id](#input\_aml\_workspace\_resource\_id) | Full resource ID of a user-owned Azure Machine Learning workspace to associate. Used for hybrid AI/ML scenarios. | `string` | `null` | no |
| <a name="input_associated_projects"></a> [associated\_projects](#input\_associated\_projects) | List of project names associated with this Foundry account. Projects must exist as child resources. | `list(string)` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_custom_sub_domain_name"></a> [custom\_sub\_domain\_name](#input\_custom\_sub\_domain\_name) | Custom subdomain for the Foundry account endpoint (e.g. 'my-foundry' → 'https://my-foundry.cognitiveservices.azure.com/'). Must be globally unique. | `string` | `null` | no |
| <a name="input_default_project"></a> [default\_project](#input\_default\_project) | The default project name targeted when data plane endpoints are called without an explicit project parameter. | `string` | `null` | no |
| <a name="input_disable_local_auth"></a> [disable\_local\_auth](#input\_disable\_local\_auth) | When true, disables local authentication (API key auth) and requires Azure AD tokens. Defaults to true for SOC2 compliance. Set false only for development or legacy integrations. | `bool` | `true` | no |
| <a name="input_dynamic_throttling_enabled"></a> [dynamic\_throttling\_enabled](#input\_dynamic\_throttling\_enabled) | When true, enables dynamic throttling to automatically adjust request rates based on capacity. | `bool` | `null` | no |
| <a name="input_encryption_identity_client_id"></a> [encryption\_identity\_client\_id](#input\_encryption\_identity\_client\_id) | Client ID of the user-assigned managed identity used to access the Key Vault for CMK. The identity must have the 'Key Vault Crypto User' role on the vault. | `string` | `null` | no |
| <a name="input_encryption_key_name"></a> [encryption\_key\_name](#input\_encryption\_key\_name) | Name of the encryption key in Key Vault. Required when encryption\_key\_source is 'Microsoft.KeyVault'. | `string` | `null` | no |
| <a name="input_encryption_key_source"></a> [encryption\_key\_source](#input\_encryption\_key\_source) | Key source for encryption at rest:<br/>- null or 'Microsoft.CognitiveServices': Microsoft-managed keys (default, no extra cost)<br/>- 'Microsoft.KeyVault': Customer-managed keys (CMK) — requires encryption\_key\_vault\_uri,<br/>  encryption\_key\_name, and a user-assigned identity with Key Vault Crypto User role. | `string` | `null` | no |
| <a name="input_encryption_key_vault_uri"></a> [encryption\_key\_vault\_uri](#input\_encryption\_key\_vault\_uri) | URI of the Azure Key Vault containing the customer-managed key (e.g. 'https://my-kv.vault.azure.net/'). Required when encryption\_key\_source is 'Microsoft.KeyVault'. | `string` | `null` | no |
| <a name="input_encryption_key_version"></a> [encryption\_key\_version](#input\_encryption\_key\_version) | Version of the encryption key. Leave null to always use the latest key version (auto-rotation). Pin to a specific version for manual rotation control. | `string` | `null` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The managed identity type: None, SystemAssigned, UserAssigned, or 'SystemAssigned, UserAssigned'. SystemAssigned is recommended for most Foundry deployments. | `string` | `null` | no |
| <a name="input_identity_user_assigned_identity_ids"></a> [identity\_user\_assigned\_identity\_ids](#input\_identity\_user\_assigned\_identity\_ids) | List of user-assigned managed identity resource IDs. Required when identity\_type is 'UserAssigned' or 'SystemAssigned, UserAssigned'. | `list(string)` | `null` | no |
| <a name="input_kind"></a> [kind](#input\_kind) | The kind of Cognitive Services account. Must be 'AIFoundry' for Azure AI Foundry v2 (the new Microsoft Foundry experience). Do NOT use 'OpenAI' or legacy kinds. | `string` | `"AIFoundry"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region in which to create the Foundry account. | `string` | n/a | yes |
| <a name="input_network_acls_bypass"></a> [network\_acls\_bypass](#input\_network\_acls\_bypass) | Services allowed to bypass network ACLs: 'AzureServices' or 'None'. Use 'AzureServices' to allow trusted Microsoft services. | `string` | `null` | no |
| <a name="input_network_acls_default_action"></a> [network\_acls\_default\_action](#input\_network\_acls\_default\_action) | Default network ACL action when no rule matches: 'Allow' or 'Deny'. Defaults to 'Deny' for SOC2 compliance. | `string` | `"Deny"` | no |
| <a name="input_network_acls_ip_rules"></a> [network\_acls\_ip\_rules](#input\_network\_acls\_ip\_rules) | List of IPv4 CIDR ranges allowed through network ACLs (e.g. ['203.0.113.0/24']). Applied in addition to virtual network rules. | `list(string)` | `null` | no |
| <a name="input_network_acls_virtual_network_rules"></a> [network\_acls\_virtual\_network\_rules](#input\_network\_acls\_virtual\_network\_rules) | List of virtual network subnet rules. Each entry requires the full subnet resource ID. | <pre>list(object({<br/>    id                                   = string<br/>    ignore_missing_vnet_service_endpoint = optional(bool, false)<br/>  }))</pre> | `null` | no |
| <a name="input_network_injections"></a> [network\_injections](#input\_network\_injections) | Network injections for AI Foundry Agent compute. Each entry injects a subnet<br/>into the Foundry account for the specified scenario.<br/><br/>- scenario: 'agent' (Agents service) or 'none' (no injection)<br/>- subnet\_arm\_id: Full resource ID of the subnet to delegate<br/>- use\_microsoft\_managed\_network: Set true to use Microsoft-managed network<br/>  instead of injecting a customer subnet (requires AI.ManagedVnetPreview feature flag) | <pre>list(object({<br/>    scenario                      = string<br/>    subnet_arm_id                 = string<br/>    use_microsoft_managed_network = optional(bool, false)<br/>  }))</pre> | `null` | no |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Controls public network access: 'Enabled' or 'Disabled'. Defaults to 'Disabled' for SOC2 compliance. Set to 'Enabled' for development or when using managed VNet isolation instead. | `string` | `"Disabled"` | no |
| <a name="input_rai_monitor_config_identity_client_id"></a> [rai\_monitor\_config\_identity\_client\_id](#input\_rai\_monitor\_config\_identity\_client\_id) | Client ID of the managed identity used to access the RAI monitoring storage account. | `string` | `null` | no |
| <a name="input_rai_monitor_config_storage_resource_id"></a> [rai\_monitor\_config\_storage\_resource\_id](#input\_rai\_monitor\_config\_storage\_resource\_id) | Resource ID of the storage account used for Responsible AI (RAI) monitoring data. Required when RAI monitoring is enabled. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the Foundry account is created. | `string` | n/a | yes |
| <a name="input_restore"></a> [restore](#input\_restore) | When true, restores a previously soft-deleted Foundry account with the same name. Use when recreating a deleted account to reuse the same name and endpoint. | `bool` | `null` | no |
| <a name="input_restrict_outbound_network_access"></a> [restrict\_outbound\_network\_access](#input\_restrict\_outbound\_network\_access) | When true, restricts all outbound network access from the Foundry account. Use with network\_acls\_ip\_rules or private endpoints to allow specific destinations. | `bool` | `null` | no |
| <a name="input_sku_capacity"></a> [sku\_capacity](#input\_sku\_capacity) | Optional capacity for the SKU when the SKU supports scale out/in. | `number` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name for the Foundry account. Use 'S0' for the standard pay-as-you-go tier. | `string` | n/a | yes |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The SKU tier: Basic, Enterprise, Free, Premium, or Standard. Optional — most Foundry accounts use sku\_name alone. | `string` | `null` | no |
| <a name="input_stored_completions_disabled"></a> [stored\_completions\_disabled](#input\_stored\_completions\_disabled) | When true, disables storing of model completions. Enable for data sovereignty or compliance requirements. | `bool` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID in which the Foundry account is created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the Foundry account resource. | `map(string)` | `null` | no |
| <a name="input_user_owned_storage"></a> [user\_owned\_storage](#input\_user\_owned\_storage) | List of user-owned Azure Storage accounts associated with this Foundry account.<br/>Used for storing completions, evaluation data, and other account data.<br/><br/>- resource\_id: Full ARM resource ID of the storage account<br/>- identity\_client\_id: Client ID of the managed identity used to access storage | <pre>list(object({<br/>    resource_id        = string<br/>    identity_client_id = optional(string, null)<br/>  }))</pre> | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_account_name"></a> [account\_name](#output\_account\_name) | The name of the Foundry account (plan-time, echoes input). |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this resource. |
| <a name="output_date_created"></a> [date\_created](#output\_date\_created) | The UTC timestamp when the Foundry account was created. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The HTTPS endpoint URL of the Foundry account (e.g. https://my-foundry.cognitiveservices.azure.com/). |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the Foundry account (plan-time). |
| <a name="output_internal_id"></a> [internal\_id](#output\_internal\_id) | The internal Azure-assigned account ID. |
| <a name="output_kind"></a> [kind](#output\_kind) | The kind of the Foundry account (plan-time, echoes input). |
| <a name="output_location"></a> [location](#output\_location) | The Azure region of the Foundry account (plan-time, echoes input). |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The principal (object) ID of the system-assigned managed identity. Null if identity\_type is not SystemAssigned. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Foundry account (e.g. Succeeded). |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name (plan-time, echoes input). |
| <a name="output_sku_name"></a> [sku\_name](#output\_sku\_name) | The SKU name of the Foundry account (plan-time, echoes input). |
| <a name="output_tenant_id_identity"></a> [tenant\_id\_identity](#output\_tenant\_id\_identity) | The tenant ID of the system-assigned managed identity. |
<!-- END_TF_DOCS -->