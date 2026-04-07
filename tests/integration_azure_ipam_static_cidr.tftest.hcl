# Integration test — ipam_static_cidr (plan only)
# Run: terraform test -filter=tests/integration_azure_ipam_static_cidr.tftest.hcl

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

run "plan_ipam_static_cidr" {
  command = plan

  variables {
    azure_ipam_static_cidrs = {
      test = {
        subscription_id      = var.subscription_id
        resource_group_name  = "test-rg"
        network_manager_name = "nm-test"
        pool_name            = "pool-test"
        static_cidr_name     = "hub1"
        address_prefixes     = ["10.1.0.0/24"]
        description          = "Hub 1 reservation"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_ipam_static_cidrs["test"].id == "/subscriptions/${var.subscription_id}/resourceGroups/test-rg/providers/Microsoft.Network/networkManagers/nm-test/ipamPools/pool-test/staticCidrs/hub1"
    error_message = "Static CIDR ARM ID must be correctly formed."
  }

  assert {
    condition     = output.azure_values.azure_ipam_static_cidrs["test"].name == "hub1"
    error_message = "Name output must echo input."
  }
}
