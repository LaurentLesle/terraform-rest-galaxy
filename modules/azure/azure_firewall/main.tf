# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/azureFirewalls
#   api_version: 2025-05-01
#   operation  : AzureFirewalls_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : AzureFirewalls_Delete          (DELETE, async — long-running)

locals {
  api_version = "2025-05-01"
  fw_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/azureFirewalls/${var.firewall_name}"

  hub_ip_addresses = var.public_ip_count != null ? {
    publicIPs = {
      addresses = []
      count     = var.public_ip_count
    }
  } : null

  ip_configurations = var.ip_configurations != null ? [
    for ipc in var.ip_configurations : merge(
      { name = ipc.name },
      {
        properties = merge(
          ipc.subnet_id != null ? { subnet = { id = ipc.subnet_id } } : {},
          ipc.public_ip_address_id != null ? { publicIPAddress = { id = ipc.public_ip_address_id } } : {},
        )
      },
    )
  ] : null

  properties = merge(
    {
      sku = {
        name = var.sku_name
        tier = var.sku_tier
      }
      # Writable properties ARM returns with defaults — include to prevent drift
      additionalProperties       = var.additional_properties
      applicationRuleCollections = var.application_rule_collections
      natRuleCollections         = var.nat_rule_collections
      networkRuleCollections     = var.network_rule_collections
    },
    var.virtual_hub_id != null ? { virtualHub = { id = var.virtual_hub_id } } : {},
    var.firewall_policy_id != null ? { firewallPolicy = { id = var.firewall_policy_id } } : {},
    var.threat_intel_mode != null ? { threatIntelMode = var.threat_intel_mode } : {},
    local.hub_ip_addresses != null ? { hubIPAddresses = local.hub_ip_addresses } : {},
    local.ip_configurations != null ? { ipConfigurations = local.ip_configurations } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.zones != null ? { zones = var.zones } : {},
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "azure_firewall" {
  path            = local.fw_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.ipConfigurations",
    "properties.hubIPAddresses",
    "properties.sku",
    "properties.firewallPolicy",
    "properties.threatIntelMode",
  ])

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
      pending = ["Updating", "Provisioning", "Creating"]
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
