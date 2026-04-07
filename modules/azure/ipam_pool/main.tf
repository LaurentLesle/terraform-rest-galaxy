# Source: azure-rest-api-specs
#   spec_path  : network/resource-manager/Microsoft.Network/networkManagers/ipamPools
#   api_version: 2025-05-01
#   operation  : IpamPools_Create  (PUT, async — Azure-AsyncOperation header)
#   delete     : IpamPools_Delete  (DELETE, async)

locals {
  api_version = "2025-05-01"
  pool_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/networkManagers/${var.network_manager_name}/ipamPools/${var.pool_name}"

  properties = merge(
    { addressPrefixes = var.address_prefixes },
    var.description != null ? { description = var.description } : {},
    var.display_name != null ? { displayName = var.display_name } : {},
    var.parent_pool_name != null ? { parentPoolName = var.parent_pool_name } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

# ── Resource provider registration check ──────────────────────────────────────
data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Network"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "ipam_pool" {
  path            = local.pool_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
  ])

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.Network is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    network:\n      resource_provider_namespace: Microsoft.Network"
    }
  }

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Creating", "Updating"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Creating", "Updating"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 10
    status = {
      success = "404"
      pending = ["200", "202"]
    }
  }
}
