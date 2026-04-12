# Unit test — modules/azure/private_dns_zone_virtual_network_link
# Run: terraform test -filter=tests/unit_azure_private_dns_zone_virtual_network_link.tftest.hcl
#
# Tests plan-time-known outputs only (id, name).
# API version: 2024-06-01 (stable).

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = "placeholder"
      }
    }
  }
}

run "plan_private_dns_zone_virtual_network_link" {
  command = plan

  module {
    source = "./modules/azure/private_dns_zone_virtual_network_link"
  }

  variables {
    subscription_id           = "00000000-0000-0000-0000-000000000000"
    resource_group_name       = "test-rg"
    private_dns_zone_name     = "privatelink.monitor.azure.com"
    virtual_network_link_name = "link-vnet-to-monitor"
    virtual_network_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/vnet-test"
    registration_enabled      = false
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/privateDnsZones/privatelink.monitor.azure.com/virtualNetworkLinks/link-vnet-to-monitor"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "link-vnet-to-monitor"
    error_message = "Name output must echo input."
  }
}
