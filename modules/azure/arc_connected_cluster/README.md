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
| [rest_operation.wait_for_connection](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/operation) | resource |
| [rest_resource.connected_cluster](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aad_profile"></a> [aad\_profile](#input\_aad\_profile) | AAD Profile for Azure Active Directory integration. | <pre>object({<br/>    enable_azure_rbac      = optional(bool, null)<br/>    admin_group_object_ids = optional(list(string), [])<br/>    tenant_id              = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_agent_public_key_certificate"></a> [agent\_public\_key\_certificate](#input\_agent\_public\_key\_certificate) | Base64 encoded public certificate used by the agent to do the initial handshake to the backend services in Azure. | `string` | n/a | yes |
| <a name="input_arc_agent_profile"></a> [arc\_agent\_profile](#input\_arc\_agent\_profile) | Arc Agent profile configuration. | <pre>object({<br/>    desired_agent_version = optional(string, null)<br/>    agent_auto_upgrade    = optional(string, "Enabled")<br/>  })</pre> | `null` | no |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_azure_hybrid_benefit"></a> [azure\_hybrid\_benefit](#input\_azure\_hybrid\_benefit) | Indicates whether Azure Hybrid Benefit is opted in (True, False, or NotApplicable). | `string` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the connected cluster resource. | `string` | n/a | yes |
| <a name="input_distribution"></a> [distribution](#input\_distribution) | The Kubernetes distribution running on this connected cluster. | `string` | `null` | no |
| <a name="input_distribution_version"></a> [distribution\_version](#input\_distribution\_version) | The Kubernetes distribution version on this connected cluster. | `string` | `null` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The type of identity used for the connected cluster (SystemAssigned or None). | `string` | `"SystemAssigned"` | no |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | The infrastructure on which the Kubernetes cluster is running. | `string` | `null` | no |
| <a name="input_kind"></a> [kind](#input\_kind) | Indicates the kind of Arc connected cluster based on host infrastructure (e.g. ProvisionedCluster). | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region for the connected cluster. | `string` | n/a | yes |
| <a name="input_private_link_scope_resource_id"></a> [private\_link\_scope\_resource\_id](#input\_private\_link\_scope\_resource\_id) | The resource id of the private link scope this connected cluster is assigned to. | `string` | `null` | no |
| <a name="input_private_link_state"></a> [private\_link\_state](#input\_private\_link\_state) | Property which describes the state of private link on a connected cluster resource (Enabled or Disabled). | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_wait_for_connection"></a> [wait\_for\_connection](#input\_wait\_for\_connection) | Wait for the Arc agent to reach 'Connected' status after resource creation. When true, Terraform polls the cluster until connectivityStatus is Connected (up to ~10 minutes). | `bool` | `true` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_agent_version"></a> [agent\_version](#output\_agent\_version) | The version of the Arc agent. |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this connected cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the connected cluster (echoes input). |
| <a name="output_connectivity_status"></a> [connectivity\_status](#output\_connectivity\_status) | The connectivity status (Connecting, Connected, Offline, Expired). |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the connected cluster. |
| <a name="output_kubernetes_version"></a> [kubernetes\_version](#output\_kubernetes\_version) | The Kubernetes version reported by the connected cluster. |
| <a name="output_location"></a> [location](#output\_location) | The location of the connected cluster (echoes input). |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The principal ID of the system-assigned managed identity. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the connected cluster. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name (echoes input). |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | The subscription ID (echoes input). |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags on the connected cluster. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | The tenant ID of the system-assigned managed identity. |
| <a name="output_total_node_count"></a> [total\_node\_count](#output\_total\_node\_count) | The total number of nodes in the connected cluster. |
| <a name="output_type"></a> [type](#output\_type) | The resource type string returned by ARM. |
<!-- END_TF_DOCS -->