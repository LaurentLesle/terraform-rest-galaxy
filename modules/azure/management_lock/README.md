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
| [rest_resource.management_lock](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auth_ref"></a> [auth\_ref](#input\_auth\_ref) | Reference to a named\_auth entry in the provider for cross-tenant auth. | `string` | `null` | no |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | The lock level. Possible values: CanNotDelete, ReadOnly. | `string` | `"CanNotDelete"` | no |
| <a name="input_lock_name"></a> [lock\_name](#input\_lock\_name) | The name of the management lock. | `string` | n/a | yes |
| <a name="input_notes"></a> [notes](#input\_notes) | Notes about the lock (max 512 characters). | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group to apply the lock to. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | The full ARM resource ID of the management lock. |
| <a name="output_lock_level"></a> [lock\_level](#output\_lock\_level) | The lock level (echoes input). |
| <a name="output_lock_name"></a> [lock\_name](#output\_lock\_name) | The name of the management lock (echoes input). |
<!-- END_TF_DOCS -->