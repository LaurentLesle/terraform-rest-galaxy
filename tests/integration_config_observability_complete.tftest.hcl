# Integration test — configurations/observability_complete.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_observability_complete.tftest.hcl
#
# Validates the complete observability configuration YAML without deploying to Azure.
# Checks ref: resolution, variable types, and dependency graph for all resources:
#   - resource_group, monitor_workspace, log_analytics_workspace
#   - user_assigned_identity, managed_grafana
#   - data_collection_endpoint, data_collection_rule
#   - application_insights
#   - action_groups (platform-team, sre-team)
#   - metric_alerts (high-cpu, high-memory)
#   - scheduled_query_rule (error-rate)
#   - activity_log_alert (resource-deletion)
#   - alert_processing_rule (business-hours-suppression)
#   - diagnostic_settings (law-diagnostics, grafana-diagnostics)
#
# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.
# Adding one causes "Provider type mismatch" errors with unit tests.

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

run "plan_observability_complete" {
  command = plan

  variables {
    config_file     = "configurations/observability_complete.yaml"
    subscription_id = "00000000-0000-0000-0000-000000000000"
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["obs-complete"] != null
    error_message = "Plan failed — resource group 'obs-complete' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_application_insights["obs-complete"] != null
    error_message = "Plan failed — application insights 'obs-complete' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_action_groups["platform-team"] != null
    error_message = "Plan failed — action group 'platform-team' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_action_groups["sre-team"] != null
    error_message = "Plan failed — action group 'sre-team' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_metric_alerts["high-cpu"] != null
    error_message = "Plan failed — metric alert 'high-cpu' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_metric_alerts["high-memory"] != null
    error_message = "Plan failed — metric alert 'high-memory' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_scheduled_query_rules["error-rate"] != null
    error_message = "Plan failed — scheduled query rule 'error-rate' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_activity_log_alerts["resource-deletion"] != null
    error_message = "Plan failed — activity log alert 'resource-deletion' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_alert_processing_rules["business-hours-suppression"] != null
    error_message = "Plan failed — alert processing rule 'business-hours-suppression' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_diagnostic_settings["law-diagnostics"] != null
    error_message = "Plan failed — diagnostic setting 'law-diagnostics' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_diagnostic_settings["grafana-diagnostics"] != null
    error_message = "Plan failed — diagnostic setting 'grafana-diagnostics' not found in output."
  }
}
