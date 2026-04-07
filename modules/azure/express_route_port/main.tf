# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/expressRoutePorts
#   api_version: 2025-05-01
#   operation  : ExpressRoutePorts_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : ExpressRoutePorts_Delete          (DELETE, async — long-running)

locals {
  api_version = "2025-05-01"
  erp_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/ExpressRoutePorts/${var.port_name}"

  properties = merge(
    {
      peeringLocation = var.peering_location
      bandwidthInGbps = var.bandwidth_in_gbps
      encapsulation   = var.encapsulation
    },
    var.billing_type != null ? { billingType = var.billing_type } : {},
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

resource "rest_resource" "express_route_port" {
  path            = local.erp_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.etherType",
    "properties.mtu",
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
