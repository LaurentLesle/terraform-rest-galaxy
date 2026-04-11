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
| [rest_resource.express_route_circuit_peering](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_azure_asn"></a> [azure\_asn](#input\_azure\_asn) | The Azure ASN. | `number` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows. | `bool` | `false` | no |
| <a name="input_circuit_name"></a> [circuit\_name](#input\_circuit\_name) | The name of the ExpressRoute circuit. | `string` | n/a | yes |
| <a name="input_gateway_manager_etag"></a> [gateway\_manager\_etag](#input\_gateway\_manager\_etag) | The GatewayManager Etag. | `string` | `null` | no |
| <a name="input_peer_asn"></a> [peer\_asn](#input\_peer\_asn) | The peer ASN. | `number` | `null` | no |
| <a name="input_peering_name"></a> [peering\_name](#input\_peering\_name) | The name of the peering (e.g. AzurePrivatePeering, AzurePublicPeering, MicrosoftPeering). | `string` | n/a | yes |
| <a name="input_peering_type"></a> [peering\_type](#input\_peering\_type) | The peering type (AzurePrivatePeering, AzurePublicPeering, MicrosoftPeering). | `string` | n/a | yes |
| <a name="input_primary_azure_port"></a> [primary\_azure\_port](#input\_primary\_azure\_port) | The primary port. | `string` | `null` | no |
| <a name="input_primary_peer_address_prefix"></a> [primary\_peer\_address\_prefix](#input\_primary\_peer\_address\_prefix) | The primary address prefix (/30 CIDR block for the primary link). | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_route_filter_id"></a> [route\_filter\_id](#input\_route\_filter\_id) | The ARM resource ID of the Route Filter. | `string` | `null` | no |
| <a name="input_secondary_azure_port"></a> [secondary\_azure\_port](#input\_secondary\_azure\_port) | The secondary port. | `string` | `null` | no |
| <a name="input_secondary_peer_address_prefix"></a> [secondary\_peer\_address\_prefix](#input\_secondary\_peer\_address\_prefix) | The secondary address prefix (/30 CIDR block for the secondary link). | `string` | `null` | no |
| <a name="input_shared_key"></a> [shared\_key](#input\_shared\_key) | The shared key (MD5 hash for BGP authentication). | `string` | `null` | no |
| <a name="input_state"></a> [state](#input\_state) | The peering state (Enabled or Disabled). | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_vlan_id"></a> [vlan\_id](#input\_vlan\_id) | The VLAN ID. | `number` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_azure_asn"></a> [azure\_asn](#output\_azure\_asn) | The Azure ASN. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the ExpressRoute circuit peering. |
| <a name="output_name"></a> [name](#output\_name) | The name of the peering (plan-time, echoes input). |
| <a name="output_primary_azure_port"></a> [primary\_azure\_port](#output\_primary\_azure\_port) | The primary Azure port. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the peering. |
| <a name="output_secondary_azure_port"></a> [secondary\_azure\_port](#output\_secondary\_azure\_port) | The secondary Azure port. |
<!-- END_TF_DOCS -->