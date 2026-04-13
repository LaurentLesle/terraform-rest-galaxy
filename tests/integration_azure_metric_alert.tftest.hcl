# Integration test — metric_alert (plan only)
# Run: terraform test -filter=tests/integration_azure_metric_alert.tftest.hcl
#
# Note: uses API version 2024-03-01-preview (no stable metricAlert spec version has PUT).
#
# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.

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

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_metric_alert" {
  command = plan

  variables {
    azure_metric_alerts = {
      test = {
        subscription_id     = var.subscription_id
        resource_group_name = "rg-test"
        metric_alert_name   = "alert-test"
        severity            = 2
        enabled             = true
        scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
        evaluation_frequency = "PT5M"
        window_size          = "PT5M"
        criteria = {
          "odata.type" = "Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria"
          allOf = [
            {
              name            = "cpu-criterion"
              metricName      = "Percentage CPU"
              operator        = "GreaterThan"
              threshold       = 90
              timeAggregation = "Average"
              criterionType   = "StaticThresholdCriterion"
            }
          ]
        }
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_metric_alerts["test"].id != null
    error_message = "Plan failed — metric alert 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_metric_alerts["test"].name == "alert-test"
    error_message = "Plan failed — metric alert name must be 'alert-test'."
  }

  assert {
    condition     = output.azure_values.azure_metric_alerts["test"].severity == 2
    error_message = "Plan failed — metric alert severity must be 2."
  }
}
