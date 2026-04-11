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
| [rest_resource.secret](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.public_key](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_organization"></a> [organization](#input\_organization) | The GitHub organization name. | `string` | n/a | yes |
| <a name="input_plaintext_value"></a> [plaintext\_value](#input\_plaintext\_value) | The secret value in plain text. It will be encrypted with the organization's public key before upload. | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | The name of the organization-scoped Actions secret (e.g. NPM\_TOKEN). | `string` | n/a | yes |
| <a name="input_selected_repository_ids"></a> [selected\_repository\_ids](#input\_selected\_repository\_ids) | List of numeric repository IDs that can access the secret. Required (and only valid) when visibility = 'selected'. | `list(number)` | `null` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Which type of organization repositories have access to the secret. One of: all, private, selected. When set to 'selected', you must also provide selected\_repository\_ids. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_name"></a> [name](#output\_name) | The name of the organization-scoped Actions secret. |
| <a name="output_organization"></a> [organization](#output\_organization) | The GitHub organization. |
| <a name="output_visibility"></a> [visibility](#output\_visibility) | Which type of organization repositories have access to the secret (all, private, selected). |
<!-- END_TF_DOCS -->