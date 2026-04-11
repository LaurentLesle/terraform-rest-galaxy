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
| [rest_resource.azure_firewall](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_additional_properties"></a> [additional\_properties](#input\_additional\_properties) | Additional properties for the Azure Firewall (key-value pairs). | `map(string)` | `{}` | no |
| <a name="input_application_rule_collections"></a> [application\_rule\_collections](#input\_application\_rule\_collections) | Collection of application rule collections used by Azure Firewall. | `list(any)` | `[]` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | The name of the Azure Firewall. | `string` | `null` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | The ARM resource ID of the Firewall Policy associated with this firewall. | `string` | `null` | no |
| <a name="input_ip_configurations"></a> [ip\_configurations](#input\_ip\_configurations) | IP configurations for VNet-based firewalls (AZFW\_VNet). The first entry must include a subnet\_id (AzureFirewallSubnet). Additional entries are for extra public IPs. | <pre>list(object({<br/>    name                 = string<br/>    subnet_id            = optional(string)<br/>    public_ip_address_id = optional(string)<br/>    privateIPAddress     = optional(string)<br/>  }))</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region for the Azure Firewall. | `string` | n/a | yes |
| <a name="input_nat_rule_collections"></a> [nat\_rule\_collections](#input\_nat\_rule\_collections) | Collection of NAT rule collections used by Azure Firewall. | `list(any)` | `[]` | no |
| <a name="input_network_rule_collections"></a> [network\_rule\_collections](#input\_network\_rule\_collections) | Collection of network rule collections used by Azure Firewall. | `list(any)` | `[]` | no |
| <a name="input_public_ip_count"></a> [public\_ip\_count](#input\_public\_ip\_count) | The number of public IP addresses associated with the hub firewall. | `number` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name (AZFW\_VNet or AZFW\_Hub). | `string` | n/a | yes |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The SKU tier (Standard, Premium, Basic). | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_threat_intel_mode"></a> [threat\_intel\_mode](#input\_threat\_intel\_mode) | The operation mode for Threat Intelligence (Alert, Deny, Off). | `string` | `null` | no |
| <a name="input_virtual_hub_id"></a> [virtual\_hub\_id](#input\_virtual\_hub\_id) | The ARM resource ID of the Virtual Hub to which the firewall belongs. | `string` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of availability zones. | `list(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the Azure Firewall. |
| <a name="output_location"></a> [location](#output\_location) | The location of the Azure Firewall (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the Azure Firewall (plan-time, echoes input). |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The private IP address of the hub firewall. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Azure Firewall. |
| <a name="output_public_ip_addresses"></a> [public\_ip\_addresses](#output\_public\_ip\_addresses) | The public IP addresses of the hub firewall. |
<!-- END_TF_DOCS -->