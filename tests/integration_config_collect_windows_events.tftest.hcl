# Integration test — configurations/collect_windows_events.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_collect_windows_events.tftest.hcl
#
# Validates the Windows Event Log collection configuration without deploying.
# Checks ref: resolution, variable types, and dependency graph for:
#   - resource_group, log_analytics_workspace
#   - data_collection_endpoint, data_collection_rule (xPathQueries per channel)
#
# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.
# Adding one causes "Provider type mismatch" errors with unit tests.

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_collect_windows_events" {
  command = plan

  variables {
    config_file     = "configurations/collect_windows_events.yaml"
    subscription_id = var.subscription_id
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["winevt"] != null
    error_message = "Plan failed — resource group 'winevt' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_log_analytics_workspaces["winevt"] != null
    error_message = "Plan failed — log analytics workspace 'winevt' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_endpoints["winevt"] != null
    error_message = "Plan failed — data collection endpoint 'winevt' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["winevt"] != null
    error_message = "Plan failed — data collection rule 'winevt' not found in output."
  }
}
