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
| [rest_operation.import_image](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/operation) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_mode"></a> [mode](#input\_mode) | Import mode: Force or NoForce. | `string` | `"Force"` | no |
| <a name="input_registry_name"></a> [registry\_name](#input\_registry\_name) | The name of the target container registry. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name of the target registry. | `string` | n/a | yes |
| <a name="input_source_image"></a> [source\_image](#input\_source\_image) | Source image reference (repo:tag or repo@digest). | `string` | n/a | yes |
| <a name="input_source_registry_uri"></a> [source\_registry\_uri](#input\_source\_registry\_uri) | The source registry URI (e.g. 'mcr.microsoft.com'). | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_target_tags"></a> [target\_tags](#input\_target\_tags) | List of target tags (repo:tag). Defaults to source tag. | `list(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_registry_name"></a> [registry\_name](#output\_registry\_name) | The target registry name. |
| <a name="output_source_image"></a> [source\_image](#output\_source\_image) | The source image that was imported. |
<!-- END_TF_DOCS -->