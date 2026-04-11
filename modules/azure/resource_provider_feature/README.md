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
| [rest_resource.feature_registration](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | The feature description. | `string` | `null` | no |
| <a name="input_feature_name"></a> [feature\_name](#input\_feature\_name) | The name of the feature to register (e.g. EncryptionAtHost). | `string` | n/a | yes |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Key-value pairs for metadata. | `map(string)` | `null` | no |
| <a name="input_provider_namespace"></a> [provider\_namespace](#input\_provider\_namespace) | The resource provider namespace (e.g. Microsoft.Compute). | `string` | n/a | yes |
| <a name="input_should_feature_display_in_portal"></a> [should\_feature\_display\_in\_portal](#input\_should\_feature\_display\_in\_portal) | Indicates whether the feature should be displayed in the Portal. | `bool` | `null` | no |
| <a name="input_state"></a> [state](#input\_state) | The desired registration state. Defaults to 'Registered'. | `string` | `"Registered"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_feature_name"></a> [feature\_name](#output\_feature\_name) | The feature name (echoes input). |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the feature registration. |
| <a name="output_provider_namespace"></a> [provider\_namespace](#output\_provider\_namespace) | The resource provider namespace (echoes input). |
| <a name="output_state"></a> [state](#output\_state) | The registration state of the feature (e.g. Registered, Registering, Pending). |
<!-- END_TF_DOCS -->