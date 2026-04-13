# Integration test — configurations/observability_app_monitoring.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_observability_app_monitoring.tftest.hcl
#
# Validates the app monitoring configuration YAML without deploying to Azure.
# Checks ref: resolution, variable types, and dependency graph for:
#   - resource_group, log_analytics_workspace
#   - application_insights (linked to LAW)
#   - action_group (app-team with email+webhook)
#   - diagnostic_setting (app insights -> LAW)
#   - metric_alerts (high-server-exceptions, slow-response)
#   - scheduled_query_rule (failed-dependencies)
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

run "plan_observability_app_monitoring" {
  command = plan

  variables {
    config_file     = "configurations/observability_app_monitoring.yaml"
    subscription_id = var.subscription_id
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["obs-app"] != null
    error_message = "Plan failed — resource group 'obs-app' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_application_insights["obs-app"] != null
    error_message = "Plan failed — application insights 'obs-app' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_action_groups["app-team"] != null
    error_message = "Plan failed — action group 'app-team' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_diagnostic_settings["appi-diag"] != null
    error_message = "Plan failed — diagnostic setting 'appi-diag' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_metric_alerts["high-server-exceptions"] != null
    error_message = "Plan failed — metric alert 'high-server-exceptions' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_metric_alerts["slow-response"] != null
    error_message = "Plan failed — metric alert 'slow-response' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_scheduled_query_rules["failed-dependencies"] != null
    error_message = "Plan failed — scheduled query rule 'failed-dependencies' not found in output."
  }
}
