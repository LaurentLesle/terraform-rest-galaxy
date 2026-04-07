# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/privateEndpoints
#   api_version: 2025-05-01
#   operation  : PrivateEndpoints_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : PrivateEndpoints_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  pe_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/privateEndpoints/${var.private_endpoint_name}"

  private_link_service_connections = var.private_link_service_connections != null ? [
    for c in var.private_link_service_connections : {
      name = c.name
      properties = merge(
        { privateLinkServiceId = c.private_link_service_id },
        c.group_ids != null ? { groupIds = c.group_ids } : {},
        c.request_message != null ? { requestMessage = c.request_message } : {},
      )
    }
  ] : null

  manual_private_link_service_connections = var.manual_private_link_service_connections != null ? [
    for c in var.manual_private_link_service_connections : {
      name = c.name
      properties = merge(
        { privateLinkServiceId = c.private_link_service_id },
        c.group_ids != null ? { groupIds = c.group_ids } : {},
        c.request_message != null ? { requestMessage = c.request_message } : {},
      )
    }
  ] : null

  ip_configurations = var.ip_configurations != null ? [
    for ipc in var.ip_configurations : {
      name = ipc.name
      properties = merge(
        { privateIPAddress = ipc.private_ip_address },
        ipc.group_id != null ? { groupId = ipc.group_id } : {},
        ipc.member_name != null ? { memberName = ipc.member_name } : {},
      )
    }
  ] : null

  properties = merge(
    {
      subnet = { id = var.subnet_id }
    },
    var.custom_network_interface_name != null ? { customNetworkInterfaceName = var.custom_network_interface_name } : {},
    local.private_link_service_connections != null ? { privateLinkServiceConnections = local.private_link_service_connections } : {},
    local.manual_private_link_service_connections != null ? { manualPrivateLinkServiceConnections = local.manual_private_link_service_connections } : {},
    local.ip_configurations != null ? { ipConfigurations = local.ip_configurations } : {},
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

resource "rest_resource" "private_endpoint" {
  path            = local.pe_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.networkInterfaces",
    "properties.customDnsConfigs",
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
      pending = ["Updating", "Provisioning", "Creating"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Updating", "Provisioning"]
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

# ── DNS Zone Group (auto-register A records) ─────────────────────────────────
resource "rest_resource" "dns_zone_group" {
  count = var.private_dns_zone_group != null ? 1 : 0

  path          = "${local.pe_path}/privateDnsZoneGroups/${var.private_dns_zone_group.name}"
  create_method = "PUT"

  query = {
    api-version = [local.api_version]
  }

  body = {
    properties = {
      privateDnsZoneConfigs = [
        for i, zone_id in var.private_dns_zone_group.private_dns_zone_ids : {
          name = "zone${i}"
          properties = {
            privateDnsZoneId = zone_id
          }
        }
      ]
    }
  }

  output_attrs = toset([
    "properties.provisioningState",
  ])

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Updating", "Creating"]
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

  depends_on = [rest_resource.private_endpoint]
}
