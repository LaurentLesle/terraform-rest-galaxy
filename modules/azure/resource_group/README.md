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
| [rest_resource.resource_group](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the resource group. It cannot be changed after the resource group has been created. It must be one of the supported Azure locations. | `string` | n/a | yes |
| <a name="input_managed_by"></a> [managed\_by](#input\_managed\_by) | The ID of the resource that manages this resource group. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group to create or update. | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID in which the resource group is created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags attached to the resource group. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this resource group. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the resource group (e.g. /subscriptions/.../resourcegroups/myRG). |
| <a name="output_location"></a> [location](#output\_location) | The location of the resource group (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the resource group (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the resource group (e.g. Succeeded). |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group (echoes the input for cross-module references). |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags attached to the resource group (plan-time, echoes input). |
| <a name="output_type"></a> [type](#output\_type) | The resource type string returned by ARM (e.g. Microsoft.Resources/resourceGroups). |
<!-- END_TF_DOCS -->