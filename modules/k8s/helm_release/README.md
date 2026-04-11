<!-- BEGIN_TF_DOCS -->


## Requirements

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
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
| [rest_helm_release.this](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/helm_release) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_chart"></a> [chart](#input\_chart) | Chart reference: local path, repo/chartname, or OCI URL. | `string` | n/a | yes |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Chart version constraint. | `string` | `null` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not exist. | `bool` | `true` | no |
| <a name="input_insecure_skip_tls_verify"></a> [insecure\_skip\_tls\_verify](#input\_insecure\_skip\_tls\_verify) | Skip TLS certificate verification for the K8s API server. | `bool` | `false` | no |
| <a name="input_kube_context"></a> [kube\_context](#input\_kube\_context) | Kubeconfig context to use. | `string` | `null` | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to the kubeconfig file. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Helm release name. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for the release. | `string` | `"default"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Chart repository URL. | `string` | `null` | no |
| <a name="input_set"></a> [set](#input\_set) | Map of individual values to set (dot-path keys supported). | `map(string)` | `{}` | no |
| <a name="input_set_sensitive"></a> [set\_sensitive](#input\_set\_sensitive) | Map of sensitive values to set (stored encrypted in state). | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Timeout in seconds for Helm operations. | `number` | `600` | no |
| <a name="input_values"></a> [values](#input\_values) | JSON-encoded values to pass to the chart. | `string` | `null` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | Wait until all resources are ready. | `bool` | `true` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_version"></a> [app\_version](#output\_app\_version) | App version of the deployed chart. |
| <a name="output_chart_version"></a> [chart\_version](#output\_chart\_version) | Version of the deployed chart. |
| <a name="output_name"></a> [name](#output\_name) | The Helm release name. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace of the release. |
| <a name="output_status"></a> [status](#output\_status) | Release status (deployed, failed, etc.). |
<!-- END_TF_DOCS -->