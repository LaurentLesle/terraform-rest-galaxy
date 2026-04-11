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
| [rest_resource.extension](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |
| [rest_resource.cluster_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |
| [rest_resource.provider_check](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/data-sources/resource) | data source |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_auto_upgrade_minor_version"></a> [auto\_upgrade\_minor\_version](#input\_auto\_upgrade\_minor\_version) | Flag to note if this extension participates in auto upgrade of minor version. | `bool` | `true` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster. | `string` | n/a | yes |
| <a name="input_cluster_node_architecture"></a> [cluster\_node\_architecture](#input\_cluster\_node\_architecture) | The CPU architecture of the cluster worker nodes (e.g. amd64, arm64). Auto-detected from K8s node labels at the root level. When set, the module checks the extension type against a built-in registry of known architecture requirements. | `string` | `null` | no |
| <a name="input_cluster_resource_name"></a> [cluster\_resource\_name](#input\_cluster\_resource\_name) | The resource type name of the cluster (e.g. connectedClusters, managedClusters). | `string` | `"connectedClusters"` | no |
| <a name="input_cluster_rp"></a> [cluster\_rp](#input\_cluster\_rp) | The resource provider of the cluster (e.g. Microsoft.Kubernetes for Arc, Microsoft.ContainerService for AKS). | `string` | `"Microsoft.Kubernetes"` | no |
| <a name="input_configuration_protected_settings"></a> [configuration\_protected\_settings](#input\_configuration\_protected\_settings) | Sensitive configuration settings as name-value pairs. | `map(string)` | `null` | no |
| <a name="input_configuration_settings"></a> [configuration\_settings](#input\_configuration\_settings) | Configuration settings as name-value pairs. | `map(string)` | `null` | no |
| <a name="input_extension_name"></a> [extension\_name](#input\_extension\_name) | The name of the extension instance. | `string` | n/a | yes |
| <a name="input_extension_type"></a> [extension\_type](#input\_extension\_type) | Type of the Extension (e.g. microsoft.monitor.pipelinecontroller, microsoft.azuremonitor.containers). | `string` | n/a | yes |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The identity type for the extension (e.g. SystemAssigned). | `string` | `null` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | Plan for the resource (marketplace extensions). | <pre>object({<br/>    name      = string<br/>    publisher = string<br/>    product   = string<br/>  })</pre> | `null` | no |
| <a name="input_release_train"></a> [release\_train](#input\_release\_train) | ReleaseTrain this extension participates in for auto-upgrade (e.g. Stable, Preview). Only if autoUpgradeMinorVersion is true. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name containing the cluster. | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | Scope of the extension — either Cluster or Namespace (not both). | <pre>object({<br/>    cluster = optional(object({<br/>      release_namespace = optional(string, null)<br/>    }), null)<br/>    namespace = optional(object({<br/>      target_namespace = optional(string, null)<br/>    }), null)<br/>  })</pre> | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_version_pin"></a> [version\_pin](#input\_version\_pin) | User-specified version to pin this extension to. autoUpgradeMinorVersion must be false. | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The ARM API version used to manage this extension. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The cluster name (echoes input). |
| <a name="output_current_version"></a> [current\_version](#output\_current\_version) | Currently installed version of the extension. |
| <a name="output_extension_name"></a> [extension\_name](#output\_extension\_name) | The name of the extension instance (echoes input). |
| <a name="output_extension_type"></a> [extension\_type](#output\_extension\_type) | The extension type. |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the extension. |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The principal ID of the extension's managed identity. |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the extension. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | The tenant ID of the extension's managed identity. |
<!-- END_TF_DOCS -->