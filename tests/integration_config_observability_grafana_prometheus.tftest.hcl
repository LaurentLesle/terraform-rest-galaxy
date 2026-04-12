# Integration test — configurations/observability_grafana_prometheus.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_observability_grafana_prometheus.tftest.hcl
#
# Validates the Grafana + Prometheus observability configuration YAML without deploying to Azure.
# Checks ref: resolution (identity → grafana → DCE → DCR → role assignments),
# variable types, and the full dependency graph.
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

run "plan_observability_grafana_prometheus" {
  command = plan

  variables {
    config_file     = "configurations/observability_grafana_prometheus.yaml"
    subscription_id = "00000000-0000-0000-0000-000000000000"
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["obs-grafana"] != null
    error_message = "Plan failed — resource group 'obs-grafana' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_monitor_workspaces["obs-grafana"] != null
    error_message = "Plan failed — monitor workspace 'obs-grafana' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_log_analytics_workspaces["obs-grafana"] != null
    error_message = "Plan failed — log analytics workspace 'obs-grafana' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_managed_grafanas["obs-grafana"] != null
    error_message = "Plan failed — managed grafana 'obs-grafana' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_endpoints["obs-grafana"] != null
    error_message = "Plan failed — data collection endpoint 'obs-grafana' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["obs-grafana"] != null
    error_message = "Plan failed — data collection rule 'obs-grafana' not found in output."
  }
}
