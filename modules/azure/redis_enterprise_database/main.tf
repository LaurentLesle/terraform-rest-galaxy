# Source: azure-rest-api-specs
#   spec_path : redisenterprise/resource-manager/Microsoft.Cache/RedisEnterprise
#   api_version: 2025-07-01
#   operation  : Databases_Create  (PUT, async — original-uri polling)
#   update     : Databases_Update  (PATCH, async — azure-async-operation)
#   delete     : Databases_Delete  (DELETE, async — azure-async-operation)

locals {
  api_version = "2025-07-01"
  db_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Cache/redisEnterprise/${var.cluster_name}/databases/${var.database_name}"

  persistence = var.persistence != null ? merge(
    var.persistence.aof_enabled != null ? { aofEnabled = var.persistence.aof_enabled } : {},
    var.persistence.aof_frequency != null ? { aofFrequency = var.persistence.aof_frequency } : {},
    var.persistence.rdb_enabled != null ? { rdbEnabled = var.persistence.rdb_enabled } : {},
    var.persistence.rdb_frequency != null ? { rdbFrequency = var.persistence.rdb_frequency } : {},
  ) : null

  properties = merge(
    {
      clientProtocol   = var.client_protocol
      port             = var.port
      clusteringPolicy = var.clustering_policy
      evictionPolicy   = var.eviction_policy
    },
    var.access_keys_authentication != null ? { accessKeysAuthentication = var.access_keys_authentication } : {},
    var.modules != null ? { modules = [for m in var.modules : merge({ name = m.name }, m.args != null ? { args = m.args } : {})] } : {},
    local.persistence != null ? { persistence = local.persistence } : {},
  )

  body = {
    properties = local.properties
  }
}

resource "rest_resource" "redis_enterprise_database" {
  path            = local.db_path
  create_method   = "PUT"
  update_method   = "PATCH"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.resourceState",
    "properties.clientProtocol",
    "properties.port",
    "properties.clusteringPolicy",
    "properties.evictionPolicy",
    "type",
  ])

  # PUT is async via original-uri polling.
  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 30
    status = {
      success = "Succeeded"
      pending = ["Creating", "Updating", "Accepted", "Provisioning", "Pending"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 15
    status = {
      success = "Succeeded"
      pending = ["Updating", "Accepted", "Provisioning"]
    }
  }

  # DELETE is async; poll until 404.
  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 30
    status = {
      success = "404"
      pending = ["202", "200"]
    }
  }
}
