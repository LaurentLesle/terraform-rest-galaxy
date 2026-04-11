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
| [rest_resource.cluster_role_binding](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | The kube-apiserver endpoint URL (e.g. https://127.0.0.1:6443). | `string` | n/a | yes |
| <a name="input_cluster_token"></a> [cluster\_token](#input\_cluster\_token) | Bearer token for kube-apiserver authentication. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the ClusterRoleBinding. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the ClusterRoleBinding. | `string` | n/a | yes |
| <a name="input_role_ref"></a> [role\_ref](#input\_role\_ref) | The ClusterRole to bind to. | <pre>object({<br/>    kind      = string<br/>    name      = string<br/>    api_group = optional(string, "rbac.authorization.k8s.io")<br/>  })</pre> | n/a | yes |
| <a name="input_subjects"></a> [subjects](#input\_subjects) | The subjects (users, groups, service accounts) to bind. | <pre>list(object({<br/>    kind      = string<br/>    name      = string<br/>    api_group = optional(string, "rbac.authorization.k8s.io")<br/>    namespace = optional(string, null)<br/>  }))</pre> | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_name"></a> [name](#output\_name) | The name of the ClusterRoleBinding. |
| <a name="output_uid"></a> [uid](#output\_uid) | The UID of the ClusterRoleBinding assigned by K8s. |
<!-- END_TF_DOCS -->