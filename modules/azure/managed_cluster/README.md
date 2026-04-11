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
| [rest_resource.managed_cluster](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aad_admin_group_object_ids"></a> [aad\_admin\_group\_object\_ids](#input\_aad\_admin\_group\_object\_ids) | AAD group object IDs that will have cluster-admin role. | `list(string)` | `null` | no |
| <a name="input_aad_enable_azure_rbac"></a> [aad\_enable\_azure\_rbac](#input\_aad\_enable\_azure\_rbac) | Whether to enable Azure RBAC for Kubernetes authorization. | `bool` | `true` | no |
| <a name="input_aad_managed"></a> [aad\_managed](#input\_aad\_managed) | Whether to enable managed AAD integration. | `bool` | `true` | no |
| <a name="input_aad_tenant_id"></a> [aad\_tenant\_id](#input\_aad\_tenant\_id) | The AAD tenant ID for authentication. | `string` | `null` | no |
| <a name="input_agent_pool_profiles"></a> [agent\_pool\_profiles](#input\_agent\_pool\_profiles) | Agent pool profiles. For AKS Automatic with node provisioning Auto, this can be null. | <pre>list(object({<br/>    name                  = string<br/>    count                 = optional(number)<br/>    vm_size               = optional(string)<br/>    os_disk_size_gb       = optional(number)<br/>    os_disk_type          = optional(string)<br/>    os_type               = optional(string)<br/>    os_sku                = optional(string)<br/>    mode                  = optional(string, "System")<br/>    min_count             = optional(number)<br/>    max_count             = optional(number)<br/>    enable_auto_scaling   = optional(bool)<br/>    max_pods              = optional(number)<br/>    vnet_subnet_id        = optional(string)<br/>    availability_zones    = optional(list(string))<br/>    node_labels           = optional(map(string))<br/>    node_taints           = optional(list(string))<br/>    enable_node_public_ip = optional(bool)<br/>    type                  = optional(string, "VirtualMachineScaleSets")<br/>    scale_set_priority    = optional(string)<br/>    orchestrator_version  = optional(string)<br/>    tags                  = optional(map(string))<br/>  }))</pre> | `null` | no |
| <a name="input_api_server_subnet_id"></a> [api\_server\_subnet\_id](#input\_api\_server\_subnet\_id) | Subnet ID for API server VNet integration. | `string` | `null` | no |
| <a name="input_authorized_ip_ranges"></a> [authorized\_ip\_ranges](#input\_authorized\_ip\_ranges) | Authorized IP ranges for the API server. | `list(string)` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the managed cluster. | `string` | `null` | no |
| <a name="input_defender_log_analytics_workspace_id"></a> [defender\_log\_analytics\_workspace\_id](#input\_defender\_log\_analytics\_workspace\_id) | Log Analytics workspace resource ID for Defender. | `string` | `null` | no |
| <a name="input_disable_local_accounts"></a> [disable\_local\_accounts](#input\_disable\_local\_accounts) | Whether to disable local accounts. | `bool` | `true` | no |
| <a name="input_disable_run_command"></a> [disable\_run\_command](#input\_disable\_run\_command) | Whether to disable run command for the cluster. | `bool` | `null` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | The DNS prefix for the cluster. | `string` | `null` | no |
| <a name="input_dns_service_ip"></a> [dns\_service\_ip](#input\_dns\_service\_ip) | The DNS service IP. | `string` | `null` | no |
| <a name="input_enable_defender"></a> [enable\_defender](#input\_enable\_defender) | Whether to enable Microsoft Defender. | `bool` | `false` | no |
| <a name="input_enable_image_cleaner"></a> [enable\_image\_cleaner](#input\_enable\_image\_cleaner) | Whether to enable image cleaner. | `bool` | `null` | no |
| <a name="input_enable_oidc_issuer"></a> [enable\_oidc\_issuer](#input\_enable\_oidc\_issuer) | Whether to enable the OIDC issuer. | `bool` | `true` | no |
| <a name="input_enable_private_cluster"></a> [enable\_private\_cluster](#input\_enable\_private\_cluster) | Whether to create the cluster as a private cluster. | `bool` | `false` | no |
| <a name="input_enable_private_cluster_public_fqdn"></a> [enable\_private\_cluster\_public\_fqdn](#input\_enable\_private\_cluster\_public\_fqdn) | Whether to create additional public FQDN for private cluster. | `bool` | `null` | no |
| <a name="input_enable_rbac"></a> [enable\_rbac](#input\_enable\_rbac) | Whether to enable Kubernetes RBAC. | `bool` | `true` | no |
| <a name="input_enable_vnet_integration"></a> [enable\_vnet\_integration](#input\_enable\_vnet\_integration) | Whether to enable API server VNet integration. | `bool` | `null` | no |
| <a name="input_enable_workload_identity"></a> [enable\_workload\_identity](#input\_enable\_workload\_identity) | Whether to enable workload identity. | `bool` | `true` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The identity type. Options: SystemAssigned, UserAssigned, None. | `string` | `"SystemAssigned"` | no |
| <a name="input_identity_user_assigned_identity_ids"></a> [identity\_user\_assigned\_identity\_ids](#input\_identity\_user\_assigned\_identity\_ids) | List of user-assigned identity ARM resource IDs. | `list(string)` | `null` | no |
| <a name="input_image_cleaner_interval_hours"></a> [image\_cleaner\_interval\_hours](#input\_image\_cleaner\_interval\_hours) | Image cleaner interval in hours. | `number` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The Kubernetes version. When null, the latest stable version is used. | `string` | `null` | no |
| <a name="input_load_balancer_sku"></a> [load\_balancer\_sku](#input\_load\_balancer\_sku) | Load balancer SKU. Options: standard, basic. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region. | `string` | n/a | yes |
| <a name="input_network_dataplane"></a> [network\_dataplane](#input\_network\_dataplane) | Network dataplane. Options: azure, cilium. | `string` | `"cilium"` | no |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin) | Network plugin. Options: azure, kubenet, none. | `string` | `"azure"` | no |
| <a name="input_network_plugin_mode"></a> [network\_plugin\_mode](#input\_network\_plugin\_mode) | Network plugin mode. Options: overlay. | `string` | `"overlay"` | no |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | Network policy. Options: none, calico, azure, cilium. | `string` | `"cilium"` | no |
| <a name="input_node_os_upgrade_channel"></a> [node\_os\_upgrade\_channel](#input\_node\_os\_upgrade\_channel) | Node OS upgrade channel. Options: None, Unmanaged, NodeImage, SecurityPatch. | `string` | `null` | no |
| <a name="input_node_provisioning_mode"></a> [node\_provisioning\_mode](#input\_node\_provisioning\_mode) | Node provisioning mode. Options: Manual, Auto. Automatic SKU defaults to Auto. | `string` | `null` | no |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group) | The name of the resource group containing agent pool nodes. | `string` | `null` | no |
| <a name="input_outbound_type"></a> [outbound\_type](#input\_outbound\_type) | Outbound routing method. Options: loadBalancer, userDefinedRouting, managedNATGateway, none. | `string` | `null` | no |
| <a name="input_pod_cidr"></a> [pod\_cidr](#input\_pod\_cidr) | The pod CIDR (used with overlay mode). | `string` | `null` | no |
| <a name="input_private_dns_zone"></a> [private\_dns\_zone](#input\_private\_dns\_zone) | The private DNS zone mode or resource ID. Options: system, none, or a resource ID. | `string` | `null` | no |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Public network access. Options: Enabled, Disabled. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group. | `string` | n/a | yes |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | The service CIDR. | `string` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name. Options: Base, Automatic. | `string` | `"Automatic"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The SKU tier. Options: Free, Standard, Premium. | `string` | `"Standard"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags. | `map(string)` | `null` | no |
| <a name="input_upgrade_channel"></a> [upgrade\_channel](#input\_upgrade\_channel) | The auto upgrade channel. Options: rapid, stable, patch, node-image, none. | `string` | `"stable"` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The FQDN of the cluster (public clusters only). |
| <a name="output_get_admin_credentials_command"></a> [get\_admin\_credentials\_command](#output\_get\_admin\_credentials\_command) | az CLI command to get admin kubeconfig (full cluster access). |
| <a name="output_get_credentials_command"></a> [get\_credentials\_command](#output\_get\_credentials\_command) | az CLI command to get kubeconfig (user role-based access). |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the managed cluster. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | The principal ID of the cluster system-assigned identity. |
| <a name="output_identity_tenant_id"></a> [identity\_tenant\_id](#output\_identity\_tenant\_id) | The tenant ID of the cluster system-assigned identity. |
| <a name="output_kubelet_identity_client_id"></a> [kubelet\_identity\_client\_id](#output\_kubelet\_identity\_client\_id) | The kubelet managed identity client ID. |
| <a name="output_kubelet_identity_object_id"></a> [kubelet\_identity\_object\_id](#output\_kubelet\_identity\_object\_id) | The kubelet managed identity object ID. |
| <a name="output_location"></a> [location](#output\_location) | The location of the managed cluster (plan-time, echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the managed cluster (plan-time, echoes input). |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url) | The OIDC issuer URL. |
| <a name="output_private_fqdn"></a> [private\_fqdn](#output\_private\_fqdn) | The private FQDN of the cluster (private clusters only). |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state. |
<!-- END_TF_DOCS -->