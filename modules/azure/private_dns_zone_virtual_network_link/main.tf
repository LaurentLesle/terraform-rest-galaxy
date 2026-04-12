# Source: azure-rest-api-specs
#   spec_path  : privatedns/resource-manager/Microsoft.Network/PrivateDns
#   api_version: 2024-06-01
#   stability  : stable
#   operation  : VirtualNetworkLinks_CreateOrUpdate (PUT, long-running — location header)
#   delete     : VirtualNetworkLinks_Delete (DELETE, long-running — location header)
#
# This is a standalone module for a single virtual network link to a Private DNS Zone.
# It is distinct from the inline virtual_network_links in the private_dns_zone module
# and is designed for the galaxy pattern where links are managed independently.

locals {
  api_version = "2024-06-01"
  link_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/privateDnsZones/${var.private_dns_zone_name}/virtualNetworkLinks/${var.virtual_network_link_name}"

  body = merge(
    {
      location = "global"
      properties = merge(
        {
          virtualNetwork      = { id = var.virtual_network_id }
          registrationEnabled = var.registration_enabled
        },
        var.resolution_policy != null ? { resolutionPolicy = var.resolution_policy } : {},
      )
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "private_dns_zone_virtual_network_link" {
  path            = local.link_path
  create_method   = "PUT"
  update_method   = "PATCH"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  # location is create-only.
  write_only_attrs = toset([
    "location",
  ])

  output_attrs = toset([
    "properties.provisioningState",
    "properties.virtualNetworkLinkState",
  ])

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 15
    status = {
      success = "Succeeded"
      pending = ["Creating", "Updating", "Accepted", "InProgress"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Updating", "Accepted"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 15
    status = {
      success = "404"
      pending = ["202", "200"]
    }
  }
}
