# Integration test — private_dns_zone_virtual_network_link (plan only)
# Run: terraform test -filter=tests/integration_azure_private_dns_zone_virtual_network_link.tftest.hcl
#
# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "graph_access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_private_dns_zone_virtual_network_link" {
  command = plan

  variables {
    azure_private_dns_zone_virtual_network_links = {
      test = {
        subscription_id           = var.subscription_id
        resource_group_name       = "rg-test"
        private_dns_zone_name     = "privatelink.monitor.azure.com"
        virtual_network_link_name = "link-vnet-to-monitor"
        virtual_network_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet-test"
        registration_enabled      = false
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_private_dns_zone_virtual_network_links["test"].id != null
    error_message = "Plan failed — VNet link 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_private_dns_zone_virtual_network_links["test"].name == "link-vnet-to-monitor"
    error_message = "Plan failed — VNet link name must be 'link-vnet-to-monitor'."
  }
}
