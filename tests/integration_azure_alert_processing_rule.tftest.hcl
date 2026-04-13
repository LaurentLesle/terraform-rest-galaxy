# Integration test — alert_processing_rule (plan only)
# Run: terraform test -filter=tests/integration_azure_alert_processing_rule.tftest.hcl
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

run "plan_alert_processing_rule" {
  command = plan

  variables {
    azure_alert_processing_rules = {
      test = {
        subscription_id            = var.subscription_id
        resource_group_name        = "rg-test"
        alert_processing_rule_name = "apr-test"
        location                   = "westeurope"
        enabled                    = true
        scopes                     = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
        actions = [
          {
            action_type = "RemoveAllActionGroups"
          }
        ]
        description = "Test alert processing rule"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_alert_processing_rules["test"].id != null
    error_message = "Plan failed — alert processing rule 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_alert_processing_rules["test"].name == "apr-test"
    error_message = "Plan failed — alert processing rule name must be 'apr-test'."
  }

  assert {
    condition     = output.azure_values.azure_alert_processing_rules["test"].enabled == true
    error_message = "Plan failed — alert processing rule 'test' must be enabled."
  }
}
