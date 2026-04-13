# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/expressRouteCircuits/peerings
#   api_version: 2025-05-01
#   operation  : ExpressRouteCircuitPeerings_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : ExpressRouteCircuitPeerings_Delete          (DELETE, async)

locals {
  api_version  = "2025-05-01"
  peering_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/expressRouteCircuits/${var.circuit_name}/peerings/${var.peering_name}"

  properties = merge(
    {
      peeringType = var.peering_type
      vlanId      = var.vlan_id
    },
    var.peer_asn != null ? { peerASN = var.peer_asn } : {},
    var.primary_peer_address_prefix != null ? { primaryPeerAddressPrefix = var.primary_peer_address_prefix } : {},
    var.secondary_peer_address_prefix != null ? { secondaryPeerAddressPrefix = var.secondary_peer_address_prefix } : {},
    var.shared_key != null ? { sharedKey = var.shared_key } : {},
    var.state != null ? { state = var.state } : {},
    var.azure_asn != null ? { azureASN = var.azure_asn } : {},
    var.primary_azure_port != null ? { primaryAzurePort = var.primary_azure_port } : {},
    var.secondary_azure_port != null ? { secondaryAzurePort = var.secondary_azure_port } : {},
    var.gateway_manager_etag != null ? { gatewayManagerEtag = var.gateway_manager_etag } : {},
    var.route_filter_id != null ? { routeFilter = { id = var.route_filter_id } } : {},
  )

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

resource "rest_resource" "express_route_circuit_peering" {
  path            = local.peering_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.azureASN",
    "properties.primaryAzurePort",
    "properties.secondaryAzurePort",
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
      success = ["Succeeded"]
      pending = ["Updating", "Provisioning", "Creating"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 30
    status = {
      success = ["Succeeded"]
      pending = ["Updating", "Provisioning"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 30
    status = {
      success = ["404"]
      pending = ["200", "202"]
    }
  }
}
