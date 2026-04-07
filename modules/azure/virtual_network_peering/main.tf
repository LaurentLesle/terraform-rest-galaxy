# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/Network
#   api_version: 2025-05-01
#   operation  : VirtualNetworkPeerings_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : VirtualNetworkPeerings_Delete          (DELETE, async)

locals {
  api_version  = "2025-05-01"
  peering_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.virtual_network_name}/virtualNetworkPeerings/${var.peering_name}"

  properties = {
    remoteVirtualNetwork = {
      id = var.remote_virtual_network_id
    }
    allowVirtualNetworkAccess = var.allow_virtual_network_access
    allowForwardedTraffic     = var.allow_forwarded_traffic
    allowGatewayTransit       = var.allow_gateway_transit
    useRemoteGateways         = var.use_remote_gateways
  }

  body = {
    properties = local.properties
  }
}

# ── Resource provider registration check ──────────────────────────────────────
data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Network"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "virtual_network_peering" {
  path            = local.peering_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.peeringState",
    "properties.peeringSyncLevel",
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
      pending = ["Updating", "Initiated"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Updating"]
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
