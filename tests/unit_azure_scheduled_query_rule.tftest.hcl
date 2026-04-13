# Unit test — modules/azure/scheduled_query_rule
# Run: terraform test -filter=tests/unit_azure_scheduled_query_rule.tftest.hcl

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

run "plan_scheduled_query_rule" {
  command = plan

  module {
    source = "./modules/azure/scheduled_query_rule"
  }

  variables {
    subscription_id      = "00000000-0000-0000-0000-000000000000"
    resource_group_name  = "test-rg"
    rule_name            = "sqr-test"
    location             = "westeurope"
    kind                 = "LogAlert"
    severity             = 1
    enabled              = true
    scopes               = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/test-law"]
    evaluation_frequency = "PT15M"
    window_size          = "PT15M"
    criteria = {
      all_of = [
        {
          query            = "requests | where success == false | count"
          time_aggregation = "Count"
          operator         = "GreaterThan"
          threshold        = 5
          failing_periods = {
            number_of_evaluation_periods = 1
            min_failing_periods_to_alert = 1
          }
        }
      ]
    }
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Insights/scheduledQueryRules/sqr-test"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "sqr-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.location == "westeurope"
    error_message = "Location output must echo input."
  }

  assert {
    condition     = output.severity == 1
    error_message = "Severity output must echo input."
  }
}
