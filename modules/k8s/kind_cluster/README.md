<!-- BEGIN_TF_DOCS -->


## Requirements

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | ~> 0.7 |

## Providers

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_kind"></a> [kind](#provider\_kind) | ~> 0.7 |

## Resources

## Resources

| Name | Type |
| ---- | ---- |
| [kind_cluster.this](https://registry.terraform.io/providers/tehcyx/kind/latest/docs/resources/cluster) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_docker_available"></a> [docker\_available](#input\_docker\_available) | Whether Docker is running. Set automatically by tf.sh. When false, a precondition prevents kind cluster creation. | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The Kubernetes version to use (maps to a kindest/node image tag). | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the kind cluster. | `string` | n/a | yes |
| <a name="input_networking"></a> [networking](#input\_networking) | Networking configuration for the kind cluster. | <pre>object({<br/>    api_server_port = optional(number, 6443)<br/>    pod_subnet      = optional(string, null)<br/>    service_subnet  = optional(string, null)<br/>  })</pre> | `{}` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Map of node pools. Each pool specifies a role (control-plane or worker), count, and optional labels/taints. | <pre>map(object({<br/>    role   = string<br/>    count  = optional(number, 1)<br/>    labels = optional(map(string), {})<br/>    taints = optional(list(object({<br/>      key    = string<br/>      value  = optional(string, "")<br/>      effect = string<br/>    })), [])<br/>  }))</pre> | `{}` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | Client certificate for authenticating to the cluster. |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | Client key for authenticating to the cluster. |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Cluster CA certificate. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The API server endpoint of the kind cluster. |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | The kubeconfig for the kind cluster. |
| <a name="output_kubernetes_version"></a> [kubernetes\_version](#output\_kubernetes\_version) | The Kubernetes version of the cluster (echoes input). |
| <a name="output_name"></a> [name](#output\_name) | The name of the kind cluster. |
<!-- END_TF_DOCS -->