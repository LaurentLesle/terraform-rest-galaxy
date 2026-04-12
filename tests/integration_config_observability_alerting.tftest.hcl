# Integration test — configurations/observability_alerting.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_observability_alerting.tftest.hcl
#
# Validates the alerting configuration YAML without deploying to Azure.
# Checks ref: resolution, variable types, and dependency graph for:
#   - resource_group, log_analytics_workspace
#   - action_groups (ops-team with email+SMS, critical with webhook+ARM role)
#   - metric_alert, scheduled_query_rule, activity_log_alert, alert_processing_rule
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

run "plan_observability_alerting" {
  command = plan

  variables {
    config_file     = "configurations/observability_alerting.yaml"
    subscription_id = var.subscription_id
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["obs-alerting"] != null
    error_message = "Plan failed — resource group 'obs-alerting' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_action_groups["ops-team"] != null
    error_message = "Plan failed — action group 'ops-team' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_action_groups["critical"] != null
    error_message = "Plan failed — action group 'critical' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_metric_alerts["high-cpu"] != null
    error_message = "Plan failed — metric alert 'high-cpu' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_scheduled_query_rules["failed-requests"] != null
    error_message = "Plan failed — scheduled query rule 'failed-requests' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_activity_log_alerts["resource-deleted"] != null
    error_message = "Plan failed — activity log alert 'resource-deleted' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_alert_processing_rules["maintenance-window"] != null
    error_message = "Plan failed — alert processing rule 'maintenance-window' not found in output."
  }
}
