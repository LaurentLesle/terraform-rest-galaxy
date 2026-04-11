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
| [rest_resource.routing_intent](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_firewall_id"></a> [firewall\_id](#input\_firewall\_id) | The ARM resource ID of the Azure Firewall used as nextHop for routing policies. | `string` | n/a | yes |
| <a name="input_internet_traffic"></a> [internet\_traffic](#input\_internet\_traffic) | Route Internet traffic through the firewall. | `bool` | `true` | no |
| <a name="input_private_traffic"></a> [private\_traffic](#input\_private\_traffic) | Route private (RFC1918) traffic through the firewall. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_routing_intent_name"></a> [routing\_intent\_name](#input\_routing\_intent\_name) | The name of the Routing Intent resource (singleton per hub). | `string` | `"RoutingIntent"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_virtual_hub_name"></a> [virtual\_hub\_name](#input\_virtual\_hub\_name) | The name of the Virtual Hub. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the Routing Intent. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Routing Intent (plan-time, echoes input). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Routing Intent. |
<!-- END_TF_DOCS -->