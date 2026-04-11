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
| [rest_resource.oauth2_permission_grant](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The object ID of the client service principal (the app that is granted consent). | `string` | n/a | yes |
| <a name="input_consent_type"></a> [consent\_type](#input\_consent\_type) | Indicates whether consent is granted for all principals or a specific principal. Values: AllPrincipals, Principal. | `string` | `"AllPrincipals"` | no |
| <a name="input_expiry_time"></a> [expiry\_time](#input\_expiry\_time) | Required by /beta API but currently ignored by the service. Use a far-future ISO 8601 date. | `string` | `"2299-12-31T00:00:00Z"` | no |
| <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id) | The object ID of the user/principal when consent\_type is 'Principal'. Required only for principal-specific consent. | `string` | `null` | no |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | The object ID of the resource service principal (the API being consented to). | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | Space-delimited list of delegated permission scopes to grant. | `string` | `"user_impersonation"` | no |
| <a name="input_start_time"></a> [start\_time](#input\_start\_time) | Required by /beta API but currently ignored by the service. Use any past ISO 8601 date. | `string` | `"2024-01-01T00:00:00Z"` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | The object ID of the client service principal. |
| <a name="output_id"></a> [id](#output\_id) | The unique identifier of the oauth2PermissionGrant. |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | The object ID of the resource service principal. |
| <a name="output_scope"></a> [scope](#output\_scope) | The granted delegated permission scopes. |
<!-- END_TF_DOCS -->