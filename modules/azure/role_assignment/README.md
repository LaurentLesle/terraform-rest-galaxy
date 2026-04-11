<!-- BEGIN_TF_DOCS -->


## Requirements

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |
| <a name="requirement_rest"></a> [rest](#requirement\_rest) | = 1.2.0 |

## Providers

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |
| <a name="provider_rest"></a> [rest](#provider\_rest) | = 1.2.0 |

## Resources

## Resources

| Name | Type |
| ---- | ---- |
| [random_uuid.role_assignment_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [rest_resource.role_assignment](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_condition"></a> [condition](#input\_condition) | The conditions on the role assignment. | `string` | `null` | no |
| <a name="input_condition_version"></a> [condition\_version](#input\_condition\_version) | Version of the condition. Currently only '2.0' is accepted. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the role assignment. | `string` | `null` | no |
| <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id) | The object ID of the principal (user, group, or service principal) to assign the role to. | `string` | n/a | yes |
| <a name="input_principal_type"></a> [principal\_type](#input\_principal\_type) | The type of the principal. Options: User, Group, ServicePrincipal, ForeignGroup, Device. | `string` | `"ServicePrincipal"` | no |
| <a name="input_role_definition_id"></a> [role\_definition\_id](#input\_role\_definition\_id) | The full ARM role definition ID (e.g. /subscriptions/{sub}/providers/Microsoft.Authorization/roleDefinitions/{guid}). | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | The ARM resource ID of the scope for the role assignment (e.g. subscription, resource group, or resource). | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The subscription ID, used to normalise provider-relative role definition IDs. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this role assignment. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the role assignment. |
| <a name="output_name"></a> [name](#output\_name) | The GUID name of the role assignment. |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The principal ID of the role assignment. |
| <a name="output_role_definition_id"></a> [role\_definition\_id](#output\_role\_definition\_id) | The role definition ID of the role assignment. |
| <a name="output_scope"></a> [scope](#output\_scope) | The scope of the role assignment. |
| <a name="output_type"></a> [type](#output\_type) | The resource type string returned by ARM. |
<!-- END_TF_DOCS -->