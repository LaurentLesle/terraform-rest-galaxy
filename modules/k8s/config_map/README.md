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
| [rest_resource.config_map](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | The kube-apiserver endpoint URL (e.g. https://127.0.0.1:6443). | `string` | n/a | yes |
| <a name="input_cluster_token"></a> [cluster\_token](#input\_cluster\_token) | Bearer token for kube-apiserver authentication. | `string` | n/a | yes |
| <a name="input_data"></a> [data](#input\_data) | Key-value pairs to store in the ConfigMap. | `map(string)` | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the ConfigMap. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the ConfigMap. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace in which to create the ConfigMap. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_name"></a> [name](#output\_name) | The name of the ConfigMap. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace of the ConfigMap. |
| <a name="output_uid"></a> [uid](#output\_uid) | The UID of the ConfigMap assigned by K8s. |
<!-- END_TF_DOCS -->