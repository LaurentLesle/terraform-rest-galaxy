# Integration test — application_insights (plan only)
# Run: terraform test -filter=tests/integration_azure_application_insights.tftest.hcl
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

run "plan_application_insights" {
  command = plan

  variables {
    azure_application_insights = {
      test = {
        subscription_id           = var.subscription_id
        resource_group_name       = "rg-test"
        application_insights_name = "appi-test"
        location                  = "westeurope"
        kind                      = "web"
        application_type          = "web"
        workspace_resource_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.OperationalInsights/workspaces/law-test"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_application_insights["test"].id != null
    error_message = "Plan failed — application insights 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_application_insights["test"].name == "appi-test"
    error_message = "Plan failed — application insights name must be 'appi-test'."
  }

  assert {
    condition     = output.azure_values.azure_application_insights["test"].location == "westeurope"
    error_message = "Plan failed — application insights location must be 'westeurope'."
  }
}
