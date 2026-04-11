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
| [rest_resource.repository](https://registry.terraform.io/providers/LaurentLesle/rest/1.2.0/docs/resources/resource) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Allow auto-merge on pull requests. | `bool` | `null` | no |
| <a name="input_allow_merge_commit"></a> [allow\_merge\_commit](#input\_allow\_merge\_commit) | Allow merging pull requests with a merge commit. | `bool` | `null` | no |
| <a name="input_allow_rebase_merge"></a> [allow\_rebase\_merge](#input\_allow\_rebase\_merge) | Allow rebase-merging pull requests. | `bool` | `null` | no |
| <a name="input_allow_squash_merge"></a> [allow\_squash\_merge](#input\_allow\_squash\_merge) | Allow squash-merging pull requests. | `bool` | `null` | no |
| <a name="input_auto_init"></a> [auto\_init](#input\_auto\_init) | Pass true to create an initial commit with an empty README. | `bool` | `false` | no |
| <a name="input_check_existance"></a> [check\_existance](#input\_check\_existance) | When true, the provider GETs the repository before creating it and adopts it into state if it already exists. Use this to reconcile drift or when a previous apply left the resource orphaned. | `bool` | `false` | no |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | Automatically delete head branches when pull requests are merged. | `bool` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | A short description of the repository. | `string` | `null` | no |
| <a name="input_gitignore_template"></a> [gitignore\_template](#input\_gitignore\_template) | Desired language or platform .gitignore template (e.g. Terraform, Go, Node). | `string` | `null` | no |
| <a name="input_has_downloads"></a> [has\_downloads](#input\_has\_downloads) | Enable or disable the downloads feature for this repository. | `bool` | `null` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | Enable or disable the issues feature for this repository. | `bool` | `null` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | Enable or disable the projects feature for this repository. | `bool` | `null` | no |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | Enable or disable the wiki feature for this repository. | `bool` | `null` | no |
| <a name="input_homepage"></a> [homepage](#input\_homepage) | A URL with more information about the repository. | `string` | `null` | no |
| <a name="input_license_template"></a> [license\_template](#input\_license\_template) | Open source license template keyword (e.g. mit, apache-2.0, mpl-2.0). | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The repository name (without .git extension). Must be unique inside the organization. | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | The GitHub organization name that will own the repository. | `string` | n/a | yes |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | The visibility of the repository. One of: public, private. (internal is GHEC/GHES only and not validated here.) | `string` | `"private"` | no |

## Outputs

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_clone_url"></a> [clone\_url](#output\_clone\_url) | The HTTPS clone URL of the repository. |
| <a name="output_default_branch"></a> [default\_branch](#output\_default\_branch) | The default branch of the repository (set by GitHub after creation). |
| <a name="output_full_name"></a> [full\_name](#output\_full\_name) | The full name of the repository in owner/name form. |
| <a name="output_html_url"></a> [html\_url](#output\_html\_url) | The HTTPS URL of the repository on github.com. |
| <a name="output_id"></a> [id](#output\_id) | The numeric database ID of the repository, assigned by GitHub. Stable across renames. |
| <a name="output_name"></a> [name](#output\_name) | The name of the repository. |
| <a name="output_node_id"></a> [node\_id](#output\_node\_id) | The GraphQL node ID of the repository. |
| <a name="output_organization"></a> [organization](#output\_organization) | The GitHub organization that owns the repository. |
| <a name="output_ssh_url"></a> [ssh\_url](#output\_ssh\_url) | The SSH clone URL of the repository. |
| <a name="output_visibility"></a> [visibility](#output\_visibility) | The visibility of the repository (public, private). |
<!-- END_TF_DOCS -->