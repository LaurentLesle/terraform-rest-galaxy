# Integration test — configurations/collect_perf_metrics.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_collect_perf_metrics.tftest.hcl
#
# Validates the performance counter collection configuration without deploying.
# Checks ref: resolution, variable types, and dependency graph for:
#   - resource_group, monitor_workspace, log_analytics_workspace
#   - data_collection_endpoint, data_collection_rule (multi-frequency perf counters)
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

run "plan_collect_perf_metrics" {
  command = plan

  variables {
    config_file     = "configurations/collect_perf_metrics.yaml"
    subscription_id = var.subscription_id
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["perf"] != null
    error_message = "Plan failed — resource group 'perf' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_monitor_workspaces["perf"] != null
    error_message = "Plan failed — monitor workspace 'perf' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_log_analytics_workspaces["perf"] != null
    error_message = "Plan failed — log analytics workspace 'perf' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_endpoints["perf"] != null
    error_message = "Plan failed — data collection endpoint 'perf' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["perf"] != null
    error_message = "Plan failed — data collection rule 'perf' not found in output."
  }
}
