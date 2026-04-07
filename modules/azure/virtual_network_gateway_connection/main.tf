# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/connections
#   api_version: 2025-05-01
#   operation  : VirtualNetworkGatewayConnections_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : VirtualNetworkGatewayConnections_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  conn_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/connections/${var.connection_name}"

  properties = merge(
    {
      connectionType         = var.connection_type
      virtualNetworkGateway1 = { id = var.virtual_network_gateway1_id }
    },
    var.virtual_network_gateway2_id != null ? { virtualNetworkGateway2 = { id = var.virtual_network_gateway2_id } } : {},
    var.peer_id != null ? { peer = { id = var.peer_id } } : {},
    var.routing_weight != null ? { routingWeight = var.routing_weight } : {},
    var.enable_bgp != null ? { enableBgp = var.enable_bgp } : {},
    var.express_route_gateway_bypass != null ? { expressRouteGatewayBypass = var.express_route_gateway_bypass } : {},
    var.enable_private_link_fast_path != null ? { enablePrivateLinkFastPath = var.enable_private_link_fast_path } : {},
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

resource "rest_resource" "virtual_network_gateway_connection" {
  path            = local.conn_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.connectionStatus",
  ])

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.Network is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    network:\n      resource_provider_namespace: Microsoft.Network"
    }
  }

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 30
    status = {
      success = "Succeeded"
      pending = ["Updating", "Provisioning", "Creating"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 30
    status = {
      success = "Succeeded"
      pending = ["Updating", "Provisioning"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 30
    status = {
      success = "404"
      pending = ["200", "202"]
    }
  }
}
