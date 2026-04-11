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
| [rest_resource.ipam_static_cidr](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_address_prefixes"></a> [address\_prefixes](#input\_address\_prefixes) | List of IP address prefixes to reserve. Either this or number\_of\_ip\_addresses\_to\_allocate must be set. | `list(string)` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | A description of the static CIDR allocation. | `string` | `null` | no |
| <a name="input_network_manager_name"></a> [network\_manager\_name](#input\_network\_manager\_name) | The name of the parent network manager. | `string` | n/a | yes |
| <a name="input_number_of_ip_addresses_to_allocate"></a> [number\_of\_ip\_addresses\_to\_allocate](#input\_number\_of\_ip\_addresses\_to\_allocate) | Number of IP addresses to allocate from the pool. The addresses are auto-assigned. | `string` | `null` | no |
| <a name="input_pool_name"></a> [pool\_name](#input\_pool\_name) | The name of the parent IPAM pool. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_static_cidr_name"></a> [static\_cidr\_name](#input\_static\_cidr\_name) | The name of the static CIDR allocation. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_address_prefix"></a> [address\_prefix](#output\_address\_prefix) | The first reserved IP address prefix (convenience for single-prefix reservations). |
| <a name="output_address_prefixes"></a> [address\_prefixes](#output\_address\_prefixes) | The reserved IP address prefixes (echoes input). |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the static CIDR allocation. |
| <a name="output_name"></a> [name](#output\_name) | The name of the static CIDR allocation. |
| <a name="output_network_manager_name"></a> [network\_manager\_name](#output\_network\_manager\_name) | The parent network manager name (echoes input). |
| <a name="output_pool_name"></a> [pool\_name](#output\_pool\_name) | The parent IPAM pool name (echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state. |
| <a name="output_total_number_of_ip_addresses"></a> [total\_number\_of\_ip\_addresses](#output\_total\_number\_of\_ip\_addresses) | Total number of IP addresses allocated. |
<!-- END_TF_DOCS -->