<!-- BEGIN_TF_DOCS -->


## Requirements

## Requirements

| Name | Version |
| ---- | ------- |
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
| [rest_resource.dns_zone](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the DNS zone. Must be 'global' for public zones. | `string` | `"global"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the DNS zone. | `map(string)` | `null` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | The name of the DNS zone (e.g. contoso.com). | `string` | n/a | yes |
| <a name="input_zone_type"></a> [zone\_type](#input\_zone\_type) | The type of DNS zone. Options: Public, Private. | `string` | `"Public"` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this DNS zone. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the DNS zone. |
| <a name="output_location"></a> [location](#output\_location) | The location (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The DNS zone name (plan-time, echoes input). |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | The name servers for the DNS zone (after-apply). |
| <a name="output_number_of_record_sets"></a> [number\_of\_record\_sets](#output\_number\_of\_record\_sets) | The number of record sets in the zone. |
<!-- END_TF_DOCS -->