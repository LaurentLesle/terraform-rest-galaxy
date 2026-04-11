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
| [rest_resource.billing_permission_request](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.billing_request_approval](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_billing_request_id"></a> [billing\_request\_id](#input\_billing\_request\_id) | The billing request GUID for GA billingRequests API (2024-04-01) approval.<br/>Used for invoice-section-scoped role assignment requests that require<br/>approval by an invoice section owner.<br/>Mutually exclusive with provisioning\_billing\_request\_id. | `string` | `null` | no |
| <a name="input_provisioning_billing_request_id"></a> [provisioning\_billing\_request\_id](#input\_provisioning\_billing\_request\_id) | The full ARM path of the billing request, as returned by the associated-tenant<br/>resource (e.g. /providers/Microsoft.Billing/billingRequests/<GUID>).<br/>The module extracts the GUID and builds the permissionRequests path.<br/>Mutually exclusive with billing\_request\_id. | `string` | `null` | no |
| <a name="input_status"></a> [status](#input\_status) | The desired status for the permission request. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The request path. |
| <a name="output_output"></a> [output](#output\_output) | The full API response. |
| <a name="output_status"></a> [status](#output\_status) | The approval status. |
<!-- END_TF_DOCS -->