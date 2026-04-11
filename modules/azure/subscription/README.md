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
| [rest_resource.subscription](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_alias_name"></a> [alias\_name](#input\_alias\_name) | The alias name for the subscription. Used as the resource path identifier. | `string` | n/a | yes |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_billing_scope"></a> [billing\_scope](#input\_billing\_scope) | Billing scope of the subscription.<br/>For CustomerLed and FieldLed: /billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections/{invoiceSectionName}<br/>For PartnerLed: /billingAccounts/{billingAccountName}/customers/{customerName}<br/>For Legacy EA: /billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName} | `string` | n/a | yes |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The friendly display name of the subscription. | `string` | n/a | yes |
| <a name="input_management_group_id"></a> [management\_group\_id](#input\_management\_group\_id) | Management group ID for the subscription. | `string` | `null` | no |
| <a name="input_reseller_id"></a> [reseller\_id](#input\_reseller\_id) | Reseller ID for the subscription. | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Existing subscription ID to create an alias for. When null, a new subscription is created. | `string` | `null` | no |
| <a name="input_subscription_owner_id"></a> [subscription\_owner\_id](#input\_subscription\_owner\_id) | Owner ID of the subscription. | `string` | `null` | no |
| <a name="input_subscription_tenant_id"></a> [subscription\_tenant\_id](#input\_subscription\_tenant\_id) | Tenant ID of the subscription. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the subscription. | `map(string)` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | The workload type of the subscription: Production or DevTest. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_alias_name"></a> [alias\_name](#output\_alias\_name) | The alias name (echoes input). |
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | The display name of the subscription (echoes input). |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the subscription alias. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the subscription alias. |
| <a name="output_scope"></a> [scope](#output\_scope) | The subscription-scoped ARM path (/subscriptions/{subscription\_id}), known after apply. Use as the scope input for subscription-level role assignments. |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | The Azure subscription ID created or associated with this alias. |
<!-- END_TF_DOCS -->