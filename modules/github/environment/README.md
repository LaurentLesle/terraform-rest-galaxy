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
| [rest_resource.environment](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_deployment_branch_policy"></a> [deployment\_branch\_policy](#input\_deployment\_branch\_policy) | Deployment branch policy for the environment. Set to null to allow all branches to deploy.<br/>Exactly one of protected\_branches / custom\_branch\_policies must be true:<br/>  - protected\_branches = true: only branches with branch protection rules can deploy.<br/>  - custom\_branch\_policies = true: only branches matching configured name patterns can deploy<br/>    (the patterns themselves must be managed via /repos/{owner}/{repo}/environments/{env}/deployment-branch-policies — out of scope for this module). | <pre>object({<br/>    protected_branches     = bool<br/>    custom_branch_policies = bool<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the deployment environment (e.g. staging, production). | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | The account owner of the repository (user or organization). | `string` | n/a | yes |
| <a name="input_prevent_self_review"></a> [prevent\_self\_review](#input\_prevent\_self\_review) | If true, the user who created the deployment cannot approve it. | `bool` | `null` | no |
| <a name="input_repo"></a> [repo](#input\_repo) | The repository name (without .git extension). | `string` | n/a | yes |
| <a name="input_reviewers"></a> [reviewers](#input\_reviewers) | Up to six users or teams that may review jobs referencing this environment. Each entry: { type = "User"\|"Team", id = <numeric id> }. | <pre>list(object({<br/>    type = string # "User" or "Team"<br/>    id   = number<br/>  }))</pre> | `null` | no |
| <a name="input_wait_timer"></a> [wait\_timer](#input\_wait\_timer) | Amount of time (in minutes) to delay a job after it is initially triggered. Must be between 0 and 43200 (30 days). | `number` | `null` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_html_url"></a> [html\_url](#output\_html\_url) | The HTML URL of the environment on github.com. |
| <a name="output_id"></a> [id](#output\_id) | The numeric ID of the environment, assigned by GitHub. |
| <a name="output_name"></a> [name](#output\_name) | The name of the deployment environment. |
| <a name="output_node_id"></a> [node\_id](#output\_node\_id) | The GraphQL node ID of the environment. |
| <a name="output_owner"></a> [owner](#output\_owner) | The repository owner. |
| <a name="output_repo"></a> [repo](#output\_repo) | The repository name. |
| <a name="output_url"></a> [url](#output\_url) | The API URL of the environment. |
<!-- END_TF_DOCS -->