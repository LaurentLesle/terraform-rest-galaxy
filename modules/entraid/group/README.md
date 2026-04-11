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
| [rest_resource.group](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_description"></a> [description](#input\_description) | An optional description for the group. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name for the group. Maximum length is 256 characters. | `string` | n/a | yes |
| <a name="input_group_types"></a> [group\_types](#input\_group\_types) | Specifies the group type. Use ["Unified"] for Microsoft 365 groups. Omit or use [] for security groups. | `list(string)` | `null` | no |
| <a name="input_is_assignable_to_role"></a> [is\_assignable\_to\_role](#input\_is\_assignable\_to\_role) | Indicates whether this group can be assigned to an Azure AD role. Immutable after creation. | `bool` | `null` | no |
| <a name="input_mail_enabled"></a> [mail\_enabled](#input\_mail\_enabled) | Specifies whether the group is mail-enabled. Required. | `bool` | n/a | yes |
| <a name="input_mail_nickname"></a> [mail\_nickname](#input\_mail\_nickname) | The mail alias for the group, unique for Microsoft 365 groups in the organization. Maximum length is 64 characters. | `string` | n/a | yes |
| <a name="input_membership_rule"></a> [membership\_rule](#input\_membership\_rule) | The rule that determines members for this group if it is a dynamic group. | `string` | `null` | no |
| <a name="input_membership_rule_processing_state"></a> [membership\_rule\_processing\_state](#input\_membership\_rule\_processing\_state) | Indicates whether dynamic membership processing is On or Paused. | `string` | `null` | no |
| <a name="input_security_enabled"></a> [security\_enabled](#input\_security\_enabled) | Specifies whether the group is a security group. Required. | `bool` | n/a | yes |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Specifies the group join policy and content visibility. Possible values: Private, Public, HiddenMembership. | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_created_date_time"></a> [created\_date\_time](#output\_created\_date\_time) | The date and time the group was created (ISO 8601 UTC). |
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | The display name of the group (plan-time, echoes input). |
| <a name="output_id"></a> [id](#output\_id) | The unique identifier (object ID) of the group, assigned by Azure AD. |
| <a name="output_mail_enabled"></a> [mail\_enabled](#output\_mail\_enabled) | Whether the group is mail-enabled (plan-time, echoes input). |
| <a name="output_mail_nickname"></a> [mail\_nickname](#output\_mail\_nickname) | The mail alias for the group (plan-time, echoes input). |
| <a name="output_security_enabled"></a> [security\_enabled](#output\_security\_enabled) | Whether the group is a security group (plan-time, echoes input). |
<!-- END_TF_DOCS -->