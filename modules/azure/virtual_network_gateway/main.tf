# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/virtualNetworkGateways
#   api_version: 2025-05-01
#   operation  : VirtualNetworkGateways_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : VirtualNetworkGateways_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  vngw_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworkGateways/${var.gateway_name}"

  ip_configurations = var.ip_configurations != null ? [
    for ipc in var.ip_configurations : {
      name = ipc.name
      properties = merge(
        { privateIPAllocationMethod = "Dynamic" },
        ipc.subnet_id != null ? { subnet = { id = ipc.subnet_id } } : {},
        ipc.public_ip_address_id != null ? { publicIPAddress = { id = ipc.public_ip_address_id } } : {},
      )
    }
  ] : null

  # VPN client configuration for P2S
  vpn_client_configuration = var.vpn_client_configuration != null ? merge(
    {
      vpnClientAddressPool = {
        addressPrefixes = var.vpn_client_configuration.address_prefixes
      }
    },
    var.vpn_client_configuration.vpn_client_protocols != null ? { vpnClientProtocols = var.vpn_client_configuration.vpn_client_protocols } : {},
    var.vpn_client_configuration.vpn_authentication_types != null ? { vpnAuthenticationTypes = var.vpn_client_configuration.vpn_authentication_types } : {},
    var.vpn_client_configuration.aad_tenant != null ? { aadTenant = var.vpn_client_configuration.aad_tenant } : {},
    var.vpn_client_configuration.aad_audience != null ? { aadAudience = var.vpn_client_configuration.aad_audience } : {},
    var.vpn_client_configuration.aad_issuer != null ? { aadIssuer = var.vpn_client_configuration.aad_issuer } : {},
    var.vpn_client_configuration.radius_server_address != null ? { radiusServerAddress = var.vpn_client_configuration.radius_server_address } : {},
    var.vpn_client_configuration.radius_server_secret != null ? { radiusServerSecret = var.vpn_client_configuration.radius_server_secret } : {},
  ) : null

  properties = merge(
    {
      gatewayType = var.gateway_type
      sku = {
        name = var.sku_name
        tier = var.sku_tier
      }
    },
    var.vpn_type != null ? { vpnType = var.vpn_type } : {},
    var.vpn_gateway_generation != null ? { vpnGatewayGeneration = var.vpn_gateway_generation } : {},
    var.enable_bgp != null ? { enableBgp = var.enable_bgp } : {},
    var.active_active != null ? { activeActive = var.active_active } : {},
    var.enable_private_ip_address != null ? { enablePrivateIpAddress = var.enable_private_ip_address } : {},
    var.admin_state != null ? { adminState = var.admin_state } : {},
    local.ip_configurations != null ? { ipConfigurations = local.ip_configurations } : {},
    local.vpn_client_configuration != null ? { vpnClientConfiguration = local.vpn_client_configuration } : {},
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

resource "rest_resource" "virtual_network_gateway" {
  path            = local.vngw_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.bgpSettings",
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
      success = ["Succeeded"]
      pending = ["Updating", "Provisioning", "Creating"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 30
    status = {
      success = ["Succeeded"]
      pending = ["Updating", "Provisioning"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 30
    status = {
      success = ["404"]
      pending = ["200", "202"]
    }
  }
}
