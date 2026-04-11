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
| [rest_resource.github_network_settings](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_business_id"></a> [business\_id](#input\_business\_id) | The GitHub database ID of the organization or enterprise. | `string` | n/a | yes |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_network_settings_name"></a> [network\_settings\_name](#input\_network\_settings\_name) | The name of the GitHub.Network networkSettings resource. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The full ARM resource ID of the subnet delegated to GitHub.Network/networkSettings. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_business_id"></a> [business\_id](#output\_business\_id) | The GitHub business (organization/enterprise) ID. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the GitHub.Network networkSettings resource. |
| <a name="output_location"></a> [location](#output\_location) | The location of the networkSettings resource. |
| <a name="output_name"></a> [name](#output\_name) | The name of the networkSettings resource. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state. |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | The subnet ID associated with this network settings resource. |
<!-- END_TF_DOCS -->