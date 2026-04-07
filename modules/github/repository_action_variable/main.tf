# Source: GitHub REST API
#   api        : GitHub REST API v2022-11-28
#   resource   : actions/variables
#   create     : POST   /repos/{owner}/{repo}/actions/variables         (synchronous)
#   read       : GET    /repos/{owner}/{repo}/actions/variables/{name}
#   update     : PATCH  /repos/{owner}/{repo}/actions/variables/{name}
#   delete     : DELETE /repos/{owner}/{repo}/actions/variables/{name}
#
# NOTE: This module requires a rest provider configured with
#   base_url = "https://api.github.com"
# and a valid GitHub token with repo scope.

resource "rest_resource" "action_variable" {
  path          = "/repos/${var.owner}/${var.repo}/actions/variables"
  create_method = "POST"
  update_method = "PATCH"

  read_path   = "/repos/${var.owner}/${var.repo}/actions/variables/${var.name}"
  update_path = "/repos/${var.owner}/${var.repo}/actions/variables/${var.name}"
  delete_path = "/repos/${var.owner}/${var.repo}/actions/variables/${var.name}"

  body = {
    name  = var.name
    value = var.value
  }

  output_attrs = toset([
    "name",
    "value",
    "created_at",
    "updated_at",
  ])
}
