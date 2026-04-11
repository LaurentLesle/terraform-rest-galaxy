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
| [rest_operation.check_domain_availability](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/operation) | resource |
| [rest_resource.app_service_domain](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auto_renew"></a> [auto\_renew](#input\_auto\_renew) | Automatically renew the domain. | `bool` | `true` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_consent_agreed_at"></a> [consent\_agreed\_at](#input\_consent\_agreed\_at) | ISO 8601 timestamp when the legal agreements were accepted (e.g. 2026-04-07T00:00:00Z). | `string` | n/a | yes |
| <a name="input_consent_agreed_by"></a> [consent\_agreed\_by](#input\_consent\_agreed\_by) | IP address of the person who agreed to the legal agreements. | `string` | n/a | yes |
| <a name="input_consent_agreement_keys"></a> [consent\_agreement\_keys](#input\_consent\_agreement\_keys) | List of legal agreement keys. Retrieve using TopLevelDomains\_ListAgreements API. Empty list accepts all agreements. | `list(string)` | `[]` | no |
| <a name="input_contact_admin"></a> [contact\_admin](#input\_contact\_admin) | Administrative contact for domain registration. | <pre>object({<br/>    first_name    = string<br/>    last_name     = string<br/>    email         = string<br/>    phone         = string<br/>    organization  = optional(string, null)<br/>    job_title     = optional(string, null)<br/>    fax           = optional(string, null)<br/>    middle_name   = optional(string, null)<br/>    address_line1 = optional(string, null)<br/>    address_line2 = optional(string, null)<br/>    city          = optional(string, null)<br/>    state         = optional(string, null)<br/>    country       = optional(string, null)<br/>    postal_code   = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_contact_billing"></a> [contact\_billing](#input\_contact\_billing) | Billing contact for domain registration. | <pre>object({<br/>    first_name    = string<br/>    last_name     = string<br/>    email         = string<br/>    phone         = string<br/>    organization  = optional(string, null)<br/>    job_title     = optional(string, null)<br/>    fax           = optional(string, null)<br/>    middle_name   = optional(string, null)<br/>    address_line1 = optional(string, null)<br/>    address_line2 = optional(string, null)<br/>    city          = optional(string, null)<br/>    state         = optional(string, null)<br/>    country       = optional(string, null)<br/>    postal_code   = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_contact_registrant"></a> [contact\_registrant](#input\_contact\_registrant) | Registrant contact for domain registration (WHOIS owner). | <pre>object({<br/>    first_name    = string<br/>    last_name     = string<br/>    email         = string<br/>    phone         = string<br/>    organization  = optional(string, null)<br/>    job_title     = optional(string, null)<br/>    fax           = optional(string, null)<br/>    middle_name   = optional(string, null)<br/>    address_line1 = optional(string, null)<br/>    address_line2 = optional(string, null)<br/>    city          = optional(string, null)<br/>    state         = optional(string, null)<br/>    country       = optional(string, null)<br/>    postal_code   = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_contact_tech"></a> [contact\_tech](#input\_contact\_tech) | Technical contact for domain registration. | <pre>object({<br/>    first_name    = string<br/>    last_name     = string<br/>    email         = string<br/>    phone         = string<br/>    organization  = optional(string, null)<br/>    job_title     = optional(string, null)<br/>    fax           = optional(string, null)<br/>    middle_name   = optional(string, null)<br/>    address_line1 = optional(string, null)<br/>    address_line2 = optional(string, null)<br/>    city          = optional(string, null)<br/>    state         = optional(string, null)<br/>    country       = optional(string, null)<br/>    postal_code   = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_dns_type"></a> [dns\_type](#input\_dns\_type) | DNS type: AzureDns or DefaultDomainRegistrarDns. | `string` | `"AzureDns"` | no |
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | Azure DNS zone resource ID. When dns\_type is AzureDns, Azure auto-creates a zone if omitted. | `string` | `null` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to register (e.g. contoso.com). | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The geo-location. App Service Domains use 'global'. | `string` | `"global"` | no |
| <a name="input_privacy"></a> [privacy](#input\_privacy) | Enable WHOIS privacy protection. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the domain. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the domain. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this domain. |
| <a name="output_dns_zone_id"></a> [dns\_zone\_id](#output\_dns\_zone\_id) | The Azure DNS zone resource ID associated with this domain. |
| <a name="output_expiration_time"></a> [expiration\_time](#output\_expiration\_time) | The domain expiration timestamp. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the App Service Domain. |
| <a name="output_location"></a> [location](#output\_location) | The location (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The domain name (plan-time, echoes input). |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | The name servers for the domain. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the domain. |
| <a name="output_registration_status"></a> [registration\_status](#output\_registration\_status) | The domain registration status (e.g. Active, Pending). |
<!-- END_TF_DOCS -->