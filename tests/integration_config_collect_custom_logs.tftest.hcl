# Integration test — configurations/collect_custom_logs.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_collect_custom_logs.tftest.hcl
#
# Validates the custom log file and IIS log collection configuration without deploying.
# Checks ref: resolution, variable types, and dependency graph for:
#   - resource_group, log_analytics_workspace
#   - data_collection_endpoint, data_collection_rule (logFiles + iisLogs + streamDeclarations)
#
# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.
# Adding one causes "Provider type mismatch" errors with unit tests.

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

run "plan_collect_custom_logs" {
  command = plan

  variables {
    config_file     = "configurations/collect_custom_logs.yaml"
    subscription_id = "00000000-0000-0000-0000-000000000000"
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["customlogs"] != null
    error_message = "Plan failed — resource group 'customlogs' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_log_analytics_workspaces["customlogs"] != null
    error_message = "Plan failed — log analytics workspace 'customlogs' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_endpoints["customlogs"] != null
    error_message = "Plan failed — data collection endpoint 'customlogs' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["customlogs"] != null
    error_message = "Plan failed — data collection rule 'customlogs' not found in output."
  }
}
