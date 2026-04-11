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
| [rest_operation.key_vault_key](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/operation) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_curve_name"></a> [curve\_name](#input\_curve\_name) | The elliptic curve name for EC keys. Options: P-256, P-256K, P-384, P-521. | `string` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the key to create. | `string` | n/a | yes |
| <a name="input_key_ops"></a> [key\_ops](#input\_key\_ops) | List of permitted JSON web key operations. Options: encrypt, decrypt, sign, verify, wrapKey, unwrapKey. | `list(string)` | `null` | no |
| <a name="input_key_size"></a> [key\_size](#input\_key\_size) | The key size in bits. For RSA: 2048, 3072, or 4096. | `number` | `null` | no |
| <a name="input_key_type"></a> [key\_type](#input\_key\_type) | The type of the key. Options: EC, EC-HSM, RSA, RSA-HSM. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group containing the key vault. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the key. | `map(string)` | `null` | no |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | The name of the key vault in which to create the key. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this key. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the key. |
| <a name="output_key_uri"></a> [key\_uri](#output\_key\_uri) | The URI to retrieve the current version of the key. |
| <a name="output_key_uri_with_version"></a> [key\_uri\_with\_version](#output\_key\_uri\_with\_version) | The URI to retrieve the specific version of the key. |
| <a name="output_name"></a> [name](#output\_name) | The name of the key (plan-time, echoes input). |
| <a name="output_type"></a> [type](#output\_type) | The resource type string returned by ARM. |
<!-- END_TF_DOCS -->