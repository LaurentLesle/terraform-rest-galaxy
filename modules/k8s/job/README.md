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
| [rest_resource.job](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_args"></a> [args](#input\_args) | Arguments to the container entrypoint. | `list(string)` | `null` | no |
| <a name="input_backoff_limit"></a> [backoff\_limit](#input\_backoff\_limit) | Number of retries before marking the Job as failed. | `number` | `0` | no |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | The kube-apiserver endpoint URL (e.g. https://127.0.0.1:6443). | `string` | n/a | yes |
| <a name="input_cluster_token"></a> [cluster\_token](#input\_cluster\_token) | Bearer token for kube-apiserver authentication. | `string` | n/a | yes |
| <a name="input_command"></a> [command](#input\_command) | Override the container entrypoint command. | `list(string)` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment variables for the container. | `map(string)` | `{}` | no |
| <a name="input_image"></a> [image](#input\_image) | The container image to use. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the Job. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Job. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace in which to create the Job. | `string` | n/a | yes |
| <a name="input_pod_labels"></a> [pod\_labels](#input\_pod\_labels) | Additional labels for the pod template. | `map(string)` | `{}` | no |
| <a name="input_resource_limits"></a> [resource\_limits](#input\_resource\_limits) | Container resource limits. | `map(string)` | <pre>{<br/>  "cpu": "500m",<br/>  "memory": "512Mi"<br/>}</pre> | no |
| <a name="input_resource_requests"></a> [resource\_requests](#input\_resource\_requests) | Container resource requests. | `map(string)` | <pre>{<br/>  "cpu": "100m",<br/>  "memory": "256Mi"<br/>}</pre> | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | The ServiceAccount name to use for the pod. | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_completion_time"></a> [completion\_time](#output\_completion\_time) | Time the Job completed. |
| <a name="output_failed"></a> [failed](#output\_failed) | Number of pods that reached the Failed phase. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Job. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace of the Job. |
| <a name="output_succeeded"></a> [succeeded](#output\_succeeded) | Number of pods that reached the Succeeded phase. |
| <a name="output_uid"></a> [uid](#output\_uid) | The UID of the Job assigned by K8s. |
<!-- END_TF_DOCS -->