# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/expressRouteCircuits
#   api_version: 2025-05-01
#   operation  : ExpressRouteCircuits_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : ExpressRouteCircuits_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  erc_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/expressRouteCircuits/${var.circuit_name}"

  sku_name = "${var.sku_tier}_${var.sku_family}"

  properties = merge(
    {},
    var.bandwidth_in_gbps != null ? { bandwidthInGbps = var.bandwidth_in_gbps } : {},
    var.bandwidth_in_mbps != null ? { bandwidthInMbps = var.bandwidth_in_mbps } : {},
    var.express_route_port_id != null ? { expressRoutePort = { id = var.express_route_port_id } } : {},
    var.service_provider_name != null ? {
      serviceProviderProperties = {
        serviceProviderName = var.service_provider_name
        peeringLocation     = var.peering_location
        bandwidthInMbps     = var.bandwidth_in_mbps
      }
    } : {},
    var.allow_classic_operations != null ? { allowClassicOperations = var.allow_classic_operations } : {},
    var.global_reach_enabled != null ? { globalReachEnabled = var.global_reach_enabled } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
      sku = {
        name   = local.sku_name
        tier   = var.sku_tier
        family = var.sku_family
      }
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

resource "rest_resource" "express_route_circuit" {
  path            = local.erc_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.serviceKey",
    "properties.provisioningState",
    "properties.serviceProviderProvisioningState",
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
