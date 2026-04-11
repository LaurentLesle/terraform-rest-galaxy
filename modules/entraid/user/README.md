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
| [rest_resource.user](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_account_enabled"></a> [account\_enabled](#input\_account\_enabled) | true if the account is enabled; otherwise, false. | `bool` | n/a | yes |
| <a name="input_city"></a> [city](#input\_city) | The city in which the user is located. Maximum length is 128 characters. | `string` | `null` | no |
| <a name="input_company_name"></a> [company\_name](#input\_company\_name) | The company name associated with the user. Maximum length is 64 characters. | `string` | `null` | no |
| <a name="input_country"></a> [country](#input\_country) | The country/region in which the user is located. Maximum length is 128 characters. | `string` | `null` | no |
| <a name="input_department"></a> [department](#input\_department) | The name for the department in which the user works. Maximum length is 64 characters. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The name displayed in the address book for the user. Maximum length is 256 characters. | `string` | n/a | yes |
| <a name="input_employee_id"></a> [employee\_id](#input\_employee\_id) | The employee identifier assigned by the organization. Maximum length is 16 characters. | `string` | `null` | no |
| <a name="input_employee_type"></a> [employee\_type](#input\_employee\_type) | Captures enterprise worker type (e.g. Employee, Contractor, Consultant, Vendor). | `string` | `null` | no |
| <a name="input_given_name"></a> [given\_name](#input\_given\_name) | The given name (first name) of the user. Maximum length is 64 characters. | `string` | `null` | no |
| <a name="input_job_title"></a> [job\_title](#input\_job\_title) | The user's job title. Maximum length is 128 characters. | `string` | `null` | no |
| <a name="input_mail_nickname"></a> [mail\_nickname](#input\_mail\_nickname) | The mail alias for the user. Maximum length is 64 characters. | `string` | n/a | yes |
| <a name="input_mobile_phone"></a> [mobile\_phone](#input\_mobile\_phone) | The primary cellular telephone number for the user. | `string` | `null` | no |
| <a name="input_office_location"></a> [office\_location](#input\_office\_location) | The office location in the user's place of business. | `string` | `null` | no |
| <a name="input_other_mails"></a> [other\_mails](#input\_other\_mails) | Additional email addresses for the user. | `list(string)` | `null` | no |
| <a name="input_password_profile"></a> [password\_profile](#input\_password\_profile) | The password profile for the user. The password must satisfy the tenant's password policy. | <pre>object({<br/>    password                                    = string<br/>    force_change_password_next_sign_in          = optional(bool, true)<br/>    force_change_password_next_sign_in_with_mfa = optional(bool, false)<br/>  })</pre> | n/a | yes |
| <a name="input_postal_code"></a> [postal\_code](#input\_postal\_code) | The postal code for the user's postal address. | `string` | `null` | no |
| <a name="input_preferred_language"></a> [preferred\_language](#input\_preferred\_language) | The preferred language for the user (ISO 639-1 code, e.g. en-US). | `string` | `null` | no |
| <a name="input_state"></a> [state](#input\_state) | The state or province in the user's address. Maximum length is 128 characters. | `string` | `null` | no |
| <a name="input_street_address"></a> [street\_address](#input\_street\_address) | The street address of the user's place of business. Maximum length is 1024 characters. | `string` | `null` | no |
| <a name="input_surname"></a> [surname](#input\_surname) | The user's surname (family name or last name). Maximum length is 64 characters. | `string` | `null` | no |
| <a name="input_usage_location"></a> [usage\_location](#input\_usage\_location) | A two-letter country code (ISO 3166). Required for users assigned licenses. | `string` | `null` | no |
| <a name="input_user_principal_name"></a> [user\_principal\_name](#input\_user\_principal\_name) | The user principal name (UPN). Format: alias@domain. The domain must be a verified domain of the tenant. | `string` | n/a | yes |
| <a name="input_user_type"></a> [user\_type](#input\_user\_type) | Classify user types: Member or Guest. | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_account_enabled"></a> [account\_enabled](#output\_account\_enabled) | Whether the account is enabled (plan-time, echoes input). |
| <a name="output_created_date_time"></a> [created\_date\_time](#output\_created\_date\_time) | The date and time the user was created (ISO 8601 UTC). |
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | The display name of the user (plan-time, echoes input). |
| <a name="output_id"></a> [id](#output\_id) | The unique identifier (object ID) of the user, assigned by Azure AD. |
| <a name="output_mail_nickname"></a> [mail\_nickname](#output\_mail\_nickname) | The mail alias for the user (plan-time, echoes input). |
| <a name="output_user_principal_name"></a> [user\_principal\_name](#output\_user\_principal\_name) | The UPN of the user (plan-time, echoes input). |
<!-- END_TF_DOCS -->