# Integration test — activity_log_alert (plan only)
# Run: terraform test -filter=tests/integration_azure_activity_log_alert.tftest.hcl
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

run "plan_activity_log_alert" {
  command = plan

  variables {
    azure_activity_log_alerts = {
      test = {
        subscription_id         = var.subscription_id
        resource_group_name     = "rg-test"
        activity_log_alert_name = "ala-test"
        location                = "global"
        enabled                 = true
        scopes                  = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
        condition = {
          all_of = [
            {
              field  = "category"
              equals = "Administrative"
            },
            {
              field  = "operationName"
              equals = "Microsoft.Resources/deployments/delete"
            }
          ]
        }
        actions = {
          action_groups = [
            {
              action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Insights/actionGroups/ag-test"
            }
          ]
        }
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_activity_log_alerts["test"].id != null
    error_message = "Plan failed — activity log alert 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_activity_log_alerts["test"].name == "ala-test"
    error_message = "Plan failed — activity log alert name must be 'ala-test'."
  }

  assert {
    condition     = output.azure_values.azure_activity_log_alerts["test"].enabled == true
    error_message = "Plan failed — activity log alert 'test' must be enabled."
  }
}
