# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/virtualHubs/hubVirtualNetworkConnections
#   api_version: 2025-05-01
#   operation  : HubVirtualNetworkConnections_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : HubVirtualNetworkConnections_Delete          (DELETE, async — long-running)

locals {
  api_version = "2025-05-01"
  hvnc_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualHubs/${var.virtual_hub_name}/hubVirtualNetworkConnections/${var.connection_name}"

  properties = merge(
    {
      remoteVirtualNetwork = { id = var.remote_virtual_network_id }
    },
    var.enable_internet_security != null ? { enableInternetSecurity = var.enable_internet_security } : {},
    var.allow_hub_to_remote_vnet_transit != null ? { allowHubToRemoteVnetTransit = var.allow_hub_to_remote_vnet_transit } : {},
    var.allow_remote_vnet_to_use_hub_vnet_gateways != null ? { allowRemoteVnetToUseHubVnetGateways = var.allow_remote_vnet_to_use_hub_vnet_gateways } : {},
  )

  body = {
    properties = local.properties
  }
}

# ── Resource provider registration check ──────────────────────────────────────
data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Network"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "virtual_hub_connection" {
  path            = local.hvnc_path
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
