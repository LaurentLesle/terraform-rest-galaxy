# Source: azure-rest-api-specs
#   spec_path : postgresql/resource-manager/Microsoft.DBforPostgreSQL
#   api_version: 2025-08-01
#   operation  : AdministratorsMicrosoftEntra_CreateOrUpdate  (PUT, async — LRO)
#   delete     : AdministratorsMicrosoftEntra_Delete          (DELETE, async — location)

locals {
  api_version = "2025-08-01"
  admin_path  = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.DBforPostgreSQL/flexibleServers/${var.server_name}/administrators/${var.object_id}"

  body = {
    properties = {
      principalType = var.principal_type
      principalName = var.principal_name
      tenantId      = var.tenant_id
    }
  }
}

resource "rest_resource" "administrator" {
  path            = local.admin_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.objectId",
    "properties.principalType",
    "properties.principalName",
    "properties.tenantId",
  ])

  poll_create = {
    status_locator    = "body.properties.objectId"
    default_delay_sec = 15
    status = {
      success = [var.object_id]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 15
    status = {
      success = ["404"]
      pending = ["200", "202", "400"]
    }
  }
}
