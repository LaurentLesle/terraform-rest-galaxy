# Integration test — network_manager (plan only)
# Run: terraform test -filter=tests/integration_azure_network_manager.tftest.hcl

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

run "plan_network_manager" {
  command = plan

  variables {
    azure_network_managers = {
      test = {
        subscription_id      = var.subscription_id
        resource_group_name  = "test-rg"
        network_manager_name = "nm-test"
        location             = "westeurope"
        scope_subscriptions  = ["/subscriptions/${var.subscription_id}"]
        scope_accesses       = ["Connectivity"]
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_network_managers["test"].id == "/subscriptions/${var.subscription_id}/resourceGroups/test-rg/providers/Microsoft.Network/networkManagers/nm-test"
    error_message = "Network Manager ARM ID must be correctly formed."
  }

  assert {
    condition     = output.azure_values.azure_network_managers["test"].name == "nm-test"
    error_message = "Name output must echo input."
  }
}
