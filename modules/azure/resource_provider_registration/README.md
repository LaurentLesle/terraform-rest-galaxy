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
| [rest_operation.register](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/operation) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_resource_provider_namespace"></a> [resource\_provider\_namespace](#input\_resource\_provider\_namespace) | The namespace of the resource provider to register (e.g. Microsoft.Compute, Microsoft.KeyVault). | `string` | n/a | yes |
| <a name="input_skip_deregister"></a> [skip\_deregister](#input\_skip\_deregister) | Skip unregistering the provider on destroy. Defaults to true because Azure often rejects unregistration when resources still exist. | `bool` | `true` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID in which to register the resource provider. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_registration_state"></a> [registration\_state](#output\_registration\_state) | The registration state of the resource provider (e.g. Registered, Registering). |
| <a name="output_resource_provider_namespace"></a> [resource\_provider\_namespace](#output\_resource\_provider\_namespace) | The resource provider namespace (echoes input). |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | The subscription ID where the provider is registered (echoes input). |
<!-- END_TF_DOCS -->