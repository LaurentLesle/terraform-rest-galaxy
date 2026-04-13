# Integration test — monitor_workspace (plan only)
# Run: terraform test -filter=tests/integration_azure_monitor_workspace.tftest.hcl
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

run "plan_monitor_workspace" {
  command = plan

  variables {
    azure_monitor_workspaces = {
      test = {
        subscription_id        = var.subscription_id
        resource_group_name    = "rg-test"
        monitor_workspace_name = "amw-test"
        location               = "westeurope"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_monitor_workspaces["test"].id != null
    error_message = "Plan failed — monitor workspace 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_monitor_workspaces["test"].name == "amw-test"
    error_message = "Plan failed — monitor workspace name must be 'amw-test'."
  }
}
