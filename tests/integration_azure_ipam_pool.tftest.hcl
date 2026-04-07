# Integration test — ipam_pool (plan only)
# Run: terraform test -filter=tests/integration_azure_ipam_pool.tftest.hcl

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

run "plan_ipam_pool" {
  command = plan

  variables {
    azure_ipam_pools = {
      test = {
        subscription_id      = var.subscription_id
        resource_group_name  = "test-rg"
        network_manager_name = "nm-test"
        pool_name            = "pool-test"
        location             = "westeurope"
        address_prefixes     = ["10.0.0.0/8"]
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_ipam_pools["test"].id == "/subscriptions/${var.subscription_id}/resourceGroups/test-rg/providers/Microsoft.Network/networkManagers/nm-test/ipamPools/pool-test"
    error_message = "IPAM Pool ARM ID must be correctly formed."
  }

  assert {
    condition     = output.azure_values.azure_ipam_pools["test"].name == "pool-test"
    error_message = "Name output must echo input."
  }
}
