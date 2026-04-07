# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/virtualNetworks
#   api_version: 2025-05-01
#   operation  : VirtualNetworks_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : VirtualNetworks_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  vnet_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.virtual_network_name}"

  subnets = var.subnets != null ? [
    for s in var.subnets : {
      name = s.name
      properties = merge(
        { addressPrefix = s.address_prefix },
        s.route_table_id != null ? { routeTable = { id = s.route_table_id } } : {},
        s.network_security_group_id != null ? { networkSecurityGroup = { id = s.network_security_group_id } } : {},
        s.delegations != null ? {
          delegations = [
            for d in s.delegations : {
              name       = replace(d, "/", ".")
              properties = { serviceName = d }
            }
          ]
        } : {},
        s.private_endpoint_network_policies != null ? { privateEndpointNetworkPolicies = s.private_endpoint_network_policies } : {},
      )
    }
  ] : null

  properties = merge(
    {
      addressSpace = { addressPrefixes = var.address_space }
    },
    var.dns_servers != null ? { dhcpOptions = { dnsServers = var.dns_servers } } : {},
    var.enable_ddos_protection != null ? { enableDdosProtection = var.enable_ddos_protection } : {},
    var.ddos_protection_plan_id != null ? { ddosProtectionPlan = { id = var.ddos_protection_plan_id } } : {},
    local.subnets != null ? { subnets = local.subnets } : {},
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

resource "rest_resource" "virtual_network" {
  path            = local.vnet_path
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
