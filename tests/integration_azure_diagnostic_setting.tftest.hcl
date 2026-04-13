# Integration test — diagnostic_setting (plan only)
# Run: terraform test -filter=tests/integration_azure_diagnostic_setting.tftest.hcl
#
# Diagnostic settings are scope-based: the path is relative to a target resource's ARM ID.
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

run "plan_diagnostic_setting" {
  command = plan

  variables {
    azure_diagnostic_settings = {
      test = {
        resource_id                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.OperationalInsights/workspaces/law-test"
        diagnostic_setting_name    = "diag-test"
        log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.OperationalInsights/workspaces/law-test"
        logs = [
          {
            category_group = "allLogs"
            enabled        = true
          }
        ]
        metrics = [
          {
            category = "AllMetrics"
            enabled  = true
          }
        ]
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_diagnostic_settings["test"].id != null
    error_message = "Plan failed — diagnostic setting 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_diagnostic_settings["test"].name == "diag-test"
    error_message = "Plan failed — diagnostic setting name must be 'diag-test'."
  }
}
