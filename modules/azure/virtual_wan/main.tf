# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/virtualWans
#   api_version: 2025-05-01
#   operation  : VirtualWans_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : VirtualWans_Delete          (DELETE, async — provisioningState polling)

locals {
  api_version = "2025-05-01"
  vwan_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualWans/${var.virtual_wan_name}"

  properties = merge(
    { type = var.type },
    var.disable_vpn_encryption != null ? { disableVpnEncryption = var.disable_vpn_encryption } : {},
    var.allow_branch_to_branch_traffic != null ? { allowBranchToBranchTraffic = var.allow_branch_to_branch_traffic } : {},
    var.allow_vnet_to_vnet_traffic != null ? { allowVnetToVnetTraffic = var.allow_vnet_to_vnet_traffic } : {},
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

resource "rest_resource" "virtual_wan" {
  path            = local.vwan_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
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
