# Source: GitHub REST API
#   api        : GitHub REST API v2022-11-28
#   resource   : actions/runner-groups
#   create     : POST   /orgs/{org}/actions/runner-groups  (synchronous, server-assigned id)
#   read       : GET    /orgs/{org}/actions/runner-groups/{runner_group_id}
#   update     : PATCH  /orgs/{org}/actions/runner-groups/{runner_group_id}
#   delete     : DELETE /orgs/{org}/actions/runner-groups/{runner_group_id}
#
# NOTE: This module requires a rest provider configured with
#   base_url = "https://api.github.com"
# and a valid GitHub token with admin:org scope.

locals {
  body = merge(
    {
      name       = var.name
      visibility = var.visibility
    },
    var.allows_public_repositories != null ? { allows_public_repositories = var.allows_public_repositories } : {},
    var.restricted_to_workflows != null ? { restricted_to_workflows = var.restricted_to_workflows } : {},
    var.selected_workflows != null ? { selected_workflows = var.selected_workflows } : {},
    var.network_configuration_id != null ? { network_configuration_id = var.network_configuration_id } : {},
  )
}

resource "rest_resource" "runner_group" {
  path          = "/orgs/${var.organization}/actions/runner-groups"
  create_method = "POST"
  update_method = "PATCH"

  read_path   = "/orgs/${var.organization}/actions/runner-groups/$(body.id)"
  update_path = "/orgs/${var.organization}/actions/runner-groups/$(body.id)"
  delete_path = "/orgs/${var.organization}/actions/runner-groups/$(body.id)"

  body = local.body

  output_attrs = toset([
    "id",
    "name",
    "visibility",
    "network_configuration_id",
    "allows_public_repositories",
    "restricted_to_workflows",
  ])
}
