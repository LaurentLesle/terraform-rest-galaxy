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
| [rest_resource.deployment](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_args"></a> [args](#input\_args) | Arguments to the container entrypoint. | `list(string)` | `null` | no |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | The kube-apiserver endpoint URL (e.g. https://127.0.0.1:6443). | `string` | n/a | yes |
| <a name="input_cluster_token"></a> [cluster\_token](#input\_cluster\_token) | Bearer token for kube-apiserver authentication. | `string` | n/a | yes |
| <a name="input_command"></a> [command](#input\_command) | Override the container entrypoint command. | `list(string)` | `null` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | The container port to expose. | `number` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment variables for the container. | `map(string)` | `{}` | no |
| <a name="input_image"></a> [image](#input\_image) | The container image to use. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the Deployment and its pod template. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Deployment. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace in which to create the Deployment. | `string` | n/a | yes |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | Node selector for pod scheduling. | `map(string)` | `{}` | no |
| <a name="input_pod_labels"></a> [pod\_labels](#input\_pod\_labels) | Additional labels to apply to the pod template (merged with match labels). | `map(string)` | `{}` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | The number of desired replicas. | `number` | `1` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | The ServiceAccount name to use for the pod. | `string` | `null` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | Tolerations for pod scheduling. | <pre>list(object({<br/>    key      = string<br/>    operator = optional(string, "Equal")<br/>    value    = optional(string, null)<br/>    effect   = optional(string, null)<br/>  }))</pre> | `[]` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_available_replicas"></a> [available\_replicas](#output\_available\_replicas) | The number of available replicas. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Deployment. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace of the Deployment. |
| <a name="output_ready_replicas"></a> [ready\_replicas](#output\_ready\_replicas) | The number of ready replicas. |
| <a name="output_uid"></a> [uid](#output\_uid) | The UID of the Deployment assigned by K8s. |
<!-- END_TF_DOCS -->