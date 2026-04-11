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
| [rest_operation.check_access](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/operation) | resource |
| [rest_resource.billing_associated_tenant](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_billing_account_name"></a> [billing\_account\_name](#input\_billing\_account\_name) | The ID that uniquely identifies the billing account (e.g. '12345678' or a GUID:GUID\_YYYY-MM-DD format). | `string` | n/a | yes |
| <a name="input_billing_management_state"></a> [billing\_management\_state](#input\_billing\_management\_state) | Whether users from the associated tenant can be assigned billing roles. One of: Active, NotAllowed, Revoked. | `string` | `"Active"` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | A friendly name for the associated tenant (displayed in Cost Management + Billing). | `string` | n/a | yes |
| <a name="input_precheck_access"></a> [precheck\_access](#input\_precheck\_access) | When true, calls the billing checkAccess API before creating the resource to verify the caller has write permission. Fails with a descriptive error if access is denied. | `bool` | `false` | no |
| <a name="input_provisioning_management_state"></a> [provisioning\_management\_state](#input\_provisioning\_management\_state) | Whether subscriptions/licenses can be provisioned in the associated tenant. One of: Active, NotRequested, Pending, Revoked. | `string` | `"NotRequested"` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The tenant ID (GUID) of the tenant to associate with the billing account. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_access_check_delete"></a> [access\_check\_delete](#output\_access\_check\_delete) | Whether the caller has delete permission on associated tenants. Null if precheck\_access is false. |
| <a name="output_access_check_write"></a> [access\_check\_write](#output\_access\_check\_write) | Whether the caller has write permission on associated tenants. Null if precheck\_access is false. |
| <a name="output_approval_url"></a> [approval\_url](#output\_approval\_url) | Portal URL for the target tenant's Global Admin to approve the provisioning request. |
| <a name="output_billing_account_name"></a> [billing\_account\_name](#output\_billing\_account\_name) | The billing account name (echoes input). |
| <a name="output_billing_management_state"></a> [billing\_management\_state](#output\_billing\_management\_state) | The billing management state of the associated tenant. |
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | The friendly display name (echoes input). |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the associated billing tenant. |
| <a name="output_provisioning_billing_request_id"></a> [provisioning\_billing\_request\_id](#output\_provisioning\_billing\_request\_id) | The unique identifier for the billing request created when enabling provisioning. |
| <a name="output_provisioning_management_state"></a> [provisioning\_management\_state](#output\_provisioning\_management\_state) | The provisioning management state of the associated tenant. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the associated tenant. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | The associated tenant ID (echoes input). |
<!-- END_TF_DOCS -->