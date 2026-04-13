# Source: azure-rest-api-specs
#   spec_path  : management/resource-manager/Microsoft.Management/ManagementGroups
#   api_version: 2023-04-01
#   operation  : ManagementGroups_CreateOrUpdate (PUT, long-running — Location header)
#   delete     : ManagementGroups_Delete         (DELETE, long-running — Location header)

locals {
  api_version = "2023-04-01"
  mg_path     = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"

  details = merge(
    var.parent_id != null ? {
      parent = {
        id = var.parent_id
      }
    } : {},
  )

  properties = merge(
    var.display_name != null ? { displayName = var.display_name } : {},
    length(local.details) > 0 ? { details = local.details } : {},
  )

  body = length(local.properties) > 0 ? { properties = local.properties } : {}
}

resource "rest_resource" "management_group" {
  path            = local.mg_path
  create_method   = "PUT"
  check_existance = var.check_existance
  auth_ref        = var.auth_ref

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "name",
    "id",
    "properties.displayName",
    "properties.details.parent.id",
    "properties.tenantId",
  ])

  # Management group creation is long-running (ARM returns 202 + Location header)
  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 5
    status = {
      success = "Succeeded"
      pending = ["Accepted", "Updating"]
    }
  }

  # DELETE is also long-running — poll until 404 (resource gone)
  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 5
    status = {
      success = "404"
      pending = ["200", "202"]
    }
  }

  # Reparenting / display name changes are also long-running (ARM returns 202)
  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 5
    status = {
      success = "Succeeded"
      pending = ["Accepted", "Updating"]
    }
  }

  # management_group_id is immutable — force destroy+create if it changes
  force_new_attrs = toset(["name"])
}
