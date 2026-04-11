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
| [rest_resource.network_manager](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | A description of the network manager. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_network_manager_name"></a> [network\_manager\_name](#input\_network\_manager\_name) | The name of the network manager. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_scope_accesses"></a> [scope\_accesses](#input\_scope\_accesses) | Scope Access types. Valid values: SecurityAdmin, Connectivity, SecurityUser, Routing. | `list(string)` | `null` | no |
| <a name="input_scope_management_groups"></a> [scope\_management\_groups](#input\_scope\_management\_groups) | List of management group resource IDs in scope. E.g. ["/Microsoft.Management/managementGroups/mg1"]. | `list(string)` | `null` | no |
| <a name="input_scope_subscriptions"></a> [scope\_subscriptions](#input\_scope\_subscriptions) | List of subscription resource IDs in the network manager scope. E.g. ["/subscriptions/00000000-..."]. | `list(string)` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the network manager. |
| <a name="output_location"></a> [location](#output\_location) | The location of the network manager. |
| <a name="output_name"></a> [name](#output\_name) | The name of the network manager. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name (echoes input). |
<!-- END_TF_DOCS -->