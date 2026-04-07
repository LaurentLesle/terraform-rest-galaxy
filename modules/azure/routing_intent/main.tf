# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/virtualHubs/routingIntent
#   api_version: 2025-05-01
#   operation  : RoutingIntent_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : RoutingIntent_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  ri_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualHubs/${var.virtual_hub_name}/routingIntent/${var.routing_intent_name}"

  routing_policies = concat(
    var.internet_traffic ? [{
      name         = "InternetTraffic"
      destinations = ["Internet"]
      nextHop      = var.firewall_id
    }] : [],
    var.private_traffic ? [{
      name         = "PrivateTrafficPolicy"
      destinations = ["PrivateTraffic"]
      nextHop      = var.firewall_id
    }] : [],
  )

  body = {
    properties = {
      routingPolicies = local.routing_policies
    }
  }
}

resource "rest_resource" "routing_intent" {
  path            = local.ri_path
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
    default_delay_sec = 15
    status = {
      success = "Succeeded"
      pending = ["Updating", "Provisioning"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 15
    status = {
      success = "Succeeded"
      pending = ["Updating", "Provisioning"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 15
    status = {
      success = "404"
      pending = ["200", "202"]
    }
  }
}
