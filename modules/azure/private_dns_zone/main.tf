# Source: azure-rest-api-specs
#   spec_path : privatedns/resource-manager/Microsoft.Network/PrivateDns
#   api_version: 2024-06-01
#   operation  : PrivateZones_CreateOrUpdate               (PUT, async — Location header)
#   delete     : PrivateZones_Delete                       (DELETE, async — Location header)
#   child      : VirtualNetworkLinks_CreateOrUpdate         (PUT, async — Location header)
#   child_del  : VirtualNetworkLinks_Delete                 (DELETE, async — Location header)

locals {
  api_version = "2024-06-01"
  zone_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/privateDnsZones/${var.zone_name}"

  zone_body = merge(
    { location = "global" },
    var.tags != null ? { tags = var.tags } : {},
  )

  # Build a map of VNet links keyed by name for for_each.
  vnet_links = { for link in var.virtual_network_links : link.name => link }
}

resource "rest_resource" "private_dns_zone" {
  path            = local.zone_path
  create_method   = "PUT"
  update_method   = "PATCH"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.zone_body

  # location is create-only.
  write_only_attrs = toset([
    "location",
  ])

  output_attrs = toset([
    "properties.provisioningState",
    "type",
  ])

  # PUT is async via Location header polling.
  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 15
    status = {
      success = "Succeeded"
      pending = ["Creating", "Updating", "Accepted"]
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

# ── Virtual Network Links ─────────────────────────────────────────────────────

resource "rest_resource" "virtual_network_link" {
  for_each = local.vnet_links

  path            = "${local.zone_path}/virtualNetworkLinks/${each.key}"
  create_method   = "PUT"
  update_method   = "PATCH"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = merge(
    {
      location = "global"
      properties = merge(
        {
          virtualNetwork      = { id = each.value.virtual_network_id }
          registrationEnabled = each.value.registration_enabled
        },
        each.value.resolution_policy != null ? { resolutionPolicy = each.value.resolution_policy } : {},
      )
    },
    each.value.tags != null ? { tags = each.value.tags } : {},
  )

  write_only_attrs = toset([
    "location",
  ])

  output_attrs = toset([
    "properties.provisioningState",
    "properties.virtualNetworkLinkState",
    "type",
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

  depends_on = [rest_resource.private_dns_zone]
}
