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
| [rest_operation.check_name_availability](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/operation) | resource |
| [rest_resource.container_registry](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admin_user_enabled"></a> [admin\_user\_enabled](#input\_admin\_user\_enabled) | Whether the admin user is enabled. | `bool` | `false` | no |
| <a name="input_anonymous_pull_enabled"></a> [anonymous\_pull\_enabled](#input\_anonymous\_pull\_enabled) | Whether anonymous pull is enabled (registry-wide). | `bool` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | When true, import existing resource instead of creating. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Whether public network access is allowed. Options: Enabled, Disabled. | `string` | `null` | no |
| <a name="input_registry_name"></a> [registry\_name](#input\_registry\_name) | The name of the container registry. Globally unique, 5–50 alphanumeric characters. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name. Options: Basic, Standard, Premium. | `string` | `"Basic"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the container registry. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the container registry. |
| <a name="output_location"></a> [location](#output\_location) | The Azure region (echoes input). |
| <a name="output_login_server"></a> [login\_server](#output\_login\_server) | The login server URL (e.g. myacr.azurecr.io). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state. |
| <a name="output_registry_name"></a> [registry\_name](#output\_registry\_name) | The name of the container registry (echoes input). |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name (echoes input). |
| <a name="output_sku_name"></a> [sku\_name](#output\_sku\_name) | The SKU name (echoes input). |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | The subscription ID (echoes input). |
<!-- END_TF_DOCS -->