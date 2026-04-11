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
| [rest_operation.mca_invoice_section_role_request](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/operation) | resource |
| [rest_resource.ea_role_assignment](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.mca_role_assignment](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_billing_account_name"></a> [billing\_account\_name](#input\_billing\_account\_name) | The billing account ID (e.g. '12345678-...:12345678-...\_2019-05-31'). | `string` | n/a | yes |
| <a name="input_billing_request_id"></a> [billing\_request\_id](#input\_billing\_request\_id) | The billing request GUID from a previous POST at a scope that requires<br/>approval (e.g. invoice section). When set, the module skips the POST<br/>(request already exists) and outputs this ID directly. | `string` | `null` | no |
| <a name="input_billing_scope"></a> [billing\_scope](#input\_billing\_scope) | Optional billing scope path to assign the role at a sub-account level<br/>(billing profile or invoice section). When null, the role is assigned at<br/>the billing account level.<br/><br/>Example (invoice section):<br/>  /providers/Microsoft.Billing/billingAccounts/{name}/billingProfiles/{profile}/invoiceSections/{section} | `string` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the role assignment already exists before creating it. | `bool` | `false` | no |
| <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id) | The object ID of the principal (user, group, or service principal) to assign the role to. | `string` | n/a | yes |
| <a name="input_principal_tenant_id"></a> [principal\_tenant\_id](#input\_principal\_tenant\_id) | The tenant ID of the principal. | `string` | n/a | yes |
| <a name="input_principal_type"></a> [principal\_type](#input\_principal\_type) | The type of the principal. Options: User, Group, ServicePrincipal, DirectoryRole, Everyone. | `string` | `"ServicePrincipal"` | no |
| <a name="input_role_definition_id"></a> [role\_definition\_id](#input\_role\_definition\_id) | The billing role definition ID. Can be a full path or just the GUID name.<br/>Full path example: /providers/Microsoft.Billing/billingAccounts/{name}/billingRoleDefinitions/{guid}<br/>GUID-only example: 10000000-aaaa-bbbb-cccc-100000000002 | `string` | n/a | yes |
| <a name="input_user_email_address"></a> [user\_email\_address](#input\_user\_email\_address) | The email address of the user. Supported only for Enterprise Agreement billing accounts. | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this billing role assignment. |
| <a name="output_billing_request_id"></a> [billing\_request\_id](#output\_billing\_request\_id) | The billing request ID when the role assignment requires approval. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the billing role assignment. |
| <a name="output_name"></a> [name](#output\_name) | The GUID name of the billing role assignment. |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The principal ID of the billing role assignment. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the billing role assignment. |
| <a name="output_role_definition_id"></a> [role\_definition\_id](#output\_role\_definition\_id) | The role definition ID of the billing role assignment. |
| <a name="output_scope"></a> [scope](#output\_scope) | The scope of the billing role assignment. |
<!-- END_TF_DOCS -->