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
| [rest_resource.federated_identity_credential](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_audiences"></a> [audiences](#input\_audiences) | The list of audiences that can appear in the issued token. | `list(string)` | <pre>[<br/>  "api://AzureADTokenExchange"<br/>]</pre> | no |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | Check whether the resource already exists before creating it. | `bool` | `false` | no |
| <a name="input_federated_credential_name"></a> [federated\_credential\_name](#input\_federated\_credential\_name) | The name of the federated identity credential. | `string` | n/a | yes |
| <a name="input_identity_name"></a> [identity\_name](#input\_identity\_name) | The name of the user-assigned managed identity. | `string` | n/a | yes |
| <a name="input_issuer"></a> [issuer](#input\_issuer) | The URL of the OIDC issuer to trust (e.g. AKS OIDC issuer URL). | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group containing the user-assigned identity. | `string` | n/a | yes |
| <a name="input_subject"></a> [subject](#input\_subject) | The identifier of the external identity (e.g. system:serviceaccount:<namespace>:<sa-name>). | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the federated identity credential. |
| <a name="output_issuer"></a> [issuer](#output\_issuer) | The OIDC issuer URL. |
| <a name="output_name"></a> [name](#output\_name) | The name of the federated identity credential. |
| <a name="output_subject"></a> [subject](#output\_subject) | The subject identifier. |
<!-- END_TF_DOCS -->