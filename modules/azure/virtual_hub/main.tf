# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/virtualHubs
#   api_version: 2025-05-01
#   operation  : VirtualHubs_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : VirtualHubs_Delete          (DELETE, async — long-running)

locals {
  api_version = "2025-05-01"
  vhub_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualHubs/${var.virtual_hub_name}"

  properties = merge(
    {
      virtualWan    = { id = var.virtual_wan_id }
      addressPrefix = var.address_prefix
      sku           = var.sku
    },
    var.allow_branch_to_branch_traffic != null ? { allowBranchToBranchTraffic = var.allow_branch_to_branch_traffic } : {},
    var.hub_routing_preference != null ? { hubRoutingPreference = var.hub_routing_preference } : {},
    var.virtual_router_auto_scale_min_capacity != null ? { virtualRouterAutoScaleConfiguration = { minCapacity = var.virtual_router_auto_scale_min_capacity } } : {},
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

resource "rest_resource" "virtual_hub" {
  path            = local.vhub_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.routingState",
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
      pending = ["Updating", "Provisioning"]
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
