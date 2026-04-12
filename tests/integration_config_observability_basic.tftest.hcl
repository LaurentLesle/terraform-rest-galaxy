# Integration test — configurations/observability_basic.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_observability_basic.tftest.hcl
#
# Validates the configuration YAML without deploying to Azure.
# Checks ref: resolution, variable types, and dependency graph.
#
# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.
# Adding one causes "Provider type mismatch" errors with unit tests.

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

run "plan_observability_basic" {
  command = plan

  variables {
    config_file     = "configurations/observability_basic.yaml"
    subscription_id = "00000000-0000-0000-0000-000000000000"
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["obs-basic"] != null
    error_message = "Plan failed — resource group 'obs-basic' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_monitor_workspaces["obs-basic"] != null
    error_message = "Plan failed — monitor workspace 'obs-basic' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_log_analytics_workspaces["obs-basic"] != null
    error_message = "Plan failed — log analytics workspace 'obs-basic' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_endpoints["obs-basic"] != null
    error_message = "Plan failed — data collection endpoint 'obs-basic' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["obs-basic"] != null
    error_message = "Plan failed — data collection rule 'obs-basic' not found in output."
  }
}
