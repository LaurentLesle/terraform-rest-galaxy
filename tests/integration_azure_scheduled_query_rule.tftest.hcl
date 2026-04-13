# Integration test — scheduled_query_rule (plan only)
# Run: terraform test -filter=tests/integration_azure_scheduled_query_rule.tftest.hcl
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

run "plan_scheduled_query_rule" {
  command = plan

  variables {
    azure_scheduled_query_rules = {
      test = {
        subscription_id      = var.subscription_id
        resource_group_name  = "rg-test"
        rule_name            = "sqr-test"
        location             = "westeurope"
        kind                 = "LogAlert"
        severity             = 1
        enabled              = true
        scopes               = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.OperationalInsights/workspaces/law-test"]
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
    }
  }

  assert {
    condition     = output.azure_values.azure_scheduled_query_rules["test"].id != null
    error_message = "Plan failed — scheduled query rule 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_scheduled_query_rules["test"].name == "sqr-test"
    error_message = "Plan failed — scheduled query rule name must be 'sqr-test'."
  }

  assert {
    condition     = output.azure_values.azure_scheduled_query_rules["test"].severity == 1
    error_message = "Plan failed — scheduled query rule severity must be 1."
  }
}
