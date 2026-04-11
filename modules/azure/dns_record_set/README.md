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
| [rest_resource.dns_record_set](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_a_records"></a> [a\_records](#input\_a\_records) | A records. | <pre>list(object({<br/>    ipv4Address = string<br/>  }))</pre> | `null` | no |
| <a name="input_aaaa_records"></a> [aaaa\_records](#input\_aaaa\_records) | AAAA records. | <pre>list(object({<br/>    ipv6Address = string<br/>  }))</pre> | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_cname_record"></a> [cname\_record](#input\_cname\_record) | CNAME record (only one allowed per record set). | <pre>object({<br/>    cname = string<br/>  })</pre> | `null` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Metadata key-value pairs for the record set. | `map(string)` | `null` | no |
| <a name="input_mx_records"></a> [mx\_records](#input\_mx\_records) | MX records. | <pre>list(object({<br/>    preference = number<br/>    exchange   = string<br/>  }))</pre> | `null` | no |
| <a name="input_record_name"></a> [record\_name](#input\_record\_name) | The name of the DNS record set relative to the zone (e.g. '@', 'www', 'mail'). | `string` | n/a | yes |
| <a name="input_record_type"></a> [record\_type](#input\_record\_type) | The DNS record type (e.g. TXT, CNAME, MX, A, AAAA). | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | The TTL for the record set in seconds. | `number` | `3600` | no |
| <a name="input_txt_records"></a> [txt\_records](#input\_txt\_records) | TXT records. Each entry contains a list of string values. | <pre>list(object({<br/>    value = list(string)<br/>  }))</pre> | `null` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | The name of the DNS zone. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this record set. |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The fully qualified domain name of the record set. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the DNS record set. |
| <a name="output_record_name"></a> [record\_name](#output\_record\_name) | The record set name (plan-time, echoes input). |
| <a name="output_record_type"></a> [record\_type](#output\_record\_type) | The record type (plan-time, echoes input). |
<!-- END_TF_DOCS -->