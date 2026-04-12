# Integration test — monitor_private_link_scope (plan only)
# Run: terraform test -filter=tests/integration_azure_monitor_private_link_scope.tftest.hcl
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

run "plan_monitor_private_link_scope" {
  command = plan

  variables {
    azure_monitor_private_link_scopes = {
      test = {
        subscription_id       = var.subscription_id
        resource_group_name   = "rg-test"
        scope_name            = "ampls-test"
        location              = "westeurope"
        ingestion_access_mode = "PrivateOnly"
        query_access_mode     = "PrivateOnly"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_monitor_private_link_scopes["test"].id != null
    error_message = "Plan failed — AMPLS 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_monitor_private_link_scopes["test"].name == "ampls-test"
    error_message = "Plan failed — AMPLS name must be 'ampls-test'."
  }

  assert {
    condition     = output.azure_values.azure_monitor_private_link_scopes["test"].location == "westeurope"
    error_message = "Plan failed — AMPLS location must be 'westeurope'."
  }
}
