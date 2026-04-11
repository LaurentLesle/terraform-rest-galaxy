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
| [rest_resource.key_vault](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | The vault's create mode. Set to 'recover' to recover a soft-deleted vault with the same name. Options: recover, default. When null, omitted from the request (normal create). | `string` | `null` | no |
| <a name="input_enable_purge_protection"></a> [enable\_purge\_protection](#input\_enable\_purge\_protection) | Enable purge protection. Once enabled, cannot be disabled. Requires soft delete. | `bool` | `null` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Use RBAC for data plane authorization instead of access policies. Default is true. | `bool` | `true` | no |
| <a name="input_enable_soft_delete"></a> [enable\_soft\_delete](#input\_enable\_soft\_delete) | Enable soft delete. Default is true; cannot be reverted to false once set. | `bool` | `true` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Allow Azure VMs to retrieve certificates stored as secrets. | `bool` | `null` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Allow Azure Disk Encryption to retrieve secrets and unwrap keys. | `bool` | `null` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | Allow Azure Resource Manager to retrieve secrets. | `bool` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region in which the key vault is created. | `string` | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Network ACL rules for the key vault. | <pre>object({<br/>    default_action = string<br/>    bypass         = optional(string, "AzureServices")<br/>    ip_rules       = optional(list(string), [])<br/>    virtual_network_rules = optional(list(object({<br/>      id = string<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Control public network access. Options: enabled, disabled. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the key vault. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name of the key vault. Options: standard, premium. | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_in_days"></a> [soft\_delete\_retention\_in\_days](#input\_soft\_delete\_retention\_in\_days) | Soft delete retention in days (7–90). Default is 90. | `number` | `90` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID in which the key vault is created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the key vault. | `map(string)` | `null` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The Azure Active Directory tenant ID for authenticating requests to the key vault. | `string` | n/a | yes |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | The name of the key vault. Globally unique, 3–24 alphanumeric and hyphens. | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this key vault. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the key vault. |
| <a name="output_location"></a> [location](#output\_location) | The Azure region where the key vault is deployed (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the key vault (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the key vault. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | The tenant ID associated with this key vault. |
| <a name="output_type"></a> [type](#output\_type) | The resource type string returned by ARM. |
| <a name="output_vault_uri"></a> [vault\_uri](#output\_vault\_uri) | The URI of the vault for performing operations on keys and secrets (plan-time computed). |
<!-- END_TF_DOCS -->