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
| [rest_resource.ciam_directory](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_country_code"></a> [country\_code](#input\_country\_code) | Country code of the tenant (e.g. 'US'). See https://aka.ms/ciam-data-location for valid codes. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of the Azure AD for customers tenant. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The data-residency location for the tenant. One of: 'United States', 'Europe', 'Asia Pacific', 'Australia'. See https://aka.ms/ciam-data-location. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the CIAM directory resource is created. | `string` | n/a | yes |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | The name of the Azure AD for customers (CIAM) directory resource. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name for the tenant. One of: 'Standard', 'PremiumP1', 'PremiumP2'. | `string` | `"Standard"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID linked to the CIAM directory. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags for the CIAM directory. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this resource. |
| <a name="output_billing_type"></a> [billing\_type](#output\_billing\_type) | The billing type of the CIAM tenant (e.g. MAU). |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The domain name of the CIAM tenant. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the CIAM directory. |
| <a name="output_location"></a> [location](#output\_location) | The data-residency location (echoes the input). |
| <a name="output_name"></a> [name](#output\_name) | The resource name (echoes the input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the CIAM directory (e.g. Succeeded). |
| <a name="output_tags"></a> [tags](#output\_tags) | The resource tags (as returned by ARM). |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | The Azure AD tenant ID of the CIAM directory. |
| <a name="output_type"></a> [type](#output\_type) | The resource type string (Microsoft.AzureActiveDirectory/ciamDirectories). |
<!-- END_TF_DOCS -->