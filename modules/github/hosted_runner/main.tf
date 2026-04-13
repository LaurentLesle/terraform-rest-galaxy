# Source: GitHub REST API
#   api        : GitHub REST API v2022-11-28
#   resource   : actions/hosted-runners
#   create     : POST   /orgs/{org}/actions/hosted-runners  (synchronous, server-assigned id)
#   read       : GET    /orgs/{org}/actions/hosted-runners/{hosted_runner_id}
#   update     : PATCH  /orgs/{org}/actions/hosted-runners/{hosted_runner_id}
#   delete     : DELETE /orgs/{org}/actions/hosted-runners/{hosted_runner_id}
#
# NOTE: This module requires a rest provider configured with
#   base_url = "https://api.github.com"
# and a valid GitHub token with manage_runners:org scope.

locals {
  body = merge(
    {
      name = var.name
      image = {
        id     = var.image_id
        source = var.image_source
      }
      size            = var.size
      runner_group_id = var.runner_group_id
    },
    var.maximum_runners != null ? { maximum_runners = var.maximum_runners } : {},
    var.enable_static_ip != null ? { enable_static_ip = var.enable_static_ip } : {},
  )
}

resource "rest_resource" "hosted_runner" {
  path          = "/orgs/${var.organization}/actions/hosted-runners"
  create_method = "POST"
  update_method = "PATCH"

  read_path   = "/orgs/${var.organization}/actions/hosted-runners/$(body.id)"
  update_path = "/orgs/${var.organization}/actions/hosted-runners/$(body.id)"
  delete_path = "/orgs/${var.organization}/actions/hosted-runners/$(body.id)"

  body = local.body

  poll_create = {
    status_locator    = "body.status"
    default_delay_sec = 30
    status = {
      success = ["Ready"]
      pending = ["Provisioning"]
    }
  }

  output_attrs = toset([
    "id",
    "name",
    "status",
    "runner_group_id",
    "platform",
    "maximum_runners",
    "public_ip_enabled",
  ])
}
