# Integration test — configurations/notify_teams.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_notify_teams.tftest.hcl
#
# Validates the Teams notification configuration YAML without deploying to Azure.
# Checks ref: resolution, variable types, and dependency graph for:
#   - resource_group, log_analytics_workspace
#   - action_groups (critical → Teams Incoming Webhook, warning + info → Power Automate)
#   - metric_alerts (high-cpu-critical @ sev0, high-cpu-warning @ sev2)
#   - scheduled_query_rules (failed-auth, app-errors)
#   - activity_log_alerts (resource-deleted, policy-denied)
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

run "plan_notify_teams" {
  command = plan

  variables {
    config_file     = "configurations/notify_teams.yaml"
    subscription_id = var.subscription_id
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["notify"] != null
    error_message = "Plan failed — resource group 'notify' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_log_analytics_workspaces["notify"] != null
    error_message = "Plan failed — log analytics workspace 'notify' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_action_groups["critical"] != null
    error_message = "Plan failed — action group 'critical' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_action_groups["warning"] != null
    error_message = "Plan failed — action group 'warning' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_action_groups["info"] != null
    error_message = "Plan failed — action group 'info' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_metric_alerts["high-cpu-critical"] != null
    error_message = "Plan failed — metric alert 'high-cpu-critical' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_metric_alerts["high-cpu-warning"] != null
    error_message = "Plan failed — metric alert 'high-cpu-warning' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_scheduled_query_rules["failed-auth"] != null
    error_message = "Plan failed — scheduled query rule 'failed-auth' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_scheduled_query_rules["app-errors"] != null
    error_message = "Plan failed — scheduled query rule 'app-errors' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_activity_log_alerts["resource-deleted"] != null
    error_message = "Plan failed — activity log alert 'resource-deleted' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_activity_log_alerts["policy-denied"] != null
    error_message = "Plan failed — activity log alert 'policy-denied' not found in output."
  }
}
