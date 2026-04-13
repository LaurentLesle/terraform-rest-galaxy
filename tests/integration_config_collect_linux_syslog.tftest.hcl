# Integration test — configurations/collect_linux_syslog.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_collect_linux_syslog.tftest.hcl
#
# Validates the Linux syslog collection configuration without deploying.
# Checks ref: resolution, variable types, and dependency graph for:
#   - resource_group, log_analytics_workspace
#   - data_collection_endpoint, data_collection_rule (per-facility log level filtering)
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

run "plan_collect_linux_syslog" {
  command = plan

  variables {
    config_file     = "configurations/collect_linux_syslog.yaml"
    subscription_id = var.subscription_id
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["syslog"] != null
    error_message = "Plan failed — resource group 'syslog' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_log_analytics_workspaces["syslog"] != null
    error_message = "Plan failed — log analytics workspace 'syslog' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_endpoints["syslog"] != null
    error_message = "Plan failed — data collection endpoint 'syslog' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["syslog"] != null
    error_message = "Plan failed — data collection rule 'syslog' not found in output."
  }
}
