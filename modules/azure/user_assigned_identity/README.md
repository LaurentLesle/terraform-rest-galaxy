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
| [rest_resource.user_assigned_identity](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_identity_name"></a> [identity\_name](#input\_identity\_name) | The name of the user-assigned managed identity. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region in which the identity is created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the identity. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID in which the user-assigned identity is created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the identity. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this identity. |
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | The client (application) ID associated with this identity. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the user-assigned managed identity. |
| <a name="output_location"></a> [location](#output\_location) | The Azure region where the identity is deployed (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the identity (plan-time, echoes input). |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The object (principal) ID of the service principal associated with this identity. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | The tenant ID of the identity. |
<!-- END_TF_DOCS -->