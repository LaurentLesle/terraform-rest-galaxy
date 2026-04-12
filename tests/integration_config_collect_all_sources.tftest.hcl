# Integration test — configurations/collect_all_sources.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_collect_all_sources.tftest.hcl
#
# Validates the full collection stack configuration without deploying.
# Checks ref: resolution, variable types, and dependency graph for:
#   - resource_group, monitor_workspace, log_analytics_workspace, data_collection_endpoint
#   - 4 data_collection_rules: perf, events, syslog, custom
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

run "plan_collect_all_sources" {
  command = plan

  variables {
    config_file     = "configurations/collect_all_sources.yaml"
    subscription_id = var.subscription_id
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["all"] != null
    error_message = "Plan failed — resource group 'all' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_monitor_workspaces["all"] != null
    error_message = "Plan failed — monitor workspace 'all' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_log_analytics_workspaces["all"] != null
    error_message = "Plan failed — log analytics workspace 'all' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_endpoints["all"] != null
    error_message = "Plan failed — data collection endpoint 'all' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["perf"] != null
    error_message = "Plan failed — data collection rule 'perf' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["events"] != null
    error_message = "Plan failed — data collection rule 'events' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["syslog"] != null
    error_message = "Plan failed — data collection rule 'syslog' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["custom"] != null
    error_message = "Plan failed — data collection rule 'custom' not found in output."
  }
}
