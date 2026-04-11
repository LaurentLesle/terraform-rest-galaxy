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
| [rest_resource.firewall_policy](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_base_policy_id"></a> [base\_policy\_id](#input\_base\_policy\_id) | The ARM resource ID of the parent firewall policy from which rules are inherited. | `string` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_dns_proxy_enabled"></a> [dns\_proxy\_enabled](#input\_dns\_proxy\_enabled) | Enable DNS Proxy on firewalls attached to this policy. | `bool` | `null` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of custom DNS server IP addresses. | `list(string)` | `null` | no |
| <a name="input_explicit_proxy"></a> [explicit\_proxy](#input\_explicit\_proxy) | Explicit proxy settings for the Firewall Policy. | <pre>object({<br/>    enable_explicit_proxy = bool<br/>    http_port             = optional(number)<br/>    https_port            = optional(number)<br/>    enable_pac_file       = optional(bool)<br/>    pac_file_port         = optional(number)<br/>    pac_file_sas_url      = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_firewall_policy_name"></a> [firewall\_policy\_name](#input\_firewall\_policy\_name) | The name of the Firewall Policy. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region for the Firewall Policy. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | Tier of the Firewall Policy (Basic, Standard, Premium). | `string` | `"Standard"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_threat_intel_mode"></a> [threat\_intel\_mode](#input\_threat\_intel\_mode) | The operation mode for Threat Intelligence (Alert, Deny, Off). | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the Firewall Policy. |
| <a name="output_location"></a> [location](#output\_location) | The location of the Firewall Policy (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the Firewall Policy (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Firewall Policy. |
<!-- END_TF_DOCS -->