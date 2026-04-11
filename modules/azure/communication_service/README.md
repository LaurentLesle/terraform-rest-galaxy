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
| [rest_resource.communication_service](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_communication_service_name"></a> [communication\_service\_name](#input\_communication\_service\_name) | The name of the Communication Service resource. Globally unique. | `string` | n/a | yes |
| <a name="input_data_location"></a> [data\_location](#input\_data\_location) | The location where the Communication Service stores its data at rest (e.g. 'Europe', 'United States', 'Asia Pacific', 'Australia', 'UK', 'Japan', 'South Korea', 'Brazil', 'Africa'). | `string` | n/a | yes |
| <a name="input_disable_local_auth"></a> [disable\_local\_auth](#input\_disable\_local\_auth) | Disable local authentication for the Communication Service. | `bool` | `null` | no |
| <a name="input_linked_domains"></a> [linked\_domains](#input\_linked\_domains) | List of email domain resource IDs to link to this Communication Service. | `list(string)` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The geo-location where the resource lives. Typically 'global' for Communication Services. | `string` | n/a | yes |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Control public network access. Options: Enabled, Disabled, SecuredByPerimeter. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Communication Service. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID in which the Communication Service is created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the Communication Service. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this Communication Service. |
| <a name="output_data_location"></a> [data\_location](#output\_data\_location) | The data location of the Communication Service (plan-time, echoes input). |
| <a name="output_host_name"></a> [host\_name](#output\_host\_name) | FQDN of the Communication Service instance. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the Communication Service. |
| <a name="output_immutable_resource_id"></a> [immutable\_resource\_id](#output\_immutable\_resource\_id) | The immutable resource ID of the Communication Service. |
| <a name="output_location"></a> [location](#output\_location) | The location of the Communication Service (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the Communication Service (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Communication Service. |
<!-- END_TF_DOCS -->