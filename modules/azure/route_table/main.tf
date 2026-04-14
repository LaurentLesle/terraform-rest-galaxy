# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/routeTables
#   api_version: 2025-05-01
#   operation  : RouteTables_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : RouteTables_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  rt_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/routeTables/${var.route_table_name}"

  routes = var.routes != null ? [
    for r in var.routes : {
      name = r.name
      properties = merge(
        {
          addressPrefix = r.address_prefix
          nextHopType   = r.next_hop_type
        },
        r.next_hop_ip_address != null ? { nextHopIpAddress = r.next_hop_ip_address } : {},
      )
    }
  ] : null

  properties = merge(
    {},
    var.disable_bgp_route_propagation != null ? { disableBgpRoutePropagation = var.disable_bgp_route_propagation } : {},
    local.routes != null ? { routes = local.routes } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "route_table" {
  path            = local.rt_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
  ])

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = ["Succeeded"]
      pending = ["Updating", "Provisioning"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = ["Succeeded"]
      pending = ["Updating", "Provisioning"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 10
    status = {
      success = ["404"]
      pending = ["200", "202"]
    }
  }
}
