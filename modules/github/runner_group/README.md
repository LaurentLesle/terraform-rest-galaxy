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
| [rest_resource.runner_group](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allows_public_repositories"></a> [allows\_public\_repositories](#input\_allows\_public\_repositories) | Whether the runner group can be used by public repositories. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the runner group. | `string` | n/a | yes |
| <a name="input_network_configuration_id"></a> [network\_configuration\_id](#input\_network\_configuration\_id) | The ARM resource ID of the GitHub.Network/networkSettings resource for VNet injection. | `string` | `null` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | The GitHub organization name. | `string` | n/a | yes |
| <a name="input_restricted_to_workflows"></a> [restricted\_to\_workflows](#input\_restricted\_to\_workflows) | If true, restrict the runner group to the workflows listed in selected\_workflows. | `bool` | `false` | no |
| <a name="input_selected_workflows"></a> [selected\_workflows](#input\_selected\_workflows) | List of workflows the runner group is allowed to run (e.g. 'org/repo/.github/workflows/deploy.yaml@main'). | `list(string)` | `null` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Visibility of the runner group. One of: selected, all, private. | `string` | `"all"` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The numeric ID of the runner group, assigned by GitHub. |
| <a name="output_name"></a> [name](#output\_name) | The name of the runner group. |
| <a name="output_network_configuration_id"></a> [network\_configuration\_id](#output\_network\_configuration\_id) | The ARM resource ID of the network configuration. |
| <a name="output_organization"></a> [organization](#output\_organization) | The GitHub organization. |
| <a name="output_visibility"></a> [visibility](#output\_visibility) | The visibility of the runner group. |
<!-- END_TF_DOCS -->