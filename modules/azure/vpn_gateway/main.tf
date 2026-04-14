# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/vpnGateways
#   api_version: 2025-05-01
#   operation  : VpnGateways_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : VpnGateways_Delete          (DELETE, async — long-running)

locals {
  api_version = "2025-05-01"
  vpngw_path  = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/vpnGateways/${var.gateway_name}"

  properties = merge(
    {
      virtualHub = { id = var.virtual_hub_id }
    },
    var.vpn_gateway_scale_unit != null ? { vpnGatewayScaleUnit = var.vpn_gateway_scale_unit } : {},
    var.enable_bgp_route_translation_for_nat != null ? { enableBgpRouteTranslationForNat = var.enable_bgp_route_translation_for_nat } : {},
    var.is_routing_preference_internet != null ? { isRoutingPreferenceInternet = var.is_routing_preference_internet } : {},
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

resource "rest_resource" "vpn_gateway" {
  path            = local.vpngw_path
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
