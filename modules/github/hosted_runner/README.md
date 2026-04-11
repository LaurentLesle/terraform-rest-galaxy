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
| [rest_resource.hosted_runner](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_enable_static_ip"></a> [enable\_static\_ip](#input\_enable\_static\_ip) | Whether to create the runner with a static public IP. | `bool` | `null` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The image ID (e.g. 'ubuntu-22.04', 'ubuntu-24.04'). | `string` | n/a | yes |
| <a name="input_image_source"></a> [image\_source](#input\_image\_source) | The image source: github, partner, or custom. | `string` | `"github"` | no |
| <a name="input_maximum_runners"></a> [maximum\_runners](#input\_maximum\_runners) | Maximum number of runners to scale up to. Limits cost. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the hosted runner (1-64 chars, alphanumeric, '.', '-', '\_'). | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | The GitHub organization name. | `string` | n/a | yes |
| <a name="input_runner_group_id"></a> [runner\_group\_id](#input\_runner\_group\_id) | The numeric ID of the runner group to add this runner to. | `number` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | The machine size (e.g. '4-core', '8-core', '16-core'). | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The numeric ID of the hosted runner, assigned by GitHub. |
| <a name="output_name"></a> [name](#output\_name) | The name of the hosted runner. |
| <a name="output_organization"></a> [organization](#output\_organization) | The GitHub organization. |
| <a name="output_platform"></a> [platform](#output\_platform) | The operating system platform (e.g. linux-x64). |
| <a name="output_runner_group_id"></a> [runner\_group\_id](#output\_runner\_group\_id) | The runner group ID (input). |
| <a name="output_size"></a> [size](#output\_size) | The machine size. |
| <a name="output_status"></a> [status](#output\_status) | The status of the hosted runner (Ready, Provisioning, etc.). |
<!-- END_TF_DOCS -->