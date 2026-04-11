<!-- BEGIN_TF_DOCS -->


## Requirements

## Requirements

No requirements.

## Providers

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_rest"></a> [rest](#provider\_rest) | n/a |

## Resources

## Resources

| Name | Type |
| ---- | ---- |
| [rest_resource.app_role_assignment](https://registry.terraform.io/providers/LaurentLesle/rest/latest/docs/resources/resource) | resource |
| [rest_resource.service_principal](https://registry.terraform.io/providers/LaurentLesle/rest/latest/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_app_role_id"></a> [app\_role\_id](#input\_app\_role\_id) | The app role ID to assign. Use the default zero GUID for the default access role. | `string` | `"00000000-0000-0000-0000-000000000000"` | no |
| <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id) | The object ID of the user, group, or service principal to assign to the Enterprise Application. | `string` | n/a | yes |
| <a name="input_principal_type"></a> [principal\_type](#input\_principal\_type) | The type of the principal. Possible values: User, Group, ServicePrincipal. Read-only in the API but useful for documentation. | `string` | `null` | no |
| <a name="input_resource_app_id"></a> [resource\_app\_id](#input\_resource\_app\_id) | The application (client) ID of the Enterprise Application (e.g. the Azure VPN app ID). The module looks up the service principal object ID automatically. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The unique identifier of the app role assignment. |
| <a name="output_principal_display_name"></a> [principal\_display\_name](#output\_principal\_display\_name) | The display name of the assigned principal. |
| <a name="output_principal_type"></a> [principal\_type](#output\_principal\_type) | The type of the assigned principal (User, Group, ServicePrincipal). |
| <a name="output_resource_display_name"></a> [resource\_display\_name](#output\_resource\_display\_name) | The display name of the resource (Enterprise Application). |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | The service principal object ID of the Enterprise Application. |
<!-- END_TF_DOCS -->