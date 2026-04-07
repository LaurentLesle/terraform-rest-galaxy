# Source: azure-rest-api-specs
#   spec_path : redisenterprise/resource-manager/Microsoft.Cache/RedisEnterprise
#   api_version: 2025-07-01
#   operation  : RedisEnterprise_Create  (PUT, async — original-uri polling)
#   update     : RedisEnterprise_Update  (PATCH, async — azure-async-operation)
#   delete     : RedisEnterprise_Delete  (DELETE, async — azure-async-operation)

locals {
  api_version  = "2025-07-01"
  cluster_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Cache/redisEnterprise/${var.cluster_name}"

  sku = merge(
    { name = var.sku_name },
    var.sku_capacity != null ? { capacity = var.sku_capacity } : {},
  )

  properties = merge(
    { minimumTlsVersion = var.minimum_tls_version },
    var.high_availability != null ? { highAvailability = var.high_availability } : {},
    var.public_network_access != null ? { publicNetworkAccess = var.public_network_access } : {},
  )

  body = merge(
    {
      location   = var.location
      sku        = local.sku
      properties = local.properties
    },
    var.zones != null ? { zones = var.zones } : {},
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "redis_enterprise_cluster" {
  path            = local.cluster_path
  create_method   = "PUT"
  update_method   = "PATCH"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  # location is create-only; exclude from PATCH updates.
  write_only_attrs = toset([
    "location",
  ])

  output_attrs = toset([
    "properties.provisioningState",
    "properties.hostName",
    "properties.minimumTlsVersion",
    "properties.publicNetworkAccess",
    "type",
  ])

  # PUT is async via original-uri polling.
  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 60
    status = {
      success = "Succeeded"
      pending = ["Creating", "Updating", "Accepted", "Provisioning", "Pending"]
    }
  }

  # PATCH is async via azure-async-operation.
  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 30
    status = {
      success = "Succeeded"
      pending = ["Updating", "Accepted", "Provisioning"]
    }
  }

  # DELETE is async via azure-async-operation; poll until 404.
  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 30
    status = {
      success = "404"
      pending = ["202", "200"]
    }
  }
}
