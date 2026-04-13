# Integration test — log_analytics_workspace (plan only)
# Run: terraform test -filter=tests/integration_azure_log_analytics_workspace.tftest.hcl
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

run "plan_log_analytics_workspace" {
  command = plan

  variables {
    azure_log_analytics_workspaces = {
      test = {
        subscription_id     = var.subscription_id
        resource_group_name = "rg-test"
        workspace_name      = "law-test"
        location            = "westeurope"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_log_analytics_workspaces["test"].id != null
    error_message = "Plan failed — log analytics workspace 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_log_analytics_workspaces["test"].name == "law-test"
    error_message = "Plan failed — log analytics workspace name must be 'law-test'."
  }
}
