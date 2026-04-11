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
| [rest_resource.application](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_api"></a> [api](#input\_api) | Specifies settings for an application that implements a web API. | <pre>object({<br/>    requested_access_token_version = optional(number, 2)<br/>    oauth2_permission_scopes = optional(list(object({<br/>      admin_consent_description  = string<br/>      admin_consent_display_name = string<br/>      id                         = string<br/>      is_enabled                 = optional(bool, true)<br/>      type                       = optional(string, "User")<br/>      user_consent_description   = optional(string, null)<br/>      user_consent_display_name  = optional(string, null)<br/>      value                      = string<br/>    })), null)<br/>  })</pre> | `null` | no |
| <a name="input_app_roles"></a> [app\_roles](#input\_app\_roles) | The collection of roles defined for the application. | <pre>list(object({<br/>    allowed_member_types = list(string)<br/>    description          = string<br/>    display_name         = string<br/>    id                   = string<br/>    is_enabled           = optional(bool, true)<br/>    value                = optional(string, null)<br/>  }))</pre> | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Free text field to provide a description of the application object. Maximum 1024 characters. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name for the application. Supports $filter (eq, ne, not, ge, le, in, startsWith). | `string` | n/a | yes |
| <a name="input_group_membership_claims"></a> [group\_membership\_claims](#input\_group\_membership\_claims) | Configures the groups claim. One of: None, SecurityGroup, All. | `string` | `null` | no |
| <a name="input_identifier_uris"></a> [identifier\_uris](#input\_identifier\_uris) | App ID URIs used when the application is used as a resource app. Must be globally unique. | `list(string)` | `null` | no |
| <a name="input_is_device_only_auth_supported"></a> [is\_device\_only\_auth\_supported](#input\_is\_device\_only\_auth\_supported) | Specifies whether this application supports device authentication without a user. | `bool` | `null` | no |
| <a name="input_is_fallback_public_client"></a> [is\_fallback\_public\_client](#input\_is\_fallback\_public\_client) | Specifies the fallback application type as public client. Default is false (confidential client). | `bool` | `false` | no |
| <a name="input_notes"></a> [notes](#input\_notes) | Notes relevant for the management of the application. | `string` | `null` | no |
| <a name="input_optional_claims"></a> [optional\_claims](#input\_optional\_claims) | Optional claims configuration for access tokens, ID tokens, and SAML tokens. | <pre>object({<br/>    access_token = optional(list(object({<br/>      name                  = string<br/>      additional_properties = optional(list(string), null)<br/>      essential             = optional(bool, false)<br/>      source                = optional(string, null)<br/>    })), null)<br/>    id_token = optional(list(object({<br/>      name                  = string<br/>      additional_properties = optional(list(string), null)<br/>      essential             = optional(bool, false)<br/>      source                = optional(string, null)<br/>    })), null)<br/>    saml2_token = optional(list(object({<br/>      name                  = string<br/>      additional_properties = optional(list(string), null)<br/>      essential             = optional(bool, false)<br/>      source                = optional(string, null)<br/>    })), null)<br/>  })</pre> | `null` | no |
| <a name="input_public_client"></a> [public\_client](#input\_public\_client) | Specifies settings for installed clients such as desktop or mobile devices. | <pre>object({<br/>    redirect_uris = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_required_resource_access"></a> [required\_resource\_access](#input\_required\_resource\_access) | Specifies the resources the application needs to access, including delegated permissions and application roles. | <pre>list(object({<br/>    resource_app_id = string<br/>    resource_access = list(object({<br/>      id   = string<br/>      type = string<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_sign_in_audience"></a> [sign\_in\_audience](#input\_sign\_in\_audience) | Specifies the Microsoft accounts supported. Possible values:<br/>- AzureADMyOrg (default, most restrictive — single tenant)<br/>- AzureADMultipleOrgs (any Azure AD tenant)<br/>- AzureADandPersonalMicrosoftAccount (any Azure AD + personal Microsoft)<br/>- PersonalMicrosoftAccount (personal only) | `string` | `"AzureADMyOrg"` | no |
| <a name="input_spa"></a> [spa](#input\_spa) | Specifies settings for a single-page application, including redirect URIs. | <pre>object({<br/>    redirect_uris = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom strings that can be used to categorize and identify the application. | `list(string)` | `null` | no |
| <a name="input_web"></a> [web](#input\_web) | Specifies settings for a web application including redirect URIs and implicit grant settings. | <pre>object({<br/>    redirect_uris                = optional(list(string), null)<br/>    home_page_url                = optional(string, null)<br/>    logout_url                   = optional(string, null)<br/>    implicit_grant_access_tokens = optional(bool, false)<br/>    implicit_grant_id_tokens     = optional(bool, false)<br/>  })</pre> | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_id"></a> [app\_id](#output\_app\_id) | The application (client) ID assigned by Azure AD. |
| <a name="output_created_date_time"></a> [created\_date\_time](#output\_created\_date\_time) | The date and time the application was registered (ISO 8601 UTC). |
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | The display name of the application (plan-time, echoes input). |
| <a name="output_id"></a> [id](#output\_id) | The unique identifier (object ID) of the application, assigned by Azure AD. |
| <a name="output_identifier_uris"></a> [identifier\_uris](#output\_identifier\_uris) | The identifier URIs for the application. |
| <a name="output_publisher_domain"></a> [publisher\_domain](#output\_publisher\_domain) | The verified publisher domain for the application. |
| <a name="output_sign_in_audience"></a> [sign\_in\_audience](#output\_sign\_in\_audience) | The sign-in audience (plan-time, echoes input). |
<!-- END_TF_DOCS -->