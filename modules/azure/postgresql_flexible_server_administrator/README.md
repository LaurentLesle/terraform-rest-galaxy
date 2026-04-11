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
| [rest_resource.administrator](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_object_id"></a> [object\_id](#input\_object\_id) | Object ID of the Microsoft Entra principal to set as administrator. | `string` | n/a | yes |
| <a name="input_principal_name"></a> [principal\_name](#input\_principal\_name) | Display name of the Microsoft Entra principal. | `string` | n/a | yes |
| <a name="input_principal_type"></a> [principal\_type](#input\_principal\_type) | Type of Entra principal. Options: User, Group, ServicePrincipal, Unknown. | `string` | `"ServicePrincipal"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group containing the server. | `string` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | The name of the PostgreSQL Flexible Server. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant ID in which the Entra principal exists. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the administrator. |
| <a name="output_object_id"></a> [object\_id](#output\_object\_id) | The object ID of the Entra principal. |
| <a name="output_principal_name"></a> [principal\_name](#output\_principal\_name) | The display name of the Entra principal. |
| <a name="output_principal_type"></a> [principal\_type](#output\_principal\_type) | The type of Entra principal. |
<!-- END_TF_DOCS -->