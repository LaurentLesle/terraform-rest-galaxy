# Source: azure-rest-api-specs
#   spec_path : dns/resource-manager/Microsoft.Network/dns
#   api_version: 2018-05-01
#   operation  : Zones_CreateOrUpdate  (PUT, synchronous)
#   delete     : Zones_Delete          (DELETE, async — 202)

locals {
  api_version = "2018-05-01"
  zone_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/dnsZones/${var.zone_name}"

  body = merge(
    {
      location = var.location
      properties = {
        zoneType = var.zone_type
      }
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

# ── Resource provider registration check ─────────────────────────────────────

data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Network"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "dns_zone" {
  path            = local.zone_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.numberOfRecordSets",
    "properties.nameServers",
    "properties.zoneType",
  ])

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.Network is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    network:\n      resource_provider_namespace: Microsoft.Network"
    }
  }

  # PUT is synchronous — no poll_create needed.

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 10
    status = {
      success = ["404"]
      pending = ["202", "200"]
    }
  }
}
