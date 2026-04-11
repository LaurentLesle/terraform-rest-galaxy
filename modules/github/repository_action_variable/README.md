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
| [rest_resource.action_variable](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_name"></a> [name](#input\_name) | The name of the Actions variable (e.g. AZURE\_CLIENT\_ID). | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | The account owner of the repository (user or organization). | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | The repository name (without .git extension). | `string` | n/a | yes |
| <a name="input_value"></a> [value](#input\_value) | The value of the Actions variable. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_name"></a> [name](#output\_name) | The name of the Actions variable. |
| <a name="output_owner"></a> [owner](#output\_owner) | The repository owner. |
| <a name="output_repo"></a> [repo](#output\_repo) | The repository name. |
| <a name="output_value"></a> [value](#output\_value) | The current value of the variable (plan-time, echoes input). |
<!-- END_TF_DOCS -->