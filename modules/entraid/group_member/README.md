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
| [rest_resource.group_member](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_group_id"></a> [group\_id](#input\_group\_id) | The object ID of the group to add the member to. | `string` | n/a | yes |
| <a name="input_member_id"></a> [member\_id](#input\_member\_id) | The object ID of the directory object (user, group, service principal) to add as a member. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_group_id"></a> [group\_id](#output\_group\_id) | The object ID of the group (plan-time, echoes input). |
| <a name="output_member_id"></a> [member\_id](#output\_member\_id) | The object ID of the member (plan-time, echoes input). |
<!-- END_TF_DOCS -->