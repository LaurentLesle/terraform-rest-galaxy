# Source: azure-rest-api-specs
#   spec_path  : network/resource-manager/Microsoft.Network/networkManagers
#   api_version: 2025-05-01
#   operation  : NetworkManagers_CreateOrUpdate  (PUT, synchronous)
#   delete     : NetworkManagers_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  nm_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/networkManagers/${var.network_manager_name}"

  network_manager_scopes = merge(
    var.scope_subscriptions != null ? { subscriptions = var.scope_subscriptions } : {},
    var.scope_management_groups != null ? { managementGroups = var.scope_management_groups } : {},
  )

  properties = merge(
    { networkManagerScopes = local.network_manager_scopes },
    var.description != null ? { description = var.description } : {},
    var.scope_accesses != null ? { networkManagerScopeAccesses = var.scope_accesses } : {},
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

resource "rest_resource" "network_manager" {
  path            = local.nm_path
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

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 10
    status = {
      success = "404"
      pending = ["200", "202"]
    }
  }
}
