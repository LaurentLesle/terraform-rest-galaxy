# Unit test — modules/azure/metric_alert
# Run: terraform test -filter=tests/unit_azure_metric_alert.tftest.hcl
#
# Note: uses API version 2024-03-01-preview (no stable metricAlert spec version has PUT).

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = "placeholder"
      }
    }
  }
}

run "plan_metric_alert" {
  command = plan

  module {
    source = "./modules/azure/metric_alert"
  }

  variables {
    subscription_id      = "00000000-0000-0000-0000-000000000000"
    resource_group_name  = "test-rg"
    metric_alert_name    = "alert-test"
    severity             = 2
    enabled              = true
    scopes               = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
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

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Insights/metricAlerts/alert-test"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "alert-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.severity == 2
    error_message = "Severity output must echo input."
  }

  assert {
    condition     = output.enabled == true
    error_message = "Enabled output must echo input."
  }
}
