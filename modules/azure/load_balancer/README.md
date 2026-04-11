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
| [rest_resource.load_balancer](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | Backend address pools. | <pre>list(object({<br/>    name = string<br/>  }))</pre> | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_frontend_ip_configurations"></a> [frontend\_ip\_configurations](#input\_frontend\_ip\_configurations) | Frontend IP configurations. | <pre>list(object({<br/>    name                         = string<br/>    subnet_id                    = optional(string)<br/>    private_ip_address           = optional(string)<br/>    private_ip_allocation_method = optional(string)<br/>    public_ip_address_id         = optional(string)<br/>    zones                        = optional(list(string))<br/>  }))</pre> | `null` | no |
| <a name="input_inbound_nat_rules"></a> [inbound\_nat\_rules](#input\_inbound\_nat\_rules) | Inbound NAT rules. | <pre>list(object({<br/>    name                      = string<br/>    protocol                  = string<br/>    frontend_port_range_start = number<br/>    frontend_port_range_end   = number<br/>    backend_port              = number<br/>    frontend_ip_config_name   = string<br/>    backend_address_pool_name = optional(string)<br/>    idle_timeout_in_minutes   = optional(number)<br/>    enable_floating_ip        = optional(bool)<br/>    enable_tcp_reset          = optional(bool)<br/>  }))</pre> | `null` | no |
| <a name="input_load_balancer_name"></a> [load\_balancer\_name](#input\_load\_balancer\_name) | The name of the load balancer. | `string` | n/a | yes |
| <a name="input_load_balancing_rules"></a> [load\_balancing\_rules](#input\_load\_balancing\_rules) | Load balancing rules. | <pre>list(object({<br/>    name                      = string<br/>    protocol                  = string<br/>    frontend_port             = number<br/>    backend_port              = number<br/>    frontend_ip_config_name   = string<br/>    backend_address_pool_name = string<br/>    probe_name                = optional(string)<br/>    idle_timeout_in_minutes   = optional(number)<br/>    enable_floating_ip        = optional(bool)<br/>    enable_tcp_reset          = optional(bool)<br/>  }))</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_probes"></a> [probes](#input\_probes) | Health probes. | <pre>list(object({<br/>    name                = string<br/>    protocol            = string<br/>    port                = number<br/>    request_path        = optional(string)<br/>    interval_in_seconds = optional(number)<br/>    number_of_probes    = optional(number)<br/>  }))</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name (Basic, Standard, Gateway). | `string` | n/a | yes |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The SKU tier (Regional, Global). | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The resource ID of the load balancer (plan-time). |
| <a name="output_location"></a> [location](#output\_location) | The Azure region. |
| <a name="output_name"></a> [name](#output\_name) | The name of the load balancer. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state (known after apply). |
<!-- END_TF_DOCS -->