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
| [rest_resource.email_communication_service_domain](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_domain_management"></a> [domain\_management](#input\_domain\_management) | How the domain is managed. Options: AzureManaged, CustomerManaged, CustomerManagedInExchangeOnline. | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The name of the domain. Use 'AzureManagedDomain' for Azure-managed domains or a custom domain name. | `string` | n/a | yes |
| <a name="input_email_service_name"></a> [email\_service\_name](#input\_email\_service\_name) | The name of the parent Email Communication Service. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The geo-location where the resource lives. Typically 'global' for Email Communication Service domains. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group containing the Email Communication Service. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the Email Communication Service domain. | `map(string)` | `null` | no |
| <a name="input_user_engagement_tracking"></a> [user\_engagement\_tracking](#input\_user\_engagement\_tracking) | Whether user engagement tracking is enabled or disabled. Options: Enabled, Disabled. | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this domain. |
| <a name="output_domain_management"></a> [domain\_management](#output\_domain\_management) | The domain management type (plan-time, echoes input). |
| <a name="output_email_service_name"></a> [email\_service\_name](#output\_email\_service\_name) | The parent Email Communication Service name (plan-time, echoes input). |
| <a name="output_from_sender_domain"></a> [from\_sender\_domain](#output\_from\_sender\_domain) | P2 sender domain displayed to email recipients. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the Email Communication Service domain. |
| <a name="output_location"></a> [location](#output\_location) | The location of the domain (plan-time, echoes input). |
| <a name="output_mail_from_sender_domain"></a> [mail\_from\_sender\_domain](#output\_mail\_from\_sender\_domain) | P1 sender domain present on the email envelope. |
| <a name="output_name"></a> [name](#output\_name) | The domain name (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the domain. |
| <a name="output_verification_records"></a> [verification\_records](#output\_verification\_records) | The DNS verification records required for domain verification (SPF, DKIM, DKIM2, DMARC). After-apply only. |
<!-- END_TF_DOCS -->