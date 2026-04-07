# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/publicIPAddresses
#   api_version: 2025-05-01
#   operation  : PublicIPAddresses_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : PublicIPAddresses_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  pip_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/publicIPAddresses/${var.public_ip_address_name}"

  properties = merge(
    {
      publicIPAllocationMethod = var.allocation_method
    },
    var.ip_version != null ? { publicIPAddressVersion = var.ip_version } : {},
    var.idle_timeout_in_minutes != null ? { idleTimeoutInMinutes = var.idle_timeout_in_minutes } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
      sku = {
        name = var.sku_name
        tier = var.sku_tier
      }
    },
    var.zones != null ? { zones = var.zones } : {},
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

resource "rest_resource" "public_ip_address" {
  path            = local.pip_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.ipAddress",
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
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Updating", "Provisioning"]
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
