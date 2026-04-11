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
| <a name="input_owner"></a> [owner](#input\_owner) | The account owner of the repository (user or organization). | `string` | n/a | yes |
| <a name="input_plaintext_value"></a> [plaintext\_value](#input\_plaintext\_value) | The secret value in plain text. It will be encrypted with the repository's public key before upload. | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | The repository name (without .git extension). | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | The name of the Actions secret (e.g. AZURE\_CLIENT\_ID). | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_name"></a> [name](#output\_name) | The name of the Actions secret. |
| <a name="output_owner"></a> [owner](#output\_owner) | The repository owner. |
| <a name="output_repo"></a> [repo](#output\_repo) | The repository name. |
<!-- END_TF_DOCS -->